(* CLI Interface - Modern command-line interface using Cmdliner *)

open Cmdliner

(* CLI argument definitions *)

let test_files_arg =
  let doc = "JSON test files or directories to run (optional for --show-* commands)" in
  Arg.(value & pos_all string [] & info [] ~docv:"FILES" ~doc)

let capabilities_arg =
  let doc = "Enable specific capability (function:parse, feature:comments, behavior:strict_spacing)" in
  Arg.(value & opt_all string [] & info ["cap"; "capability"] ~docv:"CAP" ~doc)

let verbose_arg = 
  let doc = "Enable verbose output showing skipped tests" in
  Arg.(value & flag & info ["v"; "verbose"] ~doc)

let no_color_arg =
  let doc = "Disable colored output" in
  Arg.(value & flag & info ["no-color"] ~doc)

let show_capabilities_arg =
  let doc = "Show available capabilities and exit" in
  Arg.(value & flag & info ["show-capabilities"] ~doc)

let show_exclusions_arg =
  let doc = "Show excluded tests summary and exit" in
  Arg.(value & flag & info ["show-exclusions"] ~doc)

let config_file_arg =
  let doc = "Load capabilities from configuration file" in
  Arg.(value & opt (some file) None & info ["config"; "c"] ~docv:"FILE" ~doc)

let exclude_tests_arg =
  let doc = "Exclude tests by name (can be specified multiple times)" in
  Arg.(value & opt_all string [] & info ["exclude-test"; "exclude"] ~docv:"TEST_NAME" ~doc)

(* Main run command *)
let run_cmd =
  let doc = "Run CCL test files with capability-based filtering" in
  let man = [
    `S Manpage.s_description;
    `P "Execute CCL tests using flat test format with simple capability filtering. \
        Each test validates exactly one CCL function, making test execution predictable and fast.";
    `P "Test selection follows the implementation guide: run tests for implemented \
        functions, skip tests for unimplemented functions.";
    `S Manpage.s_examples;
    `P "Run all tests with default capabilities:";
    `P "  $(b,ccl-simple-test) tests/api-parsing.json";
    `P "";
    `P "Run tests with specific capabilities:";
    `P "  $(b,ccl-simple-test) --cap function:parse --cap feature:comments tests/";
    `P "";
    `P "Run with verbose output:";
    `P "  $(b,ccl-simple-test) -v tests/";
    `P "";
    `P "Show available capabilities:";
    `P "  $(b,ccl-simple-test) --show-capabilities";
    `P "";
    `P "Exclude specific tests by name:";
    `P "  $(b,ccl-simple-test) --exclude-test \"test_name_1\" --exclude-test \"test_name_2\" tests/";
    `S Manpage.s_bugs;
    `P "Report bugs at https://github.com/chshersh/ccl/issues";
  ] in
  let info = Cmd.info "ccl-simple-test" ~version:"0.1.0" ~doc ~man in
  Cmd.v info
    Term.(const Simple_test_runner.main $ test_files_arg $ capabilities_arg $
          verbose_arg $ no_color_arg $ show_capabilities_arg $ config_file_arg $ exclude_tests_arg $ show_exclusions_arg)

(* Capabilities command - standalone utility *)
let capabilities_cmd =
  let doc = "Show available CCL implementation capabilities" in
  let man = [
    `S Manpage.s_description;
    `P "Display the functions, features, and behaviors supported by the current CCL implementation.";
    `P "Use this to understand what capabilities can be specified with --cap flags.";
  ] in
  let info = Cmd.info "capabilities" ~doc ~man in
  Cmd.v info Term.(const Simple_test_runner.show_default_capabilities $ const ())

(* Version command *)
let version_cmd =
  let doc = "Show version information" in
  let info = Cmd.info "version" ~doc in
  Cmd.v info Term.(const (fun () -> print_endline "ccl-simple-test 0.1.0") $ const ())

(* Main command group *)
let main_cmd =
  let doc = "Simplified CCL test runner following the implementation guide" in
  let man = [
    `S Manpage.s_description;
    `P "A simplified test runner for CCL (Categorical Configuration Language) that \
        follows the flat test format described in the implementation guide.";
    `P "Each test validates exactly one CCL function, enabling simple capability-based \
        filtering and predictable test execution.";
    `S Manpage.s_commands;
    `P "Use $(b,ccl-simple-test COMMAND --help) for help on individual commands.";
    `S Manpage.s_bugs;
    `P "Report bugs at https://github.com/chshersh/ccl/issues";
  ] in
  let info = Cmd.info "ccl-simple-test" ~version:"0.1.0" ~doc ~man in
  Cmd.group info [run_cmd; capabilities_cmd; version_cmd]

(* Entry point for CLI *)
let run () = 
  exit (Cmd.eval main_cmd)