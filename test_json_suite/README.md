# CCL JSON Test Suite Runner

This directory contains a simple JSON test runner that allows the ccl-ocaml implementation to test against the standardized CCL test suite located in `../ccl-test-data/generated_tests/`.

## Purpose

The JSON test runner bridges the gap between the manual OCaml tests in `../test/` and the language-agnostic JSON test format. This enables:

1. **Cross-implementation validation** - Ensure ccl-ocaml behaves consistently with other CCL implementations
2. **Comprehensive test coverage** - Access to 452 test assertions across 167 tests vs ~45 manual tests
3. **Standardized testing** - Use the same test cases across Gleam, OCaml, and future implementations
4. **Enhanced edge case coverage** - Unicode support, complex whitespace handling, internationalization

## Architecture

### Core Components

- **`ccl_test_types.atd`** - ATD type definitions for JSON test schema
- **`ccl_test_types_t.ml`** - Generated OCaml types from ATD
- **`ccl_test_types_j.ml`** - Generated JSON serialization from ATD  
- **`simple_test_runner.ml`** - Core test execution engine with capability-based filtering
- **`test_capabilities.ml`** - Capability detection and configuration system
- **`test_output.ml`** - Color-coded test result output and reporting
- **`cli_interface.ml`** - Modern CLI using Cmdliner for user-friendly interface
- **`simple_test_suite.ml`** - Main entry point executable

### Design Patterns

**Simple Capability-Based Testing:**
- **Feature-based filtering** - Tests tagged with `function:*`, `feature:*`, `behavior:*` capabilities
- **Progressive implementation** - Run only tests for implemented capabilities
- **Flat test format** - One test validates exactly one CCL function for predictability
- **Smart skipping** - Automatically skip tests for unimplemented features

**Modern Architecture:**
- **ATD-based types** - Generated type-safe JSON parsing from schema
- **Cmdliner CLI** - Professional command-line interface with help and validation
- **Color-coded output** - Visual test results with proper terminal formatting
- **Capability configuration** - Load capability sets from files or command line

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

### Quick Start with Just Commands

The easiest way to use the test runner is through the provided justfile commands:

```bash
# Recommended: Smart tests with feature skipping
just test-smart

# Quick health check of core functionality  
just health-check

# Run tests that currently pass completely
just test-working

# Run all tests (includes unimplemented features)
just test-all

# Show test suite statistics
just stats
```

### Direct Command Line Usage

```bash
# Build the test runner
just build

# Run tests with default capabilities
opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test ../ccl-test-data/generated_tests/api_comments.json

# Run with specific capabilities
opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test --cap function:parse --cap feature:comments ../ccl-test-data/generated_tests/

# Run with verbose output
opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v ../ccl-test-data/generated_tests/

# Show available capabilities
opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test --show-capabilities
```

### Directory Structure Requirements

The test runner expects this project structure:

```
ccl-ocaml/                      # Main project directory
├── test_json_suite/            # JSON test runner (this directory)
│   ├── simple_test_suite.exe   # Built executable (ccl-simple-test)
│   └── ...
└── ../ccl-test-data/           # Test data repository (sibling directory)
    └── generated_tests/        # JSON test files
        ├── api_comments.json
        ├── api_essential_parsing.json
        ├── property_algebraic.json
        └── ...
```

### Latest Test Results

Current implementation status using `just health-check`:

```
✅ Health check complete!
- Comments: Full support with 100% pass rate
- Algebraic properties: Core validation working
```

**Working Features:** Comment parsing, basic algebraic properties
**In Progress:** Full API parsing, object construction, typed access

## Test Coverage Mapping

See `../ccl-test-data/OCaml_Test_Mapping.md` for a comprehensive mapping between:
- Original OCaml test cases in `../test/`
- Equivalent JSON test cases in `../ccl-test-data/tests/`
- Coverage analysis showing 100% feature parity + additional edge cases

## Current Implementation Features

The current simple test runner provides:

**Capability-Based Testing:**
- **Smart filtering** - Run only tests for implemented capabilities
- **Progressive development** - Add capabilities incrementally as features are implemented
- **Clear skipping** - Verbose output shows exactly what's skipped and why
- **Configuration support** - Load capability sets from files

**Modern CLI:**
- **Cmdliner interface** - Professional help, validation, and error messages
- **Color-coded output** - Visual test status with proper terminal formatting
- **Flexible input** - Run single files, directories, or filtered test sets
- **Just integration** - Convenient just commands for common workflows

**Type Safety:**
- **ATD-generated types** - Type-safe JSON parsing from schema definitions
- **Compile-time validation** - Catch schema mismatches at build time
- **Maintainable code** - Clear separation between types, parsing, and logic

## Current Implementation Status

### ✅ Implemented Features
- **ATD-based type system** with generated OCaml types and JSON serialization
- **Capability-based test filtering** with feature tags
- **Modern CLI interface** using Cmdliner with help and validation
- **Color-coded test output** with proper terminal formatting
- **Smart test skipping** for unimplemented features
- **Just integration** with convenient workflow commands
- **Comment parsing** validation (100% working)
- **Basic algebraic properties** validation

### 🚧 In Progress
- **API parsing** validations (essential parsing features)
- **Object construction** validation
- **Typed access** validation (get_string, get_int, etc.)
- **Advanced features** (dotted keys, processing operations)

### ⏳ Future Enhancements
- **Complete API coverage** for all CCL functions
- **Performance benchmarking** integration
- **Enhanced error reporting** with detailed context
- **Configuration file** support for persistent capability sets

## Dependencies

- **ccl** - The core CCL library being tested
- **cmdliner** - Modern CLI interface with help and validation
- **ocolor** - Terminal color output support
- **yojson** - JSON parsing and manipulation  
- **alcotest** - Test framework integration
- **atdgen-runtime** - ATD runtime for generated types
- **unix** - System utilities

## Integration with Project

The JSON test runner complements the existing test infrastructure:

- **Manual tests** (`../test/`) provide property-based testing and OCaml-specific validation
- **JSON tests** provide standardized cross-implementation testing with comprehensive edge cases
- **Just commands** provide convenient workflow integration for development
- **Capability system** enables progressive implementation without breaking the workflow

This approach allows incremental development while maintaining compatibility with the broader CCL testing ecosystem.