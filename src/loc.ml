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
let equal_ignores_locs = ref false
let equal t1 t2 = !equal_ignores_locs || Stdune.Loc.equal t1 t2
let include_sexp_of_locs = ref false

let sexp_of_t t =
  if !include_sexp_of_locs then Lexbuf_loc.sexp_of_t (to_lexbuf_loc t) else Atom "_"
;;

let create (start, stop) = of_lexbuf_loc { start; stop }
let of_position p = of_lexbuf_loc { start = p; stop = p }
let of_pos = Stdune.Loc.of_pos
let of_lexbuf = Stdune.Loc.of_lexbuf
let none = Stdune.Loc.none
let is_none = Stdune.Loc.is_none

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
    (t.stop.pos_cnum - t.start.pos_bol)
;;

let to_file_colon_line = Stdune.Loc.to_file_colon_line

let of_file ~path =
  let p =
    { Lexing.pos_fname = path |> Fpath.to_string
    ; pos_lnum = 1
    ; pos_cnum = 0
    ; pos_bol = 0
    }
  in
  of_lexbuf_loc { start = p; stop = p }
;;

module File_cache = struct
  type t =
    { path : Fpath.t
    ; length : int
    ; ends_with_newline : bool
    ; num_lines : int
    ; bols : int array
    }

  let sexp_of_t { path; length; ends_with_newline; num_lines; bols } : Sexp.t =
    List
      [ List [ Atom "path"; Atom (path |> Fpath.to_string) ]
      ; List [ Atom "length"; Atom (length |> Int.to_string) ]
      ; List [ Atom "ends_with_newline"; Atom (ends_with_newline |> Bool.to_string) ]
      ; List [ Atom "num_lines"; Atom (num_lines |> Int.to_string) ]
      ; List
          [ Atom "bols"
          ; Sexplib0.Sexp_conv.sexp_of_array Sexplib0.Sexp_conv.sexp_of_int bols
          ]
      ]
  ;;

  let path t = t.path

  let create ~path ~file_contents =
    let bols = ref [ 0 ] in
    String.iteri
      (fun cnum char -> if Char.equal char '\n' then bols := (cnum + 1) :: !bols)
      file_contents;
    let length = String.length file_contents in
    let ends_with_newline = length > 0 && file_contents.[length - 1] = '\n' in
    if length > 0 && not ends_with_newline then bols := length :: !bols;
    let bols = Array.of_list (List.rev !bols) in
    let num_lines =
      if length = 0
      then 1 (* line 1, char 0 is considered the only valid offset. *)
      else Array.length bols - 1
    in
    { path; length; ends_with_newline; num_lines; bols }
  ;;

  let position t ~pos_cnum =
    let rec binary_search ~from ~to_ =
      if from > to_
      then raise (Invalid_argument "Loc.File_cache.position") [@coverage off]
      else (
        let mid = (from + to_) / 2 in
        let pos_bol = t.bols.(mid) in
        if pos_cnum < pos_bol
        then binary_search ~from ~to_:(mid - 1)
        else (
          let succ = mid + 1 in
          if succ < Array.length t.bols && pos_cnum >= t.bols.(succ)
          then binary_search ~from:succ ~to_
          else
            { Lexing.pos_fname = t.path |> Fpath.to_string
            ; pos_lnum = succ
            ; pos_cnum
            ; pos_bol
            }))
    in
    if pos_cnum < 0 || pos_cnum >= t.length
    then raise (Invalid_argument "Loc.File_cache.position")
    else binary_search ~from:0 ~to_:(Array.length t.bols - 1)
  ;;
end

let of_file_line ~(file_cache : File_cache.t) ~line =
  if line < 1 || line > file_cache.num_lines
  then raise (Invalid_argument "Loc.of_file_line");
  let pos_fname = file_cache.path |> Fpath.to_string in
  let pos_bol = file_cache.bols.(line - 1) in
  let start = { Lexing.pos_fname; pos_lnum = line; pos_cnum = pos_bol; pos_bol } in
  let stop =
    if line >= Array.length file_cache.bols
    then start
    else (
      let pos_cnum =
        file_cache.bols.(line)
        - if line = file_cache.num_lines && not file_cache.ends_with_newline then 0 else 1
      in
      { Lexing.pos_fname; pos_lnum = line; pos_cnum; pos_bol })
  in
  of_lexbuf_loc { start; stop }
;;

let path t =
  let t = to_lexbuf_loc t in
  t.start.pos_fname |> Fpath.v
;;

let start_line t =
  let t = to_lexbuf_loc t in
  t.start.pos_lnum
;;

let start t = Stdune.Loc.start t
let stop t = Stdune.Loc.stop t

module Offset = struct
  type t = int

  let equal = Int.equal
  let sexp_of_t = Sexplib0.Sexp_conv.sexp_of_int
  let of_position (t : Lexing.position) = t.pos_cnum
  let to_position t ~file_cache = File_cache.position file_cache ~pos_cnum:t
end

let start_offset = Stdune.Loc.start_pos_cnum
let stop_offset = Stdune.Loc.stop_pos_cnum

let of_file_offset ~file_cache ~offset =
  Offset.to_position offset ~file_cache |> of_position
;;

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

  let of_positions ~start ~stop =
    { start = Offset.of_position start; stop = Offset.of_position stop }
  ;;

  let interval { start = start1; stop = stop1 } { start = start2; stop = stop2 } =
    { start = Int.min start1 start2; stop = Int.max stop1 stop2 }
  ;;
end

let range t =
  let t = to_lexbuf_loc t in
  Range.of_positions ~start:t.start ~stop:t.stop
;;

let of_file_range ~file_cache ~range:{ Range.start; stop } =
  if start > stop
  then raise (Invalid_argument "Loc.of_file_range")
  else
    of_lexbuf_loc
      { start = Offset.to_position start ~file_cache
      ; stop = Offset.to_position stop ~file_cache
      }
;;

module Txt = struct
  module Loc = struct
    type nonrec t = t

    let sexp_of_t = sexp_of_t
    let create = create
    let equal = equal
    let none = none
  end

  type 'a t =
    { txt : 'a
    ; loc : Loc.t
    }

  let equal equal_txt ({ txt = s1; loc = l1 } as t1) ({ txt = s2; loc = l2 } as t2) =
    t1 == t2 || (Loc.equal l1 l2 && equal_txt s1 s2)
  ;;

  let sexp_of_t sexp_of_txt { txt; loc } : Sexp.t =
    if !include_sexp_of_locs
    then
      List
        [ List [ Atom "txt"; sexp_of_txt txt ]; List [ Atom "loc"; Loc.sexp_of_t loc ] ]
    else sexp_of_txt txt
  ;;

  let create loc txt = { txt; loc = Loc.create loc }
  let map t ~f = { t with txt = f t.txt }
  let no_loc txt = { txt; loc = Loc.none }
  let loc t = t.loc
  let txt t = t.txt
end

let in_file = of_file
let in_file_line = of_file_line

module Private = struct
  module File_cache = File_cache
end
