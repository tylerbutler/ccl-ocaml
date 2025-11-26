(* Auto-generated from "ccl_test_types.atd" *)
[@@@ocaml.warning "-27-32-33-35-39"]

type json = Yojson.Basic.t

type cCLTestFlatFormatTestsVariants =
  Ccl_test_types_t.cCLTestFlatFormatTestsVariants

(** Single CCL function to validate *)
type cCLTestFlatFormatTestsValidation =
  Ccl_test_types_t.cCLTestFlatFormatTestsValidation

type cCLTestFlatFormatTestsFunctions =
  Ccl_test_types_t.cCLTestFlatFormatTestsFunctions

(** Mutually exclusive options by category *)
type cCLTestFlatFormatTestsConflicts =
  Ccl_test_types_t.cCLTestFlatFormatTestsConflicts = {
  functions: string list option;
  behaviors: string list option;
  variants: string list option;
  features: string list option
}

type cCLTestFlatFormatTestsBehaviors =
  Ccl_test_types_t.cCLTestFlatFormatTestsBehaviors

type cCLTestFlatFormatTests = Ccl_test_types_t.cCLTestFlatFormatTests = {
  name: string (** Unique test name (source_name + validation function) *);
  input: string (** CCL input text to be tested *);
  validation: cCLTestFlatFormatTestsValidation
    (** Single CCL function to validate *);
  expected: json (** Expected test results with flexible structure *);
  args: string list option
    (**
      Arguments for typed access functions (get_string, get_int, get_bool,
      get_float, get_list). Required for these functions, omitted for others.
    *);
  functions: cCLTestFlatFormatTestsFunctions list option
    (** CCL functions tested by this test *);
  behaviors: cCLTestFlatFormatTestsBehaviors list
    (** Implementation behavior choices *);
  variants: cCLTestFlatFormatTestsVariants list (** Specification variants *);
  features: string list (** Required language features *);
  conflicts: cCLTestFlatFormatTestsConflicts option
    (** Mutually exclusive options by category *);
  requires: string list option
    (** Functions that must be implemented as prerequisites *);
  source_test: string option
    (** Original source test name for traceability *);
  expect_error: bool (** Whether this test should produce an error *);
  error_type: string option (** Expected error type for error tests *)
}

type root = Ccl_test_types_t.root

type int64 = Ccl_test_types_t.int64

(** Schema for existing generated flat test files *)
type cCLTestFlatFormat = Ccl_test_types_t.cCLTestFlatFormat = {
  schema: string (** JSON Schema reference *);
  tests: cCLTestFlatFormatTests list
}

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
let write_cCLTestFlatFormatTestsVariants = (
  fun ob x ->
    match x with
      | `Proposed_behavior -> Buffer.add_string ob "<\"proposed_behavior\">"
      | `Reference_compliant -> Buffer.add_string ob "<\"reference_compliant\">"
)
let string_of_cCLTestFlatFormatTestsVariants ?(len = 1024) x =
  let ob = Buffer.create len in
  write_cCLTestFlatFormatTestsVariants ob x;
  Buffer.contents ob
