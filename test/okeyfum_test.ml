let () =
  Alcotest.run "Okeyfum"
    [
      ("config", Config_test.tests);
      ("environment", Environment_test.tests);
      ("evaluator", Evaluator_test.tests);
      ("converter", Converter_test.tests);
    ]
