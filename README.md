# Syft for Bazel
This project extends bazel with a toolchain for the use of the Syft commandline tool from Anchore


## Setup
See the **WORKSPACE setup** section of the [current release][releases].

[releases]: https://github.com/ihavespoons/rules_syft/releases

# Design
This ruleset was initially designed to add SBOM generation capability for [rules_oci](https://github.com/bazel-contrib/rules_oci).
The ultimate aim is to support the entire featureset offered by syft as well as continuing to match it.

# Usage and Public API
The public API is outlined below. It is currently barebones with more features being added in the near future.

## SBOM Generation
* [syft_generate](docs/generate.md) - Generate an SBOM from a provided tarball


