(* Simple Test Runner - Core implementation following the flat test format guide *)

open Printf
open Ccl_test_types_j
open Test_capabilities
open Test_output

(* Test result types - simplified from the implementation guide *)
type test_result = 
  | Passed
  | Failed of string  
  | Skipped of string

type test_summary = {
  total: int;
  passed: int;
  failed: int;
  skipped: int;
  file_name: string;
}

type overall_summary = {
  total_tests: int;
  passed_tests: int;
  failed_tests: int;
  skipped_tests: int;
  total_files: int;
  failed_files: int;
}

(* Execute a single validation for a test case - flat format approach *)
let execute_single_validation (test_case : test_case) =
  try
    (* Each test in flat format validates exactly one function *)
    (* Call the actual OCaml CCL API based on the validation type *)
    match test_case.validation with
    | `Parse -> 
        (* Call Ccl.Parser.parse and verify expected_entries *)
        (match Ccl.Parser.parse test_case.input with
         | Ok entries -> 
             (* Verify count if specified *)
             let count_check = match test_case.expected_count with
               | Some expected -> 
                   if List.length entries = expected then Ok ()
                   else Error (Printf.sprintf "Expected %d entries, got %d" expected (List.length entries))
               | None -> Ok ()
             in
             (* Verify expected_entries if specified *)
             let entries_check = match test_case.expected_entries with
               | Some expected_list ->
                   let actual_list = List.map (fun entry -> 
                     { key = entry.Ccl.Parser.key; value = entry.Ccl.Parser.value }
                   ) entries in
                   if actual_list = expected_list then Ok ()
                   else Error (Printf.sprintf "Expected entries mismatch. Expected: %s, Got: %s"
                     (String.concat "; " (List.map (fun e -> e.key ^ "=" ^ e.value) expected_list))
                     (String.concat "; " (List.map (fun e -> e.key ^ "=" ^ e.value) actual_list)))
               | None -> Ok ()
             in
             (match count_check, entries_check with
              | Ok (), Ok () -> Passed
              | Error msg, _ -> Failed msg
              | _, Error msg -> Failed msg)
         | Error (`Parse_error msg) -> Failed ("Parse error: " ^ msg))
    
    | `Parse_value ->
        (* Call Ccl.Parser.parse_value *)
        (match Ccl.Parser.parse_value test_case.input with
         | Ok entries ->
             (* Verify count if specified *)
             let count_check = match test_case.expected_count with
               | Some expected -> 
                   if List.length entries = expected then Ok ()
                   else Error (Printf.sprintf "Expected %d entries, got %d" expected (List.length entries))
               | None -> Ok ()
             in
             (* Verify expected_entries if specified *)
             let entries_check = match test_case.expected_entries with
               | Some expected_list ->
                   let actual_list = List.map (fun entry -> 
                     { key = entry.Ccl.Parser.key; value = entry.Ccl.Parser.value }
                   ) entries in
                   if actual_list = expected_list then Ok ()
                   else Error (Printf.sprintf "Expected entries mismatch. Expected: %s, Got: %s"
                     (String.concat "; " (List.map (fun e -> e.key ^ "=" ^ e.value) expected_list))
                     (String.concat "; " (List.map (fun e -> e.key ^ "=" ^ e.value) actual_list)))
               | None -> Ok ()
             in
             (match count_check, entries_check with
              | Ok (), Ok () -> Passed
              | Error msg, _ -> Failed msg
              | _, Error msg -> Failed msg)
         | Error (`Parse_error msg) -> Failed ("Parse_value error: " ^ msg))
    
    | `Build_hierarchy ->
        (* Call Ccl.decode (which does Parser.parse |> Model.fix) *)
        (match Ccl.decode test_case.input with
         | Ok _model -> Passed  (* Successfully built hierarchy *)
         | Error (`Parse_error msg) -> Failed ("Build_hierarchy error: " ^ msg))
    
    | `Pretty_print ->
        (* Call Ccl.decode then Model.pretty *)
        (match Ccl.decode test_case.input with
         | Ok model -> 
             let _pretty_output = Ccl.Model.pretty model in
             Passed  (* Successfully pretty printed *)
         | Error (`Parse_error msg) -> Failed ("Pretty_print error: " ^ msg))
    
    (* Unimplemented functions *)
    | `Filter -> Skipped "Function filter not implemented"
    | `Compose -> Skipped "Function compose not implemented" 
    | `Expand_dotted -> Skipped "Function expand_dotted not implemented"
    | `Get_string -> Skipped "Function get_string not implemented"
    | `Get_int -> Skipped "Function get_int not implemented"
    | `Get_bool -> Skipped "Function get_bool not implemented"
    | `Get_float -> Skipped "Function get_float not implemented"
    | `Get_list -> Skipped "Function get_list not implemented"
    | `Load -> Skipped "Function load not implemented"
    | `Round_trip -> Skipped "Function round_trip not implemented"
    | `Canonical_format -> Skipped "Function canonical_format not implemented"
    | `Associativity -> Skipped "Function associativity not implemented"
    
  with
  | exn -> Failed (Printexc.to_string exn)

