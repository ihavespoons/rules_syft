"""
To load these rules, add this to the top of your `BUILD` file:

```starlark
load("@rules_syft//syft:defs.bzl", ...)
```
"""

load("//syft/private:generate.bzl", _syft_generate_sbom = "syft_generate_sbom")

syft_generate_sbom_rule = _syft_generate_sbom

def syft_generate_sbom(name, image = None, type = None):
    """Macro wrapper around syft_container_sbom

    Args:
        name: name of the resulting sbom file (extension determined by type)
        image: Single file label of an oci_tarball or oci_image that syft can scan
        type: One of: cyclonedx-json, cyclonedx-xml, syft-json, syft-text, spdx-tag-value, spdx-json, github-json
    """

    syft_generate_sbom_rule(
        name = name,
        image = image,
        type = type,
    )
