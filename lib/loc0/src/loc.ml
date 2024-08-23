module Lexing_position = struct
  type t = Lexing.position

  let to_string { Lexing.pos_fname; pos_lnum; pos_cnum; pos_bol } =
    String.concat
      ":"
      [ pos_fname; Int.to_string pos_lnum; Int.to_string (pos_cnum - pos_bol) ]
  ;;

  let sexp_of_t t = Sexp.Atom (to_string t)
end

module Lexbuf_loc = struct
  type t = Stdune.Lexbuf.Loc.t =
    { start : Lexing_position.t
    ; stop : Lexing_position.t
    }

  let equal = Stdune.Lexbuf.Loc.equal

  let sexp_of_t { start; stop } : Sexp.t =
    List
      [ List [ Atom "start"; Lexing_position.sexp_of_t start ]
      ; List [ Atom "stop"; Lexing_position.sexp_of_t stop ]
      ]
  ;;
end

type t = Stdune.Loc.t

let to_lexbuf_loc : t -> Lexbuf_loc.t = Stdune.Loc.to_lexbuf_loc
let of_lexbuf_loc : Lexbuf_loc.t -> t = Stdune.Loc.of_lexbuf_loc
let sexp_of_t t = Lexbuf_loc.sexp_of_t (to_lexbuf_loc t)
let equal_ignores_locs = ref false
let equal t1 t2 = !equal_ignores_locs || Stdune.Loc.equal t1 t2
let include_sexp_of_locs = ref false
let sexp_of_t t = if !include_sexp_of_locs then sexp_of_t t else Atom "_"
let create (start, stop) = of_lexbuf_loc { start; stop }
let of_pos p = of_lexbuf_loc { start = p; stop = p }

let to_string t =
  let t = to_lexbuf_loc t in
  let lnum =
    if t.start.pos_lnum = t.stop.pos_lnum
    then Printf.sprintf "line %d" t.start.pos_lnum
    else Printf.sprintf "lines %d-%d" t.start.pos_lnum t.stop.pos_lnum
  in
  Printf.sprintf
    "File %S, %s, characters %d-%d:"
    t.start.pos_fname
    lnum
    (t.start.pos_cnum - t.start.pos_bol)
    (t.stop.pos_cnum - t.stop.pos_bol)
;;

let to_file_colon_line = Stdune.Loc.to_file_colon_line
let dummy_pos = of_lexbuf_loc { start = Lexing.dummy_pos; stop = Lexing.dummy_pos }

let in_file_at_line ~path ~line =
  let p =
    { Lexing.pos_fname = path |> Fpath.to_string
    ; pos_lnum = line
    ; pos_cnum = 0
    ; pos_bol = 0
    }
  in
  of_lexbuf_loc { start = p; stop = p }
;;

let in_file ~path = in_file_at_line ~path ~line:1

let with_dummy_pos t =
  let t = to_lexbuf_loc t in
  of_lexbuf_loc
    { start = { Lexing.dummy_pos with pos_fname = t.start.pos_fname }
    ; stop = { Lexing.dummy_pos with pos_fname = t.stop.pos_fname }
    }
;;

let path t =
  let t = to_lexbuf_loc t in
  t.start.pos_fname |> Fpath.v
;;

let line t =
  let t = to_lexbuf_loc t in
  t.start.pos_lnum
;;

let start_pos_cnum = Stdune.Loc.start_pos_cnum
let stop_pos_cnum = Stdune.Loc.stop_pos_cnum
let start_pos t = (to_lexbuf_loc t).start
let stop_pos t = (to_lexbuf_loc t).stop

module Offset = struct
  type t = int

  let equal = Int.equal
  let sexp_of_t = Sexplib0.Sexp_conv.sexp_of_int
  let of_source_code_position (t : Lexing.position) = t.pos_cnum
end

let start_offset t = t |> start_pos |> Offset.of_source_code_position
let stop_offset t = t |> stop_pos |> Offset.of_source_code_position

module Range = struct
  type t =
    { start : Offset.t
    ; stop : Offset.t
    }

  let equal { start = t1; stop = p1 } { start = t2; stop = p2 } = t1 = t2 && p1 = p2

  let sexp_of_t { start; stop } : Sexp.t =
    List
      [ List [ Atom "start"; Sexplib0.Sexp_conv.sexp_of_int start ]
      ; List [ Atom "stop"; Sexplib0.Sexp_conv.sexp_of_int stop ]
      ]
  ;;

  let of_source_code_positions ~start ~stop =
    { start = Offset.of_source_code_position start
    ; stop = Offset.of_source_code_position stop
    }
  ;;

  let interval { start = start1; stop = stop1 } { start = start2; stop = stop2 } =
    { start = Int.min start1 start2; stop = Int.max stop1 stop2 }
  ;;
end

let range t =
  let t = to_lexbuf_loc t in
  Range.of_source_code_positions ~start:t.start ~stop:t.stop
;;
