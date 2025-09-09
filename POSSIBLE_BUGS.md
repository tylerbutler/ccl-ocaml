# Possible Bugs in CCL OCaml Reference Implementation

This document tracks potential bugs and limitations in the OCaml reference implementation of CCL that may need attention.

## Round-trip Property Failure for Multiline Values

**Status**: Confirmed bug in pretty printer  
**Severity**: Medium (breaks round-trip property)  
**Test Cases**: `round_trip_multiline_values`, `round_trip_blog_example`

### Problem Description

The CCL blog post shows valid syntax for multiline values starting on the line after the key:

```ccl
story =
  Once upon a time, a Functional Programming enjoyer came up with an idea of
  the most elegant configuration language based on a single simple concept
```

However, this syntax fails the round-trip property (parse ∘ pretty ≠ id) in the current implementation.

### What Happens

1. ✅ **Input parses successfully** into correct data structure
2. ❌ **Pretty printer produces invalid syntax**: 
   ```ccl
   story =
     
     Once upon a time, a Functional Programming enjoyer came up with an idea of
     the most elegant configuration language based on a single simple concept =
   ```
   Note the trailing ` =` which makes this invalid CCL.
3. ❌ **Re-parsing the pretty-printed output fails**

### Root Cause

The issue is in `lib/model.ml` in the `fix_entry_map` function:

```ocaml
let normalise_entry = function
  | String v -> Fix (KeyMap.singleton v empty)  (* ← Problem here *)
```

Every string value gets converted to a nested key structure, causing the pretty printer to treat multiline content as a key and append ` =` to it.

### Workaround

Use the alternative syntax where multiline values start on the same line as the key:

```ccl
story = Once upon a time, a Functional Programming enjoyer came up with an idea of
  the most elegant configuration language based on a single simple concept
```

This syntax works correctly with round-trip parsing.

### Expected Behavior

The pretty printer should preserve the semantic structure and produce valid CCL that can be parsed back to the same data structure.

### Test Coverage

- `round_trip_multiline_values`: Tests with shell script example
- `round_trip_blog_example`: Tests with exact blog post example

Both tests demonstrate the same underlying issue with different content.