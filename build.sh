#!/bin/bash

ARG1=${1:-foo}

cwd="$(pwd)"

echo "mkdir -p build"
mkdir -p build
for tarea in ./trabajo/*.tex; do

    if [ $ARG1 == "-matlab" ]; then
        echo "cd ${tarea/\.tex/}"
        cd ${tarea/\.tex/}
        
        for filename in ./*.m; do
            echo "matlab -nodisplay -nodesktop \\"
            echo "-r \"run ${filename}\""
            matlab -nodisplay -nodesktop \
            -r "run ${filename}" 
        done
        
        echo "cd ${cwd}"
        cd ${cwd}
    fi

    for j in 1 2; do
        echo ""
        echo "#############################################################################################"
        echo ""
        echo "pdflatex -shell-escape -interaction=nonstopmode \\"
        echo "-jobname=Tarea1 -output-directory=build \\"
        echo "-8bit ${tarea} \\"
        echo "| grep -E \"l\.[0-9]*\s+|!  ==>|!\ LaTeX\ Error|!\ LaTeX\ Warning|Package|Output written|Transcript written\" "
        echo ""
        pdflatex -shell-escape -interaction=nonstopmode \
        -jobname=Tarea1 -output-directory=build \
        -8bit ${tarea} \
        | grep -E "l\.[0-9]*\s+|!  ==>|!\ LaTeX\ Error|!\ LaTeX\ Warning|Package|Output written|Transcript written" 
    done

done