(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let loc = Loc.of_file ~path:(Fpath.v "file")

let%expect_test "to_string" =
  print_endline (Loc.to_string loc);
  [%expect {| File "file", line 1, characters 0-0: |}];
  print_endline (Loc.to_file_colon_line loc);
  [%expect {| file:1 |}];
  ()
;;

let%expect_test "path" =
  print_endline (Loc.path loc |> Fpath.to_string);
  [%expect {| file |}];
  ()
;;

let%expect_test "start_line" =
  print_s [%sexp (Loc.start_line loc : int)];
  [%expect {| 1 |}];
  ()
;;

let%expect_test "is_none" =
  print_s [%sexp (Loc.is_none loc : bool)];
  [%expect {| false |}];
  ()
;;

let%expect_test "range" =
  print_s [%sexp (Loc.range loc : Loc.Range.t)];
  [%expect
    {|
    ((start 0)
     (stop  0))
    |}];
  ()
;;

module _ = struct
  [@@@coverage off]
  [@@@alert "-deprecated"]

  module A = struct
    let of_file _ = failwith "scope error"
    let _ = of_file
  end

  (* With this code fragment, we can exercise the [ocamlmig] attributes located
     in the [Loc] deprecated API.

     Run: [ocamlmig migrate] to check. *)
  let _f ~file_cache ~path:p ~line =
    ignore (Loc.in_file ~path:p : Loc.t);
    ignore (Loc.in_file_line ~file_cache ~line : Loc.t);
    (* We test the migration in case the identifier [of_file] is already bound.
       We don't need to do this test, because this test is already included in
       the [ocamlmig] tests, but this is just for illustrative purposes. *)
    let open Loc in
    let open! A in
    ignore (in_file ~path:p : Loc.t);
    ignore (in_file_line ~file_cache ~line : Loc.t);
    ()
  ;;
end
