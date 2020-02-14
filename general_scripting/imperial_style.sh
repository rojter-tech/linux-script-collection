#!/bin/bash

for_each_in_list () 
{
    for string in "a" "b" "c"
    do
        output=`echo ${string}`
        echo ${output}
        if [ ${output} == "b" ] ; then
            echo "do something"
        fi
    done
}


while_reading_chunks ()
{
    command='ls -a'

    echo "from the $(echo $command) output:"
    $command

    for pr in "" "we have" ""; do echo ${pr}; done

    $command | while read chunk; do
        echo "this chunk: $chunk"
    done; echo ""
}


capture_stdout_to_var ()
{
    command='sed --help'

    stdout=$($command 2>&1)
    echo $stdout
}


read_stdout_then_match ()
{
    command='xrandr --output DP1 --mode 1920x1080'
    stdout=$($command 2>&1)
    notpresent="cannot find"

    if echo "$stdout" | grep -q "$notpresent"; then
        echo "There is no external screen matching the output mode"
        external_screen="false"
    else
        external_screen="true"
    fi

    echo $external_screen
}


incremental_loop()
{
    for i in {0..10..2}
    do
        echo "Shit nr $i"
    done
}


while_decremental_loop()
{
    declare -i counter
    counter=10
    while [ $counter -gt 2 ]; do
        echo "Counter is now $counter"
        counter=counter-1
    done
    echo ""
    echo "Because counter become $counter the loop exited"
}


#for_each_in_list
#while_reading_chunks
#capture_stdout_to_var
#read_stdout_then_match
#incremental_loop
while_decremental_loop