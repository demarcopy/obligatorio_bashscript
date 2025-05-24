#!/bin/bash
#Creado por: Garcia .J, De Marco .R, Suarez .R
definirRuta(){
echo "Ingrese la ruta deseada:"
read -r ruta
echo "Ruta definida: $ruta"
if [ -d $ruta ]; then
    echo "La ruta es correcta"
else
    echo "La ruta no existe"
    definirRuta
fi
}
        echo "Los archivos dentro de $ruta son:"
        find $ruta -maxdepth 1 -type f | wc -l
        echo "Los archivos dentro de subcarpetas son:"
        find $ruta -mindepth 2 -type f | wc -l

}

guardarURL(){
    #Pide una URL, guarda en un txt dicho contenido (pide la ruta al usuario, el nombre del archivo debe ser
    echo "Ingrese la URL a guardar: "
    read -r webpage
    echo "$webpage" > $ruta/paginaweb.txt
}

renombrarArchivos(){
    #Renombra los archivos dentro de la carpeta y subcarpetas
    echo "Renombrando archivos..."
    find $ruta -type f -exec mv {} {}bck \;
}


while true; do
    echo "---------- Menu -----------"
    echo "1) Propiedades de la carpeta"
    echo "2) Renombrar archivos"
    echo "3) Resumen del estado del disco duro"
    echo "4) Buscar palabras en carpeta"
    echo "5) Reporte del sistema"
    echo "6) Guardar URL"
    echo "7) Ingresar ruta"
    echo "8) Salir del menu"
    echo -n "Ingrese una opcion: "
    read -r opcion
    case $opcion in
        1)
            echo "Opcion 1." 
            if [ -z $ruta ]; then
                echo "Defina la ruta primero"

            else 
                archivosCantidad
            fi
        ;;
        2)
            echo "Opcion 2."
            renombrarArchivos
        ;;
        3)
            #Muestra un resumen del estado del disco duro
            echo "Opcion 3."
            df -h
            echo "Leyendo archivo de mayor tamaño por favor aguarde al resultado: "
            find / -type f -exec du -h {} + 2>/dev/null | sort -rh | head -1

        ;;
        4)
            echo "Opcion 4." 
            
        ;;
        5)
            echo "Opcion 5." 
        ;;
        6)
            echo "Opcion 6."
            if [ -z $ruta ]; then
               echo "Defina la ruta primero"

            else 
                guardarURL
            fi         
        ;;
        7)  
            definirRuta
            
        ;;
        8)
            echo "Saliendo..."
            break
        ;;
        *)
            echo "Debe ingresar un codigo correcto"
        ;;
        esac

    echo "   "
done
