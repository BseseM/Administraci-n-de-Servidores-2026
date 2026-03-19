#!/usr/bin/env bash

source "$(dirname $0)/utils.sh"

ayuda() {
	echo "$(basename $0) dirArchivo"
	echo "El script elimina un archivo de forma que sea recuperable"
	echo "Parámetros:"
	echo "	dirArchivo:Es la ruta del archivo a eliminar"
}

archivo="$1"

test "$archivo" || reportar_error "Debes pasar la ruta del archivo" ayuda 
test -f "$archivo" || reportar_error "Debes pasar un archivo" ayuda

#El archivo se mueve a la carpeta temporal /tmp
#para que se elimine al apagarse la maquina, pero pueda recuperarse antes

mv "$archivo" /tmp/

echo "archivo eliminado correctamente"
