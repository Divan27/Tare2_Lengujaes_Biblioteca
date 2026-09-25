# Tarea 2 - Biblioteca SML

## a) Portada

**Instituto Tecnológico de Costa Rica**
**Curso:** Lenguajes de Programación
**Tarea 2**
**Tema:** Gestión Bibliotecaria 

**Estudiante:** Dilan Zamora Sánchez
**Lenguaje utilizado:** Standard ML (SML)
**Herramienta:** SML/NJ

---

# b) Manual de usuario

## Requisitos

Para ejecutar el proyecto se necesita tener instalado:

* Standard ML of New Jersey (SML/NJ).
* Una terminal, CMD o PowerShell.
* Los archivos del proyecto en una misma carpeta.

Archivos principales:

```text
Tarea2_Lenguajes/
│
├── creador.sml
├── analizador.sml
└── libros.csv
```

El archivo `libros.csv` utiliza la siguiente estructura:

```text
codigo,autor,genero,fecha_publicacion,copias_disponibles
```

Ejemplo:

```text
LIB7502,George Orwell,Fantasia,2006-04-07,2
LIB9454,Agatha Christie,Ficcion,2018-11-10,15
```

---

## Ejecución del Creador

Abrir una terminal en la carpeta del proyecto y ejecutar:

```bash
sml
```

Luego cargar el archivo:

```sml
use "creador.sml";
```

Ejecutar el programa mediante:

```sml
main();
```

El programa muestra el siguiente menú:

```text
1. Agregar nuevo libro
2. Limpiar catalogo
3. Salir
```

### Agregar libro

El usuario debe ingresar:

* Código del libro.
* Fecha de publicación.
* Autor.
* Género.
* Número de copias disponibles.

El registro se guarda al final del archivo `libros.csv`.

### Limpiar catálogo

La opción permite eliminar todos los registros existentes y mantener únicamente el encabezado del archivo.

---

## Ejecución del Analizador

Desde SML/NJ cargar el programa con:

```sml
use "analizador.sml";
```

Luego ejecutar:

```sml
main();
```

El programa solicita la ruta del archivo CSV:

```text
Ingrese la ruta del archivo CSV:
```

Si el archivo se encuentra en la misma carpeta se puede ingresar:

```text
libros.csv
```

Luego se presenta el menú:

```text
1. Libros por rango de copias
2. Autores con al menos 5 libros
3. Buscar libro por codigo o autor
4. Cantidad de libros por genero
5. Resumen general
6. Salir
```

---

# c) Pruebas de funcionalidad

Para comprobar el correcto funcionamiento del sistema se realizaron pruebas sobre las diferentes opciones.

## Prueba 1 - Agregar libro

Se ingresó un nuevo libro desde el programa Creador y se verificó que la información fuera almacenada correctamente en `libros.csv`.

---

## Prueba 2 - Limpiar catálogo

Se utilizó la opción de limpiar catálogo y se verificó que todos los registros fueran eliminados, manteniendo únicamente el encabezado.

---

## Prueba 3 - Ranking por cantidad de copias

Se ingresó un rango mínimo y máximo de copias y el programa mostró los libros que cumplen la condición, ordenados de mayor a menor.

---

## Prueba 4 - Autores con al menos 5 libros

Se verificó que el programa identificara correctamente los autores que poseen cinco o más libros registrados.

---

## Prueba 5 - Búsqueda por código o autor

Se realizó una búsqueda utilizando el código de un libro y posteriormente el nombre de un autor.

---

## Prueba 6 - Cantidad por género

Se ingresó un género y el programa mostró la cantidad de libros registrados dentro de dicha categoría.

---

## Prueba 7 - Resumen general

Se ejecutó el resumen general para verificar:

* Cantidad de libros por género.
* Libro con más copias disponibles.
* Autor con más libros.
* Género con más libros.
* Mes-año con más publicaciones.

---

# d) Descripción del problema

El objetivo de la tarea consiste en desarrollar un sistema utilizando el paradigma de programación funcional mediante Standard ML.

El sistema administra información relacionada con libros almacenados en un archivo plano en formato CSV.

Para cumplir con los requerimientos se desarrollaron dos programas independientes.

El programa `creador.sml` permite agregar nuevos registros al catálogo y limpiar completamente los registros existentes.

El programa `analizador.sml` permite leer el archivo generado y realizar diferentes consultas y análisis sobre la información almacenada.

Ambos programas trabajan sobre la misma estructura de archivo CSV, permitiendo mantener una separación entre el registro de datos y su posterior análisis.

---

# e) Diseño del programa

El proyecto fue dividido principalmente en dos componentes:

## Creador

El Creador se encarga de la escritura y administración básica del archivo.

