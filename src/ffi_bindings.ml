open Ctypes

(* Constant-mapped types with generated stub *)
module Types (F: Cstubs.Types.TYPE) = struct
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

  module Input_ioctl = struct
    let grab = F.constant "EVIOCGRAB" F.int
  end

  (* The flags for Linux Open *)
  module Open_flag = struct
    let rdonly = F.constant "O_RDONLY" F.int
    let wronly = F.constant "O_WRONLY" F.int
  end
end
