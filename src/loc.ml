module Loc0 = struct
  type t = Stdune.Lexbuf.Loc.t =
    { start : Source_code_position.t
    ; stop : Source_code_position.t
    }
  [@@deriving equal, sexp_of]
end

type t = Stdune.Loc.t

let equal = Stdune.Loc.equal
let sexp_of_t t = [%sexp (Stdune.Loc.to_lexbuf_loc t : Loc0.t)]
let equal_ignores_positions = ref false
let equal t1 t2 = !equal_ignores_positions || equal t1 t2
let include_sexp_of_positions = ref false
let sexp_of_t t = if !include_sexp_of_positions then sexp_of_t t else Atom "_"
let create (start, stop) = Stdune.Loc.of_lexbuf_loc { start; stop }
let of_pos p = Stdune.Loc.of_lexbuf_loc { start = p; stop = p }

let to_string t =
  let t = Stdune.Loc.to_lexbuf_loc t in
  Printf.sprintf
    "File %S, line %d, characters %d-%d:"
    t.start.pos_fname
    t.start.pos_lnum
    (t.start.pos_cnum - t.start.pos_bol)
    (t.stop.pos_cnum - t.stop.pos_bol)
;;

let to_file_colon_line t = Stdune.Loc.to_file_colon_line t

let dummy_pos =
  Stdune.Loc.of_lexbuf_loc { start = Lexing.dummy_pos; stop = Lexing.dummy_pos }
;;

let in_file_at_line ~path ~line =
  let p =
    { Lexing.pos_fname = path |> Fpath.to_string
    ; pos_lnum = line
    ; pos_cnum = 0
    ; pos_bol = 0
    }
  in
  Stdune.Loc.of_lexbuf_loc { start = p; stop = p }
;;

let in_file ~path = in_file_at_line ~path ~line:1

let with_dummy_pos t =
  let t = Stdune.Loc.to_lexbuf_loc t in
  Stdune.Loc.of_lexbuf_loc
    { start = { Lexing.dummy_pos with pos_fname = t.start.pos_fname }
    ; stop = { Lexing.dummy_pos with pos_fname = t.stop.pos_fname }
    }
;;

let path t =
  let t = Stdune.Loc.to_lexbuf_loc t in
  t.start.pos_fname |> Fpath.v
;;

let line t =
  let t = Stdune.Loc.to_lexbuf_loc t in
  t.start.pos_lnum
;;

let start_pos_cnum = Stdune.Loc.start_pos_cnum
let stop_pos_cnum = Stdune.Loc.stop_pos_cnum
let start_pos t = (Stdune.Loc.to_lexbuf_loc t).start
let stop_pos t = (Stdune.Loc.to_lexbuf_loc t).stop

module Lexbuf_loc = struct
  type t = Stdune.Lexbuf.Loc.t =
    { start : Source_code_position.t
    ; stop : Source_code_position.t
    }
end

let to_lexbuf_loc = Stdune.Loc.to_lexbuf_loc

module Offset = struct
  type t = int [@@deriving equal, sexp_of]

  let of_source_code_position (t : Source_code_position.t) = t.pos_cnum
end

let start_offset t = t |> start_pos |> Offset.of_source_code_position
let stop_offset t = t |> stop_pos |> Offset.of_source_code_position

module Range = struct
  type t =
    { start : Offset.t
    ; stop : Offset.t
    }
  [@@deriving equal, sexp_of]

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
