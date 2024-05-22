"""
To load these rules, add this to the top of your `BUILD` file:

```starlark
load("@rules_syft//syft:defs.bzl", ...)
```
"""

load("//syft/private:generate.bzl", _syft_generate_sbom = "syft_generate_sbom")

syft_generate_sbom = _syft_generate_sbom
