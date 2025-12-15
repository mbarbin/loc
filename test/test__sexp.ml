(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

open! Import

let print_s s = print_endline (Sexp.to_string_hum s)

let%expect_test "none" =
  let loc = Loc.none in
  print_s (loc |> Loc.sexp_of_t);
  [%expect {| _ |}];
  Ref.set_temporarily Loc.include_sexp_of_locs true ~f:(fun () ->
    print_s (loc |> Loc.sexp_of_t);
    [%expect {| ((start <none>:1:0) (stop <none>:1:0)) |}]);
  print_s (loc |> Loc.sexp_of_t);
  [%expect {| _ |}];
  ()
;;

let%expect_test "pos" =
  let loc = Loc.of_pos ("fname", 1, 15, 15) in
  Ref.set_temporarily Loc.include_sexp_of_locs true ~f:(fun () ->
    print_s (loc |> Loc.sexp_of_t);
    [%expect {| ((start fname:1:15) (stop fname:1:15)) |}]);
  ()
;;

let%expect_test "loc" =
  let loc =
    Loc.create
      ( { Lexing.pos_fname = "file"; pos_lnum = 1; pos_cnum = 2; pos_bol = 0 }
      , { Lexing.pos_fname = "file"; pos_lnum = 1; pos_cnum = 10; pos_bol = 0 } )
  in
  Ref.set_temporarily Loc.include_sexp_of_locs true ~f:(fun () ->
    print_s (loc |> Loc.sexp_of_t);
    [%expect {| ((start file:1:2) (stop file:1:10)) |}]);
  ()
;;

let%expect_test "Range.sexp_of_t" =
  let r : Loc.Range.t = { start = 5; stop = 10 } in
  print_s (r |> Loc.Range.sexp_of_t);
  [%expect {| ((start 5) (stop 10)) |}];
  ()
;;

let%expect_test "Txt.sexp_of_t" =
  let a = Loc.Txt.no_loc 42 in
  print_s (a |> Loc.Txt.sexp_of_t Sexplib0.Sexp_conv.sexp_of_int);
  [%expect {| 42 |}];
  Ref.set_temporarily Loc.include_sexp_of_locs true ~f:(fun () ->
    print_s (a |> Loc.Txt.sexp_of_t Sexplib0.Sexp_conv.sexp_of_int);
    [%expect {| ((txt 42) (loc ((start <none>:1:0) (stop <none>:1:0)))) |}]);
  ()
;;

let%expect_test "File_cache.sexp_of_t" =
  let file_cache =
    Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"Hello"
  in
  print_s (file_cache |> Loc.Private.File_cache.sexp_of_t);
  [%expect
    {|
    ((path foo.txt) (length 5) (ends_with_newline false) (num_lines 1)
     (bols (0 5)))
    |}];
  ()
;;
