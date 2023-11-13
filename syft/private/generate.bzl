"Implementation details for container_sbom rule"

load("//syft/private:util.bzl", "util")
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

syft_generate_sbom(
    name = "generate_sbom",
    type = "cyclonedx-json",
    image = ":image_tarball"
)
```
"""

_attrs = {
    "image": attr.label(allow_single_file = True, mandatory = True, doc = "Label to an oci_tarball or oci_image directory"),
    "type": attr.string(values = ["cyclonedx-json", "cyclonedx-xml", "syft-json", "syft-text", "spdx-tag-value", "spdx-json", "github-json"], mandatory = True, doc = "Type of sbom. Acceptable values are (cyclonedx-json|cyclonedx-xml|syft-json|syft-text|spdx-tag-value|spdx-json|github-json)"),
    "_windows_constraint": attr.label(default = "@platforms//os:windows"),
}

def syft_generate_sbom_impl(ctx):
    image = ctx.file.image
    sbom = ctx.actions.declare_file("{}/sbom.{}".format(ctx.label.name, FILE_MAPPINGS[ctx.attr.type]))
    syft = ctx.toolchains["@rules_syft//syft:toolchain_type"].syft_info.binary
    args = ctx.actions.args()
    args.add("--output", ctx.attr.type + "=" + sbom.path)

    ctx.actions.run(
        executable = syft.path,
        inputs = [image],
        arguments = [image.path, args],
        outputs = [sbom],
        tools = [syft],
        mnemonic = "SyftGenerateContainerSbom",
        progress_message = "Generating SBOM for %{label}",
    )

    return [
        DefaultInfo(files = depset([sbom]), executable = sbom),
    ]

syft_generate_sbom = rule(
    implementation = syft_generate_sbom_impl,
    doc = _DOC,
    attrs = _attrs,
    toolchains = [
        "@bazel_tools//tools/sh:toolchain_type",
        "@rules_syft//syft:toolchain_type",
    ],
    executable = True,
)
