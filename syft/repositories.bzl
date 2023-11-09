"""Repository rules for fetching syft"""

load("//syft/private:versions.bzl", "SYFT_VERSIONS")

# buildifier: disable=bzl-visibility
load("//syft/private:toolchains_repo.bzl", "PLATFORMS", "toolchains_repo")

SYFT_BUILD_TMPL = """\
load("@rules_syft//syft:toolchain.bzl", "syft_toolchain")
syft_toolchain(
    name = "syft_toolchain",
    syft = "syft"
)
"""

def _syft_repo_impl(repository_ctx):
    platform = repository_ctx.attr.platform.replace("x86_64", "amd64")
    url = "https://github.com/anchore/syft/releases/download/v{version}/syft_{version}_{platform}.tar.gz".format(
        version = repository_ctx.attr.syft_version.lstrip("v"),
        platform = platform,
    )
    repository_ctx.download_and_extract(
        url = url,
        stripPrefix = "syft_{version}_{platform}".format(
            version = repository_ctx.attr.syft_version.lstrip("v"),
            platform = platform,
        ),
        integrity = SYFT_VERSIONS[repository_ctx.attr.syft_version][platform],
    )
    repository_ctx.file("BUILD.bazel", SYFT_BUILD_TMPL)

syft_repositories = repository_rule(
    _syft_repo_impl,
    doc = "Fetch external tools needed for syft toolchain",
    attrs = {
        "syft_version": attr.string(mandatory = True, values = SYFT_VERSIONS.keys()),
        "platform": attr.string(mandatory = True, values = PLATFORMS.keys()),
    },
)

# Wrapper macro around everything above, this is the primary API
def syft_register_toolchains(name):
    """Convenience macro for users which does typical setup.

    - create a repository for each built-in platform like "syft_linux_amd64" -
      this repository is lazily fetched when node is needed for that platform.
    - create a repository exposing toolchains for each platform like "oci_platforms"
    - register a toolchain pointing at each platform
    Users can avoid this macro and do these steps themselves, if they want more control.
    Args:
        name: base name for syft repository, like "syft"
    """
    toolchain_name = "{name}_toolchains".format(name = name)

    for platform in PLATFORMS.keys():
        syft_repositories(
            name = "{name}_{platform}".format(name = name, platform = platform),
            platform = platform,
            syft_version = SYFT_VERSIONS.keys()[0],
        )
        native.register_toolchains("@{}//:{}_toolchain".format(toolchain_name, platform))

    toolchains_repo(
        name = toolchain_name,
        toolchain_type = "@rules_syft//syft:toolchain_type",
        # avoiding use of .format since {platform} is formatted by toolchains_repo for each platform.
        toolchain = "@%s_{platform}//:syft_toolchain" % name,
    )
