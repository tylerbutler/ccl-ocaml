(* Auto-generated from "ccl_test_types.atd" *)
[@@@ocaml.warning "-27-32-33-35-39"]

type test_caseVariants = [ `Proposed_behavior | `Reference_compliant ]

(** Single CCL function to validate *)
type test_caseValidation = [
    `Parse | `Parse_value | `Filter | `Compose | `Expand_dotted
  | `Build_hierarchy | `Get_string | `Get_int | `Get_bool | `Get_float
  | `Get_list | `Canonical_format | `Load | `Round_trip | `Associativity
]

type test_caseFunctions = [
    `Parse | `Parse_value | `Filter | `Compose | `Expand_dotted
  | `Build_hierarchy | `Get_string | `Get_int | `Get_bool | `Get_float
  | `Get_list | `Canonical_format | `Load | `Round_trip | `Associativity
]

type test_caseFeatures = [
    `Comments | `Empty_keys | `Experimental_dotted_keys | `Multiline
  | `Unicode | `Whitespace
]

(** Mutually exclusive options by category *)
type test_caseConflicts = {
  functions: string list option;
  behaviors: string list option;
  variants: string list option;
  features: string list option
}

type test_caseBehaviors = [
    `Boolean_strict | `Boolean_lenient | `Crlf_preserve_literal
  | `Crlf_normalize_to_lf | `Tabs_preserve | `Tabs_to_spaces
  | `Strict_spacing | `Loose_spacing | `List_coercion_enabled
  | `List_coercion_disabled
]

type json = Yojson.Basic.t

type test_case = {
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
type test_suite = {
  schema: string (** JSON Schema reference *);
  tests: test_case list
}

type root = test_case list

type int64 = Int64.t
