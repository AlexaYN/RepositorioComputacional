#! bin/bash
#verificamos la existencia de el archivo de respuesta y en caso de existir lo borramos
# ya que nunca lo borramos al terminar y por ende se puede seguir escribiendo
#en el mismo archivo y como resultado almacenar todas las respuestas de cada
# vez que se ejecute el codigo, y solo necesitamos la respuesta de la ejecucion mas reciente
test -f RespuestaAlexa.txt && rm RespuestaAlexa.txt


#en orden de ejecucion:
#1: usamos sed (Stream EDitor) para borrar la primera linea de el archivo, ya que no es un renglon con nucleotidos
#pipeline
#2: usamos tr  (translate) para eliminar todos los saltos de line y obtener una sola linea en la que podamos buscar la secuencia
#nucleotidos que debemos quitar 
#pipeline
#3: usando sed una vez mas vamos a buscar la secuencia de nucleotidos, y cada que la encontremos la vamos a remplazar por
#un salto de linea seguido por la palabra "here" seguida por otro salto de linea, esto se veria en el archivo de la siguiente manera:
#
#here
#
#de ahora en adelante esto sera llamado marcador
#4: tomamos la salida de el comando anterior y lo guardamos en un archivo llamado Secuencia.txt, si el archivo no existe se va a crear
#y en caso de ya existir va a sobreescribirse, en este se esta guardando la secuencia de nucleotidos separados por el marcador ubicado en 
#donde se encontraban los nucleotidos que teniamos que buscar (GATATC) 
sed '1d' sars_cov2.fasta|tr -d '\n'|sed 's/GATATC/\n here\n /g'>Secuencia.txt

#egrep/grep al momento de dar un resultado, lo que hace es devolver una linea completa con la coincidencia encontrada, aqui es donde se
#utiliza el marcador anterior, ya que gracias a este podemos buscar solamente "here" y egrep lo va a localizar, y con -v se esta invirtiendo
#la busqueda, por lo que egrep va a devolver toda linea EN LA QUE NO EXISTA la palabra "here"efectivamente devolviendo cada uno de los bloques de 
#nucleotidos que necesitamos buscar, los cuales se van a almacenar en la variable analizar, podemos interpretar en este momento analizar como una
#lista de salidas(recordemos que egrep devuelve de manera individual cada coincidencia y no como una unica salida con saltos de linea)
#lo que facilita su posterior uso en el ciclo for 
analizar=$(egrep -v 'here' Secuencia.txt)


#usamos secuenciaID como un contador, este se usa para colocar en el archivo final el numero de bloque de nucleotidos que estamos analizando
secuenciaID=1

#ciclo for en el que tomamos cada una de las salidas almacenadas en analizar y la vamos guardando en
#la variable element; usamos el do en la linea de abajo porque se ve 
#mas lindo, no hay otro motivo
for element in $analizar 
do

	#almacenamos en la variable numero el conteo de caracteres que se encuentran en el bloque almacenado actualmente en element, este conteo
	#lo realiza el comando wc
	numero=$(echo $element|wc -c)
	
	#usamos printf para poder devolver una cadena de caracteres en la que de manera explicita decimos la secuencia o bloque de nucleotidos
	#que acabamos de analizar, y el numero de nucleotidos que se encontraban en esta 
	#estamos usando printf porque a diferencia de echo en este podemos escribir saltos de linea, y esta salida la concatenamos en el archivo 
	#que vamos a usar como respuesta
	printf 'la cadena de nucleotidos numero '$secuenciaID' cuenta con: '$numero' nucleotidos\n'>>RespuestaAlexa.txt
	
	#aumentamos el contador para que en el siguiente ciclo este diga el numero del el siguiente bloque, no es necesario bajo ningun concepto en 
	#este caso reiniciarlo ya que no necesitamos volver a 0 
	secuenciaID=$((secuenciaID+1))
done

#dado que el archivo secuencia solo lo necesitabamos de manera temporal ya lo podemos borrar
rm secuencia.txt

