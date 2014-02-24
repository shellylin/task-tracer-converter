#!/bin/bash

DEFAULT_MMAP_FILE="./mem_offset"
DEFAULT_SYMBOL_FILE="./symbol"

echo "Reading memory maps to get memory offset for each process."

if [ "$1" == "" ]; then
  echo "Usage ./prepare-data.sh MMAPS_PATH OBJDIR_PATH"
	exit
fi

if [ $(find . -name mmap) ]; then
  echo "  Remove old intermediate file."
  rm mmap
fi

for file in $1/mmaps_*; do
  echo "  Reading ${file}"
  IFS='/' read -a path <<< "${file}"
  pid=$(echo ${path[${#path[@]}-1]} | tr -d "mmaps_")

  line=$(grep libxul.so $file -m 1)
  IFS=' ' read -a array <<< "${line}"
  IFS='-' read -a address <<< "${array[0]}"

  echo "${pid} ${address[0]}" >> ${DEFAULT_MMAP_FILE}
done
printf "Write to \"${DEFAULT_MMAP_FILE}\".\n\n"

if [ "$2"  == "" ]; then
  echo "Usage: ./prepare-data.sh MMAPS_PATH OBJDIR_PATH"
  exit
fi

path=$2/dist/lib/libxul.so
printf "Extracting symbols from\n  ${path}\n"
nm -a ${path}  | grep _ZTV | c++filt | sort > $DEFAULT_SYMBOL_FILE
echo "Write to \"${DEFAULT_SYMBOL_FILE}\"."

printf "\nDone.\n"
