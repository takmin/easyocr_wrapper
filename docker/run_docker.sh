#!/bin/bash

# 引数でパスを受け取る
INPUT_PATH=$1
JSON_PATH=$2
OUTPUT_PATH=$3
THRESHOLD="0.0"
if [ $# -ge 4 ]; then
    THRESHOLD=$4
fi

INPUT_ABS_PATH=$(readlink -f "$INPUT_PATH")
JSON_ABS_PATH=$(readlink -f "$JSON_PATH")
OUTPUT_ABS_PATH=$(readlink -f "$OUTPUT_PATH")

# Dockerコンテナを起動
docker run --gpus all -d --rm --name easyocr_runner --shm-size=256m -v ${INPUT_ABS_PATH}:/root/input_dir/ -v ${JSON_ABS_PATH}:/root/json_dir/ -v ${OUTPUT_ABS_PATH}:/root/output_dir/ -i easyocr-wrapper:latest

# コンテナ内でコマンドを実行
docker exec -it easyocr_runner bash -c "python /root/easyocr/proc_easyocr.py /root/input_dir /root/json_dir /root/output_dir --threshold ${THRESHOLD}"

# コンテナを停止して削除
docker stop easyocr_runner
