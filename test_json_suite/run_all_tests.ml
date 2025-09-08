(* Cross-platform test runner for all JSON test files *)

let is_json_file filename =
  String.length filename > 5 && 
  String.sub filename (String.length filename - 5) 5 = ".json" &&
  filename <> "schema.json"

let run_test_file filename =
  Printf.printf "=== Running %s ===\n" filename;
  flush_all ();
  try
    let test_suite = Json_test_types.load_test_suite_from_file filename in
    let suite_result = Json_test_runner.execute_json_test_suite test_suite in
    Json_test_runner.print_suite_result suite_result;
    Printf.printf "\n";
    flush_all ();
    suite_result.failed_tests = 0
  with
  | exn -> 
    Printf.eprintf "Error running %s: %s\n" filename (Printexc.to_string exn);
    Printf.printf "\n";
    flush_all ();
    false

let run_directory_tests directory =
  try
    let files = Sys.readdir directory in
    let json_files = Array.to_list files 
                   |> List.filter is_json_file 
                   |> List.map (Filename.concat directory)
                   |> List.sort String.compare in
    
    if List.length json_files = 0 then (
      Printf.eprintf "No JSON test files found in directory: %s\n" directory;
      exit 1
    );
    
    Printf.printf "Found %d JSON test files in %s\n\n" (List.length json_files) directory;
    flush_all ();
    
    let results = List.map (fun file ->
      let success = run_test_file file in
      (Filename.basename file, success)
    ) json_files in
    
    (* Summary *)
    let total = List.length results in
    let passed = List.length (List.filter snd results) in
    let failed = total - passed in
    
    Printf.printf "=== OVERALL SUMMARY ===\n";
    Printf.printf "Test Suites: %d total | %d passed | %d failed\n" total passed failed;
    
    if failed > 0 then (
      Printf.printf "\nFailed suites:\n";
      List.iter (fun (name, success) ->
        if not success then Printf.printf "- %s\n" name
      ) results
    );
    
    exit (if failed = 0 then 0 else 1)
    
  with
  | Sys_error msg ->
    Printf.eprintf "Error reading directory %s: %s\n" directory msg;
    exit 1

let () =
  match Sys.argv with
  | [| _; "run-all"; directory |] ->
      run_directory_tests directory
  | _ -> 
    (* Delegate to existing functionality *)
    Json_test_runner.main ()