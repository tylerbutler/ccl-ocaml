# Bug Report #003: Parser Error Handling for Malformed Inputs

**Date**: 2025-09-17
**Reporter**: Community Contributor
**Severity**: Low
**Component**: `lib/parser.ml` (Angstrom parser implementation)

## Summary

The parser currently fails with `not enough input` errors on certain malformed CCL inputs instead of providing more descriptive error messages. While these inputs may be invalid CCL, I believe better error handling could improve the user experience.

## Affected Tests

1. `just_key_error_parse` - Parse error: : not enough input
2. `just_string_error_parse` - Parse error: : not enough input
3. `multiline_plain_error_parse` - Parse error: : not enough input

All fail with: `Parse error: : not enough input`

## Reproduction

### Test Case 1: Just a Key
```ccl
Input: "just_a_key"
```

**Current Behavior**: `Parse error: : not enough input`
**Expected**: Perhaps a more descriptive error like "Missing '=' separator" or similar

### Test Case 2: Just a String
```ccl
Input: "just a string without structure"
```

**Current Behavior**: `Parse error: : not enough input`
**Expected**: Perhaps "Invalid CCL format: no key-value pairs found" or similar

### Test Case 3: Plain Multiline
```ccl
Input: "line one\nline two\nline three"
```

**Current Behavior**: `Parse error: : not enough input`
**Expected**: Perhaps "Invalid CCL format: missing '=' separators" or similar

## Analysis

### Current Parser Behavior

The parser expects the `key = value` pattern and appears to fail early when it doesn't find the expected structure. The error message `not enough input` suggests the parser is reaching an unexpected end state.

### Context from Working Tests

I notice that valid CCL with unusual patterns works fine:
- ✅ Empty keys: `= value` works
- ✅ Empty values: `key =` works
- ✅ Complex multiline with proper structure works

This suggests the parser correctly handles valid CCL edge cases but struggles with fundamentally malformed input.

## Error Handling Expectations

I understand these test cases might be testing the parser's error handling capabilities rather than reporting bugs. The test suite may expect specific error conditions for malformed inputs.

Looking at the test names (`*_error_*`), I suspect these are intentionally testing error scenarios rather than expecting successful parsing.

## Suggested Investigation

I respectfully suggest reviewing whether:

1. **Error Messages**: Could be more descriptive for better user experience
2. **Error Types**: Should distinguish between different kinds of parse failures
3. **Test Expectations**: Whether these tests expect specific error formats

## Implementation Context

The current parser in `lib/parser.ml` uses Angstrom and may be designed to fail fast on invalid input. I acknowledge that more detailed error handling might require significant changes to the parser logic.

## Environment

- **OCaml Version**: 5.3.0
- **Parser Library**: Angstrom
- **Test Suite**: ccl-test-data (official JSON test suite)
- **Implementation**: ccl-ocaml

## Additional Context

I recognize these might not be bugs at all, but rather test cases verifying that the parser correctly rejects invalid input. The "error" in the test names suggests this interpretation.

I would appreciate clarification on:
1. Whether these error handling behaviors are intentional
2. If more descriptive error messages would be beneficial
3. Whether the test expectations need adjustment

Thank you for your time and consideration. I apologize if this represents a misunderstanding of the intended behavior rather than an actual issue.