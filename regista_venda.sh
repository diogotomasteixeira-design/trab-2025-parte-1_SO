#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº: 129849  Nome: Diogo Teixeira
## Nome do Módulo: regista_venda.sh
## Descrição/Explicação do Módulo:
##
##  Neste módulo estamos a registar a venda de materiais, garantindo que o vendedor é
## um utilizador registado do fenix e que existe disponibilidade do material em questão
##
#####################################################################################

##// Constantes e variáveis globais
SUCCESS=0

##/**
## * @brief  s2_1_ValidaArgumentos
## *
## * Valida se o número de argumentos é 3
## * Valida se o peso é >0
## *
## */
s2_1_ValidaArgumentos () {
    so_debug "<"

    if [ ! $# -eq 3 ]; then
        so_error S2.1 "Número de argumentos inválidos"
        exit 1
    elif ! [[ "$3" =~ ^[0-9]+$ ]] || [ "$3" -le 0 ]; then
        so_error S2.1 "Peso inválido"
        exit 1
    fi

    so_success S2.1 "Argumentos válidos"
    so_debug ">"
}

##/**
## * @brief  s2_2_ValidaVenda 
## * 
## * Valida se vendas.txt existe, pode ser lido e escrito
## * Valida se o <Material> existe em materiais.txt
## * Valida se a plataforma pode aceitar a venda do <Material> de acordo com o limite diário e quantidade pedida em Kg
## * Valida se o <Nome do Vendedor> é o nome de um utilizador do tigre
## * 
## */
s2_2_ValidaVenda () {
    so_debug "<"

    if [ ! -f "vendas.txt" ]; then
        so_error S2.2 "Ficheiro vendas.txt não existe"
        touch vendas.txt 2>/dev/null
        if [ ! -f "vendas.txt" ]; then
            so_error S2.2 "Ficheiro vendas.txt não pode ser criado"
            exit 1
        fi
    elif [ ! -r "vendas.txt" ] || [ ! -w "vendas.txt" ]; then
        so_error S2.2 "Ficheiro vendas.txt não tem as permissões de escrito ou leitura corretas"
        exit 1
    elif ! grep -q "^$2;" materiais.txt ; then
        so_error S2.2 "$2 não está registado em materiais.txt"
        exit 1
    fi

    total=$(grep ";$2;[^;]*;${hoje}" vendas.txt | cut -d ";" -f3 | awk '{sum+=$1} END {print sum+0}')
    limite=$(grep "^$2;" materiais.txt | cut -d ";" -f3)

    if [ $(($3 + $total)) -gt $limite ]; then
        so_error S2.2 "O limite de vendas de $2 é de ${limite}kg, pelo que hoje apenas poderá vender, no máximo, $(($limite - $total))kg deste material."
        exit 1
    fi

    utilizadores=$(cut -d ":" -f5 /etc/passwd | tr -d "," | awk '{print $1, $NF}')

    if ! echo "$utilizadores" | grep -q "^$1$"; then
        so_error S2.2 "Utilizador inválido"
        exit 1
    fi

    so_success S2.2 "Venda válida"
    so_debug ">"
}


##/**
## * @brief  s2_3_AdicionaVenda 
## * 
## * Acrescenta um registo a vendas.txt
## * 
## */
s2_3_AdicionaVenda () {
    so_debug "<"

    echo "$1;$2;$3;$(date +%Y-%m-%dT%H:%M ) " >> vendas.txt
    
    if [ ! $? -eq 0 ]; then
        so_error S2.3 "Erro ao registar venda"
        exit 1
    fi

    so_success S2.3 "Venda registada"
    so_debug ">"
}

main () {
    so_debug "<"

    s2_1_ValidaArgumentos "$@"
    s2_2_ValidaVenda "$@"
    s2_3_AdicionaVenda "$@"

    so_debug ">"
}
main "$@" # This statement invokes the function main(), with all the arguments passed by the user