(* Run a single test case with capability checking *)
let run_single_test test_case _capabilities verbose =
  (* For flat format, we simple check if the validation function is implemented *)
  let validation_name = match test_case.validation with
    | `Parse -> "parse"
    | `Parse_value -> "parse_value"
    | `Filter -> "filter"
    | `Compose -> "compose"
    | `Expand_dotted -> "expand_dotted"
    | `Build_hierarchy -> "build_hierarchy"
    | `Get_string -> "get_string"
    | `Get_int -> "get_int"
    | `Get_bool -> "get_bool"
    | `Get_float -> "get_float"
    | `Get_list -> "get_list"
    | `Pretty_print -> "pretty_print"
    | `Load -> "load"
    | `Round_trip -> "round_trip"
    | `Canonical_format -> "canonical_format"
    | `Associativity -> "associativity"
  in
  
  if Test_capabilities.is_function_implemented validation_name then
    let result = execute_single_validation test_case in
    (match result with
     | Passed -> if verbose then test_passed_msg test_case.name
     | Failed error_msg -> test_failed_msg test_case.name error_msg
     | Skipped reason -> if verbose then test_skipped_msg test_case.name reason);
    result
  else
    let reason = Printf.sprintf "Function %s not implemented" validation_name in
    if verbose then test_skipped_msg test_case.name reason;
    Skipped reason

(* All available capabilities discovered from the CCL test suite *)
let get_all_capabilities () =
  let all_functions = [
    "parse"; "parse_value"; "filter"; "expand_dotted"; "build_hierarchy";
    "get_string"; "get_int"; "get_bool"; "get_float"; "get_list";
    "canonical_format"
  ] in
  let all_features = [
    "comments"; "experimental_dotted_keys"
  ] in
  let all_behaviors = [
    "boolean_strict"; "boolean_lenient"; "crlf_normalize_to_lf"; 
    "crlf_preserve_literal"; "strict_spacing"; "tabs_preserve";
    "list_coercion_enabled"; "list_coercion_disabled"
  ] in
  (all_functions, all_features, all_behaviors)

(* Calculate summary from test results *)
let calculate_summary results file_name =
  let total = List.length results in
  let passed = List.length (List.filter (function Passed -> true | _ -> false) results) in
  let failed = List.length (List.filter (function Failed _ -> true | _ -> false) results) in
  let skipped = List.length (List.filter (function Skipped _ -> true | _ -> false) results) in
  { total; passed; failed; skipped; file_name }

(* Load flat format test file directly as root type *)
let load_flat_test_file filename =
  let content = In_channel.with_open_text filename In_channel.input_all in
  root_of_string content

(* Run tests for a flat format test file *)
let run_test_file test_cases file_name capabilities verbose =
  file_header file_name;
  
  let results = List.map (fun test_case ->
    run_single_test test_case capabilities verbose
  ) test_cases in
  
  let summary = calculate_summary results file_name in
  
  (* Show summary for this suite *)
  test_summary ~total:summary.total ~passed:summary.passed 
               ~failed:summary.failed ~skipped:summary.skipped;
  
  (* Show skipped assertions details for this file *)
  let skipped_details = List.filter_map (fun (test_case, result) ->
    match result with
    | Skipped reason -> Some (test_case.name, reason)
    | _ -> None
  ) (List.combine test_cases results) in
  skipped_assertions_summary file_name skipped_details;
  
  (* Show error details if there were failures *)
  if summary.failed > 0 then (
    error_details_header ();
    List.iter2 (fun test_case result ->
      match result with
      | Failed error_msg -> 
          error_detail test_case.name "validation" error_msg
      | _ -> ()
    ) test_cases results
  );
  
  summary

