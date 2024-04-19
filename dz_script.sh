#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Использование: $0 <входная_директория> <выходная_директория>"
    exit 1
fi

INPUT_DIR=$1
OUTPUT_DIR=$2

if [ ! -d "$INPUT_DIR" ]; then
    echo "Входная директория не существует: $INPUT_DIR"
    exit 1
fi


mkdir -p "$OUTPUT_DIR"

copy_files_with_unique_names() {
    local src_file=$1
    local dest_dir=$2
    local base_name=$(basename "$src_file")

    local dest_file_path="$dest_dir/$base_name"
    local file_counter=1

    while [ -f "$dest_file_path" ]; do
        dest_file_path="$dest_dir/${base_name%.*}_$file_counter.${base_name##*.}"
        ((file_counter++))
    done

    cp "$src_file" "$dest_file_path"
}

export -f copy_files_with_unique_names

find "$INPUT_DIR" -type f -exec bash -c 'copy_files_with_unique_names "$0" "$1"' {} "$OUTPUT_DIR" \;

echo "Файлы успешно скопированы в: $OUTPUT_DIR"
