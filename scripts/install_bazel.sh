#!/bin/bash
set -xeuo pipefail

function install-bazelisk {
	if [[ "${OSTYPE}" == "darwin"* ]]; then
		# macos
		URL=https://github.com/bazelbuild/bazelisk/releases/download/v1.15.0/bazelisk-darwin
	elif [[ "${OSTYPE}" == "linux-gnu"* ]]; then
		# linux/ubuntu likely
		if [[ "$(dpkg --print-architecture)" == "amd64"* ]]; then
			URL=https://github.com/bazelbuild/bazelisk/releases/download/v1.15.0/bazelisk-linux-amd64
		else
			URL=https://github.com/bazelbuild/bazelisk/releases/download/v1.15.0/bazelisk-linux-arm64
		fi
	fi

	if [[ "${URL-}" == "" ]]; then
		echo "I apparently have no idea how to install Bazelisk on this machine and cannot proceed. :("
		exit 1
	fi

	BAZELISK_DEST=/usr/local/bin/bazel
	wget "${URL}" -O ${BAZELISK_DEST}
	chmod +x ${BAZELISK_DEST}
}

install-bazelisk
