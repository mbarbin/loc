(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

open! Import

let p1 = [%here]
let p2 = [%here]

let print_offsets loc =
  print_dyn
    (Dyn.record
       [ "start_offset", Loc.start_offset loc |> Dyn.int
       ; "stop_offset", Loc.stop_offset loc |> Dyn.int
       ])
;;

let%expect_test "equal" =
  print_dyn
    (Loc.Offset.equal (Loc.Offset.of_position p1) (Loc.Offset.of_position p1) |> Dyn.bool);
  [%expect {| true |}];
  print_dyn
    (Loc.Offset.equal (Loc.Offset.of_position p1) (Loc.Offset.of_position p2) |> Dyn.bool);
  [%expect {| false |}];
  ()
;;

let%expect_test "of_position" =
  print_dyn (Loc.Offset.of_position p1 |> Dyn.int);
  [%expect {| 444 |}];
  ()
;;

let%expect_test "start/stop" =
  print_offsets (Loc.of_position p1);
  [%expect {| { start_offset = 444; stop_offset = 444 } |}];
  print_offsets (Loc.of_position p2);
  [%expect {| { start_offset = 461; stop_offset = 461 } |}];
  print_offsets (Loc.create (p1, p2));
  [%expect {| { start_offset = 444; stop_offset = 461 } |}];
  ()
;;
