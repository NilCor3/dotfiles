#!/usr/bin/env bash
# Install jdtls (Eclipse JDT Language Server) and lombok
# into ~/.local/share/nvim-java/ without Mason.
# Runs once per machine (chezmoi run_once_).
set -euo pipefail

DIR="$HOME/.local/share/nvim-java"
mkdir -p "$DIR"

# ── jdtls ────────────────────────────────────────────────────────────────────
JDTLS_VERSION="1.57.0"
JDTLS_MILESTONE="202602261110"
JDTLS_TAR="jdt-language-server-${JDTLS_VERSION}-${JDTLS_MILESTONE}.tar.gz"
JDTLS_URL="https://download.eclipse.org/jdtls/milestones/${JDTLS_VERSION}/${JDTLS_TAR}"

if [[ ! -d "$DIR/jdtls/plugins" ]]; then
  echo "Downloading jdtls ${JDTLS_VERSION}..."
  mkdir -p "$DIR/jdtls"
  curl -fsSL "$JDTLS_URL" -o "/tmp/${JDTLS_TAR}"
  tar -xzf "/tmp/${JDTLS_TAR}" -C "$DIR/jdtls"
  rm "/tmp/${JDTLS_TAR}"
  echo "jdtls installed at $DIR/jdtls"
else
  echo "jdtls already installed, skipping."
fi

# ── lombok ───────────────────────────────────────────────────────────────────
LOMBOK_VERSION="1.18.38"
LOMBOK_URL="https://projectlombok.org/downloads/lombok-${LOMBOK_VERSION}.jar"

if [[ ! -f "$DIR/lombok.jar" ]]; then
  echo "Downloading lombok ${LOMBOK_VERSION}..."
  curl -fsSL "$LOMBOK_URL" -o "$DIR/lombok.jar"
  echo "lombok installed."
else
  echo "lombok already installed, skipping."
fi

echo "Java LSP setup complete: $DIR"
