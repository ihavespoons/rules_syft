# Anchore's Syft for Bazel
This project extends bazel with a toolchain for the use of the Syft commandline tool from Anchore


## Setup
See the **WORKSPACE setup** section of the [current release][releases].

[releases]: https://github.com/ihavespoons/rules_syft/releases

# Design
This ruleset was designed to add SBOM generation capability for [rules_oci](https://github.com/bazel-contrib/rules_oci).
The ultimate aim is to support the entire featureset offered by syft as well as continuing to match it.

# Usage
You can read more about how to consume this ruleset in the [docs section](docs/readme.md)


