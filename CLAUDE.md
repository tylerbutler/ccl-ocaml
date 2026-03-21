# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ccl-ocaml** is an OCaml implementation of CCL (Categorical Configuration Language), a minimalistic configuration language based on category theory principles. The primary development focus on this branch is the **JSON test suite runner** that enables comprehensive testing against the official CCL test suite.

## Key Commands

### Development Workflow
```bash
# Dependencies setup (first time)
opam switch create .
opam install alcotest qcheck qcheck-alcotest yojson cmdliner ocolor

# Core development
opam exec -- dune build          # Build project
opam exec -- dune test           # Run OCaml unit tests
```

### Test Runner Commands (Primary Development Area)
```bash
# Quick testing
just test-smart                  # Recommended: smart tests with feature skipping
just health-check               # Quick validation of core functionality
just test-working               # Run only tests that pass completely

# Development testing
just test-all                   # Full test suite (includes unimplemented features)
just test-api                   # API tests only
just test-property              # Property tests only
just test-file FILE             # Run specific test file

# Utilities
just stats                      # Show test suite statistics
just build                      # Build the test runner
just clean-build               # Clean and rebuild
just regenerate-types           # Regenerate OCaml types from JSON schema
```

### Direct Test Runner Usage
```bash
# Build and run test runner directly
opam exec -- dune build test_json_suite/simple_test_suite.exe
opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v ../ccl-test-data/generated_tests/api_comments.json

# Run with specific capabilities
opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test --cap function:parse --cap feature:comments ../ccl-test-data/generated_tests/
```

## Architecture Overview

### Core Modules
- **`lib/ccl.ml`** - Main CCL library interface
- **`lib/parser.ml`** - Angstrom-based CCL parser
- **`lib/model.ml`** - CCL model and operations
- **`test_json_suite/`** - JSON test suite runner (primary development focus)

### Test Runner Architecture
The test runner bridges OCaml implementation with the official language-agnostic JSON test suite:

**Key Components:**
- **`test_capabilities.ml`** - Configuration of implemented functions/features/behaviors
- **`simple_test_runner.ml`** - Core test execution engine with capability-based filtering
- **`cli_interface.ml`** - Cmdliner-based CLI interface
- **`ccl_test_types_t.ml`** - Type definitions for JSON test schema (manually maintained)
- **`ccl_test_types_j.ml`** - Yojson-based JSON deserialization (manually maintained)

**Capability System:**
- **Functions:** `parse`, `parse_indented`, `build_hierarchy`, `canonical_format`, `get_string`, `get_list`, `filter`, `round_trip`, `compose_associative`, `identity_left`, `identity_right`
- **Features:** `empty_keys`, `comments`, `whitespace`, `unicode`, `multiline`
- **Behaviors:** `crlf_preserve_literal`, `boolean_strict`, `tabs_as_whitespace`, `indent_spaces`, `list_coercion_enabled`, `array_order_lexicographic`, `toplevel_indent_strip`
- **Not supported:** `print` (ref impl only has canonical_format), `delimiter_prefer_spaced`, `indent_tabs`, `tabs_as_content`

### External Integration
- **../ccl-test-data/** - Official JSON test suite (876 tests across 18 files, sibling repo)
- Test runner automatically skips tests for unimplemented capabilities

## Development Patterns

### Adding New CCL Functions
1. Implement function in `lib/` (typically `model.ml` or `parser.ml`)
2. Add function name to `test_capabilities.ml` default_capabilities.functions
3. Update test mappings if needed
4. Test with `just test-smart` to verify capability-based filtering

### Test Runner Development
1. Modify test execution logic in `simple_test_runner.ml`
2. Update CLI interface in `cli_interface.ml` if needed
3. When the upstream schema changes, manually update `ccl_test_types_t.ml` + `.mli` (types) and `ccl_test_types_j.ml` + `.mli` (JSON parsing)
4. Test with `just health-check` for quick validation

### Updating Capabilities
Edit `test_json_suite/test_capabilities.ml`:
- **functions:** Add newly implemented CCL functions
- **features:** Add support for language features (comments, dotted_keys, etc.)
- **behaviors:** Configure runtime behavior settings

## Reference Implementation Notes

This is the **reference implementation** of CCL. When tests fail, determine whether it's a test tagging issue (file against ccl-test-data) rather than changing the implementation.
- `Model.pretty` is `canonical_format`, NOT `print` (structure-preserving print is a different function)
- Uses `Map.Make(String)` so all output is lexicographic order (`array_order_lexicographic`)
- Parser splits on all `=` signs (does not support `delimiter_prefer_spaced`)
- Known test data issues tracked in github.com/CatConfLang/ccl-test-data/issues

## Current Implementation Status

**Working:** Parsing, hierarchy construction, canonical format, get_string/get_list with path traversal, comment filtering, algebraic properties (round_trip, compose_associative, identity)
**Not Implemented:** get_int, get_bool, get_float, compose, load, print (structure-preserving), dotted keys

The test runner provides detailed capability-based filtering to run only tests for implemented features, enabling progressive development without breaking the workflow.