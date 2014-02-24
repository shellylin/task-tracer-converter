#!/bin/bash

DEFAULT_MMAPS_DIRECTORY="./mmaps"
DEFAULT_MMAP_FILE="./mmap"

if [[ $(find . -name mmap) ]]; then
  echo "Remove old data."
  rm mmap
fi

for file in ${DEFAULT_MMAPS_DIRECTORY}/mmaps_*; do
  echo "Read ${file}"
  IFS='/' read -a path <<< "${file}"
  pid=$(echo ${path[${#path[@]}-1]} | tr -d "mmaps_")

  line=$(grep libxul.so $file -m 1)
  IFS=' ' read -a array <<< "${line}"
  IFS='-' read -a address <<< "${array[0]}"

  echo "${pid} ${address[0]}" >> ${DEFAULT_MMAP_FILE}
done

echo "Done. Write to $DEFAULT_MMAP_FILE"
