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

val write_cCLTestFlatFormatTestsVariants :
  Buffer.t -> cCLTestFlatFormatTestsVariants -> unit
  (** Output a JSON value of type {!type:cCLTestFlatFormatTestsVariants}. *)

val string_of_cCLTestFlatFormatTestsVariants :
  ?len:int -> cCLTestFlatFormatTestsVariants -> string
  (** Serialize a value of type {!type:cCLTestFlatFormatTestsVariants}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_cCLTestFlatFormatTestsVariants :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> cCLTestFlatFormatTestsVariants
  (** Input JSON data of type {!type:cCLTestFlatFormatTestsVariants}. *)

val cCLTestFlatFormatTestsVariants_of_string :
  string -> cCLTestFlatFormatTestsVariants
  (** Deserialize JSON data of type {!type:cCLTestFlatFormatTestsVariants}. *)

val write_cCLTestFlatFormatTestsValidation :
  Buffer.t -> cCLTestFlatFormatTestsValidation -> unit
  (** Output a JSON value of type {!type:cCLTestFlatFormatTestsValidation}. *)

val string_of_cCLTestFlatFormatTestsValidation :
  ?len:int -> cCLTestFlatFormatTestsValidation -> string
  (** Serialize a value of type {!type:cCLTestFlatFormatTestsValidation}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_cCLTestFlatFormatTestsValidation :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> cCLTestFlatFormatTestsValidation
  (** Input JSON data of type {!type:cCLTestFlatFormatTestsValidation}. *)

val cCLTestFlatFormatTestsValidation_of_string :
  string -> cCLTestFlatFormatTestsValidation
  (** Deserialize JSON data of type {!type:cCLTestFlatFormatTestsValidation}. *)

val write_cCLTestFlatFormatTestsFunctions :
  Buffer.t -> cCLTestFlatFormatTestsFunctions -> unit
  (** Output a JSON value of type {!type:cCLTestFlatFormatTestsFunctions}. *)

val string_of_cCLTestFlatFormatTestsFunctions :
  ?len:int -> cCLTestFlatFormatTestsFunctions -> string
  (** Serialize a value of type {!type:cCLTestFlatFormatTestsFunctions}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_cCLTestFlatFormatTestsFunctions :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> cCLTestFlatFormatTestsFunctions
  (** Input JSON data of type {!type:cCLTestFlatFormatTestsFunctions}. *)

val cCLTestFlatFormatTestsFunctions_of_string :
  string -> cCLTestFlatFormatTestsFunctions
  (** Deserialize JSON data of type {!type:cCLTestFlatFormatTestsFunctions}. *)

val write_cCLTestFlatFormatTestsConflicts :
  Buffer.t -> cCLTestFlatFormatTestsConflicts -> unit
  (** Output a JSON value of type {!type:cCLTestFlatFormatTestsConflicts}. *)

val string_of_cCLTestFlatFormatTestsConflicts :
  ?len:int -> cCLTestFlatFormatTestsConflicts -> string
  (** Serialize a value of type {!type:cCLTestFlatFormatTestsConflicts}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_cCLTestFlatFormatTestsConflicts :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> cCLTestFlatFormatTestsConflicts
  (** Input JSON data of type {!type:cCLTestFlatFormatTestsConflicts}. *)

val cCLTestFlatFormatTestsConflicts_of_string :
  string -> cCLTestFlatFormatTestsConflicts
  (** Deserialize JSON data of type {!type:cCLTestFlatFormatTestsConflicts}. *)

val write_cCLTestFlatFormatTestsBehaviors :
  Buffer.t -> cCLTestFlatFormatTestsBehaviors -> unit
  (** Output a JSON value of type {!type:cCLTestFlatFormatTestsBehaviors}. *)

val string_of_cCLTestFlatFormatTestsBehaviors :
  ?len:int -> cCLTestFlatFormatTestsBehaviors -> string
  (** Serialize a value of type {!type:cCLTestFlatFormatTestsBehaviors}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_cCLTestFlatFormatTestsBehaviors :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> cCLTestFlatFormatTestsBehaviors
  (** Input JSON data of type {!type:cCLTestFlatFormatTestsBehaviors}. *)

val cCLTestFlatFormatTestsBehaviors_of_string :
  string -> cCLTestFlatFormatTestsBehaviors
  (** Deserialize JSON data of type {!type:cCLTestFlatFormatTestsBehaviors}. *)

val write_cCLTestFlatFormatTests :
  Buffer.t -> cCLTestFlatFormatTests -> unit
  (** Output a JSON value of type {!type:cCLTestFlatFormatTests}. *)

val string_of_cCLTestFlatFormatTests :
  ?len:int -> cCLTestFlatFormatTests -> string
  (** Serialize a value of type {!type:cCLTestFlatFormatTests}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_cCLTestFlatFormatTests :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> cCLTestFlatFormatTests
  (** Input JSON data of type {!type:cCLTestFlatFormatTests}. *)

val cCLTestFlatFormatTests_of_string :
  string -> cCLTestFlatFormatTests
  (** Deserialize JSON data of type {!type:cCLTestFlatFormatTests}. *)

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

val write_cCLTestFlatFormat :
  Buffer.t -> cCLTestFlatFormat -> unit
  (** Output a JSON value of type {!type:cCLTestFlatFormat}. *)

val string_of_cCLTestFlatFormat :
  ?len:int -> cCLTestFlatFormat -> string
  (** Serialize a value of type {!type:cCLTestFlatFormat}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_cCLTestFlatFormat :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> cCLTestFlatFormat
  (** Input JSON data of type {!type:cCLTestFlatFormat}. *)

val cCLTestFlatFormat_of_string :
  string -> cCLTestFlatFormat
  (** Deserialize JSON data of type {!type:cCLTestFlatFormat}. *)

