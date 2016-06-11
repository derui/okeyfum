(*
  This module provides functions to evaluate function in expanded key sequence,
  and convert key sequence to key events
*)

val eval_key_seq: env:Okeyfum_environment.t -> seq:Okeyfum_types.expanded_key list
  -> Okeyfum_environment.t * (Okeyfum_types.Input_event.t, string) result list
(* [eval_key_seq ~env ~seq] evaluate functions in the [seq], then
   return truly key event to send to device and updated environment
*)
