# Bug Report #001: Parser Multiline Handling Incomplete

**Date**: 2025-09-17
**Severity**: Medium
**Component**: `lib/parser.ml` (Angstrom parser implementation)

## Summary

The CCL parser fails to handle specific multiline constructs mandated by the CCL specification, resulting in `end_of_input` errors for valid syntax. This represents incomplete implementation of the parsing logic rather than a design limitation.

## The Problem

CCL specification defines rules for empty keys and continuation lines that the current parser doesn't fully implement:

1. ✅ **Basic multiline parsing works** for properly indented continuations
2. ❌ **Empty key syntax fails** (lines starting with `=`)
3. ❌ **Lines without equals fail** (should become empty key entries)
4. ❌ **Complex mixed patterns fail** (combinations of above)

## Root Cause Analysis

The issue stems from incomplete implementation in the `key_val` function (`lib/parser.ml:57-63`):

```ocaml
let key_val prefix_len =
  let* key = many (not_char '=') >>| trim_key in  (* Requires non-empty key *)
  let* _ = blank in
  let* _ = char '=' in                            (* Requires '=' separator *)
  let* value = value_p prefix_len >>| trim_value in
  let* _ = blank in
  return { key; value }
```

### 1. Missing Empty Key Support

The parser expects `many (not_char '=')` to produce a non-empty key, but CCL allows empty keys:
- `= Section Header` should parse with `key=""`, `value="Section Header"`
- Current parser fails because it can't handle keys that start immediately with `=`

### 2. Missing No-Equals Support

The parser mandates `char '='` but CCL allows lines without equals:
- `second line` should parse with `key="second line"`, `value=""`
- Current parser fails because it requires the `=` separator

### 3. Incomplete Specification Implementation

The `nested_kvs_p` function (`lib/parser.ml:73-85`) only handles:
- End of input → return []
- Newline-prefixed → parse indented key-values
- Non-newline → parse single key-value

But doesn't account for the edge cases required by CCL specification.

## Reproduction Examples

### Test Case 1: Empty Key (Section Header)
```ccl
== Section Header =
  This continues the header
key = value
```

**Expected**:
- Entry 1: `{key="", value="= Section Header =\n  This continues the header"}`
- Entry 2: `{key="key", value="value"}`

**Observed**: `Parse_value error: : end_of_input`

**Why it fails**: `many (not_char '=')` on `== Section Header =` stops at first `=`, leaving `= Section Header =` unparsed

### Test Case 2: Line Without Equals
```ccl
descriptions = First line
second line
descriptions = Another item
```

**Expected**:
- Entry 1: `{key="descriptions", value="First line"}`
- Entry 2: `{key="second line", value=""}`
- Entry 3: `{key="descriptions", value="Another item"}`

**Observed**: `Parse_value error: : end_of_input`

**Why it fails**: `char '='` parser fails on `second line` because there's no `=` separator

## Working Examples (Evidence)

These cases work correctly, proving the core multiline logic exists:

✅ **Basic indented continuation**:
```ccl
key = value
  continuation line
```
Parses as: `{key="key", value="value\n  continuation line"}`

✅ **Empty values**:
```ccl
key =
```
Parses as: `{key="key", value=""}`

✅ **Simple multiline**:
```ccl
story = Once upon a time
  there was a configuration language
```
Parses as: `{key="story", value="Once upon a time\n  there was a configuration language"}`

## Required Implementation Changes

To fully support CCL specification, the parser needs:

### 1. Enhanced `key_val` Function
```ocaml
(* Proposed approach *)
let key_val prefix_len =
  let* line = take_till (char '\n') in
  match String.split_on_char '=' line with
  | [key_part] ->
      (* No '=' found - treat entire line as key with empty value *)
      return {key = String.trim key_part; value = ""}
  | key_part :: value_parts ->
      (* '=' found - split on first occurrence *)
      let key = String.trim key_part in
      let value = String.concat "=" value_parts |> String.trim in
      return {key; value}
  | [] -> fail "Empty line"
```

### 2. Empty Key Detection
Handle lines starting with `=` by:
- Recognizing `=` at line start as empty key indicator
- Treating remainder as value content
- Supporting continuation lines for empty key values

### 3. Specification Compliance
Ensure full implementation of CCL rules:
- **Empty keys**: Lines starting with `=`
- **No equals**: Lines without `=` become empty-value entries
- **Mixed patterns**: Combinations of above with proper indentation handling

## Affected Tests

1. `multiline_section_header_value_parse_value`
2. `unindented_multiline_becomes_continuation_parse_value`
3. `list_multiline_values_parse_value`
4. `complex_mixed_list_scenarios_parse_value`

All fail with: `Parse_value error: : end_of_input`

## Demonstration

To reproduce these issues:

```bash
# Build the project
opam exec -- dune build

# Test the failing cases
echo '== Section Header =' | opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test
echo -e 'descriptions = First line\nsecond line' | opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test
```

## Impact Assessment

**Affected Functionality:**
- Section headers and list-like structures
- Configuration files using CCL's full syntax capabilities
- Round-trip parsing for complex documents

**Workarounds:**
- Use explicit `key = value` format for all entries
- Avoid empty key syntax patterns
- Structure config files with simple key-value pairs only

**Priority:** Medium - blocks legitimate CCL syntax but workarounds exist

## Specification Reference

According to the CCL specification (https://chshersh.com/blog/2025-01-06-the-most-elegant-configuration-language.html):

> "Lines starting with `=` can represent list items or section headers"
> "Keys can be empty strings"
> "Indentation is significant for continuation"

## Environment

- **OCaml Version**: 5.3.0
- **Parser Library**: Angstrom
- **Test Suite**: ccl-test-data (official JSON test suite)
- **Implementation**: ccl-ocaml