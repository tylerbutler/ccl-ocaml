# Bug Report #002: Missing Typed Access Functions

**Date**: 2025-09-17
**Reporter**: Community Contributor
**Severity**: Medium
**Component**: `lib/model.ml` (CCL model and operations)

## Summary

Several typed access functions appear to be missing from the implementation, preventing type-aware value extraction from CCL configurations. The test suite expects these functions to be available for practical CCL usage.

## Affected Tests

1. `parse_integer_values_get_int` - Function `get_int` not implemented
2. `parse_boolean_values_get_bool` - Function `get_bool` not implemented
3. `parse_float_values_get_float` - Function `get_float` not implemented
4. `type_conversion_edge_cases_get_int` - Function `get_int` not implemented
5. `parse_missing_path_error_get_string` - Missing key error handling

## Current Implementation Status

### ✅ Working Functions
- `get_string` - Basic string value extraction (implemented)
- `get_list` - List value extraction (implemented)

### ❌ Missing Functions
- `get_int` - Integer value extraction with type conversion
- `get_bool` - Boolean value extraction with type conversion
- `get_float` - Float value extraction with type conversion

## Expected Behavior Examples

### Integer Extraction (`get_int`)
```ccl
port = 8080
timeout = 30
```

Expected API usage:
```ocaml
let port = Model.get_int config ["port"] (* Should return Some 8080 *)
let timeout = Model.get_int config ["timeout"] (* Should return Some 30 *)
let missing = Model.get_int config ["missing"] (* Should return None or error *)
```

### Boolean Extraction (`get_bool`)
```ccl
debug = true
production = false
```

Expected API usage:
```ocaml
let debug = Model.get_bool config ["debug"] (* Should return Some true *)
let prod = Model.get_bool config ["production"] (* Should return Some false *)
```

### Float Extraction (`get_float`)
```ccl
pi = 3.14159
ratio = 0.618
```

Expected API usage:
```ocaml
let pi = Model.get_float config ["pi"] (* Should return Some 3.14159 *)
let ratio = Model.get_float config ["ratio"] (* Should return Some 0.618 *)
```

## Missing Key Error Handling

The `get_string` function currently fails with `Key 'missing' not found` instead of returning a proper error type. This suggests the error handling pattern might need clarification across all typed access functions.

## Implementation Considerations

I understand these functions would likely need to:

1. **Type Conversion**: Parse string values into appropriate types
2. **Error Handling**: Handle conversion failures gracefully
3. **Missing Keys**: Consistent error/option handling across all functions
4. **Edge Cases**: Handle malformed values (e.g., `port = not_a_number`)

## Reference Implementation Context

Looking at the existing `get_string` implementation, I suspect the typed functions would follow a similar pattern but with additional type conversion logic.

## Test Configuration Context

The test capabilities configuration in `test_json_suite/test_capabilities.ml` shows these functions are expected:

```ocaml
functions = [
  "parse";
  "parse_value";
  "build_hierarchy";
  "pretty_print";
  "get_string";              (* ✅ Implemented *)
  "get_list";                (* ✅ Implemented *)
  (* Unimplemented: get_int, get_bool, get_float, filter, compose *)
]
```

## Suggested Implementation Approach

I respectfully suggest these functions might follow this pattern:

```ocaml
(* Hypothetical signatures *)
val get_int : t -> string list -> (int, error) result
val get_bool : t -> string list -> (bool, error) result
val get_float : t -> string list -> (float, error) result
```

With appropriate error types for:
- Missing keys
- Type conversion failures
- Invalid path traversal

## Environment

- **OCaml Version**: 5.3.0
- **Test Suite**: ccl-test-data (official JSON test suite)
- **Implementation**: ccl-ocaml

## Additional Context

I acknowledge these might be planned features rather than bugs. The comment in the capabilities file suggests awareness that these functions are "unimplemented."

I would appreciate guidance on:
1. Whether these functions are planned for implementation
2. The expected API design and error handling patterns
3. Any implementation priorities or timeline considerations

Thank you for your consideration and guidance.