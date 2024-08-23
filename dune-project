(lang dune 3.16)

(name loc)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin")

(source
 (github mbarbin/loc))

(documentation "https://mbarbin.github.io/loc/")

(package
 (name loc0)
 (synopsis "Representing ranges of lexing positions from parsed files")
 (depends
  (ocaml
   (>= 5.2))
  (bisect_ppx
   (and
    :dev
    (>= 2.8.3)))
  (fpath
   (>= 0.7.3))
  (ppx_js_style
   (and
    :dev
    (>= v0.17)
    (< v0.18)))
  (sexplib0
   (and
    (>= v0.17)
    (< v0.18)))
  (stdune
   (>= 3.16))))

(package
 (name loc-tests)
 (synopsis "Tests for loc")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (and
    (>= v0.17)
    (< v0.18)))
  (bisect_ppx
   (and
    :dev
    (>= 2.8.3)))
  (expect_test_helpers_core
   (and
    (>= v0.17)
    (< v0.18)))
  (fpath
   (>= 0.7.3))
  (loc0
   (= :version))
  (ppx_compare
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_enumerate
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_expect
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_js_style
   (and
    :dev
    (>= v0.17)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.17)
    (< v0.18)))
  (ppxlib
   (>= 0.33))
  (stdune
   (>= 3.16))))
