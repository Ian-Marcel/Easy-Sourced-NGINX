#!/usr/bin/env bash

echo -e "${BGREEN}Dependencies satisfied. ${BCYAN}Getting NGINX package and extra unofficial modules... ${NC} \n"
wget --directory-prefix "$ESNx_TMP" --input-file "$ESNx_ASSETS/file/packages.ini" &&
    for tarballs in *.tar.gz; do
        tar -zxf "$tarballs" &&
            rm "$tarballs"
    done
