# CCL JSON Test Suite Runner

This directory contains a JSON test runner that allows the ccl-ocaml implementation to test against the standardized CCL test suite located in `../ccl-test-data/tests/`.

## Purpose

The JSON test runner bridges the gap between the manual OCaml tests in `../test/` and the language-agnostic JSON test format. This enables:

1. **Cross-implementation validation** - Ensure ccl-ocaml behaves consistently with other CCL implementations
2. **Comprehensive test coverage** - Access to 148 test cases vs ~45 manual tests
3. **Standardized testing** - Use the same test cases across Gleam, OCaml, and future implementations
4. **Enhanced edge case coverage** - Unicode support, complex whitespace handling, internationalization

## Architecture

### Core Components

- **`json_test_types.ml`** - Type definitions and JSON parsing for the CCL test schema
- **`ccl_api_mapping.ml`** - Maps JSON test validations to actual CCL library function calls
- **`json_test_runner.ml`** - Legacy test execution engine and OCaml test file generation
- **`enhanced_test_runner.ml`** - Enhanced partial validation execution engine (recommended)
- **`test_json_suite.ml`** - Main CLI entry point

### Design Patterns

**4-Level CCL Architecture Support:**
- Level 1: Entry parsing (`parse` validations)
- Level 2: Processing (`filter`, `compose`, `expand_dotted` validations) 
- Level 3: Object construction (`make_objects` validations)
- Level 4: Typed access (`get_string`, `get_int`, etc. validations)

**Validation Mapping:**
- JSON test cases contain `validations` object with expected outcomes
- Each validation type maps to specific CCL API calls
- Results compared against expected values or error conditions
- Detailed error reporting for mismatches

**Enhanced Execution Strategy:**
- **Partial Validation Execution** - Run implemented validations, skip unimplemented ones gracefully
- **Dependency Resolution** - Topological sorting for CCL validation dependencies
- **Execution Context Management** - Shared state between validations for data flow
- **Enhanced Reporting** - Color-coded output with validation-level granularity

## Setup and Dependencies

### Prerequisites

- **OCaml** (>= 4.14)
- **Dune** (>= 3.15) 
- **opam** for package management

### Required Dependencies

Add to your `dune-project`:

```dune
(yojson (and :with-test (>= 2.0.0)))
```

The test runner depends on:
- **yojson** - JSON parsing and manipulation
- **alcotest** - Test framework integration (already in project)
- **ccl** - The core CCL library being tested

### Build Instructions

```bash
# From the ccl-ocaml project root
cd ccl-ocaml

# Install dependencies (if not already installed)
opam install yojson alcotest qcheck qcheck-alcotest

# Build the JSON test suite runner
dune build test_json_suite/test_json_suite.exe

# Verify build
ls _build/default/test_json_suite/test_json_suite.exe
```

## Usage

### Command Line Interface

```bash
# Run tests directly from JSON file (legacy runner)
./test_json_suite.exe run <json_file>

# Run tests with enhanced partial validation execution 
./test_json_suite.exe run-enhanced <json_file>

# Run all JSON test files in a directory (cross-platform)
./test_json_suite.exe run-all <directory>

# Generate OCaml test file from JSON
./test_json_suite.exe generate <json_file> <output_file>

# Show usage help
./test_json_suite.exe
```

### Running Tests

```bash
# Build the test runner (from ccl-ocaml directory)
dune build test_json_suite/test_json_suite.exe

# Quick test - run all JSON test suites (legacy runner)
./_build/default/test_json_suite/test_json_suite.exe run-all ../ccl-test-data/tests

# Run individual test suites with enhanced partial validation (recommended)
./_build/default/test_json_suite/test_json_suite.exe run-enhanced ../ccl-test-data/tests/api-core-ccl-parsing.json
./_build/default/test_json_suite/test_json_suite.exe run-enhanced ../ccl-test-data/tests/api-experimental.json

# Run individual test suites (legacy runner)
./_build/default/test_json_suite/test_json_suite.exe run ../ccl-test-data/tests/essential-parsing.json
./_build/default/test_json_suite/test_json_suite.exe run ../ccl-test-data/tests/comprehensive-parsing.json

# Generate OCaml test files
./_build/default/test_json_suite/test_json_suite.exe generate ../ccl-test-data/tests/essential-parsing.json test_essential.ml
```

### Dune Integration

The `dune` file includes automatic test generation rules:

```dune
(rule
 (target test_essential_parsing.ml)
 (deps (glob_files ../../ccl-test-data/tests/essential-parsing.json))
 (action (run ./test_json_suite.exe generate essential-parsing.json %{target})))
```

### Directory Structure Requirements

The test runner expects this project structure:

```
ccl-ocaml/                    # Main project directory
├── test_json_suite/          # JSON test runner (this directory)
│   ├── test_json_suite.exe   # Built executable
│   └── ...
└── ../ccl-test-data/         # Test data repository (sibling directory)
    └── tests/                # JSON test files
        ├── essential-parsing.json
        ├── comprehensive-parsing.json
        └── ...
```

