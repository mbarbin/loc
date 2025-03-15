let loc = Loc.of_file ~path:(Fpath.v "file")

let%expect_test "to_string" =
  print_endline (Loc.to_string loc);
  [%expect {| File "file", line 1, characters 0-0: |}];
  print_endline (Loc.to_file_colon_line loc);
  [%expect {| file:1 |}];
  ()
;;

let%expect_test "path" =
  print_endline (Loc.path loc |> Fpath.to_string);
  [%expect {| file |}];
  ()
;;

let%expect_test "start_line" =
  print_s [%sexp (Loc.start_line loc : int)];
  [%expect {| 1 |}];
  ()
;;

let%expect_test "is_none" =
  print_s [%sexp (Loc.is_none loc : bool)];
  [%expect {| false |}];
  ()
;;

let%expect_test "range" =
  print_s [%sexp (Loc.range loc : Loc.Range.t)];
  [%expect
    {|
    ((start 0)
     (stop  0))
    |}];
  ()
;;

(* With this code fragment, we can exercise the [ocamlmig] attributes located in
   the [Loc] deprecated API.

   Run: [ocamlmig migrate] to check. *)
let _f ~file_cache ~path ~line =
  (ignore (Loc.in_file ~path : Loc.t);
   ignore (Loc.in_file_line ~file_cache ~line : Loc.t);
   ())
  [@alert "-deprecated"] [@coverage off]
;;
