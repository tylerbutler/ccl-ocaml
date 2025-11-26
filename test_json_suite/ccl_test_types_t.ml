(* Auto-generated from "ccl_test_types.atd" *)
[@@@ocaml.warning "-27-32-33-35-39"]

type json = Yojson.Basic.t

type cCLTestFlatFormatTestsVariants = [
    `Proposed_behavior | `Reference_compliant
]

(** Single CCL function to validate *)
type cCLTestFlatFormatTestsValidation = [
    `Parse | `Parse_value | `Filter | `Compose | `Build_hierarchy
  | `Get_string | `Get_int | `Get_bool | `Get_float | `Get_list
  | `Canonical_format | `Load | `Round_trip | `Merge
]

type cCLTestFlatFormatTestsFunctions = [
    `Parse | `Parse_value | `Filter | `Compose | `Build_hierarchy
  | `Get_string | `Get_int | `Get_bool | `Get_float | `Get_list
  | `Canonical_format | `Load | `Round_trip | `Merge
]

(** Mutually exclusive options by category *)
type cCLTestFlatFormatTestsConflicts = {
  functions: string list option;
  behaviors: string list option;
  variants: string list option;
  features: string list option
}

type cCLTestFlatFormatTestsBehaviors = [
    `Boolean_strict | `Boolean_lenient | `Crlf_preserve_literal
  | `Crlf_normalize_to_lf | `Tabs_preserve | `Tabs_to_spaces
  | `Strict_spacing | `Loose_spacing | `List_coercion_enabled
  | `List_coercion_disabled | `Array_order_insertion | `Array_order_lexicographic
]

type cCLTestFlatFormatTests = {
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

type root = cCLTestFlatFormatTests list

type int64 = Int64.t

(** Schema for existing generated flat test files *)
type cCLTestFlatFormat = {
  schema: string (** JSON Schema reference *);
  tests: cCLTestFlatFormatTests list
}
