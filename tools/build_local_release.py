"""Build the SideSwap packages on this machine and publish them to GitHub.

This is the fallback for the GitHub Actions workflow in
`.github/workflows/build.yml`. It produces the same two artifacts, signs the
APK with the same committed debug key, and attaches both to a prerelease of
this repository. It spends no Actions minutes, because nothing runs on a
GitHub runner: only the Releases API is called.

It shares one build-number counter with the workflow, so a package from either
side always installs over a package from the other. See
`docs/adr/0015-github-actions-builds.md` decision 7.

    python tools/build_local_release.py
    python tools/build_local_release.py --platform android
    python tools/build_local_release.py --build-rust

Requirements: `gh` logged in with push access, `flutter` on PATH, and a
`rust-libs-<sha>` prerelease for the commit pinned in `rust.sha`. The native
libraries are downloaded from that prerelease rather than rebuilt, so the
binaries are byte for byte the ones the workflow ships.

When the pin has no such prerelease, `--build-rust` builds the bundle in WSL
and publishes it, then continues with the download. That route needs `wsl` on
PATH and `WSL_NDK_HOME` in `tools/.env`, and it is not byte for byte
reproducible.
"""

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import zipfile
from pathlib import Path

from wsl_env import _load_env, win_path_to_wsl

REPO_ROOT = Path(__file__).parent.parent
SCRIPT_DIR = Path(__file__).parent

APP_VERSION_FILE = REPO_ROOT / "lib" / "app_version.dart"
JNI_LIBS_DIR = REPO_ROOT / "android" / "app" / "src" / "main" / "jniLibs"
WINDOWS_RELEASE_DIR = REPO_ROOT / "build" / "windows" / "x64" / "runner" / "Release"
APK_PATH = REPO_ROOT / "build" / "app" / "outputs" / "flutter-apk" / "app-full-debug.apk"

# The one ABI the workflow ships. See ADR-0015 decision 5.
KEPT_ABI = "arm64-v8a"
KEPT_RELEASES = 5
TAG_PATTERN = re.compile(r"^(?:build|local)-(\d+)$")


def resolve(cmd: list[str]) -> list[str]:
    """Replace the program name with its full path.

    Windows needs this: `flutter` is `flutter.BAT`, and CreateProcess does not
    apply PATHEXT, so a bare name raises WinError 2. `shell=True` would fix it
    too and is not used, because these arguments carry version strings and
    paths that a shell would be free to re-interpret.
    """
    found = shutil.which(cmd[0])
    if found is None:
        sys.exit(f"x `{cmd[0]}` is not on PATH")
    return [found, *cmd[1:]]


def run(cmd: list[str], cwd: Path = REPO_ROOT) -> None:
    print(f"\n> {' '.join(cmd)}", flush=True)
    result = subprocess.run(resolve(cmd), cwd=cwd, shell=False)
    if result.returncode != 0:
        sys.exit(f"x command failed (exit {result.returncode})")


def capture(cmd: list[str], cwd: Path = REPO_ROOT) -> str:
    result = subprocess.run(resolve(cmd), cwd=cwd, shell=False, capture_output=True, text=True)
    if result.returncode != 0:
        sys.exit(f"x command failed (exit {result.returncode}): {result.stderr.strip()}")
    return result.stdout


def repo_slug() -> str:
    return capture(["gh", "repo", "view", "--json", "nameWithOwner", "-q", ".nameWithOwner"]).strip()


def read_version_name() -> str:
    """The version name from `pubspec.yaml`, e.g. `1.9.2` out of `1.9.2+5033`."""
    for line in (REPO_ROOT / "pubspec.yaml").read_text(encoding="utf-8").splitlines():
        if line.startswith("version:"):
            return line.split(":", 1)[1].strip().split("+", 1)[0]
    sys.exit("x could not read `version:` from pubspec.yaml")


def read_rust_pin() -> str:
    sha = (REPO_ROOT / "rust.sha").read_text(encoding="utf-8").strip()
    if len(sha) != 40:
        sys.exit(f"x rust.sha must hold one full 40-character SHA, got '{sha}'")
    return sha


def list_release_tags(slug: str) -> list[str]:
    raw = capture(["gh", "release", "list", "--repo", slug, "--limit", "200", "--json", "tagName"])
    return [item["tagName"] for item in json.loads(raw)]


