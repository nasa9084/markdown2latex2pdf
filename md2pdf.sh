#!/bin/bash

# function definitions
function vecho() {
    if [ $verbose -eq 1 ]; then
        echo "$1"
    fi
}

function markdown_filter() {
    vecho " filtering markdown..."
    stream="$1"
    stream=$(echo "$stream" | sed -E "s/^#//")
    stream=$(echo "$stream" | sed -E "s/<\!-- BREAK -->/\\\\newpage/g")
    markdown="$stream"
}

function tex_filter() {
    vecho " filtering TeX..."
    stream="$1"
    stream=$(echo "$stream" | sed -E "s/\\\\includegraphics/\\\\includegraphics[width=\\\\columnwidth]/g")
    stream=$(echo "$stream" | sed -E "s/verbatim/lstlisting/g")
    stream=$(echo "$stream" | sed -E "s/({変更履歴)/*\1/")
    stream=$(echo "$stream" | sed -E "s/({はじめに)/*\1/")
    stream=$(echo "$stream" | sed -E "s/({参考文献)/*\1/")
    tex="$stream"
}

function md2tex() {
    vecho " translate markdown to TeX..."
    tex=$(echo "$1" | pandoc --template="$template" -f markdown -t latex)
}

function tex2pdf() {
    vecho " compile TeX..."
    if [ $verbose -eq 1 ]; then
        platex --interaction=nonstopmode ${filename}.tex
        dvipdfmx ${filename}.dvi
    else
        platex --interaction=nonstopmode ${filename}.tex > /dev/null
        dvipdfmx ${filename}.dvi &> /dev/null
    fi
}

# flag parse
verbose=0
while getopts :t:vh OPT; do
    case $OPT in
        t)
            template="$OPTARG"
            ;;
        v)
            verbose=1
            ;;
        h)
            cat <<EOF
Usage: ${0##*/} [-t TEMPLATE] [--] FILENAME
       -t TEMPLATE template .tex file name
       -h show help and exit
EOF
            exit 0
            ;;
    esac
done
shift $(( OPTIND - 1 ))
OPTIND=1

# argument checking
filename="$1"

if [ "$1" = '' ]; then
    echo "FILENAME is required."
    cat <<EOF
Usage: ${0##*/} [-t TEMPLATE] [--] FILENAME
       -t TEMPLATE template .tex file name
       -h show help and exit
EOF
    exit 1
fi

template_gen=0
if [ "$template" = '' ]; then
    template="defaulttemplate.tex"
    template_gen=1
    cat <<'EOF' > defaulttemplate.tex
\documentclass[a4paper,12pt]{jsarticle}
\title{$title$}
\author{$author$}
\date{$date$}
\usepackage{listings}
\usepackage{url}
\usepackage{longtable}
\usepackage{booktabs}
\usepackage[dvipdfmx]{graphicx}
\usepackage[top=15truemm,left=20truemm,right=20truemm,bottom=20truemm]{geometry}
\def\tightlist{\itemsep1pt\parskip0pt\parsep0pt}
\setcounter{tocdepth}{2}
\begin{document}
\maketitle
\tableofcontents
$body$
\end{document}
EOF
fi

# main logic
for i in {0..1}; do
    vecho "### compile: $(expr $i + 1) ###"
    markdown=$(cat "$filename")
    markdown_filter "$markdown"
    md2tex "$markdown"
    tex_filter "$tex"
    echo "$tex" > "${filename}.tex"
    tex2pdf
done

rm -fr ${filename}.log ${filename}.dvi ${filename}.toc ${filename}.aux
if [ $template_gen -eq 1 ]; then
    rm -fr defaulttemplate.tex
fi
