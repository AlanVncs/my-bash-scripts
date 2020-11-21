#!/bin/bash

# Autor: alanvinicios@gmail.com
# Data: 28/01/2020
# Descrição: Move os arquivos e configura o PATH para reconhecer os scripts

DIR="$(dirname ${0})"
SRC_NAME="src"
SRC="${DIR}/${SRC_NAME}"

source "${SRC}/colors"

installDir="${1}"
arg="true"
if [[ -z ${installDir} ]]; then
    installDir='/scripts'
    arg="false"
fi

# Verifica se foi executado como root
if [[ $EUID != 0 ]]; then
    echo -e "#"
    echo -e "#   É necessário executar este script como root"
    echo -e "#"
    echo -e "#    Command: ${COLORS_CMD}sudo ./install.sh [${COLORS_PARAM}installDir${COLORS_CMD}]${COLORS_CLR}"
    echo -e "# ${COLORS_PARAM}installDir${COLORS_CLR}: Diretório de instalação (Padrão: ${COLORS_FILE}/scripts${COLORS_CLR})"
    echo -e "#"
    exit 1
fi

# Caso o arqumento não seja passado e o arquivo exista
if [[ "${arg}" == "false" && -e "${installDir}" ]]; then
    echo -e "#"
    echo -e "#   O diretório de instalação ${COLORS_FILE}${installDir}${COLORS_CLR} já existe. O que deseja fazer?"
    echo -e "#"
    echo -e "#   ${COLORS_CMD}1${COLORS_CLR} - Instalar em outro diretório"
    echo -e "#   ${COLORS_CMD}2${COLORS_CLR} - Instalar no mesmo diretório substituindo os arquivos atuais"
    echo -e "#"
    echo -n "#   Digite o número da opção: "
    read opt
    echo "#"
    if [[ ${opt} != 2 ]]; then
        if [[ ${opt} == 1 ]]; then
            echo -e "#   ${COLORS_FAIL}Todo o conteúdo do diretório escolhido será substituído!${COLORS_CLR}"
            echo "#"
            newInstallDir=""
            while [[ -z "${newInstallDir}" ]]; do
                echo -ne "#   Digite o diretório escolhido (Ctrl+C para sair): ${COLORS_FILE}"
                read newInstallDir
                echo -ne "${COLORS_CLR}"
            done
            installDir="$(${SRC}/abs-path.sh ${newInstallDir})"
        else
            exit 1
        fi
    fi
fi

if [[ -e "${installDir}" ]]; then
    rm -rf "${installDir}"
    echo -e "#"
    echo -e "#   Diretório ${COLORS_FILE}${installDir}${COLORS_CLR} deletado!"
fi

mkdir -p "${installDir}"
echo -e "#"
echo -e "#   Diretório ${COLORS_FILE}${installDir}${COLORS_CLR} criado!"
sleep 1

echo "#"
echo "#   Finalizando a instalação..."
echo "#"

cp -R ${SRC} "${installDir}"

# Cria os links que permitem que os scripts sejam executados de qualquer lugar
for file in ${installDir}/${SRC_NAME}/*.sh; do
    ${SRC}/gen-link.sh "${file}"
done


sleep 1
echo "#"
echo -e "#   Instalação concluída com ${COLORS_SUCCESS}sucesso${COLORS_CLR}!"
echo
