(*********************************************************************************)
(*  loc: Representing ranges of lexing positions from parsed files               *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let print pp = Format.printf "%a@." Pp.to_fmt pp
let print_dyn dyn = print (Dyn.pp dyn)

module List = struct
  include Stdlib.ListLabels

  let init len ~f = init ~len ~f
end

module Ref = struct
  let set_temporarily t a ~f =
    let x = !t in
    t := a;
    Fun.protect ~finally:(fun () -> t := x) f
  ;;
end

module Sexp = Sexplib0.Sexp

module String = struct
  include StringLabels
end

let require cond = if not cond then failwith "Required condition does not hold."

let require_does_raise f =
  match f () with
  | _ -> failwith "Did not raise."
  | exception e -> print_endline (Printexc.to_string e)
;;
