#!/bin/sh
URL="https://storage.googleapis.com/kaggle-data-sets/46601/84740/bundle/archive.zip?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gcp-kaggle-com%40kaggle-161607.iam.gserviceaccount.com%2F20201212%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20201212T163654Z&X-Goog-Expires=259199&X-Goog-SignedHeaders=host&X-Goog-Signature=8c0fad8a3763528e4bda994448b2864c699243a7175d8542bb5f72aabd6c899ab2d5c3a19391ea11b27c0ce106c669281eb2503c5913e21d94e624c68fdb7a472a81e87d606b644e92a2c247453103283797bd6c6839fe263dca46a7a8a964a833fd7f759062c745708a0b0c51134d648541c956f53e79acafae2095a91636af5f3718fefbbee0642dc724afb5458d3a451ec76189ec0e5cbf25b355609fac9d828a78705bcffd049b8904ff5bf7b2d8e6e8582cdaa4f7c861e3907f0b26c14f255e141728ca4f344227293539a2c68d7c212942411b5f97f0004ccbedf99da2aa5cfc86f057327d9b425d89c08ce4cd4e9d54680caadf1407a55fdb2953b9e3"
TEST_DATA_DIR=$1
LINES=3000

if [ "$#" -ne 1 ]; then
  echo "bash ./get_data.sh [TEST_DATA_DIR]"
  exit 1
fi

if [ -d ${TEST_DATA_DIR} ]; then
  echo ${TEST_DATA_DIR}' exists, please remove it before running the script'
  exit 1
fi

mkdir -p ${TEST_DATA_DIR}
wget ${URL} -O data/wikipedia.zip
cd data
unzip wikipedia.zip
shuf wikisent2.txt
tail -n $(wikisent2.txt) > input.txt
#python prepare_data.py ${TEST_DATA_DIR}
