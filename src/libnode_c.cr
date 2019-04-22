# @[Link("node")]
lib Node_c
  # SRC_JS_NATIVE_API_TYPES_H_ =
  alias Char16T = LibC::Int
  type NapiEnv = Void*
  type NapiValue = Void*

  type NapiRef = Void*
  type NapiHandleScope = Void*
  type NapiEscapableHandleScope = Void*
  type NapiCallbackInfo = Void*
  type NapiDeferred = Void*
  enum NapiPropertyAttributes : LibC::UInt
    NapiDefault      =    0
    NapiWritable     =    1
    NapiEnumerable   =    2
    NapiConfigurable =    4
    NapiStatic       = 1024
  end
  enum NapiValuetype : LibC::UInt
    NapiUndefined = 0
    NapiNull      = 1
    NapiBoolean   = 2
    NapiNumber    = 3
    NapiString    = 4
    NapiSymbol    = 5
    NapiObject    = 6
    NapiFunction  = 7
    NapiExternal  = 8
    NapiBigint    = 9
  end
  enum NapiTypedarrayType : LibC::UInt
    NapiInt8Array         =  0
    NapiUint8Array        =  1
    NapiUint8ClampedArray =  2
    NapiInt16Array        =  3
    NapiUint16Array       =  4
    NapiInt32Array        =  5
    NapiUint32Array       =  6
    NapiFloat32Array      =  7
    NapiFloat64Array      =  8
    NapiBigint64Array     =  9
    NapiBiguint64Array    = 10
  end
  enum NapiStatus : LibC::UInt
    NapiOk                    =  0
    NapiInvalidArg            =  1
    NapiObjectExpected        =  2
    NapiStringExpected        =  3
    NapiNameExpected          =  4
    NapiFunctionExpected      =  5
    NapiNumberExpected        =  6
    NapiBooleanExpected       =  7
    NapiArrayExpected         =  8
    NapiGenericFailure        =  9
    NapiPendingException      = 10
    NapiCancelled             = 11
    NapiEscapeCalledTwice     = 12
    NapiHandleScopeMismatch   = 13
    NapiCallbackScopeMismatch = 14
    NapiQueueFull             = 15
    NapiClosing               = 16
    NapiBigintExpected        = 17
    NapiDateExpected          = 18
  end
  alias NapiCallback = (NapiEnv, NapiCallbackInfo) -> NapiValue
  alias NapiFinalize = (NapiEnv, Void*, Void*) -> Void

  struct NapiPropertyDescriptor
    utf8name : UInt8*
    name : Void*
    method : NapiCallback
    getter : Void*
    setter : Void*
    value : Void*
    attributes : NapiPropertyAttributes
    data : Void*
  end

  struct NapiExtendedErrorInfo
    error_message : UInt8*
    engine_reserved : Void*
    engine_error_code : LibC::Int
    error_code : NapiStatus
  end

  fun napi_get_last_error_info(NapiEnv, NapiExtendedErrorInfo**) : NapiStatus
  fun napi_get_undefined(NapiEnv, NapiValue*) : NapiStatus
  fun napi_get_null(NapiEnv, NapiValue*) : NapiStatus
  fun napi_get_global(NapiEnv, NapiValue*) : NapiStatus
  fun napi_get_boolean(NapiEnv, Bool, NapiValue*) : NapiStatus
  fun napi_create_object(NapiEnv, NapiValue*) : NapiStatus
  fun napi_create_array(NapiEnv, NapiValue*) : NapiStatus
  fun napi_create_array_with_length(NapiEnv, LibC::SizeT, NapiValue*) : NapiStatus
  fun napi_create_double(NapiEnv, LibC::Double, NapiValue*) : NapiStatus
  fun napi_create_int32(NapiEnv, LibC::Int, NapiValue*) : NapiStatus
  fun napi_create_uint32(NapiEnv, LibC::Int, NapiValue*) : NapiStatus
  fun napi_create_int64(NapiEnv, LibC::Int, NapiValue*) : NapiStatus
  fun napi_create_string_latin1(NapiEnv, UInt8*, LibC::SizeT, NapiValue*) : NapiStatus
  fun napi_create_string_utf8(NapiEnv, UInt8*, LibC::SizeT, NapiValue*) : NapiStatus
  fun napi_create_string_utf16(NapiEnv, Char16T*, LibC::SizeT, NapiValue*) : NapiStatus
  fun napi_create_symbol(NapiEnv, NapiValue, NapiValue*) : NapiStatus
  fun napi_create_function(NapiEnv, UInt8*, LibC::SizeT, NapiCallback, Void*, NapiValue*) : NapiStatus
  fun napi_create_error(NapiEnv, NapiValue, NapiValue, NapiValue*) : NapiStatus
  fun napi_create_type_error(NapiEnv, NapiValue, NapiValue, NapiValue*) : NapiStatus
  fun napi_create_range_error(NapiEnv, NapiValue, NapiValue, NapiValue*) : NapiStatus
  fun napi_typeof(NapiEnv, NapiValue, NapiValuetype*) : NapiStatus
  fun napi_get_value_double(NapiEnv, NapiValue, LibC::Double*) : NapiStatus
  fun napi_get_value_int32(NapiEnv, NapiValue, LibC::Int*) : NapiStatus
  fun napi_get_value_uint32(NapiEnv, NapiValue, LibC::Int*) : NapiStatus
  fun napi_get_value_int64(NapiEnv, NapiValue, LibC::Int*) : NapiStatus
  fun napi_get_value_bool(NapiEnv, NapiValue, Bool*) : NapiStatus
  fun napi_get_value_string_latin1(NapiEnv, NapiValue, UInt8*, LibC::SizeT, LibC::SizeT*) : NapiStatus
  fun napi_get_value_string_utf8(NapiEnv, NapiValue, UInt8*, LibC::SizeT, LibC::SizeT*) : NapiStatus
  fun napi_get_value_string_utf16(NapiEnv, NapiValue, Char16T*, LibC::SizeT, LibC::SizeT*) : NapiStatus
  fun napi_coerce_to_bool(NapiEnv, NapiValue, NapiValue*) : NapiStatus
  fun napi_coerce_to_number(NapiEnv, NapiValue, NapiValue*) : NapiStatus
  fun napi_coerce_to_object(NapiEnv, NapiValue, NapiValue*) : NapiStatus
  fun napi_coerce_to_string(NapiEnv, NapiValue, NapiValue*) : NapiStatus
  fun napi_get_prototype(NapiEnv, NapiValue, NapiValue*) : NapiStatus
  fun napi_get_property_names(NapiEnv, NapiValue, NapiValue*) : NapiStatus
  fun napi_set_property(NapiEnv, NapiValue, NapiValue, NapiValue) : NapiStatus
  fun napi_has_property(NapiEnv, NapiValue, NapiValue, Bool*) : NapiStatus
  fun napi_get_property(NapiEnv, NapiValue, NapiValue, NapiValue*) : NapiStatus
  fun napi_delete_property(NapiEnv, NapiValue, NapiValue, Bool*) : NapiStatus
  fun napi_has_own_property(NapiEnv, NapiValue, NapiValue, Bool*) : NapiStatus
  fun napi_set_named_property(NapiEnv, NapiValue, UInt8*, NapiValue) : NapiStatus
  fun napi_has_named_property(NapiEnv, NapiValue, UInt8*, Bool*) : NapiStatus
  fun napi_get_named_property(NapiEnv, NapiValue, UInt8*, NapiValue*) : NapiStatus
  fun napi_set_element(NapiEnv, NapiValue, LibC::Int, NapiValue) : NapiStatus
  fun napi_has_element(NapiEnv, NapiValue, LibC::Int, Bool*) : NapiStatus
  fun napi_get_element(NapiEnv, NapiValue, LibC::Int, NapiValue*) : NapiStatus
  fun napi_delete_element(NapiEnv, NapiValue, LibC::Int, Bool*) : NapiStatus
  fun napi_define_properties(NapiEnv, NapiValue, LibC::SizeT, NapiPropertyDescriptor*) : NapiStatus
  fun napi_is_array(NapiEnv, NapiValue, Bool*) : NapiStatus
  fun napi_get_array_length(NapiEnv, NapiValue, LibC::Int*) : NapiStatus
  fun napi_strict_equals(NapiEnv, NapiValue, NapiValue, Bool*) : NapiStatus
  fun napi_call_function(NapiEnv, NapiValue, NapiValue, LibC::SizeT, NapiValue*, NapiValue*) : NapiStatus
  fun napi_new_instance(NapiEnv, NapiValue, LibC::SizeT, NapiValue*, NapiValue*) : NapiStatus
  fun napi_instanceof(NapiEnv, NapiValue, NapiValue, Bool*) : NapiStatus
  fun napi_get_cb_info(NapiEnv, NapiCallbackInfo, LibC::SizeT*, NapiValue*, NapiValue*, Void**) : NapiStatus
  fun napi_get_new_target(NapiEnv, NapiCallbackInfo, NapiValue*) : NapiStatus
  fun napi_define_class(NapiEnv, UInt8*, LibC::SizeT, NapiCallback, Void*, LibC::SizeT, NapiPropertyDescriptor*, NapiValue*) : NapiStatus
  fun napi_wrap(NapiEnv, NapiValue, Void*, NapiFinalize, Void*, NapiRef*) : NapiStatus
  fun napi_unwrap(NapiEnv, NapiValue, Void**) : NapiStatus
  fun napi_remove_wrap(NapiEnv, NapiValue, Void**) : NapiStatus
  fun napi_create_external(NapiEnv, Void*, NapiFinalize, Void*, NapiValue*) : NapiStatus
  fun napi_get_value_external(NapiEnv, NapiValue, Void**) : NapiStatus
  fun napi_create_reference(NapiEnv, NapiValue, LibC::Int, NapiRef*) : NapiStatus
  fun napi_delete_reference(NapiEnv, NapiRef) : NapiStatus
  fun napi_reference_ref(NapiEnv, NapiRef, LibC::Int*) : NapiStatus
  fun napi_reference_unref(NapiEnv, NapiRef, LibC::Int*) : NapiStatus
  fun napi_get_reference_value(NapiEnv, NapiRef, NapiValue*) : NapiStatus
  fun napi_open_handle_scope(NapiEnv, NapiHandleScope*) : NapiStatus
  fun napi_close_handle_scope(NapiEnv, NapiHandleScope) : NapiStatus
  fun napi_open_escapable_handle_scope(NapiEnv, NapiEscapableHandleScope*) : NapiStatus
  fun napi_close_escapable_handle_scope(NapiEnv, NapiEscapableHandleScope) : NapiStatus
  fun napi_escape_handle(NapiEnv, NapiEscapableHandleScope, NapiValue, NapiValue*) : NapiStatus
  fun napi_throw(NapiEnv, NapiValue) : NapiStatus
  fun napi_throw_error(NapiEnv, UInt8*, UInt8*) : NapiStatus
  fun napi_throw_type_error(NapiEnv, UInt8*, UInt8*) : NapiStatus
  fun napi_throw_range_error(NapiEnv, UInt8*, UInt8*) : NapiStatus
  fun napi_is_error(NapiEnv, NapiValue, Bool*) : NapiStatus
  fun napi_is_exception_pending(NapiEnv, Bool*) : NapiStatus
  fun napi_get_and_clear_last_exception(NapiEnv, NapiValue*) : NapiStatus
  fun napi_is_arraybuffer(NapiEnv, NapiValue, Bool*) : NapiStatus
  fun napi_create_arraybuffer(NapiEnv, LibC::SizeT, Void**, NapiValue*) : NapiStatus
  fun napi_create_external_arraybuffer(NapiEnv, Void*, LibC::SizeT, NapiFinalize, Void*, NapiValue*) : NapiStatus
  fun napi_get_arraybuffer_info(NapiEnv, NapiValue, Void**, LibC::SizeT*) : NapiStatus
  fun napi_is_typedarray(NapiEnv, NapiValue, Bool*) : NapiStatus
  fun napi_create_typedarray(NapiEnv, NapiTypedarrayType, LibC::SizeT, NapiValue, LibC::SizeT, NapiValue*) : NapiStatus
  fun napi_get_typedarray_info(NapiEnv, NapiValue, NapiTypedarrayType*, LibC::SizeT*, Void**, NapiValue*, LibC::SizeT*) : NapiStatus
  fun napi_create_dataview(NapiEnv, LibC::SizeT, NapiValue, LibC::SizeT, NapiValue*) : NapiStatus
  fun napi_is_dataview(NapiEnv, NapiValue, Bool*) : NapiStatus
  fun napi_get_dataview_info(NapiEnv, NapiValue, LibC::SizeT*, Void**, NapiValue*, LibC::SizeT*) : NapiStatus
  fun napi_get_version(NapiEnv, LibC::Int*) : NapiStatus
  fun napi_create_promise(NapiEnv, NapiDeferred*, NapiValue*) : NapiStatus
  fun napi_resolve_deferred(NapiEnv, NapiDeferred, NapiValue) : NapiStatus
  fun napi_reject_deferred(NapiEnv, NapiDeferred, NapiValue) : NapiStatus
  fun napi_is_promise(NapiEnv, NapiValue, Bool*) : NapiStatus
  fun napi_run_script(NapiEnv, NapiValue, NapiValue*) : NapiStatus
  fun napi_adjust_external_memory(NapiEnv, LibC::Int, LibC::Int*) : NapiStatus

  type NapiCallbackScope = Void*

  type NapiAsyncContext = Void*

  type NapiAsyncWork = Void*

  alias NapiAsyncExecuteCallback = (NapiEnv, Void*) -> Void
  alias NapiAsyncCompleteCallback = (NapiEnv, NapiStatus, Void*) -> Void

  struct NapiNodeVersion
    major : LibC::Int
    minor : LibC::Int
    patch : LibC::Int
    release : UInt8*
  end

  type UvLoopS = Void
  alias NapiAddonRegisterFunc = (NapiEnv, NapiValue) -> NapiValue

  struct NapiModule
    nm_version : LibC::Int
    nm_flags : LibC::UInt
    nm_filename : UInt8*
    nm_register_func : NapiAddonRegisterFunc
    nm_modname : UInt8*
    nm_priv : Void*
    reserved : StaticArray(Void*, 4)
  end

  fun napi_module_register(NapiModule*) : Void
  fun napi_fatal_error(UInt8*, LibC::SizeT, UInt8*, LibC::SizeT) : Void
  fun napi_async_init(NapiEnv, NapiValue, NapiValue, NapiAsyncContext*) : NapiStatus
  fun napi_async_destroy(NapiEnv, NapiAsyncContext) : NapiStatus
  fun napi_make_callback(NapiEnv, NapiAsyncContext, NapiValue, NapiValue, LibC::SizeT, NapiValue*, NapiValue*) : NapiStatus
  fun napi_create_buffer(NapiEnv, LibC::SizeT, Void**, NapiValue*) : NapiStatus
  fun napi_create_external_buffer(NapiEnv, LibC::SizeT, Void*, NapiFinalize, Void*, NapiValue*) : NapiStatus
  fun napi_create_buffer_copy(NapiEnv, LibC::SizeT, Void*, Void**, NapiValue*) : NapiStatus
  fun napi_is_buffer(NapiEnv, NapiValue, Bool*) : NapiStatus
  fun napi_get_buffer_info(NapiEnv, NapiValue, Void**, LibC::SizeT*) : NapiStatus
  fun napi_create_async_work(NapiEnv, NapiValue, NapiValue, NapiAsyncExecuteCallback, NapiAsyncCompleteCallback, Void*, NapiAsyncWork*) : NapiStatus
  fun napi_delete_async_work(NapiEnv, NapiAsyncWork) : NapiStatus
  fun napi_queue_async_work(NapiEnv, NapiAsyncWork) : NapiStatus
  fun napi_cancel_async_work(NapiEnv, NapiAsyncWork) : NapiStatus
  fun napi_get_node_version(NapiEnv, NapiNodeVersion**) : NapiStatus
  fun napi_get_uv_event_loop(NapiEnv, UvLoopS**) : NapiStatus
  fun napi_fatal_exception(NapiEnv, NapiValue) : NapiStatus
  fun napi_add_env_cleanup_hook(NapiEnv, (Void*) -> Void*, Void*) : NapiStatus
  fun napi_remove_env_cleanup_hook(NapiEnv, (Void*) -> Void*, Void*) : NapiStatus
  fun napi_open_callback_scope(NapiEnv, NapiValue, NapiAsyncContext, NapiCallbackScope*) : NapiStatus
  fun napi_close_callback_scope(NapiEnv, NapiCallbackScope) : NapiStatus
  #  fun napi_create_threadsafe_function(NapiEnv, NapiValue, NapiValue, NapiValue, LibC::SizeT, LibC::SizeT, Void*, NapiFinalize, Void*, NapiThreadsafeFunctionCallJs, NapiThreadsafeFunction*) : NapiStatus
  # fun napi_get_threadsafe_function_context(NapiThreadsafeFunction, Void**) : NapiStatus
  # fun napi_call_threadsafe_function(NapiThreadsafeFunction, Void*, NapiThreadsafeFunctionCallMode) : NapiStatus
  # fun napi_acquire_threadsafe_function(NapiThreadsafeFunction) : NapiStatus
  # fun napi_release_threadsafe_function(NapiThreadsafeFunction, NapiThreadsafeFunctionReleaseMode) : NapiStatus
  # fun napi_unref_threadsafe_function(NapiEnv, NapiThreadsafeFunction) : NapiStatus
  # fun napi_ref_threadsafe_function(NapiEnv, NapiThreadsafeFunction) : NapiStatus
end
