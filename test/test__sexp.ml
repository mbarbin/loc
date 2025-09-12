(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "none" =
  let loc = Loc.none in
  print_s [%sexp (loc : Loc.t)];
  [%expect {| _ |}];
  Ref.set_temporarily Loc.include_sexp_of_locs true ~f:(fun () ->
    print_s [%sexp (loc : Loc.t)];
    [%expect
      {|
      ((start <none>:1:0)
       (stop  <none>:1:0))
      |}]);
  print_s [%sexp (loc : Loc.t)];
  [%expect {| _ |}];
  ()
;;

let%expect_test "pos" =
  let loc = Loc.of_pos ("fname", 1, 15, 15) in
  Ref.set_temporarily Loc.include_sexp_of_locs true ~f:(fun () ->
    print_s [%sexp (loc : Loc.t)];
    [%expect
      {|
      ((start fname:1:15)
       (stop  fname:1:15))
      |}]);
  ()
;;

let%expect_test "loc" =
  let loc =
    Loc.create
      ( { Lexing.pos_fname = "file"; pos_lnum = 1; pos_cnum = 2; pos_bol = 0 }
      , { Lexing.pos_fname = "file"; pos_lnum = 1; pos_cnum = 10; pos_bol = 0 } )
  in
  Ref.set_temporarily Loc.include_sexp_of_locs true ~f:(fun () ->
    print_s [%sexp (loc : Loc.t)];
    [%expect
      {|
      ((start file:1:2)
       (stop  file:1:10))
      |}]);
  ()
;;
