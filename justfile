# ---
# title: justfile for fancter
# ---

# ---

#
# Convention: just = instantiation builds; make = TEXMF install.

# ---

set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

src-dir := "instantiations"
build-dir := "instantiations/build"

# Shows available recipes
default:
    @just --list --unsorted

# Prepare build directory
prepare:
    mkdir -p {{build-dir}}

# Compile all instantiations
compile: prepare
    #!/usr/bin/env bash
    cd "{{src-dir}}"
    for tex in *.tex; do
        latexmk -pdflatex -outdir=build "$tex"
    done

# Alias for compile
build: compile

# Removes intermediate files; keeps pdf/png/tex
clean:
    find {{build-dir}} -mindepth 1 \
        ! \( -iname "*.pdf" -o -iname "*.png" -o -iname "*.tex" -o -iname ".gitkeep" \) \
        -delete

# Wipes build directory except .gitkeep
reset:
    find {{build-dir}} -mindepth 1 ! -iname ".gitkeep" -delete
