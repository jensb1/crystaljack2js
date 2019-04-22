@[Link("jack")]
lib Jack2_c
  NBBY    = __DARWIN_NBBY
  NFDBITS = __DARWIN_NFDBITS
  # howmany =  x, y) __DARWIN_howmany( x, y
  JACK_MAX_FRAMES         = UInt.new(4294967295)
  JACK_LOAD_INIT_LIMIT    = 1024
  JackOpenOptions         = JackSessionID | JackServerName | JackNoStartServer | JackUseExactName
  JackLoadOptions         = JackLoadInit | JackLoadName | JackUseExactName
  JACK_DEFAULT_AUDIO_TYPE = "32 bit float mono audio"
  JACK_DEFAULT_MIDI_TYPE  = "8 bit raw midi"
  JACK_POSITION_MASK      = JackPositionBBT | JackPositionTimecode
  # EXTENDED_TIME_INFO =
  alias RegisterT = Int64
  alias UserAddrT = UInt64
  alias UserSizeT = UInt64
  alias UserSsizeT = Int64
  alias UserLongT = Int64
  alias UserUlongT = UInt64
  alias UserTimeT = Int64
  alias UserOffT = Int64
  alias SyscallArgT = UInt64
  alias Ushort = LibC::Short
  alias UInt = LibC::UInt
  alias Uint = UInt
  alias UQuadT = UInt64
  alias QuadT = Int64
  alias QaddrT = QuadT*
  alias DaddrT = Int32
  alias FixptT = UInt32
  alias SegszT = Int32
  alias SwblkT = Int32
  alias FdMask = LibC::Int
  alias JackUuidT = LibC::Int
  alias JackShmsizeT = Int32
  alias JackNframesT = LibC::Int
  alias JackTimeT = LibC::Int
  alias JackIntclientT = LibC::Int
  type JackPort = Void
  type JackClient = Void
  alias JackPortIdT = LibC::Int
  alias JackPortTypeIdT = LibC::Int
  enum JackOptions : Uint
    JackNullOption    =  0
    JackNoStartServer =  1
    JackUseExactName  =  2
    JackServerName    =  4
    JackLoadName      =  8
    JackLoadInit      = 16
    JackSessionID     = 32
  end
  enum JackStatus : UInt
    JackFailure       =    1
    JackInvalidOption =    2
    JackNameNotUnique =    4
    JackServerStarted =    8
    JackServerFailed  =   16
    JackServerError   =   32
    JackNoSuchClient  =   64
    JackLoadFailure   =  128
    JackInitFailure   =  256
    JackShmFailure    =  512
    JackVersionError  = 1024
    JackBackendError  = 2048
    JackClientZombie  = 4096
  end
  enum JackLatencyCallbackMode : UInt
    JackCaptureLatency  = 0
    JackPlaybackLatency = 1
  end
  alias JackLatencyCallback = (JackLatencyCallbackMode, Void*) -> Void

  struct JackLatencyRange
    # WARNING: unexpected PackedAttr within StructDecl (visit_struct)
    min : JackNframesT
    max : JackNframesT
  end

  alias JackProcessCallback = (JackNframesT, Void*) -> Void
  alias JackThreadCallback = (Void*) -> Void**
  alias JackThreadInitCallback = (Void*) -> Void*
  alias JackGraphOrderCallback = (Void*) -> LibC::Int*
  alias JackXRunCallback = (Void*) -> LibC::Int*
  alias JackBufferSizeCallback = (JackNframesT, Void*) -> Void
  alias JackSampleRateCallback = (JackNframesT, Void*) -> Void
  alias JackPortRegistrationCallback = (JackPortIdT, LibC::Int, Void*) -> Void
  alias JackClientRegistrationCallback = (UInt8*, LibC::Int, Void*) -> Void
  alias JackPortConnectCallback = (JackPortIdT, JackPortIdT, LibC::Int, Void*) -> Void
  alias JackPortRenameCallback = (JackPortIdT, UInt8*, UInt8*, Void*) -> Void
  alias JackFreewheelCallback = (LibC::Int, Void*) -> Void
  alias JackShutdownCallback = (Void*) -> Void*
  alias JackInfoShutdownCallback = (JackStatus, UInt8*, Void*) -> Void
  alias JackDefaultAudioSampleT = Float
  enum JackPortFlags : UInt
    JackPortIsInput    =  1
    JackPortIsOutput   =  2
    JackPortIsPhysical =  4
    JackPortCanMonitor =  8
    JackPortIsTerminal = 16
  end
  enum JackTransportStateT : UInt
    JackTransportStopped     = 0
    JackTransportRolling     = 1
    JackTransportLooping     = 2
    JackTransportStarting    = 3
    JackTransportNetStarting = 4
  end
  alias JackUniqueT = LibC::Int
  enum JackPositionBitsT : UInt
    JackPositionBBT      =  16
    JackPositionTimecode =  32
    JackBBTFrameOffset   =  64
    JackAudioVideoRatio  = 128
    JackVideoFrameOffset = 256
  end

  struct JackPosition
    # WARNING: unexpected PackedAttr within StructDecl (visit_struct)
    unique_1 : JackUniqueT
    usecs : JackTimeT
    frame_rate : JackNframesT
    frame : JackNframesT
    valid : JackPositionBitsT
    bar : LibC::Int32T
    beat : LibC::Int32T
    tick : LibC::Int32T
    bar_start_tick : LibC::Double
    beats_per_bar : LibC::Float
    beat_type : LibC::Float
    ticks_per_beat : LibC::Double
    beats_per_minute : LibC::Double
    frame_time : LibC::Double
    next_time : LibC::Double
    bbt_offset : JackNframesT
    audio_frames_per_video_frame : LibC::Float
    video_offset : JackNframesT
    padding : StaticArray(LibC::Int32T, 7)
    unique_2 : JackUniqueT
  end

  alias JackSyncCallback = (JackTransportStateT, JackPosition*, Void*) -> Void
  alias JackTimebaseCallback = (JackTransportStateT, JackNframesT, JackPosition*, LibC::Int, Void*) -> Void
  enum JackTransportBitsT : UInt
    JackTransportState    =  1
    JackTransportPosition =  2
    JackTransportLoop     =  4
    JackTransportSMPTE    =  8
    JackTransportBBT      = 16
  end

  struct JackTransportInfoT
    frame_rate : JackNframesT
    usecs : JackTimeT
    valid : JackTransportBitsT
    transport_state : JackTransportStateT
    frame : JackNframesT
    loop_start : JackNframesT
    loop_end : JackNframesT
    smpte_offset : LibC::Long
    smpte_frame_rate : LibC::Float
    bar : LibC::Int
    beat : LibC::Int
    tick : LibC::Int
    bar_start_tick : LibC::Double
    beats_per_bar : LibC::Float
    beat_type : LibC::Float
    ticks_per_beat : LibC::Double
    beats_per_minute : LibC::Double
  end

  fun jack_get_version(LibC::Int*, LibC::Int*, LibC::Int*, LibC::Int*) : Void
  fun jack_get_version_string : UInt8*
  fun jack_client_open(UInt8*, JackOptions, JackStatus*) : JackClient*
  fun jack_client_new(UInt8*) : JackClient*
  fun jack_client_close(JackClient*) : LibC::Int
  fun jack_client_name_size : LibC::Int
  fun jack_get_client_name(JackClient*) : UInt8*
  fun jack_get_uuid_for_client_name(JackClient*, UInt8*) : UInt8*
  fun jack_get_client_name_by_uuid(JackClient*, UInt8*) : UInt8*
  fun jack_internal_client_new(UInt8*, UInt8*, UInt8*) : LibC::Int
  fun jack_internal_client_close(UInt8*) : Void
  fun jack_activate(JackClient*) : LibC::Int
  fun jack_deactivate(JackClient*) : LibC::Int
  fun jack_get_client_pid(UInt8*) : LibC::Int
  fun jack_client_thread_id(JackClient*) : LibC::Int
  fun jack_is_realtime(JackClient*) : LibC::Int
  fun jack_thread_wait(JackClient*, LibC::Int) : JackNframesT
  fun jack_cycle_wait(JackClient*) : JackNframesT
  fun jack_cycle_signal(JackClient*, LibC::Int) : Void
  fun jack_set_process_thread(JackClient*, JackThreadCallback, Void*) : LibC::Int
  fun jack_set_thread_init_callback(JackClient*, JackThreadInitCallback, Void*) : LibC::Int
  fun jack_on_shutdown(JackClient*, JackShutdownCallback, Void*) : Void
  fun jack_on_info_shutdown(JackClient*, JackInfoShutdownCallback, Void*) : Void
  fun jack_set_process_callback(JackClient*, JackProcessCallback, Void*) : LibC::Int
  fun jack_set_freewheel_callback(JackClient*, JackFreewheelCallback, Void*) : LibC::Int
  fun jack_set_buffer_size_callback(JackClient*, JackBufferSizeCallback, Void*) : LibC::Int
  fun jack_set_sample_rate_callback(JackClient*, JackSampleRateCallback, Void*) : LibC::Int
  fun jack_set_client_registration_callback(JackClient*, JackClientRegistrationCallback, Void*) : LibC::Int
  fun jack_set_port_registration_callback(JackClient*, JackPortRegistrationCallback, Void*) : LibC::Int
  fun jack_set_port_connect_callback(JackClient*, JackPortConnectCallback, Void*) : LibC::Int
  fun jack_set_port_rename_callback(JackClient*, JackPortRenameCallback, Void*) : LibC::Int
  fun jack_set_graph_order_callback(JackClient*, JackGraphOrderCallback, Void*) : LibC::Int
  fun jack_set_xrun_callback(JackClient*, JackXRunCallback, Void*) : LibC::Int
  fun jack_set_latency_callback(JackClient*, JackLatencyCallback, Void*) : LibC::Int
  fun jack_set_freewheel(JackClient*, LibC::Int) : LibC::Int
  fun jack_set_buffer_size(JackClient*, JackNframesT) : LibC::Int
  fun jack_get_sample_rate(JackClient*) : JackNframesT
  fun jack_get_buffer_size(JackClient*) : JackNframesT
  fun jack_engine_takeover_timebase(JackClient*) : LibC::Int
  fun jack_cpu_load(JackClient*) : LibC::Float
  fun jack_port_register(JackClient*, UInt8*, UInt8*, LibC::ULong, LibC::ULong) : JackPort*
  fun jack_port_unregister(JackClient*, JackPort*) : LibC::Int
  fun jack_port_get_buffer(JackPort*, JackNframesT) : Void*
  fun jack_port_uuid(JackPort*) : JackUuidT
  fun jack_port_name(JackPort*) : UInt8*
  fun jack_port_short_name(JackPort*) : UInt8*
  fun jack_port_flags(JackPort*) : LibC::Int
  fun jack_port_type(JackPort*) : UInt8*
  fun jack_port_type_id(JackPort*) : JackPortTypeIdT
  fun jack_port_is_mine(JackClient*, JackPort*) : LibC::Int
  fun jack_port_connected(JackPort*) : LibC::Int
  fun jack_port_connected_to(JackPort*, UInt8*) : LibC::Int
  fun jack_port_get_connections(JackPort*) : UInt8**
  fun jack_port_get_all_connections(JackClient*, JackPort*) : UInt8**
  fun jack_port_tie(JackPort*, JackPort*) : LibC::Int
  fun jack_port_untie(JackPort*) : LibC::Int
  fun jack_port_set_name(JackPort*, UInt8*) : LibC::Int
  fun jack_port_rename(JackClient*, JackPort*, UInt8*) : LibC::Int
  fun jack_port_set_alias(JackPort*, UInt8*) : LibC::Int
  fun jack_port_unset_alias(JackPort*, UInt8*) : LibC::Int
  fun jack_port_get_aliases(JackPort*, StaticArray(UInt8*, 2)) : LibC::Int
  fun jack_port_request_monitor(JackPort*, LibC::Int) : LibC::Int
  fun jack_port_request_monitor_by_name(JackClient*, UInt8*, LibC::Int) : LibC::Int
  fun jack_port_ensure_monitor(JackPort*, LibC::Int) : LibC::Int
  fun jack_port_monitoring_input(JackPort*) : LibC::Int
  fun jack_connect(JackClient*, UInt8*, UInt8*) : LibC::Int
  fun jack_disconnect(JackClient*, UInt8*, UInt8*) : LibC::Int
  fun jack_port_disconnect(JackClient*, JackPort*) : LibC::Int
  fun jack_port_name_size : LibC::Int
  fun jack_port_type_size : LibC::Int
  fun jack_port_type_get_buffer_size(JackClient*, UInt8*) : LibC::SizeT
  fun jack_port_set_latency(JackPort*, JackNframesT) : Void
  fun jack_port_get_latency_range(JackPort*, JackLatencyCallbackMode, JackLatencyRange*) : Void
  fun jack_port_set_latency_range(JackPort*, JackLatencyCallbackMode, JackLatencyRange*) : Void
  fun jack_recompute_total_latencies(JackClient*) : LibC::Int
  fun jack_port_get_latency(JackPort*) : JackNframesT
  fun jack_port_get_total_latency(JackClient*, JackPort*) : JackNframesT
  fun jack_recompute_total_latency(JackClient*, JackPort*) : LibC::Int
  fun jack_get_ports(JackClient*, UInt8*, UInt8*, LibC::ULong) : UInt8**
  fun jack_port_by_name(JackClient*, UInt8*) : JackPort*
  fun jack_port_by_id(JackClient*, JackPortIdT) : JackPort*
  fun jack_frames_since_cycle_start(JackClient*) : JackNframesT
  fun jack_frame_time(JackClient*) : JackNframesT
  fun jack_last_frame_time(JackClient*) : JackNframesT
  fun jack_get_cycle_times(JackClient*, JackNframesT*, JackTimeT*, JackTimeT*, LibC::Float*) : LibC::Int
  fun jack_frames_to_time(JackClient*, JackNframesT) : JackTimeT
  fun jack_time_to_frames(JackClient*, JackTimeT) : JackNframesT
  fun jack_get_time : JackTimeT
  fun jack_set_error_function((UInt8*) -> Void*) : Void
  fun jack_set_info_function((UInt8*) -> Void*) : Void
  fun jack_free(Void*) : Void
end
