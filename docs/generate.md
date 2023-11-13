<!-- Generated with Stardoc: http://skydoc.bazel.build -->

To load these rules, add this to the top of your `BUILD` file:

```starlark
load("@rules_syft//syft:defs.bzl", ...)
```

<a id="syft_generate_sbom_rule"></a>

## syft_generate_sbom_rule

<pre>
syft_generate_sbom_rule(<a href="#syft_generate_sbom_rule-name">name</a>, <a href="#syft_generate_sbom_rule-image">image</a>, <a href="#syft_generate_sbom_rule-type">type</a>)
</pre>

Generate SBOM for an oci_tarball or oci_image using syft binary that is pulled as a toolchain.

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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="syft_generate_sbom_rule-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="syft_generate_sbom_rule-image"></a>image |  Label to an oci_tarball or oci_image directory   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="syft_generate_sbom_rule-type"></a>type |  Type of sbom. Acceptable values are (cyclonedx-json\|cyclonedx-xml\|syft-json\|syft-text\|spdx-tag-value\|spdx-json\|github-json)   | String | required |  |


<a id="syft_generate_sbom"></a>

## syft_generate_sbom

<pre>
syft_generate_sbom(<a href="#syft_generate_sbom-name">name</a>, <a href="#syft_generate_sbom-image">image</a>, <a href="#syft_generate_sbom-type">type</a>)
</pre>

Macro wrapper around syft_container_sbom

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="syft_generate_sbom-name"></a>name |  name of the resulting sbom file (extension determined by type)   |  none |
| <a id="syft_generate_sbom-image"></a>image |  Single file label of an oci_tarball or oci_image that syft can scan   |  `None` |
| <a id="syft_generate_sbom-type"></a>type |  One of: cyclonedx-json, cyclonedx-xml, syft-json, syft-text, spdx-tag-value, spdx-json, github-json   |  `None` |


