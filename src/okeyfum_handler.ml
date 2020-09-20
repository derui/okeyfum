module Log = Okeyfum_log
module Keyboard_device = Okeyfum_keyboard_device
module Conv = Okeyfum_converter
module Eval = Okeyfum_evaluator
module E = Okeyfum_environment
module C = Okeyfum_config.Config
module L = Okeyfum_log

let clear_lock_status env =
  let locked_keys = E.locked_keys env in
  List.fold_left (fun e v -> E.lock_state_unlock ~env:e ~name:v) env locked_keys

let handle_meta_key env key =
  let module T = Okeyfum_types.Meta_key in
  let module IE = Okeyfum_types.Input_event in
  let state = Okeyfum_util.event_to_state key in
  match T.key_to_meta key.IE.code with
  | Some meta_key -> (
      match state with
      | `UP   -> (E.meta_key_release ~env ~meta_key, true)
      | `DOWN -> (E.meta_key_press ~env ~meta_key, true) )
  | None          -> (env, false)

let has_output env = E.is_enable env && not (E.is_any_meta_key_pressed env)

let handle_key_event config ~user ~keyboard =
  let env = Okeyfum_environment.make config in
  let rec loop' env =
    let key = Keyboard_device.read_key keyboard in
    let env, key_as_meta = handle_meta_key env key in

    let seq = Conv.convert_event_to_seq ~config ~env ~event:key in
    let env, keys =
      if E.is_any_meta_key_pressed env || key_as_meta then (
        L.debug "Meta key pressed";
        (env, [ key ]) )
      else
        let module T = Okeyfum_types in
        match seq with
        | T.To_eval seq -> Eval.eval_key_seq ~env ~seq
        | T.No_def seq  ->
            let env, keys = Eval.eval_key_seq ~env ~seq in
            (clear_lock_status env, keys)
        | T.Not_key _   -> (env, [ key ])
    in

    (* checking converter status in updated environment here, because okeyfum should always convert and evaluate key
       sequence within enable/disable status. *)
    let module Time = Okeyfum_time in
    let module E = Okeyfum_types.Input_event in
    ( if has_output env then
      List.iter
        (fun key ->
          let key = { key with E.time = Time.now () } in
          Keyboard_device.write_key user key)
        keys
    else
      let key = { key with E.time = Time.now () } in
      Keyboard_device.write_key user key );

    loop' env
  in

  loop' env