#### Latest Complete Test Results

Running all 148 tests across 10 test suites:

```
=== OVERALL SUMMARY ===
Test Suites: 10 total | 3 passed | 7 failed  
Individual Tests: 117 total | 104 passed | 13 failed (88.9% success)
```

**Perfect Suites (100% pass):** comments, dotted-keys, object-construction  
**Main Issues:** Whitespace handling, round-trip formatting, multi-entry parsing

## Test Coverage Mapping

See `../ccl-test-data/OCaml_Test_Mapping.md` for a comprehensive mapping between:
- Original OCaml test cases in `../test/`
- Equivalent JSON test cases in `../ccl-test-data/tests/`
- Coverage analysis showing 100% feature parity + additional edge cases

## Enhanced Test Runner

The enhanced test runner implements the **Partial Validation Execution** strategy recommended in the Test Runner Implementation Guide. This enables progressive CCL implementation development by running implemented functions while gracefully skipping unimplemented ones.

### Key Features

**Partial Validation Execution:**
- Tests can run **partially** - some validations execute, others skip gracefully
- No more "all-or-nothing" test failures due to unimplemented functions
- Supports incremental development of CCL implementations

**Intelligent Dependency Resolution:**
- Automatic topological sorting of CCL validation dependencies
- Ensures proper execution order: Parse → Filter → Compose → Make Objects → Typed Access
- Prevents dependency errors and enables data flow between validations

**Enhanced Reporting:**
- **Color-coded status indicators** for visual clarity
- **Validation-level granularity** showing exactly what passed/failed/skipped
- **Partial test tracking** with detailed breakdown of execution vs skip counts
- **Professional terminal output** with proper formatting

**Backward Compatibility:**
- Preserves existing CLI interface - legacy `run` command unchanged
- Type conversion layer between Enhanced and Legacy formats
- Seamless integration with existing test infrastructure

### Usage Examples

```bash
# Enhanced runner showing partial validation execution
./_build/default/test_json_suite/test_json_suite.exe run-enhanced ../ccl-test-data/tests/api-experimental.json

# Example output showing partial tests:
# Tests: 10 | 1 passed | 0 failed | 9 partial | 0 skipped
# - basic_dotted_key_expansion: 1/2 validations executed successfully
#   1 executed, 1 skipped (expand_dotted not implemented)
```

**Test Status Classification:**
- **Passed** - All validations executed and passed
- **Failed** - At least one validation failed  
- **Partial** - Some validations executed, others skipped
- **Skipped** - Entire test skipped due to configuration

### Architecture

The enhanced runner uses a modular architecture:

```ocaml
Enhanced module → Dependencies → ExecutionContext → PartialValidationEngine → EnhancedReporting
```

**Enhanced Module**: New type system with validation-level tracking
**Dependencies**: Topological sorting for CCL validation order
**ExecutionContext**: Shared state management between validations  
**PartialValidationEngine**: Core execution with graceful error handling
**EnhancedReporting**: Color-coded terminal output with detailed breakdowns

## Current Implementation Status

### ✅ Implemented Features
- JSON schema parsing with full validation support
- Level 1 parsing validation (entry parsing)
- Basic pretty printing validation
- Round-trip testing validation
- Command line interface
- Automatic test file generation
- Detailed error reporting
- **Enhanced partial validation execution engine**
- **Dependency resolution with topological sorting**
- **Color-coded terminal reporting**
- **Backward compatibility layer**

### 🚧 Partially Implemented
- Level 2 processing validations (filter, compose, expand_dotted)
- Level 3 object construction validation
- Level 4 typed access validation

### ⏳ Future Enhancements
- Associativity and algebraic property validation
- Enhanced error pattern matching
- Performance benchmarking integration
- Parallel test execution

## Error Handling

The test runner provides detailed error messages:

```
=== CCL Essential Parsing (Validation Format) ===
Total: 18 | Passed: 14 | Failed: 4

Failed tests:
- no_equals_continuation:
  * parse: Expected successful parse but got error: : end_of_input
- crlf_normalization:
  * parse: Parse mismatch: expected 2 entries, got 2 entries
```

## Extension Points

To add support for new validation types:

1. **Add type definition** in `json_test_types.ml`
2. **Add JSON parser** in the same file
3. **Add validation executor** in `ccl_api_mapping.ml`
4. **Wire into main executor** in the `execute_validation` function

## Dependencies

- **yojson** (>= 2.0.0) - JSON parsing and manipulation
- **alcotest** - Test framework integration  
- **ccl** - The core CCL library being tested

## Integration with Existing Tests

The JSON test runner is designed to complement, not replace, the existing OCaml tests:

- **Manual tests** (`../test/`) continue to provide property-based testing, stress testing, and OCaml-specific validations
- **JSON tests** add comprehensive edge case coverage and cross-language validation
- **Both suites** run in parallel to ensure complete test coverage

This dual approach provides the best of both worlds: manual OCaml-specific testing for library correctness and standardized JSON testing for cross-implementation consistency.