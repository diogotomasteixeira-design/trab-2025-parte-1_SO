#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº: 129840 Nome: Diogo Teixeira
## Nome do Módulo: manutencao.sh
## Descrição/Explicação do Módulo:
##
##
#####################################################################################

##// Constantes e variáveis globais
SUCCESS=0

##/**
## * @brief  s3_1_Manutencao 
## * 
## * Verifica se materiais.txt existe, pode ser lido e escrito
## * Caso vendas.txt não exista não dá erro nenhum e se existir valida se pode ser lido
## * Verifica se algum <Material> atingiu o <Limite diário> no dia anterior se sim, aumento em 100kg
## * 
## */
s3_1_Manutencao () {
    so_debug "<"

    if [ ! -f "materiais.txt" ]; then
        so_error S3.1 "Ficheiro materiais.txt não existe"
        exit 1
    elif [ ! -r "materiais.txt" ] || [ ! -w "materiais.txt" ]; then
        so_error S3.1 "Ficheiro materiais.txt não tem as permissões de escrito ou leitura corretas"
        exit 1
    fi

    if [ -f "vendas.txt" ]; then
        if [ ! -r "vendas.txt" ]; then
            so_error S3.1 "ficheiro vendas.txt não pode ser lido"
            exit 1 
        fi
    fi

    ontem=$(date -d "yesterday" "+%Y-%m-%d")

    while IFS=";" read -r material preco limite; do
        [ -z "$limite" ] && continue

        total=0
        if [ -f "vendas.txt" ]; then
            total=$(grep "^[^;]*;${material};[^;]*;${ontem}" vendas.txt \
                    | cut -d";" -f3 \
                    | awk '{sum += $1} END {print sum+0}')
        fi

        if [ "$total" -eq "$limite" ]; then
            novo_limite=$((limite + 100))
            sed -i "s/^${material};${preco};${limite}$/${material};${preco};${novo_limite}/" materiais.txt
        fi

    done < materiais.txt


    so_success S3.1 "Manutenção realizada com sucesso"
    so_debug ">"
}

main () {
    so_debug "<"

    s3_1_Manutencao "$@"

    so_debug ">"
}
main "$@" # This statement invokes the function main(), with all the arguments passed by the user

## S3.2. Invocação do script:
## • Altere o ficheiro cron.def fornecido, por forma a configurar o seu sistema para que o Script: manutencao.sh  seja executado todos os dias de segunda-feira a sábado (incluindo feriados), quando tiver passado um minuto da meia-noite (às 0h01). Nos comentários no início do ficheiro cron.def, explique a configuração realizada, e indique qual é o comando Shell associado a essa configuração que vai ser utilizado para despoletar essa configuração.
## • O ficheiro cron.def alterado deverá ser submetido para avaliação juntamente com os outros Shell scripts
## • Não deverá ser acrescentado nenhum código neste ficheiro manutencao.sh para responder a esta alínea, todas as respostas deverão ser realizadas no ficheiro cron.def.