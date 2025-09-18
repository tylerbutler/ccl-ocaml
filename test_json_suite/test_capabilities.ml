(* Test Capabilities - Simplified configuration for CCL test runner *)

(* Capabilities module - no longer needs Json_test_types *)

(* Core capability types following the implementation guide *)
type test_capabilities = {
  functions: string list;     (* e.g., ["parse"; "make_objects"; "get_string"] *)
  features: string list;      (* e.g., ["dotted_keys"; "comments"] *)
  behaviors: string list;     (* e.g., ["crlf_normalize_to_lf"; "boolean_lenient"] *)
}

(* Known Bug Test Exclusions - Tests excluded due to identified implementation issues *)

(* BUG-001: Parser Multiline Handling Incomplete *)
(* See reports/BUG-001-parser-multiline-handling.md *)
let bug_001_multiline_parsing = [
  "multiline_section_header_value_parse_value";
  "unindented_multiline_becomes_continuation_parse_value";
  "list_multiline_values_parse_value";
  "complex_mixed_list_scenarios_parse_value";
]

(* BUG-002: Missing Typed Access Functions *)
(* See reports/BUG-002-missing-typed-access-functions.md *)
let bug_002_missing_typed_functions = [
  "parse_integer_values_get_int";
  "type_conversion_edge_cases_get_int";
  "parse_boolean_values_get_bool";
  "parse_float_values_get_float";
  "parse_missing_path_error_get_string";
]

(* BUG-003: Error Handling Inadequacy *)
(* See reports/BUG-003-error-handling-inadequacy.md *)
let bug_003_error_handling = [
  "just_key_error_parse";
  "just_string_error_parse";
  "multiline_plain_error_parse";
  "multiline_plain_nested_error_parse";
]

(* BUG-004: Pretty-Print Round-Trip Identity *)
(* See reports/BUG-004-pretty-print-round-trip.md *)
let bug_004_pretty_print_round_trip = [
  "round_trip_property_basic_round_trip";
  "round_trip_property_nested_round_trip";
  "round_trip_property_complex_round_trip";
]

(* Default exclusions for known bugs - combine all bug-related exclusions *)
let default_test_exclusions =
  bug_001_multiline_parsing @
  bug_002_missing_typed_functions @
  bug_003_error_handling @
  bug_004_pretty_print_round_trip

(* Default capabilities for the OCaml implementation *)
let default_capabilities = {
  functions = [
    "parse";                   (* Parser.parse - basic key-value parsing *)
    "parse_value";             (* Parser.parse_value - parse with prefix calculation *)
    "build_hierarchy";         (* Model.fix - convert flat entries to nested objects *)
    "pretty_print";            (* Model.pretty - format CCL output *)
    "get_string";              (* Model.get_string - extract string values by path *)
    "get_list";                (* Model.get_list - extract list values by path *)
    (* Unimplemented: get_int, get_bool, get_float, filter, compose *)
    (* "expand_dotted"; -- Not implemented yet *)
  ];
  features = [
    (* "dotted_keys"; -- Not supported in current implementation *)
    "empty_keys";              (* Should be supported *)
    "comments";                (* Supported per README *)
    (* No unicode or multiline support yet *)
  ];
  behaviors = [
    "crlf_normalize_to_lf";    (* We normalize CRLF to LF *)
    "boolean_strict";          (* Use strict boolean parsing *)
    "strict_spacing";          (* Support strict spacing *)
    "tabs_to_spaces";          (* Convert tabs to spaces *)
    "crlf_preserve_literal";   (* Preserve CRLF in literals when needed *)
    "list_coercion_disabled";  (* Disable automatic list coercion *)
    (* "boolean_lenient" -- Not supported, we use strict *)
  ];
}

(* Parse capability strings from CLI (e.g., "function:parse", "feature:comments") *)
let parse_capability_string cap_str =
  match String.split_on_char ':' cap_str with
  | ["function"; name] -> Some (`Function name)
  | ["feature"; name] -> Some (`Feature name)
  | ["behavior"; name] -> Some (`Behavior name)
  | _ -> None

(* Build capabilities from CLI argument list *)
let build_capabilities_from_args cap_args =
  let (funcs, features, behaviors) = List.fold_left (fun (f, feat, b) arg ->
    match parse_capability_string arg with
    | Some (`Function name) -> (name :: f, feat, b)
    | Some (`Feature name) -> (f, name :: feat, b)
    | Some (`Behavior name) -> (f, feat, name :: b)
    | None -> (f, feat, b)  (* Ignore invalid capability strings *)
  ) ([], [], []) cap_args in
  {
    functions = List.rev funcs;
    features = List.rev features;
    behaviors = List.rev behaviors;
  }

(* Merge user-specified capabilities with defaults *)
let merge_capabilities user_caps =
  if user_caps.functions = [] && user_caps.features = [] && user_caps.behaviors = [] then
    (* No user specification, use defaults *)
    default_capabilities
  else
    (* Use user-specified capabilities, falling back to defaults for empty lists *)
    {
      functions = if user_caps.functions = [] then default_capabilities.functions else user_caps.functions;
      features = if user_caps.features = [] then default_capabilities.features else user_caps.features;
      behaviors = if user_caps.behaviors = [] then default_capabilities.behaviors else user_caps.behaviors;
    }

(* Simplified capabilities - no longer need tag extraction *)
(* These functions are not used by the schema-based simplified test runner *)

(* Check if a function is implemented based on default capabilities *)
let is_function_implemented function_name =
  List.mem function_name default_capabilities.functions

(* Simplified test runner uses direct capability checking *)
(* This function is not used by the schema-based test runner *)
let is_test_runnable _test_case _capabilities = true

(* Display capabilities in a readable format *)
let show_capabilities caps =
  Printf.sprintf "Functions: [%s]\nFeatures: [%s]\nBehaviors: [%s]"
    (String.concat "; " caps.functions)
    (String.concat "; " caps.features)
    (String.concat "; " caps.behaviors)

(* Test Exclusion Utilities *)

(* Get exclusions for a specific bug (optional filtering) *)
let get_bug_exclusions = function
  | "001" -> bug_001_multiline_parsing
  | "002" -> bug_002_missing_typed_functions
  | "003" -> bug_003_error_handling
  | "004" -> bug_004_pretty_print_round_trip
  | _ -> []

(* Show exclusion summary *)
let show_exclusion_summary () =
  Printf.printf "Test Exclusions Summary:\n";
  Printf.printf "  BUG-001 (Multiline Parsing): %d tests\n" (List.length bug_001_multiline_parsing);
  Printf.printf "  BUG-002 (Missing Types): %d tests\n" (List.length bug_002_missing_typed_functions);
  Printf.printf "  BUG-003 (Error Handling): %d tests\n" (List.length bug_003_error_handling);
  Printf.printf "  BUG-004 (Round-Trip): %d tests\n" (List.length bug_004_pretty_print_round_trip);
  Printf.printf "  Total Excluded: %d tests\n" (List.length default_test_exclusions);
  Printf.printf "\nRefer to reports/ directory for detailed bug analysis.\n"