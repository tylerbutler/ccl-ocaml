# CCL Pretty-Print Round-Trip Identity Bug

## Summary

The CCL pretty-printer cannot maintain the round-trip identity property (`parse ∘ pretty ≠ id`) for multiline values that start on the line after the key. This appears to be a fundamental limitation of the current pretty-printer implementation rather than a simple bug.

## The Problem

CCL supports valid syntax where multiline values start on the line after the key:

```ccl
story =
  Once upon a time, a Functional Programming enjoyer came up with an idea of
  the most elegant configuration language based on a single simple concept
```

However, this syntax fails the round-trip property:
1. ✅ **Input parses successfully** into correct data structure
2. ❌ **Pretty printer produces invalid syntax** with trailing ` =`
3. ❌ **Re-parsing the pretty-printed output fails**

## Root Cause Analysis

The issue stems from a fundamental mismatch between CCL's data model and the pretty-printer implementation:

### 1. Data Model Normalization (`lib/model.ml:26`)

```ocaml
let normalise_entry = function
  | String v -> Fix (KeyMap.singleton v empty)  (* String becomes a key! *)
  | Nested entry_map -> fix_entry_map entry_map
```

Every string value gets converted to a nested key structure where:
- The string content becomes a **key** in a KeyMap
- That key points to an **empty map**

### 2. Pretty-Printer Assumption (`lib/model.ml:58-59`)

```ocaml
Buffer.add_string buf key;
Buffer.add_string buf " =\n";  (* Always appends " =\n" *)
go (indent + 2) buf value
```

The pretty-printer assumes **every key has nested content** and:
- Always appends ` =\n` after every key
- Always recurses to print nested content
- Has no special case for terminal/leaf values

### 3. The Fundamental Problem

The pretty-printer **cannot distinguish** between:
- **Actual keys** that should have ` =` appended
- **String values that were normalized into keys** that should NOT have ` =` appended

When a multiline string gets normalized:
- `story` → becomes a key (correctly gets ` =\n`)  
- `Once upon a time...` → becomes a key (incorrectly gets ` =\n`)
- Empty map → prints nothing

Result: `Once upon a time... =\n` (invalid CCL syntax)

## Design Question

It's unclear whether the pretty-printer is **intended** to support round-trip identity for this multiline syntax. The current design suggests it may not be:

1. **Normalization is lossy**: Converting strings to keys loses information about their original form
2. **Pretty-printer is uniform**: It treats all keys identically, which is simpler but loses semantic distinctions  
3. **No metadata preservation**: The data model doesn't preserve information about original syntax forms

## Working Workaround

The alternative syntax where multiline values start on the same line as the key works correctly:

```ccl
story = Once upon a time, a Functional Programming enjoyer came up with an idea of
  the most elegant configuration language based on a single simple concept
```

This works because the entire multiline content is parsed as a single string value attached to the `story` key, avoiding the problematic normalization.

## Demonstration

Run the demonstration script to see the bug in action:

```bash
# First build the project
opam exec -- dune build

# Then run the demonstration from the project root
opam exec -- dune exec bug-demo/demonstrate_bug.exe
```

The script will show:
- `multiline_example.ccl`: Parses successfully but fails round-trip
- `working_example.ccl`: Parses successfully and maintains round-trip identity

## Possible Solutions

1. **Accept the limitation**: Document that this multiline syntax is valid for parsing but not preserved by pretty-printing
2. **Extend the data model**: Add metadata to distinguish original strings from nested structures
3. **Redesign pretty-printer**: Add logic to detect and handle terminal string values specially
4. **Parser restriction**: Make the problematic syntax a parse error to maintain round-trip guarantees

Each approach has trade-offs between complexity, backward compatibility, and semantic clarity.