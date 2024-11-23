#!/usr/bin/env bash

## Construindo, compilando e instalando a configuração NGINX #######################
echo -e "\n${BGREEN}Package and modules obtained! ${BCYAN}Configuring NGINX... ${NC} \n"
cd nginx-1.26.2 || exit
source configure.sh &&
    echo -e "${BGREEN}NGINX configured! ${BCYAN}Compiling NGINX... ${NC} \n" &&
    make &&
    echo -e -e "${BGREEN}NGINX compiled! ${BCYAN}Installing NGINX... ${NC} \n" &&
    sudo make install
