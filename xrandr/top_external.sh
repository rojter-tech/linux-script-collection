#!/bin/sh
# HiDPI Solution
#
# Script for automatic scaling of one or two screen displays in X
# using a scale factor for the primary display
#
# Written by Daniel Reuter

# # # # # # # # # # Base configuration  # # # # # # # # # #
WIDTH_MAIN=3240;                       WIDTH_EXT=1920;    #
HEIGHT_MAIN=2160;                      HEIGHT_EXT=1080;   #
# # # # # # # # # # # # Default # # # # # # # # # # # # # #
SCALE_FACTOR_MAIN=0.65                                         #
LB=0.5; UB=1 # Lower and upper boundaries                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


read_user_input() 
{
    # Main scale factor
    read -p "Input main screen scale number (eg. 0.5, 0.75 or 1): " SCALE_INPUT
    
    if (( $(echo "$SCALE_INPUT >= $LB" |bc -l) )) && (( $(echo "$SCALE_INPUT <= $UB" |bc -l) )); then
        SCALE_FACTOR_MAIN=$SCALE_INPUT
    else
        echo "The number must lie betwen $LB and $UB"
        echo "Exiting ..."
    fi
}


set_scaling_properties()
{
    # External screen settings
    EXT_MODE=$(echo $WIDTH_EXT)x$(echo $HEIGHT_EXT);
    SCALE_FACTOR_EXT=$(awk "BEGIN {print ($WIDTH_MAIN/$WIDTH_EXT) * ($SCALE_FACTOR_MAIN)}");
    SCALE_SETTING_EXT=$SCALE_FACTOR_EXTx$SCALE_FACTOR_EXT;
    SCREEN_POS_EXT="0x0";

    # Main screen
    MAIN_MODE=$(echo $WIDTH_MAIN)x$(echo $HEIGHT_MAIN);
    SCALE_SETTING_MAIN=$(echo $SCALE_FACTOR_MAIN)x$(echo $SCALE_FACTOR_MAIN);
    NEW_WIDTH_MAIN=$(awk "BEGIN {print $WIDTH_MAIN * $SCALE_FACTOR_MAIN}");
    NEW_HEIGHT_MAIN=$(awk "BEGIN {print $HEIGHT_MAIN * $SCALE_FACTOR_MAIN}");
    NEW_MAIN_MODE=$(echo $NEW_WIDTH_MAIN)x$(echo $NEW_HEIGHT_MAIN);
    SCALED_HEIGHT_MAIN=$(awk "BEGIN {print $HEIGHT_EXT * $SCALE_FACTOR_EXT}");
    MAIN_SCREEN_POS=0x$SCALED_HEIGHT_MAIN;

    echo "Scaling main screen by $SCALE_FACTOR_MAIN" 
}


sleep_timer()
{
    echo "."
    sleep 0.3
    echo ".."
    sleep 0.3
    echo "..."
    sleep 0.3
}


external_exists ()
{
    command='xrandr --output DP1 --mode '$(echo $EXT_MODE)
    stdout=$($command 2>&1)
    notpresent="cannot find"

    if echo "$stdout" | grep -q "$notpresent"; then
        echo "There is no external screen matching the output mode"
        return 1
    else
        EXTERNAL_SCREEN="true"
        return 0
    fi
}


xrandr_external()
{
    # First clear settings ...
    xrandr \
    --output eDP1 --primary --mode $MAIN_MODE --rotate normal --pos 0x$HEIGHT_MAIN --scale 1x1 \
    --output DP1 --mode $EXT_MODE --rotate normal --pos $SCREEN_POS_EXT --scale 1x1
    # then execute scaling
    xrandr \
    --output eDP1 --primary --mode $MAIN_MODE --rotate normal --pos $MAIN_SCREEN_POS --scale $SCALE_SETTING_MAIN \
    --output DP1 --mode $EXT_MODE --rotate normal --pos $SCREEN_POS_EXT --scale $SCALE_SETTING_EXT
}


xrandr_no_external() 
{
    # First clear settings ...
    xrandr \
    --output eDP1 --primary --mode $MAIN_MODE --rotate normal --pos 0x0 --scale 1x1 --fb $MAIN_MODE
    # then execute scaling
    xrandr \
    --output eDP1 --primary --mode $MAIN_MODE --rotate normal --pos 0x0 --scale $SCALE_SETTING_MAIN --fb $NEW_MAIN_MODE
}


main() 
{
    read_user_input
    set_scaling_properties
    sleep_timer

    if external_exists; then
        echo "Found external, setting up both screens"
        echo "Scaling external screen by $SCALE_FACTOR_EXT" 
        echo "Setting main screen height position to $NEW_HEIGHT_MAIN" 
        xrandr_external
    else
        echo "Found no external, setting up only the internal screen"
        echo "Scaled main resolution: $NEW_MAIN_MODE"
        xrandr_no_external
    fi

    echo "done hopefully"
}


main