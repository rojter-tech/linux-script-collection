#!/bin/bash
echo "Integer calculation example script"
echo ""
declare -i number1
declare -i number2
declare -i total
read -p "Insert first number: " number1
read -p "Insert second number: " number2
total=$number1*$number2
        echo "Product of first and second number is " $total

exit 0