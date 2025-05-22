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
archivosCantidad(){
    #a) Muestra cuantos archivos hay dentro diferenciando la cantidad que se encuentran dentro de la ruta y la cantidad de los que se encuentran dentro de subcarpetas (dentro de la ruta)
    #b) Mostrar el nombre del archivo de menor tamaño y el de mayor tamaño.    
        echo "Los archivos dentro de $ruta son:"
        find $ruta -type f -maxdepth 1| wc -l
        echo "Los archivos dentro de subcarpetas son:"
        find $ruta -type f -mindepth 1 | wc -l

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
        if [ -z "$ruta" ]; then
            echo "Defina la ruta primero"
        else 
            archivosCantidad
        fi
    ;;
    2)
        echo "Opcion 2." #Test

    ;;
    3)
        echo "Opcion 3." #Test
    ;;
    4)
        echo "Opcion 4." #Test
        
    ;;
    5)
        echo "Opcion 5." #Test
    ;;
    6)
        echo "Opcion 6." #Test
                    
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
