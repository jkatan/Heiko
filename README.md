# Heiko
Heiko is a new programming language tailored to perform numerical analysis

Instrucciones de compilacion:

1. Makefile: se proveen los siguientes comandos en el Makefile
	- make clean: remueve todos los archivos intermedios de compilacion y archivos generados por lex y yacc.
	- make all: compila el archivo en Lex y el archivo en Yacc y genera el compilador de Heiko
	- make fromzero: es equivalente a ejecutar make clean y luego make all

Por lo tanto, si se desea compilar el compilador de Heiko, hacer "make all", y si se desea recompilarlo, eliminando archivos intermedios, se puede usar "make fromzero".

2. Archivos generados por el makefile: Al ejecutar "make all" o "make fromzero"	notar que se generan los arhivos correspondientes a Lex y Yacc, y otros dos archivos, uno llamado compiler, que es generado por Yacc, y otro llamado heikoc, que es un programa que automatiza la compilacion de un script escrito en heiko.

3. Compilacion de scripts escritos en Heiko: se puede optar compilar los scripts de dos formas distintas. La forma recomendada es usar el programa heikoc generado por el makefile, que automatiza las tareas.

	- Usando heikoc: Simplemente ejecutar heikoc pasandole como primer argumento el nombre del archivo a compilar. Por ejemplo, si el archivo se llama "test_script", escribir "./heikoc test_script". Al terminar la ejecucion, heikoc va a haber generado en la carpeta donde se encuentra los archivos .class y .java correspondientes al script. El programa heikoc, luego de compilar y generar los archivos .class y .java, ejecuta el script.

	- Manualmente: Tambien, se puede optar por compilar manualmente, en vez de usar las funcionalidades que provee heikoc. Para esto, ejecutar el siguiente comando en la terminal de linux:

	"cat 'filename' | ./compiler > Heiko.java && javac Heiko.java"

	donde 'filename' es el archivo a compilar. Notar que el archivo "compiler" es el generado por yacc, que recibe por entrada estanar un programa escrito en heiko y deja en salida estandar su traduccion a Java. Entonces, lo que se hace con este comando es dejar en un archivo "Heiko.java" la salida del compilador, y luego se compila ese archivo en Java con el compilador de Java. Esto es lo que hace el programa heikoc internamente.

4. Ejecucion de scripts escritos en Heiko: Por ultimo, si se desea ejecutar un script de heiko ya compilado, escribir "java Heiko". Heiko es el nombre de la clase en Java que contiene el codigo traducido a partir de Heiko. 