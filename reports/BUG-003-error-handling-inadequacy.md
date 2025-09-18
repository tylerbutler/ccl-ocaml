# Bug Report #003: Parser Error Handling for Malformed Inputs

**Date**: 2025-09-17
**Severity**: Low
**Component**: `lib/parser.ml` (Angstrom parser implementation)

## Summary

The CCL parser produces generic "not enough input" error messages for various types of malformed input, making it difficult for users to understand and fix configuration errors. While the parser correctly rejects invalid input, the lack of specific error information degrades the developer experience.

## The Problem

The parser fails to provide contextual error messages for different types of invalid input:

1. ✅ **Correctly rejects malformed input** - parser logic works
2. ❌ **Generic error messages** - all failures report "not enough input"
3. ❌ **No error context** - users can't identify specific problems
4. ❌ **Poor debugging experience** - difficult to fix configuration issues

## Root Cause Analysis

The issue stems from Angstrom's default error reporting mechanism in the parsing chain:

### Current Error Propagation (`lib/parser.ml:87-91`)

```ocaml
let parse str =
  match parse_string ~consume:All kvs_p str with
  | Error msg -> Error (`Parse_error msg)
  | Ok key_vals -> Ok (Model.fix key_vals)
```

### Error Source Analysis

The `key_val` function (`lib/parser.ml:57-63`) expects a specific pattern:

```ocaml
let key_val prefix_len =
  let* key = many (not_char '=') >>| trim_key in
  let* _ = blank in
  let* _ = char '=' in          (* Fails here for inputs without '=' *)
  let* value = value_p prefix_len >>| trim_value in
  let* _ = blank in
  return { key; value }
```

**Why "not enough input" occurs:**
- Angstrom's `char '='` parser expects to find `=` character
- When `=` is missing, it reaches end of input without finding expected character
- Results in generic "not enough input" message instead of "missing '=' separator"

### Missing Error Context

The parser doesn't distinguish between:
- **Missing separators**: `just_a_key` (no `=` found)
- **Invalid structure**: `line one\nline two` (multiple lines without structure)
- **Malformed syntax**: `key value` (space instead of `=`)

## Affected Test Cases

### Test Case 1: Single Key Without Separator
```ccl
Input: "just_a_key"
```

**Current**: `Parse error: : not enough input`
**Expected**: `Parse error: Missing '=' separator after key 'just_a_key'`

**Root cause**: `char '='` parser fails at end of input

### Test Case 2: Plain Text Input
```ccl
Input: "just a string without structure"
```

**Current**: `Parse error: : not enough input`
**Expected**: `Parse error: Invalid CCL format - no key-value pairs found`

**Root cause**: Parser expects key-value structure, finds plain text

### Test Case 3: Multiline Plain Text
```ccl
Input: "line one\nline two\nline three"
```

**Current**: `Parse error: : not enough input`
**Expected**: `Parse error: Invalid CCL format - lines missing '=' separators`

**Root cause**: Each line fails the `char '='` requirement

## Working Error Cases (Evidence)

These error cases work correctly, showing the parser can handle some invalid scenarios:

✅ **Parser catches real syntax errors in valid CCL structure**
✅ **Empty input is handled gracefully**
✅ **Properly structured but semantically invalid CCL generates appropriate errors**

The issue is specifically with **structurally invalid** input that doesn't match CCL format at all.

## Implementation Requirements

### 1. Enhanced Error Messages
Replace generic Angstrom errors with contextual information:

```ocaml
(* Proposed error enhancement approach *)
let key_val_with_errors prefix_len =
  let* key_result = many (not_char '=') in
  match key_result with
  | [] when at_end_of_input ->
      fail "Empty input - expected key-value pair"
  | key_chars ->
      let key = trim_key key_chars in
      let* _ = blank in
      let* has_equals = peek_char in
      match has_equals with
      | Some '=' ->
          let* _ = char '=' in
          (* Continue with normal parsing *)
          ...
      | None ->
          fail ("Missing '=' separator after key '" ^ key ^ "'")
      | Some c ->
          fail ("Expected '=' after key '" ^ key ^ "', found '" ^ String.make 1 c ^ "'")
```

### 2. Error Classification
Categorize different types of parsing failures:
- **Structure errors**: Missing separators, invalid format
- **Syntax errors**: Invalid characters, malformed values
- **Content errors**: Empty content, unexpected end of input

### 3. User-Friendly Messages
Provide actionable error information:
- **Location**: Which line or character position failed
- **Expected**: What the parser was looking for
- **Found**: What was actually encountered
- **Suggestion**: How to fix the problem

## Affected Tests

1. `just_key_error_parse` - expects specific error for key without value
2. `just_string_error_parse` - expects specific error for plain text
3. `multiline_plain_error_parse` - expects specific error for unstructured multiline

All currently fail with: `Parse error: : not enough input`

## Implementation Approach

### 1. Custom Error Types
```ocaml
type parse_error =
  | Missing_separator of string  (* key *)
  | Invalid_format of string     (* description *)
  | Unexpected_char of char * string (* char, context *)
  | Empty_input
  | Custom of string

let error_to_string = function
  | Missing_separator key ->
      Printf.sprintf "Missing '=' separator after key '%s'" key
  | Invalid_format desc ->
      Printf.sprintf "Invalid CCL format: %s" desc
  | Unexpected_char (c, ctx) ->
      Printf.sprintf "Unexpected character '%c' in %s" c ctx
  | Empty_input ->
      "Empty input - expected CCL key-value pairs"
  | Custom msg -> msg
```

### 2. Enhanced Parser Functions
Modify parsing functions to provide context-aware error messages instead of relying on generic Angstrom failures.

### 3. Error Recovery
Consider whether parser should attempt to recover from errors and continue parsing, or fail fast with detailed information.

## Demonstration

To reproduce the generic error issue:

```bash
# Build the project
opam exec -- dune build

# Test various malformed inputs
echo 'just_a_key' | opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test
echo 'key value' | opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test
echo -e 'line one\nline two' | opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test
```

All produce the same generic "not enough input" error.

## Impact Assessment

**Affected User Experience:**
- Difficult to debug CCL configuration files
- Generic errors provide no actionable information
- Increased development time for CCL adoption
- Poor first-time user experience

**Current Workarounds:**
- Manual inspection of input against CCL specification
- Trial-and-error debugging approach
- Use of external CCL validation tools

**Implementation Effort:** Medium - requires parsing logic changes but no architectural changes

## Priority Justification

**Low Priority** because:
- ✅ **Parser functional correctness** - correctly rejects invalid input
- ✅ **Workarounds exist** - manual debugging possible
- ❌ **User experience impact** - significant debugging difficulty
- ❌ **Quality expectation** - modern parsers provide contextual errors

## Expected Test Results

After improvement, the error tests should produce:
- `just_key_error_parse`: "Missing '=' separator after key 'just_a_key'"
- `just_string_error_parse`: "Invalid CCL format: no key-value pairs found"
- `multiline_plain_error_parse`: "Invalid CCL format: lines missing '=' separators"

## Environment

- **OCaml Version**: 5.3.0
- **Parser Library**: Angstrom
- **Test Suite**: ccl-test-data (official JSON test suite)
- **Implementation**: ccl-ocaml