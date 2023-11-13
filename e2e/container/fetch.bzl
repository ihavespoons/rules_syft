"""OCI base images used for testing.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_oci//oci:pull.bzl", "oci_pull")

def fetch_images():
    oci_pull(
        name = "chainguard_go",
        digest = "sha256:05c643e3683112900554f31bdfa7a351046d9ca77516af7366a8c276d1ec97f5",
        image = "cgr.dev/chainguard/go",
    )

    oci_pull(
        name = "chainguard_aws",
        digest = "sha256:2d7ec00ee706b99986b6eb9c24005bbd17bb76add1ec8a923e5dee8410f1552e",
        image = "cgr.dev/chainguard/aws-cli",
    )

    oci_pull(
        name = "dockerhub_ubuntu",
        digest = "sha256:c9cf959fd83770dfdefd8fb42cfef0761432af36a764c077aed54bbc5bb25368",
        image = "docker.io/library/ubuntu",
    )
