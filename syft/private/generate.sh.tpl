#!/usr/bin/env bash

set -euo pipefail

readonly SYFT="{{syft}}"
readonly IMAGE="{{image}}"
readonly TYPE="{{type}}"
readonly SBOM="{{sbom}}"

exec "${SYFT}" "${IMAGE}" --output "${TYPE}"="${SBOM}"