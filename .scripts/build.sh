#!/usr/bin/env bash

set -e

list=(
  'https://raw.githubusercontent.com/BambooEngine/ibus-bamboo/refs/heads/master/data/vietnamese.cm.dict'
  'https://raw.githubusercontent.com/1ec5/hunspell-vi/refs/heads/main/dictionaries/vi-DauMoi.dic'
  # 'https://raw.githubusercontent.com/rockkhuya/DongDu/refs/heads/master/bin/data/VNsyl.txt'
  # 'https://raw.githubusercontent.com/miendinh/VietnameseOCR/refs/heads/master/dict/vi_VN.dic'
)

TMPFILE=$(mktemp)
TMPFILE_SORTED=$(mktemp)
trap 'rm -f "$TMPFILE" "$TMPFILE_SORTED"' EXIT INT HUP TERM

for url in "${list[@]}"; do
  curl -fsSL "$url" >>"$TMPFILE"
done

wait

sort "$TMPFILE" | uniq >"$TMPFILE_SORTED"

mkdir -p 'spell'

vim -u NONE -e -c "mkspell! spell/vi ${TMPFILE_SORTED}" -c q
