import argparse
import json
import os

MANIFEST_DATA = {
    "name": "framework-arduinoespressif32-libs-patch",
    "description": "Precompiled libraries for Arduino Wiring-based Framework, adjusted for the Espressif ESP32 / Pico32 SoC",
    "keywords": ["framework", "arduino", "espressif", "esp32"],
    "license": "LGPL-2.1-or-later",
    "repository": {
        "type": "git",
        "url": "https://github.com/DIMATE-GmbH/esp32-arduino-lib-builder",
    },
}


def main(dst_dir, tag_esp_idf, tag_arduino_esp32):
    manifest_file_path = os.path.join(dst_dir, "package.json")
    with open(manifest_file_path, "w", encoding="utf8") as fp:
        MANIFEST_DATA["version"] = f"{tag_esp_idf}-{tag_arduino_esp32}"
        json.dump(MANIFEST_DATA, fp, indent=2)

    print(f"Generated pioarduino manifest file '{manifest_file_path}'")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-o",
        "--dst-dir",
        dest="dst_dir",
        required=True,
        help="Destination folder where the 'package.json' manifest will be located",
    )
    parser.add_argument(
        "-t1",
        "--tag-esp-idf",
        dest="tag_esp_idf",
        required=True,
        help="ESP-IDF latest tag on branch",
    )
    parser.add_argument(
        "-t2",
        "--tag-arduino-esp32",
        dest="tag_arduino_esp32",
        required=True,
        help="Arduino ESP32 latest tag on branch",
    )
    args = parser.parse_args()

    main(args.dst_dir, args.tag_esp_idf, args.tag_arduino_esp32)
