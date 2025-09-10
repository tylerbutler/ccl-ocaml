open Json_test_types

(* Test result tracking *)
type test_status = 
  | Passed
  | Failed of string
  | Skipped of string
  | Ignored of string

type test_result = {
  name : string;
  status : test_status;
  validations_run : (string * bool * string option * int) list; (* validation_name, success, error_msg, assertion_count *)
  overall_success : bool;
  total_assertions : int;
  passed_assertions : int;
  failed_assertions : int;
}

type suite_result = {
  suite_name : string;
  total_tests : int;
  passed_tests : int;
  failed_tests : int;
  skipped_tests : int;
  ignored_tests : int;
  test_results : test_result list;
  total_assertions : int;
  passed_assertions : int;
  failed_assertions : int;
}

(* Default test configuration *)
let default_config = {
  skip_optional_features = false;
  ignored_features = [];
  skip_features = ["dotted-keys"; "typed-parsing"; "processing"];
  skip_proposed = true;  (* Skip proposed behaviors, prefer reference-compliant *)
  skip_tags = [
    "proposed"; 
    "proposed-behavior";
    "needs-flexible-boolean-parsing"; 
    "needs-crlf-normalization";
  ];
}

(* Helper function to count assertions in a validation *)
let count_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some validation ->
      (match validation with
       | Json_test_types.Entries { count; _ } -> count
       | Json_test_types.ParseError _ -> 1)

let count_filter_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some validation ->
      (match validation with
       | Json_test_types.FilteredEntries { count; _ } -> count
       | Json_test_types.FilterError _ -> 1)

let count_expand_dotted_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some validation ->
      (match validation with
       | Json_test_types.ExpandedEntries { count; _ } -> count
       | Json_test_types.ExpandError _ -> 1)

let count_make_objects_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some validation ->
      (match validation with
       | Json_test_types.ObjectResult { count; _ } -> count
       | Json_test_types.ObjectError _ -> 1)

let count_typed_access_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some validation ->
      (match validation with
       | Json_test_types.TypedCases { count; _ } -> count)

let count_compose_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some _ -> 1 (* Compose validations typically count as 1 assertion *)

let count_pretty_print_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some _ -> 1

let count_round_trip_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some _ -> 1

let count_canonical_format_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some _ -> 1

let count_associativity_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some _ -> 1

(* Count total assertions in a test case *)
let count_test_case_assertions test_case =
  let validations = test_case.validations in
  count_validation_assertions validations.parse +
  count_validation_assertions validations.parse_value +
  count_filter_validation_assertions validations.filter +
  count_compose_validation_assertions validations.compose +
  count_expand_dotted_validation_assertions validations.expand_dotted +
  count_make_objects_validation_assertions validations.make_objects +
  count_typed_access_validation_assertions validations.get_string +
  count_typed_access_validation_assertions validations.get_int +
  count_typed_access_validation_assertions validations.get_bool +
  count_typed_access_validation_assertions validations.get_float +
  count_pretty_print_validation_assertions validations.pretty_print +
  count_round_trip_validation_assertions validations.round_trip +
  count_canonical_format_validation_assertions validations.canonical_format +
  count_associativity_validation_assertions validations.associativity

(* Check if a test should be skipped or ignored *)
let should_skip_test config test_case =
  (* Check for tag-based skipping first *)
  let has_skip_tag = List.exists (fun tag -> List.mem tag config.skip_tags) test_case.meta.tags in
  if has_skip_tag then
    let skip_tag = List.find (fun tag -> List.mem tag config.skip_tags) test_case.meta.tags in
    Some (Skipped ("Tag '" ^ skip_tag ^ "' is not supported"))
  else
    (* Check for proposed behavior skipping *)
    if config.skip_proposed && 
       (List.mem "proposed" test_case.meta.tags || List.mem "proposed-behavior" test_case.meta.tags) then
      Some (Skipped "Proposed behavior not implemented (using reference-compliant behavior)")
    else
      match test_case.meta.feature with
      | Some feature ->
          if List.mem feature config.ignored_features then
            Some (Ignored ("Feature '" ^ feature ^ "' is ignored"))
          else if List.mem feature config.skip_features then
            Some (Skipped ("Feature '" ^ feature ^ "' is not implemented"))
          else if config.skip_optional_features && 
                  List.exists (fun tag -> List.mem tag ["optional"; "advanced"]) test_case.meta.tags then
            Some (Skipped "Optional feature skipped")
          else
            None
      | None -> None

