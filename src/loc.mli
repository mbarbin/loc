(** A library to manipulate code locations, typically to decorate AST nodes
    built by parser so as to allow located error messages. *)

(** An immutable value representing a range of characters in a file. *)
type t

(** {1 Dumping locations} *)

(** By default, locations are hidden and rendered as the [Atom "_"]. Locations
    are typically brittle, and not always interesting when inspecting the
    nodes of an AST. You may however set {!val:include_sexp_of_locs} to
    [true] - then {!val:sexp_of_t} will show actual locations. *)
val sexp_of_t : t -> Sexp.t

(** By default set to [false], this may be temporarily turned to [true] to
    inspect locations in the dump of an AST. *)
val include_sexp_of_locs : bool ref

(** {1 Comparing locations} *)

(** [equal t1 t2] returns [true] if t1 and t2 identify the same location.
    Beware, it is possible to deactivate comparison of locs by setting
    {!val:equal_ignores_locs} to [true], in which case {!val:equal} will
    always return [true]. *)
val equal : t -> t -> bool

(** By default set to [false], this may be temporarily turned to [true] to
    operates some comparison that ignores all locations. When this is [true],
    {!val:equal} returns [true] for any locs. *)
val equal_ignores_locs : bool ref

(** {1 Creating locations} *)

(** To be called in the right hand side of a Menhir rule, using the [$loc]
    special keyword provided by Menhir. For example:

    {v
     ident:
      | ident=IDENT { Loc.create $loc }
     ;
    v} *)
val create : Lexing.position * Lexing.position -> t

(** To be used with a [Lexing.position], including for example:

    {[
      Loc.of_position [%here]
    ]} *)
val of_position : Lexing.position -> t

(** To be used with the [__POS__] special construct. For example:

    {[
      Loc.of_pos __POS__
    ]} *)
val of_pos : string * int * int * int -> t

(** Build a location from the current internal state of the [lexbuf]. *)
val of_lexbuf : Lexing.lexbuf -> t

(** Build a location identifying the file as a whole. This is a practical
    location to use when it is not possible to build a more precise location
    rather than the entire file. *)
val of_file : path:Fpath.t -> t

(** [none] is a special value to be used when no location information is available. *)
val none : t

module File_cache : sig
  (** When locations are created manually, such as from a given line number, to
      compute all the actual positions and offsets we need to access the
      original contents of the file and locate new lines characters in it. This
      cache serves this purpose. *)

  type t

  (** Return the path that was used to create the cache. *)
  val path : t -> Fpath.t

  (** Create a cache from the name of a file and its contents. *)
  val create : path:Fpath.t -> file_contents:string -> t
end

(** Create a location that covers the entire line [line] of the file. Lines
    start at [1]. Raises [Invalid_argument] if the line overflows. *)
val of_file_line : file_cache:File_cache.t -> line:int -> t

(** {1 Getters} *)

(** [is_none loc] is true when [loc] is [none], and [false] otherwise. *)
val is_none : t -> bool

(** Build the first line of error messages to produce to stderr using the same
    syntax as used by the OCaml compiler. If your editor has logic to recognize
    it, it will allow to jump to the source file. *)
val to_string : t -> string

(** This builds a short string representation for use in tests or quick debug. *)
val to_file_colon_line : t -> string

(** Retrieves the name of the file that contains the location. *)
val path : t -> Fpath.t

(** Retrieve the line number from the start position of the given location. Line
    numbers start at line 1. *)
val start_line : t -> int

(** {1 Lexbuf locations} *)

module Lexbuf_loc : sig
  type t =
    { start : Lexing.position
    ; stop : Lexing.position
    }
end

(** Convert between [Lexbuf_loc] and [t]. *)

val to_lexbuf_loc : t -> Lexbuf_loc.t
val of_lexbuf_loc : Lexbuf_loc.t -> t

(** Access the [start] (included) and [stop] (excluded) positions of a location,
    expressed as lexing positions. *)

val start : t -> Lexing.position
val stop : t -> Lexing.position

(** {1 Utils on offsets and ranges} *)

