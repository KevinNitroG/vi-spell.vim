#!/usr/bin/env bash

set -e

list=(
  'https://raw.githubusercontent.com/BambooEngine/ibus-bamboo/refs/heads/master/data/vietnamese.cm.dict'
  'https://raw.githubusercontent.com/1ec5/hunspell-vi/refs/heads/main/dictionaries/vi-DauMoi.dic'
  # 'https://raw.githubusercontent.com/rockkhuya/DongDu/refs/heads/master/bin/data/VNsyl.txt'
  # 'https://raw.githubusercontent.com/miendinh/VietnameseOCR/refs/heads/master/dict/vi_VN.dic'
)

tmpdir=$(mktemp -d)
merged_file="merged.dict"

for url in "${list[@]}"; do
  curl -fsSL "$url" >>"$tmpdir/vi.dic"
done

wait

sort "$tmpdir/vi.dic" | uniq >"$merged_file"

mkdir -p 'spell'

vim -u NONE -e -c "mkspell! spell/vi ${merged_file}" -c q

rm -rf "$tmpdir"
