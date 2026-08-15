# ---
# title: justfile for fancter
# ---

# ---

set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

root := justfile_directory()
latexmkrc := root / ".latexmkrc"
examples := root / "examples"
build-dir := "build"

# Shows available recipes
default:
    @just --list --unsorted

# Prepares build directory
prepare:
    mkdir -p {{build-dir}}

# Compiles all examples/<slug>/main.tex into build/<slug>.pdf
compile: prepare
    #!/usr/bin/env bash
    shopt -s nullglob
    for main in "{{examples}}"/*/main.tex; do
        slug="$(basename "$(dirname "${main}")")"
        latexmk -cd -r "{{latexmkrc}}" -jobname="${slug}" "${main}"
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
