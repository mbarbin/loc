let%expect_test "create" =
  let test file_contents =
    let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents in
    print_s [%sexp (file_cache : Loc.Private.File_cache.t)]
  in
  test "";
  [%expect
    {|
    ((path              foo.txt)
     (length            0)
     (ends_with_newline false)
     (num_lines         1)
     (bols (0)))
    |}];
  test "Hello";
  [%expect
    {|
    ((path              foo.txt)
     (length            5)
     (ends_with_newline false)
     (num_lines         1)
     (bols (0 5)))
    |}];
  test "Hello\nWorld";
  [%expect
    {|
    ((path              foo.txt)
     (length            11)
     (ends_with_newline false)
     (num_lines         2)
     (bols (0 6 11)))
    |}];
  test "Hello\nWorld\n";
  [%expect
    {|
    ((path              foo.txt)
     (length            12)
     (ends_with_newline true)
     (num_lines         2)
     (bols (0 6 12)))
    |}];
  test "Hello\nFriendly\nWorld";
  [%expect
    {|
    ((path              foo.txt)
     (length            20)
     (ends_with_newline false)
     (num_lines         3)
     (bols (0 6 15 20)))
    |}];
  test "Hello\nFriendly\nWorld\n";
  [%expect
    {|
    ((path              foo.txt)
     (length            21)
     (ends_with_newline true)
     (num_lines         3)
     (bols (0 6 15 21)))
    |}];
  ()
;;

let%expect_test "getters" =
  let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"" in
  print_endline (Loc.File_cache.path file_cache |> Fpath.to_string);
  [%expect {| foo.txt |}];
  ()
;;

let%expect_test "negative" =
  let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"" in
  require_does_raise [%here] (fun () -> Loc.of_file_line ~file_cache ~line:0);
  [%expect {| (Invalid_argument Loc.of_file_line) |}];
  require_does_raise [%here] (fun () -> Loc.of_file_line ~file_cache ~line:(-1));
  [%expect {| (Invalid_argument Loc.of_file_line) |}];
  ()
;;

let%expect_test "out of bounds" =
  let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"" in
  require_does_raise [%here] (fun () -> Loc.of_file_line ~file_cache ~line:2);
  [%expect {| (Invalid_argument Loc.of_file_line) |}];
  require_does_raise [%here] (fun () -> Loc.of_file_line ~file_cache ~line:3);
  [%expect {| (Invalid_argument Loc.of_file_line) |}];
  ()
;;

let%expect_test "empty file" =
  let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"" in
  print_endline (Loc.to_string (Loc.of_file_line ~file_cache ~line:1));
  [%expect {| File "foo.txt", line 1, characters 0-0: |}];
  require_does_raise [%here] (fun () -> Loc.of_file_line ~file_cache ~line:2);
  [%expect {| (Invalid_argument Loc.of_file_line) |}];
  ()
;;

let%expect_test "single line" =
  let file_cache =
    Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"Hello"
  in
  print_endline (Loc.to_string (Loc.of_file_line ~file_cache ~line:1));
  [%expect {| File "foo.txt", line 1, characters 0-5: |}];
  require_does_raise [%here] (fun () -> Loc.of_file_line ~file_cache ~line:2);
  [%expect {| (Invalid_argument Loc.of_file_line) |}];
  ()
;;

let%expect_test "single line with newline" =
  let file_cache =
    Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"Hello\n"
  in
  print_endline (Loc.to_string (Loc.of_file_line ~file_cache ~line:1));
  [%expect {| File "foo.txt", line 1, characters 0-5: |}];
  require_does_raise [%here] (fun () -> Loc.of_file_line ~file_cache ~line:2);
  [%expect {| (Invalid_argument Loc.of_file_line) |}];
  ()
;;

let%expect_test "empty lines" =
  let file_cache =
    Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"\n\n\n"
  in
  print_endline (Loc.to_string (Loc.of_file_line ~file_cache ~line:1));
  [%expect {| File "foo.txt", line 1, characters 0-0: |}];
  print_endline (Loc.to_string (Loc.of_file_line ~file_cache ~line:2));
  [%expect {| File "foo.txt", line 2, characters 0-0: |}];
  print_endline (Loc.to_string (Loc.of_file_line ~file_cache ~line:3));
  [%expect {| File "foo.txt", line 3, characters 0-0: |}];
  require_does_raise [%here] (fun () -> Loc.of_file_line ~file_cache ~line:4);
  [%expect {| (Invalid_argument Loc.of_file_line) |}];
  require_does_raise [%here] (fun () -> Loc.of_file_line ~file_cache ~line:5);
  [%expect {| (Invalid_argument Loc.of_file_line) |}];
  ()
;;

let%expect_test "non-empty" =
  let file_cache =
    Loc.File_cache.create
      ~path:(Fpath.v "foo.txt")
      ~file_contents:"Line1\nLine2\nLine3\nLine4"
  in
  print_endline (Loc.to_string (Loc.of_file_line ~file_cache ~line:1));
  [%expect {| File "foo.txt", line 1, characters 0-5: |}];
  print_endline (Loc.to_string (Loc.of_file_line ~file_cache ~line:2));
  [%expect {| File "foo.txt", line 2, characters 0-5: |}];
  print_endline (Loc.to_string (Loc.of_file_line ~file_cache ~line:3));
  [%expect {| File "foo.txt", line 3, characters 0-5: |}];
  print_endline (Loc.to_string (Loc.of_file_line ~file_cache ~line:4));
  [%expect {| File "foo.txt", line 4, characters 0-5: |}];
  require_does_raise [%here] (fun () -> Loc.of_file_line ~file_cache ~line:5);
  [%expect {| (Invalid_argument Loc.of_file_line) |}];
  ()
