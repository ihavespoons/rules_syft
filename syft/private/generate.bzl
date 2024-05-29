"Implementation details for container_sbom rule"

load("//syft:providers.bzl", "SyftSbomInfo")
load("//syft/private:file_mappings.bzl", "FILE_MAPPINGS")

_DOC = """Generate SBOM for an oci_tarball or oci_image using syft binary that is pulled as a toolchain.

```starlark
oci_image(
    name = "image"
)

oci_tarball(
    name = "image_tarball",
    image = ":image",
    repo_tags = []
)

syft_sbom(
    name = "generate_sbom",
    image = ":image_tarball"
)
```
"""

_attrs = {
    "image": attr.label(
        doc = "Label to an oci_tarball or oci_image directory",
        allow_single_file = True,
        mandatory = True,
    ),
    "scope": attr.string(
        doc = "selection of layers to catalog",
        values = ["squashed", "all-layers"],
        default = "squashed",
    ),
    "_windows_constraint": attr.label(default = "@platforms//os:windows"),
}

# see: https://github.com/anchore/syft#configuration
SYFT_CONFIG_TMPL = """\
# disable checking for application updates on startup
check-for-app-updates: false

# the search space to look for file and package data
scope: {scope}

# the output format(s) of the SBOM report
output:
{output}
"""

def syft_sbom_impl(ctx):
    """
    Implementation for generating SBOM for an oci_tarball or oci_image using syft binary that is pulled as a toolchain.

    Args:
        ctx: action context

    Returns:
        The SBOM files generated by this function
    """
    outputs = {}
    output_options = []

    output_options = []

    for output_format, output_extension in FILE_MAPPINGS.items():
        output_file = ctx.actions.declare_file("{}/sbom.{}".format(ctx.label.name, output_extension))
        outputs[output_format] = output_file
        output_options.append("- {}={}".format(output_format, output_file.path))

    config_file = ctx.actions.declare_file("{}/syft-config.yaml".format(ctx.label.name))
    ctx.actions.write(
        output = config_file,
        content = SYFT_CONFIG_TMPL.format(
            scope = ctx.attr.scope,
            output = "\n".join(output_options),
        ),
    )

    args = ctx.actions.args()
    args.add("--config", config_file.path)
    args.add(ctx.file.image.path)

    ctx.actions.run(
        executable = ctx.toolchains["@rules_syft//syft:toolchain_type"].syftinfo.target_tool_path,
        inputs = [config_file, ctx.file.image],
        arguments = [args],
        outputs = outputs.values(),
        tools = ctx.toolchains["@rules_syft//syft:toolchain_type"].syftinfo.tool_files,
        mnemonic = "SyftGenerateContainerSbom",
        progress_message = "Generating SBOM for %{label}",
    )

    return [
        DefaultInfo(files = depset(outputs.values())),
        SyftSbomInfo(syft_json = outputs["syft-json"]),
    ]

syft_sbom = rule(
    implementation = syft_sbom_impl,
    doc = _DOC,
    attrs = _attrs,
    toolchains = [
        "@bazel_tools//tools/sh:toolchain_type",
        "@rules_syft//syft:toolchain_type",
    ],
)
