#!/bin/bash
#Creado por: Garcia .J, Demarco .R, Suarez .R

if [ ! -x "$0" ]; then
    chmod +x "$0"
    exec "$0" "$@"
    exit
fi

ruta_guardada=""

obtenerRuta(){
    local mensaje="$1"
    if [ -n "$ruta_guardada" ]; then
        echo "$ruta_guardada"
        return 0
    else
        while true; do
            read -r -p "$mensaje" ruta
            if [ -d "$ruta" ]; then
                echo "$ruta"
                return 0
            else
                printf "\n\033[31mERROR:\033[0m '%s' no existe, intente nuevamente\n\n" "$ruta" >&2
            fi
        done
    fi
}

definirRuta(){
    while true; do
        read -p "Ingrese la ruta deseada: " ruta_guardada
        if [ -d $ruta_guardada ]; then
            echo "Ruta definida con exito: $ruta_guardada"
            break
        else
            printf "\n\033[31mERROR:\033[0m '%s' no existe, intente nuevamente\n\n" "$ruta_guardada" >&2
        fi
    done
}

archivosCantidad(){ 
    local ruta="$1"
    archivos_carpeta=$(find "$ruta" -maxdepth 1 -type f | wc -l)
    archivos_subcarpetas=$(find "$ruta" -mindepth 2 -type f | wc -l)
    archivo_mayor=$(find "$ruta" -type f -exec du -h {} + 2>/dev/null | sort -rh | head -1 | cut -f2)
    archivo_menor=$(find "$ruta" -type f -exec du -h {} + 2>/dev/null | sort -h | head -1 | cut -f2)
    echo "Archivos en carpeta $ruta: $archivos_carpeta"
    echo "Archivos en subcarpetas: $archivos_subcarpetas"
    if [ -n "$archivo_mayor" ]; then
        echo "Archivo más grande: $archivo_mayor"
        echo "Archivo más chico: $archivo_menor"
    else
        echo "No se econtraron archivos dentro de esta ruta"
    fi
}

guardarURL(){
    local ruta="$1"
    read -r -p "Ingrese la URL a guardar: " webpage
    if wget -q -O "$ruta/paginaweb.txt" "$webpage"; then
        echo "Contenido de $webpage guardado en $ruta/paginaweb.txt"
    else
        echo "Error al descargar la URL $webpage"
    fi
}

renombrarArchivos(){
    local ruta="$1"
    echo "Renombrando archivos en $ruta..."
    find "$ruta" -type f -exec mv -- '{}' '{}bck' \;
}

buscarPalabra(){
    local ruta="$1"
    local palabra="$2"
    echo "Buscando '$palabra' en los archivos de $ruta..."
    resultado=$(grep -rnw "$ruta" -e "$palabra" 2>/dev/null)
    if [ -z "$resultado" ]; then
        echo "No se encontraron coincidencias"
    else
        echo "Coincidencias encontradas:"
        echo "$resultado"
    fi
}

while true; do
    clear
    echo "---------- Menu -----------"
    echo "1) Propiedades de la carpeta"
    echo "2) Renombrar archivos"
    echo "3) Resumen del estado del disco duro"
    echo "4) Buscar palabras en carpeta"
    echo "5) Reporte del sistema"
    echo "6) Guardar URL"
    echo "7) Ingresar ruta"
    echo "8) Salir del menu"
    read -r -p "Ingrese una opcion: " opcion
    case $opcion in
        1)
            echo "Opcion 1." 
            ruta=$(obtenerRuta "Ingrese la ruta de la carpeta: ")
            archivosCantidad "$ruta"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        2)
            echo "Opcion 2."
            ruta=$(obtenerRuta "Ingrese la ruta de la carpeta: ")
            renombrarArchivos "$ruta"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        3)
            echo "Opcion 3."
            df -h
            echo "Leyendo archivo de mayor tamaño por favor aguarde al resultado: "
            echo "Nota: Algunas carpetas no son accesibles debido a permisos insuficientes."
            find / -type f -exec du -h {} + 2>/dev/null | sort -rh | head -1
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'

        ;;
        4)
            echo "Opcion 4."
            ruta=$(obtenerRuta "Defina la ruta: ")  
            read -r -p "Ingrese la palabra que desea buscar: " palabra             
            buscarPalabra "$ruta" "$palabra"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        5)
            echo "Opcion 5." 
            echo "Usuario actual: $(whoami)"
            echo "El sistema se encendió el: $(uptime -s)"
            echo "Fecha y hora actual: $(date)"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        6)
            echo "Opcion 6."
            ruta=$(obtenerRuta "Ingrese la ruta de la carpeta: ")
            guardarURL "$ruta"    
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        7)
            echo "Opcion 7."  
            echo "----------"
            definirRuta
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        8)
            echo "Saliendo..."
            break
        ;;
        *)
            echo "Debe ingresar un codigo correcto"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        esac
    echo "   "
done
