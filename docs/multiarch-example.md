## Generating multiarch SBOMs with rules_syft

Syft itself doesn't support the generation of multiarch SBOM manifests. There is however the option to use the following pattern to generate SBOM's on a per manifest basis. These can then be attached using cosign or other methodologies as syft's attestation support is experimental and doesn't nicely support a headless flow.

```starlark
oci_image(
    name = "aws-cli_2_5_2_amd64",
    base = "@aws-cli_2_5_2_amd64_base",
    entrypoint = ["/usr/local/bin/aws",],
    cmd = ["/bin/sh","-c","#(nop) ","ENTRYPOINT [/usr/local/bin/aws]",],
    workdir = "/aws",
)

oci_image(
    name = "aws-cli_2_5_2_arm64",
    base = "@aws-cli_2_5_2_arm64_base",
    entrypoint = ["/usr/local/bin/aws",],
    cmd = ["/bin/sh","-c","#(nop) ","ENTRYPOINT [/usr/local/bin/aws]",],
    workdir = "/aws",
)

syft_sbom(
    name = "generate_sbom_aws-cli_2_5_2_arm64",
    type = "cyclonedx-json",
    image = ":aws-cli_2_5_2_arm64"
)

syft_sbom(
    name = "generate_sbom_aws-cli_2_5_2_amd64",
    type = "cyclonedx-json",
    image = ":aws-cli_2_5_2_amd64"
)
```
