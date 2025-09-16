(* Auto-generated from "ccl_test_types.atd" *)
[@@@ocaml.warning "-27-32-33-35-39"]

type test_caseVariants = Ccl_test_types_t.test_caseVariants

(** Single CCL function to validate *)
type test_caseValidation = Ccl_test_types_t.test_caseValidation

type test_caseFunctions = Ccl_test_types_t.test_caseFunctions

type test_caseFeatures = Ccl_test_types_t.test_caseFeatures

(** Mutually exclusive options by category *)
type test_caseConflicts = Ccl_test_types_t.test_caseConflicts = {
  functions: string list option;
  behaviors: string list option;
  variants: string list option;
  features: string list option
}

type test_caseBehaviors = Ccl_test_types_t.test_caseBehaviors

type json = Yojson.Basic.t

type test_case = Ccl_test_types_t.test_case = {
  name: string (** Unique test name (source_name + validation function) *);
  input: string (** CCL input text to be tested *);
  validation: test_caseValidation (** Single CCL function to validate *);
  expected: json (** Expected test results with flexible structure *);
  args: string list option
    (**
      Arguments for typed access functions (get_string, get_int, get_bool,
      get_float, get_list). Required for these functions, omitted for others.
    *);
  functions: test_caseFunctions list option
    (** CCL functions tested by this test *);
  behaviors: test_caseBehaviors list (** Implementation behavior choices *);
  variants: test_caseVariants list (** Specification variants *);
  features: test_caseFeatures list (** Required language features *);
  conflicts: test_caseConflicts option
    (** Mutually exclusive options by category *);
  requires: string list option
    (** Functions that must be implemented as prerequisites *);
  level: int option (** CCL implementation level (1-5) *);
  source_test: string option
    (** Original source test name for traceability *);
  expect_error: bool (** Whether this test should produce an error *);
  error_type: string option (** Expected error type for error tests *)
}

(** Schema for existing generated flat test files (star-flat.json) *)
type test_suite = Ccl_test_types_t.test_suite = {
  schema: string (** JSON Schema reference *);
  tests: test_case list
}

type root = Ccl_test_types_t.root

type int64 = Ccl_test_types_t.int64

let write_test_caseVariants = (
  fun ob x ->
    match x with
      | `Proposed_behavior -> Buffer.add_string ob "<\"proposed_behavior\">"
      | `Reference_compliant -> Buffer.add_string ob "<\"reference_compliant\">"
)
let string_of_test_caseVariants ?(len = 1024) x =
  let ob = Buffer.create len in
  write_test_caseVariants ob x;
  Buffer.contents ob
