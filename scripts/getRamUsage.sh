#!/usr/bin/env bash

# Obtener el uso de la RAM
get_ram_usage() {
    echo "$(free -h | grep Mem | awk '{print $3 "/" $2}')"
}
