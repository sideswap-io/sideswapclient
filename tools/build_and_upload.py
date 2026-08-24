"""
SideSwap build & Google Drive upload script.

Requirements:
    pip install google-auth-oauthlib google-auth-httplib2 google-api-python-client

First run: place credentials.json (OAuth 2.0 Desktop App) next to this script.
Subsequent runs: token.json is reused automatically.
"""

import os
import shutil
import subprocess
import sys
import zipfile
from pathlib import Path

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

# ── Config ────────────────────────────────────────────────────────────────────

SCRIPT_DIR = Path(__file__).parent
REPO_ROOT = SCRIPT_DIR.parent

RUST_PROJECT_DIR    = REPO_ROOT / ".." / "sideswap_rust"

def _load_env(path: Path) -> None:
    if not path.exists():
        return
    for line in path.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith("#") and "=" in line:
            k, v = line.split("=", 1)
            os.environ.setdefault(k.strip(), v.strip())

_load_env(SCRIPT_DIR / ".env")

WSL_BUILD_SCRIPT = os.environ.get("WSL_BUILD_SCRIPT", "")
WSL_COPY_SCRIPT  = os.environ.get("WSL_COPY_SCRIPT", "")

WINDOWS_RELEASE_DIR = REPO_ROOT / "build" / "windows" / "x64" / "runner" / "Release"
WINDOWS_DEBUG_DIR   = REPO_ROOT / "build" / "windows" / "x64" / "runner" / "Debug"
WINDOWS_LIBS_DIR    = REPO_ROOT / ".." / "libs" / "latest" / "windows"
ANDROID_LIBS_DIR    = REPO_ROOT / ".." / "libs" / "latest" / "android"
ANDROID_JNI_DIR     = REPO_ROOT / "android" / "app" / "src" / "main" / "jniLibs"
WINDOWS_ZIP_PATH    = REPO_ROOT / "build" / "windows.zip"
APK_DIR             = REPO_ROOT / "build" / "app" / "outputs" / "flutter-apk"

DRIVE_FOLDER_NAME   = "SideSwap"
SCOPES              = ["https://www.googleapis.com/auth/drive"]
CREDENTIALS_FILE    = SCRIPT_DIR / "credentials.json"
TOKEN_FILE          = SCRIPT_DIR / "token.json"

# ── Helpers ───────────────────────────────────────────────────────────────────

def run(cmd: str, cwd: Path = REPO_ROOT) -> None:
    print(f"\n▶ {cmd}")
    result = subprocess.run(cmd, shell=True, cwd=cwd)
    if result.returncode != 0:
        print(f"✗ Command failed (exit {result.returncode})")
        sys.exit(result.returncode)


def win_path_to_wsl(path: Path) -> str:
    resolved = path.resolve()
    drive = resolved.drive.rstrip(":").lower()
    rest = str(resolved)[len(resolved.drive):].replace("\\", "/")
    return f"/mnt/{drive}{rest}"


def build_rust() -> None:
    if not WSL_BUILD_SCRIPT or not WSL_COPY_SCRIPT:
        print("✗ WSL_BUILD_SCRIPT / WSL_COPY_SCRIPT not set. Create tools/.env (see .env.example).")
        sys.exit(1)
    wsl_rust   = win_path_to_wsl(RUST_PROJECT_DIR)
    wsl_parent = win_path_to_wsl(RUST_PROJECT_DIR / "..")
    run(f'wsl bash -l -c "cd {wsl_rust} && bash {WSL_BUILD_SCRIPT}"')
    run(f'wsl bash -l -c "cd {wsl_parent} && bash {WSL_COPY_SCRIPT}"')


def zip_directory(source_dir: Path, zip_path: Path) -> None:
    print(f"\n▶ Zipping {source_dir} → {zip_path}")
    zip_path.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
        for file in source_dir.rglob("*"):
            if file.is_file():
                zf.write(file, file.relative_to(source_dir))
    size_mb = zip_path.stat().st_size / 1_048_576
    print(f"  ✓ {zip_path.name} ({size_mb:.1f} MB)")


def auth_drive():
    creds = None
    if TOKEN_FILE.exists():
        creds = Credentials.from_authorized_user_file(TOKEN_FILE, SCOPES)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            try:
                creds.refresh(Request())
            except Exception:
                TOKEN_FILE.unlink(missing_ok=True)
                print("✗ Token expired or revoked. Re-run the script and log in again.")
                sys.exit(1)
        else:
            if not CREDENTIALS_FILE.exists():
                print(f"✗ Missing {CREDENTIALS_FILE}")
                print("  Download OAuth 2.0 Desktop App credentials from Google Cloud Console.")
                sys.exit(1)
            flow = InstalledAppFlow.from_client_secrets_file(CREDENTIALS_FILE, SCOPES)
            creds = flow.run_local_server(port=0)
        TOKEN_FILE.write_text(creds.to_json())
    return build("drive", "v3", credentials=creds)


