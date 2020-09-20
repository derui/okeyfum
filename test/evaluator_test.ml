open Okeyfum
module GT = Okeyfum_c_type_description.Types (Okeyfum_c.Okeyfum_c_generated_types)

let tests =
  [
    ( "OKeyfum sequence evaluator should return key event",
      `Quick,
      fun () ->
        match Okeyfum_config.load "./config.okf" with
        | Some config ->
            let env = Okeyfum_environment.make config in
            let module E = Okeyfum_evaluator in
            let event =
              let module I = Okeyfum_types.Input_event in
              {
                I.typ = GT.Event_type.ev_key;
                code = Okeyfum_key.key_name_to_code "a" |> Okeyfum_util.option_get;
                value = 1L;
                time = Okeyfum_types.Timeval.empty;
              }
            in
            let syn =
              let module I = Okeyfum_types.Input_event in
              { I.empty with I.typ = GT.Event_type.ev_syn; code = GT.Input_syn.report; value = 0L }
            in
            let keys = E.eval_key_seq ~env ~seq:[ Okeyfum_types.Key event ] in
            Alcotest.(check @@ of_pp Fmt.nop) "key event" (env, [ event; syn ]) keys
        | None        -> Alcotest.fail "failed" );
    ( "OKeyfum sequence evaluator should evaluate function in sequence",
      `Quick,
      fun () ->
        match Okeyfum_config.load "./config.okf" with
        | Some config ->
            let env = Okeyfum_environment.make config in
            let module E = Okeyfum_evaluator in
            let event =
              let module I = Okeyfum_types.Input_event in
              {
                I.typ = GT.Event_type.ev_key;
                code = Okeyfum_key.key_name_to_code "a" |> Okeyfum_util.option_get;
                value = 1L;
                time = Okeyfum_types.Timeval.empty;
              }
            in
            let module T = Okeyfum_types in
            let env, _ = E.eval_key_seq ~env ~seq:[ T.Key event; T.Func ("&enable", []) ] in
            Alcotest.(check bool) "enabled" true @@ Okeyfum_environment.is_enable env
        | None        -> Alcotest.fail "failed" );
    ( "OKeyfum sequence evaluator should be able to change lock state",
      `Quick,
      fun () ->
        match Okeyfum_config.load "./config.okf" with
        | Some config ->
            let env = Okeyfum_environment.make config in
            let module E = Okeyfum_evaluator in
            let module T = Okeyfum_types in
            let env, evs = E.eval_key_seq ~env ~seq:[ T.Func ("&enable", []); T.Func ("&lock", [ "b" ]) ] in
            Alcotest.(check @@ list @@ of_pp Fmt.nop) "event" [] evs;
            Alcotest.(check bool) "enabled" true @@ Okeyfum_environment.is_enable env;
            Alcotest.(check @@ list string) "locked keys" [ "b" ] @@ Okeyfum_environment.locked_keys env
        | None        -> Alcotest.fail "failed" );
  ]
