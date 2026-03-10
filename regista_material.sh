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
##  Neste módulo registramos e organizamos os materiais em ficheiros .txt excutando 
## as devidas verificações a nível da integridade da informação recebida.
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

    if [ $# -eq 3 ]; then
        if ! [[ "$3" =~ ^[0-9]+$ ]] || [ "$3" -le 0 ]; then
            so_error S1.1 "Limite diário tem ser um valor positivo"
            exit 1
        fi
    fi

    so_success S1.1 "Argumento Valido"
    so_debug ">"
}

##/**
## * @brief  s1_2_ValidaMaterial 
## *
## * Verifica se o ficheiro materiais.txt existe e pode ser lido / escrito
## * Se não existe passa para S1.3
## * Se não se pode ler / escrever dá erro
## * Verifica se o <Material> existe (maiúsculas importam) 
## *
## */
s1_2_ValidaMaterial () {
    so_debug "<"

    if [ ! -f "materiais.txt" ]; then
        so_error S1.2 "Ficheiro materiais.txt não existe"
        touch materiais.txt 2>/dev/null
        if [ ! -f "materiais.txt" ]; then
            so_error S1.2 "Ficheiro materiais.txt não pode ser criado"
            exit 1
        fi
        return 0
    elif [ ! -r "materiais.txt" ] || [ ! -w "materiais.txt" ]; then
        so_error S1.2 "Ficheiro materiais.txt não tem as permissões de escrito ou leitura corretas"
        exit 1
    elif ! grep -q "^$1;" materiais.txt ; then
        so_error S1.2 "Material não está registado no sistema"
        return 0
    else 
        so_success S1.2 "Material válido"
        return 1
    fi

    so_debug ">"
}

##/**
## * @brief  s1_3_AdicionaMaterial 
## *
## * Escrever em materiais.txt novos materiais se for o caso
## *
## */
s1_3_AdicionaMaterial () {
    so_debug "<"

    if [ $# -eq 2 ]; then
        echo $1";"$2 >> materiais.txt
        so_success S1.3 "Material adicionado"
    elif [ $# -eq 3 ]; then
        echo $1";"$2";"$3 >> materiais.txt
        so_success S1.3 "Material adicionado"
    else
        so_error S1.3 "Erro ao adicionar o material à lista"
        exit 1
    fi

    so_debug ">"
}

##/**
## * @brief  s1_4_ListaMaterial 
## *
## * Cria ficheiro materiais-ordenados-preço.txt e passa os materiais ja registrados para lá por ordem crescente
## *
## */
s1_4_ListaMaterial () {
    so_debug "<"

    sort -t ";" -k2 -n materiais.txt > materiais-ordenados-preco.txt

    if [ ! $? -eq 0 ];then
        so_error S1.4 "Erro ao criar o ficheiro ordenado"
        exit 1
    fi

    so_success S1.4 "Materiais ordenados"
    so_debug ">"
}

main () { ## Passa os argumentos para cada uma das funções
    so_debug "<"

    s1_1_ValidaArgumentos "$@"

    s1_2_ValidaMaterial "$@"

    
    if [ $? -eq 1 ]; then
        s1_4_ListaMaterial "$@" 
    else 
        s1_3_AdicionaMaterial "$@"
        s1_4_ListaMaterial "$@"
    fi

    so_debug ">"
}
main "$@" # This statement invokes the function main(), with all the arguments passed by the user