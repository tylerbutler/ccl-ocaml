(* Auto-generated from "ccl_test_types.atd" *)
[@@@ocaml.warning "-27-32-33-35-39"]

type rootValidation = [
    `Parse | `Parse_value | `Filter | `Compose | `Expand_dotted
  | `Build_hierarchy | `Get_string | `Get_int | `Get_bool | `Get_float
  | `Get_list | `Pretty_print | `Load | `Round_trip | `Canonical_format
  | `Associativity
]

type rootExpected_entries = { key: string; value: string }

type test_case = {
  name: string;
  input: string;
  validation: rootValidation;
  expected_count: int option;
  expected_entries: rootExpected_entries list option
}

type root = test_case list

type json = Yojson.Basic.t

type int64 = Int64.t
