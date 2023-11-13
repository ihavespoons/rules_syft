#!/usr/bin/env bash

set -euo pipefail

echo $1
echo $2

if diff --brief <(sort "$1") <(sort "$2"); then
    exit 0
else
    exit 1
fi