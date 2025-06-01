#!/bin/bash
#Creado por: Garcia .J, Demarco .R, Suarez .R

main() {

rojo='\033[0;31m'
verde='\033[0;32m'
azul='\033[0;34m'
cian='\033[0;36m'
FIN='\e[0m'
ROJO='\033[1;31m'
VERDE='\033[1;32m'
AZUL='\033[1;34m'
CIAN='\033[1;36m'


ruta_guardada=""

obtenerRuta(){
    local mensaje="$1"
    if [ -n "$ruta_guardada" ]; then
        echo -e "utilizando ruta guardada: ${VERDE}$ruta_guardada${FIN}" >&2
        echo "$ruta_guardada"
        return 0
    else
        while true; do
            read -r -p "$mensaje" ruta
            if [ -d "$ruta" ]; then
                echo "$ruta"
                return 0
            else
                printf "${ROJO}ERROR:${FIN} '%s' no existe, intente nuevamente\n\n" "$ruta" >&2
            fi
        done
    fi
}

definirRuta(){
    while true; do
        read -p "Ingrese la ruta que desea guardar: " ruta_guardada

	 if [ -z "$ruta_guardada" ]; then
	    printf "${ROJO}ERROR:${FIN} La ruta no puede estar vacia\n\n" >&2
            continue
	 fi

	 if [ -d "$ruta_guardada" ]; then
            echo "Ruta definida con exito: $ruta_guardada"
            break
        else
            printf "${ROJO}ERROR:${FIN} '$ruta_guardada' no existe, intente nuevamente\n\n" >&2
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
        echo -e "Archivos en carpeta $ruta: ${VERDE}$archivos_carpeta${FIN}"
        echo -e "Archivos en subcarpetas: ${VERDE}$archivos_subcarpetas${FIN}"
        echo -e "Archivo más grande: ${VERDE}$archivo_mayor${FIN}"
        echo -e "Archivo más chico: ${VERDE}$archivo_menor${FIN}"
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
                echo -e "${VERDE}Éxito:${FIN} Contenido de '$webpage' guardado en '$ruta/paginaweb.txt'"
            else
                echo e- "${ROJO}Error:${FIN} El archivo descargado está vacío." >&2
                rm -f "$ruta/paginaweb.txt"
                return 1
            fi
        else
            echo e- "${ROJO}Error:${FIN} Fallo al descargar '$webpage'." >&2
            return 1
        fi
    else
        echo "Error: La URL '$webpage' no es válida o no está accesible." >&2
        return 1
    fi
}

renombrarArchivos(){
    local ruta="$1"
    local count=$(find "$ruta" -type f ! -name '.*' | wc -l)
    if [ "$count" -gt 0 ]; then
        echo "Renombrando archivos en $ruta..."
        find "$ruta" -type f 2>/dev/null -exec mv -- '{}' '{}bck' \;
        echo -e "Se renombraron correctamente ${verde}$count${FIN} archivos"
    else
        echo -e "No se encontraron archivos en ${verde}$ruta${FIN}. No se pudo renombrar nada".
    fi
}

buscarPalabra(){
    local ruta="$1"
    local palabra="$2"
    echo -e "Buscando ${verde}'$palabra'${FIN} en los archivos de ${verde}$ruta${FIN}..."
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
    echo -e "${CIAN}---------- Menu -----------${FIN}"
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
            echo -e "${cian}Opcion 1.${FIN}"
            echo -e "${cian}---------${FIN}"
            ruta=$(obtenerRuta "Ingrese la ruta de la carpeta: ")
            archivosCantidad "$ruta"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        2)
            echo -e "${cian}Opcion 1.${FIN}"
            echo -e "${cian}---------${FIN}"
            ruta=$(obtenerRuta "Ingrese la ruta de la carpeta: ")
            renombrarArchivos "$ruta"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        3)
            echo -e "${cian}Opcion 1.${FIN}"
            echo -e "${cian}---------${FIN}"
            df -h
            echo "Leyendo archivo de mayor tamaño por favor aguarde al resultado: "
            echo -e "${verde}Nota:${FIN} Algunas carpetas no son accesibles debido a permisos insuficientes."
            find / -type f -exec du -h {} + 2>/dev/null | sort -rh | head -1
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'

        ;;
        4)
            echo -e "${cian}Opcion 1.${FIN}"
            echo -e "${cian}---------${FIN}"
            ruta=$(obtenerRuta "Defina la ruta: ")
	    local count=$(find "$ruta" -type f ! -name '.*' | wc -l)
            if [ "$count" -gt 0 ]; then
                  read -r -p "Ingrese la palabra que desea buscar: " palabra
                  buscarPalabra "$ruta" "$palabra"
	    else
		  echo "No hay archivos en la ruta, no se pueden buscar palabras"
            fi
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        5)
            echo -e "${cian}Opcion 1.${FIN}"
            echo -e "${cian}---------${FIN}"
            echo "Usuario actual: $(whoami)"
            echo "El sistema se encendió el: $(uptime -s)"
            echo "Fecha y hora actual: $(date)"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        6)
            echo -e "${cian}Opcion 1.${FIN}"
            echo -e "${cian}---------${FIN}"
            ruta=$(obtenerRuta "Ingrese la ruta de la carpeta: ")
            guardarURL "$ruta"    
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        7)
            echo -e "${cian}Opcion 1.${FIN}"
            echo -e "${cian}---------${FIN}"
            if [ -n "$ruta_guardada" ]; then
                echo -e "Actual ruta guardada: ${verde}$ruta_guardada${FIN}"
            fi
            definirRuta
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        8)
            echo -e "${ROJO}Saliendo...${FIN}"
            break
        ;;
        *)
            echo "Debe ingresar un codigo correcto"
            read -p $'\033[1;34mPresione Enter para continuar...\033[0m'
        ;;
        esac
    echo "   "
done

}

if [ -n "$BASH_SOURCE" ] && [ "$0" == "$BASH_SOURCE" ]; then
	main "$@"
fi
