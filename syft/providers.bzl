"Provider to share information between syft and grype"

SyftSbomInfo = provider(
    doc = "Information about a generated SBOM.",
    fields = {
        "syft_json": "File object for SBOM in syft-json format.",
    },
)
