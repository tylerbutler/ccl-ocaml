(* Test Output - Clean terminal formatting with OColor *)

open Ocolor_format

(* Global color control *)
let use_colors = ref true

let disable_colors () = 
  use_colors := false

let enable_colors () = 
  use_colors := true

(* Initialize color support based on terminal detection *)
let init_colors no_color_flag =
  if no_color_flag || not (Unix.isatty Unix.stdout) then
    disable_colors ()
  else
    enable_colors ()

(* Status message formatters *)
let success_msg ?(prefix="✓") msg = 
  if !use_colors then
    printf "@{<bold>@{<green>%s@}@} %s@." prefix msg
  else
    printf "%s %s\n" prefix msg

let error_msg ?(prefix="✗") msg =
  if !use_colors then  
    printf "@{<bold>@{<red>%s@}@} %s@." prefix msg
  else
    printf "%s %s\n" prefix msg

let info_msg ?(prefix="ℹ") msg =
  if !use_colors then
    printf "@{<bold>@{<cyan>%s@}@} %s@." prefix msg
  else
    printf "%s %s\n" prefix msg

let warning_msg ?(prefix="⚠") msg =
  if !use_colors then
    printf "@{<bold>@{<yellow>%s@}@} %s@." prefix msg
  else
    printf "%s %s\n" prefix msg

let debug_msg ?(prefix="🐛") msg =
  if !use_colors then
    printf "@{<dim>%s %s@." prefix msg
  else
    printf "%s %s\n" prefix msg

(* Section and structural formatting *)
let section_header title =
  if !use_colors then
    printf "\n@{<bold>@{<blue>=== %s ===%s@}@}\n" title ""
  else
    printf "\n=== %s ===\n" title

let subsection_header title =
  if !use_colors then
    printf "\n@{<bold>%s@}\n" title
  else
    printf "\n%s\n" title

let separator () =
  if !use_colors then
    printf "@{<dim>%s@}\n" (String.make 50 '-')
  else
    printf "%s\n" (String.make 50 '-')

(* Test result specific formatting *)
let test_passed_msg test_name =
  success_msg ~prefix:"✓" test_name

let test_failed_msg test_name err_msg =
  error_msg ~prefix:"✗" (test_name ^ ": " ^ err_msg)

let test_skipped_msg test_name reason =
  warning_msg ~prefix:"⚪" (test_name ^ ": " ^ reason)

(* Summary formatting *)
let test_summary ~total ~passed ~failed ~skipped =
  let status_indicator = 
    if failed = 0 then "✓" else "✗" 
  in
  let status_color = 
    if failed = 0 then "green" else "red" 
  in
  
  printf "\n";
  if !use_colors then
    printf "@{<bold>%s Summary:@} %d total | @{<green>%d passed@} | @{<%s>%d failed@} | @{<yellow>%d skipped@}\n"
      status_indicator total passed status_color failed skipped
  else
    printf "%s Summary: %d total | %d passed | %d failed | %d skipped\n"
      status_indicator total passed failed skipped

let capabilities_summary caps =
  section_header "Implementation Capabilities";
  if !use_colors then (
    printf "@{<bold>Functions:@} @{<green>%s@}\n" (String.concat ", " caps.Test_capabilities.functions);
    printf "@{<bold>Features:@} @{<cyan>%s@}\n" (String.concat ", " caps.Test_capabilities.features);
    printf "@{<bold>Behaviors:@} @{<yellow>%s@}\n" (String.concat ", " caps.Test_capabilities.behaviors)
  ) else (
    printf "Functions: %s\n" (String.concat ", " caps.Test_capabilities.functions);
    printf "Features: %s\n" (String.concat ", " caps.Test_capabilities.features);
    printf "Behaviors: %s\n" (String.concat ", " caps.Test_capabilities.behaviors)
  )

(* Progress indicators for long operations *)
let progress_start msg =
  if !use_colors then
    printf "@{<bold>@{<cyan>⏳@}@} %s..." msg
  else
    printf "⏳ %s..." msg;
  flush stdout

