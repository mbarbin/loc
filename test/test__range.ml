(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let p1 = [%here]
let p2 = [%here]
let p3 = [%here]

let%expect_test "equal" =
  let test r1 r2 = print_s [%sexp (Loc.Range.equal r1 r2 : bool)] in
  let r1 = Loc.Range.of_positions ~start:p1 ~stop:p1 in
  let r2 = Loc.Range.of_positions ~start:p1 ~stop:p2 in
  let r3 = Loc.Range.of_positions ~start:p1 ~stop:p2 in
  test r1 r1;
  [%expect {| true |}];
  test r1 r2;
  [%expect {| false |}];
  test r2 r3;
  [%expect {| true |}];
  ()
;;

let%expect_test "sexp_of" =
  let r1 = Loc.Range.of_positions ~start:p1 ~stop:p2 in
  let r2 = Loc.Range.of_positions ~start:p2 ~stop:p3 in
  let r3 = Loc.Range.of_positions ~start:p1 ~stop:p3 in
  print_s [%sexp (r1 : Loc.Range.t)];
  [%expect
    {|
    ((start 9)
     (stop  26))
    |}];
  print_s [%sexp (r2 : Loc.Range.t)];
  [%expect
    {|
    ((start 26)
     (stop  43))
    |}];
  print_s [%sexp (r3 : Loc.Range.t)];
  [%expect
    {|
    ((start 9)
     (stop  43))
    |}];
  ()
;;

let%expect_test "range" =
  let via_loc = Loc.create (p1, p3) |> Loc.range in
  let r1 = Loc.Range.of_positions ~start:p1 ~stop:p3 in
  assert (Loc.Range.equal via_loc r1);
  let interval =
    let r1 = Loc.Range.of_positions ~start:p1 ~stop:p2 in
    let r2 = Loc.Range.of_positions ~start:p2 ~stop:p3 in
    Loc.Range.interval r1 r2
  in
  assert (Loc.Range.equal via_loc interval);
  ()
;;
