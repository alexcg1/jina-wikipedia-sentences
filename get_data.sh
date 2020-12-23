#!/bin/sh
DATASET="mikeortman/wikipedia-sentences"
DATA_DIR="data"
LINES=3000

if [ "$#" -ne 1 ]; then
  echo "bash ./get_data.sh [DATA_DIR]"
  exit 1
fi

if [ -d ${DATA_DIR} ]; then
  echo ${DATA_DIR}' exists, please remove it before running the script'
  exit 1
fi

mkdir -p ${DATA_DIR}
cd ${DATA_DIR}
kaggle datasets download -d ${DATASET}
unzip wikipedia-sentences.zip
shuf wikisent2.txt > shuffled.txt
tail -n ${LINES} shuffled.txt > input.txt
