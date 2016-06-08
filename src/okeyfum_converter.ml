
module IE = Okeyfum_types.Input_event
module E = Okeyfum_environment
module K = Okeyfum_key
module C = Okeyfum_config.Config

let rec expand_key config env = function
  | `Key k -> K.key_name_to_code k
  | `Var k -> let vars = C.variable_map config in
              let vars = try Hashtbl.find vars k with Not_found -> [] in
              expand_key_sequence config env 
  
and expand_key_sequence config env seq =
  List.fold_left (fun seq key ->
    let keys = expand_key config env key in
    seq @ keys
  ) seq

let handle_key_event ~config ~env ~event =
  if not (E.is_enable env) then [event]
  else

  []
