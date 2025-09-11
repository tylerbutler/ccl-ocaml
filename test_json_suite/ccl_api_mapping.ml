open Json_test_types

(* Convert JSON test entry to CCL entry *)
let json_entry_to_ccl_entry entry =
  { Ccl.Parser.key = entry.key; value = entry.value }

let ccl_entry_to_json_entry entry =
  { key = entry.Ccl.Parser.key; value = entry.Ccl.Parser.value }

(* Execute Level 1: Parsing validation *)
let execute_parse_validation input validation =
  match Ccl.Parser.parse input with
  | Ok entries ->
      let json_entries = List.map ccl_entry_to_json_entry entries in
      (match validation with
       | Entries { count; expected = expected_entries } ->
           if List.equal (fun a b -> String.equal a.key b.key && String.equal a.value b.value) 
                        json_entries expected_entries
           then Ok ()
           else Error (Printf.sprintf "Parse mismatch: expected %d entries (count: %d), got %d entries"
                      (List.length expected_entries) count (List.length json_entries))
       | ParseError _ ->
           Error "Expected parse error but parsing succeeded")
  | Error (`Parse_error msg) ->
      (match validation with
       | ParseError _error_validation ->
           Ok ()
       | Entries _ ->
           Error ("Expected successful parse but got error: " ^ msg))

(* Execute Level 2: Parse Value - Indentation-aware parsing *)
let execute_parse_value_validation input validation =
  match Ccl.Parser.parse_value input with
  | Ok entries ->
      let json_entries = List.map ccl_entry_to_json_entry entries in
      (match validation with
       | Entries { expected = expected_entries; _ } ->
           if List.equal (fun a b -> String.equal a.key b.key && String.equal a.value b.value) 
                        json_entries expected_entries
           then Ok ()
           else Error "Parse value mismatch"
       | ParseError _ -> Error "Expected parse error but parsing succeeded")
  | Error (`Parse_error msg) -> 
      (match validation with
       | ParseError _ -> Ok ()
       | Entries _ -> Error ("Parse value failed: " ^ msg))

(* Execute Level 2: Filter validation *)
let execute_filter_validation entries validation =
  match validation with
  | FilteredEntries { expected = expected_entries; _ } -> 
      let json_entries = List.map ccl_entry_to_json_entry entries in
      if List.equal (fun a b -> String.equal a.key b.key && String.equal a.value b.value) 
                   json_entries expected_entries
      then Ok ()
      else Error "Filter validation failed"
  | FilterError _ -> Error "Filter error validation not implemented"

(* Execute Level 2: Compose validation *)
let execute_compose_validation validation =
  match validation with
  | CompositionResult { left; right; expected } ->
      (* Convert to CCL entries and use Model.merge for composition *)
      let left_ccl = List.map json_entry_to_ccl_entry left in
      let right_ccl = List.map json_entry_to_ccl_entry right in
      let left_model = Ccl.Model.fix left_ccl in
      let right_model = Ccl.Model.fix right_ccl in
      let composed_model = Ccl.Model.merge left_model right_model in
      let composed_pretty = Ccl.Model.pretty composed_model in
      (* Parse the pretty-printed result to get entries for comparison *)
      (match Ccl.Parser.parse composed_pretty with
       | Ok composed_entries ->
           let composed_json = List.map ccl_entry_to_json_entry composed_entries in
           if List.equal (fun a b -> String.equal a.key b.key && String.equal a.value b.value) 
                        composed_json expected
           then Ok ()
           else Error "Compose validation failed"
       | Error _ -> Error "Failed to parse composed result")
  | ComposeError _ -> Error "Compose error validation not implemented"

