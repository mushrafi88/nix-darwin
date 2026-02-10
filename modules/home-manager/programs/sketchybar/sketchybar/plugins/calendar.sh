#!/bin/sh

sketchybar --set $NAME label="$(LC_TIME=en_US.UTF-8 date '+%d/%m %I:%M %p')" \
