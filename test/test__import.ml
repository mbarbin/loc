(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

open! Import

let%expect_test "require" =
  (match require false with
   | () -> assert false
   | exception exn -> print_endline (Printexc.to_string exn));
  [%expect {| Failure("Required condition does not hold.") |}];
  ()
;;

let%expect_test "require_does_raise did not raise" =
  (match require_does_raise ignore with
   | () -> assert false
   | exception exn -> print_string (Printexc.to_string exn));
  [%expect {| Failure("Did not raise.") |}];
  ()
;;
