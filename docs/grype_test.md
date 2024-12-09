<!-- Generated with Stardoc: http://skydoc.bazel.build -->

To load these rules, add this to the top of your `BUILD` file:

```starlark
load("@rules_syft//grype:defs.bzl", ...)
```

<a id="grype_test"></a>

## grype_test

<pre>
load("@rules_syft//grype:defs.bzl", "grype_test")

grype_test(<a href="#grype_test-name">name</a>, <a href="#grype_test-database">database</a>, <a href="#grype_test-fail_on_severity">fail_on_severity</a>, <a href="#grype_test-ignore_vulnerabilities">ignore_vulnerabilities</a>, <a href="#grype_test-only_fixed">only_fixed</a>, <a href="#grype_test-sbom">sbom</a>)
</pre>

Scans a SBOM for known vulnerabilities and fails if vulnerabilities are found that exceed a certain severity.

```starlark
oci_image(
    name = "image"
)

syft_sbom(
    name = "sbom",
    image = ":image"
)

grype_test(
    name = "test",
    sbom = ":sbom",
    database = "@grype_database",
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="grype_test-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="grype_test-database"></a>database |  Label to grype.database   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="grype_test-fail_on_severity"></a>fail_on_severity |  Severity at or above which to fail   | String | optional |  `"low"`  |
| <a id="grype_test-ignore_vulnerabilities"></a>ignore_vulnerabilities |  Vulnerabilities to ignore   | List of strings | optional |  `[]`  |
| <a id="grype_test-only_fixed"></a>only_fixed |  Ignore matches for vulnerabilities that are not fixed   | Boolean | optional |  `False`  |
| <a id="grype_test-sbom"></a>sbom |  Label to syft_sbom   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


