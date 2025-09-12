(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let p1 = [%here]
let p2 = [%here]

let print_offsets loc =
  print_s
    [%sexp
      { start_offset = (Loc.start_offset loc : Loc.Offset.t)
      ; stop_offset = (Loc.stop_offset loc : Loc.Offset.t)
      }]
;;

let%expect_test "equal" =
  print_s
    [%sexp
      (Loc.Offset.equal (Loc.Offset.of_position p1) (Loc.Offset.of_position p1) : bool)];
  [%expect {| true |}];
  print_s
    [%sexp
      (Loc.Offset.equal (Loc.Offset.of_position p1) (Loc.Offset.of_position p2) : bool)];
  [%expect {| false |}];
  ()
;;

let%expect_test "of_position" =
  print_s [%sexp (Loc.Offset.of_position p1 : Loc.Offset.t)];
  [%expect {| 9 |}];
  ()
;;

let%expect_test "start/stop" =
  print_offsets (Loc.of_position p1);
  [%expect
    {|
    ((start_offset 9)
     (stop_offset  9))
    |}];
  print_offsets (Loc.of_position p2);
  [%expect
    {|
    ((start_offset 26)
     (stop_offset  26))
    |}];
  print_offsets (Loc.create (p1, p2));
  [%expect
    {|
    ((start_offset 9)
     (stop_offset  26))
    |}];
  ()
;;
