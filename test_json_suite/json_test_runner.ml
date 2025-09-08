open Json_test_types

(* Test result tracking *)
type test_result = {
  name : string;
  validations_run : (string * bool * string option) list;
  overall_success : bool;
}

type suite_result = {
  suite_name : string;
  total_tests : int;
  passed_tests : int;
  failed_tests : int;
  test_results : test_result list;
}

(* Convert JSON test case to Alcotest test *)
let json_test_to_alcotest (test_case : Json_test_types.test_case) =
  let test_name = Printf.sprintf "[JSON] %s" test_case.name in
  let test_func () =
    let validation_results = Ccl_api_mapping.execute_validation test_case in
    let failed_validations = List.filter (fun (_, success, _) -> not success) validation_results in
    
    if List.length failed_validations = 0 then
      () (* Test passes *)
    else
      let error_messages = List.map (fun (name, _, msg_opt) ->
        match msg_opt with
        | Some msg -> Printf.sprintf "%s: %s" name msg
        | None -> Printf.sprintf "%s: failed" name
      ) failed_validations in
      let combined_error = String.concat "; " error_messages in
      Alcotest.fail combined_error
  in
  Alcotest.test_case test_name `Quick test_func

(* Generate Alcotest test list from JSON test suite *)
let generate_alcotest_from_json_suite test_suite =
  let suite_name = test_suite.suite in
  let tests = List.map json_test_to_alcotest test_suite.tests in
  (suite_name, tests)

(* Execute JSON test suite and return results *)
let execute_json_test_suite test_suite =
  let test_results = List.map (fun test_case ->
    let validation_results = Ccl_api_mapping.execute_validation test_case in
    let overall_success = List.for_all (fun (_, success, _) -> success) validation_results in
    { name = test_case.name; validations_run = validation_results; overall_success }
  ) test_suite.tests in
  
  let passed_tests = List.length (List.filter (fun tr -> tr.overall_success) test_results) in
  let failed_tests = List.length test_results - passed_tests in
  
  {
    suite_name = test_suite.suite;
    total_tests = List.length test_results;
    passed_tests;
    failed_tests;
    test_results;
  }

(* Print test results summary *)
let print_suite_result suite_result =
  Printf.printf "\n=== %s ===\n" suite_result.suite_name;
  Printf.printf "Total: %d | Passed: %d | Failed: %d\n"
    suite_result.total_tests suite_result.passed_tests suite_result.failed_tests;
  
  if suite_result.failed_tests > 0 then (
    Printf.printf "\nFailed tests:\n";
    List.iter (fun test_result ->
      if not test_result.overall_success then (
        Printf.printf "- %s:\n" test_result.name;
        List.iter (fun (validation_name, success, msg_opt) ->
          if not success then
            match msg_opt with
            | Some msg -> Printf.printf "  * %s: %s\n" validation_name msg
            | None -> Printf.printf "  * %s: failed\n" validation_name
        ) test_result.validations_run
      )
    ) suite_result.test_results
  )

(* Helper function for marshaling test cases to OCaml *)
let marshal_test_case_to_ocaml (test_case : Json_test_types.test_case) =
  (* This is a simplified marshaling - in practice would need full OCaml syntax generation *)
  Printf.sprintf {|{
  name = "%s";
  input = %s;
  input1 = %s; 
  input2 = %s;
  input3 = %s;
  validations = { (* TODO: marshal validations *) };
  meta = { tags = [%s]; level = %d; feature = %s; difficulty = %s };
}|} 
    test_case.name
    (match test_case.input with Some s -> "Some \"" ^ String.escaped s ^ "\"" | None -> "None")
    (match test_case.input1 with Some s -> "Some \"" ^ String.escaped s ^ "\"" | None -> "None")
    (match test_case.input2 with Some s -> "Some \"" ^ String.escaped s ^ "\"" | None -> "None") 
    (match test_case.input3 with Some s -> "Some \"" ^ String.escaped s ^ "\"" | None -> "None")
    (String.concat "; " (List.map (fun tag -> "\"" ^ tag ^ "\"") test_case.meta.tags))
    test_case.meta.level
    (match test_case.meta.feature with Some f -> "Some \"" ^ f ^ "\"" | None -> "None")
    (match test_case.meta.difficulty with Some d -> "Some \"" ^ d ^ "\"" | None -> "None")

(* Generate OCaml test file content from JSON test suite *)
let generate_test_file_content (test_suite : Json_test_types.test_suite) =
  let suite_name = test_suite.suite in
  
  let test_functions = List.mapi (fun i (test_case : Json_test_types.test_case) ->
    let test_func_name = Printf.sprintf "test_%d_%s" i 
      (String.map (function 'A'..'Z' | 'a'..'z' | '0'..'9' | '_' as c -> c | _ -> '_') test_case.name) in
    Printf.sprintf {|
let %s () =
  let test_case = %s in
  let validation_results = Ccl_api_mapping.execute_validation test_case in
  let failed_validations = List.filter (fun (_, success, _) -> not success) validation_results in
  if List.length failed_validations = 0 then
    ()
  else
    let error_messages = List.map (fun (name, _, msg_opt) ->
      match msg_opt with
      | Some msg -> Printf.sprintf "%%s: %%s" name msg
      | None -> Printf.sprintf "%%s: failed" name
    ) failed_validations in
    let combined_error = String.concat "; " error_messages in
    Alcotest.fail combined_error
|} test_func_name (marshal_test_case_to_ocaml test_case)
  ) test_suite.tests in

  let test_list = List.mapi (fun i (test_case : Json_test_types.test_case) ->
    let test_func_name = Printf.sprintf "test_%d_%s" i 
      (String.map (function 'A'..'Z' | 'a'..'z' | '0'..'9' | '_' as c -> c | _ -> '_') test_case.name) in
    Printf.sprintf {|    Alcotest.test_case "[JSON] %s" `Quick %s;|} test_case.name test_func_name
  ) test_suite.tests in

  Printf.sprintf {|
(* Generated test file for: %s *)
open Json_test_types

%s

let tests = [
%s
]

let () = Alcotest.run "%s" [("%s", tests)]
|} suite_name 
   (String.concat "\n" test_functions)
   (String.concat "\n" test_list)
   suite_name suite_name

