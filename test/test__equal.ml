(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let test loc1 loc2 = print_s [%sexp (Loc.equal loc1 loc2 : bool)]

let%expect_test "ignore" =
  let loc1 = Loc.of_pos ("file1", 1, 0, 0) in
  let loc2 = Loc.of_pos ("file2", 1, 0, 0) in
  test loc1 loc2;
  [%expect {| false |}];
  Ref.set_temporarily Loc.equal_ignores_locs true ~f:(fun () ->
    test loc1 loc2;
    [%expect {| true |}]);
  test loc1 loc2;
  [%expect {| false |}];
  ()
;;

let%expect_test "positions" =
  test (Loc.of_position [%here]) (Loc.of_position [%here]);
  [%expect {| false |}];
  let p = [%here] in
  test (Loc.of_position p) (Loc.of_position p);
  [%expect {| true |}];
  ()
;;
