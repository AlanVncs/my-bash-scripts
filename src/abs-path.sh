#!/bin/bash

#     Autor: alanvncs
#      Data: 27/01/2020
# Descrição: Dado um endereço relativo de um arquivo, retorna o endereço
#            absoluto deste arquivo baseado na posição atual do usuário (pwd)

relPath="$1"
userDir="$(pwd)"

# Sem argumento
if [[ -z "${relPath}" ]]; then
    echo "Argumento faltando"
    exit 1
fi

# Determina o endereço absoluto
if ! [[ ${relPath} =~ ^/ ]]; then
    echo "${userDir}/${relPath}"
else
    echo "${relPath}"
fi

exit 0