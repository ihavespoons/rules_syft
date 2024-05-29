"""
To load these rules, add this to the top of your `BUILD` file:

```starlark
load("@rules_syft//syft:defs.bzl", ...)
```
"""

load("//syft/private:generate.bzl", _syft_sbom = "syft_sbom")

syft_sbom = _syft_sbom

def syft_generate_sbom(name, image, scope = "squashed", **kwargs):
    _syft_sbom(
        name = name,
        image = image,
        scope = scope,
        deprecation = "This rule is deprecated and will be removed in the near future. Please use syft_sbom instead.",
        **kwargs
    )