let progress_done () =
  if !use_colors then
    printf " @{<bold>@{<green>done@}@}\n"
  else
    printf " done\n";
  flush stdout

let progress_failed error =
  if !use_colors then
    printf " @{<bold>@{<red>failed@}@}: %s\n" error
  else
    printf " failed: %s\n" error;
  flush stdout

(* File and suite formatting *)
let file_header filename =
  if !use_colors then
    printf "\n@{<bold>📄 %s@}\n" filename
  else
    printf "\n📄 %s\n" filename

let suite_header suite_name =
  if !use_colors then
    printf "@{<bold>@{<blue>%s@}@}\n" suite_name
  else
    printf "%s\n" suite_name

(* Error details formatting *)
let error_details_header () =
  subsection_header "Error Details"

let error_detail test_name validation_name error_msg =
  if !use_colors then
    printf "  @{<red>•@} @{<bold>%s@} (%s): %s\n" test_name validation_name error_msg
  else
    printf "  • %s (%s): %s\n" test_name validation_name error_msg

(* Capability filtering information *)
let filtering_info total_tests runnable_tests skipped_tests =
  if !use_colors then
    printf "Test filtering: @{<cyan>%d@} total → @{<green>%d@} runnable, @{<yellow>%d@} skipped\n" 
      total_tests runnable_tests skipped_tests
  else
    printf "Test filtering: %d total → %d runnable, %d skipped\n" 
      total_tests runnable_tests skipped_tests

(* Configuration display block *)
let configuration_block caps variant behaviors =
  let border = String.make 60 '=' in
  if !use_colors then (
    printf "@{<bold>@{<blue>%s@}@}\n" border;
    printf "@{<bold>@{<blue>🎯 CCL TEST RUNNER CONFIGURATION@}@}\n";
    printf "@{<bold>@{<blue>%s@}@}\n" border;
    printf "@{<bold>Functions (enabled):@} @{<green>%s@}\n" (String.concat ", " caps.Test_capabilities.functions);
    printf "@{<bold>Features (enabled):@} @{<cyan>%s@}\n" (String.concat ", " caps.Test_capabilities.features);
    printf "@{<bold>Behaviors (enabled):@} @{<yellow>%s@}\n" (String.concat ", " caps.Test_capabilities.behaviors);
    printf "@{<bold>Variant chosen:@} @{<magenta>%s@}\n" variant;
    printf "@{<bold>Behavior mode:@} @{<magenta>%s@}\n" behaviors;
    printf "@{<bold>@{<blue>%s@}@}\n" border
  ) else (
    printf "%s\n" border;
    printf "🎯 CCL TEST RUNNER CONFIGURATION\n";
    printf "%s\n" border;
    printf "Functions (enabled): %s\n" (String.concat ", " caps.Test_capabilities.functions);
    printf "Features (enabled): %s\n" (String.concat ", " caps.Test_capabilities.features);
    printf "Behaviors (enabled): %s\n" (String.concat ", " caps.Test_capabilities.behaviors);
    printf "Variant chosen: %s\n" variant;
    printf "Behavior mode: %s\n" behaviors;
    printf "%s\n" border
  )

(* Skipped assertions summary for a test suite *)
let skipped_assertions_summary file_name skipped_results =
  if List.length skipped_results > 0 then (
    subsection_header ("Skipped Assertions: " ^ file_name);
    List.iter (fun (test_name, reason) ->
      if !use_colors then
        printf "  @{<yellow>⚪@} @{<bold>%s@}: %s\n" test_name reason
      else
        printf "  ⚪ %s: %s\n" test_name reason
    ) skipped_results
  )

(* Exit status formatting *)
let final_result_msg success =
  printf "\n";
  if success then
    success_msg ~prefix:"🎉" "All tests passed!"
  else
    error_msg ~prefix:"💥" "Some tests failed"