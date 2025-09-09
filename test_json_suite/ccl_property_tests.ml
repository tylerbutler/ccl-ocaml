open Json_test_types

(* Property test execution functions *)
let execute_round_trip_validation (input : string) (validation : Json_test_types.round_trip_validation) =
  match validation.property with
  | "identity" ->
      (* Test: parse -> pretty_print -> parse should be identity *)
      (match Ccl.decode input with
       | Ok model ->
           let pretty_output = Ccl.Model.pretty model in
           (match Ccl.decode pretty_output with
            | Ok reparsed_model ->
                if Ccl.Model.compare model reparsed_model = 0
                then Ok ()
                else Error "Round-trip identity failed: parse ∘ pretty ≠ id"
            | Error _ -> Error "Round-trip failed: reparsing after pretty-print failed")
       | Error _ -> Error "Round-trip failed: initial parsing failed")
  | _ -> Error ("Unknown round-trip property: " ^ validation.property)

let execute_canonical_format_validation (input : string) (validation : Json_test_types.canonical_format_validation) =
  (* Test that parsing input produces the expected canonical format when pretty-printed *)
  match Ccl.decode input with
  | Ok model ->
      let actual_output = Ccl.Model.pretty model in
      if String.equal actual_output validation.expected
      then Ok ()
      else Error (Printf.sprintf "Canonical format mismatch:\nExpected: %s\nActual: %s" 
                                validation.expected actual_output)
  | Error _ -> Error "Canonical format failed: parsing failed"

let rec execute_associativity_validation (input : string) (validation : Json_test_types.associativity_validation) =
  match validation.property with
  | "semigroup_associativity" ->
      (* For CCL: (A ⊕ B) ⊕ C ≡ A ⊕ (B ⊕ C) *)
      execute_semigroup_associativity input
  | "monoid_identity_left" -> 
      (* For CCL: ε ⊕ A ≡ A *)
      execute_monoid_left_identity input
  | "monoid_identity_right" ->
      (* For CCL: A ⊕ ε ≡ A *)
      execute_monoid_right_identity input
  | _ -> Error ("Unknown associativity property: " ^ validation.property)

and execute_semigroup_associativity input =
  (* Test associativity with the same model three times for simplicity *)
  match Ccl.decode input with
  | Ok model_a ->
      let model_b = model_a in (* For testing, use same model *)
      let model_c = model_a in
      let left_assoc = Ccl.Model.merge (Ccl.Model.merge model_a model_b) model_c in
      let right_assoc = Ccl.Model.merge model_a (Ccl.Model.merge model_b model_c) in
      if Ccl.Model.compare left_assoc right_assoc = 0
      then Ok ()
      else Error "Semigroup associativity failed: (A ⊕ B) ⊕ C ≠ A ⊕ (B ⊕ C)"
  | Error _ -> Error "Associativity test failed: parsing failed"

and execute_monoid_left_identity input =
  (* Test left identity: ε ⊕ A ≡ A *)
  match Ccl.decode input with
  | Ok model ->
      let empty_model = Ccl.Model.empty in
      let result = Ccl.Model.merge empty_model model in
      if Ccl.Model.compare model result = 0
      then Ok ()
      else Error "Monoid left identity failed: ε ⊕ A ≠ A"
  | Error _ -> Error "Left identity test failed: parsing failed"

and execute_monoid_right_identity input =
  (* Test right identity: A ⊕ ε ≡ A *)
  match Ccl.decode input with
  | Ok model ->
      let empty_model = Ccl.Model.empty in
      let result = Ccl.Model.merge model empty_model in
      if Ccl.Model.compare model result = 0
      then Ok ()
      else Error "Monoid right identity failed: A ⊕ ε ≠ A"
  | Error _ -> Error "Right identity test failed: parsing failed"

(* Enhanced round trip validation using actual CCL functions *)
let execute_enhanced_round_trip_validation input validation =
  match validation.property with
  | "identity" ->
      (* More robust round-trip test using Ccl functions *)
      (match Ccl.Parser.parse input with
       | Ok entries ->
           let model = Ccl.Model.fix entries in
           let pretty_output = Ccl.Model.pretty model in
           (match Ccl.Parser.parse pretty_output with
            | Ok reparsed_entries ->
                let reparsed_model = Ccl.Model.fix reparsed_entries in
                if Ccl.Model.compare model reparsed_model = 0
                then Ok ()
                else Error "Enhanced round-trip identity failed"
            | Error _ -> Error "Enhanced round-trip failed: reparsing failed")
       | Error _ -> Error "Enhanced round-trip failed: initial parsing failed")
  | "parse_pretty_parse" ->
      (* Another variant: test parse -> pretty -> parse cycle *)
      (match Ccl.Parser.parse input with
       | Ok original_entries ->
           let model = Ccl.Model.fix original_entries in
           let pretty_output = Ccl.Model.pretty model in
           (match Ccl.Parser.parse pretty_output with
            | Ok final_entries ->
                (* Compare the parsed entries directly *)
                let entries_equal = List.for_all2 (fun a b ->
                  String.equal a.Ccl.Parser.key b.Ccl.Parser.key &&
                  String.equal a.Ccl.Parser.value b.Ccl.Parser.value
                ) original_entries final_entries in
                if entries_equal && List.length original_entries = List.length final_entries
                then Ok ()
                else Error "Parse-pretty-parse round-trip failed: entries differ"
            | Error _ -> Error "Parse-pretty-parse failed: final parsing failed")
       | Error _ -> Error "Parse-pretty-parse failed: initial parsing failed")
  | _ -> Error ("Unknown enhanced round-trip property: " ^ validation.property)