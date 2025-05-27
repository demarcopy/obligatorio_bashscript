#!/bin/bash
#Creado por: Garcia .J, Demarco .R, Suarez .R

if [ ! -x "$0" ]; then
    chmod +x "$0"
    exec "$0" "$@"
    exit
fi

ruta_guardada=""



obtenerRuta() {
    local mensaje="$1"
    if [ -n "$ruta_guardada" ]; then
        read -r -p "¿Desea cambiar la ruta? (s/n): " respuesta

        if [[ "$respuesta" =~ ^[sS]$ ]]; then
            unset ruta_guardada
        else
            echo "$ruta_guardada"
            return 0
        fi
    fi
    while true; do
        read -r -p "$mensaje" ruta
        if [ -d "$ruta" ]; then
            ruta_guardada="$ruta"
            echo "$ruta_guardada"
            return 0
        else
            echo "La ruta no es válida o no existe, intente nuevamente."
        fi
    done
}



archivosCantidad(){ 
    archivos_carpeta=$(find "$ruta_guardada" -maxdepth 1 -type f | wc -l)
    archivos_subcarpetas=$(find "$ruta_guardada" -mindepth 2 -type f | wc -l)
    archivo_mayor=$(find "$ruta_guardada" -type f -exec du -h {} + 2>/dev/null | sort -rh | head -1 | cut -f2)
    archivo_menor=$(find "$ruta_guardada" -type f -exec du -h {} + 2>/dev/null | sort -h | head -1 | cut -f2)
    echo "Archivos en carpeta $ruta_guardada: $archivos_carpeta"
    echo "Archivos en subcarpetas: $archivos_subcarpetas"
    echo "Archivo más grande: $archivo_mayor"
    echo "Archivo más chico: $archivo_menor"
    read -p "Presione Enter para continuar..."
}

guardarURL(){
    local ruta="$1"
    read -r -p "Ingrese la URL a guardar: " webpage
    if wget --spider -q "$webpage"; then
        if wget -q -O "$ruta/paginaweb.txt" "$webpage"; then
        echo "Contenido de $webpage guardado en $ruta/paginaweb.txt"
        else
        echo "Error al descargar la URL $webpage"
        fi
    else
        echo "La URL ingresada no es válida o no es accesible."
    fi
}

renombrarArchivos(){
    local ruta="$1"
    echo "Renombrando archivos en $ruta..."
    find "$ruta" -maxdepth 1 -type f -exec mv -- '{}' '{}bck' \;
}

buscarPalabra(){
    local ruta="$ruta_guardada"
    local palabra="$3"
    echo "Buscando '$palabra' en los archivos de $ruta..."
    resultado=$(grep -rnw "$ruta" -e "$palabra" 2>/dev/null)
    if [ -z "$resultado" ]; then
        echo "No se encontraron coincidencias"
    else
        echo "Coincidencias encontradas:"
        echo "$resultado"
    fi
}

verificarRuta() {
    local funcion="$1"
    if [ -n "$ruta_guardada" ]; then
        echo "La ruta actual es: $ruta_guardada"
        $funcion "$ruta_guardada" "$@" "$@"
    else
        echo "No se ha definido una ruta, volviendo al menú principal"
        sleep 3
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
            verificarRuta archivosCantidad
        ;;
        2)
            echo "Opcion 2."
            verificarRuta renombrarArchivos
            read -p "Presione Enter para continuar..."
        ;;
        3)
            echo "Opcion 3."
            df -h
            echo "Leyendo archivo de mayor tamaño por favor aguarde al resultado: "
            echo "Nota: Algunas carpetas no son accesibles debido a permisos insuficientes."
            find / -type f -exec du -h {} + 2>/dev/null | sort -rh | head -1
            read -p "Presione Enter para continuar..."
        ;;
        4)
            echo "Opcion 4."
            read -r -p "Ingrese la palabra a buscar: " palabra
            verificarRuta buscarPalabra "$palabra"
            read -p "Presione Enter para continuar..."
        ;;
        5)
            echo "Opcion 5." 
            echo "Usuario actual: $(whoami)"
            echo "El sistema se encendió el: $(uptime -s)"
            echo "Fecha y hora actual: $(date)"
            read -p "Presione Enter para continuar..."
        ;;
        6)
            echo "Opcion 6."
            verificarRuta guardarURL
            read -p "Presione Enter para continuar..."
        ;;
        7)
            echo "Opcion 7."  
            echo "----------"
            ruta_guardada=$(obtenerRuta "Ingrese la ruta de la carpeta: ")
            read -p "Presione Enter para continuar..."
        ;;
        8)
            echo "Saliendo..."
            break
        ;;
        *)
            echo "Debe ingresar un código correcto"
            read -p "Presione Enter para continuar..."
        ;;
        esac
    echo "   "
done