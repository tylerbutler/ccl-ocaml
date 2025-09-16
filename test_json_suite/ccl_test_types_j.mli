(* Auto-generated from "ccl_test_types.atd" *)
[@@@ocaml.warning "-27-32-33-35-39"]

type rootValidation = Ccl_test_types_t.rootValidation

type rootExpected_entries = Ccl_test_types_t.rootExpected_entries = {
  key: string;
  value: string
}

type test_case = Ccl_test_types_t.test_case = {
  name: string;
  input: string;
  validation: rootValidation;
  expected_count: int option;
  expected_entries: rootExpected_entries list option
}

type root = Ccl_test_types_t.root

type json = Yojson.Basic.t

type int64 = Ccl_test_types_t.int64

val write_rootValidation :
  Buffer.t -> rootValidation -> unit
  (** Output a JSON value of type {!type:rootValidation}. *)

val string_of_rootValidation :
  ?len:int -> rootValidation -> string
  (** Serialize a value of type {!type:rootValidation}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_rootValidation :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> rootValidation
  (** Input JSON data of type {!type:rootValidation}. *)

val rootValidation_of_string :
  string -> rootValidation
  (** Deserialize JSON data of type {!type:rootValidation}. *)

val write_rootExpected_entries :
  Buffer.t -> rootExpected_entries -> unit
  (** Output a JSON value of type {!type:rootExpected_entries}. *)

val string_of_rootExpected_entries :
  ?len:int -> rootExpected_entries -> string
  (** Serialize a value of type {!type:rootExpected_entries}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_rootExpected_entries :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> rootExpected_entries
  (** Input JSON data of type {!type:rootExpected_entries}. *)

val rootExpected_entries_of_string :
  string -> rootExpected_entries
  (** Deserialize JSON data of type {!type:rootExpected_entries}. *)

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

