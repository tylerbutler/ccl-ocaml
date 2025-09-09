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
       | Entries expected_entries ->
           if List.equal (fun a b -> String.equal a.key b.key && String.equal a.value b.value) 
                        json_entries expected_entries
           then Ok ()
           else Error (Printf.sprintf "Parse mismatch: expected %d entries, got %d entries"
                      (List.length expected_entries) (List.length json_entries))
       | ParseError _ ->
           Error "Expected parse error but parsing succeeded")
  | Error (`Parse_error msg) ->
      (match validation with
       | ParseError _error_validation ->
           (* TODO: Match against specific error patterns if needed *)
           Ok ()
       | Entries _ ->
           Error ("Expected successful parse but got error: " ^ msg))

(* Execute Level 2: Parse Value - Indentation-aware parsing *)
let execute_parse_value_validation input validation =
  match Ccl.Parser.parse_value input with
  | Ok entries ->
      let json_entries = List.map ccl_entry_to_json_entry entries in
      (match validation with
       | Entries expected_entries ->
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
  | FilteredEntries expected_entries -> 
      (* Basic implementation: filter entries by key pattern *)
      let json_entries = List.map ccl_entry_to_json_entry entries in
      (* For now, assume no filtering - compare entries directly *)
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
  | ExpandedEntries expected_entries ->
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
        let assoc_list = Ccl.Model.KeyMap.fold (fun key value acc ->
          (key, model_to_json_value value) :: acc
        ) map [] in
        `Assoc (List.rev assoc_list)
  in
  model_to_json_value model

(* Execute Level 3: Make objects validation *)
let execute_make_objects_validation entries validation =
  match validation with
  | ObjectResult expected_json ->
      (* Use CCL Model.fix to construct the hierarchical object *)
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

(* Execute Level 4: Typed access validation *)
let execute_typed_access_validation json_obj validation access_type =
  match validation with
  | TypedResult { args; expected } ->
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
       | _ -> Error ("Unknown access type: " ^ access_type))
  | TypedError { args; error = _error } ->
      (* Test that access with given args produces an error *)
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
       | _ -> Error ("Unknown access type: " ^ access_type))

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
         | Ok () -> ("round_trip", true, None) :: results
         | Error msg -> ("round_trip", false, Some msg) :: results)
    | None, Some _ -> ("round_trip", false, Some "Missing input for round trip validation") :: results
    | _, None -> results
  in

  (* Execute canonical format validation if present *)
  let results = 
    match input, validations.canonical_format with
    | Some input_str, Some canonical_validation ->
        (match Ccl_property_tests.execute_canonical_format_validation input_str canonical_validation with
         | Ok () -> ("canonical_format", true, None) :: results
         | Error msg -> ("canonical_format", false, Some msg) :: results)
    | None, Some _ -> ("canonical_format", false, Some "Missing input for canonical format validation") :: results
    | _, None -> results
  in

  (* Execute associativity validation if present *)
  let results = 
    match input, validations.associativity with
    | Some input_str, Some associativity_validation ->
        (match Ccl_property_tests.execute_associativity_validation input_str associativity_validation with
         | Ok () -> ("associativity", true, None) :: results
         | Error msg -> ("associativity", false, Some msg) :: results)
    | None, Some _ -> ("associativity", false, Some "Missing input for associativity validation") :: results
    | _, None -> results
  in

  results

