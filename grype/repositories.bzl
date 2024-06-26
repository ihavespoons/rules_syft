"Implementation of grype_register_toolchain and grype_register_database"

load("//grype/private:toolchains_repo.bzl", "PLATFORMS", "toolchains_repo")
load("//grype/private:versions.bzl", "TOOL_VERSIONS")

# Default base name for grype toolchain repositories by the module extension
DEFAULT_GRYPE_TOOLCHAIN_REPOSITORY = "grype"

# Default toolchain version
DEFAULT_GRYPE_TOOLCHAIN_VERSION = TOOL_VERSIONS.keys()[-1]

GRYPE_TOOLCHAIN_BUILD_TMPL = """\
#Generated by grype/repositories.bzl
load("@rules_syft//grype:toolchain.bzl", "grype_toolchain")
grype_toolchain(
    name = "grype_toolchain",
    target_tool = select({
        "@bazel_tools//src/conditions:host_windows": "grype.exe",
        "//conditions:default": "grype",
    }),
)
"""

def _grype_toolchain_repo_impl(repository_ctx):
    extension = "tar.gz"
    if repository_ctx.attr.platform == "windows_amd64":
        extension = "zip"
    url = "https://github.com/anchore/grype/releases/download/v{version}/grype_{version}_{platform}.{extension}".format(
        version = repository_ctx.attr.grype_version,
        platform = repository_ctx.attr.platform,
        extension = extension,
    )
    repository_ctx.download_and_extract(
        url = url,
        sha256 = TOOL_VERSIONS[repository_ctx.attr.grype_version][repository_ctx.attr.platform],
    )

    # Base BUILD file for this repository
    repository_ctx.file("BUILD.bazel", GRYPE_TOOLCHAIN_BUILD_TMPL)

grype_toolchain_repositories = repository_rule(
    _grype_toolchain_repo_impl,
    doc = "Fetch external tools needed for grype toolchain",
    attrs = {
        "grype_version": attr.string(values = TOOL_VERSIONS.keys(), default = DEFAULT_GRYPE_TOOLCHAIN_VERSION),
        "platform": attr.string(mandatory = True, values = PLATFORMS.keys()),
    },
)

# Wrapper macro around everything above, this is the primary API
def grype_register_toolchains(name = DEFAULT_GRYPE_TOOLCHAIN_REPOSITORY, register = True, **kwargs):
    """Convenience macro for users which does typical setup.

    - create a repository for each built-in platform like "grype_linux_amd64" -
      this repository is lazily fetched when node is needed for that platform.
    - TODO: create a convenience repository for the host platform like "grype_host"
    - create a repository exposing toolchains for each platform like "grype_platforms"
    - register a toolchain pointing at each platform
    Users can avoid this macro and do these steps themselves, if they want more control.
    Args:
        name: base name for all created repos, like "grype1_14"
        register: whether to call through to native.register_toolchains.
            Should be True for WORKSPACE users, but false when used under bzlmod extension
        **kwargs: passed to each node_repositories call
    """
    for platform in PLATFORMS.keys():
        grype_toolchain_repositories(
            name = name + "_" + platform,
            platform = platform,
            **kwargs
        )
        if register:
            native.register_toolchains("@%s_toolchains//:%s_toolchain" % (name, platform))

    toolchains_repo(
        name = name + "_toolchains",
        user_repository_name = name,
    )

# Default name for grype database used by module extension
DEFAULT_GRYPE_DATABASE_REPOSITORY = "grype_database"

GRYPE_DATABASE_BUILD_TMPL = """\
#Generated by grype/repositories.bzl
load("@aspect_bazel_lib//lib:copy_to_directory.bzl", "copy_to_directory")
load("@rules_syft//grype:database.bzl", "grype_database")

copy_to_directory(
    name = "data",
    srcs = [
        "metadata.json",
        "provider-metadata.json",
        "vulnerability.db",
    ],
    hardlink = "on",
    replace_prefixes = {{
        "metadata.json": "{version}/metadata.json",
        "provider-metadata.json": "{version}/provider-metadata.json",
        "vulnerability.db": "{version}/vulnerability.db",
    }},
)

grype_database(
    name = "database",
    data = ":data",
    validate_age = {validate_age},
    max_allowed_built_age = "{max_allowed_built_age}",
)

alias(
    name = "{alias_name}",
    actual = ":database",
    visibility = ["//visibility:public"],
)
"""

def _grype_database_repo_impl(repository_ctx):
    repository_ctx.download_and_extract(
        url = repository_ctx.attr.url,
        sha256 = repository_ctx.attr.sha256,
    )
    build_content = GRYPE_DATABASE_BUILD_TMPL.format(
        alias_name = repository_ctx.attr.alias_name,
        version = repository_ctx.attr.version,
        validate_age = repository_ctx.attr.validate_age,
        max_allowed_built_age = repository_ctx.attr.max_allowed_built_age,
    )

    # Base BUILD file for this repository
    repository_ctx.file("BUILD.bazel", build_content)

grype_database_repository = repository_rule(
    implementation = _grype_database_repo_impl,
    doc = "Fetch a CVE database to use with grype_report and grype_test",
    attrs = {
        "url": attr.string(
            doc = "The URL of the database to download.",
        ),
        "sha256": attr.string(
            doc = "The SHA256 integrity hash of the database.",
        ),
        "version": attr.int(
            doc = "The version of the database.",
            default = 5,
        ),
        "validate_age": attr.bool(
            doc = "Whether to enable database age-validation when using this database.",
            default = True,
        ),
        "max_allowed_built_age": attr.string(
            doc = "The maximum allowed age when using this database.",
            default = "120h",
        ),
        "alias_name": attr.string(doc = "Internal use only."),
    },
)

def grype_register_database(name, url, sha256, version = 5, validate_age = True, max_allowed_built_age = "120h"):
    grype_database_repository(
        name = name,
        url = url,
        sha256 = sha256,
        version = version,
        validate_age = validate_age,
        max_allowed_built_age = max_allowed_built_age,
        alias_name = name,
    )
