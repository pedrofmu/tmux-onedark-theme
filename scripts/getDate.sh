#!/usr/bin/env bash

previous_date=""

# Función para obtener la fecha en el formato especificado
get_date() {
    local format="${1:-%d/%m/%Y}"  # Usa el formato pasado como argumento, o un formato por defecto
    local current_date
    current_date=$(date +"$format")
    
    if [[ "$current_date" != "$previous_date" ]]; then
        previous_date="$current_date"
        echo "$current_date"
    else
        echo "$previous_date"
    fi
}