Sus principales funciones son:

* Leer información ingresada por el usuario.
* Validar datos básicos.
* Crear el registro separado por comas.
* Agregar el registro al final del archivo.
* Limpiar el archivo cuando sea solicitado.

Se utiliza recursión para volver a solicitar información cuando el usuario ingresa un dato inválido.

---

## Analizador

El Analizador se encarga de leer los registros almacenados en el archivo CSV y convertirlos en estructuras de tipo `libro`.

Cada libro contiene:

```sml
type libro = {
    codigo : string,
    autor : string,
    genero : string,
    fecha : string,
    copias : int
};
```

El programa utiliza listas para almacenar y procesar los libros.

Las consultas se realizan principalmente mediante funciones recursivas.

### Algoritmos utilizados

**Filtrado por rango**

Se recorre la lista de libros y se seleccionan únicamente aquellos cuya cantidad de copias se encuentre entre el mínimo y máximo ingresado.

**Ordenamiento**

Para mostrar el ranking de libros se utiliza un algoritmo de inserción que ordena los libros de manera descendente según la cantidad de copias.

**Búsqueda**

Se recorre la lista comparando el criterio ingresado con el código y el autor de cada libro.

**Conteo**

Se utilizan funciones recursivas para calcular:

* Cantidad de libros por autor.
* Cantidad de libros por género.
* Cantidad de publicaciones por mes y año.

**Obtención de valores máximos**

El programa recorre los resultados acumulados para determinar:

* Libro con más copias.
* Autor con más libros.
* Género con más libros.
* Mes-año con más publicaciones.

---

# f) Librerías usadas

El proyecto utiliza principalmente las bibliotecas estándar incluidas en SML/NJ.

## TextIO

Se utiliza para trabajar con archivos y entrada de datos.

Funciones utilizadas:

```sml
TextIO.inputLine
TextIO.openIn
TextIO.openOut
TextIO.openAppend
TextIO.output
TextIO.closeIn
TextIO.closeOut
TextIO.stdIn
```

Estas funciones permiten leer información desde teclado y trabajar con los archivos CSV.

---

## String

Se utiliza para manipular cadenas de texto.

Funciones utilizadas:

```sml
String.size
String.substring
String.sub
String.tokens
String.map
```

---

## Int

Se utiliza para trabajar con valores enteros.

Funciones principales:

```sml
Int.fromString
Int.toString
```

Estas permiten convertir datos ingresados como texto a números y viceversa.

---

## Char

Se utiliza principalmente para convertir caracteres a minúscula:

```sml
Char.toLower
```

Esto facilita las búsquedas sin importar si el usuario escribe en mayúscula o minúscula.

---

## List

Se utiliza para manejar colecciones de información dentro del programa.

Las listas representan el conjunto de libros cargados desde el archivo CSV.

---

# g) Análisis de resultados

El desarrollo permitió cumplir con los objetivos principales definidos para la tarea.

## Objetivos alcanzados

Se logró implementar correctamente:

* Registro de nuevos libros.
* Escritura de registros en formato CSV.
* Limpieza del catálogo.
* Lectura del archivo CSV.
* Conversión de registros a estructuras internas.
* Filtrado por cantidad de copias.
* Ordenamiento descendente.
* Identificación de autores con cinco o más libros.
* Búsqueda por código o autor.
* Conteo de libros por género.
* Generación de un resumen general.
* Identificación de valores máximos dentro de los registros.
* Ejecución de ambos programas mediante la función `main()`.

El proyecto permitió aplicar conceptos básicos y fundamentales del lenguaje Standard ML, entre ellos:

* Funciones.
* Recursión.
* Listas.
* Registros.
* Pattern Matching.
* `case`.
* `let`, `in` y `end`.
* Manejo de archivos.
* Conversión de tipos.
* Manipulación de strings.

## Objetivos no alcanzados

No se identifican objetivos principales sin implementar dentro de los requerimientos desarrollados.

Sin embargo, el sistema puede ser mejorado posteriormente agregando validaciones más estrictas sobre los datos ingresados, como fechas completamente válidas o control de códigos duplicados.

Estas mejoras no afectan el funcionamiento principal solicitado para la tarea y pueden considerarse extensiones futuras del sistema.

---

# Conclusión

El proyecto permitió desarrollar una solución utilizando programación funcional con Standard ML para almacenar y analizar información de libros.

La separación entre el Creador y el Analizador facilita la organización del sistema, ya que un programa se encarga de administrar los registros y el otro de procesarlos.

Además, el uso de funciones recursivas, listas y pattern matching permitió resolver los requerimientos sin depender de estructuras propias de lenguajes orientados a objetos, aplicando los conceptos estudiados durante el curso.
