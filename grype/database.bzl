"""This module implements the grype-specific database rule."""

GrypeDatabaseInfo = provider(
    doc = "Information about a grype database.",
    fields = {
        "cache": "File object for the cache directory.",
        "validate_age": "bool: Whether validate-age is enabled for this database.",
        "max_allowed_built_age": "string: The allowed maximum age of this database.",
    },
)

def _grype_database_impl(ctx):
    return [
        DefaultInfo(files = depset([ctx.file.data])),
        GrypeDatabaseInfo(
            cache = ctx.file.data,
            validate_age = ctx.attr.validate_age,
            max_allowed_built_age = ctx.attr.max_allowed_built_age,
        ),
    ]

grype_database = rule(
    implementation = _grype_database_impl,
    attrs = {
        "data": attr.label(allow_single_file = True),
        "validate_age": attr.bool(default = True),
        "max_allowed_built_age": attr.string(default = "120h"),
    },
    doc = "Defines a grype database.",
)
