"""Our "development" dependencies

Users should *not* need to install these. If users see a load()
statement from these, that's a bug in our distribution.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", _http_archive = "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def http_archive(name, **kwargs):
    maybe(_http_archive, name = name, **kwargs)

def generate_test_internal_deps():
    "Fetch deps needed for local testing"
    http_archive(
        name = "aspect_bazel_lib",
        sha256 = "ce259cbac2e94a6dff01aff9455dcc844c8af141503b02a09c2642695b7b873e",
        strip_prefix = "bazel-lib-1.37.0",
        url = "https://github.com/aspect-build/bazel-lib/releases/download/v1.37.0/bazel-lib-v1.37.0.tar.gz",
    )

    http_archive(
        name = "rules_oci",
        sha256 = "21a7d14f6ddfcb8ca7c5fc9ffa667c937ce4622c7d2b3e17aea1ffbc90c96bed",
        strip_prefix = "rules_oci-1.4.0",
        url = "https://github.com/bazel-contrib/rules_oci/releases/download/v1.4.0/rules_oci-v1.4.0.tar.gz",
    )
