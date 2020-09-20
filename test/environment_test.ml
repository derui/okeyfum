open Okeyfum

let tests =
  [
    ( "OKeyfum environment can change state of lock",
      `Quick,
      fun () ->
        let module E = Okeyfum_environment in
        let e = E.make Okeyfum_config.Config.empty in
        let e = E.lock_state_lock ~env:e ~name:"foo" in
        Alcotest.(check @@ list string) "state" [ "foo" ] (E.locked_keys e);
        let e = E.lock_state_unlock ~env:e ~name:"foo" in
        Alcotest.(check @@ list string) "state" [] (E.locked_keys e) );
  ]