(* Main validation executor *)
let execute_validation test_case =
  let { name = _name; input; input1 = _input1; input2 = _input2; input3 = _input3; validations; meta = _meta } = test_case in
  let results = [] in
  
  (* Execute parse validation if present *)
  let results = 
    match input, validations.parse with
    | Some input_str, Some parse_validation ->
        (match execute_parse_validation input_str parse_validation with
         | Ok () -> ("parse", true, None) :: results
         | Error msg -> ("parse", false, Some msg) :: results)
    | None, Some _ -> ("parse", false, Some "Missing input for parse validation") :: results
    | _, None -> results
  in

  (* Execute parse_value validation if present *)
  let results = 
    match input, validations.parse_value with
    | Some input_str, Some parse_value_validation ->
        (match execute_parse_value_validation input_str parse_value_validation with
         | Ok () -> ("parse_value", true, None) :: results
         | Error msg -> ("parse_value", false, Some msg) :: results)
    | None, Some _ -> ("parse_value", false, Some "Missing input for parse_value validation") :: results
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
        (match execute_filter_validation entries filter_validation with
         | Ok () -> ("filter", true, None) :: results
         | Error msg -> ("filter", false, Some msg) :: results)
    | None, Some _ -> ("filter", false, Some "No parsed entries for filter validation") :: results
    | _, None -> results
  in

  (* Execute compose validation if present *)
  let results =
    match validations.compose with
    | Some compose_validation ->
        (match execute_compose_validation compose_validation with
         | Ok () -> ("compose", true, None) :: results
         | Error msg -> ("compose", false, Some msg) :: results)
    | None -> results
  in

  (* Execute expand_dotted validation if present *)
  let results =
    match parsed_entries, validations.expand_dotted with
    | Some entries, Some expand_validation ->
        (match execute_expand_dotted_validation entries expand_validation with
         | Ok () -> ("expand_dotted", true, None) :: results
         | Error msg -> ("expand_dotted", false, Some msg) :: results)
    | None, Some _ -> ("expand_dotted", false, Some "No parsed entries for expand_dotted validation") :: results
    | _, None -> results
  in

  (* Execute make_objects validation if present *)
  let results =
    match parsed_entries, validations.make_objects with
    | Some entries, Some objects_validation ->
        let json_entries = List.map ccl_entry_to_json_entry entries in
        (match execute_make_objects_validation json_entries objects_validation with
         | Ok () -> ("make_objects", true, None) :: results
         | Error msg -> ("make_objects", false, Some msg) :: results)
    | None, Some _ -> ("make_objects", false, Some "No parsed entries for make_objects validation") :: results
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
        (match execute_typed_access_validation json_obj string_validation "get_string" with
         | Ok () -> ("get_string", true, None) :: results
         | Error msg -> ("get_string", false, Some msg) :: results)
    | None, Some _ -> ("get_string", false, Some "No JSON object for get_string validation") :: results
    | _, None -> results
  in

  (* Execute get_int validation if present *)
  let results =
    match json_obj_opt, validations.get_int with
    | Some json_obj, Some int_validation ->
        (match execute_typed_access_validation json_obj int_validation "get_int" with
         | Ok () -> ("get_int", true, None) :: results
         | Error msg -> ("get_int", false, Some msg) :: results)
    | None, Some _ -> ("get_int", false, Some "No JSON object for get_int validation") :: results
    | _, None -> results
  in

  (* Execute get_bool validation if present *)
  let results =
    match json_obj_opt, validations.get_bool with
    | Some json_obj, Some bool_validation ->
        (match execute_typed_access_validation json_obj bool_validation "get_bool" with
         | Ok () -> ("get_bool", true, None) :: results
         | Error msg -> ("get_bool", false, Some msg) :: results)
    | None, Some _ -> ("get_bool", false, Some "No JSON object for get_bool validation") :: results
    | _, None -> results
  in

  (* Execute get_float validation if present *)
  let results =
    match json_obj_opt, validations.get_float with
    | Some json_obj, Some float_validation ->
        (match execute_typed_access_validation json_obj float_validation "get_float" with
         | Ok () -> ("get_float", true, None) :: results
         | Error msg -> ("get_float", false, Some msg) :: results)
    | None, Some _ -> ("get_float", false, Some "No JSON object for get_float validation") :: results
    | _, None -> results
  in

  (* Execute pretty print validation if present *)
  let results =
    match parsed_entries, validations.pretty_print with
    | Some entries, Some pretty_validation ->
        (match execute_pretty_print_validation entries pretty_validation with
         | Ok () -> ("pretty_print", true, None) :: results
         | Error msg -> ("pretty_print", false, Some msg) :: results)
    | None, Some _ -> ("pretty_print", false, Some "No parsed entries for pretty print validation") :: results
    | _, None -> results
  in

  (* Execute property validations *)
  let property_results = execute_property_validations test_case in
  let results = property_results @ results in

  List.rev results