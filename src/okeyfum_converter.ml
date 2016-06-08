
module IE = Okeyfum_types.Input_event
module E = Okeyfum_environment

let handle_key_event ~env ~event =
  if not (E.is_enable env) then [event]
  else
    
  []
