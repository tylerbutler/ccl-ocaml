# Bug Report #001: Parser Multiline Handling Incomplete

**Date**: 2025-09-17
**Reporter**: Community Contributor
**Severity**: Medium
**Component**: `lib/parser.ml` (Angstrom parser implementation)

## Summary

The `parse_value` function appears to have limitations handling certain multiline CCL constructs that may be valid according to the CCL specification. I observe `end_of_input` errors on inputs that could be legitimate CCL syntax.

## Affected Tests

1. `multiline_section_header_value_parse_value`
2. `unindented_multiline_becomes_continuation_parse_value`
3. `list_multiline_values_parse_value`
4. `complex_mixed_list_scenarios_parse_value`

All fail with: `Parse_value error: : end_of_input`

## Reproduction

### Test Case 1: Section Header with Continuation
```ccl
== Section Header =
  This continues the header
key = value
```

**Expected Behavior** (per test suite):
- Entry 1: `key=""`, `value="= Section Header =\n  This continues the header"`
- Entry 2: `key="key"`, `value="value"`

**Observed**: `Parse_value error: : end_of_input`

### Test Case 2: Mixed List Structure
```ccl
descriptions = First line
second line
descriptions = Another item
```

**Expected Behavior** (per test suite):
- Entry 1: `key="descriptions"`, `value="First line"`
- Entry 2: `key="second line"`, `value=""` (line without `=`)
- Entry 3: `key="descriptions"`, `value="Another item"`

**Observed**: `Parse_value error: : end_of_input`

## Analysis

### Current Implementation Location
`lib/parser.ml`, function `nested_kvs_p` (lines 73-85):

The function handles three cases:
1. End of input → return []
2. Starts with newline → parse indented key-values
3. Starts with non-newline → parse single key-value

### Suspected Issue

The parser may not fully implement the CCL specification's rules for:
1. **Empty keys**: Lines starting with `=` creating empty key entries
2. **Lines without equals**: Should become empty key entries per spec
3. **Complex multiline structures**: Mixed indentation patterns

## Specification Reference

According to the CCL specification blog post (https://chshersh.com/blog/2025-01-06-the-most-elegant-configuration-language.html):

> "Lines starting with `=` can represent list items or section headers"

> "Keys can be empty strings"

> "Indentation is significant for continuation"
> - "Parser remembers first key's leading space count (N)"
> - "Lines with ≤ N leading spaces start a new key-value entry"
> - "Lines with > N leading spaces continue the previous value"

## Working Examples (Evidence)

These `parse_value` tests **do work**, suggesting the core multiline logic exists:
- ✅ `indented_key_parse_value`: `"  key = val"`
- ✅ `spaces_vs_tabs_continuation_parse_value`: Multiline with proper indentation

## Suggested Investigation Areas

I respectfully suggest investigating whether the `nested_kvs_p` function might benefit from:

1. **Empty key handling**: Logic for lines starting with `=`
2. **No-equals handling**: Processing lines without `=` as empty key entries
3. **Enhanced indentation logic**: Full implementation of the N-space continuation rule

## Environment

- **OCaml Version**: 5.3.0
- **Parser Library**: Angstrom
- **Test Suite**: ccl-test-data (official JSON test suite)
- **Implementation**: ccl-ocaml

## Additional Context

I acknowledge this could be a misunderstanding of the specification on our part. The test cases come from the official ccl-test-data repository, but I recognize they might represent edge cases or proposed features rather than core requirements.

I would greatly appreciate guidance on whether these parsing scenarios should be supported, or if the test expectations need clarification.

Thank you for your time and consideration.