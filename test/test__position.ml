(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

open! Import

let p1 = [%here]
let p2 = [%here]
let equal_position (a : Lexing.position) (b : Lexing.position) = Stdlib.compare a b = 0

let%expect_test "equal" =
  let r1 = Loc.create (p1, p2) in
  require (equal_position (Loc.start r1) p1);
  [%expect {||}];
  require (equal_position (Loc.stop r1) p2);
  [%expect {||}];
  require (not (equal_position (Loc.start r1) p2));
  [%expect {||}];
  require (not (equal_position (Loc.stop r1) p1));
  [%expect {||}];
  ()
;;
