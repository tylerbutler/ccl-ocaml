open Json_test_types

(* Convert hyphens to underscores for consistency with config *)
let normalize_tag_name tag_name =
  String.map (function '-' -> '_' | c -> c) tag_name

(* Helper for string prefix checking *)
let starts_with_prefix prefix s = 
  String.length s >= String.length prefix &&
  String.sub s 0 (String.length prefix) = prefix

(* Extract available capabilities from JSON test files *)
let extract_capabilities_from_tests test_suites =
  let all_functions = ref [] in
  let all_features = ref [] in
  let all_behaviors = ref [] in
  let all_variants = ref [] in
  
  List.iter (fun test_suite ->
    List.iter (fun test_case ->
      List.iter (fun tag ->
        if starts_with_prefix "function:" tag then (
          let func = String.sub tag 9 (String.length tag - 9) |> normalize_tag_name in
          if not (List.mem func !all_functions) then
            all_functions := func :: !all_functions
        ) else if starts_with_prefix "feature:" tag then (
          let feature = String.sub tag 8 (String.length tag - 8) |> normalize_tag_name in
          if not (List.mem feature !all_features) then
            all_features := feature :: !all_features
        ) else if starts_with_prefix "behavior:" tag then (
          let behavior = String.sub tag 9 (String.length tag - 9) |> normalize_tag_name in
          if not (List.mem behavior !all_behaviors) then
            all_behaviors := behavior :: !all_behaviors
        ) else if starts_with_prefix "variant:" tag then (
          let variant = String.sub tag 8 (String.length tag - 8) |> normalize_tag_name in
          if not (List.mem variant !all_variants) then
            all_variants := variant :: !all_variants
        )
      ) test_case.meta.tags
    ) test_suite.tests
  ) test_suites;
  
  let result = (List.sort String.compare !all_functions,
                List.sort String.compare !all_features,
                List.sort String.compare !all_behaviors,
                List.sort String.compare !all_variants) in
  result

(* Test result tracking *)
type skip_category = 
  | KnownIssue
  | UnimplementedFunction of string
  | UnsupportedBehavior of string  
  | UnsupportedVariant of string
  | LegacyTag of string

type test_status = 
  | Passed
  | Failed of string
  | Skipped of skip_category * string
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

(* Test configuration - OCaml mock implementation capabilities *)
let default_config = {
  skip_tests = [
    (* Known bugs in implementation *)
    "round_trip_multiline_values";
    "canonical_format_line_endings_reference_behavior";
  ];
  skip_functions = [
    "expand_dotted"  (* Function not implemented yet *)
  ];  (* Implemented: parse, filter, compose, pretty_print, make_objects, get_string/int/bool/float/list *)
  skip_features = [
    (* Optional language features not implemented *)
  ];
  skip_behaviors = [
    "boolean_lenient"  (* Use strict boolean parsing only *)
  ];  (* Supported: strict_spacing, tabs_preserve, crlf_preserve_literal *)
  skip_variants = [
    "proposed_behavior"  (* Use reference_compliant behavior only *)
  ];
}

(* Helper function to count assertions in a validation - respects JSON count fields *)
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

(* Fixed: All validation counting now respects actual type definitions *)
let count_compose_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some validation ->
      (match validation with
       | Json_test_types.CompositionResult _ -> 1  (* Single composition test *)
       | Json_test_types.ComposeError _ -> 1)

let count_pretty_print_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some validation ->
      (match validation with
       | Json_test_types.PrettyResult _ -> 1  (* Single pretty print test *)
       | Json_test_types.PrettyError _ -> 1)

let count_round_trip_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some _ -> 1  (* Single round trip test *)

let count_canonical_format_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some _ -> 1  (* Single canonical format test *)

let count_associativity_validation_assertions validation_opt =
  match validation_opt with
  | None -> 0
  | Some _ -> 1  (* Single associativity test *)

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
  count_typed_access_validation_assertions validations.get_list +
  count_pretty_print_validation_assertions validations.pretty_print +
  count_round_trip_validation_assertions validations.round_trip +
  count_canonical_format_validation_assertions validations.canonical_format +
  count_associativity_validation_assertions validations.associativity

