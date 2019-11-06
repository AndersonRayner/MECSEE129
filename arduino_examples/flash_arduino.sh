#!/bin/bash
# Script for flashing my Arduino code onto the Arduino

BOARD="arduino:avr:mega:cpu=atmega2560"
PORT="ttyACM0"
arduino --board $BOARD --port /dev/$PORT --upload blink/blink.ino

exit

PORT="$(readlink /dev/ttyArduino)"
arduino --board $BOARD --port /dev/$PORT --upload publisher_example/publisher_example.ino