def next_build_number(tags: list[str]) -> int:
    """One past the highest number any release carries, from either source.

    The workflow computes this the same way. A shared counter is what keeps
    every APK's versionCode above the one already on the device, whichever
    side built the package before it.
    """
    used = [int(m.group(1)) for m in (TAG_PATTERN.match(t) for t in tags) if m]
    return max(used, default=0) + 1


def build_rust_bundle(slug: str, rust_sha: str, work: Path) -> None:
    """Build the bundle in WSL and publish it as the `rust-libs-<sha>` prerelease.

    This is the unreproducible route. The runner's `protoc` and MinGW toolchain
    are not the ones WSL has, so the binaries are not byte for byte the
    workflow's. It exists because a moved pin otherwise stops the local path
    too. See `docs/adr/0015-github-actions-builds.md` decision 12.
    """
    _load_env(SCRIPT_DIR / ".env")
    ndk_home = os.environ.get("WSL_NDK_HOME", "").strip()
    if not ndk_home:
        sys.exit(
            "x `WSL_NDK_HOME` is not set.\n"
            "  --build-rust needs the WSL path of the Android NDK. Put it in\n"
            "  tools/.env as `WSL_NDK_HOME=/home/<user>/Android/Sdk/ndk/<version>`;\n"
            "  see tools/.env.example."
        )

    # No `shutil.which("wsl")` check here: `resolve()` already exits with
    # ``x `wsl` is not on PATH`` when `run()` is called with `wsl`.

    # A subdirectory of its own, because `download_rust_bundle` then downloads
    # the published asset into `work` under the same name and `gh release
    # download` refuses an existing destination file.
    out = work / "rust-build"
    out.mkdir(exist_ok=True)

    script = win_path_to_wsl(SCRIPT_DIR / "build_rust_bundle.sh")
    run(["wsl", "bash", script, rust_sha, ndk_home, win_path_to_wsl(out)])

    tag = f"rust-libs-{rust_sha}"
    run([
        "gh", "release", "create", tag, str(out / "rust-libs.tar.gz"),
        "--repo", slug,
        "--title", tag,
        "--notes", f"Native libraries built from sideswap_rust `{rust_sha}`. Delete only when no rust.sha refers to it.",
        "--prerelease",
    ])


def download_rust_bundle(slug: str, rust_sha: str, into: Path, build_rust: bool) -> Path:
    tag = f"rust-libs-{rust_sha}"
    if subprocess.run(
        resolve(["gh", "release", "view", tag, "--repo", slug]),
        capture_output=True,
    ).returncode != 0:
        if build_rust:
            build_rust_bundle(slug, rust_sha, into)
        else:
            sys.exit(
                f"x no `{tag}` prerelease.\n"
                "  The native libraries for the pinned commit have never been built.\n"
                "  Dispatch `.github/workflows/build.yml` once to produce them, or rerun\n"
                "  with `--build-rust` to build and publish them from WSL."
            )
    run(["gh", "release", "download", tag, "--repo", slug, "--pattern", "rust-libs.tar.gz", "--dir", str(into)])
    bundle = into / "bundle"
    with tarfile.open(into / "rust-libs.tar.gz") as tar:
        tar.extractall(bundle)
    return bundle


def stamp_app_version(version_name: str, build_number: int) -> None:
    """Rewrite the two constants the About screen reads.

    `flutter build --build-name/--build-number` reaches the APK's versionCode
    and the Windows version resource, but not this file.
    """
    lines = APP_VERSION_FILE.read_text(encoding="utf-8").splitlines()
    lines[0] = f"const appVersion = '{version_name}';"
    lines[1] = f"const appBuildNumber = {build_number};"
    APP_VERSION_FILE.write_text("\n".join(lines) + "\n", encoding="utf-8")


def zip_directory(source_dir: Path, zip_path: Path) -> None:
    print(f"\n> zipping {source_dir} -> {zip_path.name}")
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as archive:
        for file in source_dir.rglob("*"):
            if file.is_file():
                archive.write(file, file.relative_to(source_dir))
    print(f"  {zip_path.name} ({zip_path.stat().st_size / 1_048_576:.1f} MB)")


def prune(slug: str) -> None:
    """Keep the last releases of both kinds. `rust-libs-` tags are never touched."""
    numbered = sorted(
        ((int(m.group(1)), t) for m, t in ((TAG_PATTERN.match(t), t) for t in list_release_tags(slug)) if m),
        reverse=True,
    )
    for _, tag in numbered[KEPT_RELEASES:]:
        print(f"  pruning {tag}")
        run(["gh", "release", "delete", tag, "--repo", slug, "--yes", "--cleanup-tag"])


