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
        echo "utilizando ruta guardada: '$ruta_guardada'" >&2
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
    archivos_carpeta=$(find "$ruta" -maxdepth 1 -type f 2>/dev/null | wc -l)
    archivos_subcarpetas=$(find "$ruta" -mindepth 2 -type f 2>/dev/null | wc -l)
    archivo_mayor=$(find "$ruta" -type f -exec du -h {} + 2>/dev/null | sort -rh | head -1 | cut -f2)
    archivo_menor=$(find "$ruta" -type f -exec du -h {} + 2>/dev/null | sort -h | head -1 | cut -f2)
    
    if [ -n "$archivo_mayor" ]; then
        echo "Archivos en carpeta $ruta: $archivos_carpeta"
        echo "Archivos en subcarpetas: $archivos_subcarpetas"
        echo "Archivo más grande: $archivo_mayor"
        echo "Archivo más chico: $archivo_menor"
    else
        echo "No se encontraron archivos dentro de esta ruta"
    fi
}

guardarURL(){
    local ruta="$1"
    read -r -p "Ingrese la URL a guardar: " webpage
    if wget --spider -q "$webpage"; then
        if wget -q -O "$ruta/paginaweb.txt" "$webpage"; then
            if [ -s "$ruta/paginaweb.txt" ]; then
                echo "Éxito: Contenido de '$webpage' guardado en '$ruta/paginaweb.txt'"
            else
                echo "Error: El archivo descargado está vacío." >&2
                rm -f "$ruta/paginaweb.txt"
                return 1
            fi
        else
            echo "Error: Fallo al descargar '$webpage'." >&2
            return 1
        fi
    else
        echo "Error: La URL '$webpage' no es válida o no está accesible." >&2
        return 1
    fi
}

renombrarArchivos(){
    local ruta="$1"

    if find "$ruta" -type f -quit 2>/dev/null; then
        echo "Renombrando archivos en $ruta..."
        find "$ruta" -type f 2>/dev/null -exec mv -- '{}' '{}bck' \;
    else
        echo "No se encontraron archivos en $ruta. No se pudo renombrar nada".
    fi
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
            echo "---------" 
            ruta=$(obtenerRuta "Ingrese la ruta de la carpeta: ")
            archivosCantidad "$ruta"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        2)
            echo "Opcion 2."
            echo "---------"
            ruta=$(obtenerRuta "Ingrese la ruta de la carpeta: ")
            renombrarArchivos "$ruta"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        3)
            echo "Opcion 3."
            echo "---------"
            df -h
            echo "Leyendo archivo de mayor tamaño por favor aguarde al resultado: "
            echo "Nota: Algunas carpetas no son accesibles debido a permisos insuficientes."
            find / -type f -exec du -h {} + 2>/dev/null | sort -rh | head -1
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'

        ;;
        4)
            echo "Opcion 4."
            echo "---------"
            ruta=$(obtenerRuta "Defina la ruta: ")  
            read -r -p "Ingrese la palabra que desea buscar: " palabra             
            buscarPalabra "$ruta" "$palabra"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        5)
            echo "Opcion 5."
            echo "---------"
            echo "Usuario actual: $(whoami)"
            echo "El sistema se encendió el: $(uptime -s)"
            echo "Fecha y hora actual: $(date)"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        6)
            echo "Opcion 6."
            echo "---------"
            ruta=$(obtenerRuta "Ingrese la ruta de la carpeta: ")
            guardarURL "$ruta"    
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        7)
            echo "Opcion 7."  
            echo "---------"
            if [ -n "$ruta_guardada" ]; then
                echo "Ruta guarada actual: '$ruta_guarada'"
            fi
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
