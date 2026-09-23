# ADR-0015 — Builds run on GitHub's free runners, and the Rust libraries are built once per pin

- **Status:** Accepted
- **Date:** 2026-09-08
- **Driver:** There is no automated build. A Windows release and a debug APK are produced by `tools/build_and_upload.py` on one developer machine, which cross-compiles the Rust libraries in WSL and uploads the result to Google Drive. Nobody else can produce a testable build, and no build is reproducible.
- **Vocabulary:** *pinned rust commit*, *rust libs bundle*, *build prerelease* and *CI build number* are defined in [CONTEXT.md](../../CONTEXT.md#build-pipeline). Issues, tags and workflow job names use those words.
- **Scope:** a new `.github/workflows/build.yml`, a new `rust.sha` at the root, a `signingConfigs` block and a committed `debug.keystore` in `android/app/`. No production Dart code changes.

## Context

### What constrains the design

Three facts set the whole shape, and two of them cannot be changed from inside this repo.

`sideswap-io/client_private` is **private**. Actions minutes are metered against the organisation, and the Windows runner carries a 2x multiplier while Linux carries 1x. The artifact storage quota is small. Release assets do not count against it.

The developer driving this has **`push` but not `admin`** on the repository. That removes repository secrets, self-hosted runner registration, and any change to the Actions settings or the artifact retention. Every decision below is reachable with `push` alone.

`sideswap-io/sideswap_rust` is **public**, but the same developer has **`pull` only**. Building the libraries in the repository where minutes are free is therefore not available, however attractive it looks.

### What the build actually needs

The Flutter side is cheap. The Rust side is not: the workspace vendors `gdk_rust`, and a cold build of the two targets this project needs takes tens of minutes. The shipped Windows DLL is cross-compiled from Linux with `x86_64-pc-windows-gnu`, so four MinGW runtime libraries ship beside it. `sideswap_client/build.rs` runs `prost_build` and `vergen_gitcl`; the include path it passes points at a directory that does not exist and the proto imports nothing, so the crate builds standalone and needs no second checkout.

`prost-build` 0.12 does **not** vendor a `protoc` binary, despite what its documentation suggests for later versions. Without one on `PATH`, `build.rs` panics with "Could not find `protoc`" after about six minutes of compiling. The first full run failed exactly there.

Three generated Dart surfaces are committed here and derived from `sideswap_rust`: the protobuf bindings under `thirdparty/sideswap_protobuf/lib/src`, `ffi/gen/side_swap_client_ffi.h`, and `lib/side_swap_client_ffi.dart`. A drift between them and the *pinned rust commit* produces no compile error. It produces a runtime failure.

### What the capability probe settled

A one-shot `probe.yml` was pushed to a branch and run once, because four facts could not be read without admin. Run `34203666770`, `ubuntu-24.04`, image `20260831.293.1`:

- Actions are enabled, and a `push` trigger runs from a non-default branch.
- `GITHUB_TOKEN` is granted `Contents: write`. `gh release create` and `gh release delete --cleanup-tag` both succeeded.
- NDK `28.2.13676358` is on the image — the same version the local Android script uses. Java is Temurin 17, matching `jvmTarget = 17`.
- **MinGW is not installed** and **`protoc` is not installed**.

## Decisions

### 1. The Rust libraries are built once per pin, not once per build

A *rust libs bundle* is built from the *pinned rust commit* and stored as the assets of a `rust-libs-<sha>` *build prerelease*. A build that finds the bundle downloads it. A build that does not, builds it and publishes it first. The expensive job therefore runs when `rust.sha` moves, and at no other time.

### 2. The bundle lives in a release, not in the Actions cache

The Actions cache is scoped per branch, so a run from a working branch cannot read a cache written on `master`, and an entry is evicted after seven days without a hit. Both failure modes land exactly when builds are infrequent, which is the case here. A release asset has neither property, does not expire, and does not consume the storage quota.

### 3. The Windows DLL is cross-compiled on Linux

`x86_64-pc-windows-gnu` on `ubuntu-latest` costs 1x. The same build on `windows-latest` with MSVC costs 2x. The cross-compiled path is also the path that produces the shipped product today, so it is the tested one. The price is four MinGW runtime libraries, about 28 MB, added to the Windows archive. The job installs `gcc-mingw-w64-x86-64` and `g++-mingw-w64-x86-64` with `apt-get`, because the probe recorded that the image carries neither.

### 4. `rust.sha` pins the Rust commit

One file, one line, one full SHA. Tracking `sideswap_rust`'s default branch `main` would make a build depend on a repository this project does not control and cannot revert. The opening pin is `612474f05ee908c4c3fe2ec021ed13d79a7e7ecd`, the commit the committed Dart bindings were verified against.

### 5. The debug APK carries one ABI

`arm64-v8a` only. This is the single largest cost lever on the Rust job, and it covers the device under test. An emulator needs `x86_64` and is out of scope; adding it means a new bundle.

### 6. The build is dispatched by hand

`workflow_dispatch` with a `platform` input of `both`, `windows` or `android`. A trigger on every push to `master` would spend metered minutes on merges nobody is testing, and would need the workflow to commit a version bump. Neither is wanted.

### 7. The version is `1.9.2+<n>`, where `n` is one shared counter

The version name comes from `pubspec.yaml`. The *CI build number* `n` is one past the highest number any `build-<n>` or `local-<n>` release already carries. Both sides compute it that way: the workflow and `tools/build_local_release.py` (decision 12). Both are passed through `flutter build --build-name --build-number`.

`github.run_number` was the first choice and is wrong once a second source exists. It counts runs of one workflow and knows nothing about packages built elsewhere, so a developer machine could publish `+9` and the next CI run would publish `+7`. Android reads that as a downgrade and refuses the install. A counter derived from the releases themselves is the only one both sides can agree on without shared state. `windows/runner/Runner.rc` already reads `FLUTTER_BUILD_NAME` and `FLUTTER_BUILD_NUMBER`, so the executable version resource follows with no edit. `lib/app_version.dart` does not, so the workflow rewrites its two constants in the checkout and commits nothing.

A CI build therefore starts at a `versionCode` far below the shipped `5033`. Android refuses that install with `INSTALL_FAILED_VERSION_DOWNGRADE`, so moving from a locally built APK to a CI one costs one uninstall. This was chosen over an offset, because a build number that reads `+16` says which run produced it and a number that reads `+5049` says nothing.

### 8. The debug keystore is committed and used everywhere

`android/app/debug.keystore` with an explicit `signingConfigs { debug { ... } }` block. A runner generates a fresh keystore on every run otherwise, and every CI APK would then need an uninstall rather than only the first. Using it locally as well is what makes a CI build update a local one. A debug keystore is not a secret; it signs nothing that is distributed.

### 9. `flutter analyze` gates the build

It runs on Linux, takes about three minutes, and it runs before the Windows job. Three cheap minutes stop a compile error from spending twenty-four expensive ones. The generated Dart is committed, so no `build_runner` step is needed. The test suite is not run: it is run locally, and duplicating it here doubles the bill.

### 10. Protobuf drift fails the build

A job regenerates `thirdparty/sideswap_protobuf/lib/src/*.pb.dart` from the proto at the *pinned rust commit* and fails on any diff. `protoc_plugin` is pinned to `25.0.0` and `protoc` to `36.0`, downloaded from the protobuf release rather than `apt`, which carries `3.21`. Those two versions were verified to reproduce the committed files byte for byte. The `cbindgen` and `ffigen` surfaces are not checked; that is a separate issue.

### 11. Only the last five `build-<n>` prereleases are kept

The workflow prunes them and never touches a `rust-libs-<sha>`. Five is enough to compare a regression against and small enough that the Releases list stays readable.

### 12. A local script is the fallback when the minutes run out

`tools/build_local_release.py` builds the same two artifacts on a developer machine and attaches them to a `local-<n>` prerelease. It calls only the Releases API, so it spends no metered minutes. It downloads the *rust libs bundle* rather than rebuilding it, so the native libraries are byte for byte the ones the workflow ships, and it fails with a clear message when the pin has no bundle yet and `--build-rust` is not given.

`--build-rust` covers the case that message describes. It builds the bundle in WSL from the pinned commit, publishes it as the `rust-libs-<sha>` prerelease, and then the download path runs unchanged. This route is not byte for byte reproducible: the `protoc` of WSL is not the one of the runner, and the MinGW toolchain of WSL need not match the runner's either. `rustc` is not a difference, because `sideswap_rust/rust-toolchain.toml` pins the channel and both sides honour it. The script names the posix MinGW variant, because the WSL default is the win32 one and the runtime libraries must come from the compiler that linked the DLL. It needs `WSL_NDK_HOME` in `tools/.env`.

This is not a second pipeline. It is the same artifacts by a slower, unreproducible route, and it exists because the metered quota is an organisation-level resource this project cannot see or control. The two tag prefixes keep the lists separable; decision 7 keeps the numbers compatible.

The first real full run proved the need: the `prune` job was refused with *"The job was not started because recent account payments have failed or your spending limit needs to be increased"*, after the packages themselves had already been built.

## Consequences

- A full run costs roughly 36 metered minutes: about 24 for Windows at the 2x multiplier, 7 for Android, and 5 for the gate and the drift check. An Android-only run costs about 7. A `rust.sha` bump adds 40 to 60 minutes, once.
- The Releases list of a private repository gains entries that are not product releases. The `rust-libs-` and `build-` prefixes are what keeps them legible, and every one of them is marked pre-release.
- `tools/build_and_upload.py` is not replaced. It still builds all four ABIs, the Linux library and a signed Windows release, and it still uploads to Drive. The workflow is the reproducible path, not the release path.
- Anyone with `push` can spend the organisation's minutes. There is no way to restrict that without admin.

## Alternatives rejected

- **Build the libraries in `sideswap_rust`, where minutes are free.** The developer has `pull` only. It is the right answer once that changes.
- **A self-hosted runner on the developer machine.** Zero metered minutes, but registration needs admin.
- **`actions/upload-artifact`.** Consumes the storage quota, and the retention period cannot be shortened without admin. A debug APK plus a Windows archive fills the quota within two runs.
- **Binaries on a branch.** Git refuses a file above 100 MB, and the repository would grow permanently.
- **`Swatinem/rust-cache` over the whole `target` directory.** Two targets of this workspace exceed the 10 GB per-repository cache limit, so entries evict each other.
- **Building the DLL natively with MSVC.** Twice the price, and it is not the toolchain the product ships with.

## Work

1. `rust.sha`, `android/app/debug.keystore` and the `signingConfigs` block.
2. `.github/workflows/build.yml`, and delete `probe.yml`.
3. One dispatch to prove the bundle job, one to prove the cached path.
