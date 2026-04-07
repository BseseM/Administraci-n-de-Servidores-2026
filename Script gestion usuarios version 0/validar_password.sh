#!/usr/bin/env bash

CONFIG="./password.conf"

if test -f "$CONFIG"; then
    source "$CONFIG"
else
    echo "Archivo de configuración no encontrado"
    exit 1
fi

validar_password() {
    local pass="$1"

    [[ ${#pass} -lt $MIN_LEN ]] && {
        echo "Debe tener al menos $MIN_LEN caracteres"
        return 1
    }

    [[ "$REQUIRE_UPPER" -eq 1 && ! "$pass" =~ [A-Z] ]] && {
        echo "Debe tener una mayúscula"
        return 1
    }

    [[ "$REQUIRE_LOWER" -eq 1 && ! "$pass" =~ [a-z] ]] && {
        echo "Debe tener una minúscula"
        return 1
    }

    [[ "$REQUIRE_NUMBER" -eq 1 && ! "$pass" =~ [0-9] ]] && {
        echo "Debe tener un número"
        return 1
    }

    [[ "$REQUIRE_SPECIAL" -eq 1 && ! "$pass" =~ [^a-zA-Z0-9] ]] && {
        echo "Debe tener un carácter especial"
        return 1
    }

    return 0
}
