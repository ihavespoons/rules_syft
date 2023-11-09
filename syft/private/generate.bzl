"Implementation details for generate rule"

load("//syft/private:util.bzl", "util")
load("//syft/private:mappings.bzl", "FILE_MAPPINGS")

_DOC = """Generate SBOM for an oci_tarball using syft binary at a remote registry.

```starlark
oci_image(
    name = "image"
)

oci_tarball(
    name = "image_tarball",
    image = ":image",
    repo_tags = []
)

syft_generate(
    name = "generate_sbom",
    type = "cyclonedx-json",
    tarball = ":image_tarball"
)
```
"""

_attrs = {
    "tarball": attr.label(allow_single_file = True, mandatory = True, doc = "Label to an oci_tarball"),
    "type": attr.string(values = ["cyclonedx-json", "cyclonedx-xml", "syft-json", "syft-text", "spdx-tag-value", "spdx-json", "github-json"], mandatory = True, doc = "Type of sbom. Acceptable values are (cyclonedx-json|cyclonedx-xml|syft-json|syft-text|spdx-tag-value|spdx-json|github-json)"),
    "_generate_sh_tpl": attr.label(default = "generate.sh.tpl", allow_single_file = True),
    "_windows_constraint": attr.label(default = "@platforms//os:windows"),
}

def syft_generate_impl(ctx):
    syft = ctx.toolchains["@rules_syft//syft:toolchain_type"].syft_info.binary
    tarball = ctx.file.tarball
    sbom = ctx.actions.declare_file("{}/sbom.{}".format(ctx.label.name, FILE_MAPPINGS[ctx.attr.type]))
    executable = ctx.actions.declare_file("{}/generate.sh".format(ctx.label.name))

    substitutions = {
        "{{syft}}": syft.path,
        "{{tarball}}": tarball.path,
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
        inputs = [tarball, executable],
        outputs = [sbom],
        tools = [syft],
        mnemonic = "SyftGenerate",
        progress_message = "Syft Generate %{label}",
    )

    return [
        DefaultInfo(files = depset([sbom]), executable = executable),
    ]

syft_generate = rule(
    implementation = syft_generate_impl,
    attrs = _attrs,
    toolchains = [
        "@bazel_tools//tools/sh:toolchain_type",
        "@rules_syft//syft:toolchain_type",
    ],
    executable = True,
)
