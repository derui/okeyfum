module T = Okeyfum_types
module IE = Okeyfum_types.Input_event
module GT = Okeyfum_c_type_description.Types (Okeyfum_c.Okeyfum_c_generated_types)
module E = Okeyfum_environment

let syn_event = { IE.empty with IE.typ = GT.Event_type.ev_syn; code = GT.Input_syn.report; value = 0L }

let key_to_event = function
  | T.Key input -> Ok [ input; syn_event ]
  | _           -> Error "Only key type to be able to convert Input_event"

let invoke_function env = function
  | T.Key _               -> Error "Only func type to be able to invoke"
  | T.Func (fname, param) -> (
      let module L = Okeyfum_log in
      match fname with
      | "&toggle"  -> (
          match param with
          | [ name ] ->
              L.debug (Printf.sprintf "toggle lock for: %s" name);
              Ok (E.lock_state_toggle ~env ~name:(List.hd param))
          | _        -> Error "the number of arguments of 'toggle' function must be 1." )
      | "&lock"    -> (
          match param with
          | [ name ] ->
              L.debug (Printf.sprintf "lock: %s" name);
              Ok (E.lock_state_lock ~env ~name)
          | _        -> Error "the number of arguments of 'lock' function must be 1" )
      | "&unlock"  -> (
          match param with
          | [ name ] ->
              L.debug (Printf.sprintf "unlock: %s" name);
              Ok (E.lock_state_unlock ~env ~name)
          | _        -> Error "the number of arguments of 'unlock' function must be 1" )
      | "&enable"  -> (
          match param with
          | [] ->
              L.info "Okeyfum converter enabled";
              Ok (E.enable_converter env)
          | _  -> Error "the number of arguments of 'enable' function must be 0" )
      | "&disable" -> (
          match param with
          | [] ->
              L.info "Okeyfum converter disabled";
              Ok (E.disable_converter env)
          | _  -> Error "the number of arguments of 'disable' function must be 0" )
      | "&switch"  -> (
          match param with
          | [] ->
              L.info "Okeyfum converter enabled";
              if E.is_enable env then Ok (E.disable_converter env) else Ok (E.enable_converter env)
          | _  -> Error "the number of arguments of 'switch' function must be 0" )
      | _          -> Error (Printf.sprintf "the function `%s` is not defined" fname) )

let eval_key_seq ~env ~seq =
  let keys = List.filter (function T.Key _ -> true | _ -> false) seq
  and funcs = List.filter (function T.Key _ -> false | _ -> true) seq in

  let keys =
    List.fold_left
      (fun keys key ->
        match key_to_event key with
        | Ok keys' -> keys @ keys'
        | Error e  ->
            Okeyfum_log.error e;
            keys)
      [] keys
  in

  let env =
    List.fold_left
      (fun env f ->
        match invoke_function env f with
        | Ok env    -> env
        | Error mes ->
            let module L = Okeyfum_log in
            L.error mes;
            env)
      env funcs
  in
  (env, keys)
