
(* The environment of this application *)
type t

val make : Okeyfum_config.Config.t -> t
(* [make config] make new environment created from [config] *)

val lock_state_lock : env:t -> name:string -> unit
(* [lock_state_lock ~env ~name] change state of lock [name] to locked *)

val lock_state_unlock : env:t -> name:string -> unit
(* [lock_state_unlock ~env ~name] change state of lock [name] to unlocked *)

val lock_state_toggle : env:t -> name:string -> unit
(* [lock_state_toggle ~env ~name] change state of lock [name] to invert current state in [env] *)

val find_key_code : env:t -> name:string -> int option
(* [find_key_code ~env ~name] find key code with given key name. *)
