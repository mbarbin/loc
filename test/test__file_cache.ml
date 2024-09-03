let%expect_test "negative" =
  let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"" in
  require_does_raise [%here] (fun () -> Loc.in_file_line ~file_cache ~line:0);
  [%expect {| (Invalid_argument Loc.in_file_line) |}];
  require_does_raise [%here] (fun () -> Loc.in_file_line ~file_cache ~line:(-1));
  [%expect {| (Invalid_argument Loc.in_file_line) |}];
  ()
;;

let%expect_test "out of bounds" =
  let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"" in
  require_does_raise [%here] (fun () -> Loc.in_file_line ~file_cache ~line:2);
  [%expect {| (Invalid_argument Loc.in_file_line) |}];
  require_does_raise [%here] (fun () -> Loc.in_file_line ~file_cache ~line:3);
  [%expect {| (Invalid_argument Loc.in_file_line) |}];
  ()
;;

let%expect_test "empty file" =
  let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"" in
  print_endline (Loc.to_string (Loc.in_file_line ~file_cache ~line:1));
  [%expect {| File "foo.txt", line 1, characters 0-0: |}];
  require_does_raise [%here] (fun () -> Loc.in_file_line ~file_cache ~line:2);
  [%expect {| (Invalid_argument Loc.in_file_line) |}];
  ()
;;

let%expect_test "single line" =
  let file_cache =
    Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"Hello"
  in
  print_endline (Loc.to_string (Loc.in_file_line ~file_cache ~line:1));
  [%expect {| File "foo.txt", line 1, characters 0-5: |}];
  require_does_raise [%here] (fun () -> Loc.in_file_line ~file_cache ~line:2);
  [%expect {| (Invalid_argument Loc.in_file_line) |}];
  ()
;;

let%expect_test "single line with newline" =
  let file_cache =
    Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"Hello\n"
  in
  print_endline (Loc.to_string (Loc.in_file_line ~file_cache ~line:1));
  [%expect {| File "foo.txt", line 1, characters 0-5: |}];
  require_does_raise [%here] (fun () -> Loc.in_file_line ~file_cache ~line:2);
  [%expect {| (Invalid_argument Loc.in_file_line) |}];
  ()
;;

let%expect_test "empty lines" =
  let file_cache =
    Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"\n\n\n"
  in
  print_endline (Loc.to_string (Loc.in_file_line ~file_cache ~line:1));
  [%expect {| File "foo.txt", line 1, characters 0-0: |}];
  print_endline (Loc.to_string (Loc.in_file_line ~file_cache ~line:2));
  [%expect {| File "foo.txt", line 2, characters 0-0: |}];
  print_endline (Loc.to_string (Loc.in_file_line ~file_cache ~line:3));
  [%expect {| File "foo.txt", line 3, characters 0-0: |}];
  require_does_raise [%here] (fun () -> Loc.in_file_line ~file_cache ~line:4);
  [%expect {| (Invalid_argument Loc.in_file_line) |}];
  require_does_raise [%here] (fun () -> Loc.in_file_line ~file_cache ~line:5);
  [%expect {| (Invalid_argument Loc.in_file_line) |}];
  ()
;;

let%expect_test "non-empty" =
  let file_cache =
    Loc.File_cache.create
      ~path:(Fpath.v "foo.txt")
      ~file_contents:"Line1\nLine2\nLine3\nLine4"
  in
  print_endline (Loc.to_string (Loc.in_file_line ~file_cache ~line:1));
  [%expect {| File "foo.txt", line 1, characters 0-5: |}];
  print_endline (Loc.to_string (Loc.in_file_line ~file_cache ~line:2));
  [%expect {| File "foo.txt", line 2, characters 0-5: |}];
  print_endline (Loc.to_string (Loc.in_file_line ~file_cache ~line:3));
  [%expect {| File "foo.txt", line 3, characters 0-5: |}];
  print_endline (Loc.to_string (Loc.in_file_line ~file_cache ~line:4));
  [%expect {| File "foo.txt", line 4, characters 0-5: |}];
  require_does_raise [%here] (fun () -> Loc.in_file_line ~file_cache ~line:5);
  [%expect {| (Invalid_argument Loc.in_file_line) |}];
  ()
;;

let%expect_test "newline" =
  let file_cache =
    Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"Line1\n"
  in
  print_endline (Loc.to_string (Loc.in_file_line ~file_cache ~line:1));
  [%expect {| File "foo.txt", line 1, characters 0-5: |}];
  require_does_raise [%here] (fun () -> Loc.in_file_line ~file_cache ~line:2);
  [%expect {| (Invalid_argument Loc.in_file_line) |}];
  require_does_raise [%here] (fun () -> Loc.in_file_line ~file_cache ~line:3);
  [%expect {| (Invalid_argument Loc.in_file_line) |}];
  ()
;;
