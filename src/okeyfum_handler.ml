module Log = Okeyfum_log
module Keyboard_device = Okeyfum_keyboard_device
module Conv = Okeyfum_converter
module Eval = Okeyfum_evaluator

let handle_key_event config ~user ~keyboard =
  let env = Okeyfum_environment.make config in
  let rec loop' env =
    let key = Keyboard_device.read_key keyboard in
    let seq = Conv.convert_event_to_seq ~config ~env ~event:key in
    let env, keys = Eval.eval_key_seq ~env ~seq in

    (* checking converter status in updated environment here,
       because okeyfum should always convert and evaluate key sequence
       within enable/disable status.
    *)
    if Okeyfum_environment.is_enable env then
      List.iter (fun key ->
        let module Time = Okeyfum_time in
        let module E = Okeyfum_types.Input_event in 
        let key = {key with E.time = Time.now ()} in
        Keyboard_device.write_key user key
      ) keys
    else
      Keyboard_device.write_key user key;

    loop' env
  in

  loop' env
