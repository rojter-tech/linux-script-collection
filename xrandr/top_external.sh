#!/bin/sh

# Base configuration
MAIN_WIDTH=3240; MAIN_HEIGHT=2160
EXT_WIDTH=1920;  EXT_HEIGHT=1080;

# Main settings
read -p "Input main screen scale number (eg. 0.5, 1.5 or 2): " SCALENR_MAIN
SCALE_SETTING_MAIN=$SCALENR_MAINx$SCALENR_MAIN

# External settings
SCALENR_EXT=$(awk "BEGIN {print ($MAIN_WIDTH/$EXT_WIDTH) * ($SCALENR_MAIN)}")
SCALE_SETTING_EXT=$SCALENR_EXTx$SCALENR_EXT
EXT_SCREEN_POS=0x0

# Execute xrandr
MAIN_HEIGHT_POS=$(awk "BEGIN {print $EXT_HEIGHT * $SCALENR_EXT}")
MAIN_SCREEN_POS=0x$MAIN_HEIGHT_POS
echo "Scaling external screen by" $SCALENR_EXT
echo "Setting main screen height position to" $MAIN_HEIGHT_POS
echo "."
sleep 0.3
echo ".."
sleep 0.3
echo "..."

# First clear settings ...
xrandr \
--output eDP1 --primary --mode $(echo $MAIN_WIDTH)x$(echo $MAIN_HEIGHT) --rotate normal --pos 0x$MAIN_HEIGHT --scale 1x1 \
--output DP1 --mode $(echo $EXT_WIDTH)x$(echo $EXT_HEIGHT) --rotate normal --pos 0x0 --scale 1x1

# then execute xrandr
xrandr \
--output eDP1 --primary --mode $(echo $MAIN_WIDTH)x$(echo $MAIN_HEIGHT) --rotate normal --pos $MAIN_SCREEN_POS --scale $SCALE_SETTING_MAIN \
--output DP1 --mode $(echo $EXT_WIDTH)x$(echo $EXT_HEIGHT) --rotate normal --pos $EXT_SCREEN_POS --scale $SCALE_SETTING_EXT
