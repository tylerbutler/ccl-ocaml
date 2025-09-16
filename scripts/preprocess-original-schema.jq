# Progressive schema preprocessing for jsonschema2atd compatibility
# Takes the full original schema and removes only problematic constructs
# Preserves maximum schema fidelity while addressing jsonschema2atd issues #10, #11, #13

def remove_problematic_constructs:
  if type == "object" then
    # Remove only the constructs that break jsonschema2atd
    del(.allOf, .anyOf, .oneOf, .not, .if, .then, .else) |

    # Remove additionalProperties that can cause issues
    del(.additionalProperties) |

    # Remove validation constructs that aren't essential for type generation
    del(.minItems, .maxItems, .pattern, .minimum, .maximum) |

    # Fix union types - jsonschema2atd doesn't support ["object", "null"] syntax
    if .type and (.type | type == "array") then
      if (.type | contains(["object"])) then
        .type = "object"
      elif (.type | contains(["string"])) then
        .type = "string"
      elif (.type | contains(["array"])) then
        .type = "array"
      elif (.type | contains(["integer"])) then
        .type = "integer"
      else
        # Default to first non-null type
        .type = (.type | map(select(. != "null")) | .[0])
      end
    else
      .
    end |

    # Recursively process nested objects
    with_entries(.value |= remove_problematic_constructs)
  elif type == "array" then
    map(remove_problematic_constructs)
  else
    .
  end;

# Apply preprocessing
remove_problematic_constructs |

# Fix specific issues with the expected field structure
if .properties and .properties.tests then
  .properties.tests.items.properties.expected = {
    "description": "Expected test results with flexible structure"
  }
else
  .
end