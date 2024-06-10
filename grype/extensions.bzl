"""Extensions for bzlmod.

Installs a grype toolchain.
Every module can define a toolchain version under the default name, "grype".
The latest of those versions will be selected (the rest discarded),
and will always be registered by rules_syft.

Additionally, the root module can define arbitrarily many more toolchain versions under different
names (the latest version will be picked for each name) and can register them as it sees fit,
effectively overriding the default named toolchain due to toolchain resolution precedence.
"""

load(":repositories.bzl", "DEFAULT_GRYPE_DATABASE_REPOSITORY", "DEFAULT_GRYPE_TOOLCHAIN_REPOSITORY", "DEFAULT_GRYPE_TOOLCHAIN_VERSION", "grype_register_database", "grype_register_toolchains")

_toolchain = tag_class(attrs = {
    "name": attr.string(
        doc = """\
Base name for generated repositories, allowing more than one grype toolchain to be registered.
Overriding the default is only permitted in the root module.
""",
        default = DEFAULT_GRYPE_TOOLCHAIN_REPOSITORY,
    ),
    "grype_version": attr.string(
        doc = "Explicit version of grype.",
        default = DEFAULT_GRYPE_TOOLCHAIN_VERSION,
    ),
})

_database = tag_class(attrs = {
    "name": attr.string(
        doc = "The name of the generated database repository.",
        default = DEFAULT_GRYPE_DATABASE_REPOSITORY,
    ),
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
})

def _grype_extension(module_ctx):
    registrations = {}
    for mod in module_ctx.modules:
        for toolchain in mod.tags.toolchain:
            if toolchain.name != DEFAULT_GRYPE_TOOLCHAIN_REPOSITORY and not mod.is_root:
                fail("""\
                Only the root module may override the default name for the grype toolchain.
                This prevents conflicting registrations in the global namespace of external repos.
                """)
            if toolchain.name not in registrations.keys():
                registrations[toolchain.name] = []
            registrations[toolchain.name].append(toolchain.grype_version)

        for database in mod.tags.database:
            grype_register_database(
                name = database.name,
                url = database.url,
                sha256 = database.sha256,
                version = database.version,
                validate_age = database.validate_age,
                max_allowed_built_age = database.max_allowed_built_age,
            )

    for name, versions in registrations.items():
        if len(versions) > 1:
            # TODO: should be semver-aware, using MVS
            selected = sorted(versions, reverse = True)[0]

            # buildifier: disable=print
            print("NOTE: grype toolchain {} has multiple versions {}, selected {}".format(name, versions, selected))
        else:
            selected = versions[0]

        grype_register_toolchains(
            name = name,
            grype_version = selected,
            register = False,
        )

grype = module_extension(
    implementation = _grype_extension,
    tag_classes = {
        "toolchain": _toolchain,
        "database": _database,
    },
)
