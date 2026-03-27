#!/usr/bin/env bash
# install.sh -- Install seine from GitHub Releases
# Author: Christopher Boone
# Date: 2026-03-27
set -euo pipefail

readonly REPO="cboone/seine"
readonly BINARY="seine"
readonly INSTALL_DIR="${INSTALL_DIR:-${HOME}/.local/bin}"

function parse_args() {
  VERSION=""
  while [[ ${#} -gt 0 ]]; do
    case "${1}" in
      --version)
        VERSION="${2}"
        shift 2
        ;;
      *)
        printf 'Unknown argument: %s\n' "${1}" >&2
        exit 1
        ;;
    esac
  done
}

function fetch_latest_version() {
  local version
  version="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' || true)"
  if [[ -z "${version}" ]]; then
    printf 'Error: could not determine latest version.\n' >&2
    exit 1
  fi
  printf '%s' "${version}"
}

function detect_os() {
  local os
  os="$(uname -s)"
  case "${os}" in
    Linux)  printf 'linux' ;;
    Darwin) printf 'darwin' ;;
    *)
      printf 'Unsupported OS: %s\n' "${os}" >&2
      exit 1
      ;;
  esac
}

function detect_arch() {
  local arch
  arch="$(uname -m)"
  case "${arch}" in
    x86_64)  printf 'amd64' ;;
    aarch64) printf 'arm64' ;;
    arm64)   printf 'arm64' ;;
    *)
      printf 'Unsupported architecture: %s\n' "${arch}" >&2
      exit 1
      ;;
  esac
}

function verify_checksum() {
  local tarball_path="${1}"
  local tarball_name="${2}"
  local checksums_url="${3}"
  local tmpdir="${4}"

  if ! curl -fsSL -o "${tmpdir}/checksums.txt" "${checksums_url}" 2>/dev/null; then
    return 0
  fi

  printf 'Verifying checksum...\n'
  local expected
  expected="$(awk -v t="${tarball_name}" '$0 ~ t { print $1 }' "${tmpdir}/checksums.txt")"
  if [[ -z "${expected}" ]]; then
    return 0
  fi

  local actual
  if command -v sha256sum >/dev/null 2>&1; then
    actual="$(sha256sum "${tarball_path}" | awk '{ print $1 }')"
  elif command -v shasum >/dev/null 2>&1; then
    actual="$(shasum -a 256 "${tarball_path}" | awk '{ print $1 }')"
  else
    printf 'Warning: no sha256 tool found, skipping checksum verification.\n' >&2
    return 0
  fi

  if [[ "${actual}" != "${expected}" ]]; then
    printf 'Checksum mismatch: expected %s, got %s\n' "${expected}" "${actual}" >&2
    exit 1
  fi
  printf 'Checksum verified.\n'
}

function validate_archive() {
  local tarball_path="${1}"

  if tar -tzf "${tarball_path}" | grep -qE '(^/|(^|/)\.\./(/|$))'; then
    printf 'Error: archive contains unsafe paths, refusing to install.\n' >&2
    exit 1
  fi
}

function main() {
  parse_args "${@}"

  if [[ -z "${VERSION}" ]]; then
    VERSION="$(fetch_latest_version)"
  fi

  local os
  os="$(detect_os)"
  local arch
  arch="$(detect_arch)"

  local tarball="${BINARY}-${VERSION#v}-${os}-${arch}.tar.gz"
  local url="https://github.com/${REPO}/releases/download/${VERSION}/${tarball}"
  local checksums_url="https://github.com/${REPO}/releases/download/${VERSION}/checksums.txt"

  local tmpdir
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "${tmpdir}"' EXIT

  printf 'Downloading %s %s for %s/%s...\n' "${BINARY}" "${VERSION}" "${os}" "${arch}"
  curl -fsSL -o "${tmpdir}/${tarball}" "${url}"

  verify_checksum "${tmpdir}/${tarball}" "${tarball}" "${checksums_url}" "${tmpdir}"
  validate_archive "${tmpdir}/${tarball}"

  local extract_dir="${tmpdir}/extract"
  mkdir -p "${extract_dir}"
  tar -xzf "${tmpdir}/${tarball}" -C "${extract_dir}"
  mkdir -p "${INSTALL_DIR}"
  install -m 755 "${extract_dir}/${BINARY}" "${INSTALL_DIR}/${BINARY}"

  printf 'Installed %s to %s/%s\n' "${BINARY}" "${INSTALL_DIR}" "${BINARY}"

  case ":${PATH}:" in
    *":${INSTALL_DIR}:"*) ;;
    *)
      printf '\nNote: %s is not in your PATH.\n' "${INSTALL_DIR}"
      # shellcheck disable=SC2016
      printf 'Add it with: export PATH="%s:${PATH}"\n' "${INSTALL_DIR}"
      ;;
  esac
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${@}"
