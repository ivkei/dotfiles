#!/bin/bash

nvtop -s | grep "gpu_util" | awk '{print $2}' | sed "s/[%, \\\"]//g"
