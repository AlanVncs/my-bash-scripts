#!/bin/bash

#     Autor: alanvncs
#      Data: 29/01/2020
# Descrição: Instala o LibreOffice a partir do arquivo compactado tar.gz

DIR="$(dirname `readlink -f "${0}"`)"
source "${DIR}/colors"

# Verifica se foi executado como root
if [[ $EUID != 0 ]]; then
    echo -e "#"
    echo -e "#   É necessário executar este script com sudo"
    echo -e "#"
    echo -e "#   Command: ${COLORS_CMD}sudo libre-installer ${COLORS_PARAM}${1}${COLORS_CLR}"
    echo -e "#"
    exit 1
fi

file="${1}"

if [[ -z "${file}" ]]; then
    echo -e "#"
    echo -e "#   Indique o arquivo"
    echo -e "#   Ex.: ${COLORS_CMD}sudo libre-installer ${COLORS_PARAM}libreOffice.tar.gz${COLORS_CLR}"
    echo -e "#"
    exit 1
fi

file="$(${DIR}/abs-path.sh ${file})"

if ! [[ -f "${file}" ]]; then
    echo -e "#"
    echo -e "#   O arquivo ${COLORS_FILE}${file}${COLORS_CLR} não existe ou é inválido"
    echo -e "#"
    exit 1
fi

if [[ "${file}" =~ (.+)\.tar\.gz$ ]]; then
    name="${BASH_REMATCH[1]}"
else
    echo -e "#"
    echo -e "#   É necessário passar um arquivo válido (${COLORS_FILE}.tar.gz${COLORS_CLR})"
    echo -e "#"
    exit 1
fi

tmpDir="$(mktemp -d)"

if ! (tar -xf "${file}" -C ${tmpDir} --strip-components=1 &> /dev/null); then
    echo -e "#"
    echo -e "#   Não foi possível realizar a operação"
    echo -e "#   ${COLORS_CMD}tar -xf ${file}${COLORS_CLR}"
    echo -e "#   O arquivo pode estar corrompido"
    echo -e "#"
    exit 1
fi

echo -e "Iniciando instalação..."

dpkg -i "${tmpDir}/DEBS/"*".deb"

rm -rf "${tmpDir}"

echo -e "Instalação ${COLORS_SUCCESS}concluída${COLORS_CLR}!"