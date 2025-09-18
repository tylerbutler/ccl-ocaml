# CCL-OCaml Reports

This directory contains consolidated bug reports and analysis for the CCL-OCaml implementation.

## Report Summary

**Date**: 2025-09-17
**Test Results**: 9 failures out of 366 tests (281 passed, 76 skipped)
**Overall Pass Rate**: 96.9% of implemented features

## Bug Report Index

### BUG-001: Parser Multiline Handling Incomplete
- **Severity**: Medium
- **Component**: `lib/parser.ml` (Angstrom parser)
- **Tests Affected**: 4 tests
- **Issue**: `parse_value` fails on certain multiline constructs with `end_of_input` errors
- **Root Cause**: `nested_kvs_p` function may not fully implement CCL specification

### BUG-002: Missing Typed Access Functions
- **Severity**: Medium
- **Component**: `lib/model.ml` (CCL model and operations)
- **Tests Affected**: 5 tests
- **Issue**: Missing `get_int`, `get_bool`, `get_float` functions
- **Root Cause**: Unimplemented type conversion functions

### BUG-003: Parser Error Handling for Malformed Inputs
- **Severity**: Low
- **Component**: `lib/parser.ml` (Angstrom parser)
- **Tests Affected**: 3 tests
- **Issue**: Generic "not enough input" errors for malformed CCL
- **Root Cause**: Limited error message specificity

### BUG-004: Pretty-Print Round-Trip Identity Failure
- **Severity**: Critical (Design Issue)
- **Component**: `lib/model.ml` (Pretty-printer and data model)
- **Issue**: Cannot maintain round-trip identity for multiline values that start on line after key
- **Root Cause**: Fundamental mismatch between data model normalization and pretty-printer assumptions

## Root Cause Analysis

The identified issues group into 4 distinct categories:

1. **Parser Logic Gaps** (4 test failures): Core parsing logic incomplete for full CCL spec
2. **Missing Features** (5 test failures): Planned but unimplemented typed access functions
3. **Error Handling** (3 test failures): Limited error message quality for malformed inputs
4. **Design Issues** (1 architectural issue): Fundamental round-trip identity limitations

## Methodology

- **Test Suite**: Official ccl-test-data (452 assertions, 167 tests)
- **Reference**: CCL specification from https://chshersh.com/blog/2025-01-06-the-most-elegant-configuration-language.html
- **Analysis**: Comparison of failing tests against official specification
- **Validation**: Cross-referenced with working test cases to understand expected behavior

## Submission Notes

These reports are written with humility, acknowledging that:
- Test interpretations might be incorrect
- Implementation priorities may differ from test expectations
- Some failures might represent test issues rather than implementation bugs
- The maintainers have the authoritative understanding of CCL requirements

Each report includes:
- Specific reproduction cases
- References to official CCL specification
- Evidence from working test cases
- Respectful suggestions for investigation
- Clear acknowledgment of potential misunderstandings