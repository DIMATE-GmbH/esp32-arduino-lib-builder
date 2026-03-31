#!/usr/bin/env bash

# This script simply creates a distribution of the ESP32 / Pico32 Arduino
# libraries necessary for our use case with the ESP32 Pico D4 SoC.

source build.sh \
  -e \
  -t esp32 \
  -D error \
  -A patch-3.3.7 \
  -I release/v5.5
