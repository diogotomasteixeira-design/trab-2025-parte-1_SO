#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº: 129840    Nome: Diogo Teixeira
## Nome do Módulo: regista_material.sh
## Descrição/Explicação do Módulo:
##
##
#####################################################################################

##// Constantes e variáveis globais
SUCCESS=0

##/**
## * @brief  s1_1_ValidaArgumentos 
## *
## * Num de argumenttos entre 2 e 3
## * <Material> pelos menos 2 caracteres 
## * <Preço por kg> valor >0
## * <Limite diário> (por omição é ilimitado) valor >0
## * 
## */
s1_1_ValidaArgumentos () {
    so_debug "<"

    if [ $# -lt 2 ] || [ $# -gt 3 ] ; then
        so_error S1.1 "Número de argumentos inválido"
        exit 1
    fi 

    if [ ${#1} -lt 2 ]; then
        so_error S1.1 "Material deve ter pelo menos 2 caracteres"
        exit 1
    fi

    if ! [[ "$2" =~ ^[0-9]+$ ]] || [ "$2" -le 0 ]; then
        so_error S1.1 "Preço por kilo tem de ser positivo"
        exit 1
    fi

    if [ -n "$3" ]; then
        if ! [[ "$3" =~ ^[0-9]+$ ]] || [ "$3" -le 0 ]; then
            so_error S1.1 "Limite diário tem ser um valor positivo"
            exit 1
        fi
    fi

    so_success S1.1 "Material Valido"
    so_debug ">"
}

##/**
## * @brief  s1_2_ValidaMaterial 
## *
## * Verifica se o ficheiro materiais.txt existe e pode ser lido / escrito
## * Se não existe cria
## * Se não se pode ler / escrever dá erro
## * Verifica se o <Material> existe (maiúsculas importam)
## *
## */
s1_2_ValidaMaterial () {
    so_debug "<"

    

    so_debug ">"
}

##/**
## * @brief  s1_3_AdicionaMaterial Ler a descrição da tarefa S1.3 no enunciado
## */
s1_3_AdicionaMaterial () {
    so_debug "<"

    ##// Substituir este comentário pelo código a ser implementado pelo aluno

    so_debug ">"
}

##/**
## * @brief  s1_4_ListaMaterial Ler a descrição da tarefa S1.4 no enunciado
## */
s1_4_ListaMaterial () {
    so_debug "<"

    ##// Substituir este comentário pelo código a ser implementado pelo aluno

    so_debug ">"
}

main () {. ## Passa os argumentos para cada uma das funções
    so_debug "<"

    s1_1_ValidaArgumentos "$@"

    s1_2_ValidaMaterial "$@"

    if [ $? -eq 0 ]; then
        s1_4_ListaMaterial "$@" 
    else 
        s1_3_AdicionaMaterial "$@"
        s1_4_ListaMaterial "$@"
    fi

    so_debug ">"
}
main "$@" # This statement invokes the function main(), with all the arguments passed by the user