<!-- Generated with Stardoc: http://skydoc.bazel.build -->

To load these rules, add this to the top of your `BUILD` file:

```starlark
load("@rules_syft//syft:defs.bzl", ...)
```

<a id="syft_sbom"></a>

## syft_sbom

<pre>
syft_sbom(<a href="#syft_sbom-name">name</a>, <a href="#syft_sbom-image">image</a>, <a href="#syft_sbom-scope">scope</a>)
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

syft_sbom(
    name = "generate_sbom",
    image = ":image_tarball"
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="syft_sbom-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="syft_sbom-image"></a>image |  Label to an oci_tarball or oci_image directory   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="syft_sbom-scope"></a>scope |  selection of layers to catalog   | String | optional |  `"squashed"`  |