;;

let%expect_test "newline" =
  let file_cache =
    Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents:"Line1\n"
  in
  print_endline (Loc.to_string (Loc.of_file_line ~file_cache ~line:1));
  [%expect {| File "foo.txt", line 1, characters 0-5: |}];
  require_does_raise [%here] (fun () -> Loc.of_file_line ~file_cache ~line:2);
  [%expect {| (Invalid_argument Loc.of_file_line) |}];
  require_does_raise [%here] (fun () -> Loc.of_file_line ~file_cache ~line:3);
  [%expect {| (Invalid_argument Loc.of_file_line) |}];
  ()
;;

let make_matrix_contents =
  lazy
    (let line = "0123456789" in
     String.concat ~sep:"\n" (List.init 10 ~f:(fun _ -> line)))
;;

let%expect_test "of_file_offset" =
  let file_contents = Lazy.force make_matrix_contents in
  let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents in
  let test offset =
    let loc = Loc.of_file_offset ~file_cache ~offset in
    print_endline (Loc.to_string loc)
  in
  require_does_raise [%here] (fun () -> test (-1));
  [%expect {| (Invalid_argument Loc.File_cache.position) |}];
  require_does_raise [%here] (fun () -> test (String.length file_contents));
  [%expect {| (Invalid_argument Loc.File_cache.position) |}];
  test 0;
  [%expect {| File "foo.txt", line 1, characters 0-0: |}];
  test 1;
  [%expect {| File "foo.txt", line 1, characters 1-1: |}];
  test 10;
  [%expect {| File "foo.txt", line 1, characters 10-10: |}];
  test 11;
  [%expect {| File "foo.txt", line 2, characters 0-0: |}];
  ()
;;

let%expect_test "of_file_offset more" =
  let file_contents = "Hello\nWorld" in
  let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents in
  print_s [%sexp (file_cache : Loc.Private.File_cache.t)];
  [%expect
    {|
    ((path              foo.txt)
     (length            11)
     (ends_with_newline false)
     (num_lines         2)
     (bols (0 6 11)))
    |}];
  let test offset =
    let loc = Loc.of_file_offset ~file_cache ~offset in
    print_endline (Loc.to_string loc)
  in
  require_does_raise [%here] (fun () -> test (String.length file_contents));
  [%expect {| (Invalid_argument Loc.File_cache.position) |}];
  test (String.length file_contents - 1);
  [%expect {| File "foo.txt", line 2, characters 4-4: |}];
  let file_contents = "Hello\nFriendly\nWorld\n" in
  let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents in
  print_s [%sexp (file_cache : Loc.Private.File_cache.t)];
  [%expect
    {|
    ((path              foo.txt)
     (length            21)
     (ends_with_newline true)
     (num_lines         3)
     (bols (0 6 15 21)))
    |}];
  let test offset =
    let loc = Loc.of_file_offset ~file_cache ~offset in
    print_endline (Loc.to_string loc)
  in
  require_does_raise [%here] (fun () -> test (String.length file_contents));
  [%expect {| (Invalid_argument Loc.File_cache.position) |}];
  test (String.length file_contents - 1);
  [%expect {| File "foo.txt", line 3, characters 5-5: |}];
  let file_contents = "Hello\nFriendly\nWorld" in
  let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents in
  print_s [%sexp (file_cache : Loc.Private.File_cache.t)];
  [%expect
    {|
    ((path              foo.txt)
     (length            20)
     (ends_with_newline false)
     (num_lines         3)
     (bols (0 6 15 20)))
    |}];
  let test offset =
    let loc = Loc.of_file_offset ~file_cache ~offset in
    print_endline (Loc.to_string loc)
  in
  require_does_raise [%here] (fun () -> test (String.length file_contents));
  [%expect {| (Invalid_argument Loc.File_cache.position) |}];
  test (String.length file_contents - 1);
  [%expect {| File "foo.txt", line 3, characters 4-4: |}];
  ()
;;

let%expect_test "of_file_range" =
  let file_contents = Lazy.force make_matrix_contents in
  let file_cache = Loc.File_cache.create ~path:(Fpath.v "foo.txt") ~file_contents in
  let test start stop =
    let loc = Loc.of_file_range ~file_cache ~range:{ start; stop } in
    print_endline (Loc.to_string loc)
  in
  require_does_raise [%here] (fun () -> test (-1) 0);
  [%expect {| (Invalid_argument Loc.File_cache.position) |}];
  require_does_raise [%here] (fun () -> test 0 (String.length file_contents));
  [%expect {| (Invalid_argument Loc.File_cache.position) |}];
  require_does_raise [%here] (fun () -> test 1 0);
  [%expect {| (Invalid_argument Loc.of_file_range) |}];
  test 0 0;
  [%expect {| File "foo.txt", line 1, characters 0-0: |}];
  test 0 1;
  [%expect {| File "foo.txt", line 1, characters 0-1: |}];
  test 10 11;
  [%expect {| File "foo.txt", lines 1-2, characters 10-11: |}];
  test 11 15;
  [%expect {| File "foo.txt", line 2, characters 0-4: |}];
  ()
;;
