[%%suite
 let%spec "OKeyfum configuration loader can load a config" =
   let conf = Okeyfum_config.load "./config.okf" in
   match conf with
   | Some _ -> true [@true "Loading succeess"]
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum can build configuration from a file" =
   let conf = Okeyfum_config.load "./config.okf" in
   match conf with
   | Some c -> begin
     let module M = Okeyfum_config.Keydef_map in
     Okeyfum_config.(M.mem ("sample", `UP) (Config.keydef_map c)) [@true "Found key def"]
   end
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum config should give lock definition" =
   let conf = Okeyfum_config.load "./config.okf" in
   match conf with
   | Some c -> begin
     Okeyfum_config.(List.mem "b" (Config.lock_defs c)) [@true "Found lock def"]
   end
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum config should give locked declaration" =
   let conf = Okeyfum_config.load "./config.okf" in
   match conf with
   | Some c -> begin
     let dec = List.assoc "b" Okeyfum_config.(Config.lock_decls c) in
     let module M = Okeyfum_config.Keydef_map in
     Okeyfum_config.(M.find ("a", `UP) dec) [@eq [`Id "c"]]
   end
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum config should give variable definition" =
   let conf = Okeyfum_config.load "./config.okf" in
   match conf with
   | Some c -> begin
     Okeyfum_config.(Hashtbl.find (Config.variable_map c) "$var_name") [@eq [`Id "a";`Id "b";`Id "c";`Id "d"]]
   end
   | None -> false [@false "Loading failure"]

 let%spec "OKeyfum config should be able to contain variable and function in sequence" =
   let conf = Okeyfum_config.load "./config.okf" in
   match conf with
   | Some c -> begin
     let module M = Okeyfum_config.Keydef_map in
     let seq = Okeyfum_config.(M.find ("d", `UP) (Config.keydef_map c)) in
     seq [@eq [`Var "$a";`Func ("&fun", ["b"])]]
   end
   | None -> false [@false "Loading failure"]
]
