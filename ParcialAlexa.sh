#! bin/bash
#verificamos la existencia de el archivo de respuesta y en caso de existir lo borramos
# ya que nunca lo borramos al terminar y por ende se puede seguir escribiendo
#en el mismo archivo y como resultado almacenar todas las respuestas de cada
# vez que se ejecute el codigo
test -f RespuestaAlexa.txt && rm RespuestaAlexa.txt


#creamos un archivo secuencia y otro final usando touch(auque no sea necesario)
touch secuencia.txt
touch RespuestaAlexa.txt



#eliminamos los saltos de linea de el archivo para poder leer la cadena
#una vez eliminados los saltos de linea usando un pipeline le pasamos
#a egrep la linea que estamos recibiendo, esto nos va a devovler la cadena
#cuantas veces se repita, tomamos esta salida del egrep y la almacenamos en el
#archivo secuencia
tr -d '\n' <sars_cov2.fasta | egrep -o "GATATC">secuencia.txt



#crearemos un array para poder usar un loop y contar letra por letra 
cadena=("G" "A" "T" "C")



#usamos un for loop que usa un array para poder leer cada letra y finalmente
#guardar el resultado en el archivo 
for letra in ${cadena[@]}
do

#la variable numero almacena el numero de veces que aparece la variable
#se usa  este orden debido a que egrep va a devolver multiples lineas y por ende
#saltos de linea,por lo que esto va a dar como resultado (si no usamos tr en esa pocision)
#el doble de la cantidad que hay realmente
numero=$(egrep -o $letra<secuencia.txt | tr -d '\n' |wc -c)

#almacena la salida en un archivo de texto
printf '%s\n' "la letra "$letra" se encuentra un total de: "$numero" veces">>RespuestaAlexa.txt
done


#dado que el archivo secuencia solo lo necesitabamos para almacenar las coincidencias ya lo podemos borrar
rm secuencia.txt

