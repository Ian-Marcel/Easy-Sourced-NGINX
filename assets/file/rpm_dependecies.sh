#!/usr/bin/env bash

dnf_tasks=(
    "sudo dnf check-upgrade --refresh"
    "sudo dnf upgrade --assumeyes"
    "sudo dnf --assumeyes group install development-tools"
    "pcre"
    "zlib"
    "openssl"
    "libxml2"
    "libxslt"
    "pcre-devel"
    "zlib-devel"
    "openssl-devel"
    "libxml2-devel"
    "libxslt-devel"
)
