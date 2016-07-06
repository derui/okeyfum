module T = Okeyfum_types
module IE = Okeyfum_types.Input_event
module E = Okeyfum_environment
module K = Okeyfum_key
module U = Okeyfum_util
module C = Okeyfum_config.Config

module GT = Okeyfum_ffi_bindings.Types(Okeyfum_ffi_generated_types)
(* Expand key sequence to terms are only code and function to invoke later *)
let rec expand_key config state = function
  | `Id k -> begin
    match K.key_name_to_code k with
    | Some c -> let k_d = {IE.code = c;
                           time = T.Timeval.empty;
                           value = 1L;
                           typ = GT.Event_type.ev_key;
                          } in
                let k_u = {k_d with IE.value = 0L} in
                [T.Key k_d;T.Key k_u]
    | None -> let module L = Okeyfum_log in
              L.error (Printf.sprintf "Not defined key name : %s" k);
              raise Not_found
  end
  | `Var k -> let vars = C.variable_map config in
              let vars = try Hashtbl.find vars k with Not_found -> [] in
              expand_key_seq config state vars
  | `Func (fname, params) ->
     let module L = Okeyfum_log in
     L.debug (Printf.sprintf "function detected : %s" fname);
     [T.Func(fname, params)]

and expand_key_seq config state seq =
  List.fold_left (fun seq key ->
    let keys = expand_key config state key in
    seq @ keys
  ) [] seq

let is_not_key_event {IE.typ=typ;_} = typ <> GT.Event_type.ev_key

let resolve_key_seq config map key =
  let module M = Okeyfum_config.Keydef_map in
  let module C =  Okeyfum_config.Config in
  let seq =
    (* If already defined some default key sequense, use it. *)
    match try Some (M.find key map) with Not_found -> None with
    | None -> (try Some (M.find (C.wildcard_key, (snd key)) map) with Not_found -> None)
    | Some _ as k -> k
  in

  match seq with
  | None -> let module L = Okeyfum_log in
            let key', state  = key in
            L.info (Printf.sprintf "Not found defined key sequence for : %s" key');
            None
  | Some seq -> Some (expand_key_seq config (snd key) seq)

(* resolve key event to key sequence to evalate with environment and config *)
let expand_event config env event =
  let module M = Okeyfum_config.Keydef_map in
  let key = U.event_to_key_of_map event in
  let key_map = match E.locked_keys env with
    | [] -> Some (C.keydef_map config)
    | keys -> let module S = Okeyfum_config.Lock_set in
              let locked_keys = S.of_list keys in
              let decls = C.lock_decls config in
              let decls = List.find_all (fun (set, _) -> S.equal set locked_keys) decls in
              match decls with
              | [] -> None
              | (_, map) :: _ -> Some map
  in
  match key, key_map with
  | None, _ | Some _, None -> None
  | Some key, Some key_map -> resolve_key_seq config key_map key

let convert_event_to_seq ~config ~env ~event =
  let default_seq = [T.Key event] in
  if is_not_key_event event then T.Not_key default_seq
  else
    match expand_event config env event with
    | None -> T.No_def default_seq
    | Some seq -> T.To_eval seq