(* Command line interface *)
let generate_test_file json_filename output_filename =
  try
    let test_suite = load_test_suite_from_file json_filename in
    let content = generate_test_file_content test_suite in
    let oc = open_out output_filename in
    output_string oc content;
    close_out oc;
    Printf.printf "Generated test file: %s\n" output_filename
  with
  | exn -> 
    Printf.eprintf "Error generating test file: %s\n" (Printexc.to_string exn);
    exit 1

let run_test_file json_filename =
  try
    let test_suite = load_test_suite_from_file json_filename in
    let suite_result = execute_json_test_suite test_suite in
    print_suite_result suite_result;
    if suite_result.failed_tests > 0 then exit 1 else exit 0
  with
  | exn ->
    Printf.eprintf "Error running tests: %s\n" (Printexc.to_string exn);
    exit 1

(* Cross-platform directory operations *)
let is_json_file filename =
  String.length filename > 5 && 
  String.sub filename (String.length filename - 5) 5 = ".json" &&
  filename <> "schema.json"

let run_directory_tests directory =
  try
    let files = Sys.readdir directory in
    let json_files = Array.to_list files 
                   |> List.filter is_json_file 
                   |> List.map (Filename.concat directory)
                   |> List.sort String.compare in
    
    if List.length json_files = 0 then (
      Printf.eprintf "No JSON test files found in directory: %s\n" directory;
      exit 1
    );
    
    Printf.printf "Found %d JSON test files in %s\n\n" (List.length json_files) directory;
    flush_all ();
    
    let results = List.map (fun file ->
      Printf.printf "=== Running %s ===\n" (Filename.basename file);
      flush_all ();
      try
        let test_suite = load_test_suite_from_file file in
        let suite_result = execute_json_test_suite test_suite in
        print_suite_result suite_result;
        Printf.printf "\n";
        flush_all ();
        (Filename.basename file, suite_result.failed_tests = 0, Some suite_result)
      with
      | exn -> 
        Printf.eprintf "Error running %s: %s\n" file (Printexc.to_string exn);
        Printf.printf "\n";
        flush_all ();
        (Filename.basename file, false, None)
    ) json_files in
    
    (* Calculate totals *)
    let suite_total = List.length results in
    let suite_passed = List.length (List.filter (fun (_, success, _) -> success) results) in
    let suite_failed = suite_total - suite_passed in
    
    let (test_total, test_passed, test_failed) = List.fold_left (fun (total, passed, failed) (_, _, result_opt) ->
      match result_opt with
      | Some suite_result -> 
          (total + suite_result.total_tests, 
           passed + suite_result.passed_tests, 
           failed + suite_result.failed_tests)
      | None -> (total, passed, failed)
    ) (0, 0, 0) results in
    
    (* Summary *)
    Printf.printf "=== OVERALL SUMMARY ===\n";
    Printf.printf "Test Suites: %d total | %d passed | %d failed\n" suite_total suite_passed suite_failed;
    Printf.printf "Individual Tests: %d total | %d passed | %d failed (%.1f%% success)\n" 
      test_total test_passed test_failed 
      (if test_total > 0 then (float_of_int test_passed /. float_of_int test_total) *. 100.0 else 0.0);
    
    if suite_failed > 0 then (
      Printf.printf "\nFailed suites:\n";
      List.iter (fun (name, success, _) ->
        if not success then Printf.printf "- %s\n" name
      ) results
    );
    
    exit (if suite_failed = 0 then 0 else 1)
    
  with
  | Sys_error msg ->
    Printf.eprintf "Error reading directory %s: %s\n" directory msg;
    exit 1

(* Main CLI function - to be called from test_json_suite.ml *)
let main () =
  match Sys.argv with
  | [| _; "generate"; json_file; output_file |] ->
      generate_test_file json_file output_file
  | [| _; "run"; json_file |] ->
      run_test_file json_file
  | [| _; "run-all"; directory |] ->
      run_directory_tests directory
  | _ ->
      Printf.eprintf "Usage:\n";
      Printf.eprintf "  %s generate <json_file> <output_file>\n" Sys.argv.(0);
      Printf.eprintf "  %s run <json_file>\n" Sys.argv.(0);
      Printf.eprintf "  %s run-all <directory>\n" Sys.argv.(0);
      exit 1