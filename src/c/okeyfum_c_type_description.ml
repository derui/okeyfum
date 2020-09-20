(* Constant-mapped types with generated stub *)
module Types (F : Cstubs.Types.TYPE) = struct
  module Event_type = struct
    let ev_syn = F.constant "EV_SYN" F.int

    let ev_key = F.constant "EV_KEY" F.int

    let ev_rel = F.constant "EV_REL" F.int

    let ev_abs = F.constant "EV_ABS" F.int

    let ev_msc = F.constant "EV_MSC" F.int

    let ev_sw = F.constant "EV_SW" F.int

    let ev_led = F.constant "EV_LED" F.int

    let ev_snd = F.constant "EV_SND" F.int

    let ev_rep = F.constant "EV_REP" F.int

    let ev_ff = F.constant "EV_FF" F.int

    let ev_pwr = F.constant "EV_PWR" F.int

    let ev_ff_status = F.constant "EV_FF_STATUS" F.int

    let ev_max = F.constant "EV_MAX" F.int

    let ev_cnt = F.constant "EV_CNT" F.int
  end

  module Key = struct
    let key_esc = F.constant "KEY_ESC" F.int

    let key_1 = F.constant "KEY_1" F.int

    let key_2 = F.constant "KEY_2" F.int

    let key_3 = F.constant "KEY_3" F.int

    let key_4 = F.constant "KEY_4" F.int

    let key_5 = F.constant "KEY_5" F.int

    let key_6 = F.constant "KEY_6" F.int

    let key_7 = F.constant "KEY_7" F.int

    let key_8 = F.constant "KEY_8" F.int

    let key_9 = F.constant "KEY_9" F.int

    let key_0 = F.constant "KEY_0" F.int

    let key_minus = F.constant "KEY_MINUS" F.int

    let key_equal = F.constant "KEY_EQUAL" F.int

    let key_backspace = F.constant "KEY_BACKSPACE" F.int

    let key_tab = F.constant "KEY_TAB" F.int

    let key_q = F.constant "KEY_Q" F.int

    let key_w = F.constant "KEY_W" F.int

    let key_e = F.constant "KEY_E" F.int

    let key_r = F.constant "KEY_R" F.int

    let key_t = F.constant "KEY_T" F.int

    let key_y = F.constant "KEY_Y" F.int

    let key_u = F.constant "KEY_U" F.int

    let key_i = F.constant "KEY_I" F.int

    let key_o = F.constant "KEY_O" F.int

    let key_p = F.constant "KEY_P" F.int

    let key_leftbrace = F.constant "KEY_LEFTBRACE" F.int

    let key_rightbrace = F.constant "KEY_RIGHTBRACE" F.int

    let key_enter = F.constant "KEY_ENTER" F.int

    let key_leftctrl = F.constant "KEY_LEFTCTRL" F.int

    let key_a = F.constant "KEY_A" F.int

    let key_s = F.constant "KEY_S" F.int

    let key_d = F.constant "KEY_D" F.int

    let key_f = F.constant "KEY_F" F.int

    let key_g = F.constant "KEY_G" F.int

    let key_h = F.constant "KEY_H" F.int

    let key_j = F.constant "KEY_J" F.int

    let key_k = F.constant "KEY_K" F.int

    let key_l = F.constant "KEY_L" F.int

    let key_semicolon = F.constant "KEY_SEMICOLON" F.int

    let key_apostrophe = F.constant "KEY_APOSTROPHE" F.int

    let key_grave = F.constant "KEY_GRAVE" F.int

    let key_leftshift = F.constant "KEY_LEFTSHIFT" F.int

    let key_backslash = F.constant "KEY_BACKSLASH" F.int

    let key_z = F.constant "KEY_Z" F.int

    let key_x = F.constant "KEY_X" F.int

    let key_c = F.constant "KEY_C" F.int

    let key_v = F.constant "KEY_V" F.int

    let key_b = F.constant "KEY_B" F.int

    let key_n = F.constant "KEY_N" F.int

    let key_m = F.constant "KEY_M" F.int

    let key_comma = F.constant "KEY_COMMA" F.int

    let key_dot = F.constant "KEY_DOT" F.int

    let key_slash = F.constant "KEY_SLASH" F.int

    let key_rightshift = F.constant "KEY_RIGHTSHIFT" F.int

    let key_kpasterisk = F.constant "KEY_KPASTERISK" F.int

    let key_leftalt = F.constant "KEY_LEFTALT" F.int

    let key_space = F.constant "KEY_SPACE" F.int

    let key_capslock = F.constant "KEY_CAPSLOCK" F.int

    let key_f1 = F.constant "KEY_F1" F.int

    let key_f2 = F.constant "KEY_F2" F.int

    let key_f3 = F.constant "KEY_F3" F.int

    let key_f4 = F.constant "KEY_F4" F.int

    let key_f5 = F.constant "KEY_F5" F.int

    let key_f6 = F.constant "KEY_F6" F.int

    let key_f7 = F.constant "KEY_F7" F.int

    let key_f8 = F.constant "KEY_F8" F.int

    let key_f9 = F.constant "KEY_F9" F.int

    let key_f10 = F.constant "KEY_F10" F.int

    let key_numlock = F.constant "KEY_NUMLOCK" F.int

    let key_scrolllock = F.constant "KEY_SCROLLLOCK" F.int

    let key_kp7 = F.constant "KEY_KP7" F.int

    let key_kp8 = F.constant "KEY_KP8" F.int

    let key_kp9 = F.constant "KEY_KP9" F.int

    let key_kpminus = F.constant "KEY_KPMINUS" F.int

    let key_kp4 = F.constant "KEY_KP4" F.int

    let key_kp5 = F.constant "KEY_KP5" F.int

    let key_kp6 = F.constant "KEY_KP6" F.int

    let key_kpplus = F.constant "KEY_KPPLUS" F.int

    let key_kp1 = F.constant "KEY_KP1" F.int

    let key_kp2 = F.constant "KEY_KP2" F.int

    let key_kp3 = F.constant "KEY_KP3" F.int

    let key_kp0 = F.constant "KEY_KP0" F.int

    let key_kpdot = F.constant "KEY_KPDOT" F.int

    let key_zenkakuhankaku = F.constant "KEY_ZENKAKUHANKAKU" F.int

    let key_102nd = F.constant "KEY_102ND" F.int

    let key_f11 = F.constant "KEY_F11" F.int

    let key_f12 = F.constant "KEY_F12" F.int

    let key_ro = F.constant "KEY_RO" F.int

    let key_katakana = F.constant "KEY_KATAKANA" F.int

    let key_hiragana = F.constant "KEY_HIRAGANA" F.int

    let key_henkan = F.constant "KEY_HENKAN" F.int

    let key_katakanahiragana = F.constant "KEY_KATAKANAHIRAGANA" F.int

    let key_muhenkan = F.constant "KEY_MUHENKAN" F.int

    let key_kpjpcomma = F.constant "KEY_KPJPCOMMA" F.int

    let key_kpenter = F.constant "KEY_KPENTER" F.int

    let key_rightctrl = F.constant "KEY_RIGHTCTRL" F.int

    let key_kpslash = F.constant "KEY_KPSLASH" F.int

    let key_sysrq = F.constant "KEY_SYSRQ" F.int

    let key_rightalt = F.constant "KEY_RIGHTALT" F.int

    let key_linefeed = F.constant "KEY_LINEFEED" F.int

    let key_home = F.constant "KEY_HOME" F.int

    let key_up = F.constant "KEY_UP" F.int

    let key_pageup = F.constant "KEY_PAGEUP" F.int

    let key_left = F.constant "KEY_LEFT" F.int

    let key_right = F.constant "KEY_RIGHT" F.int

    let key_end = F.constant "KEY_END" F.int

    let key_down = F.constant "KEY_DOWN" F.int

    let key_pagedown = F.constant "KEY_PAGEDOWN" F.int

    let key_insert = F.constant "KEY_INSERT" F.int

    let key_delete = F.constant "KEY_DELETE" F.int

    let key_macro = F.constant "KEY_MACRO" F.int

    let key_mute = F.constant "KEY_MUTE" F.int

    let key_volumedown = F.constant "KEY_VOLUMEDOWN" F.int

    let key_volumeup = F.constant "KEY_VOLUMEUP" F.int

    let key_power = F.constant "KEY_POWER" F.int

    let key_kpequal = F.constant "KEY_KPEQUAL" F.int

    let key_kpplusminus = F.constant "KEY_KPPLUSMINUS" F.int

    let key_pause = F.constant "KEY_PAUSE" F.int

    let key_scale = F.constant "KEY_SCALE" F.int

    let key_kpcomma = F.constant "KEY_KPCOMMA" F.int

    let key_hangeul = F.constant "KEY_HANGEUL" F.int

    let key_hanguel = F.constant "KEY_HANGUEL" F.int

    let key_hanja = F.constant "KEY_HANJA" F.int

    let key_yen = F.constant "KEY_YEN" F.int

    let key_leftmeta = F.constant "KEY_LEFTMETA" F.int

    let key_rightmeta = F.constant "KEY_RIGHTMETA" F.int

    let key_compose = F.constant "KEY_COMPOSE" F.int

    let key_stop = F.constant "KEY_STOP" F.int

    let key_again = F.constant "KEY_AGAIN" F.int

    let key_props = F.constant "KEY_PROPS" F.int

    let key_undo = F.constant "KEY_UNDO" F.int

    let key_front = F.constant "KEY_FRONT" F.int

    let key_copy = F.constant "KEY_COPY" F.int

    let key_open = F.constant "KEY_OPEN" F.int

    let key_paste = F.constant "KEY_PASTE" F.int

    let key_find = F.constant "KEY_FIND" F.int

    let key_cut = F.constant "KEY_CUT" F.int

    let key_help = F.constant "KEY_HELP" F.int

    let key_menu = F.constant "KEY_MENU" F.int

    let key_calc = F.constant "KEY_CALC" F.int

    let key_setup = F.constant "KEY_SETUP" F.int

    let key_sleep = F.constant "KEY_SLEEP" F.int

    let key_wakeup = F.constant "KEY_WAKEUP" F.int

    let key_file = F.constant "KEY_FILE" F.int

    let key_sendfile = F.constant "KEY_SENDFILE" F.int

    let key_deletefile = F.constant "KEY_DELETEFILE" F.int

    let key_xfer = F.constant "KEY_XFER" F.int

    let key_prog1 = F.constant "KEY_PROG1" F.int

    let key_prog2 = F.constant "KEY_PROG2" F.int

    let key_www = F.constant "KEY_WWW" F.int

    let key_msdos = F.constant "KEY_MSDOS" F.int

    let key_coffee = F.constant "KEY_COFFEE" F.int

    let key_screenlock = F.constant "KEY_SCREENLOCK" F.int

    let key_rotate_display = F.constant "KEY_ROTATE_DISPLAY" F.int

    let key_direction = F.constant "KEY_DIRECTION" F.int

    let key_cyclewindows = F.constant "KEY_CYCLEWINDOWS" F.int

    let key_mail = F.constant "KEY_MAIL" F.int

    let key_bookmarks = F.constant "KEY_BOOKMARKS" F.int

    let key_computer = F.constant "KEY_COMPUTER" F.int

    let key_back = F.constant "KEY_BACK" F.int

    let key_forward = F.constant "KEY_FORWARD" F.int

    let key_closecd = F.constant "KEY_CLOSECD" F.int

    let key_ejectcd = F.constant "KEY_EJECTCD" F.int

    let key_ejectclosecd = F.constant "KEY_EJECTCLOSECD" F.int

    let key_nextsong = F.constant "KEY_NEXTSONG" F.int

    let key_playpause = F.constant "KEY_PLAYPAUSE" F.int

    let key_previoussong = F.constant "KEY_PREVIOUSSONG" F.int

    let key_stopcd = F.constant "KEY_STOPCD" F.int

    let key_record = F.constant "KEY_RECORD" F.int

    let key_rewind = F.constant "KEY_REWIND" F.int

    let key_phone = F.constant "KEY_PHONE" F.int

    let key_iso = F.constant "KEY_ISO" F.int

    let key_config = F.constant "KEY_CONFIG" F.int

    let key_homepage = F.constant "KEY_HOMEPAGE" F.int

    let key_refresh = F.constant "KEY_REFRESH" F.int

    let key_exit = F.constant "KEY_EXIT" F.int

    let key_move = F.constant "KEY_MOVE" F.int

    let key_edit = F.constant "KEY_EDIT" F.int

    let key_scrollup = F.constant "KEY_SCROLLUP" F.int

    let key_scrolldown = F.constant "KEY_SCROLLDOWN" F.int

    let key_kpleftparen = F.constant "KEY_KPLEFTPAREN" F.int

    let key_kprightparen = F.constant "KEY_KPRIGHTPAREN" F.int

    let key_new = F.constant "KEY_NEW" F.int

    let key_redo = F.constant "KEY_REDO" F.int

    let key_f13 = F.constant "KEY_F13" F.int

    let key_f14 = F.constant "KEY_F14" F.int

    let key_f15 = F.constant "KEY_F15" F.int

    let key_f16 = F.constant "KEY_F16" F.int

    let key_f17 = F.constant "KEY_F17" F.int

    let key_f18 = F.constant "KEY_F18" F.int

    let key_f19 = F.constant "KEY_F19" F.int

    let key_f20 = F.constant "KEY_F20" F.int

    let key_f21 = F.constant "KEY_F21" F.int

    let key_f22 = F.constant "KEY_F22" F.int

    let key_f23 = F.constant "KEY_F23" F.int

    let key_f24 = F.constant "KEY_F24" F.int

    let key_playcd = F.constant "KEY_PLAYCD" F.int

    let key_pausecd = F.constant "KEY_PAUSECD" F.int

    let key_prog3 = F.constant "KEY_PROG3" F.int

    let key_prog4 = F.constant "KEY_PROG4" F.int

    let key_dashboard = F.constant "KEY_DASHBOARD" F.int

    let key_suspend = F.constant "KEY_SUSPEND" F.int

    let key_close = F.constant "KEY_CLOSE" F.int

    let key_play = F.constant "KEY_PLAY" F.int

    let key_fastforward = F.constant "KEY_FASTFORWARD" F.int

    let key_bassboost = F.constant "KEY_BASSBOOST" F.int

    let key_print = F.constant "KEY_PRINT" F.int

    let key_hp = F.constant "KEY_HP" F.int

    let key_camera = F.constant "KEY_CAMERA" F.int

    let key_sound = F.constant "KEY_SOUND" F.int

    let key_question = F.constant "KEY_QUESTION" F.int

    let key_email = F.constant "KEY_EMAIL" F.int

    let key_chat = F.constant "KEY_CHAT" F.int

    let key_search = F.constant "KEY_SEARCH" F.int

    let key_connect = F.constant "KEY_CONNECT" F.int

    let key_finance = F.constant "KEY_FINANCE" F.int

    let key_sport = F.constant "KEY_SPORT" F.int

    let key_shop = F.constant "KEY_SHOP" F.int

    let key_alterase = F.constant "KEY_ALTERASE" F.int

    let key_cancel = F.constant "KEY_CANCEL" F.int

    let key_brightnessdown = F.constant "KEY_BRIGHTNESSDOWN" F.int

    let key_brightnessup = F.constant "KEY_BRIGHTNESSUP" F.int

    let key_media = F.constant "KEY_MEDIA" F.int
  end

  module Uinput = struct
    let max_name_size = F.constant "UINPUT_MAX_NAME_SIZE" F.int

    let ui_set_evbit = F.constant "UI_SET_EVBIT" F.int

    let ui_set_keybit = F.constant "UI_SET_KEYBIT" F.int

    let ui_dev_create = F.constant "UI_DEV_CREATE" F.int

    let ui_dev_destroy = F.constant "UI_DEV_DESTROY" F.int
  end

  module Input_abs = struct
    let abs_cnt = F.constant "ABS_CNT" F.int
  end

  module Input_bus = struct
    let bus_virtual = F.constant "BUS_VIRTUAL" F.int
  end

  module Input_syn = struct
    let report = F.constant "SYN_REPORT" F.int
  end

  module Input_ioctl = struct
    let grab = F.constant "EVIOCGRAB" F.int
  end

  (* The flags for Linux Open *)
  module Open_flag = struct
    let rdonly = F.constant "O_RDONLY" F.int

    let rdwr = F.constant "O_RDWR" F.int

    let wronly = F.constant "O_WRONLY" F.int
  end
end
