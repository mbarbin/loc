module T = struct
  type 'a t =
    { loc : Loc.t
    ; symbol : 'a
    }

  let sexp_of_t sexp_of_symbol { loc; symbol } : Sexp.t =
    List
      [ List [ Atom "loc"; Loc.sexp_of_t loc ]
      ; List [ Atom "symbol"; sexp_of_symbol symbol ]
      ]
  ;;
end

type 'a t = 'a T.t =
  { loc : Loc.t
  ; symbol : 'a
  }

let equal equal_symbol ({ loc = l1; symbol = s1 } as t1) ({ loc = l2; symbol = s2 } as t2)
  =
  t1 == t2 || (Loc.equal l1 l2 && equal_symbol s1 s2)
;;

let sexp_of_t sexp_of_a t =
  if !Loc.include_sexp_of_locs then T.sexp_of_t sexp_of_a t else sexp_of_a t.symbol
;;

let create loc symbol = { loc = Loc.create loc; symbol }
let to_string t = Loc.to_string t.loc
let map t ~f = { t with symbol = f t.symbol }
let with_dummy_pos symbol = { loc = Loc.dummy_pos; symbol }
let loc t = t.loc
let symbol t = t.symbol
