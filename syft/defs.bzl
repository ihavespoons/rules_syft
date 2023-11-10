"""
To load these rules, add this to the top of your `BUILD` file:

```starlark
load("@rules_syft//syft:defs.bzl", ...)
```
"""

load("//syft/private:generate.bzl", _syft_generate = "syft_generate")

syft_generate_rule = _syft_generate

def syft_generate(name, tarball = None, type = None):
    """Macro wrapper around syft_generate

    Args:
        name: name of the resulting sbom file (extension determined by type)
        tarball: Single file label of an OCI tarball that syft can scan
        type: One of: cyclonedx-json, cyclonedx-xml, syft-json, syft-text, spdx-tag-value, spdx-json, github-json
    """

    syft_generate_rule(
        name = name,
        tarball = tarball,
        type = type,
    )
