module T = Okeyfum_types

(* The environment of this application *)
type t = {
  lock_state: (string, bool) Hashtbl.t;
  meta_key_status: T.Meta_key.status;
  enabled: bool;
}

let make config =
  let module C = Okeyfum_config.Config in
  let decls = C.lock_defs config in 
  let tbl = Hashtbl.create (List.length decls) in
  List.iter (fun decl -> Hashtbl.add tbl decl false) decls;
  {lock_state = tbl; meta_key_status = 0;enabled = false}

let lock_state_lock ~env ~name = Hashtbl.replace env.lock_state name true; env
let lock_state_unlock ~env ~name = Hashtbl.replace env.lock_state name false; env
let lock_state_toggle ~env ~name =
  let cur = try Hashtbl.find env.lock_state name with Not_found -> false in
  Hashtbl.replace env.lock_state name (not cur);
  env

let locked_keys t =
  Hashtbl.fold (fun k v b -> if v then k :: b else b) t.lock_state []

let enable_converter t = {t with enabled = true}
let disable_converter t = {t with enabled = false}

let is_enable t = t.enabled

let meta_key_press ~env ~meta_key =
  let module T = Okeyfum_types.Meta_key in
  {env with meta_key_status = T.press ~state:env.meta_key_status ~key:meta_key}

let meta_key_release ~env ~meta_key =
  let module T = Okeyfum_types.Meta_key in
  {env with meta_key_status = T.release ~state:env.meta_key_status ~key:meta_key}

let is_any_meta_key_pressed env = not (T.Meta_key.is_any_pressed env.meta_key_status)
