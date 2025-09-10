open Ccl

let test_file filename =
  Printf.printf "=== Testing %s ===\n" filename;
  
  match decode_file filename with
  | Error (`Parse_error msg) ->
    Printf.printf "❌ Parse error: %s\n\n" msg
  | Ok ccl ->
    Printf.printf "✅ Original file parsed successfully\n";
    
    let pretty_printed = Model.pretty ccl in
    Printf.printf "📄 Pretty-printed output:\n%s\n" pretty_printed;
    Printf.printf "📄 Pretty-printed output (escaped):\n%S\n" pretty_printed;
    
    match decode pretty_printed with
    | Error (`Parse_error msg) ->
      Printf.printf "❌ Round-trip FAILED: %s\n\n" msg
    | Ok ccl2 ->
      if Model.compare ccl ccl2 = 0 then
        Printf.printf "✅ Round-trip successful - data structures match\n\n"
      else
        Printf.printf "⚠️  Round-trip parsed but data structures differ\n\n"

let () =
  test_file "bug-demo/multiline_example.ccl";
  test_file "bug-demo/working_example.ccl"