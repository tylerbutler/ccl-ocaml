(* Type definitions for CCL test suite JSON format *)
[@@@ocaml.warning "-27-32-33-35-39"]

type json = Yojson.Basic.t

type cCLTestFlatFormatTestsVariants = [
    `Proposed_behavior | `Reference_compliant
]

(** Single CCL function to validate *)
type cCLTestFlatFormatTestsValidation = [
    `Parse | `Parse_indented | `Filter | `Compose | `Build_hierarchy
  | `Get_string | `Get_int | `Get_bool | `Get_float | `Get_list
  | `Print | `Canonical_format | `Load | `Round_trip
  | `Compose_associative | `Identity_left | `Identity_right
]

type cCLTestFlatFormatTestsFunctions = [
    `Parse | `Parse_indented | `Filter | `Compose | `Build_hierarchy
  | `Get_string | `Get_int | `Get_bool | `Get_float | `Get_list
  | `Print | `Canonical_format | `Load | `Round_trip
  | `Compose_associative | `Identity_left | `Identity_right
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
  | `Crlf_normalize_to_lf | `Tabs_as_content | `Tabs_as_whitespace
  | `Indent_spaces | `Indent_tabs
  | `List_coercion_enabled | `List_coercion_disabled
  | `Array_order_insertion | `Array_order_lexicographic
  | `Toplevel_indent_strip | `Toplevel_indent_preserve
  | `Delimiter_first_equals | `Delimiter_prefer_spaced
]

type cCLTestFlatFormatTests = {
  name: string;
  inputs: string list;
  validation: cCLTestFlatFormatTestsValidation;
  expected: json;
  args: string list option;
  functions: cCLTestFlatFormatTestsFunctions list option;
  behaviors: cCLTestFlatFormatTestsBehaviors list;
  variants: cCLTestFlatFormatTestsVariants list;
  features: string list;
  conflicts: cCLTestFlatFormatTestsConflicts option;
  requires: string list option;
  source_test: string option;
  expect_error: bool;
  error_type: string option;
}

type root = cCLTestFlatFormatTests list

type int64 = Int64.t

(** Schema for existing generated flat test files *)
type cCLTestFlatFormat = {
  schema: string;
  tests: cCLTestFlatFormatTests list;
}
