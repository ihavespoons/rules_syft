# Syft rules for [Bazel](https://bazel.build/)

This project extends bazel with a toolchain for the use of both the Syft and Grype toolchains from Anchore

## Setup

See the **WORKSPACE setup** section of the [current release][releases].

[releases]: https://github.com/ihavespoons/rules_syft/releases

# Design

This ruleset was initially designed to add SBOM generation capability for [rules_oci](https://github.com/bazel-contrib/rules_oci).
It now supports both using Syft and Grype per the public API below

# Usage and Public API

The public API is outlined below. It is currently barebones with more features being added in the near future.

## Syft

- [syft_sbom](docs/syft_sbom.md) - Generate an SBOM from a provided oci_image

## Grype
- [grype_report](docs/grype_report.md) - Generate CVE Report for an syft_sbom using grype binary that is pulled as a toolchain.
- [grype_test](docs/grype_test.md) - Scans a SBOM for known vulnerabilities and fails if vulnerabilities are found that exceed a certain severity.

### SBOM Generation Examples

- [Multiarch SBOM Generation](docs/multiarch-example.md) - Generate SBOM's for multiarch images then combine into an image index
