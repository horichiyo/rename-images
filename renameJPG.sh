#!/bin/bash
# set -e -o pipefail
####################################################
# Script name : renameJPG.sh
# Discription : *.JPGファイルのファイル名先頭に撮影日付を、拡張子の前に撮影したレンズの名前を付与するプログラム
# How to : 
#          実行前に `chmod +x ./renameJPG.sh` をして権限を与える。
#          任意のディレクトリでこのスクリプトを実行。
# Date : 2022/09/24
# Maker: horichiyo
####################################################

FLG=0

echo ---------- start rename all JPG files in `pwd` ----------

for file in *JPG
do
  EXIF=`identify -verbose ${file} | grep -e DateTime: -e LensModel:`
  FLG=$?
  if [ ${FLG} -ne 0 ]; then
    echo ---- error detected stop program. ----
    exit ${FLG}
  fi

  DATETIME=`echo ${EXIF} | awk '{print $2"_"$3}' | sed -e s/://g`
  FLG=$?
  if [ ${FLG} -ne 0 ]; then
    echo ---- error detected ----
    exit ${FLG}
  fi

  LENS=`echo ${EXIF} | awk '{for(i=5;i<NF;++i){printf("%s",$i)}print $NF}'`
  FLG=$?
  if [ ${FLG} -ne 0 ]; then
    echo ---- error detected ----
    exit ${FLG}
  fi

  AFTERNAME=${DATETIME}_${file%.*}_${LENS}.JPG
  FLG=$?
  if [ ${FLG} -ne 0 ]; then
    echo ---- error detected ----
    exit ${FLG}
  fi

  mv "${file}" "${AFTERNAME}"
  FLG=$?
  if [ ${FLG} -ne 0 ]; then
    echo ---- error detected ----
    exit ${FLG}
  fi

  echo ${file} → ${AFTERNAME}
done

echo ---------- end rename all .JPG files ----------
exit ${FLG}