#!/usr/bin/env bash

# This script simply creates a distribution of the ESP32 / Pico32 Arduino
# libraries necessary for our use case with the ESP32 Pico D4 SoC.

VERSION_ESP_IDF="5.5"
VERSION_ARDUINO_ESP32="3.3.7"

source build.sh \
  -t esp32 \
  -D error \
  -A patch-$VERSION_ARDUINO_ESP32 \
  -I release/v$VERSION_ESP_IDF

COMMIT_SHORT_ARDUINO_ESP32="$(git -C $ARDUINO_ESP32_PATH log --format="%h" -n 1)"
COMMIT_SHORT_ESP32_ARDUINO_LIB_BUILDER="$(git log --format="%h" -n 1)"


# 1) Build esp32-arduino-lib-builder-*.zip for the actual "package_index.json"
#    that only contains the limited content.

FOLDER="esp32-arduino-lib-builder-$TAG_ARDUINO_ESP32-$COMMIT_SHORT_ARDUINO_ESP32-$COMMIT_SHORT_ESP32_ARDUINO_LIB_BUILDER"
ARCHIVE="$FOLDER.zip"

rm -rf $FOLDER
rm -f $ARCHIVE

mkdir $FOLDER

cp -a out/tools/esp32-arduino-libs/esp32/bin $FOLDER
cp -a out/tools/esp32-arduino-libs/esp32/dio_qspi $FOLDER
cp -a out/tools/esp32-arduino-libs/esp32/flags $FOLDER
cp -a out/tools/esp32-arduino-libs/esp32/include $FOLDER
cp -a out/tools/esp32-arduino-libs/esp32/ld $FOLDER
cp -a out/tools/esp32-arduino-libs/esp32/lib $FOLDER
cp -a out/tools/esp32-arduino-libs/esp32/qio_qspi $FOLDER
cp out/tools/esp32-arduino-libs/esp32/sdkconfig $FOLDER
cp out/tools/esp32-arduino-libs/versions.txt $FOLDER

zip -r $ARCHIVE $FOLDER >/dev/null

sha256 $ARCHIVE
stat -f%z $ARCHIVE


# 2) Build esp32-libs-*.zip for the templated "*index.json" file that is used
#    by this build process itself (!?) for whatever reason.

FOLDER="esp32-libs-$TAG_ESP_IDF-$TAG_ARDUINO_ESP32"
ARCHIVE="$FOLDER.zip"

rm -rf $FOLDER
rm -f $ARCHIVE

mkdir $FOLDER

cp -a out/tools/esp32-arduino-libs/esp32 $FOLDER
cp out/tools/esp32-arduino-libs/package.json $FOLDER
cp out/tools/esp32-arduino-libs/tools.json $FOLDER
cp out/tools/esp32-arduino-libs/versions.txt $FOLDER

zip -r $ARCHIVE $FOLDER >/dev/null

sha256 $ARCHIVE
stat -f%z $ARCHIVE
