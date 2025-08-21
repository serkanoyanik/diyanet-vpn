#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname -- "$0")/.."

if ! command -v dpkg-buildpackage >/dev/null 2>&1; then
  echo "dpkg-buildpackage not found. Install 'devscripts' or 'dpkg-dev' and 'debhelper'." >&2
  exit 1
fi

dpkg-buildpackage -us -uc -b

echo "Build complete. Check the parent directory for .deb files." 