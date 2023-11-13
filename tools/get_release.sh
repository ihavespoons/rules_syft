#!/usr/bin/env bash
set -o pipefail -o errexit -o nounset

VERSION="0.96.0"

PLATFORMS=("darwin_amd64" "darwin_arm64" "linux_amd64" "linux_arm64")
url="https://github.com/anchore/syft/releases/download/vVERSIONSTRING/syft_VERSIONSTRING_PLATFORM.tar.gz"
windows_url="https://github.com/anchore/syft/releases/download/vVERSIONSTRING/syft_VERSIONSTRING_windows_amd64.zip"

for platform in "${PLATFORMS[@]}"; do
  INTERIM="${url/PLATFORM/$platform}"
  echo ${INTERIM//VERSIONSTRING/$VERSION}
  wget -q -O syft.tar.gz ${INTERIM//VERSIONSTRING/$VERSION}
  shasum -b -a 384 syft.tar.gz | awk '{ print $1 }' | xxd -r -p | base64
  rm -rf syft.tar.gz
done

echo ${windows_url//VERSIONSTRING/$VERSION}
wget -q -O syft.zip ${windows_url//VERSIONSTRING/$VERSION}
shasum -b -a 384 syft.zip | awk '{ print $1 }' | xxd -r -p | base64
rm syft.zip

