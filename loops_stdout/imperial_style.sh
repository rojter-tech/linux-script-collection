#!/bin/bash

for_each_in_list () {

    for string in "a" "b" "c"
    do
        output=`echo ${string}`
        echo ${output}
        if [ ${output} == "b" ] ; then
            echo "do something"
        fi
    done

}
#for_each_in_list


while_reading_chunks () {
    command='ls -a'

    echo "from the $(echo $command) output:"
    $command

    for pr in "" "we have" ""; do echo ${pr}; done

    $command | while read chunk; do
        echo "this chunk: $chunk"
    done; echo ""

}
#while_reading_chunks


capture_stdout_to_var () {

    command='sed --help'

    stdout=$($command 2>&1)
    echo $stdout

}
#capture_stdout_to_var

external_screen="false"
read_stdout_then_match () {
    command='xrandr --output DP1 --mode 1920x1080'
    stdout=$($command 2>&1)
    notpresent="cannot find"

    if echo "$stdout" | grep -q "$notpresent"; then
        echo "There is no external screen matching the output mode"
    else
        external_screen="true"
    fi

}
read_stdout_then_match

echo $external_screen