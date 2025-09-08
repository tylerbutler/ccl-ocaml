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

(* Execute Level 2: Filter validation *)
let execute_filter_validation entries validation =
  (* TODO: Implement filtering logic when CCL library supports it *)
  match validation with
  | FilteredEntries expected_entries -> 
      (* For now, assume no filtering - just compare entries *)
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
      (* TODO: Implement composition when CCL library supports it *)
      (* For now, assume composition is concatenation *)
      let composed = left @ right in
      if List.equal (fun a b -> String.equal a.key b.key && String.equal a.value b.value) 
                   composed expected
      then Ok ()
      else Error "Compose validation failed"
  | ComposeError _ -> Error "Compose error validation not implemented"

(* Execute Level 2: Expand dotted keys validation *)
let execute_expand_dotted_validation entries validation =
  match validation with
  | ExpandedEntries expected_entries ->
      (* TODO: Implement dotted key expansion when CCL library supports it *)
      let json_entries = List.map ccl_entry_to_json_entry entries in
      if List.equal (fun a b -> String.equal a.key b.key && String.equal a.value b.value) 
                   json_entries expected_entries
      then Ok ()
      else Error "Expand dotted validation failed"
  | ExpandError _ -> Error "Expand dotted error validation not implemented"

(* Execute Level 3: Make objects validation *)
let execute_make_objects_validation entries validation =
  match validation with
  | ObjectResult expected_json ->
      (* TODO: Implement object construction when CCL library supports it *)
      (* For now, create a simple JSON object from entries *)
      let json_obj = `Assoc (List.map (fun entry -> (entry.key, `String entry.value)) 
                            (List.map ccl_entry_to_json_entry entries)) in
      (* Simple comparison - in practice would need more sophisticated comparison *)
      if Yojson.Safe.equal json_obj expected_json
      then Ok ()
      else Error "Make objects validation failed"
  | ObjectError _ -> Error "Make objects error validation not implemented"

(* Execute Level 4: Typed access validation *)
let execute_typed_access_validation json_obj validation access_type =
  match validation with
  | TypedResult { args; expected } ->
      (* TODO: Implement typed access when CCL library supports it *)
      (* For now, simulate path-based access to JSON object *)
      let rec access_path obj path =
        match path, obj with
        | [], value -> Ok value
        | key :: rest, `Assoc assoc ->
            (match List.assoc_opt key assoc with
             | Some value -> access_path value rest
             | None -> Error ("Key not found: " ^ key))
        | _ -> Error "Invalid path for object structure"
      in
      (match access_path json_obj args with
       | Ok actual_value ->
           if Yojson.Safe.equal actual_value expected
           then Ok ()
           else Error (Printf.sprintf "Typed access mismatch for %s access" access_type)
       | Error err -> Error err)
  | TypedError { args = _args; error = _error } ->
      (* TODO: Validate that access with given args produces expected error *)
      Error "Typed access error validation not implemented"

(* Execute pretty print validation *)
let execute_pretty_print_validation entries validation =
  match validation with
  | PrettyResult expected_output ->
      (* TODO: Implement pretty printing when CCL library supports it *)
      (* For now, create simple key=value format *)
      let pretty_output = String.concat "\n" 
        (List.map (fun entry -> 
          let json_entry = ccl_entry_to_json_entry entry in
          json_entry.key ^ " = " ^ json_entry.value) entries) in
      if String.equal pretty_output expected_output
      then Ok ()
      else Error "Pretty print validation failed"
  | PrettyError _ -> Error "Pretty print error validation not implemented"

(* Execute round trip validation *)
let execute_round_trip_validation input validation =
  match validation with
  | { property = "identity"; description = _description } ->
      (* Test: parse -> pretty_print -> parse should be identity *)
      (match Ccl.Parser.parse input with
       | Ok entries ->
           (* TODO: Use actual pretty print function when available *)
           let pretty_output = String.concat "\n" 
             (List.map (fun entry -> entry.Ccl.Parser.key ^ " = " ^ entry.Ccl.Parser.value) entries) in
           (match Ccl.Parser.parse pretty_output with
            | Ok reparsed_entries ->
                if List.equal (fun a b -> String.equal a.Ccl.Parser.key b.Ccl.Parser.key && String.equal a.Ccl.Parser.value b.Ccl.Parser.value)
                             entries reparsed_entries
                then Ok ()
                else Error "Round trip validation failed: not identity"
            | Error _ -> Error "Round trip validation failed: reparsing failed")
       | Error _ -> Error "Round trip validation failed: initial parsing failed")
  | { property; _ } -> Error ("Unknown round trip property: " ^ property)

(* Execute canonical format validation *)
let execute_canonical_format_validation entries validation =
  match validation with
  | { expected; description = _description } ->
      (* TODO: Implement canonical formatting when CCL library supports it *)
      let canonical_output = String.concat "\n" 
        (List.map (fun entry -> 
          let json_entry = ccl_entry_to_json_entry entry in
          json_entry.key ^ "=" ^ json_entry.value) entries) in
      if String.equal canonical_output expected
      then Ok ()
      else Error "Canonical format validation failed"

(* Execute associativity validation *)
let execute_associativity_validation _input1 _input2 _input3 validation =
  match validation with
  | { property = "semigroup_associativity"; should_be_equal = true; _ } ->
      (* Test: (input1 ⊕ input2) ⊕ input3 ≡ input1 ⊕ (input2 ⊕ input3) *)
      (* TODO: Implement composition operation when CCL library supports it *)
      Error "Associativity validation not implemented - requires composition operation"
  | { property = "monoid_identity_left"; should_be_equal = true; _ } ->
      (* Test: ε ⊕ input ≡ input *)
      Error "Left identity validation not implemented - requires empty element and composition"
  | { property = "monoid_identity_right"; should_be_equal = true; _ } ->
      (* Test: input ⊕ ε ≡ input *)  
      Error "Right identity validation not implemented - requires empty element and composition"
  | { property; _ } -> Error ("Unknown associativity property: " ^ property)

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

  (* Execute other validations similarly... *)
  (* TODO: Add expand_dotted, make_objects, typed access validations *)

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

  (* Execute round trip validation if present *)
  let results =
    match input, validations.round_trip with
    | Some input_str, Some round_trip_validation ->
        (match execute_round_trip_validation input_str round_trip_validation with
         | Ok () -> ("round_trip", true, None) :: results
         | Error msg -> ("round_trip", false, Some msg) :: results)
    | None, Some _ -> ("round_trip", false, Some "Missing input for round trip validation") :: results
    | _, None -> results
  in

  List.rev results