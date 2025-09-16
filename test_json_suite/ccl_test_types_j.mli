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

val write_test_caseVariants :
  Buffer.t -> test_caseVariants -> unit
  (** Output a JSON value of type {!type:test_caseVariants}. *)

val string_of_test_caseVariants :
  ?len:int -> test_caseVariants -> string
  (** Serialize a value of type {!type:test_caseVariants}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_test_caseVariants :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> test_caseVariants
  (** Input JSON data of type {!type:test_caseVariants}. *)

val test_caseVariants_of_string :
  string -> test_caseVariants
  (** Deserialize JSON data of type {!type:test_caseVariants}. *)

val write_test_caseValidation :
  Buffer.t -> test_caseValidation -> unit
  (** Output a JSON value of type {!type:test_caseValidation}. *)

val string_of_test_caseValidation :
  ?len:int -> test_caseValidation -> string
  (** Serialize a value of type {!type:test_caseValidation}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_test_caseValidation :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> test_caseValidation
  (** Input JSON data of type {!type:test_caseValidation}. *)

val test_caseValidation_of_string :
  string -> test_caseValidation
  (** Deserialize JSON data of type {!type:test_caseValidation}. *)

val write_test_caseFunctions :
  Buffer.t -> test_caseFunctions -> unit
  (** Output a JSON value of type {!type:test_caseFunctions}. *)

val string_of_test_caseFunctions :
  ?len:int -> test_caseFunctions -> string
  (** Serialize a value of type {!type:test_caseFunctions}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_test_caseFunctions :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> test_caseFunctions
  (** Input JSON data of type {!type:test_caseFunctions}. *)

val test_caseFunctions_of_string :
  string -> test_caseFunctions
  (** Deserialize JSON data of type {!type:test_caseFunctions}. *)

val write_test_caseFeatures :
  Buffer.t -> test_caseFeatures -> unit
  (** Output a JSON value of type {!type:test_caseFeatures}. *)

val string_of_test_caseFeatures :
  ?len:int -> test_caseFeatures -> string
  (** Serialize a value of type {!type:test_caseFeatures}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_test_caseFeatures :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> test_caseFeatures
  (** Input JSON data of type {!type:test_caseFeatures}. *)

val test_caseFeatures_of_string :
  string -> test_caseFeatures
  (** Deserialize JSON data of type {!type:test_caseFeatures}. *)

val write_test_caseConflicts :
  Buffer.t -> test_caseConflicts -> unit
  (** Output a JSON value of type {!type:test_caseConflicts}. *)

val string_of_test_caseConflicts :
  ?len:int -> test_caseConflicts -> string
  (** Serialize a value of type {!type:test_caseConflicts}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_test_caseConflicts :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> test_caseConflicts
  (** Input JSON data of type {!type:test_caseConflicts}. *)

val test_caseConflicts_of_string :
  string -> test_caseConflicts
  (** Deserialize JSON data of type {!type:test_caseConflicts}. *)

val write_test_caseBehaviors :
  Buffer.t -> test_caseBehaviors -> unit
  (** Output a JSON value of type {!type:test_caseBehaviors}. *)

val string_of_test_caseBehaviors :
  ?len:int -> test_caseBehaviors -> string
  (** Serialize a value of type {!type:test_caseBehaviors}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_test_caseBehaviors :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> test_caseBehaviors
  (** Input JSON data of type {!type:test_caseBehaviors}. *)

val test_caseBehaviors_of_string :
  string -> test_caseBehaviors
  (** Deserialize JSON data of type {!type:test_caseBehaviors}. *)

val write_json :
  Buffer.t -> json -> unit
  (** Output a JSON value of type {!type:json}. *)

val string_of_json :
  ?len:int -> json -> string
  (** Serialize a value of type {!type:json}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_json :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> json
  (** Input JSON data of type {!type:json}. *)

val json_of_string :
  string -> json
  (** Deserialize JSON data of type {!type:json}. *)

val write_test_case :
  Buffer.t -> test_case -> unit
  (** Output a JSON value of type {!type:test_case}. *)

val string_of_test_case :
  ?len:int -> test_case -> string
  (** Serialize a value of type {!type:test_case}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_test_case :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> test_case
  (** Input JSON data of type {!type:test_case}. *)

val test_case_of_string :
  string -> test_case
  (** Deserialize JSON data of type {!type:test_case}. *)

val write_test_suite :
  Buffer.t -> test_suite -> unit
  (** Output a JSON value of type {!type:test_suite}. *)

val string_of_test_suite :
  ?len:int -> test_suite -> string
  (** Serialize a value of type {!type:test_suite}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_test_suite :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> test_suite
  (** Input JSON data of type {!type:test_suite}. *)

val test_suite_of_string :
  string -> test_suite
  (** Deserialize JSON data of type {!type:test_suite}. *)

val write_root :
  Buffer.t -> root -> unit
  (** Output a JSON value of type {!type:root}. *)

val string_of_root :
  ?len:int -> root -> string
  (** Serialize a value of type {!type:root}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_root :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> root
  (** Input JSON data of type {!type:root}. *)

val root_of_string :
  string -> root
  (** Deserialize JSON data of type {!type:root}. *)

val write_int64 :
  Buffer.t -> int64 -> unit
  (** Output a JSON value of type {!type:int64}. *)

val string_of_int64 :
  ?len:int -> int64 -> string
  (** Serialize a value of type {!type:int64}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_int64 :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> int64
  (** Input JSON data of type {!type:int64}. *)

val int64_of_string :
  string -> int64
  (** Deserialize JSON data of type {!type:int64}. *)

