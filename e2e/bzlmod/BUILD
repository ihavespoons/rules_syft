"""Provides a simple way to test your rules as an external workspace.
Add a basic smoke-test target below.
"""

# buildifier: disable=out-of-order-load
load("@rules_oci//oci:defs.bzl", "oci_image")

# buildifier: disable=out-of-order-load
load("@rules_syft//syft:defs.bzl", "syft_generate_sbom")

# buildifier: disable=out-of-order-load
load("@bazel_skylib//rules:build_test.bzl", "build_test")

oci_image(
    name = "dockerhub_ubuntu",
    base = "@dockerhub_ubuntu",
)

syft_generate_sbom(
    name = "generate_sbom_imagedir",
    image = ":dockerhub_ubuntu",
    type = "cyclonedx-json",
)

build_test(
    name = "smoke_test",
    targets = [
        ":generate_sbom_imagedir",
    ],
)
