#!/bin/bash
sudo apt install jq
X=($@)
export GENERATED_ARRAY=$(jq --compact-output --null-input '$ARGS.positional' --args -- ""${X[@]}"")
echo $GENERATED_ARRAY > regions.txt