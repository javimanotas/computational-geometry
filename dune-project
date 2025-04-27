(lang dune 3.18)

(name computational-geometry)

(generate_opam_files false)

(source
 (github javimanotas/computational-geometry))

(authors "Javier Manotas Ruiz jmanotastuiz@gmail.com")

(maintainers "Javier Manotas Ruiz jmanotastuiz@gmail.com")

(license LICENSE)

(package
 (name computational-geometry)
 (allow_empty)
 (synopsis "implementation of computational geometry algorithmgs")
 (description "the main goal of this project is to implement and visualize 2D computational geometry algorithms along with the necessary data structures")
 (depends ocaml graphics))
