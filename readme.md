# Análisis de Carpeta y Utilidades del Sistema (Bash Script)

Este proyecto es un script en Bash desarrollado por Garcia J., Demarco R. y Suarez R., que ofrece un menú interactivo para realizar tareas comunes de administración y análisis de archivos en un sistema Linux.

## Funcionalidades

- 📁 **Propiedades de una carpeta:** Muestra cantidad de archivos, archivo más grande y más pequeño.
- ✏️ **Renombrar archivos:** Agrega sufijo `bck` a todos los archivos de una carpeta.
- 💾 **Estado del disco:** Muestra uso del disco y el archivo más pesado del sistema.
- 🔍 **Buscar palabras:** Busca coincidencias de texto dentro de archivos de una ruta.
- 🖥️ **Reporte del sistema:** Usuario actual, uptime y fecha/hora.
- 🌐 **Guardar contenido web:** Descarga el contenido de una URL y lo guarda como `paginaweb.txt`.
- 📌 **Gestión de ruta:** Permite definir y reutilizar rutas para las operaciones.

## Requisitos

- Linux con Bash.
- Comandos básicos disponibles: `find`, `grep`, `du`, `wget`, `df`.

## Uso

1. Clona este repositorio.
2. Da permisos de ejecución:  
   ```bash
   chmod +x script.sh

## Ejecucion
./script.sh

### Notas
<p>Este script fue desarrollado con fines educativos y puede requerir permisos especiales para algunas operaciones (como buscar archivos en todo el sistema).</p>
<p>Tener en cuenta utilizar el comando <b>sed -i 's/\r$//' toolkit.sh </b></p>
<i>Es comun que github en los brancheos inserte retornos de carro /r </i>
<p>Ejecutar asi: bash toolkit.sh - Sin permisos se ejecuta igual</p>
