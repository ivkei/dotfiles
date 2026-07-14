#!/bin/bash

#grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f%%", usage}'
top -b -n 1 | grep '^%Cpu' | tail -n 1 | awk '{printf "%.0f%%", 100 - $8}'
