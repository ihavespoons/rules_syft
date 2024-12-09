"""
To load these rules, add this to the top of your `BUILD` file:

```starlark
load("@rules_syft//syft:defs.bzl", ...)
```
"""

load("//syft/private:generate.bzl", _syft_sbom = "syft_sbom")

syft_sbom = _syft_sbom
