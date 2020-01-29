#!/bin/bash

# Autor: alanvinicios@gmail.com
# Data: 28/01/2020
# Descrição: Cria um link que será o comando para executar o script


DIR="$(dirname `readlink -f "${0}"`)"
source "${DIR}/colors"

# Verifica se foi executado como root
if [[ $EUID != 0 ]]; then
    echo -e "#"
    echo -e "# É necessário executar este script como root"
    echo -e "#"
    echo -e "#    Command: ${COLORS_CMD}sudo linkScript ${COLORS_PARAM}script.sh${COLORS_CLR}"
    echo -e "#"
    exit 1
fi

script="${1}"

if [[ "${script}" =~ ^[^/] ]]; then
    script="$(pwd)/${script}"
elif [[ -z "${script}" ]]; then
    echo -e "#"
    echo -e "#   Faltando parâmetro"
    echo -e "#"
    exit 1
fi

if ! [[ -f "${script}" ]]; then
    echo -e "#"
    echo -e "#   O arquivo ${COLORS_FILE}${script}${COLORS_CLR} não existe ou é inválido!"
    echo -e "#"
    exit 1
fi

chmod 755 "${script}"

# Obtém o nome do arquivo (Ex: /gg/files/cloneDR.sh -> cloneDR)
if [[ "${script}" =~ ([^/]+)\.sh$ ]]; then
    name="${BASH_REMATCH[1]}"
else
    echo -e "#"
    echo -e "#   É necessário passar um arquivo válido (${COLORS_FILE}.sh${COLORS_CLR})"
    echo -e "#"
    exit 1
fi

if [[ -e "/usr/local/bin/${name}" ]]; then
    rm -rf "/usr/local/bin/${name}"
fi

ln -s "${script}" "/usr/local/bin/${name}"
echo -e "#   Link gerado: ${COLORS_FILE}/usr/local/bin/${name}${COLORS_CLR} -> ${COLORS_FILE}${script}${COLORS_CLR}"