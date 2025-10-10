(lang dune 3.17)

(name loc)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin <opensource@mbarbin.org>")

(source
 (github mbarbin/loc))

(documentation "https://mbarbin.github.io/loc/")

;; The value for the [implicit_transitive_deps] option is set during the CI
;; depending on the OCaml compiler version.
;;
;; This will be set to [false] iif [ocaml-version >= 5.2].
;;
;; For packaging purposes with older ocaml, it is simpler atm if the option is
;; set to [true] in the main branch.
;;
;; See: [.github/workflows/edit_dune_project_dot_ml].

(implicit_transitive_deps true)

(package
 (name loc)
 (synopsis "Representing ranges of lexing positions from parsed files")
 (depends
  (ocaml
   (>= 4.14))
  (fpath
   (>= 0.7.3))
  (sexplib0
   (>= v0.16))
  (stdune
   (>= 3.17))))

(package
 (name loc-tests)
 (synopsis "Tests for loc")
 (depends
  (ocaml
   (>= 4.14))
  (dune
   (< 3.20))
  (base
   (>= v0.16))
  (expect_test_helpers_core
   (>= v0.16))
  (fpath
   (>= 0.7.3))
  (loc
   (= :version))
  (ppx_compare
   (>= v0.16))
  (ppx_enumerate
   (>= v0.16))
  (ppx_expect
   (>= v0.16))
  (ppx_hash
   (>= v0.16))
  (ppx_here
   (>= v0.16))
  (ppx_let
   (>= v0.16))
  (ppx_sexp_conv
   (>= v0.16))
  (ppx_sexp_value
   (>= v0.16))
  (ppxlib
   (>= 0.33))
  (stdune
   (>= 3.17))))

(package
 (name loc-dev)
 (synopsis "Package to regroup dev targets, documentation, and more")
 (allow_empty)
 (depends
  (ocaml
   (>= 4.14))
  (dune
   (< 3.20))
  (ocamlformat
   (= 0.27.0))
  (base
   (>= v0.16))
  (bisect_ppx
   (>= 2.8.3))
  (expect_test_helpers_core
   (>= v0.16))
  (fpath
   (>= 0.7.3))
  (loc
   (= :version))
  (loc-tests
   (= :version))
  (ppx_compare
   (>= v0.16))
  (ppx_enumerate
   (>= v0.16))
  (ppx_expect
   (>= v0.16))
  (ppx_hash
   (>= v0.16))
  (ppx_here
   (>= v0.16))
  (ppx_js_style
   (>= v0.16))
  (ppx_let
   (>= v0.16))
  (ppx_sexp_conv
   (>= v0.16))
  (ppx_sexp_value
   (>= v0.16))
  (ppxlib
   (>= 0.33))
  (stdune
   (>= 3.17))
  (sherlodoc
   (and
    :with-doc
    (>= 0.2)))))
