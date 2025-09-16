# Minimal schema preprocessing for jsonschema2atd compatibility
# Creates a very basic schema that avoids all known problematic constructs
# References: ahrefs/jsonschema2atd issues #10, #11, #13
# Generates types that match existing OCaml code expectations

{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "array",
  "items": {
    "type": "object",
    "properties": {
      "name": {"type": "string"},
      "input": {"type": "string"},
      "validation": {
        "type": "string",
        "enum": [
          "parse", "parse_value", "filter", "compose", "expand_dotted",
          "build_hierarchy", "get_string", "get_int", "get_bool", "get_float", "get_list",
          "canonical_format", "load", "round_trip", "associativity"
        ]
      },
      "args": {
        "type": "array",
        "items": {"type": "string"}
      },
      "expected_count": {"type": "integer"},
      "expected_entries": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "key": {"type": "string"},
            "value": {"type": "string"}
          }
        }
      },
      "expected_value": {"type": "string"},
      "expected_list": {
        "type": "array",
        "items": {"type": "string"}
      }
    }
  }
}