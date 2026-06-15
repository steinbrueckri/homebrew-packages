#!/usr/bin/env python3
"""Update Homebrew formulae in this tap to the latest upstream GitHub release.

For every formula the script:
  * detects the GitHub repo and the current tag from the existing release URLs
  * looks up the latest release via the `gh` CLI
  * rewrites every url/sha256 pair (and the `version` line, if present)

Formulae without a GitHub *release* URL are skipped on purpose. This covers
head-only builds (no url at all) and commit-pinned `/archive/<sha>.zip` URLs.

The same script is used locally (via the Justfile) and in CI (see
.github/workflows/update.yml), so both paths behave identically.

Usage:
    scripts/update.py                 # update all formulae
    scripts/update.py ringo pik       # update only the named formulae
    scripts/update.py --dry-run       # report available updates, write nothing

Requires the `gh` CLI to be installed and authenticated. Only the Python
standard library is used otherwise.
"""

import argparse
import hashlib
import json
import re
import subprocess
import sys
import urllib.request
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# Formula line patterns. group(1) is the prefix up to the opening quote,
# group(2) the value, group(3) the closing quote plus any trailing text.
URL_RE = re.compile(r'^(\s*url\s+")([^"]+)(".*)$')
SHA_RE = re.compile(r'^(\s*sha256\s+")([0-9a-f]{64})(".*)$')
VERSION_RE = re.compile(r'^(\s*version\s+")([^"]+)(".*)$')

# A GitHub release-asset download URL: owner, repo, tag, asset path.
GH_RELEASE_RE = re.compile(
    r"^https://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(.+)$"
)


def gh_latest_release(owner, repo):
    """Return (tag, {asset_name: sha256_or_None}) for the latest release."""
    result = subprocess.run(
        ["gh", "release", "view", "--repo", f"{owner}/{repo}",
         "--json", "tagName,assets"],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        sys.exit(f"gh failed for {owner}/{repo}: {result.stderr.strip()}")
    data = json.loads(result.stdout)
    assets = {}
    for asset in data["assets"]:
        digest = asset.get("digest") or ""
        prefix = "sha256:"
        assets[asset["name"]] = digest[len(prefix):] if digest.startswith(prefix) else None
    return data["tagName"], assets


def sha256_of_url(url):
    """Download `url` and return its sha256 (fallback when gh has no digest)."""
    digest = hashlib.sha256()
    with urllib.request.urlopen(url) as response:
        for chunk in iter(lambda: response.read(1 << 16), b""):
            digest.update(chunk)
    return digest.hexdigest()


def detect_repo_and_tag(lines):
    """Return (owner, repo, tag) from the first GitHub release URL, or None."""
    for line in lines:
        match = URL_RE.match(line)
        if not match:
            continue
        gh = GH_RELEASE_RE.match(match.group(2))
        if gh:
            return gh.group(1), gh.group(2), gh.group(3)
    return None


def resolve_sha256(name, asset, url, assets):
    """Return the sha256 for `asset`, preferring gh's digest, else downloading."""
    if asset not in assets:
        sys.exit(
            f"{name}: asset '{asset}' not found in the latest release. "
            f"Available assets: {', '.join(sorted(assets)) or '(none)'}"
        )
    return assets[asset] or sha256_of_url(url)


def update_formula(path, dry_run):
    """Update a single formula file. Return True if an update is available."""
    name = path.stem
    lines = path.read_text().splitlines()

    info = detect_repo_and_tag(lines)
    if info is None:
        print(f"{name}: skipped (no GitHub release URL)")
        return False

    owner, repo, current_tag = info
    new_tag, assets = gh_latest_release(owner, repo)
    if new_tag == current_tag:
        print(f"{name}: up to date ({current_tag})")
        return False

    new_version = re.sub(r"^v", "", new_tag)
    out = []
    pending = None  # (asset_name, new_url) waiting for its sha256 line

    for line in lines:
        url_match = URL_RE.match(line)
        sha_match = SHA_RE.match(line)
        version_match = VERSION_RE.match(line)

        if url_match:
            gh = GH_RELEASE_RE.match(url_match.group(2))
            if gh and gh.group(3) == current_tag:
                o, r, _tag, asset = gh.groups()
                # The version often appears inside the asset filename too,
                # so swap it there as well (e.g. pik-0.18.1-...tar.gz).
                new_asset = asset.replace(current_tag, new_tag)
                new_url = f"https://github.com/{o}/{r}/releases/download/{new_tag}/{new_asset}"
                pending = (new_asset, new_url)
                out.append(f"{url_match.group(1)}{new_url}{url_match.group(3)}")
                continue
        elif sha_match and pending is not None:
            asset, url = pending
            digest = resolve_sha256(name, asset, url, assets)
            out.append(f"{sha_match.group(1)}{digest}{sha_match.group(3)}")
            pending = None
            continue
        elif version_match:
            out.append(f"{version_match.group(1)}{new_version}{version_match.group(3)}")
            continue

        out.append(line)

    if dry_run:
        print(f"{name}: update available {current_tag} -> {new_tag} (dry-run)")
    else:
        path.write_text("\n".join(out) + "\n")
        print(f"{name}: updated {current_tag} -> {new_tag}")
    return True


def resolve_paths(packages):
    if not packages:
        return sorted(REPO_ROOT.glob("*.rb"))
    paths = []
    for package in packages:
        path = REPO_ROOT / f"{package}.rb"
        if not path.exists():
            sys.exit(f"unknown package: {package} ({path} not found)")
        paths.append(path)
    return paths


def main():
    parser = argparse.ArgumentParser(
        description="Update Homebrew formulae to the latest GitHub release."
    )
    parser.add_argument("packages", nargs="*",
                        help="formula names to update (default: all)")
    parser.add_argument("--dry-run", action="store_true",
                        help="report available updates without writing files")
    args = parser.parse_args()

    for path in resolve_paths(args.packages):
        update_formula(path, args.dry_run)


if __name__ == "__main__":
    main()
