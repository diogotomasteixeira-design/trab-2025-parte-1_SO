#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº: 129840 Nome: Diogo Teixeira
## Nome do Módulo: stats.sh
## Descrição/Explicação do Módulo:
##
##  Este módulo lê as informações escritas nos ficheiros materiais.txt e vendas.txt
## apresentando estatísticas e adicionando-as a um ficheiro .html
##
#####################################################################################

##// Constantes e variáveis globais
SUCCESS=0

##/**
## * @brief  s4_1_Validacoes
## *
## * Valida os ficheiros materiais.txt e vendas.txt garantindo que podem ser lidos
## * Valida os argumentos da chamada das outras funções
## *
## */
s4_1_Validacoes () {
    so_debug "<"

    if [ ! -f "materiais.txt" ]; then
        so_error S4.1 "Ficheiro materiais.txt não existe"
        exit 1
    elif [ ! -r "materiais.txt" ]; then
        so_error S4.1 "Ficheiro materiais.txt não tem as permissões de leitura corretas"
        exit 1
    fi

    if [ ! -f "vendas.txt" ]; then
        so_error S4.1 "Ficheiro vendas.txt não existe"
        exit 1
        if [ ! -r "vendas.txt" ]; then
            so_error S4.1 "Ficheiro vendas.txt não tem as permissões de leitura corretas"
            exit 1 
        fi
    fi

    echo "<html><head><meta charset=\"UTF-8\"><title>FerrIULândia: Estatísticas</title></head>" > stats.html
    echo "<body><h1>Lista atualizada em $(date +%Y-%m-%dT%H:%M) </h1>" >> stats.html
    echo -e "" >> stats.html

    if [ $# -eq 0 ]; then
        s4_2_1_Stat_Preco
        s4_2_2_Stat_Top3
        s4_2_3_Stat_Rei_Sucata
        s4_2_4_Stat_TopVendedores
    else
        for stat in "$@"; do
            case "$stat" in
                1) s4_2_1_Stat_Preco ;;
                2) s4_2_2_Stat_Top3 ;;
                3) s4_2_3_Stat_Rei_Sucata ;;
                4) s4_2_4_Stat_TopVendedores ;;
                *) so_error S4.1 "Opção inválida: $stat" ; exit 1 ;;
            esac
        done
    fi

    echo "</body></html>" >> stats.html
    so_success S4.1 "Argumentos válidos"
    so_debug ">"
}

##/**
## * @brief  s4_2_1_Stat_Preco 
## * 
## * Apresenta o material com o preço mais alto
## * 
## */
s4_2_1_Stat_Preco () {
    so_debug "<"

    echo "<h2>Stats1:</h2>" >> stats.html

    matcaro=$(sort -t";" -k2 -nr materiais.txt | head -1 | cut -d";" -f1)

    if [ $? -ne 0 ]; then
        so_error S4.2.1 "Erro ao obter o material"
    fi

    limite=$(grep "^${matcaro};" materiais.txt | cut -d ";" -f3)

    if [ $? -ne 0 ]; then
        so_error S4.2.1 "Erro ao obter o o limite de vendas"
    fi
    
    if [ -z "$limite" ];then
        echo "A bitcoin da sucata é: <b>$matcaro</b>, sem limite diário." >> stats.html
    else
        echo "A bitcoin da sucata é: <b>$matcaro</b>, com limite diário de: <b>$limite kg</b>." >> stats.html
    fi
    echo -e "" >> stats.html

    so_success S4.2.1
    so_debug ">"
}

##/**
## * @brief  s4_2_2_Stat_Top3 
## * 
## * Obter top3 materiais mais vendidos no mês
## * 
## */
s4_2_2_Stat_Top3 () {
    so_debug "<"

    echo "<h2>Stats2:</h2>" >> stats.html

    mes_atual=$(date "+%Y-%m")

    top3=$(grep ";${mes_atual}" vendas.txt | cut -d ";" -f2,3 | awk -F";" '{soma[$1]+=$2} END {for (m in soma) print soma[m]";"m}' | sort -t";" -k1 -nr | head -3)

    if [ $? -ne 0 ]; then
        so_error S4.2.2 "Erro ao obter o top3"
    fi

    echo "<ul>" >> stats.html
    contador=1
    while IFS=";" read -r peso material; do
        echo "<li>Top matéria ${contador}: <b>${material}</b>, com <b>${peso}Kg</b> transacionados.</li>" >> stats.html
        contador=$((contador + 1))
    done <<< "$top3"

    echo "</ul>">> stats.html

    echo -e "" >> stats.html

    so_success S4.2.2
    so_debug ">"
}

##/**
## * @brief  s4_2_3_Stat_Rei_Sucata 
## * 
## * Apresenta o operador que mais vendeu com menos kg vendidos no mês passado
## * 
## */
s4_2_3_Stat_Rei_Sucata () {
    so_debug "<"

    echo "<h2>Stats3:</h2>" >> stats.html

    mes_passado=$(date -d "last month" "+%Y-%m")
    utilizador=$(sort -nr vendas.txt | head -1 | cut -d ";" -f1)

    if [ $? -ne 0 ]; then
        so_error S4.2.3 "Erro ao obter o rei da sucata"
    fi

    echo "O rei das sucatas do mês de <b>${mes_passado}</b> é: <b>${utilizador}</b>." >> stats.html

    echo -e "" >> stats.html

    so_success S4.2.3
    so_debug ">"
}

##/**
## * @brief  s4_2_4_Stat_TopVendedores 
## * 
## * Os 3 operadores que realizaram mais vendas no ano
## * 
## */
s4_2_4_Stat_TopVendedores () {
    so_debug "<"

    echo "<h2>Stats4:</h2>" >> stats.html
    
    echo "<ul>" >> stats.html

    ano_atual=$(date "+%Y")
    top3=$(grep ";${ano_atual}" vendas.txt | cut -d ";" -f1 | sort | uniq -c | sort -nr | head -3)

    if [ $? -ne 0 ]; then
        so_error S4.2.4 "Erro ao obter o top3"
    fi
    
    contador=1
    while IFS= read -r linha; do
        vendas=$(echo "$linha" | awk '{print $1}')
        vendedor=$(echo "$linha" | awk '{$1=""; print $0}' | sed 's/^ //')
        echo "<li>Top vendedor ${contador}: <b>${vendedor}</b>, com <b>${vendas}</b> vendas.</li>" >> stats.html
        contador=$((contador + 1))
    done <<< "$top3"
    
    echo "</ul>">> stats.html

    echo -e "" >> stats.html

    so_success S4.2.4
    so_debug ">"
}

##/**
## * @brief  s4_3_1_Processamento Ler a descrição da tarefa S4.3.1 no enunciado
## */
s4_3_1_Processamento () {
    so_debug "<"

    ##// Substituir este comentário pelo código a ser implementado pelo aluno

    so_debug ">"
}

main () {
    so_debug "<"

    s4_1_Validacoes "$@"

    so_debug ">"
}
main "$@" # This statement invokes the function main(), with all the arguments passed by the user