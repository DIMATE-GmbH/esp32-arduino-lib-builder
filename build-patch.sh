#!/usr/bin/env bash

# This script simply creates a distribution of the ESP32 / Pico32 Arduino
# libraries necessary for our use case with the ESP32 Pico D4 SoC.

VERSION_ESP_IDF="5.5"
VERSION_ARDUINO_ESP32="3.3.7"

# Replace template with value in a file
function replaceStringInFile() {
    sed -ir "s#$2#$3#" $1
    rm "$1r"
}

function adjustSdkconfig() {
  replaceStringInFile "$1" \
    "CONFIG_ESP32_WIFI_ENABLED=y" \
    "CONFIG_ESP32_WIFI_ENABLED=n"
  
  replaceStringInFile "$1" \
    "CONFIG_ESP_WIFI_ENABLED=y" \
    "CONFIG_ESP_WIFI_ENABLED=n"
  
  replaceStringInFile "$1" \
    "CONFIG_WIFI_ENABLED=y" \
    "CONFIG_WIFI_ENABLED=n"
  
  replaceStringInFile "$1" \
    "CONFIG_BT_BLE_ENABLED=y" \
    "CONFIG_BT_BLE_ENABLED=n"
}

function adjustSdkConfigH() {
  replaceStringInFile "$1" \
    "CONFIG_ESP32_WIFI_ENABLED 1" \
    "CONFIG_ESP32_WIFI_ENABLED 0"
  
  replaceStringInFile "$1" \
    "CONFIG_ESP_WIFI_ENABLED 1" \
    "CONFIG_ESP_WIFI_ENABLED 0"
  
  replaceStringInFile "$1" \
    "CONFIG_WIFI_ENABLED 1" \
    "CONFIG_WIFI_ENABLED 0"
  
  replaceStringInFile "$1" \
    "CONFIG_BT_BLE_ENABLED 1" \
    "CONFIG_BT_BLE_ENABLED 0"
}

export EXTRA_CFLAGS="-DARDUINO_DISABLE_WIFI"
source build.sh \
  -t esp32 \
  -D error \
  -A patch-$VERSION_ARDUINO_ESP32 \
  -I release/v$VERSION_ESP_IDF

COMMIT_SHORT_ARDUINO_ESP32="$(git -C $ARDUINO_ESP32_PATH log --format="%h" -n 1)"
COMMIT_SHORT_ESP32_ARDUINO_LIB_BUILDER="$(git log --format="%h" -n 1)"

FOLDER="esp32-libs-$TAG_ARDUINO_ESP32-$COMMIT_SHORT_ARDUINO_ESP32-$COMMIT_SHORT_ESP32_ARDUINO_LIB_BUILDER"
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

adjustSdkconfig "$FOLDER/sdkconfig"
adjustSdkConfigH "$FOLDER/dio_qspi/include/sdkconfig.h"
adjustSdkConfigH "$FOLDER/qio_qspi/include/sdkconfig.h"

zip -r $ARCHIVE $FOLDER >/dev/null

sha256 $ARCHIVE
stat -f%z $ARCHIVE
