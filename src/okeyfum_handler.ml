module Log = Okeyfum_log
module Keyboard_device = Okeyfum_keyboard_device
module Conv = Okeyfum_converter
module Eval = Okeyfum_evaluator
module E = Okeyfum_environment
module C = Okeyfum_config.Config

module S = Set.Make(struct
  type t = string
  let compare = Pervasives.compare
end)
let clear_lock_status env =
  let locked_keys = E.locked_keys env in
  List.fold_left (fun e v -> E.lock_state_unlock ~env:e ~name:v) env locked_keys
    
let handle_key_event config ~user ~keyboard =
  let env = Okeyfum_environment.make config in
  let rec loop' env =
    let key = Keyboard_device.read_key keyboard in
    let seq = Conv.convert_event_to_seq ~config ~env ~event:key in
    let env, keys =
      let module T = Okeyfum_types in 
      match seq with
      | T.To_eval seq -> Eval.eval_key_seq ~env ~seq
      | T.No_def seq -> let env, keys = Eval.eval_key_seq ~env ~seq in
                        (clear_lock_status env, keys)
      | T.Not_key seq -> Eval.eval_key_seq ~env ~seq
    in

      (* checking converter status in updated environment here,
         because okeyfum should always convert and evaluate key sequence
         within enable/disable status.
      *)
    let module Time = Okeyfum_time in
    let module E = Okeyfum_types.Input_event in 
    if Okeyfum_environment.is_enable env then
      List.iter (fun key ->
        let key = {key with E.time = Time.now ()} in
        Keyboard_device.write_key user key
      ) keys
    else
      let key = {key with E.time = Time.now ()} in
      Keyboard_device.write_key user key;

      loop' env
  in

  loop' env
