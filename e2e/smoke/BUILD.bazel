load("@bazel_skylib//rules:build_test.bzl", "build_test")
load("@rules_oci//oci:defs.bzl", "oci_image", "oci_tarball")
load("@rules_syft//grype:defs.bzl", "grype_report", "grype_test")
load("@rules_syft//syft:defs.bzl", "syft_sbom")

oci_image(
    name = "image",
    base = "@ubuntu",
)

oci_tarball(
    name = "tarball",
    image = ":image",
    repo_tags = [],
)

syft_sbom(
    name = "sbom_pulled",
    image = "@ubuntu",
)

syft_sbom(
    name = "sbom_image",
    image = ":image",
)

syft_sbom(
    name = "sbom_tarball",
    image = ":tarball",
)

grype_report(
    name = "cve_report_pulled",
    database = "@grype_database",
    ignore_vulnerabilities = [
        "CVE-2024-28085",
        "CVE-2023-39804",
    ],
    only_fixed = True,
    sbom = ":sbom_pulled",
)

grype_test(
    name = "cve_test_pulled",
    database = "@grype_database",
    fail_on_severity = "high",
    ignore_vulnerabilities = [
        "CVE-2024-28085",
        "CVE-2023-39804",
    ],
    only_fixed = True,
    sbom = ":sbom_pulled",
)

build_test(
    name = "smoke_test",
    targets = [
        ":sbom_pulled",
        ":sbom_image",
        ":sbom_tarball",
        ":cve_report_pulled",
        ":cve_test_pulled",
    ],
)