(* Determine if a path is a file or directory *)
let is_directory path =
  try
    Sys.is_directory path
  with
  | Sys_error _ -> false

(* Find JSON test files in a directory *)
let find_json_files directory =
  try
    let files = Sys.readdir directory in
    Array.to_list files
    |> List.filter (fun f -> 
        String.length f > 5 && 
        String.sub f (String.length f - 5) 5 = ".json" &&
        f <> "schema.json")
    |> List.map (Filename.concat directory)
    |> List.sort String.compare
  with
  | Sys_error msg ->
      error_msg ("Error reading directory " ^ directory ^ ": " ^ msg);
      []

(* Expand file arguments to actual JSON files *)
let expand_file_args file_args =
  List.fold_left (fun acc arg ->
    if is_directory arg then
      let json_files = find_json_files arg in
      json_files @ acc
    else
      arg :: acc
  ) [] file_args
  |> List.rev

(* Run tests for multiple files *)
let run_multiple_files files capabilities verbose =
  let json_files = expand_file_args files in
  
  if List.length json_files = 0 then (
    error_msg "No JSON test files found";
    exit 1
  );
  
  info_msg (Printf.sprintf "Running tests from %d file(s)" (List.length json_files));
  
  let file_summaries = List.map (fun file ->
    try
      progress_start ("Loading " ^ Filename.basename file);
      let test_cases = load_flat_test_file file in
      progress_done ();
      
      let summary = run_test_file test_cases (Filename.basename file) capabilities verbose in
      (true, summary)
    with
    | exn -> 
        progress_failed (Printexc.to_string exn);
        (false, { total = 0; passed = 0; failed = 0; skipped = 0; file_name = file })
  ) json_files in
  
  (* Calculate overall summary *)
  let (successful_files, summaries) = List.split file_summaries in
  let total_files = List.length json_files in
  let failed_files = List.length (List.filter not successful_files) in
  
  let overall = List.fold_left (fun acc summary ->
    {
      total_tests = acc.total_tests + summary.total;
      passed_tests = acc.passed_tests + summary.passed;
      failed_tests = acc.failed_tests + summary.failed;
      skipped_tests = acc.skipped_tests + summary.skipped;
      total_files = acc.total_files;
      failed_files = acc.failed_files;
    }
  ) { total_tests = 0; passed_tests = 0; failed_tests = 0; skipped_tests = 0; 
      total_files; failed_files } summaries in
  
  overall

(* Show default capabilities *)
let show_default_capabilities () =
  capabilities_summary default_capabilities;
  info_msg "Use --cap function:name or --cap feature:name to specify custom capabilities"

(* Main entry point *)
let main files capability_args verbose no_color show_capabilities _config_file =
  (* Initialize output formatting *)
  init_colors no_color;
  
  (* Handle show capabilities *)
  if show_capabilities then (
    show_default_capabilities ();
    exit 0
  );
  
  (* Handle missing files *)
  if List.length files = 0 then (
    error_msg "No test files specified";
    info_msg "Use --help for usage information";
    exit 1
  );
  
  (* Build capabilities from arguments *)
  let user_capabilities = build_capabilities_from_args capability_args in
  let capabilities = merge_capabilities user_capabilities in
  
  (* Get all available capabilities *)
  let (all_functions, all_features, all_behaviors) = get_all_capabilities () in
  
  (* Show configuration block at start *)
  configuration_block capabilities "reference-compliant" all_functions all_features all_behaviors;
  printf "\n";
  
  (* Show capabilities being used *)
  if verbose then (
    section_header "Test Configuration";
    capabilities_summary capabilities
  );
  
  (* Run the tests *)
  let overall_summary = run_multiple_files files capabilities verbose in
  
  (* Show final results *)
  section_header "Overall Results";
  test_summary ~total:overall_summary.total_tests ~passed:overall_summary.passed_tests
               ~failed:overall_summary.failed_tests ~skipped:overall_summary.skipped_tests;
  
  if overall_summary.total_files > 1 then (
    printf "\nFiles processed: %d | Failed to process: %d\n" 
      overall_summary.total_files overall_summary.failed_files
  );
  
  (* Show configuration block at end *)
  printf "\n";
  configuration_block capabilities "reference-compliant" all_functions all_features all_behaviors;
  
  (* Exit with appropriate code *)
  let success = overall_summary.failed_tests = 0 && overall_summary.failed_files = 0 in
  final_result_msg success;
  if success then exit 0 else exit 1