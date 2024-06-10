"""Our "development" dependencies

Users should *not* need to install these. If users see a load()
statement from these, that's a bug in our distribution.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", _http_archive = "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def http_archive(name, **kwargs):
    maybe(_http_archive, name = name, **kwargs)

def rules_syft_internal_deps():
    "Fetch deps needed for local development"

    # Override bazel_skylib distribution to fetch sources instead
    # so that the gazelle extension is included
    # see https://github.com/bazelbuild/bazel-skylib/issues/250
    http_archive(
        name = "bazel_skylib",
        sha256 = "9f38886a40548c6e96c106b752f242130ee11aaa068a56ba7e56f4511f33e4f2",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.6.1/bazel-skylib-1.6.1.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.6.1/bazel-skylib-1.6.1.tar.gz",
        ],
    )

    http_archive(
        name = "io_bazel_stardoc",
        sha256 = "62bd2e60216b7a6fec3ac79341aa201e0956477e7c8f6ccc286f279ad1d96432",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/stardoc/releases/download/0.6.2/stardoc-0.6.2.tar.gz",
            "https://github.com/bazelbuild/stardoc/releases/download/0.6.2/stardoc-0.6.2.tar.gz",
        ],
    )

    http_archive(
        name = "buildifier_prebuilt",
        sha256 = "8ada9d88e51ebf5a1fdff37d75ed41d51f5e677cdbeafb0a22dda54747d6e07e",
        strip_prefix = "buildifier-prebuilt-6.4.0",
        urls = [
            "http://github.com/keith/buildifier-prebuilt/archive/6.4.0.tar.gz",
        ],
    )

    http_archive(
        name = "aspect_bazel_lib",
        sha256 = "87ab4ec479ebeb00d286266aca2068caeef1bb0b1765e8f71c7b6cfee6af4226",
        strip_prefix = "bazel-lib-2.7.3",
        url = "https://github.com/aspect-build/bazel-lib/releases/download/v2.7.3/bazel-lib-v2.7.3.tar.gz",
    )
