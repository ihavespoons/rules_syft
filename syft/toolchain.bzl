"""This module implements the syft-specific toolchain rule."""

SyftInfo = provider(
    doc = "Information about how to invoke the syft executable.",
    fields = {
        "binary": "Executable syft binary",
    },
)

def _syft_toolchain_impl(ctx):
    binary = ctx.executable.syft

    # Make the $(SYFT_BIN) variable available in places like genrules.
    # See https://docs.bazel.build/versions/main/be/make-variables.html#custom_variables
    template_variables = platform_common.TemplateVariableInfo({
        "SYFT_BIN": binary.path,
    })
    default = DefaultInfo(
        files = depset([binary]),
        runfiles = ctx.runfiles(files = [binary]),
    )
    syft_info = SyftInfo(binary = binary)

    # Export all the providers inside our ToolchainInfo
    # so the resolved_toolchain rule can grab and re-export them.
    toolchain_info = platform_common.ToolchainInfo(
        syft_info = syft_info,
        template_variables = template_variables,
        default = default,
    )
    return [
        default,
        toolchain_info,
        template_variables,
    ]

syft_toolchain = rule(
    implementation = _syft_toolchain_impl,
    attrs = {
        "syft": attr.label(
            doc = "A hermetically downloaded syft executable target for the target platform.",
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
    doc = """Defines a syft toolchain.

For usage see https://docs.bazel.build/versions/main/toolchains.html#defining-toolchains.
""",
)
