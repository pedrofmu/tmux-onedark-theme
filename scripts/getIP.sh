#!/usr/bin/env bash
export LC_ALL=en_US.UTF-8

HOSTS="google.com github.com example.com"

get_ip()
{
  # Check OS
  case $(uname -s) in
    Linux)
      # Obtenemos la interfaz de red conectada (sea WiFi o Ethernet)
      interface=$(ip route | grep default | awk '{print $5}')
      # Obtenemos la IP de esa interfaz
      IP=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
      if [ -n "$IP" ]; then
        printf '%s' "$IP"
      else
        echo 'No IP found'
      fi
      ;;

    Darwin)
      # Para macOS usamos ifconfig para obtener la IP de la interfaz activa
      IP=$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}')
      if [ -n "$IP" ]; then
        printf '%s' "$IP"
      else
        echo 'No IP found'
      fi
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # Compatibilidad con Windows (por ejemplo, usando PowerShell o ipconfig)
      # Aquí podrías agregar compatibilidad con Windows si es necesario
      ;;

    *)
      ;;
  esac
}