(* Helper function to expand dotted keys *)
let expand_dotted_keys entries =
  (* Convert a.b.c = value to nested structure and back to entries *)
  let ccl_entries = List.map json_entry_to_ccl_entry entries in
  let model = Ccl.Model.fix ccl_entries in
  let pretty_output = Ccl.Model.pretty model in
  match Ccl.Parser.parse pretty_output with
  | Ok expanded_entries -> List.map ccl_entry_to_json_entry expanded_entries
  | Error _ -> entries (* fallback: return original entries *)

(* Execute Level 2: Expand dotted keys validation *)
let execute_expand_dotted_validation entries validation =
  match validation with
  | ExpandedEntries { expected = expected_entries; _ } ->
      let json_entries = List.map ccl_entry_to_json_entry entries in
      let expanded_entries = expand_dotted_keys json_entries in
      if List.equal (fun a b -> String.equal a.key b.key && String.equal a.value b.value) 
                   expanded_entries expected_entries
      then Ok ()
      else Error "Expand dotted validation failed"
  | ExpandError _ -> Error "Expand dotted error validation not implemented"

(* Helper function to convert CCL model to JSON *)
let ccl_model_to_json model =
  let rec model_to_json_value = function
    | Ccl.Model.Fix map ->
        (* Check if this is a leaf value: single key mapping to empty object *)
        let bindings = Ccl.Model.KeyMap.bindings map in
        (match bindings with
         | [(key, Ccl.Model.Fix empty_map)] when Ccl.Model.KeyMap.is_empty empty_map ->
             (* This is a leaf value - return the key as a string *)
             `String key
         | _ ->
             (* Check if all values are leaf values and could represent an array *)
             let leaf_values = List.filter_map (fun (key, value) ->
               match value with
               | Ccl.Model.Fix empty_map when Ccl.Model.KeyMap.is_empty empty_map -> Some key
               | _ -> None
             ) bindings in
             
             if List.length leaf_values = List.length bindings && List.length leaf_values > 1 then
               (* All are leaf values and more than one - represent as array *)
               `List (List.map (fun k -> `String k) leaf_values)
             else
               (* Mixed or single structure - convert to JSON object normally *)
               let assoc_list = Ccl.Model.KeyMap.fold (fun key value acc ->
                 (key, model_to_json_value value) :: acc
               ) map [] in
               `Assoc (List.rev assoc_list))
  in
  model_to_json_value model

(* Execute Level 3: Make objects validation *)
let execute_make_objects_validation entries validation =
  match validation with
  | ObjectResult { expected = expected_json; _ } ->
      let ccl_entries = List.map json_entry_to_ccl_entry entries in
      let ccl_model = Ccl.Model.fix ccl_entries in
      let actual_json = ccl_model_to_json ccl_model in
      if Yojson.Safe.equal actual_json expected_json
      then Ok ()
      else Error (Printf.sprintf "Make objects validation failed: expected %s, got %s" 
                   (Yojson.Safe.to_string expected_json) (Yojson.Safe.to_string actual_json))
  | ObjectError _ -> Error "Make objects error validation not implemented"

(* Helper functions for typed access *)
let get_string_from_path json_obj path =
  let rec access_path obj path =
    match path, obj with
    | [], `String s -> Ok s
    | [], _ -> Error "Value is not a string"
    | key :: rest, `Assoc assoc ->
        (match List.assoc_opt key assoc with
         | Some value -> access_path value rest
         | None -> Error ("Key not found: " ^ key))
    | _, _ -> Error "Invalid path for object structure"
  in
  access_path json_obj path

let get_int_from_path json_obj path =
  let rec access_path obj path =
    match path, obj with
    | [], `Int i -> Ok i
    | [], `String s -> (try Ok (int_of_string s) with _ -> Error "Value is not an integer")
    | [], _ -> Error "Value is not an integer"
    | key :: rest, `Assoc assoc ->
        (match List.assoc_opt key assoc with
         | Some value -> access_path value rest
         | None -> Error ("Key not found: " ^ key))
    | _, _ -> Error "Invalid path for object structure"
  in
  access_path json_obj path

let get_bool_from_path json_obj path =
  let rec access_path obj path =
    match path, obj with
    | [], `Bool b -> Ok b
    | [], `String "true" -> Ok true
    | [], `String "false" -> Ok false
    | [], _ -> Error "Value is not a boolean"
    | key :: rest, `Assoc assoc ->
        (match List.assoc_opt key assoc with
         | Some value -> access_path value rest
         | None -> Error ("Key not found: " ^ key))
    | _, _ -> Error "Invalid path for object structure"
  in
  access_path json_obj path

let get_float_from_path json_obj path =
  let rec access_path obj path =
    match path, obj with
    | [], `Float f -> Ok f
    | [], `Int i -> Ok (float_of_int i)
    | [], `String s -> (try Ok (float_of_string s) with _ -> Error "Value is not a float")
    | [], _ -> Error "Value is not a float"
    | key :: rest, `Assoc assoc ->
        (match List.assoc_opt key assoc with
         | Some value -> access_path value rest
         | None -> Error ("Key not found: " ^ key))
    | _, _ -> Error "Invalid path for object structure"
  in
  access_path json_obj path

let get_list_from_path json_obj path =
  let rec access_path obj path =
    match path, obj with
    | [], `List l -> Ok l
    | [], _ -> Error "Value is not a list"
    | key :: rest, `Assoc assoc ->
        (match List.assoc_opt key assoc with
         | Some value -> access_path value rest
         | None -> Error ("Key not found: " ^ key))
    | _, _ -> Error "Invalid path for object structure"
  in
  access_path json_obj path

(* Execute Level 4: Typed access validation *)
let execute_typed_access_case json_obj case_val access_type =
  match case_val with
  | TypedResultCase { args; expected } ->
      (match access_type with
       | "get_string" ->
           (match get_string_from_path json_obj args with
            | Ok actual_value ->
                if Yojson.Safe.equal (`String actual_value) expected
                then Ok ()
                else Error (Printf.sprintf "String access mismatch: expected %s, got %s" 
                             (Yojson.Safe.to_string expected) actual_value)
            | Error err -> Error err)
       | "get_int" ->
           (match get_int_from_path json_obj args with
            | Ok actual_value ->
                if Yojson.Safe.equal (`Int actual_value) expected
                then Ok ()
                else Error (Printf.sprintf "Int access mismatch: expected %s, got %d" 
                             (Yojson.Safe.to_string expected) actual_value)
            | Error err -> Error err)
       | "get_bool" ->
           (match get_bool_from_path json_obj args with
            | Ok actual_value ->
                if Yojson.Safe.equal (`Bool actual_value) expected
                then Ok ()
                else Error (Printf.sprintf "Bool access mismatch: expected %s, got %b" 
                             (Yojson.Safe.to_string expected) actual_value)
            | Error err -> Error err)
       | "get_float" ->
           (match get_float_from_path json_obj args with
            | Ok actual_value ->
                if Yojson.Safe.equal (`Float actual_value) expected
                then Ok ()
                else Error (Printf.sprintf "Float access mismatch: expected %s, got %f" 
                             (Yojson.Safe.to_string expected) actual_value)
            | Error err -> Error err)
       | "get_list" ->
           (match get_list_from_path json_obj args with
            | Ok actual_list ->
                if Yojson.Safe.equal (`List actual_list) expected
                then Ok ()
                else Error (Printf.sprintf "List access mismatch: expected %s, got %s" 
                             (Yojson.Safe.to_string expected) (Yojson.Safe.to_string (`List actual_list)))
            | Error err -> Error err)
       | _ -> Error ("Unknown access type: " ^ access_type))
  | TypedErrorCase { args; error = _error } ->
      (match access_type with
       | "get_string" ->
           (match get_string_from_path json_obj args with
            | Ok _ -> Error "Expected error but string access succeeded"
            | Error _ -> Ok ())
       | "get_int" ->
           (match get_int_from_path json_obj args with
            | Ok _ -> Error "Expected error but int access succeeded"
            | Error _ -> Ok ())
       | "get_bool" ->
           (match get_bool_from_path json_obj args with
            | Ok _ -> Error "Expected error but bool access succeeded"
            | Error _ -> Ok ())
       | "get_float" ->
           (match get_float_from_path json_obj args with
            | Ok _ -> Error "Expected error but float access succeeded"
            | Error _ -> Ok ())
       | "get_list" ->
           (match get_list_from_path json_obj args with
            | Ok _ -> Error "Expected error but list access succeeded"
            | Error _ -> Ok ())
       | _ -> Error ("Unknown access type: " ^ access_type))

let execute_typed_access_validation json_obj validation access_type =
  match validation with
  | TypedCases { cases; _ } ->
      (* Execute all cases and collect results *)
      let results = List.map (fun case_val ->
        execute_typed_access_case json_obj case_val access_type
      ) cases in
      (* Check if all cases passed *)
      let errors = List.filter_map (function
        | Ok () -> None
        | Error msg -> Some msg
      ) results in
      if List.length errors = 0 then Ok ()
      else Error (String.concat "; " errors)

(* Execute Level 5: Pretty print validation *)
let execute_pretty_print_validation (ccl_entries : Ccl.Parser.key_val list) validation =
  match validation with
  | PrettyResult expected_output ->
      (* Use actual CCL Model.pretty function *)
      let ccl_model = Ccl.Model.fix ccl_entries in
      let pretty_output = Ccl.Model.pretty ccl_model in
      if String.equal pretty_output expected_output
      then Ok ()
      else Error (Printf.sprintf "Pretty print validation failed: expected %s, got %s" 
                   expected_output pretty_output)
  | PrettyError _ -> Error "Pretty print error validation not implemented"

(* Execute property validations using the dedicated module *)
let execute_property_validations test_case =
  let { input; validations; _ } = test_case in
  let results = [] in

  (* Execute round trip validation if present *)
  let results = 
    match input, validations.round_trip with
    | Some input_str, Some round_trip_validation ->
        (match Ccl_property_tests.execute_round_trip_validation input_str round_trip_validation with
         | Ok () -> ("round_trip", true, None, 1) :: results
         | Error msg -> ("round_trip", false, Some msg, 1) :: results)
    | None, Some _ -> ("round_trip", false, Some "Missing input for round trip validation", 1) :: results
    | _, None -> results
  in

  (* Execute canonical format validation if present *)
  let results = 
    match input, validations.canonical_format with
    | Some input_str, Some canonical_validation ->
        (match Ccl_property_tests.execute_canonical_format_validation input_str canonical_validation with
         | Ok () -> ("canonical_format", true, None, 1) :: results
         | Error msg -> ("canonical_format", false, Some msg, 1) :: results)
    | None, Some _ -> ("canonical_format", false, Some "Missing input for canonical format validation", 1) :: results
    | _, None -> results
  in

  (* Execute associativity validation if present *)
  let results = 
    match input, validations.associativity with
    | Some input_str, Some associativity_validation ->
        (match Ccl_property_tests.execute_associativity_validation input_str associativity_validation with
         | Ok () -> ("associativity", true, None, 1) :: results
         | Error msg -> ("associativity", false, Some msg, 1) :: results)
    | None, Some _ -> ("associativity", false, Some "Missing input for associativity validation", 1) :: results
    | _, None -> results
  in

  results

(* Helper function to get assertion count from validation *)
let get_assertion_count validation_name validations =
  match validation_name with
  | "parse" ->
      (match validations.Json_test_types.parse with
       | Some (Json_test_types.Entries { count; _ }) -> count
       | Some (Json_test_types.ParseError _) -> 1
       | None -> 0)
  | "parse_value" ->
      (match validations.Json_test_types.parse_value with
       | Some (Json_test_types.Entries { count; _ }) -> count
       | Some (Json_test_types.ParseError _) -> 1
       | None -> 0)
  | "filter" ->
      (match validations.Json_test_types.filter with
       | Some (Json_test_types.FilteredEntries { count; _ }) -> count
       | Some (Json_test_types.FilterError _) -> 1
       | None -> 0)
  | "compose" -> 1
  | "expand_dotted" ->
      (match validations.Json_test_types.expand_dotted with
       | Some (Json_test_types.ExpandedEntries { count; _ }) -> count
       | Some (Json_test_types.ExpandError _) -> 1
       | None -> 0)
  | "make_objects" ->
      (match validations.Json_test_types.make_objects with
       | Some (Json_test_types.ObjectResult { count; _ }) -> count
       | Some (Json_test_types.ObjectError _) -> 1
       | None -> 0)
  | "get_string" | "get_int" | "get_bool" | "get_float" | "get_list" ->
      (match validation_name with
       | "get_string" ->
           (match validations.Json_test_types.get_string with
            | Some (Json_test_types.TypedCases { count; _ }) -> count
            | None -> 0)
       | "get_int" ->
           (match validations.Json_test_types.get_int with
            | Some (Json_test_types.TypedCases { count; _ }) -> count
            | None -> 0)
       | "get_bool" ->
           (match validations.Json_test_types.get_bool with
            | Some (Json_test_types.TypedCases { count; _ }) -> count
            | None -> 0)
       | "get_float" ->
           (match validations.Json_test_types.get_float with
            | Some (Json_test_types.TypedCases { count; _ }) -> count
            | None -> 0)
       | "get_list" ->
           (match validations.Json_test_types.get_list with
            | Some (Json_test_types.TypedCases { count; _ }) -> count
            | None -> 0)
       | _ -> 0)
  | "pretty_print" | "round_trip" | "canonical_format" | "associativity" -> 1
  | _ -> 1

(* Helper function to execute validation with assertion counting *)
let execute_with_count validation_name validations execution_result =
  let assertion_count = get_assertion_count validation_name validations in
  match execution_result with
  | Ok () -> (validation_name, true, None, assertion_count)
  | Error msg -> (validation_name, false, Some msg, assertion_count)

(* Main validation executor *)
let execute_validation test_case =
  let { name = _name; input; input1 = _input1; input2 = _input2; input3 = _input3; validations; meta = _meta } = test_case in
  let results = [] in
  
  (* Execute parse validation if present *)
  let results = 
    match input, validations.parse with
    | Some input_str, Some parse_validation ->
        execute_with_count "parse" validations (execute_parse_validation input_str parse_validation) :: results
    | None, Some _ -> 
        execute_with_count "parse" validations (Error "Missing input for parse validation") :: results
    | _, None -> results
  in

  (* Execute parse_value validation if present *)
  let results = 
    match input, validations.parse_value with
    | Some input_str, Some parse_value_validation ->
        execute_with_count "parse_value" validations (execute_parse_value_validation input_str parse_value_validation) :: results
    | None, Some _ -> 
        execute_with_count "parse_value" validations (Error "Missing input for parse_value validation") :: results
    | _, None -> results
  in

  (* For other validations, we need parsed entries first *)
  let parsed_entries = 
    match input with
    | Some input_str ->
        (match Ccl.Parser.parse input_str with
         | Ok entries -> Some entries
         | Error _ -> None)
    | None -> None
  in

  (* Execute filter validation if present *)
  let results =
    match parsed_entries, validations.filter with
    | Some entries, Some filter_validation ->
        execute_with_count "filter" validations (execute_filter_validation entries filter_validation) :: results
    | None, Some _ -> 
        execute_with_count "filter" validations (Error "No parsed entries for filter validation") :: results
    | _, None -> results
  in

  (* Execute compose validation if present *)
  let results =
    match validations.compose with
    | Some compose_validation ->
        execute_with_count "compose" validations (execute_compose_validation compose_validation) :: results
    | None -> results
  in

  (* Execute expand_dotted validation if present *)
  let results =
    match parsed_entries, validations.expand_dotted with
    | Some entries, Some expand_validation ->
        execute_with_count "expand_dotted" validations (execute_expand_dotted_validation entries expand_validation) :: results
    | None, Some _ -> 
        execute_with_count "expand_dotted" validations (Error "No parsed entries for expand_dotted validation") :: results
    | _, None -> results
  in

  (* Execute make_objects validation if present *)
  let results =
    match parsed_entries, validations.make_objects with
    | Some entries, Some objects_validation ->
        let json_entries = List.map ccl_entry_to_json_entry entries in
        execute_with_count "make_objects" validations (execute_make_objects_validation json_entries objects_validation) :: results
    | None, Some _ -> 
        execute_with_count "make_objects" validations (Error "No parsed entries for make_objects validation") :: results
    | _, None -> results
  in

  (* Execute typed access validations if present - need JSON object from make_objects *)
  let json_obj_opt = 
    match parsed_entries with
    | Some entries ->
        let ccl_model = Ccl.Model.fix entries in
        Some (ccl_model_to_json ccl_model)
    | None -> None
  in

  (* Execute get_string validation if present *)
  let results =
    match json_obj_opt, validations.get_string with
    | Some json_obj, Some string_validation ->
        execute_with_count "get_string" validations (execute_typed_access_validation json_obj string_validation "get_string") :: results
    | None, Some _ -> 
        execute_with_count "get_string" validations (Error "No JSON object for get_string validation") :: results
    | _, None -> results
  in

  (* Execute get_int validation if present *)
  let results =
    match json_obj_opt, validations.get_int with
    | Some json_obj, Some int_validation ->
        execute_with_count "get_int" validations (execute_typed_access_validation json_obj int_validation "get_int") :: results
    | None, Some _ -> 
        execute_with_count "get_int" validations (Error "No JSON object for get_int validation") :: results
    | _, None -> results
  in

  (* Execute get_bool validation if present *)
  let results =
    match json_obj_opt, validations.get_bool with
    | Some json_obj, Some bool_validation ->
        execute_with_count "get_bool" validations (execute_typed_access_validation json_obj bool_validation "get_bool") :: results
    | None, Some _ -> 
        execute_with_count "get_bool" validations (Error "No JSON object for get_bool validation") :: results
    | _, None -> results
  in

  (* Execute get_float validation if present *)
  let results =
    match json_obj_opt, validations.get_float with
    | Some json_obj, Some float_validation ->
        execute_with_count "get_float" validations (execute_typed_access_validation json_obj float_validation "get_float") :: results
    | None, Some _ -> 
        execute_with_count "get_float" validations (Error "No JSON object for get_float validation") :: results
    | _, None -> results
  in

  (* Execute get_list validation if present *)
  let results =
    match json_obj_opt, validations.get_list with
    | Some json_obj, Some list_validation ->
        execute_with_count "get_list" validations (execute_typed_access_validation json_obj list_validation "get_list") :: results
    | None, Some _ -> 
        execute_with_count "get_list" validations (Error "No JSON object for get_list validation") :: results
    | _, None -> results
  in

  (* Execute pretty print validation if present *)
  let results =
    match parsed_entries, validations.pretty_print with
    | Some entries, Some pretty_validation ->
        execute_with_count "pretty_print" validations (execute_pretty_print_validation entries pretty_validation) :: results
    | None, Some _ -> 
        execute_with_count "pretty_print" validations (Error "No parsed entries for pretty print validation") :: results
    | _, None -> results
  in

  (* Execute property validations *)
  let property_results = execute_property_validations test_case in
  let results = property_results @ results in

  List.rev results