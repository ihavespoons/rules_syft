import os
import sys
import textwrap
from dataclasses import dataclass, field

import requests  # type: ignore
from github import Auth, Github
from github.GitRelease import GitRelease
from packaging.version import Version


@dataclass
class ToolBinary:
    arch: str
    sha256: str


@dataclass
class ToolVersion:
    version: Version
    binaries: list[ToolBinary] = field(default_factory=list)


def parse_release(release: GitRelease) -> ToolVersion:
    print(f"Parsing release: {release.title}", file=sys.stderr)
    tool_version = ToolVersion(version=Version(release.title))
    checksums_asset = None
    for asset in release.get_assets():
        if asset.name.endswith("_checksums.txt"):
            checksums_asset = asset
            break

    if not checksums_asset:
        return tool_version

    checksums = requests.get(checksums_asset.browser_download_url).text.strip()
    for checksum_line in checksums.split("\n"):
        checksum, filename = checksum_line.split()
        if not filename.endswith(".tar.gz") and not filename.endswith(".zip"):
            continue
        _, _, arch_ext = filename.split("_", maxsplit=2)
        arch, _ = arch_ext.split(".", maxsplit=1)
        tool_binary = ToolBinary(arch=arch, sha256=checksum)
        tool_version.binaries.append(tool_binary)
    return tool_version


def get_tool_versions(client: Github, repo_name: str) -> list[ToolVersion]:
    print(f"Getting releases for: {repo_name}", file=sys.stderr)
    repo = client.get_repo(repo_name)
    tool_versions: list[ToolVersion] = []
    for release in repo.get_releases():
        tool_version = parse_release(release)
        tool_versions.append(tool_version)
    tool_versions.sort(key=lambda x: x.version)
    return tool_versions


def get_versions_file(tool_versions: list[ToolVersion]) -> str:
    def indent(text: str, amount: int = 1) -> str:
        return textwrap.indent(text, amount * 4 * " ")

    lines = [
        '"Mirror of release info"',
        "",
        "TOOL_VERSIONS = {",
    ]

    for version in tool_versions:
        lines.append(indent(f'"{version.version}": {{'))
        for binary in version.binaries:
            lines.append(indent(f'"{binary.arch}": "{binary.sha256}",', 2))
        lines.append(indent("},"))

    lines.append("}")
    return "\n".join(lines)


def get_client() -> Github:
    auth = None
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        auth = Auth.Token(token=token)
    return Github(auth=auth)


def main() -> None:
    client = get_client()
    syft_versions = get_tool_versions(client=client, repo_name="anchore/syft")
    syft_versions_file = get_versions_file(syft_versions)
    with open("syft_versions.bzl", "w") as f:
        f.write(syft_versions_file)

    grype_versions = get_tool_versions(client=client, repo_name="anchore/grype")
    grype_versions_file = get_versions_file(grype_versions)
    with open("grype_versions.bzl", "w") as f:
        f.write(grype_versions_file)


if __name__ == "__main__":
    main()
