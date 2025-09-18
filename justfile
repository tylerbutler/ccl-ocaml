# OCaml CCL JSON Test Suite
# Convenient tasks for running the enhanced JSON test suite

# Default recipe lists available tasks
default:
    @just --list

# Initialize dependencies (run once for new setup)
deps:
    @echo "🔧 Initializing OCaml dependencies..."
    @echo "📦 Creating opam switch..."
    opam switch create . --deps-only -y
    @echo "📚 Installing project dependencies..."
    opam install . --deps-only -y
    @echo "🛠️ Installing additional dev dependencies..."
    opam install utop ocamlformat ocaml-lsp-server -y
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
regenerate-types:
    @echo "🔄 Regenerating OCaml types from JSON schema..."
    @echo "  🛠️ Preprocessing original schema (addresses jsonschema2atd issues #10, #11, #13)..."
    jq -f scripts/preprocess-original-schema.jq ../ccl-test-data/schemas/generated-format.json > test_json_suite/preprocessed_schema.json
    @echo "  📄 Converting preprocessed schema to ATD..."
    opam exec -- jsonschema2atd test_json_suite/preprocessed_schema.json > test_json_suite/ccl_test_types.atd
    @echo "  🔧 Post-processing ATD to simplify type names and structure..."
    sd 'cCLTestCurrentFlatFormatTests' 'test_case' test_json_suite/ccl_test_types.atd
    sd 'cCLTestCurrentFlatFormatTestsValidation' 'validation_type' test_json_suite/ccl_test_types.atd
    sd 'cCLTestCurrentFlatFormat' 'test_suite' test_json_suite/ccl_test_types.atd
    sd '\(\*-flat\.json\)' '(star-flat.json)' test_json_suite/ccl_test_types.atd
    echo '' >> test_json_suite/ccl_test_types.atd
    echo 'type root = test_case list' >> test_json_suite/ccl_test_types.atd
    @echo "  🏗️ Generating OCaml types..."
    opam exec -- atdgen -t test_json_suite/ccl_test_types.atd
    @echo "  📦 Generating JSON serialization..."
    opam exec -- atdgen -j test_json_suite/ccl_test_types.atd
    @echo "  🔨 Building with new types..."
    opam exec -- dune build
    @echo "  🧹 Cleaning up temporary files..."
    rm -f test_json_suite/preprocessed_schema.json
    @echo "✅ Type regeneration complete!"

# Generate OCaml test code from a JSON file (advanced usage)
generate INPUT OUTPUT:
    @echo "🔧 Generating OCaml test code..."
    opam exec -- dune exec test_json_suite/simple_test_suite.exe -- generate {{INPUT}} {{OUTPUT}}

# Show usage help
help:
    @echo "OCaml CCL JSON Test Suite"
    @echo "========================="
    @echo ""
    @echo "Setup (run once):"
    @echo "  just deps            # Initialize opam switch and install dependencies"
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