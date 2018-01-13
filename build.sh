mkdir -p build
for i in tarea1
do
    cd trabajo/${i}
    for k in ej1
    do 
        matlab -nodisplay -nodesktop -r "run ${k}.m" 
    done
    cd ../..
    for j in 1 2
    do
        pdflatex -interaction=nonstopmode \
        -jobname=Tarea1 -output-directory=build \
        -8bit trabajo/${i}.tex
    done
done