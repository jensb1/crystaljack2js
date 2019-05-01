require "./tools"
require "./libjack2_c"

module Jack2
  VERSION = "0.1.0"

  class OutputFrame
    getter :nframes, :out1, :out2, :time
    setter :nframes, :out1, :out2, :time

    def initialize(@time : Int32 = 0, @nframes : Int32 = 0, @out1 : Float32* = Pointer(Float32).null, @out2 : Float32* = Pointer(Float32).null)
    end
  end

  class Client
    PORT_OUTPUT = Jack2_c::JackPortFlags::JackPortIsOutput

    @@closure_callback : Pointer(Void)?
    @ports = {} of String => Jack2_c::JackPort*
    @@frame = OutputFrame.new

    def initialize
      status = Jack2_c::JackStatus::JackFailure
      @client = Jack2_c.jack_client_open("testclient", Jack2_c::JackOptions::JackNullOption, pointerof(status)) ||
                raise "could not create client"
    end

    def activate
      r = Jack2_c.jack_activate(@client)
      raise "could not activate: #{r}" if r != 0
    end

    def finalize
      puts "finalizing jack2_c"
      Jack2_c.jack_client_close(@client) if @client
    end

    def register_port(name, port_type = PORT_OUTPUT)
      port = Jack2_c.jack_port_register(@client, name,
        Jack2_c::JACK_DEFAULT_AUDIO_TYPE,
        port_type,
        0) || raise "could not register port"
      puts "registered port: #{port}"
      @ports[name] = port
    end

    def connect(p1, p2)
      case Jack2_c.jack_connect(@client, p1, p2)
      when 0
      else
        raise "Failed to connect port"
      end
    end

    def register_process_callback(&block : (OutputFrame -> Void))
      closure = ->(nframes : Jack2_c::JackNframesT, data : Void*) {
        puts "time from crystal: #{@@frame.time}"
        @@frame.nframes = nframes
        @@frame.time = @@frame.time + nframes
        @@frame.out1 = Jack2_c.jack_port_get_buffer(@ports["out1"], nframes).as(Float32*)
        @@frame.out2 = Jack2_c.jack_port_get_buffer(@ports["out2"], nframes).as(Float32*)

        block.call(@@frame)
      }

      # Make sure garbagem collector is not running
      # on the boxed closure
      @@closure_callback = Box.box(closure)

      Jack2_c.jack_set_process_callback(@client, ->(nframes : Jack2_c::JackNframesT, data : Void*) {
        # Make sure GC is not running within another thread
        GC.disable
        begin
          callback = Box(typeof(closure)).unbox(data)
          callback.call(nframes, data)
        rescue e
          puts "Exception within process callback: #{e}"
          return 1
        ensure
          GC.enable
        end
        0
      }, @@closure_callback)
    end

    def client_name
      String.new(Jack2_c.jack_get_client_name(@client))
    end

    def ports
      ports_c = Jack2_c.jack_get_ports(@client, "", "", 0)
      ports = ports_c.map_ptr_not_null { |a| String.new(a) }
      Jack2_c.jack_free(ports_c)
      ports
    end
  end
end
