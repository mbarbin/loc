(** A type used to decorate AST nodes built by parser so as to allow located
    error messages. *)

type t = Stdune.Loc.t

val equal : t -> t -> bool
val sexp_of_t : t -> Sexp.t

(** By default set to [false], this may be temporarily turned to [true] to
    operates some comparison that ignores all locations. Beware, when this is
    [true], [equal t1 t2] returns [true] for any locs. *)
val equal_ignores_locs : bool ref

(** By default set to [false], this may be temporarily turned to [true] to
    inspect positions in the dump of a program. *)
val include_sexp_of_locs : bool ref

(** To be called in the right hand side of a Menhir rule, using the [$loc]
    special keyword provided by Menhir. For example:

    {v
     ident:
      | ident=IDENT { Loc.create $loc }
     ;
    v} *)
val create : Lexing.position * Lexing.position -> t

val of_pos : Lexing.position -> t

(** Build the first line of error messages to produce to stderr using the same
    syntax as used by the OCaml compiler. If your editor has logic to recognize
    it, it will allow to jump to the source file. *)
val to_string : t -> string

val to_file_colon_line : t -> string
val dummy_pos : t
val in_file : path:Fpath.t -> t
val in_file_at_line : path:Fpath.t -> line:int -> t

(** Same as [dummy_pos] but try and keep the original path. *)
val with_dummy_pos : t -> t

val path : t -> Fpath.t
val line : t -> int
val start_pos_cnum : t -> int
val stop_pos_cnum : t -> int

module Lexbuf_loc : sig
  type t = Stdune.Lexbuf.Loc.t =
    { start : Lexing.position
    ; stop : Lexing.position
    }

  val equal : t -> t -> bool
end

val to_lexbuf_loc : t -> Lexbuf_loc.t
val start_pos : t -> Lexing.position
val stop_pos : t -> Lexing.position

(** {1 Utils on offsets and ranges} *)

module Offset : sig
  (** Number of bytes from the beginning of the input. The first byte has offset
      [0]. *)
  type t = int

  val equal : t -> t -> bool
  val sexp_of_t : t -> Sexp.t
  val of_source_code_position : Lexing.position -> t
end

val start_offset : t -> Offset.t
val stop_offset : t -> Offset.t

module Range : sig
  (** A range refers to a chunk of the file, from start (included) to stop
      (excluded). *)
  type t =
    { start : Offset.t
    ; stop : Offset.t
    }

  val equal : t -> t -> bool
  val sexp_of_t : t -> Sexp.t
  val of_source_code_positions : start:Lexing.position -> stop:Lexing.position -> t

  (** Build the range that covers both inputs, and what may be in between. *)
  val interval : t -> t -> t
end

val range : t -> Range.t
