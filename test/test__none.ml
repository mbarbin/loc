(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "is_none" =
  print_s [%sexp (Loc.is_none Loc.none : bool)];
  [%expect {| true |}];
  print_s [%sexp (Loc.is_none (Loc.of_position [%here]) : bool)];
  [%expect {| false |}];
  ()
;;

let%expect_test "equal" =
  print_s [%sexp (Loc.equal Loc.none Loc.none : bool)];
  [%expect {| true |}];
  ()
;;

let%expect_test "to_string" =
  print_endline (Loc.to_string Loc.none);
  [%expect {| File "<none>", line 1, characters 0-0: |}];
  print_endline (Loc.to_file_colon_line Loc.none);
  [%expect {| <none>:1 |}];
  ()
;;

let%expect_test "path" =
  print_endline (Loc.path Loc.none |> Fpath.to_string);
  [%expect {| <none> |}];
  ()
;;

let%expect_test "start_line" =
  print_s [%sexp (Loc.start_line Loc.none : int)];
  [%expect {| 1 |}];
  ()
;;

let%expect_test "offsets" =
  print_s
    [%sexp
      { start_offset = (Loc.start_offset Loc.none : int)
      ; stop_offset = (Loc.stop_offset Loc.none : int)
      }];
  [%expect
    {|
    ((start_offset 0)
     (stop_offset  0))
    |}];
  ()
;;

let%expect_test "range" =
  print_s [%sexp (Loc.range Loc.none : Loc.Range.t)];
  [%expect
    {|
    ((start 0)
     (stop  0))
    |}];
  ()
;;
