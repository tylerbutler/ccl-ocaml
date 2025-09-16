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

let write_rootValidation = (
  fun ob x ->
    match x with
      | `Parse -> Buffer.add_string ob "<\"parse\">"
      | `Parse_value -> Buffer.add_string ob "<\"parse_value\">"
      | `Filter -> Buffer.add_string ob "<\"filter\">"
      | `Compose -> Buffer.add_string ob "<\"compose\">"
      | `Expand_dotted -> Buffer.add_string ob "<\"expand_dotted\">"
      | `Build_hierarchy -> Buffer.add_string ob "<\"build_hierarchy\">"
      | `Get_string -> Buffer.add_string ob "<\"get_string\">"
      | `Get_int -> Buffer.add_string ob "<\"get_int\">"
      | `Get_bool -> Buffer.add_string ob "<\"get_bool\">"
      | `Get_float -> Buffer.add_string ob "<\"get_float\">"
      | `Get_list -> Buffer.add_string ob "<\"get_list\">"
      | `Pretty_print -> Buffer.add_string ob "<\"pretty_print\">"
      | `Load -> Buffer.add_string ob "<\"load\">"
      | `Round_trip -> Buffer.add_string ob "<\"round_trip\">"
      | `Canonical_format -> Buffer.add_string ob "<\"canonical_format\">"
      | `Associativity -> Buffer.add_string ob "<\"associativity\">"
)
let string_of_rootValidation ?(len = 1024) x =
  let ob = Buffer.create len in
  write_rootValidation ob x;
  Buffer.contents ob
