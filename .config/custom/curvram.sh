#!/bin/bash

nvtop -s | grep "mem_util" | awk '{print $2}' | sed "s/[%, \\\"]//g"
