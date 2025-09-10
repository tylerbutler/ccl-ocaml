open Yojson.Safe
open Yojson.Safe.Util

type entry = {
  key : string;
  value : string;
}

type error_validation = {
  error : bool;
  error_type : string option;
  error_pattern : string option;
  error_message : string option;
}

type parse_validation = 
  | Entries of { count : int; expected : entry list }
  | ParseError of error_validation

type filter_validation = 
  | FilteredEntries of { count : int; expected : entry list }
  | FilterError of error_validation

type compose_validation = 
  | CompositionResult of {
      left : entry list;
      right : entry list;
      expected : entry list;
    }
  | ComposeError of error_validation

type expand_dotted_validation = 
  | ExpandedEntries of { count : int; expected : entry list }
  | ExpandError of error_validation

type make_objects_validation = 
  | ObjectResult of { count : int; expected : Yojson.Safe.t }
  | ObjectError of error_validation

type typed_access_case = 
  | TypedResultCase of {
      args : string list;
      expected : Yojson.Safe.t;
    }
  | TypedErrorCase of {
      args : string list;
      error : error_validation;
    }

type typed_access_validation = 
  | TypedCases of { count : int; cases : typed_access_case list }

type pretty_print_validation = 
  | PrettyResult of string
  | PrettyError of error_validation

type round_trip_validation = {
  property : string;
  description : string option;
}

type canonical_format_validation = {
  expected : string;
  description : string option;
}

type associativity_validation = {
  property : string;
  left_assoc : string option;
  right_assoc : string option;
  should_be_equal : bool;
}

type validations = {
  parse : parse_validation option;
  parse_value : parse_validation option;
  filter : filter_validation option;
  compose : compose_validation option;
  expand_dotted : expand_dotted_validation option;
  make_objects : make_objects_validation option;
  get_string : typed_access_validation option;
  get_int : typed_access_validation option;
  get_bool : typed_access_validation option;
  get_float : typed_access_validation option;
  pretty_print : pretty_print_validation option;
  round_trip : round_trip_validation option;
  canonical_format : canonical_format_validation option;
  associativity : associativity_validation option;
}

type test_metadata = {
  tags : string list;
  level : int;
  feature : string option;
  difficulty : string option;
}

type test_config = {
  skip_optional_features : bool;
  ignored_features : string list;
  skip_features : string list;
  skip_proposed : bool;  (* Skip tests with "proposed" or "proposed-behavior" tags *)
  skip_tags : string list;  (* Skip tests with these tags *)
}

type test_case = {
  name : string;
  input : string option;
  input1 : string option;
  input2 : string option;
  input3 : string option;
  validations : validations;
  meta : test_metadata;
}

type test_suite = {
  suite : string;
  version : string;
  description : string option;
  tests : test_case list;
}

(* JSON parsing functions *)

