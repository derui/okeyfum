module T = Okeyfum_types
module IE = Okeyfum_types.Input_event
module E = Okeyfum_environment
module K = Okeyfum_key
module U = Okeyfum_util
module C = Okeyfum_config.Config

module GT = Okeyfum_ffi_bindings.Types(Okeyfum_ffi_generated_types)

(* Expand key sequence to terms are only code and function to invoke later *)
let rec expand_key config = function
  | `Id k -> begin
    match K.key_name_to_code k with
    | Some c -> [T.Key c]
    | None -> let module L = Okeyfum_log in
              L.error (Printf.sprintf "Not defined key name : %s" k);
              raise Not_found
  end
  | `Var k -> let vars = C.variable_map config in
              let vars = try Hashtbl.find vars k with Not_found -> [] in
              expand_key_seq config vars
  | `Func (fname, params) -> [T.Func(fname, params)]

and expand_key_seq config seq =
  List.fold_left (fun seq key ->
    let keys = expand_key config key in
    seq @ keys
  ) [] seq

let is_not_key_event {IE.typ=typ;_} = typ <> GT.Event_type.ev_key

let resolve_key_map config env event =
  let key = match K.key_code_to_name event.IE.code with
    | None -> let module L = Okeyfum_log in
              L.error (Printf.sprintf "Not defined key code: %d" event.IE.code);
              raise Not_found
    | Some k -> k
  in
  let state = match event.IE.value with
    | 0L -> `UP
    | _ -> `DOWN
  in
  let current_lock_key = match E.locked_keys env with
    | [] -> None
    | k :: _ -> Some k
  in
  let key_map = match current_lock_key with
    | None -> C.keydef_map config
    | Some k -> C.lock_decls config |> List.filter (fun (k', _) -> k = k') |> List.hd |> snd
  in
  let module M = Okeyfum_config.Keydef_map in 

  match try Some (M.find (key,state) key_map) with Not_found -> None with
  | None -> let module L = Okeyfum_log in
            L.debug (Printf.sprintf "Not found defined key sequence for : %s" key);
            None
  | Some seq -> Some (expand_key_seq config seq)

let convert_event_to_seq ~config ~env ~event =
  let default_seq = [T.Key (event.IE.code)] in
  if not (E.is_enable env) then default_seq
  else if is_not_key_event event then default_seq
  else
    match resolve_key_map config env event with
    | None -> default_seq
    | Some seq -> seq