let read_cCLTestFlatFormatTestsVariants = (
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
let cCLTestFlatFormatTestsVariants_of_string s =
  read_cCLTestFlatFormatTestsVariants (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_cCLTestFlatFormatTestsValidation = (
  fun ob x ->
    match x with
      | `Parse -> Buffer.add_string ob "<\"parse\">"
      | `Parse_value -> Buffer.add_string ob "<\"parse_value\">"
      | `Filter -> Buffer.add_string ob "<\"filter\">"
      | `Compose -> Buffer.add_string ob "<\"compose\">"
      | `Build_hierarchy -> Buffer.add_string ob "<\"build_hierarchy\">"
      | `Get_string -> Buffer.add_string ob "<\"get_string\">"
      | `Get_int -> Buffer.add_string ob "<\"get_int\">"
      | `Get_bool -> Buffer.add_string ob "<\"get_bool\">"
      | `Get_float -> Buffer.add_string ob "<\"get_float\">"
      | `Get_list -> Buffer.add_string ob "<\"get_list\">"
      | `Canonical_format -> Buffer.add_string ob "<\"canonical_format\">"
      | `Load -> Buffer.add_string ob "<\"load\">"
      | `Round_trip -> Buffer.add_string ob "<\"round_trip\">"
      | `Merge -> Buffer.add_string ob "<\"merge\">"
)
let string_of_cCLTestFlatFormatTestsValidation ?(len = 1024) x =
  let ob = Buffer.create len in
  write_cCLTestFlatFormatTestsValidation ob x;
  Buffer.contents ob
let read_cCLTestFlatFormatTestsValidation = (
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
            | "parse_indented" ->
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
            | "merge" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Merge
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "parse" ->
              `Parse
            | "parse_value" ->
              `Parse_value
            | "parse_indented" ->
              `Parse_value
            | "filter" ->
              `Filter
            | "compose" ->
              `Compose
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
            | "merge" ->
              `Merge
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let cCLTestFlatFormatTestsValidation_of_string s =
  read_cCLTestFlatFormatTestsValidation (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_cCLTestFlatFormatTestsFunctions = (
  fun ob x ->
    match x with
      | `Parse -> Buffer.add_string ob "<\"parse\">"
      | `Parse_value -> Buffer.add_string ob "<\"parse_value\">"
      | `Filter -> Buffer.add_string ob "<\"filter\">"
      | `Compose -> Buffer.add_string ob "<\"compose\">"
      | `Build_hierarchy -> Buffer.add_string ob "<\"build_hierarchy\">"
      | `Get_string -> Buffer.add_string ob "<\"get_string\">"
      | `Get_int -> Buffer.add_string ob "<\"get_int\">"
      | `Get_bool -> Buffer.add_string ob "<\"get_bool\">"
      | `Get_float -> Buffer.add_string ob "<\"get_float\">"
      | `Get_list -> Buffer.add_string ob "<\"get_list\">"
      | `Canonical_format -> Buffer.add_string ob "<\"canonical_format\">"
      | `Load -> Buffer.add_string ob "<\"load\">"
      | `Round_trip -> Buffer.add_string ob "<\"round_trip\">"
      | `Merge -> Buffer.add_string ob "<\"merge\">"
)
let string_of_cCLTestFlatFormatTestsFunctions ?(len = 1024) x =
  let ob = Buffer.create len in
  write_cCLTestFlatFormatTestsFunctions ob x;
  Buffer.contents ob
let read_cCLTestFlatFormatTestsFunctions = (
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
            | "parse_indented" ->
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
            | "merge" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Merge
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "parse" ->
              `Parse
            | "parse_value" ->
              `Parse_value
            | "parse_indented" ->
              `Parse_value
            | "filter" ->
              `Filter
            | "compose" ->
              `Compose
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
            | "merge" ->
              `Merge
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let cCLTestFlatFormatTestsFunctions_of_string s =
  read_cCLTestFlatFormatTestsFunctions (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
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
let write_cCLTestFlatFormatTestsConflicts : _ -> cCLTestFlatFormatTestsConflicts -> _ = (
  fun ob (x : cCLTestFlatFormatTestsConflicts) ->
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
let string_of_cCLTestFlatFormatTestsConflicts ?(len = 1024) x =
  let ob = Buffer.create len in
  write_cCLTestFlatFormatTestsConflicts ob x;
  Buffer.contents ob
let read_cCLTestFlatFormatTestsConflicts = (
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
         : cCLTestFlatFormatTestsConflicts)
      )
)
let cCLTestFlatFormatTestsConflicts_of_string s =
  read_cCLTestFlatFormatTestsConflicts (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_cCLTestFlatFormatTestsBehaviors = (
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
let string_of_cCLTestFlatFormatTestsBehaviors ?(len = 1024) x =
  let ob = Buffer.create len in
  write_cCLTestFlatFormatTestsBehaviors ob x;
  Buffer.contents ob
let read_cCLTestFlatFormatTestsBehaviors = (
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
let cCLTestFlatFormatTestsBehaviors_of_string s =
  read_cCLTestFlatFormatTestsBehaviors (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
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
let write__cCLTestFlatFormatTestsVariants_list = (
  Atdgen_runtime.Oj_run.write_list (
    write_cCLTestFlatFormatTestsVariants
  )
)
let string_of__cCLTestFlatFormatTestsVariants_list ?(len = 1024) x =
  let ob = Buffer.create len in
  write__cCLTestFlatFormatTestsVariants_list ob x;
  Buffer.contents ob
let read__cCLTestFlatFormatTestsVariants_list = (
  Atdgen_runtime.Oj_run.read_list (
    read_cCLTestFlatFormatTestsVariants
  )
)
let _cCLTestFlatFormatTestsVariants_list_of_string s =
  read__cCLTestFlatFormatTestsVariants_list (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__cCLTestFlatFormatTestsFunctions_list = (
  Atdgen_runtime.Oj_run.write_list (
    write_cCLTestFlatFormatTestsFunctions
  )
)
let string_of__cCLTestFlatFormatTestsFunctions_list ?(len = 1024) x =
  let ob = Buffer.create len in
  write__cCLTestFlatFormatTestsFunctions_list ob x;
  Buffer.contents ob
let read__cCLTestFlatFormatTestsFunctions_list = (
  Atdgen_runtime.Oj_run.read_list (
    read_cCLTestFlatFormatTestsFunctions
  )
)
let _cCLTestFlatFormatTestsFunctions_list_of_string s =
  read__cCLTestFlatFormatTestsFunctions_list (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__cCLTestFlatFormatTestsFunctions_list_option = (
  Atdgen_runtime.Oj_run.write_option (
    write__cCLTestFlatFormatTestsFunctions_list
  )
)
let string_of__cCLTestFlatFormatTestsFunctions_list_option ?(len = 1024) x =
  let ob = Buffer.create len in
  write__cCLTestFlatFormatTestsFunctions_list_option ob x;
  Buffer.contents ob
let read__cCLTestFlatFormatTestsFunctions_list_option = (
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
                  read__cCLTestFlatFormatTestsFunctions_list
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
                  read__cCLTestFlatFormatTestsFunctions_list
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _cCLTestFlatFormatTestsFunctions_list_option_of_string s =
  read__cCLTestFlatFormatTestsFunctions_list_option (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__cCLTestFlatFormatTestsConflicts_option = (
  Atdgen_runtime.Oj_run.write_option (
    write_cCLTestFlatFormatTestsConflicts
  )
)
let string_of__cCLTestFlatFormatTestsConflicts_option ?(len = 1024) x =
  let ob = Buffer.create len in
  write__cCLTestFlatFormatTestsConflicts_option ob x;
  Buffer.contents ob
let read__cCLTestFlatFormatTestsConflicts_option = (
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
                  read_cCLTestFlatFormatTestsConflicts
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
                  read_cCLTestFlatFormatTestsConflicts
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _cCLTestFlatFormatTestsConflicts_option_of_string s =
  read__cCLTestFlatFormatTestsConflicts_option (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__cCLTestFlatFormatTestsBehaviors_list = (
  Atdgen_runtime.Oj_run.write_list (
    write_cCLTestFlatFormatTestsBehaviors
  )
)
let string_of__cCLTestFlatFormatTestsBehaviors_list ?(len = 1024) x =
  let ob = Buffer.create len in
  write__cCLTestFlatFormatTestsBehaviors_list ob x;
  Buffer.contents ob
let read__cCLTestFlatFormatTestsBehaviors_list = (
  Atdgen_runtime.Oj_run.read_list (
    read_cCLTestFlatFormatTestsBehaviors
  )
)
let _cCLTestFlatFormatTestsBehaviors_list_of_string s =
  read__cCLTestFlatFormatTestsBehaviors_list (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_cCLTestFlatFormatTests : _ -> cCLTestFlatFormatTests -> _ = (
  fun ob (x : cCLTestFlatFormatTests) ->
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
      write_cCLTestFlatFormatTestsValidation
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
        write__cCLTestFlatFormatTestsFunctions_list
      )
        ob x;
    );
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"behaviors\":";
    (
      write__cCLTestFlatFormatTestsBehaviors_list
    )
      ob x.behaviors;
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"variants\":";
    (
      write__cCLTestFlatFormatTestsVariants_list
    )
      ob x.variants;
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"features\":";
    (
      write__string_list
    )
      ob x.features;
    (match x.conflicts with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"conflicts\":";
      (
        write_cCLTestFlatFormatTestsConflicts
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
let string_of_cCLTestFlatFormatTests ?(len = 1024) x =
  let ob = Buffer.create len in
  write_cCLTestFlatFormatTests ob x;
  Buffer.contents ob
let read_cCLTestFlatFormatTests = (
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
                if String.unsafe_get s pos = 'i' && String.unsafe_get s (pos+1) = 'n' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'u' && String.unsafe_get s (pos+4) = 't' then (
                  1
                )
                else (
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
                        13
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
                  11
                )
                else (
                  -1
                )
              )
            | 12 -> (
                if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'x' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 't' && String.unsafe_get s (pos+6) = '_' && String.unsafe_get s (pos+7) = 'e' && String.unsafe_get s (pos+8) = 'r' && String.unsafe_get s (pos+9) = 'r' && String.unsafe_get s (pos+10) = 'o' && String.unsafe_get s (pos+11) = 'r' then (
                  12
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
                  read_cCLTestFlatFormatTestsValidation
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
                    read__cCLTestFlatFormatTestsFunctions_list
                  ) p lb
                )
              );
            )
          | 6 ->
            field_behaviors := (
              Some (
                (
                  read__cCLTestFlatFormatTestsBehaviors_list
                ) p lb
              )
            );
          | 7 ->
            field_variants := (
              Some (
                (
                  read__cCLTestFlatFormatTestsVariants_list
                ) p lb
              )
            );
          | 8 ->
            field_features := (
              Some (
                (
                  read__string_list
                ) p lb
              )
            );
          | 9 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_conflicts := (
                Some (
                  (
                    read_cCLTestFlatFormatTestsConflicts
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
              field_source_test := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_string
                  ) p lb
                )
              );
            )
          | 12 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_expect_error := (
                (
                  Atdgen_runtime.Oj_run.read_bool
                ) p lb
              );
            )
          | 13 ->
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
                  if String.unsafe_get s pos = 'i' && String.unsafe_get s (pos+1) = 'n' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'u' && String.unsafe_get s (pos+4) = 't' then (
                    1
                  )
                  else (
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
                          13
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
                    11
                  )
                  else (
                    -1
                  )
                )
              | 12 -> (
                  if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'x' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 't' && String.unsafe_get s (pos+6) = '_' && String.unsafe_get s (pos+7) = 'e' && String.unsafe_get s (pos+8) = 'r' && String.unsafe_get s (pos+9) = 'r' && String.unsafe_get s (pos+10) = 'o' && String.unsafe_get s (pos+11) = 'r' then (
                    12
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
                    read_cCLTestFlatFormatTestsValidation
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
                      read__cCLTestFlatFormatTestsFunctions_list
                    ) p lb
                  )
                );
              )
            | 6 ->
              field_behaviors := (
                Some (
                  (
                    read__cCLTestFlatFormatTestsBehaviors_list
                  ) p lb
                )
              );
            | 7 ->
              field_variants := (
                Some (
                  (
                    read__cCLTestFlatFormatTestsVariants_list
                  ) p lb
                )
              );
            | 8 ->
              field_features := (
                Some (
                  (
                    read__string_list
                  ) p lb
                )
              );
            | 9 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_conflicts := (
                  Some (
                    (
                      read_cCLTestFlatFormatTestsConflicts
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
                field_source_test := (
                  Some (
                    (
                      Atdgen_runtime.Oj_run.read_string
                    ) p lb
                  )
                );
              )
            | 12 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_expect_error := (
                  (
                    Atdgen_runtime.Oj_run.read_bool
                  ) p lb
                );
              )
            | 13 ->
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
            source_test = !field_source_test;
            expect_error = !field_expect_error;
            error_type = !field_error_type;
          }
         : cCLTestFlatFormatTests)
      )
)
let cCLTestFlatFormatTests_of_string s =
  read_cCLTestFlatFormatTests (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__cCLTestFlatFormatTests_list = (
  Atdgen_runtime.Oj_run.write_list (
    write_cCLTestFlatFormatTests
  )
)
let string_of__cCLTestFlatFormatTests_list ?(len = 1024) x =
  let ob = Buffer.create len in
  write__cCLTestFlatFormatTests_list ob x;
  Buffer.contents ob
let read__cCLTestFlatFormatTests_list = (
  Atdgen_runtime.Oj_run.read_list (
    read_cCLTestFlatFormatTests
  )
)
let _cCLTestFlatFormatTests_list_of_string s =
  read__cCLTestFlatFormatTests_list (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_root = (
  write__cCLTestFlatFormatTests_list
)
let string_of_root ?(len = 1024) x =
  let ob = Buffer.create len in
  write_root ob x;
  Buffer.contents ob
let read_root = (
  read__cCLTestFlatFormatTests_list
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
let write_cCLTestFlatFormat : _ -> cCLTestFlatFormat -> _ = (
  fun ob (x : cCLTestFlatFormat) ->
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
      write__cCLTestFlatFormatTests_list
    )
      ob x.tests;
    Buffer.add_char ob '}';
)
let string_of_cCLTestFlatFormat ?(len = 1024) x =
  let ob = Buffer.create len in
  write_cCLTestFlatFormat ob x;
  Buffer.contents ob
let read_cCLTestFlatFormat = (
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
                  read__cCLTestFlatFormatTests_list
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
                    read__cCLTestFlatFormatTests_list
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
         : cCLTestFlatFormat)
      )
)
let cCLTestFlatFormat_of_string s =
  read_cCLTestFlatFormat (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