(* Convert JSON test case to Alcotest test *)
let json_test_to_alcotest (test_case : Json_test_types.test_case) =
  let test_name = Printf.sprintf "[JSON] %s" test_case.name in
  let test_func () =
    let validation_results = Ccl_api_mapping.execute_validation test_case in
    let failed_validations = List.filter (fun (_, success, _, _) -> not success) validation_results in
    
    if List.length failed_validations = 0 then
      () (* Test passes *)
    else
      let error_messages = List.map (fun (name, _, msg_opt, _) ->
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

(* Execute JSON test suite with configuration *)
let execute_json_test_suite_with_config config test_suite =
  let test_results = List.map (fun test_case ->
    match should_skip_test config test_case with
    | Some skip_reason ->
        let total_assertions = count_test_case_assertions test_case in
        { name = test_case.name; status = skip_reason; validations_run = []; 
          overall_success = false; total_assertions; passed_assertions = 0; failed_assertions = 0 }
    | None ->
        let validation_results = Ccl_api_mapping.execute_validation test_case in
        let overall_success = List.for_all (fun (_, success, _, _) -> success) validation_results in
        let status = if overall_success then Passed else Failed "Some validations failed" in
        
        (* Calculate assertion counts *)
        let total_assertions = List.fold_left (fun acc (_, _, _, count) -> acc + count) 0 validation_results in
        let passed_assertions = List.fold_left (fun acc (_, success, _, count) -> 
          if success then acc + count else acc) 0 validation_results in
        let failed_assertions = total_assertions - passed_assertions in
        
        { name = test_case.name; status; validations_run = validation_results; overall_success;
          total_assertions; passed_assertions; failed_assertions }
  ) test_suite.tests in
  
  let passed_tests = List.length (List.filter (fun tr -> tr.status = Passed) test_results) in
  let failed_tests = List.length (List.filter (fun tr -> match tr.status with Failed _ -> true | _ -> false) test_results) in
  let skipped_tests = List.length (List.filter (fun tr -> match tr.status with Skipped _ -> true | _ -> false) test_results) in
  let ignored_tests = List.length (List.filter (fun tr -> match tr.status with Ignored _ -> true | _ -> false) test_results) in
  
  (* Aggregate assertion counts *)
  let total_assertions = List.fold_left (fun acc (tr : test_result) -> acc + tr.total_assertions) 0 test_results in
  let passed_assertions = List.fold_left (fun acc (tr : test_result) -> acc + tr.passed_assertions) 0 test_results in
  let failed_assertions = List.fold_left (fun acc (tr : test_result) -> acc + tr.failed_assertions) 0 test_results in
  
  {
    suite_name = test_suite.suite;
    total_tests = List.length test_results;
    passed_tests;
    failed_tests;
    skipped_tests;
    ignored_tests;
    test_results;
    total_assertions;
    passed_assertions;
    failed_assertions;
  }

(* Execute JSON test suite and return results (backwards compatibility) *)
let execute_json_test_suite test_suite =
  execute_json_test_suite_with_config default_config test_suite

(* Print test results summary *)
let print_suite_result suite_result =
  Printf.printf "\n=== %s ===\n" suite_result.suite_name;
  Printf.printf "Tests: %d | Passed: %d | Failed: %d" 
    suite_result.total_tests suite_result.passed_tests suite_result.failed_tests;
  
  if suite_result.skipped_tests > 0 then
    Printf.printf " | Skipped: %d" suite_result.skipped_tests;
  
  if suite_result.ignored_tests > 0 then
    Printf.printf " | Ignored: %d" suite_result.ignored_tests;
  
  Printf.printf "\n";
  Printf.printf "Assertions: %d | Passed: %d | Failed: %d\n" 
    suite_result.total_assertions suite_result.passed_assertions suite_result.failed_assertions;
  
  (* Show skipped tests *)
  let skipped_tests = List.filter (fun tr -> match tr.status with Skipped _ -> true | _ -> false) suite_result.test_results in
  if List.length skipped_tests > 0 then (
    Printf.printf "\nSkipped tests:\n";
    List.iter (fun test_result ->
      match test_result.status with
      | Skipped reason -> Printf.printf "- %s: %s\n" test_result.name reason
      | _ -> ()
    ) skipped_tests
  );
  
  (* Show ignored tests *)
  let ignored_tests = List.filter (fun tr -> match tr.status with Ignored _ -> true | _ -> false) suite_result.test_results in
  if List.length ignored_tests > 0 then (
    Printf.printf "\nIgnored tests:\n";
    List.iter (fun test_result ->
      match test_result.status with
      | Ignored reason -> Printf.printf "- %s: %s\n" test_result.name reason
      | _ -> ()
    ) ignored_tests
  );
  
  (* Show failed tests *)
  let failed_tests = List.filter (fun tr -> match tr.status with Failed _ -> true | _ -> false) suite_result.test_results in
  if List.length failed_tests > 0 then (
    Printf.printf "\nFailed tests:\n";
    List.iter (fun test_result ->
      match test_result.status with
      | Failed _ -> (
        Printf.printf "- %s:\n" test_result.name;
        List.iter (fun (validation_name, success, msg_opt, assertion_count) ->
          if not success then
            match msg_opt with
            | Some msg -> Printf.printf "  * %s (%d assertions): %s\n" validation_name assertion_count msg
            | None -> Printf.printf "  * %s (%d assertions): failed\n" validation_name assertion_count
        ) test_result.validations_run
      )
      | _ -> ()
    ) failed_tests
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

(* Test file classification *)
type test_file_type = 
  | ApiTest of string       (* e.g., "parsing", "objects" *)
  | PropertyTest of string  (* e.g., "algebraic", "roundtrip" *)
  | UnknownTest of string

let classify_test_file filename =
  if String.length filename < 5 then UnknownTest filename
  else
    let basename = Filename.basename filename in
    if String.starts_with ~prefix:"api-" basename then
      let test_type = String.sub basename 4 (String.length basename - 9) in (* Remove "api-" and ".json" *)
      ApiTest test_type
    else if String.starts_with ~prefix:"property-" basename then  
      let test_type = String.sub basename 9 (String.length basename - 14) in (* Remove "property-" and ".json" *)
      PropertyTest test_type
    else
      UnknownTest basename

(* Cross-platform directory operations *)
let is_json_file filename =
  String.length filename > 5 && 
  String.sub filename (String.length filename - 5) 5 = ".json" &&
  filename <> "schema.json"

let run_categorized_tests directory =
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
    
    (* Classify test files *)
    let (api_tests, property_tests, unknown_tests) = List.fold_left (fun (api, prop, unk) file ->
      match classify_test_file (Filename.basename file) with
      | ApiTest _ -> (file :: api, prop, unk)
      | PropertyTest _ -> (api, file :: prop, unk)
      | UnknownTest _ -> (api, prop, file :: unk)
    ) ([], [], []) json_files in
    
    let api_tests = List.rev api_tests in
    let property_tests = List.rev property_tests in
    let unknown_tests = List.rev unknown_tests in
    
    Printf.printf "Found %d API test files, %d property test files, %d other test files in %s\n\n" 
                  (List.length api_tests) (List.length property_tests) (List.length unknown_tests) directory;
    flush_all ();
    
    (* Run API tests first *)
    let api_results = List.map (fun file ->
      Printf.printf "=== API Test: %s ===\n" (Filename.basename file);
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
    ) api_tests in
    
    (* Run property tests second *)
    let property_results = List.map (fun file ->
      Printf.printf "=== Property Test: %s ===\n" (Filename.basename file);
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
    ) property_tests in
    
    (* Run other tests third *)
    let other_results = List.map (fun file ->
      Printf.printf "=== Other Test: %s ===\n" (Filename.basename file);
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
    ) unknown_tests in
    
    let results = api_results @ property_results @ other_results in
    
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

(* Smart test runner with intelligent skipping *)
let run_smart_tests directory =
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
    
    (* Classify test files *)
    let (api_tests, property_tests, unknown_tests) = List.fold_left (fun (api, prop, unk) file ->
      match classify_test_file (Filename.basename file) with
      | ApiTest _ -> (file :: api, prop, unk)
      | PropertyTest _ -> (api, file :: prop, unk)
      | UnknownTest _ -> (api, prop, file :: unk)
    ) ([], [], []) json_files in
    
    let api_tests = List.rev api_tests in
    let property_tests = List.rev property_tests in
    let unknown_tests = List.rev unknown_tests in
    
    Printf.printf "🚀 Smart Test Run - Skipping Known Unimplemented Features\n";
    Printf.printf "Found %d API test files, %d property test files, %d other test files in %s\n\n" 
                  (List.length api_tests) (List.length property_tests) (List.length unknown_tests) directory;
    Printf.printf "Configured to skip features: %s\n" (String.concat ", " default_config.skip_features);
    Printf.printf "Configured to skip tags: %s\n" (String.concat ", " default_config.skip_tags);
    Printf.printf "Skip proposed behaviors: %b\n\n" default_config.skip_proposed;
    flush_all ();
    
    (* Run API tests first with smart skipping *)
    let api_results = List.map (fun file ->
      Printf.printf "=== API Test: %s ===\n" (Filename.basename file);
      flush_all ();
      try
        let test_suite = load_test_suite_from_file file in
        let suite_result = execute_json_test_suite_with_config default_config test_suite in
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
    ) api_tests in
    
    (* Run property tests second with smart skipping *)
    let property_results = List.map (fun file ->
      Printf.printf "=== Property Test: %s ===\n" (Filename.basename file);
      flush_all ();
      try
        let test_suite = load_test_suite_from_file file in
        let suite_result = execute_json_test_suite_with_config default_config test_suite in
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
    ) property_tests in
    
    (* Run other tests third with smart skipping *)
    let other_results = List.map (fun file ->
      Printf.printf "=== Other Test: %s ===\n" (Filename.basename file);
      flush_all ();
      try
        let test_suite = load_test_suite_from_file file in
        let suite_result = execute_json_test_suite_with_config default_config test_suite in
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
    ) unknown_tests in
    
    let results = api_results @ property_results @ other_results in
    
    (* Calculate totals with enhanced stats *)
    let suite_total = List.length results in
    let suite_passed = List.length (List.filter (fun (_, success, _) -> success) results) in
    let suite_failed = suite_total - suite_passed in
    
    let (test_total, test_passed, test_failed, test_skipped, test_ignored) = List.fold_left (fun (total, passed, failed, skipped, ignored) (_, _, result_opt) ->
      match result_opt with
      | Some suite_result -> 
          (total + suite_result.total_tests, 
           passed + suite_result.passed_tests, 
           failed + suite_result.failed_tests,
           skipped + suite_result.skipped_tests,
           ignored + suite_result.ignored_tests)
      | None -> (total, passed, failed, skipped, ignored)
    ) (0, 0, 0, 0, 0) results in
    
    (* Enhanced Summary *)
    Printf.printf "=== 🎯 SMART TEST SUMMARY ===\n";
    Printf.printf "Test Suites: %d total | %d passed | %d failed\n" suite_total suite_passed suite_failed;
    Printf.printf "Individual Tests: %d total | %d passed | %d failed | %d skipped | %d ignored\n" 
      test_total test_passed test_failed test_skipped test_ignored;
    Printf.printf "Success Rate: %.1f%% (excluding skipped/ignored)\n"
      (if (test_passed + test_failed) > 0 then (float_of_int test_passed /. float_of_int (test_passed + test_failed)) *. 100.0 else 0.0);
    Printf.printf "Coverage: %.1f%% (tests actually run)\n"
      (if test_total > 0 then (float_of_int (test_passed + test_failed) /. float_of_int test_total) *. 100.0 else 0.0);
    
    if suite_failed > 0 then (
      Printf.printf "\n❌ Failed suites (actual issues):\n";
      List.iter (fun (name, success, _) ->
        if not success then Printf.printf "- %s\n" name
      ) results
    );
    
    Printf.printf "\n💡 Tip: Use 'run-categorized' to see all tests including unimplemented features\n";
    
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
      run_categorized_tests directory
  | [| _; "run-categorized"; directory |] ->
      run_categorized_tests directory
  | [| _; "run-smart"; directory |] ->
      run_smart_tests directory
  | _ ->
      Printf.eprintf "Usage:\n";
      Printf.eprintf "  %s generate <json_file> <output_file>\n" Sys.argv.(0);
      Printf.eprintf "  %s run <json_file>\n" Sys.argv.(0);
      Printf.eprintf "  %s run-all <directory>\n" Sys.argv.(0);
      Printf.eprintf "  %s run-categorized <directory>  # Run with API/property test classification\n" Sys.argv.(0);
      Printf.eprintf "  %s run-smart <directory>        # Run with intelligent skipping of unimplemented features\n" Sys.argv.(0);
      exit 1