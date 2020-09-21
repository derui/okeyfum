open Okeyfum

let tests =
  [
    ( "OKeyfum configuration loader can load a config",
      `Quick,
      fun () ->
        let conf = Okeyfum_config.load "./config.okf" in
        Alcotest.(check @@ bool) "loading" true (Option.is_some conf) );
    ( "OKeyfum can build configuration from a file",
      `Quick,
      fun () ->
        let conf = Okeyfum_config.load "./config.okf" in
        let module M = Okeyfum_config.Keydef_map in
        let ret =
          Option.map (fun c -> Okeyfum_config.(M.mem ("sample", `UP) (Config.keydef_map c))) conf
          |> Option.value ~default:false
        in
        Alcotest.(check bool) "key def" true ret );
    ( "OKeyfum config should give lock definition",
      `Quick,
      fun () ->
        let conf = Okeyfum_config.load "./config.okf" in
        let module M = Okeyfum_config.Keydef_map in
        let ret =
          Option.map (fun c -> Okeyfum_config.(List.mem "b" (Config.lock_defs c))) conf |> Option.value ~default:false
        in
        Alcotest.(check bool) "lock def" true ret );
    ( "OKeyfum config should give locked declaration",
      `Quick,
      fun () ->
        let conf = Okeyfum_config.load "./config.okf" in
        match conf with
        | Some c ->
            let dec = List.hd Okeyfum_config.(Config.lock_decls c) |> snd in
            let module M = Okeyfum_config.Keydef_map in
            let ret = M.find ("a", `UP) dec in
            Alcotest.(check @@ list @@ of_pp Fmt.nop) "locked decls" [ `Id "c" ] ret
        | None   -> Alcotest.fail "failed" );
    ( "OKeyfum config should give variable definition",
      `Quick,
      fun () ->
        let conf = Okeyfum_config.load "./config.okf" in
        match conf with
        | Some c ->
            let ret = Okeyfum_config.(Hashtbl.find (Config.variable_map c) "$var_name") in
            Alcotest.(check @@ list @@ of_pp Fmt.nop) "variable defs" [ `Id "a"; `Id "b"; `Id "c"; `Id "d" ] ret
        | None   -> Alcotest.fail "fail" );
    ( "OKeyfum config should be able to contain variable and function in sequence",
      `Quick,
      fun () ->
        let conf = Okeyfum_config.load "./config.okf" in
        match conf with
        | Some c ->
            let module M = Okeyfum_config.Keydef_map in
            let seq = Okeyfum_config.(M.find ("d", `UP) (Config.keydef_map c)) in
            Alcotest.(check @@ list @@ of_pp Fmt.nop) "sequence" [ `Var "$a"; `Func ("&fun", [ "b" ]) ] seq
        | None   -> Alcotest.fail "failed" );
  ]
