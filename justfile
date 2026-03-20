# OCaml CCL JSON Test Suite
# Convenient tasks for running the enhanced JSON test suite

# Default recipe lists available tasks
default:
    @just --list

# Create opam switch (run once for new setup)
switch:
    @echo "📦 Creating opam switch..."
    opam switch create . --deps-only -y

# Install project dependencies from opam file
install-deps:
    @echo "📚 Installing project dependencies..."
    opam install . --deps-only --with-test -y

# Install development tools (optional)
install-dev-tools:
    @echo "🛠️ Installing development tools..."
    opam install utop ocamlformat ocaml-lsp-server -y

# Install dependencies only (most common case)
deps: install-deps
    @echo "✅ Project dependencies installed!"

# Full dependency initialization (combines all steps)
deps-init: switch install-deps install-dev-tools
    @echo "✅ Dependencies initialized successfully!"
    @echo ""
    @echo "Next steps:"
    @echo "  just build           # Build the project"
    @echo "  just test-smart      # Run tests"

# Build the test suite
build:
    opam exec -- dune build

# Run smart tests (recommended) - skips known unimplemented features
test-smart:
    @echo "🚀 Running smart tests with intelligent skipping..."
    opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v ../ccl-test-data/generated_tests

# Run all tests with categorization - shows everything including optional features
test-all:
    @echo "📊 Running all tests with full categorization..."
    opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v ../ccl-test-data/generated_tests

# Run tests without categorization (legacy mode)
test-legacy:
    @echo "📋 Running tests in legacy mode..."
    opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v ../ccl-test-data/generated_tests

# Run a specific test file
test-file FILE:
    @echo "🎯 Running single test file: {{FILE}}"
    opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v {{FILE}}

# Run only working tests (comments and algebraic properties)
test-working:
    @echo "✅ Running only tests that pass completely..."
    @opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v ../ccl-test-data/generated_tests/api_comments.json
    @opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v ../ccl-test-data/generated_tests/property_algebraic.json

# Run only API tests
test-api:
    @echo "🔧 Running API tests..."
    @for file in ../ccl-test-data/generated_tests/api_*.json; do \
        echo "Running $$(basename $$file)..."; \
        opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v "$$file" || true; \
    done

# Run only property tests
test-property:
    @echo "🧮 Running property tests..."
    @for file in ../ccl-test-data/generated_tests/property_*.json; do \
        echo "Running $$(basename $$file)..."; \
        opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v "$$file" || true; \
    done

# Run tests for a specific feature (e.g., just test-feature dotted-keys)
test-feature FEATURE:
    @echo "🎪 Running tests for feature: {{FEATURE}}"
    @for file in ../ccl-test-data/generated_tests/*{{FEATURE}}*.json; do \
        if [ -f "$$file" ]; then \
            echo "Running $$(basename $$file)..."; \
            opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v "$$file" || true; \
        fi \
    done

# Quick health check - run only tests that should pass
health-check:
    @echo "🏥 Running health check (core working features only)..."
    @echo "Testing comments..."
    @opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v ../ccl-test-data/generated_tests/api_comments.json
    @echo "Testing algebraic properties..."
    @opam exec -- dune exec test_json_suite/simple_test_suite.exe -- ccl-simple-test -v ../ccl-test-data/generated_tests/property_algebraic.json
    @echo "✅ Health check complete!"

# Show test suite statistics
stats:
    @echo "📈 Test Suite Statistics:"
    @echo "Available test files:"
    @ls -1 ../ccl-test-data/generated_tests/*.json | wc -l | xargs echo "  Total files:"
    @ls -1 ../ccl-test-data/generated_tests/api_*.json | wc -l | xargs echo "  API tests:"
    @ls -1 ../ccl-test-data/generated_tests/property_*.json | wc -l | xargs echo "  Property tests:"
    @echo ""
    @echo "Test files by category:"
    @ls -1 ../ccl-test-data/generated_tests/api_*.json | sed 's/.*api_/  - /' | sed 's/.json//'
    @echo "Property tests:"
    @ls -1 ../ccl-test-data/generated_tests/property_*.json | sed 's/.*property_/  - /' | sed 's/.json//'

# Clean and rebuild
clean-build:
    @echo "🧹 Cleaning and rebuilding..."
    opam exec -- dune clean
    opam exec -- dune build

# Regenerate OCaml types from JSON schema
# Note: Types are now maintained manually in ccl_test_types_t.ml and ccl_test_types_j.ml
# (replaced atdgen-generated code with direct Yojson parsing for maintainability).
# When the schema changes, update:
#   1. test_json_suite/ccl_test_types_t.ml and ccl_test_types_t.mli (type definitions)
#   2. test_json_suite/ccl_test_types_j.ml and ccl_test_types_j.mli (JSON parsing)
#   3. test_json_suite/simple_test_runner.ml (validation execution)
#   4. test_json_suite/test_capabilities.ml (capability configuration)
regenerate-types:
    @echo "Note: Types are now maintained manually. See justfile for update instructions."
    @echo "Schema location: ../ccl-test-data/schemas/generated-format.json"
    @echo "Building to verify types..."
    opam exec -- dune build
    @echo "Build successful!"

# Generate OCaml test code from a JSON file (advanced usage)
generate INPUT OUTPUT:
    @echo "🔧 Generating OCaml test code..."
    opam exec -- dune exec test_json_suite/simple_test_suite.exe -- generate {{INPUT}} {{OUTPUT}}

# Show usage help
help:
    @echo "OCaml CCL JSON Test Suite"
    @echo "========================="
    @echo ""
    @echo "Setup:"
    @echo "  just deps            # Install dependencies (most common)"
    @echo "  just deps-init       # Full setup: create switch + install all dependencies"
    @echo "  just switch          # Create opam switch only"
    @echo ""
    @echo "Quick start:"
    @echo "  just test-smart      # Recommended: smart tests with feature skipping"
    @echo "  just health-check    # Quick validation of core functionality"
    @echo "  just test-working    # Run only tests that pass completely"
    @echo ""
    @echo "Development:"
    @echo "  just test-all        # Full test suite (includes unimplemented features)"
    @echo "  just test-api        # API tests only"
    @echo "  just test-property   # Property tests only"
    @echo ""
    @echo "Advanced:"
    @echo "  just test-file FILE              # Run specific test file"
    @echo "  just test-feature FEATURE        # Run tests for specific feature"
    @echo "  just generate INPUT OUTPUT       # Generate OCaml code from JSON"
    @echo ""
    @echo "Utilities:"
    @echo "  just stats               # Show test suite statistics"
    @echo "  just build               # Build the test runner"
    @echo "  just clean-build         # Clean and rebuild"
    @echo "  just regenerate-types    # Regenerate OCaml types from JSON schema"

# Alias for the most common command
alias t := test-smart
alias test := test-smart
alias h := health-check
alias s := stats