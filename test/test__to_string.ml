(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "1 line" =
  let loc =
    Loc.create
      ( { Lexing.pos_fname = "file"; pos_lnum = 1; pos_cnum = 2; pos_bol = 0 }
      , { Lexing.pos_fname = "file"; pos_lnum = 1; pos_cnum = 10; pos_bol = 0 } )
  in
  print_endline (Loc.to_string loc);
  [%expect {| File "file", line 1, characters 2-10: |}];
  ()
;;

let%expect_test "multiple lines" =
  let loc =
    Loc.create
      ( { Lexing.pos_fname = "file"; pos_lnum = 1; pos_cnum = 2; pos_bol = 0 }
      , { Lexing.pos_fname = "file"; pos_lnum = 3; pos_cnum = 35; pos_bol = 30 } )
  in
  print_endline (Loc.to_string loc);
  [%expect {| File "file", lines 1-3, characters 2-35: |}];
  ()
;;
