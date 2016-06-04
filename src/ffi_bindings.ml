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
end
