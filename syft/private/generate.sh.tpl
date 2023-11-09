#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly SYFT="{{syft}}"
readonly TARBALL="{{tarball}}"
readonly TYPE="{{type}}"
readonly SBOM="{{sbom}}"


exec "${SYFT}" "${TARBALL}" --output "${TYPE}"="${SBOM}"