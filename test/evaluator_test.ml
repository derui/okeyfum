[%%suite
 module GT = Okeyfum_ffi_bindings.Types(Okeyfum_ffi_generated_types)
 let%spec "OKeyfum sequence evaluator should return key event" =
   match Okeyfum_config.load "./config.okf" with
   | Some config ->
      let env = Okeyfum_environment.make config in
      let module E = Okeyfum_evaluator in
      let event = let module I = Okeyfum_types.Input_event in
                  {I.typ = GT.Event_type.ev_key;
                   code = Okeyfum_key.key_name_to_code "a" |> Okeyfum_util.option_get;
                   value = 1L;
                   time = Okeyfum_types.Timeval.empty;
                  } in
      let keys = E.eval_key_seq ~env ~seq:[Okeyfum_types.Key event] in
      keys [@eq (env, [Ok(event)])]
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum sequence evaluator should evaluate function in sequence" =
   match Okeyfum_config.load "./config.okf" with
   | Some config ->
      let env = Okeyfum_environment.make config in
      let module E = Okeyfum_evaluator in
      let event = let module I = Okeyfum_types.Input_event in
                  {I.typ = GT.Event_type.ev_key;
                   code = Okeyfum_key.key_name_to_code "a" |> Okeyfum_util.option_get;
                   value = 1L;
                   time = Okeyfum_types.Timeval.empty;
                  } in
      let module T = Okeyfum_types in 
      let env, _ = E.eval_key_seq ~env ~seq:[T.Key event;T.Func ("enable", [])] in
      Okeyfum_environment.is_enable env [@true "converter enabled"]
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum sequence evaluator should be able to change lock state" =
   match Okeyfum_config.load "./config.okf" with
   | Some config ->
      let env = Okeyfum_environment.make config in
      let module E = Okeyfum_evaluator in
      let module T = Okeyfum_types in 
      let env, evs = E.eval_key_seq ~env ~seq:[T.Func ("enable", []);T.Func ("lock", ["b"])] in
      evs [@eq []];
      Okeyfum_environment.is_enable env [@true "converter enabled"];
      Okeyfum_environment.locked_keys env [@eq ["b"]];
   | None -> false [@false "Loading failure"]
]