(* Helper functions for structured tag analysis *)
let extract_function_tags tags = List.filter (fun tag -> starts_with_prefix "function:" tag) tags
let extract_feature_tags tags = List.filter (fun tag -> starts_with_prefix "feature:" tag) tags
let extract_behavior_tags tags = List.filter (fun tag -> starts_with_prefix "behavior:" tag) tags
let extract_variant_tags tags = List.filter (fun tag -> starts_with_prefix "variant:" tag) tags

(* Check if a test should be skipped or ignored with structured filtering only *)
let should_skip_test config test_case =
  let tags = test_case.meta.tags in
  
  (* 0. Check for explicit test name skipping first *)
  if List.mem test_case.name config.skip_tests then
    Some (Skipped (KnownIssue, "Test '" ^ test_case.name ^ "' is skipped (known issue)"))
  else
  
  (* Extract structured tag categories *)
  let function_tags = extract_function_tags tags in
  let feature_tags = extract_feature_tags tags in  (* Now implemented *)
  let behavior_tags = extract_behavior_tags tags in
  let variant_tags = extract_variant_tags tags in
  
  (* 1. Check function requirements - skip if any required function is not implemented *)
  let required_functions = List.map (fun tag -> 
    String.sub tag 9 (String.length tag - 9) |> normalize_tag_name (* Remove "function:" prefix and normalize *)
  ) function_tags in
  let has_unimplemented_function = List.exists (fun func -> List.mem func config.skip_functions) required_functions in
  if has_unimplemented_function then
    let unimpl_func = List.find (fun func -> List.mem func config.skip_functions) required_functions in
    Some (Skipped (UnimplementedFunction unimpl_func, "Function '" ^ unimpl_func ^ "' is not implemented"))
  else

  (* 2. Check feature requirements - skip if test requires unsupported feature *)
  let required_features = List.map (fun tag ->
    String.sub tag 8 (String.length tag - 8) |> normalize_tag_name (* Remove "feature:" prefix and normalize *)
  ) feature_tags in
  let has_unsupported_feature = List.exists (fun feat -> List.mem feat config.skip_features) required_features in
  if has_unsupported_feature then
    let unsup_feat = List.find (fun feat -> List.mem feat config.skip_features) required_features in
    Some (Skipped (UnimplementedFunction unsup_feat, "Feature '" ^ unsup_feat ^ "' is not implemented"))
  else

  (* 3. Check behavior requirements - skip if test requires unsupported behavior *)  
  let required_behaviors = List.map (fun tag ->
    String.sub tag 9 (String.length tag - 9) |> normalize_tag_name (* Remove "behavior:" prefix and normalize *)
  ) behavior_tags in
  let has_unsupported_behavior = List.exists (fun behav -> List.mem behav config.skip_behaviors) required_behaviors in
  if has_unsupported_behavior then
    let unsup_behav = List.find (fun behav -> List.mem behav config.skip_behaviors) required_behaviors in
    Some (Skipped (UnsupportedBehavior unsup_behav, "Behavior '" ^ unsup_behav ^ "' is not supported"))
  else

  (* 4. Check variant requirements - skip if test requires unsupported variant *)
  let required_variants = List.map (fun tag ->
    String.sub tag 8 (String.length tag - 8) |> normalize_tag_name (* Remove "variant:" prefix and normalize *)
  ) variant_tags in
  let has_unsupported_variant = List.exists (fun var -> List.mem var config.skip_variants) required_variants in
  if has_unsupported_variant then
    let unsup_var = List.find (fun var -> List.mem var config.skip_variants) required_variants in
    Some (Skipped (UnsupportedVariant unsup_var, "Variant '" ^ unsup_var ^ "' is not supported"))
  else
    None  (* All checks passed, test should run *)

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
  let skipped_tests = List.length (List.filter (fun tr -> match tr.status with Skipped (_, _) -> true | _ -> false) test_results) in
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
let print_suite_result ?file_name ?description suite_result =
  Printf.printf "\n=== %s" suite_result.suite_name;
  (match file_name with
   | Some fname -> Printf.printf " (%s)" fname
   | None -> ());
  Printf.printf " ===\n";
  (match description with
   | Some desc -> Printf.printf "%s\n" desc
   | None -> ());
  Printf.printf "Tests: %d | Passed: %d | Failed: %d" 
    suite_result.total_tests suite_result.passed_tests suite_result.failed_tests;
  
  if suite_result.skipped_tests > 0 then
    Printf.printf " | Skipped: %d" suite_result.skipped_tests;
  
  if suite_result.ignored_tests > 0 then
    Printf.printf " | Ignored: %d" suite_result.ignored_tests;
  
  Printf.printf "\n";
  Printf.printf "Assertions: %d | Passed: %d | Failed: %d\n" 
    suite_result.total_assertions suite_result.passed_assertions suite_result.failed_assertions;
  
  (* Show skipped tests grouped by category *)
  let skipped_tests = List.filter (fun tr -> match tr.status with Skipped (_, _) -> true | _ -> false) suite_result.test_results in
  if List.length skipped_tests > 0 then (
    let show_grouped_skipped_tests skipped_tests =
      (* ANSI color codes *)
      let bold = "\027[1m" in
      let reset = "\027[0m" in
      let yellow = "\027[33m" in
      let cyan = "\027[36m" in
      let blue = "\027[34m" in
      let magenta = "\027[35m" in
      let red = "\027[31m" in
      
      (* Group tests by skip category *)
      let known_issue_tests = ref [] in
      let unimpl_func_tests = ref [] in  
      let unsup_behavior_tests = ref [] in
      let unsup_variant_tests = ref [] in
      let legacy_tag_tests = ref [] in
      
      List.iter (fun test_result ->
        match test_result.status with
        | Skipped (KnownIssue, reason) -> 
            known_issue_tests := (test_result.name, reason) :: !known_issue_tests
        | Skipped (UnimplementedFunction func, reason) ->
            unimpl_func_tests := (test_result.name, reason, func) :: !unimpl_func_tests
        | Skipped (UnsupportedBehavior behavior, reason) ->
            unsup_behavior_tests := (test_result.name, reason, behavior) :: !unsup_behavior_tests  
        | Skipped (UnsupportedVariant variant, reason) ->
            unsup_variant_tests := (test_result.name, reason, variant) :: !unsup_variant_tests
        | Skipped (LegacyTag tag, reason) ->
            legacy_tag_tests := (test_result.name, reason, tag) :: !legacy_tag_tests
        | _ -> ()
      ) skipped_tests;
      
      Printf.printf "\n%s🚫 SKIPPED TESTS SUMMARY%s\n" bold reset;
      
      (* Known Issues *)
      if !known_issue_tests <> [] then (
        Printf.printf "\n%s%s🐛 Known Issues (bugs in implementation)%s\n" bold red reset;
        List.iter (fun (name, reason) ->
          Printf.printf "   %s• %s%s - %s\n" red name reset reason
        ) (List.rev !known_issue_tests)
      );
      
      (* Unimplemented Functions *)
      if !unimpl_func_tests <> [] then (
        Printf.printf "\n%s%s⚙️  Unimplemented Functions%s\n" bold yellow reset;
        let func_groups = List.fold_left (fun acc (name, reason, func) ->
          let existing = try List.assoc func acc with Not_found -> [] in
          (func, (name, reason) :: existing) :: (List.remove_assoc func acc)
        ) [] !unimpl_func_tests in
        List.iter (fun (func, tests) ->
          Printf.printf "   %s%sFunction: %s%s (%d tests)\n" bold yellow func reset (List.length tests);
          List.iter (fun (name, _reason) ->
            Printf.printf "     %s• %s%s\n" yellow name reset
          ) (List.rev tests)
        ) func_groups
      );
      
      (* Unsupported Behaviors *)
      if !unsup_behavior_tests <> [] then (
        Printf.printf "\n%s%s🔧 Unsupported Behaviors%s\n" bold cyan reset;
        let behavior_groups = List.fold_left (fun acc (name, reason, behavior) ->
          let existing = try List.assoc behavior acc with Not_found -> [] in
          (behavior, (name, reason) :: existing) :: (List.remove_assoc behavior acc)
        ) [] !unsup_behavior_tests in
        List.iter (fun (behavior, tests) ->
          Printf.printf "   %s%sBehavior: %s%s (%d tests)\n" bold cyan behavior reset (List.length tests);
          List.iter (fun (name, _reason) ->
            Printf.printf "     %s• %s%s\n" cyan name reset
          ) (List.rev tests)
        ) behavior_groups
      );
      
      (* Unsupported Variants *)
      if !unsup_variant_tests <> [] then (
        Printf.printf "\n%s%s🔀 Unsupported Variants%s\n" bold blue reset;
        let variant_groups = List.fold_left (fun acc (name, reason, variant) ->
          let existing = try List.assoc variant acc with Not_found -> [] in
          (variant, (name, reason) :: existing) :: (List.remove_assoc variant acc)
        ) [] !unsup_variant_tests in
        List.iter (fun (variant, tests) ->
          Printf.printf "   %s%sVariant: %s%s (%d tests)\n" bold blue variant reset (List.length tests);
          List.iter (fun (name, _reason) ->
            Printf.printf "     %s• %s%s\n" blue name reset
          ) (List.rev tests)
        ) variant_groups
      );
      
      (* Legacy Tags *)
      if !legacy_tag_tests <> [] then (
        Printf.printf "\n%s%s📜 Legacy Tags (deprecated)%s\n" bold magenta reset;
        let tag_groups = List.fold_left (fun acc (name, reason, tag) ->
          let existing = try List.assoc tag acc with Not_found -> [] in
          (tag, (name, reason) :: existing) :: (List.remove_assoc tag acc)
        ) [] !legacy_tag_tests in
        List.iter (fun (tag, tests) ->
          Printf.printf "   %s%sTag: %s%s (%d tests)\n" bold magenta tag reset (List.length tests);
          List.iter (fun (name, _reason) ->
            Printf.printf "     %s• %s%s\n" magenta name reset
          ) (List.rev tests)
        ) tag_groups
      )
    in
    show_grouped_skipped_tests skipped_tests
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
    print_suite_result ~file_name:(Filename.basename json_filename) ?description:test_suite.description suite_result;
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
      try
        let test_suite = load_test_suite_from_file file in
        let suite_result = execute_json_test_suite test_suite in
        print_suite_result ~file_name:(Printf.sprintf "API Test: %s" (Filename.basename file)) ?description:test_suite.description suite_result;
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
      try
        let test_suite = load_test_suite_from_file file in
        let suite_result = execute_json_test_suite test_suite in
        print_suite_result ~file_name:(Printf.sprintf "Property Test: %s" (Filename.basename file)) ?description:test_suite.description suite_result;
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
      try
        let test_suite = load_test_suite_from_file file in
        let suite_result = execute_json_test_suite test_suite in
        print_suite_result ~file_name:(Printf.sprintf "Other Test: %s" (Filename.basename file)) ?description:test_suite.description suite_result;
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

(* Analyze behavior-variant dependencies from test suites *)
let analyze_behavior_variant_dependencies test_suites =
  let behavior_variants = ref [] in
  
  List.iter (fun test_suite ->
    List.iter (fun test_case ->
      let behavior_tags = extract_behavior_tags test_case.meta.tags in
      let variant_tags = extract_variant_tags test_case.meta.tags in
      
      List.iter (fun behavior_tag ->
        let behavior = String.sub behavior_tag 9 (String.length behavior_tag - 9) |> normalize_tag_name in
        List.iter (fun variant_tag ->
          let variant = String.sub variant_tag 8 (String.length variant_tag - 8) |> normalize_tag_name in
          let key = (behavior, variant) in
          if not (List.mem key !behavior_variants) then
            behavior_variants := key :: !behavior_variants
        ) variant_tags
      ) behavior_tags
    ) test_suite.tests
  ) test_suites;
  
  !behavior_variants

(* Display capability status with color coding and variant dependency analysis *)
let display_capability_status_with_dependencies config (all_functions, all_features, all_behaviors, all_variants) test_suites =
  let bold = "\027[1m" in
  let reset = "\027[0m" in
  let green = "\027[32m" in
  let red = "\027[31m" in
  let dim = "\027[2m" in
  
  (* Analyze behavior-variant dependencies *)
  let behavior_variant_deps = analyze_behavior_variant_dependencies test_suites in
  
  let format_capability_list all_items skip_items =
    List.map (fun item ->
      if List.mem item skip_items then
        Printf.sprintf "%s%s%s%s" red dim item reset
      else
        Printf.sprintf "%s%s%s%s" bold green item reset
    ) all_items
  in
  
  (* Enhanced behavior formatting that considers variant dependencies *)
  let yellow = "\027[33m" in
  let format_behavior_list all_behaviors skip_behaviors skip_variants =
    List.map (fun behavior ->
      if List.mem behavior skip_behaviors then
        (* Explicitly disabled behavior - red *)
        Printf.sprintf "%s%s%s%s" red dim behavior reset
      else
        (* Check if behavior only exists in disabled variants *)
        let behavior_variants = List.filter (fun (b, _) -> b = behavior) behavior_variant_deps in
        let available_variants = List.map snd behavior_variants in
        let enabled_variants = List.filter (fun v -> not (List.mem v skip_variants)) available_variants in
        
        if available_variants <> [] && enabled_variants = [] then
          (* Behavior has variants but they are ALL disabled - yellow (variant-dependent) *)
          Printf.sprintf "%s%s%s%s" yellow dim behavior reset
        else
          (* Behavior has at least one enabled variant OR has no variants (always available) *)
          Printf.sprintf "%s%s%s%s" bold green behavior reset
    ) all_behaviors
  in
  
  Printf.printf "%s🎯 CCL IMPLEMENTATION STATUS%s\n" bold reset;
  Printf.printf "\n%s📚 Functions:%s %s\n" bold reset 
    (String.concat " " (format_capability_list all_functions config.skip_functions));
  Printf.printf "%s🎨 Features:%s %s\n" bold reset 
    (String.concat " " (format_capability_list all_features config.skip_features));
  Printf.printf "%s⚙️  Behaviors:%s %s\n" bold reset 
    (String.concat " " (format_behavior_list all_behaviors config.skip_behaviors config.skip_variants));
  Printf.printf "%s🔀 Variants:%s %s\n" bold reset 
    (String.concat " " (format_capability_list all_variants config.skip_variants));
  Printf.printf "\n%s%s✅ Enabled%s | %s%s❌ Explicitly Disabled%s | %s%s⚠️ Variant-Dependent%s\n\n" bold green reset red dim reset yellow dim reset

(* Display capability status with color coding - backwards compatibility wrapper *)
let display_capability_status config capabilities =
  display_capability_status_with_dependencies config capabilities []

(* Display configuration settings *)
let display_configuration config =
  let bold = "\027[1m" in
  let reset = "\027[0m" in
  let dim = "\027[2m" in
  
  Printf.printf "%s⚙️  CONFIGURATION%s\n" bold reset;
  
  if List.length config.skip_tests > 0 then
    Printf.printf "%sSkipped Tests:%s %s\n" dim reset (String.concat ", " config.skip_tests);
  
  if List.length config.skip_functions > 0 then
    Printf.printf "%sSkipped Functions:%s %s\n" dim reset (String.concat ", " config.skip_functions);
  
  if List.length config.skip_features > 0 then
    Printf.printf "%sSkipped Features:%s %s\n" dim reset (String.concat ", " config.skip_features);
  
  if List.length config.skip_behaviors > 0 then
    Printf.printf "%sSkipped Behaviors:%s %s\n" dim reset (String.concat ", " config.skip_behaviors);
  
  if List.length config.skip_variants > 0 then
    Printf.printf "%sSkipped Variants:%s %s\n" dim reset (String.concat ", " config.skip_variants);
  
  Printf.printf "\n"

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
    
    (* Load all test suites to extract capabilities *)
    let all_test_suites = List.map load_test_suite_from_file (api_tests @ property_tests @ unknown_tests) in
    let capabilities = extract_capabilities_from_tests all_test_suites in
    
    Printf.printf "🚀 Smart Test Run - Progressive CCL Implementation\n";
    Printf.printf "Found %d API test files, %d property test files, %d other test files in %s\n\n" 
                  (List.length api_tests) (List.length property_tests) (List.length unknown_tests) directory;
    
    display_capability_status_with_dependencies default_config capabilities all_test_suites;
    flush_all ();
    
    (* Run API tests first with smart skipping *)
    let api_results = List.map (fun file ->
      try
        let test_suite = load_test_suite_from_file file in
        let suite_result = execute_json_test_suite_with_config default_config test_suite in
        print_suite_result ~file_name:(Filename.basename file) ?description:test_suite.description suite_result;
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
      try
        let test_suite = load_test_suite_from_file file in
        let suite_result = execute_json_test_suite_with_config default_config test_suite in
        print_suite_result ~file_name:(Filename.basename file) ?description:test_suite.description suite_result;
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
      try
        let test_suite = load_test_suite_from_file file in
        let suite_result = execute_json_test_suite_with_config default_config test_suite in
        print_suite_result ~file_name:(Filename.basename file) ?description:test_suite.description suite_result;
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
    
    (* Enhanced Summary with Implementation Status *)
    let bold = "\027[1m" in
    let reset = "\027[0m" in
    let green = "\027[32m" in
    let red = "\027[31m" in
    let yellow = "\027[33m" in
    let cyan = "\027[36m" in
    
    Printf.printf "=== %s🎯 SMART TEST SUMMARY%s ===\n" bold reset;
    Printf.printf "Test Suites: %d total | %s%d passed%s | %s%d failed%s\n" 
      suite_total green suite_passed reset red suite_failed reset;
    Printf.printf "Individual Tests: %d total | %s%d passed%s | %s%d failed%s | %s%d skipped%s | %d ignored\n" 
      test_total green test_passed reset red test_failed reset yellow test_skipped reset test_ignored;
    Printf.printf "Success Rate: %s%.1f%%%s (excluding skipped/ignored)\n"
      (if (test_passed + test_failed) > 0 then green else red)
      (if (test_passed + test_failed) > 0 then (float_of_int test_passed /. float_of_int (test_passed + test_failed)) *. 100.0 else 0.0)
      reset;
    Printf.printf "Coverage: %s%.1f%%%s (tests actually run)\n"
      cyan
      (if test_total > 0 then (float_of_int (test_passed + test_failed) /. float_of_int test_total) *. 100.0 else 0.0)
      reset;
    
    (* Use cached capabilities from start of run *)
    let (all_functions, all_features, all_behaviors, all_variants) = capabilities in
    
    (* Implementation Progress Summary *)
    let enabled_functions = List.length (List.filter (fun f -> not (List.mem f default_config.skip_functions)) all_functions) in
    let enabled_features = List.length (List.filter (fun f -> not (List.mem f default_config.skip_features)) all_features) in
    let enabled_behaviors = List.length (List.filter (fun b -> not (List.mem b default_config.skip_behaviors)) all_behaviors) in
    let enabled_variants = List.length (List.filter (fun v -> not (List.mem v default_config.skip_variants)) all_variants) in
    
    Printf.printf "\n%s📊 IMPLEMENTATION PROGRESS%s\n" bold reset;
    Printf.printf "Functions: %s%d/%d%s (%s%.1f%%%s)\n" 
      green enabled_functions (List.length all_functions) reset
      green ((float_of_int enabled_functions) /. (float_of_int (List.length all_functions)) *. 100.0) reset;
    Printf.printf "Features: %s%d/%d%s (%s%.1f%%%s)\n" 
      green enabled_features (List.length all_features) reset
      green ((float_of_int enabled_features) /. (float_of_int (List.length all_features)) *. 100.0) reset;
    Printf.printf "Behaviors: %s%d/%d%s (%s%.1f%%%s)\n" 
      green enabled_behaviors (List.length all_behaviors) reset
      green ((float_of_int enabled_behaviors) /. (float_of_int (List.length all_behaviors)) *. 100.0) reset;
    Printf.printf "Variants: %s%d/%d%s (configuration choice)\n" 
      green enabled_variants (List.length all_variants) reset;
    
    if suite_failed > 0 then (
      Printf.printf "\n%s❌ Failed suites (actual issues):%s\n" red reset;
      List.iter (fun (name, success, _) ->
        if not success then Printf.printf "- %s\n" name
      ) results
    );
    
    Printf.printf "\n";
    display_capability_status_with_dependencies default_config capabilities all_test_suites;
    
    exit (if suite_failed = 0 then 0 else 1)
    
  with
  | Sys_error msg ->
    Printf.eprintf "Error reading directory %s: %s\n" directory msg;
    exit 1

(* Proposed test analysis functionality *)
type proposed_test_result = {
  test_name : string;
  has_proposed_tag : bool;
  has_reference_tag : bool;
  tags : string list;
  passed_normally : bool;
  error_message : string option;
}

(* Check if a test case has proposed behavior tags *)
let has_proposed_tags test_case =
  let tags = test_case.meta.tags in
  List.exists (fun tag -> 
    tag = "proposed" || 
    tag = "proposed-behavior" || 
    tag = "variant:proposed-behavior"
  ) tags

(* Check if a test case has reference-compliant tags *)
let has_reference_tags test_case =
  let tags = test_case.meta.tags in
  List.exists (fun tag -> 
    tag = "reference-compliant" || 
    tag = "variant:reference-compliant"
  ) tags

(* Run a single test case and return detailed results *)
let analyze_single_proposed_test test_case =
  let proposed_tag = has_proposed_tags test_case in
  let reference_tag = has_reference_tags test_case in
  
  (* Test the case normally *)
  let (passed, error_msg) = 
    try
      let validation_results = Ccl_api_mapping.execute_validation test_case in
      let overall_success = List.for_all (fun (_, success, _, _) -> success) validation_results in
      let error_msg = 
        if not overall_success then
          let failed_validations = List.filter (fun (_, success, _, _) -> not success) validation_results in
          let error_messages = List.map (fun (name, _, msg_opt, _) ->
            match msg_opt with
            | Some msg -> Printf.sprintf "%s: %s" name msg
            | None -> Printf.sprintf "%s: failed" name
          ) failed_validations in
          Some (String.concat "; " error_messages)
        else None
      in
      (overall_success, error_msg)
    with
    | exn -> (false, Some (Printexc.to_string exn))
  in
  
  {
    test_name = test_case.name;
    has_proposed_tag = proposed_tag;
    has_reference_tag = reference_tag;
    tags = test_case.meta.tags;
    passed_normally = passed;
    error_message = error_msg;
  }

(* Analyze all tests in a suite and categorize results *)
let analyze_proposed_in_suite test_suite =
  Printf.printf "=== Analyzing Proposed Tests in %s ===\n" test_suite.suite;
  
  let results = List.map analyze_single_proposed_test test_suite.tests in
  
  (* Categorize results *)
  let proposed_tests = List.filter (fun r -> r.has_proposed_tag) results in
  let reference_tests = List.filter (fun r -> r.has_reference_tag) results in
  let untagged_tests = List.filter (fun r -> not r.has_proposed_tag && not r.has_reference_tag) results in
  
  let proposed_passing = List.filter (fun r -> r.has_proposed_tag && r.passed_normally) results in
  let proposed_failing = List.filter (fun r -> r.has_proposed_tag && not r.passed_normally) results in
  
  Printf.printf "\n📊 Test Categorization:\n";
  Printf.printf "- Tests with proposed tags: %d\n" (List.length proposed_tests);
  Printf.printf "- Tests with reference tags: %d\n" (List.length reference_tests);
  Printf.printf "- Tests with no variant tags: %d\n" (List.length untagged_tests);
  Printf.printf "- Total tests: %d\n" (List.length results);
  
  Printf.printf "\n🎯 Proposed Test Results:\n";
  Printf.printf "- Proposed tests PASSING: %d\n" (List.length proposed_passing);
  Printf.printf "- Proposed tests FAILING: %d\n" (List.length proposed_failing);
  
  if List.length proposed_passing > 0 then (
    Printf.printf "\n✅ PASSING Proposed Tests (candidates for recategorization):\n";
    List.iter (fun r ->
      Printf.printf "- %s\n" r.test_name;
      Printf.printf "  Tags: %s\n" (String.concat ", " r.tags);
    ) proposed_passing
  );
  
  if List.length proposed_failing > 0 then (
    Printf.printf "\n❌ FAILING Proposed Tests:\n";
    List.iter (fun r ->
      Printf.printf "- %s\n" r.test_name;
      Printf.printf "  Tags: %s\n" (String.concat ", " r.tags);
      (match r.error_message with
       | Some msg -> Printf.printf "  Error: %s\n" msg
       | None -> ())
    ) proposed_failing
  );
  
  (proposed_passing, proposed_failing)

(* Run analysis on all test files *)
let analyze_all_proposed_tests directory =
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
    
    Printf.printf "🔍 PROPOSED TEST ANALYSIS\n";
    Printf.printf "Analyzing %d test files for proposed tests that might actually pass...\n\n" (List.length json_files);
    
    let all_passing_proposed = ref [] in
    let all_failing_proposed = ref [] in
    
    List.iter (fun file ->
      Printf.printf "\n" ;
      try
        let test_suite = load_test_suite_from_file file in
        let (passing, failing) = analyze_proposed_in_suite test_suite in
        all_passing_proposed := passing @ !all_passing_proposed;
        all_failing_proposed := failing @ !all_failing_proposed;
      with
      | exn -> 
        Printf.eprintf "Error analyzing %s: %s\n" file (Printexc.to_string exn);
    ) json_files;
    
    Printf.printf "\n" ;
    Printf.printf "=== 🎉 OVERALL PROPOSED TEST SUMMARY ===\n";
    Printf.printf "Total proposed tests found: %d\n" (List.length !all_passing_proposed + List.length !all_failing_proposed);
    Printf.printf "Proposed tests PASSING: %d\n" (List.length !all_passing_proposed);
    Printf.printf "Proposed tests FAILING: %d\n" (List.length !all_failing_proposed);
    
    if List.length !all_passing_proposed > 0 then (
      let success_rate = (float_of_int (List.length !all_passing_proposed)) /. 
                        (float_of_int (List.length !all_passing_proposed + List.length !all_failing_proposed)) *. 100.0 in
      Printf.printf "Success rate: %.1f%%\n" success_rate;
      
      Printf.printf "\n🏆 ALL PASSING PROPOSED TESTS (ready for recategorization):\n";
      List.iter (fun r ->
        Printf.printf "- %s\n" r.test_name;
      ) (List.rev !all_passing_proposed);
      
      Printf.printf "\n📋 Recategorization Suggestions:\n";
      Printf.printf "The following tests could potentially be changed from 'variant:proposed-behavior' to 'variant:reference-compliant':\n\n";
      List.iter (fun r ->
        Printf.printf "# %s\n" r.test_name;
      ) (List.rev !all_passing_proposed);
    ) else (
      Printf.printf "\nNo proposed tests are currently passing. All proposed behaviors remain unimplemented.\n";
    );
    
    if List.length !all_passing_proposed > 0 then exit 0 else exit 1
    
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
  | [| _; "analyze-proposed"; directory |] ->
      analyze_all_proposed_tests directory
  | [| _; "run-enhanced"; json_file |] ->
      Enhanced_test_runner.test_enhanced_runner json_file
  | _ ->
      Printf.eprintf "Usage:\n";
      Printf.eprintf "  %s generate <json_file> <output_file>\n" Sys.argv.(0);
      Printf.eprintf "  %s run <json_file>\n" Sys.argv.(0);
      Printf.eprintf "  %s run-all <directory>\n" Sys.argv.(0);
      Printf.eprintf "  %s run-categorized <directory>  # Run with API/property test classification\n" Sys.argv.(0);
      Printf.eprintf "  %s run-smart <directory>        # Run with intelligent skipping of unimplemented features\n" Sys.argv.(0);
      Printf.eprintf "  %s run-enhanced <json_file>     # Run with enhanced partial validation engine\n" Sys.argv.(0);
      Printf.eprintf "  %s analyze-proposed <directory> # Analyze proposed tests to identify ones that actually pass\n" Sys.argv.(0);
      exit 1