module Offset : sig
  (** Number of bytes from the beginning of the input. The first byte has offset
      [0]. Such offset is named [pos_cnum] in the [Lexing.position] terminology. *)
  type t = int

  val equal : t -> t -> bool
  val sexp_of_t : t -> Sexp.t

  (** Reading the [pos_cnum] of a lexing position. *)
  val of_position : Lexing.position -> t

  (** Rebuild the position from a file at the given offset. Raises
      [Invalid_argument] if [offset < 0] or if [offset > file.length]. The
      end-of-file position [file.length] is purposely allowed in order for the
      resulting position to be used as [stop] value for a range covering the
      file until its last character (which may occasionally be useful). *)
  val to_position : t -> file_cache:File_cache.t -> Lexing.position
end

val start_offset : t -> Offset.t
val stop_offset : t -> Offset.t

(** A convenient wrapper to build a loc from the position at a given offset. See
    {!val:Offset.to_position}. *)
val of_file_offset : file_cache:File_cache.t -> offset:Offset.t -> t

module Range : sig
  (** A range refers to a chunk of the file, from start (included) to stop
      (excluded). *)
  type t =
    { start : Offset.t
    ; stop : Offset.t
    }

  val equal : t -> t -> bool
  val sexp_of_t : t -> Sexp.t
  val of_positions : start:Lexing.position -> stop:Lexing.position -> t

  (** Build the range that covers both inputs, and what may be in between. *)
  val interval : t -> t -> t
end

val range : t -> Range.t

(** A convenient wrapper to build a loc from a file range. Raises
    [Invalid_argument] if the range is not valid for that file. See
    {!val:Offset.to_position}. *)
val of_file_range : file_cache:File_cache.t -> range:Range.t -> t

module Txt : sig
  (** When the symbol you want to decorate is not already an argument in a
      record, it may be convenient to use this type as a standard way to
      decorate a symbol with a position.

      Using [Loc.t] or ['a Loc.Txt.t] are two different styles to decorate a
      symbol, you may choose one depending on the context.

      An example using [Loc.t]:

      {[
        type t =
          | T of { loc : Loc.t ; a : A.t; b : B.t; ... }
      ]}

      An example using ['a Loc.Txt.t]:

      {[
        type t = A.t Loc.Txt.t list
      ]} *)

  type loc := t

  type 'a t =
    { txt : 'a
    ; loc : loc
    }

  (** It is possible to ignore the locations by setting
      {!val:Loc.equal_ignores_locs} to [true]. *)
  val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

  (** By default locations are not shown. To include the locations set
      {!val:Loc.include_sexp_of_locs} to [true]. *)
  val sexp_of_t : ('a -> Sexp.t) -> 'a t -> Sexp.t

  (** To be called in the right hand side of a Menhir rule, using the [$loc]
      special keyword provided by Menhir. For example:

      {[
        ident:
         | ident=IDENT { Loc.Txt.create $loc ident }
        ;
      ]} *)
  val create : Lexing.position * Lexing.position -> 'a -> 'a t

  (** Build a new node where the symbol has been mapped, keeping the original
      location. *)
  val map : 'a t -> f:('a -> 'b) -> 'b t

  (** Build a [t] where [t.loc = Loc.none]. *)
  val no_loc : 'a -> 'a t

  (** {1 Fields getters} *)

  val loc : _ t -> loc
  val txt : 'a t -> 'a
end

(** {1 Deprecated aliases}

    This part of the API will be deprecated in a future version. *)

(** This was renamed [of_file]. *)
val in_file : path:Fpath.t -> t
[@@ocaml.deprecated "[since 2025-03] Use [of_file]. Hint: Run [ocamlmig migrate]"]
[@@migrate { repl = of_file }]

(** This was renamed [of_file_line]. *)
val in_file_line : file_cache:File_cache.t -> line:int -> t
[@@ocaml.deprecated "[since 2025-03] Use [of_file_line]. Hint: Run [ocamlmig migrate]"]
[@@migrate { repl = of_file_line }]

(** {1 Private} *)

module Private : sig
  (** Exported for testing only.

      This module is meant for tests only. Its signature may change in breaking ways
      at any time without prior notice, and outside of the guidelines set by
      semver. Do not use. *)

  module File_cache : sig
    type t = File_cache.t

    val sexp_of_t : t -> Sexp.t
  end
end
