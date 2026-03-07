#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº:       Nome:
## Nome do Módulo: manutencao.sh
## Descrição/Explicação do Módulo:
##
##
#####################################################################################

##// Constantes e variáveis globais
SUCCESS=0

##/**
## * @brief  s3_1_Manutencao Ler a descrição da tarefa S3.1 no enunciado
## */
s3_1_Manutencao () {
    so_debug "<"

    ##// Substituir este comentário pelo código a ser implementado pelo aluno

    so_debug ">"
}

main () {
    so_debug "<"

    ##// Substituir este comentário pelo código a ser implementado pelo aluno

    so_debug ">"
}
main "$@" # This statement invokes the function main(), with all the arguments passed by the user

## S3.2. Invocação do script:
## • Altere o ficheiro cron.def fornecido, por forma a configurar o seu sistema para que o Script: manutencao.sh  seja executado todos os dias de segunda-feira a sábado (incluindo feriados), quando tiver passado um minuto da meia-noite (às 0h01). Nos comentários no início do ficheiro cron.def, explique a configuração realizada, e indique qual é o comando Shell associado a essa configuração que vai ser utilizado para despoletar essa configuração.
## • O ficheiro cron.def alterado deverá ser submetido para avaliação juntamente com os outros Shell scripts
## • Não deverá ser acrescentado nenhum código neste ficheiro manutencao.sh para responder a esta alínea, todas as respostas deverão ser realizadas no ficheiro cron.def.