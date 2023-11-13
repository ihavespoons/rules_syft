"""OCI base images used for testing.
"""

load("@rules_oci//oci:pull.bzl", "oci_pull")

def fetch_images():
    oci_pull(
        name = "dockerhub_ubuntu",
        digest = "sha256:c9cf959fd83770dfdefd8fb42cfef0761432af36a764c077aed54bbc5bb25368",
        image = "docker.io/library/ubuntu",
    )
