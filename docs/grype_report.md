<!-- Generated with Stardoc: http://skydoc.bazel.build -->

To load these rules, add this to the top of your `BUILD` file:

```starlark
load("@rules_syft//grype:defs.bzl", ...)
```

<a id="grype_report"></a>

## grype_report

<pre>
grype_report(<a href="#grype_report-name">name</a>, <a href="#grype_report-database">database</a>, <a href="#grype_report-ignore_vulnerabilities">ignore_vulnerabilities</a>, <a href="#grype_report-only_fixed">only_fixed</a>, <a href="#grype_report-sbom">sbom</a>)
</pre>

Generate CVE Report for an syft_sbom using grype binary that is pulled as a toolchain.

```starlark
oci_image(
    name = "image"
)

syft_sbom(
    name = "sbom",
    image = ":image"
)

grype_report(
    name = "report",
    sbom = ":sbom",
    database = "@grype_database",
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="grype_report-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="grype_report-database"></a>database |  Label to grype.database   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="grype_report-ignore_vulnerabilities"></a>ignore_vulnerabilities |  Vulnerabilities to ignore   | List of strings | optional |  `[]`  |
| <a id="grype_report-only_fixed"></a>only_fixed |  Ignore matches for vulnerabilities that are not fixed   | Boolean | optional |  `False`  |
| <a id="grype_report-sbom"></a>sbom |  Label to syft_sbom   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