let read_rootValidation = (
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
            | "filter" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Filter
            | "compose" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Compose
            | "expand_dotted" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Expand_dotted
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
            | "pretty_print" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Pretty_print
            | "load" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Load
            | "round_trip" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Round_trip
            | "canonical_format" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Canonical_format
            | "associativity" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              `Associativity
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "parse" ->
              `Parse
            | "parse_value" ->
              `Parse_value
            | "filter" ->
              `Filter
            | "compose" ->
              `Compose
            | "expand_dotted" ->
              `Expand_dotted
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
            | "pretty_print" ->
              `Pretty_print
            | "load" ->
              `Load
            | "round_trip" ->
              `Round_trip
            | "canonical_format" ->
              `Canonical_format
            | "associativity" ->
              `Associativity
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let rootValidation_of_string s =
  read_rootValidation (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_rootExpected_entries : _ -> rootExpected_entries -> _ = (
  fun ob (x : rootExpected_entries) ->
    Buffer.add_char ob '{';
    let is_first = ref true in
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"key\":";
    (
      Yojson.Safe.write_string
    )
      ob x.key;
    if !is_first then
      is_first := false
    else
      Buffer.add_char ob ',';
      Buffer.add_string ob "\"value\":";
    (
      Yojson.Safe.write_string
    )
      ob x.value;
    Buffer.add_char ob '}';
)
let string_of_rootExpected_entries ?(len = 1024) x =
  let ob = Buffer.create len in
  write_rootExpected_entries ob x;
  Buffer.contents ob
let read_rootExpected_entries = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    Yojson.Safe.read_lcurl p lb;
    let field_key = ref (None) in
    let field_value = ref (None) in
    try
      Yojson.Safe.read_space p lb;
      Yojson.Safe.read_object_end lb;
      Yojson.Safe.read_space p lb;
      let f =
        fun s pos len ->
          if pos < 0 || len < 0 || pos + len > String.length s then
            invalid_arg (Printf.sprintf "out-of-bounds substring position or length: string = %S, requested position = %i, requested length = %i" s pos len);
          match len with
            | 3 -> (
                if String.unsafe_get s pos = 'k' && String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'y' then (
                  0
                )
                else (
                  -1
                )
              )
            | 5 -> (
                if String.unsafe_get s pos = 'v' && String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'l' && String.unsafe_get s (pos+3) = 'u' && String.unsafe_get s (pos+4) = 'e' then (
                  1
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
            field_key := (
              Some (
                (
                  Atdgen_runtime.Oj_run.read_string
                ) p lb
              )
            );
          | 1 ->
            field_value := (
              Some (
                (
                  Atdgen_runtime.Oj_run.read_string
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
              | 3 -> (
                  if String.unsafe_get s pos = 'k' && String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'y' then (
                    0
                  )
                  else (
                    -1
                  )
                )
              | 5 -> (
                  if String.unsafe_get s pos = 'v' && String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'l' && String.unsafe_get s (pos+3) = 'u' && String.unsafe_get s (pos+4) = 'e' then (
                    1
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
              field_key := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_string
                  ) p lb
                )
              );
            | 1 ->
              field_value := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_string
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
            key = (match !field_key with Some x -> x | None -> Atdgen_runtime.Oj_run.missing_field p "key");
            value = (match !field_value with Some x -> x | None -> Atdgen_runtime.Oj_run.missing_field p "value");
          }
         : rootExpected_entries)
      )
)
let rootExpected_entries_of_string s =
  read_rootExpected_entries (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__rootExpected_entries_list = (
  Atdgen_runtime.Oj_run.write_list (
    write_rootExpected_entries
  )
)
let string_of__rootExpected_entries_list ?(len = 1024) x =
  let ob = Buffer.create len in
  write__rootExpected_entries_list ob x;
  Buffer.contents ob
let read__rootExpected_entries_list = (
  Atdgen_runtime.Oj_run.read_list (
    read_rootExpected_entries
  )
)
let _rootExpected_entries_list_of_string s =
  read__rootExpected_entries_list (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__rootExpected_entries_list_option = (
  Atdgen_runtime.Oj_run.write_option (
    write__rootExpected_entries_list
  )
)
let string_of__rootExpected_entries_list_option ?(len = 1024) x =
  let ob = Buffer.create len in
  write__rootExpected_entries_list_option ob x;
  Buffer.contents ob
let read__rootExpected_entries_list_option = (
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
                  read__rootExpected_entries_list
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
                  read__rootExpected_entries_list
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _rootExpected_entries_list_option_of_string s =
  read__rootExpected_entries_list_option (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__int_option = (
  Atdgen_runtime.Oj_run.write_option (
    Yojson.Safe.write_int
  )
)
let string_of__int_option ?(len = 1024) x =
  let ob = Buffer.create len in
  write__int_option ob x;
  Buffer.contents ob
let read__int_option = (
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
                  Atdgen_runtime.Oj_run.read_int
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
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _int_option_of_string s =
  read__int_option (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_test_case : _ -> test_case -> _ = (
  fun ob (x : test_case) ->
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
      write_rootValidation
    )
      ob x.validation;
    (match x.expected_count with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"expected_count\":";
      (
        Yojson.Safe.write_int
      )
        ob x;
    );
    (match x.expected_entries with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Buffer.add_char ob ',';
        Buffer.add_string ob "\"expected_entries\":";
      (
        write__rootExpected_entries_list
      )
        ob x;
    );
    Buffer.add_char ob '}';
)
let string_of_test_case ?(len = 1024) x =
  let ob = Buffer.create len in
  write_test_case ob x;
  Buffer.contents ob
let read_test_case = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    Yojson.Safe.read_lcurl p lb;
    let field_name = ref (None) in
    let field_input = ref (None) in
    let field_validation = ref (None) in
    let field_expected_count = ref (None) in
    let field_expected_entries = ref (None) in
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
                if String.unsafe_get s pos = 'n' && String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'm' && String.unsafe_get s (pos+3) = 'e' then (
                  0
                )
                else (
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
            | 10 -> (
                if String.unsafe_get s pos = 'v' && String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'l' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 'd' && String.unsafe_get s (pos+5) = 'a' && String.unsafe_get s (pos+6) = 't' && String.unsafe_get s (pos+7) = 'i' && String.unsafe_get s (pos+8) = 'o' && String.unsafe_get s (pos+9) = 'n' then (
                  2
                )
                else (
                  -1
                )
              )
            | 14 -> (
                if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'x' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 't' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 'd' && String.unsafe_get s (pos+8) = '_' && String.unsafe_get s (pos+9) = 'c' && String.unsafe_get s (pos+10) = 'o' && String.unsafe_get s (pos+11) = 'u' && String.unsafe_get s (pos+12) = 'n' && String.unsafe_get s (pos+13) = 't' then (
                  3
                )
                else (
                  -1
                )
              )
            | 16 -> (
                if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'x' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 't' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 'd' && String.unsafe_get s (pos+8) = '_' && String.unsafe_get s (pos+9) = 'e' && String.unsafe_get s (pos+10) = 'n' && String.unsafe_get s (pos+11) = 't' && String.unsafe_get s (pos+12) = 'r' && String.unsafe_get s (pos+13) = 'i' && String.unsafe_get s (pos+14) = 'e' && String.unsafe_get s (pos+15) = 's' then (
                  4
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
                  read_rootValidation
                ) p lb
              )
            );
          | 3 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_expected_count := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_int
                  ) p lb
                )
              );
            )
          | 4 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_expected_entries := (
                Some (
                  (
                    read__rootExpected_entries_list
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
                  if String.unsafe_get s pos = 'n' && String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'm' && String.unsafe_get s (pos+3) = 'e' then (
                    0
                  )
                  else (
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
              | 10 -> (
                  if String.unsafe_get s pos = 'v' && String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'l' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 'd' && String.unsafe_get s (pos+5) = 'a' && String.unsafe_get s (pos+6) = 't' && String.unsafe_get s (pos+7) = 'i' && String.unsafe_get s (pos+8) = 'o' && String.unsafe_get s (pos+9) = 'n' then (
                    2
                  )
                  else (
                    -1
                  )
                )
              | 14 -> (
                  if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'x' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 't' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 'd' && String.unsafe_get s (pos+8) = '_' && String.unsafe_get s (pos+9) = 'c' && String.unsafe_get s (pos+10) = 'o' && String.unsafe_get s (pos+11) = 'u' && String.unsafe_get s (pos+12) = 'n' && String.unsafe_get s (pos+13) = 't' then (
                    3
                  )
                  else (
                    -1
                  )
                )
              | 16 -> (
                  if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'x' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 't' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 'd' && String.unsafe_get s (pos+8) = '_' && String.unsafe_get s (pos+9) = 'e' && String.unsafe_get s (pos+10) = 'n' && String.unsafe_get s (pos+11) = 't' && String.unsafe_get s (pos+12) = 'r' && String.unsafe_get s (pos+13) = 'i' && String.unsafe_get s (pos+14) = 'e' && String.unsafe_get s (pos+15) = 's' then (
                    4
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
                    read_rootValidation
                  ) p lb
                )
              );
            | 3 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_expected_count := (
                  Some (
                    (
                      Atdgen_runtime.Oj_run.read_int
                    ) p lb
                  )
                );
              )
            | 4 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_expected_entries := (
                  Some (
                    (
                      read__rootExpected_entries_list
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
            expected_count = !field_expected_count;
            expected_entries = !field_expected_entries;
          }
         : test_case)
      )
)
let test_case_of_string s =
  read_test_case (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__test_case_list = (
  Atdgen_runtime.Oj_run.write_list (
    write_test_case
  )
)
let string_of__test_case_list ?(len = 1024) x =
  let ob = Buffer.create len in
  write__test_case_list ob x;
  Buffer.contents ob
let read__test_case_list = (
  Atdgen_runtime.Oj_run.read_list (
    read_test_case
  )
)
let _test_case_list_of_string s =
  read__test_case_list (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_root = (
  write__test_case_list
)
let string_of_root ?(len = 1024) x =
  let ob = Buffer.create len in
  write_root ob x;
  Buffer.contents ob
let read_root = (
  read__test_case_list
)
let root_of_string s =
  read_root (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
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
