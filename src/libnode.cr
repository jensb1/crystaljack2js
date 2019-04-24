require "./libjack2"
require "./libnode_c"

macro register_fn(name, fn)
	desc = Node_c::NapiPropertyDescriptor.new
    desc.utf8name = "setup"
    desc.name = Pointer(Void).null
    desc.method = {{fn}}
    desc.getter = Pointer(Void).null
    desc.setter = Pointer(Void).null
    desc.value = Pointer(Void).null
    desc.attributes = Node_c::NapiPropertyAttributes::NapiDefault
    desc.data = Pointer(Void).null
    status = Node_c.napi_define_properties(env, exports, 1, pointerof(desc))
end

macro napi_string(str)
  %pv = uninitialized Node_c::NapiValue
  Node_c.napi_create_string_utf8(env, {{str}}, {{str}}.size, pointerof(%pv))
  %pv
end

macro napi_array(from_arr)
	%from_arr = {{from_arr}}
	%arr = uninitialized Node_c::NapiValue
  	Node_c.napi_create_array_with_length(env, %from_arr.size, pointerof(%arr))
  	%from_arr.each_with_index do |e, i|
  		if e.class == String
  			Node_c.napi_set_element(env, %arr, i, napi_string(e))
  		else
  			raise "invalid type for napi_array"
  		end
  	end
  	%arr
end

macro napi_throw(msg)
	%err_msg = uninitialized Node_c::NapiValue
	Node_c.napi_create_string_utf8(env, {{msg}}, LibC::SizeT::MAX, pointerof(%err_msg))
	Node_c.napi_throw(env, %err_msg)
end

macro napi_typeof(what)
	%t = uninitialized Node_c::NapiValuetype
	status = Node_c.napi_typeof(env, {{what}}, pointerof(%t))
	%t
end

macro napi_lasterror
    %error = Node_c::NapiExtendedErrorInfo.new
    %error_ptr = pointerof(%error)
    Node_c.napi_get_last_error_info(env, pointerof(%error_ptr))
	%error.error_message.null? ? nil : String.new(%error.error_message)
end

macro assert_napiok(call)
	%status = {{call}}
	raise(%({{call}} failed: {status})) if %status != Node_c::NapiStatus::NapiOk
end

# https://github.com/nodejs/abi-stable-node-addon-examples
module Node
  class Jack2
    VERSION = "0.1.0"

    @@module = Node_c::NapiModule.new

    def self.setup
      module_register_callback = ->(env : Node_c::NapiEnv, exports : Node_c::NapiValue) {
        # Avoid closure
        register_fn("setup", ->(env : Node_c::NapiEnv, info : Node_c::NapiCallbackInfo) {
          begin
            client = ::Jack2::Client.new
            client.register_port("out1", ::Jack2::Client::PORT_OUTPUT)
            client.register_port("out2", ::Jack2::Client::PORT_OUTPUT)

            # Get arguments
            argc = 1_u64
            callback_fn = uninitialized Node_c::NapiValue
            assert_napiok(Node_c.napi_get_cb_info(env, info, pointerof(argc), pointerof(callback_fn), nil, nil))
            raise "invalid arg, expected function" unless napi_typeof(callback_fn) == Node_c::NapiValuetype::NapiFunction

            threadsafe_function = uninitialized Node_c::NapiThreadsafeFunction
            assert_napiok(Node_c.napi_create_threadsafe_function(env, callback_fn,
              nil, napi_string("callback for jack2 process"), 20, 1, nil, nil, nil, nil, pointerof(threadsafe_function)))

            # Callback definition
            client.register_process_callback do |nframe, out1, out2|
              assert_napiok(Node_c.napi_acquire_threadsafe_function(threadsafe_function))
              assert_napiok(Node_c.napi_call_threadsafe_function(threadsafe_function, nil,
                Node_c::NapiThreadsafeFunctionCallMode::NapiTsfnBlocking))
              assert_napiok(Node_c.napi_release_threadsafe_function(threadsafe_function,
                Node_c::NapiThreadsafeFunctionReleaseMode::NapiTsfnRelease))
            end
            client.activate
            client.connect("testclient:out1", "Live:in1")
            client.connect("testclient:out2", "Live:in2")
            puts client.ports

            ports = client.ports

            return napi_array(ports)
          rescue e
            napi_throw("Exception from Crystal: #{e.to_s}")
          end
          return napi_array([] of String)
        })

        exports
      }

      @@module = Node_c::NapiModule.new
      @@module.nm_version = 1
      @@module.nm_flags = 0
      @@module.nm_filename = "main.cr"
      @@module.nm_register_func = module_register_callback
      @@module.nm_modname = "crystaljack2js"
      @@module.nm_priv = Pointer(Void).null

      Node_c.napi_module_register(pointerof(@@module))
    end
  end
end
