#!/usr/bin/env bash

dnf_tasks=(
    "sudo dnf upgrade --refresh --quiet --assumeyes"
    "sudo dnf --assumeyes --quiet group install development-tools"
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
