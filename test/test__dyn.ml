(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let pp_to_string pp =
  let buffer = Buffer.create 23 in
  let formatter = Stdlib.Format.formatter_of_buffer buffer in
  Stdlib.Format.fprintf formatter "%a%!" Pp.to_fmt pp;
  Buffer.contents buffer
;;

let print_d d = print_string (pp_to_string (Dyn.pp d))

let%expect_test "none" =
  let loc = Loc.none in
  print_d (loc |> Loc.to_dyn);
  [%expect {| "_" |}];
  Ref.set_temporarily Loc.include_sexp_of_locs true ~f:(fun () ->
    print_d (loc |> Loc.to_dyn);
    [%expect {| { start = "<none>:1:0"; stop = "<none>:1:0" } |}]);
  print_d (loc |> Loc.to_dyn);
  [%expect {| "_" |}];
  ()
;;

let%expect_test "pos" =
  let loc = Loc.of_pos ("fname", 1, 15, 15) in
  Ref.set_temporarily Loc.include_sexp_of_locs true ~f:(fun () ->
    print_d (loc |> Loc.to_dyn);
    [%expect {| { start = "fname:1:15"; stop = "fname:1:15" } |}]);
  ()
;;

let%expect_test "loc" =
  let loc =
    Loc.create
      ( { Lexing.pos_fname = "file"; pos_lnum = 1; pos_cnum = 2; pos_bol = 0 }
      , { Lexing.pos_fname = "file"; pos_lnum = 1; pos_cnum = 10; pos_bol = 0 } )
  in
  Ref.set_temporarily Loc.include_sexp_of_locs true ~f:(fun () ->
    print_d (loc |> Loc.to_dyn);
    [%expect {| { start = "file:1:2"; stop = "file:1:10" } |}]);
  ()
;;

let p1 = [%here]
let p2 = [%here]
let p3 = [%here]

let%expect_test "range" =
  let r1 = Loc.Range.of_positions ~start:p1 ~stop:p2 in
  let r2 = Loc.Range.of_positions ~start:p2 ~stop:p3 in
  let r3 = Loc.Range.of_positions ~start:p1 ~stop:p3 in
  print_d (r1 |> Loc.Range.to_dyn);
  [%expect {| { start = 1659; stop = 1676 } |}];
  print_d (r2 |> Loc.Range.to_dyn);
  [%expect {| { start = 1676; stop = 1693 } |}];
  print_d (r3 |> Loc.Range.to_dyn);
  [%expect {| { start = 1659; stop = 1693 } |}];
  ()
;;

let%expect_test "file_cache" =
  let test file_contents =
    let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents in
    print_d (file_cache |> Loc.Private.File_cache.to_dyn)
  in
  test "Hello";
  [%expect
    {|
    { path = "foo.txt"
    ; length = 5
    ; ends_with_newline = false
    ; num_lines = 1
    ; bols = [| 0;  5 |]
    }
    |}];
  ()
;;

let%expect_test "text" =
  let a1 = Loc.Txt.no_loc 0 in
  print_d (a1 |> Loc.Txt.to_dyn Dyn.int);
  [%expect {| 0 |}];
  Ref.set_temporarily Loc.include_sexp_of_locs true ~f:(fun () ->
    print_d (a1 |> Loc.Txt.to_dyn Dyn.int);
    [%expect {| { txt = 0; loc = { start = "<none>:1:0"; stop = "<none>:1:0" } } |}]);
  ()
;;
