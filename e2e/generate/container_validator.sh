#!/usr/bin/env bash

set -euo pipefail

minimumsize=9000

actualsize=$(wc -c <"$1")

if [ $actualsize -ge $minimumsize ]; then
    if grep -wq "cpe:2.3:a:adduser:adduser:3.118ubuntu5:*:*:*:*:*:*:*" $1; then
      exit 0
    else
      exit 1
    fi
else
    exit 1
fi