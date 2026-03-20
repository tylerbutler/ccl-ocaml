(* JSON deserialization interface for CCL test suite format *)
[@@@ocaml.warning "-27-32-33-35-39"]

open Ccl_test_types_t

val cCLTestFlatFormat_of_string : string -> cCLTestFlatFormat
(** Deserialize a JSON string into a test suite. *)
