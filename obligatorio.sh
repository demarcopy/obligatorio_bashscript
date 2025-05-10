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
    read opcion

        case $opcion in
        1)
            echo "Opcion 1." #Test

            if[-z $ruta]; then
                echo "Variable vacia"
            else 
                echo "variable con contenido"
            fi
        ;;
        2)
            echo "Opcion 2." #Test
            if[-z $ruta]; then
                echo "Variable vacia"
            else 
                echo "variable con contenido"
            fi            
        ;;
        3)
            echo "Opcion 3." #Test
        ;;
        4)
            echo "Opcion 4." #Test
            if[-z $ruta]; then
                echo "Variable vacia"
            else 
                echo "variable con contenido"
            fi            
        ;;
        5)
            echo "Opcion 5." #Test
        ;;
        6)
            echo "Opcion 6." #Test
            if[-z $ruta]; then
                echo "Variable vacia"
            else 
                echo "variable con contenido"
            fi            
        ;;
        7)
            echo "Ingrese la ruta deseada:" #Test
            read=ruta
        ;;
        8)
            echo "Saliendo..."
        ;;
        *)
            echo "Debe ingresar un codigo correcto"
        ;;
        esac

    echo "   "
done