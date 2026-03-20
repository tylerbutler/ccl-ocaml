(* JSON deserialization for CCL test suite format *)
(* Replaces atdgen-generated code with direct Yojson parsing *)
[@@@ocaml.warning "-27-32-33-35-39"]

open Ccl_test_types_t

let validation_of_string = function
  | "parse" -> `Parse
  | "parse_indented" -> `Parse_indented
  | "filter" -> `Filter
  | "compose" -> `Compose
  | "build_hierarchy" -> `Build_hierarchy
  | "get_string" -> `Get_string
  | "get_int" -> `Get_int
  | "get_bool" -> `Get_bool
  | "get_float" -> `Get_float
  | "get_list" -> `Get_list
  | "print" -> `Print
  | "canonical_format" -> `Canonical_format
  | "load" -> `Load
  | "round_trip" -> `Round_trip
  | "compose_associative" -> `Compose_associative
  | "identity_left" -> `Identity_left
  | "identity_right" -> `Identity_right
  | s -> failwith ("Unknown validation function: " ^ s)

let function_of_string = function
  | "parse" -> `Parse
  | "parse_indented" -> `Parse_indented
  | "filter" -> `Filter
  | "compose" -> `Compose
  | "build_hierarchy" -> `Build_hierarchy
  | "get_string" -> `Get_string
  | "get_int" -> `Get_int
  | "get_bool" -> `Get_bool
  | "get_float" -> `Get_float
  | "get_list" -> `Get_list
  | "print" -> `Print
  | "canonical_format" -> `Canonical_format
  | "load" -> `Load
  | "round_trip" -> `Round_trip
  | "compose_associative" -> `Compose_associative
  | "identity_left" -> `Identity_left
  | "identity_right" -> `Identity_right
  | s -> failwith ("Unknown function: " ^ s)

let behavior_of_string = function
  | "boolean_strict" -> `Boolean_strict
  | "boolean_lenient" -> `Boolean_lenient
  | "crlf_preserve_literal" -> `Crlf_preserve_literal
  | "crlf_normalize_to_lf" -> `Crlf_normalize_to_lf
  | "tabs_as_content" -> `Tabs_as_content
  | "tabs_as_whitespace" -> `Tabs_as_whitespace
  | "indent_spaces" -> `Indent_spaces
  | "indent_tabs" -> `Indent_tabs
  | "list_coercion_enabled" -> `List_coercion_enabled
  | "list_coercion_disabled" -> `List_coercion_disabled
  | "array_order_insertion" -> `Array_order_insertion
  | "array_order_lexicographic" -> `Array_order_lexicographic
  | "toplevel_indent_strip" -> `Toplevel_indent_strip
  | "toplevel_indent_preserve" -> `Toplevel_indent_preserve
  | "delimiter_first_equals" -> `Delimiter_first_equals
  | "delimiter_prefer_spaced" -> `Delimiter_prefer_spaced
  | s -> failwith ("Unknown behavior: " ^ s)

let variant_of_string = function
  | "proposed_behavior" -> `Proposed_behavior
  | "reference_compliant" -> `Reference_compliant
  | s -> failwith ("Unknown variant: " ^ s)

let get_string_list json =
  match json with
  | `List items -> List.filter_map (function `String s -> Some s | _ -> None) items
  | _ -> []

let get_string_field fields name =
  match List.assoc_opt name fields with
  | Some (`String s) -> s
  | _ -> failwith ("Missing or invalid string field: " ^ name)

let get_optional_string_field fields name =
  match List.assoc_opt name fields with
  | Some (`String s) -> Some s
  | Some `Null -> None
  | None -> None
  | _ -> None

let get_bool_field_default fields name default =
  match List.assoc_opt name fields with
  | Some (`Bool b) -> b
  | _ -> default

let parse_conflicts json =
  match json with
  | `Assoc fields ->
      Some {
        functions = (match List.assoc_opt "functions" fields with Some l -> Some (get_string_list l) | None -> None);
        behaviors = (match List.assoc_opt "behaviors" fields with Some l -> Some (get_string_list l) | None -> None);
        variants = (match List.assoc_opt "variants" fields with Some l -> Some (get_string_list l) | None -> None);
        features = (match List.assoc_opt "features" fields with Some l -> Some (get_string_list l) | None -> None);
      }
  | `Null -> None
  | _ -> None

let parse_test_case json : cCLTestFlatFormatTests =
  match json with
  | `Assoc fields ->
      let name = get_string_field fields "name" in
      let inputs = match List.assoc_opt "inputs" fields with
        | Some l -> get_string_list l
        | None ->
            (* Backward compatibility: support old "input" field *)
            (match List.assoc_opt "input" fields with
             | Some (`String s) -> [s]
             | _ -> failwith ("Test '" ^ name ^ "' missing both 'inputs' and 'input' fields"))
      in
      let validation = validation_of_string (get_string_field fields "validation") in
      let expected = (match List.assoc_opt "expected" fields with Some e -> e | None -> `Null) in
      let args = (match List.assoc_opt "args" fields with Some l -> Some (get_string_list l) | None -> None) in
      let functions = (match List.assoc_opt "functions" fields with
        | Some (`List items) -> Some (List.map (fun f -> match f with `String s -> function_of_string s | _ -> failwith "Invalid function") items)
        | _ -> None) in
      let behaviors = (match List.assoc_opt "behaviors" fields with
        | Some (`List items) -> List.filter_map (fun b -> match b with `String s -> Some (behavior_of_string s) | _ -> None) items
        | _ -> []) in
      let variants = (match List.assoc_opt "variants" fields with
        | Some (`List items) -> List.filter_map (fun v -> match v with `String s -> Some (variant_of_string s) | _ -> None) items
        | _ -> []) in
      let features = (match List.assoc_opt "features" fields with Some l -> get_string_list l | None -> []) in
      let conflicts = (match List.assoc_opt "conflicts" fields with Some c -> parse_conflicts c | None -> None) in
      let requires = (match List.assoc_opt "requires" fields with Some l -> Some (get_string_list l) | None -> None) in
      let source_test = get_optional_string_field fields "source_test" in
      let expect_error = get_bool_field_default fields "expect_error" false in
      let error_type = get_optional_string_field fields "error_type" in
      { name; inputs; validation; expected; args; functions; behaviors;
        variants; features; conflicts; requires; source_test; expect_error; error_type }
  | _ -> failwith "Test case must be a JSON object"

let parse_test_suite json : cCLTestFlatFormat =
  match json with
  | `Assoc fields ->
      let schema = (match List.assoc_opt "$schema" fields with
        | Some (`String s) -> s
        | _ -> "") in
      let tests = match List.assoc_opt "tests" fields with
        | Some (`List items) -> List.map parse_test_case items
        | _ -> failwith "Missing 'tests' array in test suite"
      in
      { schema; tests }
  | _ -> failwith "Test suite must be a JSON object"

let cCLTestFlatFormat_of_string content =
  let json = Yojson.Basic.from_string content in
  parse_test_suite json
