
(* The environment of this application *)
type t = {
  lock_state: (string, bool) Hashtbl.t;
  enabled: bool;
}

let make config =
  let module C = Okeyfum_config.Config in
  let decls = C.lock_defs config in 
  let tbl = Hashtbl.create (List.length decls) in
  List.iter (fun decl -> Hashtbl.add tbl decl false) decls;
  {lock_state = tbl; enabled = false}

let lock_state_lock ~env ~name = Hashtbl.add env.lock_state name true; env
let lock_state_unlock ~env ~name = Hashtbl.add env.lock_state name false; env
let lock_state_toggle ~env ~name =
  let cur = try Hashtbl.find env.lock_state name with Not_found -> false in
  Hashtbl.add env.lock_state name (not cur);
  env

let locked_keys t =
  Hashtbl.fold (fun k v b -> if v then k :: b else b) t.lock_state []

let enable_converter t = {t with enabled = true}
let disable_converter t = {t with enabled = false}

let is_enable t = t.enabled
