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
    "_generate_sh_tpl": attr.label(default = "generate.sh.tpl", allow_single_file = True),
    "_windows_constraint": attr.label(default = "@platforms//os:windows"),
}

def syft_generate_sbom_impl(ctx):
    syft = ctx.toolchains["@rules_syft//syft:toolchain_type"].syft_info.binary
    image = ctx.file.image
    sbom = ctx.actions.declare_file("{}/sbom.{}".format(ctx.label.name, FILE_MAPPINGS[ctx.attr.type]))
    executable = ctx.actions.declare_file("{}/generate.sh".format(ctx.label.name))

    substitutions = {
        "{{syft}}": syft.path,
        "{{image}}": image.path,
        "{{sbom}}": sbom.path,
        "{{type}}": ctx.attr.type,
    }

    ctx.actions.expand_template(
        template = ctx.file._generate_sh_tpl,
        output = executable,
        is_executable = True,
        substitutions = substitutions,
    )

    ctx.actions.run(
        executable = util.maybe_wrap_launcher_for_windows(ctx, executable),
        inputs = [image, executable],
        outputs = [sbom],
        tools = [syft],
        mnemonic = "SyftGenerateContainerSbom",
        progress_message = "Generating SBOM for %{label}",
    )

    return [
        DefaultInfo(files = depset([sbom]), executable = executable),
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
