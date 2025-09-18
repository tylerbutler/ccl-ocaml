# Bug Report #002: Missing Typed Access Functions

**Date**: 2025-09-17
**Severity**: Medium
**Component**: `lib/model.ml` (CCL model and operations)

## Summary

The CCL implementation lacks essential typed access functions (`get_int`, `get_bool`, `get_float`) that enable type-safe value extraction from configuration data. This prevents practical usage of CCL for applications requiring non-string data types.

## The Problem

CCL's data model can represent various value types, but the API only provides string and list accessors:

1. ✅ **String access works** via `get_string` function
2. ✅ **List access works** via `get_list` function
3. ❌ **Integer access missing** - no `get_int` function
4. ❌ **Boolean access missing** - no `get_bool` function
5. ❌ **Float access missing** - no `get_float` function

## Root Cause Analysis

The implementation foundation exists but typed accessors are simply unimplemented:

### Current Implementation (`lib/model.ml:79-102`)

```ocaml
let get_string (Fix map) path =
  try
    match KeyMap.find path map with
    | Fix inner_map when KeyMap.cardinal inner_map = 1 ->
        (* Extract single key as string value *)
        let (key, _) = KeyMap.choose inner_map in
        Some key
    | Fix inner_map when KeyMap.is_empty inner_map ->
        Some ""  (* Empty map = empty string *)
    | _ -> None
  with Not_found -> None

let get_list (Fix map) path =
  try
    match KeyMap.find path map with
    | Fix inner_map ->
        KeyMap.fold (fun key _value acc -> key :: acc) inner_map []
        |> List.rev
  with Not_found -> []
```

### Missing Pattern Extensions

The typed functions would follow the same pattern but add type conversion:

```ocaml
(* Missing implementations *)
let get_int (Fix map) path =
  match get_string (Fix map) path with
  | Some str ->
      (try Some (int_of_string str)
       with Failure _ -> None)
  | None -> None

let get_bool (Fix map) path =
  match get_string (Fix map) path with
  | Some "true" -> Some true
  | Some "false" -> Some false
  | _ -> None

let get_float (Fix map) path =
  match get_string (Fix map) path with
  | Some str ->
      (try Some (float_of_string str)
       with Failure _ -> None)
  | None -> None
```

## Affected Tests

**Test Failures Due to Missing Functions:**
1. `parse_integer_values_get_int` - Function `get_int` not found
2. `parse_boolean_values_get_bool` - Function `get_bool` not found
3. `parse_float_values_get_float` - Function `get_float` not found
4. `type_conversion_edge_cases_get_int` - Function `get_int` not found
5. `parse_missing_path_error_get_string` - Error handling inconsistency

**Current Capability Status** (`test_json_suite/test_capabilities.ml`):
```ocaml
functions = [
  "parse"; "parse_value"; "build_hierarchy"; "pretty_print";
  "get_string";  (* ✅ Implemented *)
  "get_list";    (* ✅ Implemented *)
  (* Missing: get_int, get_bool, get_float, filter, compose *)
]
```

## Expected Behavior Examples

### Integer Extraction (`get_int`)
```ccl
port = 8080
timeout = 30
invalid = not_a_number
```

**Expected API:**
```ocaml
let port = Model.get_int config "port"          (* Some 8080 *)
let timeout = Model.get_int config "timeout"    (* Some 30 *)
let invalid = Model.get_int config "invalid"    (* None *)
let missing = Model.get_int config "missing"    (* None *)
```

### Boolean Extraction (`get_bool`)
```ccl
debug = true
production = false
invalid = maybe
```

**Expected API:**
```ocaml
let debug = Model.get_bool config "debug"       (* Some true *)
let prod = Model.get_bool config "production"   (* Some false *)
let invalid = Model.get_bool config "invalid"   (* None *)
let missing = Model.get_bool config "missing"   (* None *)
```

### Float Extraction (`get_float`)
```ccl
pi = 3.14159
ratio = 0.618
invalid = not_a_float
```

**Expected API:**
```ocaml
let pi = Model.get_float config "pi"            (* Some 3.14159 *)
let ratio = Model.get_float config "ratio"      (* Some 0.618 *)
let invalid = Model.get_float config "invalid"  (* None *)
let missing = Model.get_float config "missing"  (* None *)
```

## Implementation Requirements

### 1. Type Conversion Logic
Each function needs robust conversion with graceful failure:
- **Integer**: Use `int_of_string` with exception handling
- **Boolean**: Match exact strings "true"/"false" (case-sensitive)
- **Float**: Use `float_of_string` with exception handling

### 2. Error Handling Pattern
Consistent with existing `get_string` approach:
- Missing keys → `None`
- Type conversion failures → `None`
- Invalid paths → `None`
- No exceptions propagated to caller

### 3. Interface Signatures
```ocaml
(* Required additions to model.mli *)
val get_int : t -> string -> int option
val get_bool : t -> string -> bool option
val get_float : t -> string -> float option
```

## Current Error Handling Issue

The existing `get_string` function has an inconsistency - test `parse_missing_path_error_get_string` expects error information but the function returns `None` for missing keys. This pattern should be clarified before implementing typed functions.

## Demonstration

To verify missing functions:

```bash
# Build the project
opam exec -- dune build

# Try to use missing functions (will fail compilation)
echo 'port = 8080' > test.ccl
echo 'let config = Ccl.decode_file "test.ccl" in
      match config with
      | Ok ccl -> Model.get_int ccl "port"
      | Error _ -> None' > test_missing.ml

# This will show "Unbound value Model.get_int"
ocaml -I _build/install/default/lib/ccl test_missing.ml
```

## Impact Assessment

**Blocked Functionality:**
- Configuration files with numeric values (ports, timeouts, limits)
- Boolean configuration flags (debug modes, feature toggles)
- Float-based settings (ratios, percentages, measurements)
- Type-safe configuration APIs for OCaml applications

**Current Workarounds:**
- Manual string parsing with `get_string` + conversion
- Application-level type conversion and error handling
- Limited to string-only configuration usage

**Implementation Effort:** Low - pattern established, simple type conversion additions

## Priority Justification

**Medium Priority** because:
- ✅ **Clear implementation path** - pattern established by `get_string`
- ✅ **High practical value** - enables real-world CCL usage
- ✅ **Low implementation cost** - straightforward type conversions
- ❌ **Has workarounds** - manual conversion possible but cumbersome

## Proposed Implementation

### Complete Implementation Outline
```ocaml
(* Add to lib/model.ml *)

let get_int (Fix map) path =
  match get_string (Fix map) path with
  | Some str ->
      (try Some (int_of_string (String.trim str))
       with Failure _ -> None)
  | None -> None

let get_bool (Fix map) path =
  match get_string (Fix map) path with
  | Some str ->
      (match String.trim str with
       | "true" -> Some true
       | "false" -> Some false
       | _ -> None)
  | None -> None

let get_float (Fix map) path =
  match get_string (Fix map) path with
  | Some str ->
      (try Some (float_of_string (String.trim str))
       with Failure _ -> None)
  | None -> None
```

### Test Configuration Update
```ocaml
(* Update test_json_suite/test_capabilities.ml *)
functions = [
  "parse"; "parse_value"; "build_hierarchy"; "pretty_print";
  "get_string"; "get_list";
  "get_int"; "get_bool"; "get_float";  (* Add these *)
  (* Still missing: filter, compose *)
]
```

## Environment

- **OCaml Version**: 5.3.0
- **Test Suite**: ccl-test-data (official JSON test suite)
- **Implementation**: ccl-ocaml
- **Dependencies**: None (uses standard library only)