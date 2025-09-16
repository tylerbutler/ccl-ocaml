(* Simple Test Suite - Main entry point for the simplified CCL test runner *)

(* This is the main entry point that connects all the modules together *)

let () = 
  (* Run the CLI interface which will dispatch to the appropriate test runner functions *)
  Cli_interface.run ()