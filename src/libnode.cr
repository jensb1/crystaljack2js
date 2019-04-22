require "./libjack2"
require "./libnode_c"

module Node
  class Jack2
    VERSION = "0.1.0"

    def self.setup
      module_register_callback = ->(env : Node_c::NapiEnv, exports : Node_c::NapiValue) {
        # Avoid closure
        exported_method = ->(env : Node_c::NapiEnv, callback : Node_c::NapiCallbackInfo) {
          client = ::Jack2::Client.new
          client.register_port("out", ::Jack2::Client::PORT_OUTPUT)
          puts client.ports

          world = uninitialized Node_c::NapiValue
        }

        desc = Node_c::NapiPropertyDescriptor.new
        desc.utf8name = "hello"
        desc.name = Pointer(Void).null
        desc.method = exported_method
        desc.getter = Pointer(Void).null
        desc.setter = Pointer(Void).null
        desc.value = Pointer(Void).null
        desc.attributes = Node_c::NapiPropertyAttributes::NapiDefault
        desc.data = Pointer(Void).null
        status = Node_c.napi_define_properties(env, exports, 1, pointerof(desc))

        exports
      }

      m = Pointer(Node_c::NapiModule).malloc(1)
      m.value.nm_version = 1
      m.value.nm_flags = 0
      m.value.nm_filename = "main.cr"
      m.value.nm_register_func = module_register_callback
      m.value.nm_modname = "NODE_GYP_MODULE_NAME"
      m.value.nm_priv = Pointer(Void).null

      Node_c.napi_module_register(m)
    end
  end
end
