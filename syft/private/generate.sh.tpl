#!/usr/bin/env bash

set -euo pipefail

readonly SYFT="{{syft}}"
readonly TARBALL="{{tarball}}"
readonly TYPE="{{type}}"
readonly SBOM="{{sbom}}"


exec "${SYFT}" "${TARBALL}" --output "${TYPE}"="${SBOM}"