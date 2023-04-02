#! /bin/bash
for key1 in "zero" "one" "two" "three" "four" "five"
do
    for key2 in "zero" "one" "two" "three" "four" "five"
        do
            mkdir -p "level_${key1}" && touch ./"level_${key1}"/"${key1}_${key2}.lua"
        done
done
