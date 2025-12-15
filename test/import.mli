(*_********************************************************************************)
(*_  loc: Representing ranges of lexing positions from parsed files               *)
(*_  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

val print_dyn : Dyn.t -> unit

module List : sig
  include module type of struct
    include Stdlib.ListLabels
  end

  val init : int -> f:(int -> 'a) -> 'a t
end

module Ref : sig
  val set_temporarily : 'a ref -> 'a -> f:(unit -> 'b) -> 'b
end

module Sexp = Sexplib0.Sexp

module String : sig
  include module type of struct
    include Stdlib.StringLabels
  end
end

val require : bool -> unit
val require_does_raise : (unit -> 'a) -> unit