def build_windows(bundle: Path, version_name: str, build_number: int, out_dir: Path) -> Path:
    run([
        "flutter", "build", "windows", "--release",
        "--build-name", version_name,
        "--build-number", str(build_number),
    ])
    for dll in (bundle / "windows").glob("*.dll"):
        shutil.copy2(dll, WINDOWS_RELEASE_DIR / dll.name)
    asset = out_dir / f"sideswap-windows-{version_name}+{build_number}.zip"
    zip_directory(WINDOWS_RELEASE_DIR, asset)
    return asset


def build_android(bundle: Path, version_name: str, build_number: int, out_dir: Path) -> Path:
    # The workflow ships one ABI. Leaving the other three in place here would
    # produce a package three times the size and unlike the one CI publishes,
    # so only the kept ABI is staged; the caller restores the directory.
    shutil.rmtree(JNI_LIBS_DIR, ignore_errors=True)
    target = JNI_LIBS_DIR / KEPT_ABI
    target.mkdir(parents=True)
    shutil.copy2(bundle / "android" / KEPT_ABI / "libsideswap_client.so", target)

    run([
        "flutter", "build", "apk", "--debug", "--flavor", "full",
        "--build-name", version_name,
        "--build-number", str(build_number),
    ])
    asset = out_dir / f"sideswap-{version_name}+{build_number}-{KEPT_ABI}-debug.apk"
    shutil.copy2(APK_PATH, asset)
    print(f"  {asset.name} ({asset.stat().st_size / 1_048_576:.1f} MB)")
    return asset


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--platform",
        choices=["both", "windows", "android"],
        default="both",
        help="which artifacts to build (default: both)",
    )
    parser.add_argument(
        "--build-rust",
        action="store_true",
        help="build and publish the rust libs bundle in WSL when the pin has none",
    )
    args = parser.parse_args()

    slug = repo_slug()
    version_name = read_version_name()
    rust_sha = read_rust_pin()
    build_number = next_build_number(list_release_tags(slug))
    tag = f"local-{build_number}"
    commit = capture(["git", "rev-parse", "HEAD"]).strip()
    branch = capture(["git", "rev-parse", "--abbrev-ref", "HEAD"]).strip()

    print(f"repository   {slug}")
    print(f"version      {version_name}+{build_number}   tag {tag}")
    print(f"source       {branch} @ {commit[:12]}")
    print(f"rust pin     {rust_sha[:12]}")
    print(f"platform     {args.platform}")
    print(f"build rust   {args.build_rust}")

    work = Path(tempfile.mkdtemp(prefix="sideswap-local-"))
    out_dir = work / "out"
    out_dir.mkdir()

    app_version_backup = APP_VERSION_FILE.read_text(encoding="utf-8")
    jni_backup = work / "jniLibs-backup"
    if JNI_LIBS_DIR.exists():
        shutil.copytree(JNI_LIBS_DIR, jni_backup)

    assets: list[Path] = []
    try:
        bundle = download_rust_bundle(slug, rust_sha, work, args.build_rust)
        stamp_app_version(version_name, build_number)

        if args.platform in ("both", "windows"):
            assets.append(build_windows(bundle, version_name, build_number, out_dir))
        if args.platform in ("both", "android"):
            assets.append(build_android(bundle, version_name, build_number, out_dir))
    finally:
        # Restored whether or not the build succeeded, so a failed run never
        # leaves a stamped version file or a one-ABI jniLibs behind.
        APP_VERSION_FILE.write_text(app_version_backup, encoding="utf-8", newline="")
        shutil.rmtree(JNI_LIBS_DIR, ignore_errors=True)
        if jni_backup.exists():
            shutil.copytree(jni_backup, JNI_LIBS_DIR)

    notes = (
        f"Built on a developer machine, not on a runner. Source `{branch}` at "
        f"`{commit}`. Rust pin `{rust_sha}`. Not a product release."
    )
    run([
        "gh", "release", "create", tag,
        *[str(a) for a in assets],
        "--repo", slug,
        "--title", f"{version_name}+{build_number}",
        "--notes", notes,
        "--prerelease",
    ])
    prune(slug)

    shutil.rmtree(work, ignore_errors=True)
    print(f"\nhttps://github.com/{slug}/releases/tag/{tag}")


if __name__ == "__main__":
    main()
