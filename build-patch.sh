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

pushd out/tools/esp32-arduino-libs

ARCHIVE="esp32-libs-$TAG_ESP_IDF-$TAG_ARDUINO_ESP32.zip"

rm -f $ARCHIVE
zip -r $ARCHIVE \
  esp32/ \
  package.json \
  tools.json \
  versions.txt

sha256 $ARCHIVE

popd
