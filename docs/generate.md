To load this rule add the following at the top of your BUILD file:
```python
load("@rules_syft//syft:defs.bzl", "syft_generate")
```

# syft_generate
```python
syft_generate(name, tarball, type)
```

## Parameters
| Name    | Description                                                                                                                | Type                                                                | Mandatory | Default |
|:--------|:---------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------|:----------| :------------- |
| name    | A unique name for this target.                                                                                             | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |  |
| tarball | Label to an oci_tarball                                                                                                    | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |  |
| type    | Controls output typem, one of: cyclonedx-json, cyclonedx-xml, syft-json, syft-text, spdx-tag-value, spdx-json, github-json | String                                                              | required  |  |