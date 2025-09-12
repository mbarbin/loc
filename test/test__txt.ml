(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let h1 = [%here]
let h2 = [%here]
let p1 = Loc.of_position h1
let p2 = Loc.of_position h2

(* no loc *)
let a1 = Loc.Txt.no_loc 0
let a2 = Loc.Txt.no_loc 0
let a3 = Loc.Txt.no_loc 1

(* loc = p1 *)
let b1 = { Loc.Txt.txt = 0; loc = p1 }
let b2 = { Loc.Txt.txt = 0; loc = p1 }
let b3 = { Loc.Txt.txt = 1; loc = p1 }

(* loc = p2 *)
let c1 = { Loc.Txt.txt = 0; loc = p2 }
let c2 = { Loc.Txt.txt = 0; loc = p2 }
let c3 = { Loc.Txt.txt = 1; loc = p2 }

(* loc = (h1, h2) *)
let d1 = Loc.Txt.create (h1, h2) 0
let d2 = Loc.Txt.create (h1, h2) 0
let d3 = Loc.Txt.create (h1, h2) 1

let%expect_test "loc" =
  print_s [%sexp (Loc.is_none (Loc.Txt.loc a1) : bool)];
  [%expect {| true |}];
  print_s [%sexp (Loc.is_none (Loc.Txt.loc b1) : bool)];
  [%expect {| false |}];
  print_s [%sexp (Loc.is_none (Loc.Txt.loc (Loc.Txt.map a1 ~f:Int.succ)) : bool)];
  [%expect {| true |}];
  print_s [%sexp (Loc.is_none (Loc.Txt.loc (Loc.Txt.map b1 ~f:Int.succ)) : bool)];
  [%expect {| false |}];
  ()
;;

let%expect_test "symbol" =
  print_s [%sexp (Loc.Txt.txt a1 : int)];
  [%expect {| 0 |}];
  print_s [%sexp (Loc.Txt.txt a3 : int)];
  [%expect {| 1 |}];
  print_s [%sexp (Loc.Txt.txt (Loc.Txt.map a1 ~f:Int.succ) : int)];
  [%expect {| 1 |}];
  print_s [%sexp (Loc.Txt.txt (Loc.Txt.map a3 ~f:Int.succ) : int)];
  [%expect {| 2 |}];
  ()
;;

let%expect_test "sexp_of_t" =
  print_s [%sexp (a1 : int Loc.Txt.t)];
  [%expect {| 0 |}];
  Ref.set_temporarily Loc.include_sexp_of_locs true ~f:(fun () ->
    print_s [%sexp (a1 : int Loc.Txt.t)];
    [%expect
      {|
      ((txt 0)
       (loc (
         (start <none>:1:0)
         (stop  <none>:1:0))))
      |}]);
  ()
;;

let%expect_test "equal" =
  let test a b =
    let equal = Loc.Txt.equal Int.equal a b in
    let equal_ignores_locs =
      Ref.set_temporarily Loc.equal_ignores_locs true ~f:(fun () ->
        Loc.Txt.equal Int.equal a b)
    in
    print_s [%sexp { equal : bool; equal_ignores_locs : bool }]
  in
  test a1 a1;
  [%expect
    {|
    ((equal              true)
     (equal_ignores_locs true))
    |}];
  test a1 a2;
  [%expect
    {|
    ((equal              true)
     (equal_ignores_locs true))
    |}];
  test a1 a3;
  [%expect
    {|
    ((equal              false)
     (equal_ignores_locs false))
    |}];
  test b1 b1;
  [%expect
    {|
    ((equal              true)
     (equal_ignores_locs true))
    |}];
  test b1 b2;
  [%expect
    {|
    ((equal              true)
     (equal_ignores_locs true))
    |}];
  test b1 b3;
  [%expect
    {|
    ((equal              false)
     (equal_ignores_locs false))
    |}];
  test c1 c1;
  [%expect
    {|
    ((equal              true)
     (equal_ignores_locs true))
    |}];
  test c1 c2;
  [%expect
    {|
    ((equal              true)
     (equal_ignores_locs true))
    |}];
  test c1 c3;
  [%expect
    {|
    ((equal              false)
     (equal_ignores_locs false))
    |}];
  test a1 b1;
  [%expect
    {|
    ((equal              false)
     (equal_ignores_locs true))
    |}];
  test a2 b2;
  [%expect
    {|
    ((equal              false)
     (equal_ignores_locs true))
    |}];
  test a3 b3;
  [%expect
    {|
    ((equal              false)
     (equal_ignores_locs true))
    |}];
  test a1 c1;
  [%expect
    {|
    ((equal              false)
     (equal_ignores_locs true))
    |}];
  test a2 c2;
  [%expect
    {|
    ((equal              false)
     (equal_ignores_locs true))
    |}];
  test a3 c3;
  [%expect
    {|
    ((equal              false)
     (equal_ignores_locs true))
    |}];
  test b1 c1;
  [%expect
    {|
    ((equal              false)
     (equal_ignores_locs true))
    |}];
  test b2 c2;
  [%expect
    {|
    ((equal              false)
     (equal_ignores_locs true))
    |}];
  test b3 c3;
  [%expect
    {|
    ((equal              false)
     (equal_ignores_locs true))
    |}];
  test c1 d1;
  [%expect
    {|
      ((equal              false)
       (equal_ignores_locs true))
      |}];
  test c2 d2;
  [%expect
    {|
      ((equal              false)
       (equal_ignores_locs true))
      |}];
  test c3 d3;
  [%expect
    {|
      ((equal              false)
       (equal_ignores_locs true))
      |}];
  ()
;;
