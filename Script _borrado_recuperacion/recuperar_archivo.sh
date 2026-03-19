#!/usr/bin/env bash

source "$(dirname $0)/utils.sh" 

basurero="/tmp/"

listar_directorio() {
	local dir="/tmp/"
	for archivo in "$dir"/*; do
		if test -f "$archivo"; then
			echo "$(basename "$archivo")"
		fi
	done 
}

echo "---- Archivos disponibles: "
listar_directorio
echo "---------"

read -p "Ingresa el archivo a recuperar: " recuperado
test -f "$basurero/$recuperado" || reportar_error "Archivo invalido" 

read -p "Ingresa el directorio donde se resturara el archivo: " destino
test -d "$destino" || reportar_error "Directorio de destion invalido"

mv "$basurero/$recuperado" "$destino"
echo "Archivo recuperado correctamente"
