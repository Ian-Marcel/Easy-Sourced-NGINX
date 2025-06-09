#!/usr/bin/env bash

yum_tasks=(
	"sudo yum upgrade --refresh --quiet --assumeyes"
	"sudo yum --assumeyes --quiet group install development-tools"
	"pcre"
	"zlib"
	"openssl"
	"libxml2"
	"libxslt"
	"geoip"
	"pcre-devel"
	"zlib-devel"
	"openssl-devel"
	"libxml2-devel"
	"libxslt-devel"
	"geoip-devel"
)