let read_test_caseVariants = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "proposed_behavior" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Proposed_behavior
            | "reference_compliant" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Reference_compliant
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "proposed_behavior" ->
              `Proposed_behavior
            | "reference_compliant" ->
              `Reference_compliant
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let test_caseVariants_of_string s =
  read_test_caseVariants (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_test_caseValidation = (
  fun ob x ->
    match x with
      | `Parse -> Buffer.add_string ob "<\"parse\">"
      | `Parse_value -> Buffer.add_string ob "<\"parse_value\">"
      | `Filter -> Buffer.add_string ob "<\"filter\">"
      | `Compose -> Buffer.add_string ob "<\"compose\">"
      | `Expand_dotted -> Buffer.add_string ob "<\"expand_dotted\">"
      | `Build_hierarchy -> Buffer.add_string ob "<\"build_hierarchy\">"
      | `Get_string -> Buffer.add_string ob "<\"get_string\">"
      | `Get_int -> Buffer.add_string ob "<\"get_int\">"
      | `Get_bool -> Buffer.add_string ob "<\"get_bool\">"
      | `Get_float -> Buffer.add_string ob "<\"get_float\">"
      | `Get_list -> Buffer.add_string ob "<\"get_list\">"
      | `Canonical_format -> Buffer.add_string ob "<\"canonical_format\">"
      | `Load -> Buffer.add_string ob "<\"load\">"
      | `Round_trip -> Buffer.add_string ob "<\"round_trip\">"
      | `Associativity -> Buffer.add_string ob "<\"associativity\">"
)
let string_of_test_caseValidation ?(len = 1024) x =
  let ob = Buffer.create len in
  write_test_caseValidation ob x;
  Buffer.contents ob
let read_test_caseValidation = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "parse" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Parse
            | "parse_value" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Parse_value
            | "filter" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Filter
            | "compose" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Compose
            | "expand_dotted" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Expand_dotted
            | "build_hierarchy" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Build_hierarchy
            | "get_string" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Get_string
            | "get_int" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Get_int
            | "get_bool" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Get_bool
            | "get_float" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Get_float
            | "get_list" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Get_list
            | "canonical_format" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Canonical_format
            | "load" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Load
            | "round_trip" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Round_trip
            | "associativity" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Associativity
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "parse" ->
              `Parse
            | "parse_value" ->
              `Parse_value
            | "filter" ->
              `Filter
            | "compose" ->
              `Compose
            | "expand_dotted" ->
              `Expand_dotted
            | "build_hierarchy" ->
              `Build_hierarchy
            | "get_string" ->
              `Get_string
            | "get_int" ->
              `Get_int
            | "get_bool" ->
              `Get_bool
            | "get_float" ->
              `Get_float
            | "get_list" ->
              `Get_list
            | "canonical_format" ->
              `Canonical_format
            | "load" ->
              `Load
            | "round_trip" ->
              `Round_trip
            | "associativity" ->
              `Associativity
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let test_caseValidation_of_string s =
  read_test_caseValidation (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_test_caseFunctions = (
  fun ob x ->
    match x with
      | `Parse -> Buffer.add_string ob "<\"parse\">"
      | `Parse_value -> Buffer.add_string ob "<\"parse_value\">"
      | `Filter -> Buffer.add_string ob "<\"filter\">"
      | `Compose -> Buffer.add_string ob "<\"compose\">"
      | `Expand_dotted -> Buffer.add_string ob "<\"expand_dotted\">"
      | `Build_hierarchy -> Buffer.add_string ob "<\"build_hierarchy\">"
      | `Get_string -> Buffer.add_string ob "<\"get_string\">"
      | `Get_int -> Buffer.add_string ob "<\"get_int\">"
      | `Get_bool -> Buffer.add_string ob "<\"get_bool\">"
      | `Get_float -> Buffer.add_string ob "<\"get_float\">"
      | `Get_list -> Buffer.add_string ob "<\"get_list\">"
      | `Canonical_format -> Buffer.add_string ob "<\"canonical_format\">"
      | `Load -> Buffer.add_string ob "<\"load\">"
      | `Round_trip -> Buffer.add_string ob "<\"round_trip\">"
      | `Associativity -> Buffer.add_string ob "<\"associativity\">"
)
let string_of_test_caseFunctions ?(len = 1024) x =
  let ob = Buffer.create len in
  write_test_caseFunctions ob x;
  Buffer.contents ob
let read_test_caseFunctions = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "parse" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Parse
            | "parse_value" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Parse_value
            | "filter" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Filter
            | "compose" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Compose
            | "expand_dotted" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Expand_dotted
            | "build_hierarchy" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Build_hierarchy
            | "get_string" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Get_string
            | "get_int" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Get_int
            | "get_bool" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Get_bool
            | "get_float" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Get_float
            | "get_list" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Get_list
            | "canonical_format" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Canonical_format
            | "load" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Load
            | "round_trip" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Round_trip
            | "associativity" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Associativity
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "parse" ->
              `Parse
            | "parse_value" ->
              `Parse_value
            | "filter" ->
              `Filter
            | "compose" ->
              `Compose
            | "expand_dotted" ->
              `Expand_dotted
            | "build_hierarchy" ->
              `Build_hierarchy
            | "get_string" ->
              `Get_string
            | "get_int" ->
              `Get_int
            | "get_bool" ->
              `Get_bool
            | "get_float" ->
              `Get_float
            | "get_list" ->
              `Get_list
            | "canonical_format" ->
              `Canonical_format
            | "load" ->
              `Load
            | "round_trip" ->
              `Round_trip
            | "associativity" ->
              `Associativity
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let test_caseFunctions_of_string s =
  read_test_caseFunctions (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_test_caseFeatures = (
  fun ob x ->
    match x with
      | `Comments -> Buffer.add_string ob "<\"comments\">"
      | `Empty_keys -> Buffer.add_string ob "<\"empty_keys\">"
      | `Experimental_dotted_keys -> Buffer.add_string ob "<\"experimental_dotted_keys\">"
      | `Multiline -> Buffer.add_string ob "<\"multiline\">"
      | `Unicode -> Buffer.add_string ob "<\"unicode\">"
      | `Whitespace -> Buffer.add_string ob "<\"whitespace\">"
)
let string_of_test_caseFeatures ?(len = 1024) x =
  let ob = Buffer.create len in
  write_test_caseFeatures ob x;
  Buffer.contents ob
let read_test_caseFeatures = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "comments" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Comments
            | "empty_keys" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Empty_keys
            | "experimental_dotted_keys" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Experimental_dotted_keys
            | "multiline" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Multiline
            | "unicode" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Unicode
            | "whitespace" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Whitespace
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "comments" ->
              `Comments
            | "empty_keys" ->
              `Empty_keys
            | "experimental_dotted_keys" ->
              `Experimental_dotted_keys
            | "multiline" ->
              `Multiline
            | "unicode" ->
              `Unicode
            | "whitespace" ->
              `Whitespace
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let test_caseFeatures_of_string s =
  read_test_caseFeatures (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__string_list = (
  Atdgen_runtime.Oj_run.write_list (
    Yojson.Safe.write_string
  )
)
let string_of__string_list ?(len = 1024) x =
  let ob = Buffer.create len in
  write__string_list ob x;
  Buffer.contents ob
let read__string_list = (
  Atdgen_runtime.Oj_run.read_list (
    Atdgen_runtime.Oj_run.read_string
  )
)
let _string_list_of_string s =
  read__string_list (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__string_list_option = (
  Atdgen_runtime.Oj_run.write_option (
    write__string_list
  )
)
let string_of__string_list_option ?(len = 1024) x =
  let ob = Buffer.create len in
  write__string_list_option ob x;
  Buffer.contents ob
let read__string_list_option = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "None" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (None : _ option)
            | "Some" ->
              Atdgen_runtime.Oj_run.read_until_field_value p lb;
              let x = (
                  read__string_list
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "None" ->
              (None : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | "Some" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_comma p lb;
              Yojson.Safe.read_space p lb;
              let x = (
                  read__string_list
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _string_list_option_of_string s =
  read__string_list_option (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_test_caseConflicts : _ -> test_caseConflicts -> _ = (
  fun ob (x : test_caseConflicts) ->
    Buffer.add_char ob '{';
    let is_first = ref true in
    (match x.functions with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"functions\":";
      (
        write__string_list
      )
        ob x;
    );
    (match x.behaviors with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"behaviors\":";
      (
        write__string_list
      )
        ob x;
    );
    (match x.variants with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"variants\":";
      (
        write__string_list
      )
        ob x;
    );
    (match x.features with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"features\":";
      (
        write__string_list
      )
        ob x;
    );
    Buffer.add_char ob '}';
)
let string_of_test_caseConflicts ?(len = 1024) x =
  let ob = Buffer.create len in
  write_test_caseConflicts ob x;
  Buffer.contents ob
let read_test_caseConflicts = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    Yojson.Safe.read_lcurl p lb;
    let field_functions = ref (None) in
    let field_behaviors = ref (None) in
    let field_variants = ref (None) in
    let field_features = ref (None) in
    try
      Yojson.Safe.read_space p lb;
      Yojson.Safe.read_object_end lb;
      Yojson.Safe.read_space p lb;
      let f =
        fun s pos len ->
          if pos < 0 || len < 0 || pos + len > String.length s then
            invalid_arg (Printf.sprintf "out-of-bounds substring position or length: string = %S, requested position = %i, requested length = %i" s pos len);
          match len with
            | 8 -> (
                match String.unsafe_get s pos with
                  | 'f' -> (
                      if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'a' && String.unsafe_get s (pos+3) = 't' && String.unsafe_get s (pos+4) = 'u' && String.unsafe_get s (pos+5) = 'r' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 's' then (
                        3
                      )
                      else (
                        -1
                      )
                    )
                  | 'v' -> (
                      if String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'r' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 'a' && String.unsafe_get s (pos+5) = 'n' && String.unsafe_get s (pos+6) = 't' && String.unsafe_get s (pos+7) = 's' then (
                        2
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | 9 -> (
                match String.unsafe_get s pos with
                  | 'b' -> (
                      if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'h' && String.unsafe_get s (pos+3) = 'a' && String.unsafe_get s (pos+4) = 'v' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'o' && String.unsafe_get s (pos+7) = 'r' && String.unsafe_get s (pos+8) = 's' then (
                        1
                      )
                      else (
                        -1
                      )
                    )
                  | 'f' -> (
                      if String.unsafe_get s (pos+1) = 'u' && String.unsafe_get s (pos+2) = 'n' && String.unsafe_get s (pos+3) = 'c' && String.unsafe_get s (pos+4) = 't' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'o' && String.unsafe_get s (pos+7) = 'n' && String.unsafe_get s (pos+8) = 's' then (
                        0
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | _ -> (
                -1
              )
      in
      let i = Yojson.Safe.map_ident p f lb in
      Atdgen_runtime.Oj_run.read_until_field_value p lb;
      (
        match i with
          | 0 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_functions := (
                Some (
                  (
                    read__string_list
                  ) p lb
                )
              );
            )
          | 1 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_behaviors := (
                Some (
                  (
                    read__string_list
                  ) p lb
                )
              );
            )
          | 2 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_variants := (
                Some (
                  (
                    read__string_list
                  ) p lb
                )
              );
            )
          | 3 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_features := (
                Some (
                  (
                    read__string_list
                  ) p lb
                )
              );
            )
          | _ -> (
              Yojson.Safe.skip_json p lb
            )
      );
      while true do
        Yojson.Safe.read_space p lb;
        Yojson.Safe.read_object_sep p lb;
        Yojson.Safe.read_space p lb;
        let f =
          fun s pos len ->
            if pos < 0 || len < 0 || pos + len > String.length s then
              invalid_arg (Printf.sprintf "out-of-bounds substring position or length: string = %S, requested position = %i, requested length = %i" s pos len);
            match len with
              | 8 -> (
                  match String.unsafe_get s pos with
                    | 'f' -> (
                        if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'a' && String.unsafe_get s (pos+3) = 't' && String.unsafe_get s (pos+4) = 'u' && String.unsafe_get s (pos+5) = 'r' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 's' then (
                          3
                        )
                        else (
                          -1
                        )
                      )
                    | 'v' -> (
                        if String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'r' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 'a' && String.unsafe_get s (pos+5) = 'n' && String.unsafe_get s (pos+6) = 't' && String.unsafe_get s (pos+7) = 's' then (
                          2
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | 9 -> (
                  match String.unsafe_get s pos with
                    | 'b' -> (
                        if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'h' && String.unsafe_get s (pos+3) = 'a' && String.unsafe_get s (pos+4) = 'v' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'o' && String.unsafe_get s (pos+7) = 'r' && String.unsafe_get s (pos+8) = 's' then (
                          1
                        )
                        else (
                          -1
                        )
                      )
                    | 'f' -> (
                        if String.unsafe_get s (pos+1) = 'u' && String.unsafe_get s (pos+2) = 'n' && String.unsafe_get s (pos+3) = 'c' && String.unsafe_get s (pos+4) = 't' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'o' && String.unsafe_get s (pos+7) = 'n' && String.unsafe_get s (pos+8) = 's' then (
                          0
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | _ -> (
                  -1
                )
        in
        let i = Yojson.Safe.map_ident p f lb in
        Atdgen_runtime.Oj_run.read_until_field_value p lb;
        (
          match i with
            | 0 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_functions := (
                  Some (
                    (
                      read__string_list
                    ) p lb
                  )
                );
              )
            | 1 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_behaviors := (
                  Some (
                    (
                      read__string_list
                    ) p lb
                  )
                );
              )
            | 2 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_variants := (
                  Some (
                    (
                      read__string_list
                    ) p lb
                  )
                );
              )
            | 3 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_features := (
                  Some (
                    (
                      read__string_list
                    ) p lb
                  )
                );
              )
            | _ -> (
                Yojson.Safe.skip_json p lb
              )
        );
      done;
      assert false;
    with Yojson.End_of_object -> (
        (
          {
            functions = !field_functions;
            behaviors = !field_behaviors;
            variants = !field_variants;
            features = !field_features;
          }
         : test_caseConflicts)
      )
)
let test_caseConflicts_of_string s =
  read_test_caseConflicts (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_test_caseBehaviors = (
  fun ob x ->
    match x with
      | `Boolean_strict -> Buffer.add_string ob "<\"boolean_strict\">"
      | `Boolean_lenient -> Buffer.add_string ob "<\"boolean_lenient\">"
      | `Crlf_preserve_literal -> Buffer.add_string ob "<\"crlf_preserve_literal\">"
      | `Crlf_normalize_to_lf -> Buffer.add_string ob "<\"crlf_normalize_to_lf\">"
      | `Tabs_preserve -> Buffer.add_string ob "<\"tabs_preserve\">"
      | `Tabs_to_spaces -> Buffer.add_string ob "<\"tabs_to_spaces\">"
      | `Strict_spacing -> Buffer.add_string ob "<\"strict_spacing\">"
      | `Loose_spacing -> Buffer.add_string ob "<\"loose_spacing\">"
      | `List_coercion_enabled -> Buffer.add_string ob "<\"list_coercion_enabled\">"
      | `List_coercion_disabled -> Buffer.add_string ob "<\"list_coercion_disabled\">"
)
let string_of_test_caseBehaviors ?(len = 1024) x =
  let ob = Buffer.create len in
  write_test_caseBehaviors ob x;
  Buffer.contents ob
let read_test_caseBehaviors = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "boolean_strict" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Boolean_strict
            | "boolean_lenient" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Boolean_lenient
            | "crlf_preserve_literal" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Crlf_preserve_literal
            | "crlf_normalize_to_lf" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Crlf_normalize_to_lf
            | "tabs_preserve" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Tabs_preserve
            | "tabs_to_spaces" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Tabs_to_spaces
            | "strict_spacing" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Strict_spacing
            | "loose_spacing" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Loose_spacing
            | "list_coercion_enabled" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `List_coercion_enabled
            | "list_coercion_disabled" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `List_coercion_disabled
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "boolean_strict" ->
              `Boolean_strict
            | "boolean_lenient" ->
              `Boolean_lenient
            | "crlf_preserve_literal" ->
              `Crlf_preserve_literal
            | "crlf_normalize_to_lf" ->
              `Crlf_normalize_to_lf
            | "tabs_preserve" ->
              `Tabs_preserve
            | "tabs_to_spaces" ->
              `Tabs_to_spaces
            | "strict_spacing" ->
              `Strict_spacing
            | "loose_spacing" ->
              `Loose_spacing
            | "list_coercion_enabled" ->
              `List_coercion_enabled
            | "list_coercion_disabled" ->
              `List_coercion_disabled
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let test_caseBehaviors_of_string s =
  read_test_caseBehaviors (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_json = (
  Yojson.Basic.write_t
)
let string_of_json ?(len = 1024) x =
  let ob = Buffer.create len in
  write_json ob x;
  Buffer.contents ob
let read_json = (
  Yojson.Basic.read_t
)
let json_of_string s =
  read_json (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__test_caseVariants_list = (
  Atdgen_runtime.Oj_run.write_list (
    write_test_caseVariants
  )
)
let string_of__test_caseVariants_list ?(len = 1024) x =
  let ob = Buffer.create len in
  write__test_caseVariants_list ob x;
  Buffer.contents ob
let read__test_caseVariants_list = (
  Atdgen_runtime.Oj_run.read_list (
    read_test_caseVariants
  )
)
let _test_caseVariants_list_of_string s =
  read__test_caseVariants_list (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__test_caseFunctions_list = (
  Atdgen_runtime.Oj_run.write_list (
    write_test_caseFunctions
  )
)
let string_of__test_caseFunctions_list ?(len = 1024) x =
  let ob = Buffer.create len in
  write__test_caseFunctions_list ob x;
  Buffer.contents ob
let read__test_caseFunctions_list = (
  Atdgen_runtime.Oj_run.read_list (
    read_test_caseFunctions
  )
)
let _test_caseFunctions_list_of_string s =
  read__test_caseFunctions_list (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__test_caseFunctions_list_option = (
  Atdgen_runtime.Oj_run.write_option (
    write__test_caseFunctions_list
  )
)
let string_of__test_caseFunctions_list_option ?(len = 1024) x =
  let ob = Buffer.create len in
  write__test_caseFunctions_list_option ob x;
  Buffer.contents ob
let read__test_caseFunctions_list_option = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "None" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (None : _ option)
            | "Some" ->
              Atdgen_runtime.Oj_run.read_until_field_value p lb;
              let x = (
                  read__test_caseFunctions_list
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "None" ->
              (None : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | "Some" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_comma p lb;
              Yojson.Safe.read_space p lb;
              let x = (
                  read__test_caseFunctions_list
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _test_caseFunctions_list_option_of_string s =
  read__test_caseFunctions_list_option (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__test_caseFeatures_list = (
  Atdgen_runtime.Oj_run.write_list (
    write_test_caseFeatures
  )
)
let string_of__test_caseFeatures_list ?(len = 1024) x =
  let ob = Buffer.create len in
  write__test_caseFeatures_list ob x;
  Buffer.contents ob
let read__test_caseFeatures_list = (
  Atdgen_runtime.Oj_run.read_list (
    read_test_caseFeatures
  )
)
let _test_caseFeatures_list_of_string s =
  read__test_caseFeatures_list (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__test_caseConflicts_option = (
  Atdgen_runtime.Oj_run.write_option (
    write_test_caseConflicts
  )
)
let string_of__test_caseConflicts_option ?(len = 1024) x =
  let ob = Buffer.create len in
  write__test_caseConflicts_option ob x;
  Buffer.contents ob
let read__test_caseConflicts_option = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "None" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (None : _ option)
            | "Some" ->
              Atdgen_runtime.Oj_run.read_until_field_value p lb;
              let x = (
                  read_test_caseConflicts
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "None" ->
              (None : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | "Some" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_comma p lb;
              Yojson.Safe.read_space p lb;
              let x = (
                  read_test_caseConflicts
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _test_caseConflicts_option_of_string s =
  read__test_caseConflicts_option (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__test_caseBehaviors_list = (
  Atdgen_runtime.Oj_run.write_list (
    write_test_caseBehaviors
  )
)
let string_of__test_caseBehaviors_list ?(len = 1024) x =
  let ob = Buffer.create len in
  write__test_caseBehaviors_list ob x;
  Buffer.contents ob
let read__test_caseBehaviors_list = (
  Atdgen_runtime.Oj_run.read_list (
    read_test_caseBehaviors
  )
)
let _test_caseBehaviors_list_of_string s =
  read__test_caseBehaviors_list (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__string_option = (
  Atdgen_runtime.Oj_run.write_option (
    Yojson.Safe.write_string
  )
)
let string_of__string_option ?(len = 1024) x =
  let ob = Buffer.create len in
  write__string_option ob x;
  Buffer.contents ob
let read__string_option = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "None" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (None : _ option)
            | "Some" ->
              Atdgen_runtime.Oj_run.read_until_field_value p lb;
              let x = (
                  Atdgen_runtime.Oj_run.read_string
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "None" ->
              (None : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | "Some" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_comma p lb;
              Yojson.Safe.read_space p lb;
              let x = (
                  Atdgen_runtime.Oj_run.read_string
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _string_option_of_string s =
  read__string_option (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__int_option = (
  Atdgen_runtime.Oj_run.write_option (
    Yojson.Safe.write_int
  )
)
let string_of__int_option ?(len = 1024) x =
  let ob = Buffer.create len in
  write__int_option ob x;
  Buffer.contents ob
let read__int_option = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "None" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (None : _ option)
            | "Some" ->
              Atdgen_runtime.Oj_run.read_until_field_value p lb;
              let x = (
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "None" ->
              (None : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | "Some" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_comma p lb;
              Yojson.Safe.read_space p lb;
              let x = (
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _int_option_of_string s =
  read__int_option (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_test_case : _ -> test_case -> _ = (
  fun ob (x : test_case) ->
    Buffer.add_char ob '{';
    let is_first = ref true in
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"name\":";
    (
      Yojson.Safe.write_string
    )
      ob x.name;
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"input\":";
    (
      Yojson.Safe.write_string
    )
      ob x.input;
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"validation\":";
    (
      write_test_caseValidation
    )
      ob x.validation;
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"expected\":";
    (
      write_json
    )
      ob x.expected;
    (match x.args with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"args\":";
      (
        write__string_list
      )
        ob x;
    );
    (match x.functions with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"functions\":";
      (
        write__test_caseFunctions_list
      )
        ob x;
    );
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"behaviors\":";
    (
      write__test_caseBehaviors_list
    )
      ob x.behaviors;
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"variants\":";
    (
      write__test_caseVariants_list
    )
      ob x.variants;
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"features\":";
    (
      write__test_caseFeatures_list
    )
      ob x.features;
    (match x.conflicts with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"conflicts\":";
      (
        write_test_caseConflicts
      )
        ob x;
    );
    (match x.requires with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"requires\":";
      (
        write__string_list
      )
        ob x;
    );
    (match x.level with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"level\":";
      (
        Yojson.Safe.write_int
      )
        ob x;
    );
    (match x.source_test with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"source_test\":";
      (
        Yojson.Safe.write_string
      )
        ob x;
    );
    if x.expect_error <> false then (
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"expect_error\":";
      (
        Yojson.Safe.write_bool
      )
        ob x.expect_error;
    );
    (match x.error_type with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"error_type\":";
      (
        Yojson.Safe.write_string
      )
        ob x;
    );
    Buffer.add_char ob '}';
)
let string_of_test_case ?(len = 1024) x =
  let ob = Buffer.create len in
  write_test_case ob x;
  Buffer.contents ob
let read_test_case = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    Yojson.Safe.read_lcurl p lb;
    let field_name = ref (None) in
    let field_input = ref (None) in
    let field_validation = ref (None) in
    let field_expected = ref (None) in
    let field_args = ref (None) in
    let field_functions = ref (None) in
    let field_behaviors = ref (None) in
    let field_variants = ref (None) in
    let field_features = ref (None) in
    let field_conflicts = ref (None) in
    let field_requires = ref (None) in
    let field_level = ref (None) in
    let field_source_test = ref (None) in
    let field_expect_error = ref (false) in
    let field_error_type = ref (None) in
    try
      Yojson.Safe.read_space p lb;
      Yojson.Safe.read_object_end lb;
      Yojson.Safe.read_space p lb;
      let f =
        fun s pos len ->
          if pos < 0 || len < 0 || pos + len > String.length s then
            invalid_arg (Printf.sprintf "out-of-bounds substring position or length: string = %S, requested position = %i, requested length = %i" s pos len);
          match len with
            | 4 -> (
                match String.unsafe_get s pos with
                  | 'a' -> (
                      if String.unsafe_get s (pos+1) = 'r' && String.unsafe_get s (pos+2) = 'g' && String.unsafe_get s (pos+3) = 's' then (
                        4
                      )
                      else (
                        -1
                      )
                    )
                  | 'n' -> (
                      if String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'm' && String.unsafe_get s (pos+3) = 'e' then (
                        0
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | 5 -> (
                match String.unsafe_get s pos with
                  | 'i' -> (
                      if String.unsafe_get s (pos+1) = 'n' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'u' && String.unsafe_get s (pos+4) = 't' then (
                        1
                      )
                      else (
                        -1
                      )
                    )
                  | 'l' -> (
                      if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'v' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'l' then (
                        11
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | 8 -> (
                match String.unsafe_get s pos with
                  | 'e' -> (
                      if String.unsafe_get s (pos+1) = 'x' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 't' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 'd' then (
                        3
                      )
                      else (
                        -1
                      )
                    )
                  | 'f' -> (
                      if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'a' && String.unsafe_get s (pos+3) = 't' && String.unsafe_get s (pos+4) = 'u' && String.unsafe_get s (pos+5) = 'r' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 's' then (
                        8
                      )
                      else (
                        -1
                      )
                    )
                  | 'r' -> (
                      if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'q' && String.unsafe_get s (pos+3) = 'u' && String.unsafe_get s (pos+4) = 'i' && String.unsafe_get s (pos+5) = 'r' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 's' then (
                        10
                      )
                      else (
                        -1
                      )
                    )
                  | 'v' -> (
                      if String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'r' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 'a' && String.unsafe_get s (pos+5) = 'n' && String.unsafe_get s (pos+6) = 't' && String.unsafe_get s (pos+7) = 's' then (
                        7
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | 9 -> (
                match String.unsafe_get s pos with
                  | 'b' -> (
                      if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'h' && String.unsafe_get s (pos+3) = 'a' && String.unsafe_get s (pos+4) = 'v' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'o' && String.unsafe_get s (pos+7) = 'r' && String.unsafe_get s (pos+8) = 's' then (
                        6
                      )
                      else (
                        -1
                      )
                    )
                  | 'c' -> (
                      if String.unsafe_get s (pos+1) = 'o' && String.unsafe_get s (pos+2) = 'n' && String.unsafe_get s (pos+3) = 'f' && String.unsafe_get s (pos+4) = 'l' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'c' && String.unsafe_get s (pos+7) = 't' && String.unsafe_get s (pos+8) = 's' then (
                        9
                      )
                      else (
                        -1
                      )
                    )
                  | 'f' -> (
                      if String.unsafe_get s (pos+1) = 'u' && String.unsafe_get s (pos+2) = 'n' && String.unsafe_get s (pos+3) = 'c' && String.unsafe_get s (pos+4) = 't' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'o' && String.unsafe_get s (pos+7) = 'n' && String.unsafe_get s (pos+8) = 's' then (
                        5
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | 10 -> (
                match String.unsafe_get s pos with
                  | 'e' -> (
                      if String.unsafe_get s (pos+1) = 'r' && String.unsafe_get s (pos+2) = 'r' && String.unsafe_get s (pos+3) = 'o' && String.unsafe_get s (pos+4) = 'r' && String.unsafe_get s (pos+5) = '_' && String.unsafe_get s (pos+6) = 't' && String.unsafe_get s (pos+7) = 'y' && String.unsafe_get s (pos+8) = 'p' && String.unsafe_get s (pos+9) = 'e' then (
                        14
                      )
                      else (
                        -1
                      )
                    )
                  | 'v' -> (
                      if String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'l' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 'd' && String.unsafe_get s (pos+5) = 'a' && String.unsafe_get s (pos+6) = 't' && String.unsafe_get s (pos+7) = 'i' && String.unsafe_get s (pos+8) = 'o' && String.unsafe_get s (pos+9) = 'n' then (
                        2
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | 11 -> (
                if String.unsafe_get s pos = 's' && String.unsafe_get s (pos+1) = 'o' && String.unsafe_get s (pos+2) = 'u' && String.unsafe_get s (pos+3) = 'r' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 'e' && String.unsafe_get s (pos+6) = '_' && String.unsafe_get s (pos+7) = 't' && String.unsafe_get s (pos+8) = 'e' && String.unsafe_get s (pos+9) = 's' && String.unsafe_get s (pos+10) = 't' then (
                  12
                )
                else (
                  -1
                )
              )
            | 12 -> (
                if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'x' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 't' && String.unsafe_get s (pos+6) = '_' && String.unsafe_get s (pos+7) = 'e' && String.unsafe_get s (pos+8) = 'r' && String.unsafe_get s (pos+9) = 'r' && String.unsafe_get s (pos+10) = 'o' && String.unsafe_get s (pos+11) = 'r' then (
                  13
                )
                else (
                  -1
                )
              )
            | _ -> (
                -1
              )
      in
      let i = Yojson.Safe.map_ident p f lb in
      Atdgen_runtime.Oj_run.read_until_field_value p lb;
      (
        match i with
          | 0 ->
            field_name := (
              Some (
                (
                  Atdgen_runtime.Oj_run.read_string
                ) p lb
              )
            );
          | 1 ->
            field_input := (
              Some (
                (
                  Atdgen_runtime.Oj_run.read_string
                ) p lb
              )
            );
          | 2 ->
            field_validation := (
              Some (
                (
                  read_test_caseValidation
                ) p lb
              )
            );
          | 3 ->
            field_expected := (
              Some (
                (
                  read_json
                ) p lb
              )
            );
          | 4 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_args := (
                Some (
                  (
                    read__string_list
                  ) p lb
                )
              );
            )
          | 5 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_functions := (
                Some (
                  (
                    read__test_caseFunctions_list
                  ) p lb
                )
              );
            )
          | 6 ->
            field_behaviors := (
              Some (
                (
                  read__test_caseBehaviors_list
                ) p lb
              )
            );
          | 7 ->
            field_variants := (
              Some (
                (
                  read__test_caseVariants_list
                ) p lb
              )
            );
          | 8 ->
            field_features := (
              Some (
                (
                  read__test_caseFeatures_list
                ) p lb
              )
            );
          | 9 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_conflicts := (
                Some (
                  (
                    read_test_caseConflicts
                  ) p lb
                )
              );
            )
          | 10 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_requires := (
                Some (
                  (
                    read__string_list
                  ) p lb
                )
              );
            )
          | 11 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_level := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_int
                  ) p lb
                )
              );
            )
          | 12 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_source_test := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_string
                  ) p lb
                )
              );
            )
          | 13 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_expect_error := (
                (
                  Atdgen_runtime.Oj_run.read_bool
                ) p lb
              );
            )
          | 14 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_error_type := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_string
                  ) p lb
                )
              );
            )
          | _ -> (
              Yojson.Safe.skip_json p lb
            )
      );
      while true do
        Yojson.Safe.read_space p lb;
        Yojson.Safe.read_object_sep p lb;
        Yojson.Safe.read_space p lb;
        let f =
          fun s pos len ->
            if pos < 0 || len < 0 || pos + len > String.length s then
              invalid_arg (Printf.sprintf "out-of-bounds substring position or length: string = %S, requested position = %i, requested length = %i" s pos len);
            match len with
              | 4 -> (
                  match String.unsafe_get s pos with
                    | 'a' -> (
                        if String.unsafe_get s (pos+1) = 'r' && String.unsafe_get s (pos+2) = 'g' && String.unsafe_get s (pos+3) = 's' then (
                          4
                        )
                        else (
                          -1
                        )
                      )
                    | 'n' -> (
                        if String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'm' && String.unsafe_get s (pos+3) = 'e' then (
                          0
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | 5 -> (
                  match String.unsafe_get s pos with
                    | 'i' -> (
                        if String.unsafe_get s (pos+1) = 'n' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'u' && String.unsafe_get s (pos+4) = 't' then (
                          1
                        )
                        else (
                          -1
                        )
                      )
                    | 'l' -> (
                        if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'v' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'l' then (
                          11
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | 8 -> (
                  match String.unsafe_get s pos with
                    | 'e' -> (
                        if String.unsafe_get s (pos+1) = 'x' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 't' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 'd' then (
                          3
                        )
                        else (
                          -1
                        )
                      )
                    | 'f' -> (
                        if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'a' && String.unsafe_get s (pos+3) = 't' && String.unsafe_get s (pos+4) = 'u' && String.unsafe_get s (pos+5) = 'r' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 's' then (
                          8
                        )
                        else (
                          -1
                        )
                      )
                    | 'r' -> (
                        if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'q' && String.unsafe_get s (pos+3) = 'u' && String.unsafe_get s (pos+4) = 'i' && String.unsafe_get s (pos+5) = 'r' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 's' then (
                          10
                        )
                        else (
                          -1
                        )
                      )
                    | 'v' -> (
                        if String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'r' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 'a' && String.unsafe_get s (pos+5) = 'n' && String.unsafe_get s (pos+6) = 't' && String.unsafe_get s (pos+7) = 's' then (
                          7
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | 9 -> (
                  match String.unsafe_get s pos with
                    | 'b' -> (
                        if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'h' && String.unsafe_get s (pos+3) = 'a' && String.unsafe_get s (pos+4) = 'v' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'o' && String.unsafe_get s (pos+7) = 'r' && String.unsafe_get s (pos+8) = 's' then (
                          6
                        )
                        else (
                          -1
                        )
                      )
                    | 'c' -> (
                        if String.unsafe_get s (pos+1) = 'o' && String.unsafe_get s (pos+2) = 'n' && String.unsafe_get s (pos+3) = 'f' && String.unsafe_get s (pos+4) = 'l' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'c' && String.unsafe_get s (pos+7) = 't' && String.unsafe_get s (pos+8) = 's' then (
                          9
                        )
                        else (
                          -1
                        )
                      )
                    | 'f' -> (
                        if String.unsafe_get s (pos+1) = 'u' && String.unsafe_get s (pos+2) = 'n' && String.unsafe_get s (pos+3) = 'c' && String.unsafe_get s (pos+4) = 't' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'o' && String.unsafe_get s (pos+7) = 'n' && String.unsafe_get s (pos+8) = 's' then (
                          5
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | 10 -> (
                  match String.unsafe_get s pos with
                    | 'e' -> (
                        if String.unsafe_get s (pos+1) = 'r' && String.unsafe_get s (pos+2) = 'r' && String.unsafe_get s (pos+3) = 'o' && String.unsafe_get s (pos+4) = 'r' && String.unsafe_get s (pos+5) = '_' && String.unsafe_get s (pos+6) = 't' && String.unsafe_get s (pos+7) = 'y' && String.unsafe_get s (pos+8) = 'p' && String.unsafe_get s (pos+9) = 'e' then (
                          14
                        )
                        else (
                          -1
                        )
                      )
                    | 'v' -> (
                        if String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'l' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 'd' && String.unsafe_get s (pos+5) = 'a' && String.unsafe_get s (pos+6) = 't' && String.unsafe_get s (pos+7) = 'i' && String.unsafe_get s (pos+8) = 'o' && String.unsafe_get s (pos+9) = 'n' then (
                          2
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | 11 -> (
                  if String.unsafe_get s pos = 's' && String.unsafe_get s (pos+1) = 'o' && String.unsafe_get s (pos+2) = 'u' && String.unsafe_get s (pos+3) = 'r' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 'e' && String.unsafe_get s (pos+6) = '_' && String.unsafe_get s (pos+7) = 't' && String.unsafe_get s (pos+8) = 'e' && String.unsafe_get s (pos+9) = 's' && String.unsafe_get s (pos+10) = 't' then (
                    12
                  )
                  else (
                    -1
                  )
                )
              | 12 -> (
                  if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'x' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 't' && String.unsafe_get s (pos+6) = '_' && String.unsafe_get s (pos+7) = 'e' && String.unsafe_get s (pos+8) = 'r' && String.unsafe_get s (pos+9) = 'r' && String.unsafe_get s (pos+10) = 'o' && String.unsafe_get s (pos+11) = 'r' then (
                    13
                  )
                  else (
                    -1
                  )
                )
              | _ -> (
                  -1
                )
        in
        let i = Yojson.Safe.map_ident p f lb in
        Atdgen_runtime.Oj_run.read_until_field_value p lb;
        (
          match i with
            | 0 ->
              field_name := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_string
                  ) p lb
                )
              );
            | 1 ->
              field_input := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_string
                  ) p lb
                )
              );
            | 2 ->
              field_validation := (
                Some (
                  (
                    read_test_caseValidation
                  ) p lb
                )
              );
            | 3 ->
              field_expected := (
                Some (
                  (
                    read_json
                  ) p lb
                )
              );
            | 4 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_args := (
                  Some (
                    (
                      read__string_list
                    ) p lb
                  )
                );
              )
            | 5 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_functions := (
                  Some (
                    (
                      read__test_caseFunctions_list
                    ) p lb
                  )
                );
              )
            | 6 ->
              field_behaviors := (
                Some (
                  (
                    read__test_caseBehaviors_list
                  ) p lb
                )
              );
            | 7 ->
              field_variants := (
                Some (
                  (
                    read__test_caseVariants_list
                  ) p lb
                )
              );
            | 8 ->
              field_features := (
                Some (
                  (
                    read__test_caseFeatures_list
                  ) p lb
                )
              );
            | 9 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_conflicts := (
                  Some (
                    (
                      read_test_caseConflicts
                    ) p lb
                  )
                );
              )
            | 10 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_requires := (
                  Some (
                    (
                      read__string_list
                    ) p lb
                  )
                );
              )
            | 11 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_level := (
                  Some (
                    (
                      Atdgen_runtime.Oj_run.read_int
                    ) p lb
                  )
                );
              )
            | 12 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_source_test := (
                  Some (
                    (
                      Atdgen_runtime.Oj_run.read_string
                    ) p lb
                  )
                );
              )
            | 13 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_expect_error := (
                  (
                    Atdgen_runtime.Oj_run.read_bool
                  ) p lb
                );
              )
            | 14 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_error_type := (
                  Some (
                    (
                      Atdgen_runtime.Oj_run.read_string
                    ) p lb
                  )
                );
              )
            | _ -> (
                Yojson.Safe.skip_json p lb
              )
        );
      done;
      assert false;
    with Yojson.End_of_object -> (
        (
          {
            name = (match !field_name with Some x -> x | None -> Atdgen_runtime.Oj_run.missing_field p "name");
            input = (match !field_input with Some x -> x | None -> Atdgen_runtime.Oj_run.missing_field p "input");
            validation = (match !field_validation with Some x -> x | None -> Atdgen_runtime.Oj_run.missing_field p "validation");
            expected = (match !field_expected with Some x -> x | None -> Atdgen_runtime.Oj_run.missing_field p "expected");
            args = !field_args;
            functions = !field_functions;
            behaviors = (match !field_behaviors with Some x -> x | None -> Atdgen_runtime.Oj_run.missing_field p "behaviors");
            variants = (match !field_variants with Some x -> x | None -> Atdgen_runtime.Oj_run.missing_field p "variants");
            features = (match !field_features with Some x -> x | None -> Atdgen_runtime.Oj_run.missing_field p "features");
            conflicts = !field_conflicts;
            requires = !field_requires;
            level = !field_level;
            source_test = !field_source_test;
            expect_error = !field_expect_error;
            error_type = !field_error_type;
          }
         : test_case)
      )
)
let test_case_of_string s =
  read_test_case (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__test_case_list = (
  Atdgen_runtime.Oj_run.write_list (
    write_test_case
  )
)
let string_of__test_case_list ?(len = 1024) x =
  let ob = Buffer.create len in
  write__test_case_list ob x;
  Buffer.contents ob
let read__test_case_list = (
  Atdgen_runtime.Oj_run.read_list (
    read_test_case
  )
)
let _test_case_list_of_string s =
  read__test_case_list (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_test_suite : _ -> test_suite -> _ = (
  fun ob (x : test_suite) ->
    Buffer.add_char ob '{';
    let is_first = ref true in
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"$schema\":";
    (
      Yojson.Safe.write_string
    )
      ob x.schema;
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"tests\":";
    (
      write__test_case_list
    )
      ob x.tests;
    Buffer.add_char ob '}';
)
let string_of_test_suite ?(len = 1024) x =
  let ob = Buffer.create len in
  write_test_suite ob x;
  Buffer.contents ob
let read_test_suite = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    Yojson.Safe.read_lcurl p lb;
    let field_schema = ref (None) in
    let field_tests = ref (None) in
    try
      Yojson.Safe.read_space p lb;
      Yojson.Safe.read_object_end lb;
      Yojson.Safe.read_space p lb;
      let f =
        fun s pos len ->
          if pos < 0 || len < 0 || pos + len > String.length s then
            invalid_arg (Printf.sprintf "out-of-bounds substring position or length: string = %S, requested position = %i, requested length = %i" s pos len);
          match len with
            | 5 -> (
                if String.unsafe_get s pos = 't' && String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 's' && String.unsafe_get s (pos+3) = 't' && String.unsafe_get s (pos+4) = 's' then (
                  1
                )
                else (
                  -1
                )
              )
            | 7 -> (
                if String.unsafe_get s pos = '$' && String.unsafe_get s (pos+1) = 's' && String.unsafe_get s (pos+2) = 'c' && String.unsafe_get s (pos+3) = 'h' && String.unsafe_get s (pos+4) = 'e' && String.unsafe_get s (pos+5) = 'm' && String.unsafe_get s (pos+6) = 'a' then (
                  0
                )
                else (
                  -1
                )
              )
            | _ -> (
                -1
              )
      in
      let i = Yojson.Safe.map_ident p f lb in
      Atdgen_runtime.Oj_run.read_until_field_value p lb;
      (
        match i with
          | 0 ->
            field_schema := (
              Some (
                (
                  Atdgen_runtime.Oj_run.read_string
                ) p lb
              )
            );
          | 1 ->
            field_tests := (
              Some (
                (
                  read__test_case_list
                ) p lb
              )
            );
          | _ -> (
              Yojson.Safe.skip_json p lb
            )
      );
      while true do
        Yojson.Safe.read_space p lb;
        Yojson.Safe.read_object_sep p lb;
        Yojson.Safe.read_space p lb;
        let f =
          fun s pos len ->
            if pos < 0 || len < 0 || pos + len > String.length s then
              invalid_arg (Printf.sprintf "out-of-bounds substring position or length: string = %S, requested position = %i, requested length = %i" s pos len);
            match len with
              | 5 -> (
                  if String.unsafe_get s pos = 't' && String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 's' && String.unsafe_get s (pos+3) = 't' && String.unsafe_get s (pos+4) = 's' then (
                    1
                  )
                  else (
                    -1
                  )
                )
              | 7 -> (
                  if String.unsafe_get s pos = '$' && String.unsafe_get s (pos+1) = 's' && String.unsafe_get s (pos+2) = 'c' && String.unsafe_get s (pos+3) = 'h' && String.unsafe_get s (pos+4) = 'e' && String.unsafe_get s (pos+5) = 'm' && String.unsafe_get s (pos+6) = 'a' then (
                    0
                  )
                  else (
                    -1
                  )
                )
              | _ -> (
                  -1
                )
        in
        let i = Yojson.Safe.map_ident p f lb in
        Atdgen_runtime.Oj_run.read_until_field_value p lb;
        (
          match i with
            | 0 ->
              field_schema := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_string
                  ) p lb
                )
              );
            | 1 ->
              field_tests := (
                Some (
                  (
                    read__test_case_list
                  ) p lb
                )
              );
            | _ -> (
                Yojson.Safe.skip_json p lb
              )
        );
      done;
      assert false;
    with Yojson.End_of_object -> (
        (
          {
            schema = (match !field_schema with Some x -> x | None -> Atdgen_runtime.Oj_run.missing_field p "schema");
            tests = (match !field_tests with Some x -> x | None -> Atdgen_runtime.Oj_run.missing_field p "tests");
          }
         : test_suite)
      )
)
let test_suite_of_string s =
  read_test_suite (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_root = (
  write__test_case_list
)
let string_of_root ?(len = 1024) x =
  let ob = Buffer.create len in
  write_root ob x;
  Buffer.contents ob
let read_root = (
  read__test_case_list
)
let root_of_string s =
  read_root (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_int64 = (
  Atdgen_runtime.Oj_run.write_int64
)
let string_of_int64 ?(len = 1024) x =
  let ob = Buffer.create len in
  write_int64 ob x;
  Buffer.contents ob
let read_int64 = (
  Atdgen_runtime.Oj_run.read_int64
)
let int64_of_string s =
  read_int64 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
