#!/bin/bash

export gomodir="$HOME/.gomo"

mkdir $gomodir 2> /dev/null
mkdir $gomodir/bin 2> /dev/null

ln -sf $PWD/scripts/gomo.sh $gomodir/bin/gomo

echo
echo Gomo installed!
echo Make sure to add \"$gomodir/bin\" to your \$PATH variable.
echo
