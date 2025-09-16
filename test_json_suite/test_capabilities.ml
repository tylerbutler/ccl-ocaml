(* Test Capabilities - Simplified configuration for CCL test runner *)

(* Capabilities module - no longer needs Json_test_types *)

(* Core capability types following the implementation guide *)
type test_capabilities = {
  functions: string list;     (* e.g., ["parse"; "make_objects"; "get_string"] *)
  features: string list;      (* e.g., ["dotted_keys"; "comments"] *)
  behaviors: string list;     (* e.g., ["crlf_normalize_to_lf"; "boolean_lenient"] *)
}

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
    "tabs_preserve";           (* Preserve tabs *)
    "crlf_preserve_literal";   (* Preserve CRLF in literals when needed *)
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