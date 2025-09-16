# Schema preprocessing for jsonschema2atd compatibility
# Addresses known issues in ahrefs/jsonschema2atd GitHub repository:
# - Issues #10, #11, #13: Complex schema parsing problems
# - allOf/anyOf/oneOf constructs cause "Expected '{' but found" errors
# - Conditional logic (if/then/else) not supported
# - additionalProperties can cause parsing failures
#
# This preprocessor removes problematic constructs while preserving
# the essential type information needed for ATD generation

def simplify_schema:
  if type == "object" then
    # Remove complex schema constructs that jsonschema2atd can't handle
    del(.allOf, .anyOf, .oneOf, .not, .if, .then, .else, .additionalProperties) |

    # Handle conditional required fields by making them optional
    if has("required") and (.required | type == "array") then
      .required = (.required | map(select(. != "args")))
    else
      .
    end |

    # Recursively simplify nested objects
    with_entries(
      if .key == "properties" and (.value | type == "object") then
        .value |= with_entries(.value |= simplify_schema)
      else
        .value |= simplify_schema
      end
    )
  elif type == "array" then
    map(simplify_schema)
  else
    .
  end;

# Apply simplification and add missing properties
simplify_schema |

# Ensure required structure for test format
if has("properties") and has("properties") and .properties.tests then
  .properties.tests.items.properties.args = {
    "type": "array",
    "items": {"type": "string"},
    "description": "Optional arguments for typed access functions"
  } |
  .properties.tests.items.properties.expected = {
    "type": "object",
    "description": "Expected test results with flexible structure",
    "properties": {
      "count": {"type": "integer"},
      "entries": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "key": {"type": "string"},
            "value": {"type": "string"}
          }
        }
      },
      "value": {"description": "Expected value for typed access"},
      "list": {"type": "array", "description": "Expected list structure"},
      "error": {"type": "string", "description": "Expected error message"}
    }
  }
else
  .
end