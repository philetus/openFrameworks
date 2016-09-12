#!/bin/bash

export LC_ALL=C

for category in $( find ../../examples/ -maxdepth 1 -type d )
do
    echo category $category
    echo category $category >> log.txt

    if [ "$category" = "../../examples/android" -o "$category" = "../../examples/ios" -o "$category" = "../../examples/" ]; then
        echo ignoring $category
        echo ignoring $category >> log.txt
        continue
    fi

    for example in $( find "$category" -maxdepth 1 -type d | grep -v osx )
    do
        if [ "$example" = "$category" ]; then
            continue
        fi

        echo "-----------------------------------------------------------------"
        echo "copying default make to " $example

        cp -n ../templates/osx/Makefile $example
        cp -n ../templates/osx/config.make $example

        echo -----------------------------------------------------------------
        echo building  $example

        #projectGenerator .
        make Debug -j2 -C "$example"
        ret=$?
        if [ $ret -ne 0 ]; then
            echo error compiling $example
            echo error compiling $example >> log.txt
        fi
        make Release -j2 -C "$example"
        ret=$?
        if [ $ret -ne 0 ]; then
            echo error compiling $example
            echo error compiling $example >> log.txt
        fi

        echo -----------------------------------------------------------------
        echo
    done
done
