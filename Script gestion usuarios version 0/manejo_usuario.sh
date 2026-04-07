#!/usr/bin/env bash

source "$(dirname $0)/validar_password.sh"

comprobar_grupo() {
	local grupo="$1"
	if cut -d":" -f1 /etc/group | grep "$grupo" &> /dev/null; then
		return 0
	else 
		echo "Grupo invalido o no existe"
		return 1
	fi
}

crear_usuario() {
	read -p "Ingresa el nombre completo del usuario:" comentario
	test -z "$comentario" && { echo "El nombre completo no puede estar vacio"; return; }

	read -p "Ingresa la ruta del directorio home, Ejemplo /home/usuario:" dir_home
	test -z "$dir_home" && { echo "El directorio no puede estar vacio"; return; }

	echo "Grupos disponibles:"
	cut -d":" -f1 /etc/group 
	
	read -p "Ingresa el grupo para agregar el usuario:" grupo
	test -z "$grupo" && { echo "El grupo no puede estar vacio"; return; }
	comprobar_grupo "$grupo" || return 
	echo "-----------------------------"

	echo "Shells disponibles:"
	cat /etc/shells
	
	read -p "Ingresa el shell del usuario:" shell 
	test -z "$shell" && { echo "El shell no puede estar vacio"; return; }

	read -p "Ingresa el nombre del usuario:" usuario
	test -z "$usuario" && { echo "El nombre de usuario no debe estar vacio"; return; }

	if useradd -c "$comentario" -d "$dir_home" -m -k /etc/skel -g "$grupo" -s "$shell" "$usuario" &> /dev/null; then
		echo "Usuario creado correctamente"
		else
		echo "Error al crear usuario"
		return 
	fi
	
	asignar_contrasena "$usuario"
	
}

asignar_contrasena() {
	local usuario="$1"
	while true; do
		read -s -p "Ingresa la contrasena para $usuario: " password
		if validar_password "$password"; then 
			echo "$usuario:$password" | chpasswd 
			return 0
		else
			echo "Intenta otra vez"
		fi
	done
}

borrar_usuario() {
	read -p "Ingresa el usuario a eliminar:" usuario
	if grep -E "^$usuario" /etc/passwd &> /dev/null; then   
		 userdel -r $usuario >& /dev/null
		 echo "Usuario $usuario eliminado"
	else   
		echo "Usuario invalido o no existe" 
		return 1
	fi
}


echo "Selecciona una opcion"

OPTIONS="Crear_usuario Borrar_un_usuario Salir"

select opt in $OPTIONS; do
	if [ "$opt" = "Crear_usuario" ]; then
		crear_usuario
	elif [ "$opt" = "Borrar_un_usuario" ]; then
		borrar_usuario
	elif [ "$opt" = "Salir" ]; then
		echo "Cerrando programa..."
		exit								
	else
		clear
		echo "Seleccion incorrecta"		
	fi
done
