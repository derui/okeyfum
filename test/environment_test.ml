[%%suite

 let%spec "OKeyfum environment can change state of lock" =
   let module E = Okeyfum_environment in
   let e = E.make Okeyfum_config.Config.empty in
   let e = E.lock_state_lock ~env:e ~name:"foo" in
   (E.locked_keys e) [@eq ["foo"]];
   let e = E.lock_state_unlock ~env:e ~name:"foo" in
   (E.locked_keys e) [@eq []]
]
