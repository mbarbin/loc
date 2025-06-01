(lang dune 3.17)

(name loc)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin <opensource@mbarbin.org>")

(source
 (github mbarbin/loc))

(documentation "https://mbarbin.github.io/loc/")

;; The value for the [implicit_transtive_deps] option is set during the CI
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
  (ocamlformat
   (and
    :with-dev-setup
    (= 0.27.0)))
  (base
   (and
    (>= v0.16)
    (< v0.18)))
  (bisect_ppx
   (and
    :with-dev-setup
    (>= 2.8.3)))
  (expect_test_helpers_core
   (and
    (>= v0.16)
    (< v0.18)))
  (fpath
   (>= 0.7.3))
  (loc
   (= :version))
  (ppx_compare
   (and
    (>= v0.16)
    (< v0.18)))
  (ppx_enumerate
   (and
    (>= v0.16)
    (< v0.18)))
  (ppx_expect
   (and
    (>= v0.16)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.16)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.16)
    (< v0.18)))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.16)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.16)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.16)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.16)
    (< v0.18)))
  (ppxlib
   (>= 0.33))
  (stdune
   (>= 3.17))
  (sherlodoc
   (and
    :with-doc
    (>= 0.2)))))