def find_folder(service, name: str) -> str:
    q = f"name='{name}' and mimeType='application/vnd.google-apps.folder' and trashed=false"
    res = service.files().list(q=q, fields="files(id, name)").execute()
    files = res.get("files", [])
    if not files:
        print(f"✗ Google Drive folder '{name}' not found.")
        sys.exit(1)
    return files[0]["id"]


def delete_apks_and_zips(service, folder_id: str) -> None:
    q = (
        f"'{folder_id}' in parents and trashed=false and ("
        "name contains '.apk' or name contains '.zip')"
    )
    res = service.files().list(q=q, fields="files(id, name)").execute()
    files = res.get("files", [])
    if not files:
        print("  (no existing apk/zip files to delete)")
        return
    for f in files:
        service.files().delete(fileId=f["id"]).execute()
        print(f"  ✗ deleted {f['name']}")


def upload_file(service, local_path: Path, folder_id: str) -> str:
    mime = "application/zip" if local_path.suffix == ".zip" else "application/vnd.android.package-archive"
    meta = {"name": local_path.name, "parents": [folder_id]}
    media = MediaFileUpload(local_path, mimetype=mime, resumable=True)
    f = service.files().create(body=meta, media_body=media, fields="id").execute()
    return f["id"]


def make_shareable_link(service, file_id: str) -> str:
    service.permissions().create(
        fileId=file_id,
        body={"type": "anyone", "role": "reader"},
    ).execute()
    meta = service.files().get(fileId=file_id, fields="webContentLink").execute()
    return meta.get("webContentLink", f"https://drive.google.com/file/d/{file_id}/view")


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    # 0. Build Rust libs via WSL2 (all targets: Windows + Android + Linux)
    build_rust()

    # 1. Build Windows release
    run("flutter build windows --release")

    # 2. Copy extra libs into Release and Debug dirs
    if not WINDOWS_LIBS_DIR.exists():
        print(f"✗ Libs dir not found: {WINDOWS_LIBS_DIR}")
        sys.exit(1)
    for target_dir in (WINDOWS_RELEASE_DIR, WINDOWS_DEBUG_DIR):
        print(f"\n▶ Copying libs {WINDOWS_LIBS_DIR} → {target_dir}")
        target_dir.mkdir(parents=True, exist_ok=True)
        for src in WINDOWS_LIBS_DIR.iterdir():
            dst = target_dir / src.name
            if src.is_dir():
                shutil.copytree(src, dst, dirs_exist_ok=True)
            else:
                shutil.copy2(src, dst)
            print(f"  ✓ {src.name}")

    # 3. Zip Release directory
    zip_directory(WINDOWS_RELEASE_DIR, WINDOWS_ZIP_PATH)

    # 4. Copy Android libs into jniLibs
    if not ANDROID_LIBS_DIR.exists():
        print(f"✗ Android libs dir not found: {ANDROID_LIBS_DIR}")
        sys.exit(1)
    ANDROID_JNI_DIR.mkdir(parents=True, exist_ok=True)
    print(f"\n▶ Copying Android libs {ANDROID_LIBS_DIR} → {ANDROID_JNI_DIR}")
    for src in ANDROID_LIBS_DIR.iterdir():
        dst = ANDROID_JNI_DIR / src.name
        if src.is_dir():
            shutil.copytree(src, dst, dirs_exist_ok=True)
        else:
            shutil.copy2(src, dst)
        print(f"  ✓ {src.name}")

    # 5. Build APK (full flavor, split per ABI)
    run("flutter build apk --release --split-per-abi --flavor full")

    # 6. Collect files to upload
    apk_files = sorted(APK_DIR.glob("app-*-full-release.apk"))
    if not apk_files:
        print(f"✗ No full-release APKs found in {APK_DIR}")
        sys.exit(1)

    upload_files = apk_files + [WINDOWS_ZIP_PATH]
    print(f"\n▶ Files to upload ({len(upload_files)}):")
    for f in upload_files:
        print(f"  • {f.name}")

    # 7. Authenticate & connect to Drive
    print("\n▶ Authenticating Google Drive…")
    service = auth_drive()
    print("  ✓ authenticated")

    # 8. Find SideSwap folder
    folder_id = find_folder(service, DRIVE_FOLDER_NAME)
    print(f"  ✓ folder '{DRIVE_FOLDER_NAME}' found (id={folder_id})")

    # 9. Delete existing apk/zip
    print("\n▶ Removing old apk/zip from Drive…")
    delete_apks_and_zips(service, folder_id)

    # 10. Upload & create shareable links
    print("\n▶ Uploading…")
    results = []
    for local_path in upload_files:
        size_mb = local_path.stat().st_size / 1_048_576
        print(f"  ↑ {local_path.name} ({size_mb:.1f} MB)…", end=" ", flush=True)
        file_id = upload_file(service, local_path, folder_id)
        link = make_shareable_link(service, file_id)
        print("✓")
        results.append((local_path.name, link))

    # 11. Print results
    print("\n" + "─" * 72)
    print(f"{'FILE':<45} LINK")
    print("─" * 72)
    for name, link in results:
        print(f"{name:<45} {link}")
    print("─" * 72)


if __name__ == "__main__":
    main()
