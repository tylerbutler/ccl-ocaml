# OCaml CCL JSON Test Suite
# Convenient tasks for running the enhanced JSON test suite

# Default recipe lists available tasks
default:
    @just --list

# Build the test suite
build:
    opam exec -- dune build

# Run smart tests (recommended) - skips known unimplemented features
test-smart:
    @echo "🚀 Running smart tests with intelligent skipping..."
    opam exec -- dune exec test_json_suite/test_json_suite.exe -- run-smart ../ccl-test-data/tests/

# Run all tests with categorization - shows everything including optional features
test-all:
    @echo "📊 Running all tests with full categorization..."
    opam exec -- dune exec test_json_suite/test_json_suite.exe -- run-categorized ../ccl-test-data/tests/

# Run tests without categorization (legacy mode)
test-legacy:
    @echo "📋 Running tests in legacy mode..."
    opam exec -- dune exec test_json_suite/test_json_suite.exe -- run-all ../ccl-test-data/tests/

# Run a specific test file
test-file FILE:
    @echo "🎯 Running single test file: {{FILE}}"
    opam exec -- dune exec test_json_suite/test_json_suite.exe -- run {{FILE}}

# Run only working tests (comments and algebraic properties)
test-working:
    @echo "✅ Running only tests that pass completely..."
    @opam exec -- dune exec test_json_suite/test_json_suite.exe -- run ../ccl-test-data/tests/api-comments.json
    @opam exec -- dune exec test_json_suite/test_json_suite.exe -- run ../ccl-test-data/tests/property-algebraic.json

# Run only API tests
test-api:
    @echo "🔧 Running API tests..."
    @for file in ../ccl-test-data/tests/api-*.json; do \
        echo "Running $$(basename $$file)..."; \
        opam exec -- dune exec test_json_suite/test_json_suite.exe -- run "$$file" || true; \
    done

# Run only property tests  
test-property:
    @echo "🧮 Running property tests..."
    @for file in ../ccl-test-data/tests/property-*.json; do \
        echo "Running $$(basename $$file)..."; \
        opam exec -- dune exec test_json_suite/test_json_suite.exe -- run "$$file" || true; \
    done

# Run tests for a specific feature (e.g., just test-feature dotted-keys)
test-feature FEATURE:
    @echo "🎪 Running tests for feature: {{FEATURE}}"
    @for file in ../ccl-test-data/tests/*{{FEATURE}}*.json; do \
        if [ -f "$$file" ]; then \
            echo "Running $$(basename $$file)..."; \
            opam exec -- dune exec test_json_suite/test_json_suite.exe -- run "$$file" || true; \
        fi \
    done

# Quick health check - run only tests that should pass
health-check:
    @echo "🏥 Running health check (core working features only)..."
    @echo "Testing comments..."
    @opam exec -- dune exec test_json_suite/test_json_suite.exe -- run ../ccl-test-data/tests/api-comments.json
    @echo "Testing algebraic properties..."
    @opam exec -- dune exec test_json_suite/test_json_suite.exe -- run ../ccl-test-data/tests/property-algebraic.json
    @echo "✅ Health check complete!"

# Show test suite statistics
stats:
    @echo "📈 Test Suite Statistics:"
    @echo "Available test files:"
    @ls -1 ../ccl-test-data/tests/*.json | wc -l | xargs echo "  Total files:"
    @ls -1 ../ccl-test-data/tests/api-*.json | wc -l | xargs echo "  API tests:"
    @ls -1 ../ccl-test-data/tests/property-*.json | wc -l | xargs echo "  Property tests:"
    @echo ""
    @echo "Test files by category:"
    @ls -1 ../ccl-test-data/tests/api-*.json | sed 's/.*api-/  - /' | sed 's/.json//'
    @echo "Property tests:"
    @ls -1 ../ccl-test-data/tests/property-*.json | sed 's/.*property-/  - /' | sed 's/.json//'

# Clean and rebuild
clean-build:
    @echo "🧹 Cleaning and rebuilding..."
    opam exec -- dune clean
    opam exec -- dune build

# Generate OCaml test code from a JSON file (advanced usage)
generate INPUT OUTPUT:
    @echo "🔧 Generating OCaml test code..."
    opam exec -- dune exec test_json_suite/test_json_suite.exe -- generate {{INPUT}} {{OUTPUT}}

# Show usage help
help:
    @echo "OCaml CCL JSON Test Suite"
    @echo "========================="
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
    @echo "  just stats           # Show test suite statistics"
    @echo "  just build           # Build the test runner"
    @echo "  just clean-build     # Clean and rebuild"

# Alias for the most common command
alias t := test-smart
alias test := test-smart
alias h := health-check
alias s := stats