#! bin/bash

#paso uno  crear archivo en blanco
touch  archivosecuencia.txt

#paso dos quitar el salto de línea  va hasta el '\n' y (usa pipeline, o sea leer varios codigos), luego buscar secuencia
tr -d '\n' < sars_cov2.fasta | egrep  -o "GATATC"

#paso tres contar cuantas letras contiene el fragmento, o sea nucleotidos
wc -m

#paso cuatro  pasarle a una nueva linea a mi archivo inicial "archivosecuencia" el # de nucleotidos obtenidos
echo  resultado>archivosecuencia.txt
