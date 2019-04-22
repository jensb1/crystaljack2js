require "./tools"
require "./libjack2_c"

module Jack2
  VERSION = "0.1.0"

  class Client
    PORT_OUTPUT = Jack2_c::JackPortFlags::JackPortIsOutput

    def initialize
      status = Jack2_c::JackStatus::JackFailure
      @client = Jack2_c.jack_client_open("testclient", Jack2_c::JackOptions::JackNullOption, pointerof(status)) ||
                raise "could not create client"
      r = Jack2_c.jack_activate(@client)
      raise "could not activate: #{r}" if r != 0
    end

    def finalize
      Jack2_c.jack_client_close(@client) if @client
    end

    def register_port(name, port_type = PORT_OUTPUT)
      Jack2_c.jack_port_register(@client, name,
        Jack2_c::JACK_DEFAULT_AUDIO_TYPE,
        port_type,
        0) || raise "could not register port"
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