let parse_entry json =
  match json with
  | `Assoc [("key", `String key); ("value", `String value)]
  | `Assoc [("value", `String value); ("key", `String key)] ->
      { key; value }
  | _ -> failwith "Invalid entry format"

let parse_error_validation json =
  let error = json |> member "error" |> to_bool in
  let error_type = json |> member "error_type" |> to_string_option in
  let error_pattern = json |> member "error_pattern" |> to_string_option in
  let error_message = json |> member "error_message" |> to_string_option in
  { error; error_type; error_pattern; error_message }

let parse_parse_validation json =
  match json with
  | `Assoc _ when member "expected" json <> `Null ->
      let expected_entries = json |> member "expected" |> to_list |> List.map parse_entry in
      let count = json |> member "count" |> to_int in
      Entries { count; expected = expected_entries }
  | `Assoc _ when member "error" json <> `Null ->
      ParseError (parse_error_validation json)
  | _ -> failwith "Invalid parse validation format"

let parse_filter_validation json =
  match json with
  | `Assoc _ when member "expected" json <> `Null ->
      let expected_entries = json |> member "expected" |> to_list |> List.map parse_entry in
      let count = json |> member "count" |> to_int in
      FilteredEntries { count; expected = expected_entries }
  | `Assoc _ when member "error" json <> `Null ->
      FilterError (parse_error_validation json)
  | _ -> failwith "Invalid filter validation format"

let parse_compose_validation json =
  match json with
  | `Assoc _ when member "left" json <> `Null ->
      let left = json |> member "left" |> to_list |> List.map parse_entry in
      let right = json |> member "right" |> to_list |> List.map parse_entry in
      let expected = json |> member "expected" |> to_list |> List.map parse_entry in
      CompositionResult { left; right; expected }
  | `Assoc _ when member "error" json <> `Null ->
      ComposeError (parse_error_validation json)
  | _ -> failwith "Invalid compose validation format"

let parse_expand_dotted_validation json =
  match json with
  | `Assoc _ when member "expected" json <> `Null ->
      let expected_entries = json |> member "expected" |> to_list |> List.map parse_entry in
      let count = json |> member "count" |> to_int in
      ExpandedEntries { count; expected = expected_entries }
  | `Assoc _ when member "error" json <> `Null ->
      ExpandError (parse_error_validation json)
  | _ -> failwith "Invalid expand_dotted validation format"

let parse_make_objects_validation json =
  match json with
  | `Assoc _ when member "expected" json <> `Null ->
      let expected_obj = json |> member "expected" in
      let count = json |> member "count" |> to_int in
      ObjectResult { count; expected = expected_obj }
  | `Assoc _ when member "error" json <> `Null ->
      ObjectError (parse_error_validation json)
  | _ -> failwith "Invalid make_objects validation format"

let parse_typed_access_case json =
  match json with
  | `Assoc _ when member "args" json <> `Null && member "expected" json <> `Null ->
      let args = json |> member "args" |> to_list |> List.map to_string in
      let expected = json |> member "expected" in
      TypedResultCase { args; expected }
  | `Assoc _ when member "args" json <> `Null && member "error" json <> `Null ->
      let args = json |> member "args" |> to_list |> List.map to_string in
      let error = { error = true; error_type = None; error_pattern = None; error_message = json |> member "error_message" |> to_string_option } in
      TypedErrorCase { args; error }
  | _ -> failwith "Invalid typed access case format"

let parse_typed_access_validation json =
  match json with
  | `Assoc _ when member "cases" json <> `Null ->
      let cases_json = json |> member "cases" |> to_list in
      let cases = List.map parse_typed_access_case cases_json in
      let count = json |> member "count" |> to_int in
      TypedCases { count; cases }
  | _ -> failwith "Invalid typed access validation format"

let parse_pretty_print_validation json =
  match json with
  | `String result -> PrettyResult result
  | `Assoc _ when member "error" json <> `Null ->
      PrettyError (parse_error_validation json)
  | _ -> failwith "Invalid pretty print validation format"

let parse_round_trip_validation json =
  let property = json |> member "property" |> to_string in
  let description = json |> member "description" |> to_string_option in
  { property; description }

let parse_canonical_format_validation json =
  let expected = json |> member "expected" |> to_string in
  let description = json |> member "description" |> to_string_option in
  { expected; description }

let parse_associativity_validation json =
  let property = json |> member "property" |> to_string in
  let left_assoc = json |> member "left_assoc" |> to_string_option in
  let right_assoc = json |> member "right_assoc" |> to_string_option in
  let should_be_equal = json |> member "should_be_equal" |> to_bool in
  { property; left_assoc; right_assoc; should_be_equal }

let parse_validations json =
  let parse_optional_validation field parser =
    match member field json with
    | `Null -> None
    | value -> Some (parser value)
  in
  {
    parse = parse_optional_validation "parse" parse_parse_validation;
    parse_value = parse_optional_validation "parse_value" parse_parse_validation;
    filter = parse_optional_validation "filter" parse_filter_validation;
    compose = parse_optional_validation "compose" parse_compose_validation;
    expand_dotted = parse_optional_validation "expand_dotted" parse_expand_dotted_validation;
    make_objects = parse_optional_validation "make_objects" parse_make_objects_validation;
    get_string = parse_optional_validation "get_string" parse_typed_access_validation;
    get_int = parse_optional_validation "get_int" parse_typed_access_validation;
    get_bool = parse_optional_validation "get_bool" parse_typed_access_validation;
    get_float = parse_optional_validation "get_float" parse_typed_access_validation;
    pretty_print = parse_optional_validation "pretty_print" parse_pretty_print_validation;
    round_trip = parse_optional_validation "round_trip" parse_round_trip_validation;
    canonical_format = parse_optional_validation "canonical_format" parse_canonical_format_validation;
    associativity = parse_optional_validation "associativity" parse_associativity_validation;
  }

let parse_test_metadata json =
  let tags = json |> member "tags" |> to_list |> List.map to_string in
  let level = json |> member "level" |> to_int in
  let feature = json |> member "feature" |> to_string_option in
  let difficulty = json |> member "difficulty" |> to_string_option in
  { tags; level; feature; difficulty }

let parse_test_case json =
  let name = json |> member "name" |> to_string in
  let input = json |> member "input" |> to_string_option in
  let input1 = json |> member "input1" |> to_string_option in
  let input2 = json |> member "input2" |> to_string_option in
  let input3 = json |> member "input3" |> to_string_option in
  let validations = json |> member "validations" |> parse_validations in
  let meta = json |> member "meta" |> parse_test_metadata in
  { name; input; input1; input2; input3; validations; meta }

let parse_test_suite json =
  let suite = json |> member "suite" |> to_string in
  let version = json |> member "version" |> to_string in
  let description = json |> member "description" |> to_string_option in
  let tests = json |> member "tests" |> to_list |> List.map parse_test_case in
  { suite; version; description; tests }

let load_test_suite_from_file filename =
  let json = from_file filename in
  parse_test_suite json