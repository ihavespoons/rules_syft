"""
To load these rules, add this to the top of your `BUILD` file:

```starlark
load("@rules_syft//grype:defs.bzl", ...)
```
"""
load("//grype/private:grype.bzl", _grype_report = "grype_report", _grype_test = "grype_test")

grype_report = _grype_report
grype_test = _grype_test
