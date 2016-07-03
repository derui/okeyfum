[%%suite
 module GT = Okeyfum_ffi_bindings.Types(Okeyfum_ffi_generated_types)
 let%spec "OKeyfum key converter should return without change" =
   match Okeyfum_config.load "./config.okf" with
   | Some config ->
      let env = Okeyfum_environment.make config in
      let env = Okeyfum_environment.disable_converter env in
      let module C = Okeyfum_converter in
      let event = let module E = Okeyfum_types.Input_event in
                  {E.typ = GT.Event_type.ev_key;
                   code = Okeyfum_key.key_name_to_code "v" |> Okeyfum_util.option_get;
                   value = 1L;
                   time = Okeyfum_types.Timeval.empty;
                  } in
      let keys = C.convert_event_to_seq ~config ~env ~event in
      let module T = Okeyfum_types in 
      keys [@eq T.No_def [T.Key event]]
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum key converter should return key sequence expanded" =
   match Okeyfum_config.load "./config.okf" with
   | Some config ->
      let env = Okeyfum_environment.make config in
      let env = Okeyfum_environment.enable_converter env in
      let module C = Okeyfum_converter in
      let base = let module E = Okeyfum_types.Input_event in
                  {E.typ = GT.Event_type.ev_key;
                   code = Okeyfum_key.key_name_to_code "a" |> Okeyfum_util.option_get;
                   value = 1L;
                   time = Okeyfum_types.Timeval.empty;
                  } in
      let b = let module E = Okeyfum_types.Input_event in
              {base with E.code = Okeyfum_key.key_name_to_code "b" |> Okeyfum_util.option_get} in
      let b' = let module E = Okeyfum_types.Input_event in {b with E.value = 0L} in
      let v = let module E = Okeyfum_types.Input_event in
              {base with E.code = Okeyfum_key.key_name_to_code "v" |> Okeyfum_util.option_get} in
      let v' = let module E = Okeyfum_types.Input_event in {v with E.value = 0L} in
      let keys = C.convert_event_to_seq ~config ~env ~event:base in
      let module T = Okeyfum_types in
      keys [@eq T.To_eval [T.Key v;T.Key v';T.Key b;T.Key b']]
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum key converter should return key sequence expanded with state" =
   match Okeyfum_config.load "./config.okf" with
   | Some config ->
      let env = Okeyfum_environment.make config in
      let env = Okeyfum_environment.enable_converter env in
      let module C = Okeyfum_converter in
      let base = let module E = Okeyfum_types.Input_event in
                  {E.typ = GT.Event_type.ev_key;
                   code = Okeyfum_key.key_name_to_code "a" |> Okeyfum_util.option_get;
                   value = 0L;
                   time = Okeyfum_types.Timeval.empty;
                  } in
      let b = let module E = Okeyfum_types.Input_event in
              {base with E.code = Okeyfum_key.key_name_to_code "b" |> Okeyfum_util.option_get;
                value = 1L} in
      let b' = let module E = Okeyfum_types.Input_event in {b with E.value = 0L} in
      let v = let module E = Okeyfum_types.Input_event in
              {base with E.code = Okeyfum_key.key_name_to_code "v" |> Okeyfum_util.option_get;
                value = 1L;} in
      let v' = let module E = Okeyfum_types.Input_event in {v with E.value = 0L} in
      let keys = C.convert_event_to_seq ~config ~env ~event:base in
      let module T = Okeyfum_types in
      keys [@eq T.To_eval [T.Key b;T.Key b';T.Key v;T.Key v']]
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum key converter should be able to expand variable" =
   match Okeyfum_config.load "./config.okf" with
   | Some config ->
      let env = Okeyfum_environment.make config in
      let env = Okeyfum_environment.enable_converter env in
      let module C = Okeyfum_converter in
      let base = let module E = Okeyfum_types.Input_event in
                  {E.typ = GT.Event_type.ev_key;
                   code = Okeyfum_key.key_name_to_code "b" |> Okeyfum_util.option_get;
                   value = 1L;
                   time = Okeyfum_types.Timeval.empty;
                  } in
      let key_to_ev k v =
        let module E = Okeyfum_types.Input_event in
        {base with E.code = Okeyfum_key.key_name_to_code k |> Okeyfum_util.option_get;
          value = v} in
      let a = key_to_ev "a" 1L
      and b = key_to_ev "b" 1L
      and c = key_to_ev "c" 1L
      and d = key_to_ev "d" 1L in
      let a' = key_to_ev "a" 0L
      and b' = key_to_ev "b" 0L
      and c' = key_to_ev "c" 0L
      and d' = key_to_ev "d" 0L in
      let keys = C.convert_event_to_seq ~config ~env ~event:base in
      let module T = Okeyfum_types in
      keys [@eq T.To_eval [T.Key a;T.Key a';
                           T.Key b;T.Key b';
                           T.Key c;T.Key c';
                           T.Key d;T.Key d';
                           T.Key c;T.Key c']]
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum key converter should be able to expand pre-defined function" =
   match Okeyfum_config.load "./config.okf" with
   | Some config ->
      let env = Okeyfum_environment.make config in
      let env = Okeyfum_environment.enable_converter env in
      let module C = Okeyfum_converter in
      let base = let module E = Okeyfum_types.Input_event in
                  {E.typ = GT.Event_type.ev_key;
                   code = Okeyfum_key.key_name_to_code "e" |> Okeyfum_util.option_get;
                   value = 0L;
                   time = Okeyfum_types.Timeval.empty;
                  } in
      let keys = C.convert_event_to_seq ~config ~env ~event:base in
      let module T = Okeyfum_types in
      keys [@eq T.To_eval [T.Func ("&fun", ["c"])]]
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum key converter should resolve with locked key" =
   match Okeyfum_config.load "./config.okf" with
   | Some config ->
      let env = Okeyfum_environment.make config in
      let env = Okeyfum_environment.enable_converter env in
      let env = Okeyfum_environment.lock_state_lock ~env ~name:"b" in
      let module C = Okeyfum_converter in
      let base = let module E = Okeyfum_types.Input_event in
                  {E.typ = GT.Event_type.ev_key;
                   code = Okeyfum_key.key_name_to_code "a" |> Okeyfum_util.option_get;
                   value = 0L;
                   time = Okeyfum_types.Timeval.empty;
                  } in
      let key_to_ev k v =
        let module E = Okeyfum_types.Input_event in
        {base with E.code = Okeyfum_key.key_name_to_code k |> Okeyfum_util.option_get;value = v} in
      let c = key_to_ev "c" 1L in
      let c' = key_to_ev "c" 0L in
      let keys = C.convert_event_to_seq ~config ~env ~event:base in
      let module T = Okeyfum_types in
      keys [@eq T.To_eval [T.Key c;T.Key c']]
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum key converter should resolve function key" =
   match Okeyfum_config.load "./config.okf" with
   | Some config ->
      let env = Okeyfum_environment.make config in
      let module C = Okeyfum_converter in
      let base = let module E = Okeyfum_types.Input_event in
                  {E.typ = GT.Event_type.ev_key;
                   code = Okeyfum_key.key_name_to_code "f12" |> Okeyfum_util.option_get;
                   value = 1L;
                   time = Okeyfum_types.Timeval.empty;
                  } in
      let keys = C.convert_event_to_seq ~config ~env ~event:base in
      let module T = Okeyfum_types in
      keys [@eq T.To_eval [T.Func ("&enable", [])]]
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum key converter should resolve with muitiple locked key" =
   match Okeyfum_config.load "./config_multi.okf" with
   | Some config ->
      let env = Okeyfum_environment.make config in
      let env = Okeyfum_environment.enable_converter env in
      let env = Okeyfum_environment.lock_state_lock ~env ~name:"b" in
      let env = Okeyfum_environment.lock_state_lock ~env ~name:"a" in
      let module C = Okeyfum_converter in
      let base = let module E = Okeyfum_types.Input_event in
                  {E.typ = GT.Event_type.ev_key;
                   code = Okeyfum_key.key_name_to_code "a" |> Okeyfum_util.option_get;
                   value = 0L;
                   time = Okeyfum_types.Timeval.empty;
                  } in
      let key_to_ev k v =
        let module E = Okeyfum_types.Input_event in
        {base with E.code = Okeyfum_key.key_name_to_code k |> Okeyfum_util.option_get;value = v} in
      let c = key_to_ev "c" 1L in
      let c' = key_to_ev "c" 0L in
      let keys = C.convert_event_to_seq ~config ~env ~event:base in
      let module T = Okeyfum_types in
      keys [@eq T.To_eval [T.Key c;T.Key c']]
   | None -> false [@false "Loading failure"]
]
