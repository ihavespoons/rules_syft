<!-- Generated with Stardoc: http://skydoc.bazel.build -->

To load these rules, add this to the top of your `BUILD` file:

```starlark
load("@rules_syft//syft:defs.bzl", ...)
```

<a id="syft_generate_rule"></a>

## syft_generate_rule

<pre>
syft_generate_rule(<a href="#syft_generate_rule-name">name</a>, <a href="#syft_generate_rule-tarball">tarball</a>, <a href="#syft_generate_rule-type">type</a>)
</pre>

Generate SBOM for an oci_tarball using syft binary at a remote registry.

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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="syft_generate_rule-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="syft_generate_rule-tarball"></a>tarball |  Label to an oci_tarball   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="syft_generate_rule-type"></a>type |  Type of sbom. Acceptable values are (cyclonedx-json\|cyclonedx-xml\|syft-json\|syft-text\|spdx-tag-value\|spdx-json\|github-json)   | String | required |  |


<a id="syft_generate"></a>

## syft_generate

<pre>
syft_generate(<a href="#syft_generate-name">name</a>, <a href="#syft_generate-tarball">tarball</a>, <a href="#syft_generate-type">type</a>)
</pre>

Macro wrapper around syft_generate

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="syft_generate-name"></a>name |  name of the resulting sbom file (extension determined by type)   |  none |
| <a id="syft_generate-tarball"></a>tarball |  Single file label of an OCI tarball that syft can scan   |  `None` |
| <a id="syft_generate-type"></a>type |  One of: cyclonedx-json, cyclonedx-xml, syft-json, syft-text, spdx-tag-value, spdx-json, github-json   |  `None` |


