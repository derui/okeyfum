
(* The environment of this application *)
type t = {
  lock_state: (string, bool) Hashtbl.t;
  key_map: (string, int) Hashtbl.t;
}

module T = Okeyfum_ffi_bindings.Types(Okeyfum_ffi_generated_types)

(* Fixed keycode map. This map is specially defined in user environment *)
let key_map =
  let tbl = Hashtbl.create 100 in
  Hashtbl.add tbl "esc" T.Key.key_esc;
  Hashtbl.add tbl "_1" T.Key.key_1;
  Hashtbl.add tbl "_2" T.Key.key_2;
  Hashtbl.add tbl "_3" T.Key.key_3;
  Hashtbl.add tbl "_4" T.Key.key_4;
  Hashtbl.add tbl "_5" T.Key.key_5;
  Hashtbl.add tbl "_6" T.Key.key_6;
  Hashtbl.add tbl "_7" T.Key.key_7;
  Hashtbl.add tbl "_8" T.Key.key_8;
  Hashtbl.add tbl "_9" T.Key.key_9;
  Hashtbl.add tbl "_0" T.Key.key_0;
  Hashtbl.add tbl "minus" T.Key.key_minus;
  Hashtbl.add tbl "equal" T.Key.key_equal;
  Hashtbl.add tbl "backspace" T.Key.key_backspace;
  Hashtbl.add tbl "tab" T.Key.key_tab;
  Hashtbl.add tbl "q" T.Key.key_q;
  Hashtbl.add tbl "w" T.Key.key_w;
  Hashtbl.add tbl "e" T.Key.key_e;
  Hashtbl.add tbl "r" T.Key.key_r;
  Hashtbl.add tbl "t" T.Key.key_t;
  Hashtbl.add tbl "y" T.Key.key_y;
  Hashtbl.add tbl "u" T.Key.key_u;
  Hashtbl.add tbl "i" T.Key.key_i;
  Hashtbl.add tbl "o" T.Key.key_o;
  Hashtbl.add tbl "p" T.Key.key_p;
  Hashtbl.add tbl "leftbrace" T.Key.key_leftbrace;
  Hashtbl.add tbl "rightbrace" T.Key.key_rightbrace;
  Hashtbl.add tbl "enter" T.Key.key_enter;
  Hashtbl.add tbl "leftctrl" T.Key.key_leftctrl;
  Hashtbl.add tbl "a" T.Key.key_a;
  Hashtbl.add tbl "s" T.Key.key_s;
  Hashtbl.add tbl "d" T.Key.key_d;
  Hashtbl.add tbl "f" T.Key.key_f;
  Hashtbl.add tbl "g" T.Key.key_g;
  Hashtbl.add tbl "h" T.Key.key_h;
  Hashtbl.add tbl "j" T.Key.key_j;
  Hashtbl.add tbl "k" T.Key.key_k;
  Hashtbl.add tbl "l" T.Key.key_l;
  Hashtbl.add tbl "semicolon" T.Key.key_semicolon;
  Hashtbl.add tbl "apostrophe" T.Key.key_apostrophe;
  Hashtbl.add tbl "grave" T.Key.key_grave;
  Hashtbl.add tbl "leftshift" T.Key.key_leftshift;
  Hashtbl.add tbl "backslash" T.Key.key_backslash;
  Hashtbl.add tbl "z" T.Key.key_z;
  Hashtbl.add tbl "x" T.Key.key_x;
  Hashtbl.add tbl "c" T.Key.key_c;
  Hashtbl.add tbl "v" T.Key.key_v;
  Hashtbl.add tbl "b" T.Key.key_b;
  Hashtbl.add tbl "n" T.Key.key_n;
  Hashtbl.add tbl "m" T.Key.key_m;
  Hashtbl.add tbl "comma" T.Key.key_comma;
  Hashtbl.add tbl "dot" T.Key.key_dot;
  Hashtbl.add tbl "slash" T.Key.key_slash;
  Hashtbl.add tbl "rightshift" T.Key.key_rightshift;
  Hashtbl.add tbl "kpasterisk" T.Key.key_kpasterisk;
  Hashtbl.add tbl "leftalt" T.Key.key_leftalt;
  Hashtbl.add tbl "space" T.Key.key_space;
  Hashtbl.add tbl "capslock" T.Key.key_capslock;
  Hashtbl.add tbl "f1" T.Key.key_f1;
  Hashtbl.add tbl "f2" T.Key.key_f2;
  Hashtbl.add tbl "f3" T.Key.key_f3;
  Hashtbl.add tbl "f4" T.Key.key_f4;
  Hashtbl.add tbl "f5" T.Key.key_f5;
  Hashtbl.add tbl "f6" T.Key.key_f6;
  Hashtbl.add tbl "f7" T.Key.key_f7;
  Hashtbl.add tbl "f8" T.Key.key_f8;
  Hashtbl.add tbl "f9" T.Key.key_f9;
  Hashtbl.add tbl "f10" T.Key.key_f10;
  Hashtbl.add tbl "numlock" T.Key.key_numlock;
  Hashtbl.add tbl "scrolllock" T.Key.key_scrolllock;
  Hashtbl.add tbl "kp7" T.Key.key_kp7;
  Hashtbl.add tbl "kp8" T.Key.key_kp8;
  Hashtbl.add tbl "kp9" T.Key.key_kp9;
  Hashtbl.add tbl "kpminus" T.Key.key_kpminus;
  Hashtbl.add tbl "kp4" T.Key.key_kp4;
  Hashtbl.add tbl "kp5" T.Key.key_kp5;
  Hashtbl.add tbl "kp6" T.Key.key_kp6;
  Hashtbl.add tbl "kpplus" T.Key.key_kpplus;
  Hashtbl.add tbl "kp1" T.Key.key_kp1;
  Hashtbl.add tbl "kp2" T.Key.key_kp2;
  Hashtbl.add tbl "kp3" T.Key.key_kp3;
  Hashtbl.add tbl "kp0" T.Key.key_kp0;
  Hashtbl.add tbl "kpdot" T.Key.key_kpdot;
  Hashtbl.add tbl "zenkakuhankaku" T.Key.key_zenkakuhankaku;
  Hashtbl.add tbl "102nd" T.Key.key_102nd;
  Hashtbl.add tbl "f11" T.Key.key_f11;
  Hashtbl.add tbl "f12" T.Key.key_f12;
  Hashtbl.add tbl "ro" T.Key.key_ro;
  Hashtbl.add tbl "katakana" T.Key.key_katakana;
  Hashtbl.add tbl "hiragana" T.Key.key_hiragana;
  Hashtbl.add tbl "henkan" T.Key.key_henkan;
  Hashtbl.add tbl "katakanahiragana" T.Key.key_katakanahiragana;
  Hashtbl.add tbl "muhenkan" T.Key.key_muhenkan;
  Hashtbl.add tbl "kpjpcomma" T.Key.key_kpjpcomma;
  Hashtbl.add tbl "kpenter" T.Key.key_kpenter;
  Hashtbl.add tbl "rightctrl" T.Key.key_rightctrl;
  Hashtbl.add tbl "kpslash" T.Key.key_kpslash;
  Hashtbl.add tbl "sysrq" T.Key.key_sysrq;
  Hashtbl.add tbl "rightalt" T.Key.key_rightalt;
  Hashtbl.add tbl "linefeed" T.Key.key_linefeed;
  Hashtbl.add tbl "home" T.Key.key_home;
  Hashtbl.add tbl "up" T.Key.key_up;
  Hashtbl.add tbl "pageup" T.Key.key_pageup;
  Hashtbl.add tbl "left" T.Key.key_left;
  Hashtbl.add tbl "right" T.Key.key_right;
  Hashtbl.add tbl "end" T.Key.key_end;
  Hashtbl.add tbl "down" T.Key.key_down;
  Hashtbl.add tbl "pagedown" T.Key.key_pagedown;
  Hashtbl.add tbl "insert" T.Key.key_insert;
  Hashtbl.add tbl "delete" T.Key.key_delete;
  Hashtbl.add tbl "macro" T.Key.key_macro;
  Hashtbl.add tbl "mute" T.Key.key_mute;
  Hashtbl.add tbl "volumedown" T.Key.key_volumedown;
  Hashtbl.add tbl "volumeup" T.Key.key_volumeup;
  Hashtbl.add tbl "power" T.Key.key_power;
  Hashtbl.add tbl "kpequal" T.Key.key_kpequal;
  Hashtbl.add tbl "kpplusminus" T.Key.key_kpplusminus;
  Hashtbl.add tbl "pause" T.Key.key_pause;
  Hashtbl.add tbl "scale" T.Key.key_scale;
  Hashtbl.add tbl "yen" T.Key.key_yen;
  Hashtbl.add tbl "leftmeta" T.Key.key_leftmeta;
  Hashtbl.add tbl "rightmeta" T.Key.key_rightmeta;
  Hashtbl.add tbl "f13" T.Key.key_f13;
  Hashtbl.add tbl "f14" T.Key.key_f14;
  Hashtbl.add tbl "f15" T.Key.key_f15;
  Hashtbl.add tbl "f16" T.Key.key_f16;
  Hashtbl.add tbl "f17" T.Key.key_f17;
  Hashtbl.add tbl "f18" T.Key.key_f18;
  Hashtbl.add tbl "f19" T.Key.key_f19;
  Hashtbl.add tbl "f20" T.Key.key_f20;
  Hashtbl.add tbl "f21" T.Key.key_f21;
  Hashtbl.add tbl "f22" T.Key.key_f22;
  Hashtbl.add tbl "f23" T.Key.key_f23;
  Hashtbl.add tbl "f24" T.Key.key_f24;
  tbl

let make config =
  let module C = Okeyfum_config.Config in
  let decls = C.lock_defs config in 
  let tbl = Hashtbl.create (List.length decls) in
  List.iter (fun decl -> Hashtbl.add tbl decl false) decls;
  {lock_state = tbl; key_map = key_map}

let lock_state_lock ~env ~name = Hashtbl.add env.lock_state name true
let lock_state_unlock ~env ~name = Hashtbl.add env.lock_state name false
let lock_state_toggle ~env ~name =
  let cur = try Hashtbl.find env.lock_state name with Not_found -> false in
  Hashtbl.add env.lock_state name (not cur)

let find_key_code ~env ~name =
  try
    let code = Hashtbl.find env.key_map name in Some(code)
  with Not_found -> None
