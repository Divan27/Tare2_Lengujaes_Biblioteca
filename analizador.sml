(*Tipo de dato utilizado para representar un libro en el archivo*)

type libro = { codigo : string, autor : string, genero : string, fecha : string, copias : int };


(*Obtener los datos de un libro*)
fun codigoLibro ({codigo, autor, genero, fecha, copias}:libro) = codigo;
fun autorLibro ({codigo, autor, genero, fecha, copias}:libro) = autor;
fun generoLibro ({codigo, autor, genero, fecha, copias}:libro) = genero;
fun fechaLibro ({codigo, autor, genero, fecha, copias}:libro) = fecha;
fun copiasLibro ({codigo, autor, genero, fecha, copias}:libro) = copias;

(* Elimina \n o \r del final del texto *)
fun quitarSalto texto =
    let val largo = String.size texto
    in
        if largo = 0 then ""
        else
            let val ultimo = String.sub(texto, largo - 1)
            in
                if ultimo = #"\n" orelse ultimo = #"\r" then
                    quitarSalto(String.substring(texto, 0, largo - 1))
                else texto
            end
    end;

(*Lee una linea del teclado*)
fun leerLinea () =
    case TextIO.inputLine TextIO.stdIn of
        SOME texto => quitarSalto texto
      | NONE => "";

(*Convierte texto a minusculas*)
fun minusculas texto = String.map Char.toLower texto;

(*Solicita un numero entero para la opción*)
fun pedirEntero mensaje =
    let
        val _ = print(mensaje)
        val texto = leerLinea()
    in
        case Int.fromString texto of
            SOME numero => numero
          | NONE =>
                let val _ = print("Debe ingresar un numero entero.\n")
                in pedirEntero mensaje
                end
    end;

(*Solicita un entero mayor o igual a cero*)
fun pedirEnteroPositivo mensaje =
    let val numero = pedirEntero mensaje
    in
        if numero >= 0 then numero
        else
            let val _ = print("El numero no puede ser negativo.\n")
            in pedirEnteroPositivo mensaje
            end
    end;

(*LECTURA DEL CSV*)

(* Convierte una linea CSV en un libro *)
fun convertirLinea linea =
    let val campos = String.tokens (fn caracter => caracter = #",") linea
    in
        case campos of
            [codigo, autor, genero, fecha, copiasTexto] =>
                (case Int.fromString copiasTexto of
                    SOME copias =>
                        SOME({
                            codigo = codigo,
                            autor = autor,
                            genero = genero,
                            fecha = fecha,
                            copias = copias
                        }:libro)
                  | NONE => NONE)
          | _ => NONE
    end;

(*Lee todas las lineas del archivo*)
fun leerArchivo archivo =
    case TextIO.inputLine archivo of
        NONE => []
      | SOME linea => quitarSalto linea :: leerArchivo archivo;

(*Convierte las lineas del archivo en una lista de libros*)
fun convertirLineas [] = []
  | convertirLineas (linea::resto) =
        case convertirLinea linea of
            SOME libro => libro :: convertirLineas resto
          | NONE => convertirLineas resto;

(*Carga el archivo indicado por el usuario*)
fun cargarLibros ruta =
    let
        val archivo = TextIO.openIn ruta
        val lineas = leerArchivo archivo
        val _ = TextIO.closeIn archivo
        (* Se elimina la primera linea porque es el encabezado *)
        val datos =
            case lineas of
                [] => []
              | encabezado::resto => resto
    in
        SOME(convertirLineas datos)
    end
    handle _ => NONE;

(*                  MOSTRAR INFORMACION                      *)

(*Muestra un libro*)
fun mostrarLibro libro =
    let
        val _ = print(
            "Codigo: " ^ codigoLibro libro ^
            " | Copias: " ^ Int.toString(copiasLibro libro) ^
            " | Fecha: " ^ fechaLibro libro ^
            " | Autor: " ^ autorLibro libro ^
            " | Genero: " ^ generoLibro libro ^ "\n")
    in
        ()
    end;

(* Muestra una lista de libros *)
fun mostrarLibros [] = ()
  | mostrarLibros (libro::resto) =
        let val _ = mostrarLibro libro
        in mostrarLibros resto
        end;

(* OPCION A - LIBROS DENTRO DE UN RANGO DE COPIAS           *)

(* Obtiene libros dentro del rango indicado *)
fun librosEnRango ([], minimo, maximo) = []
  | librosEnRango (libro::resto, minimo, maximo) =
        let val copias = copiasLibro libro
        in
            if copias >= minimo andalso copias <= maximo then
                libro :: librosEnRango(resto, minimo, maximo)
            else
                librosEnRango(resto, minimo, maximo)
        end;

(* Inserta un libro en orden descendente *)
fun insertarOrdenado (libro:libro, []) = [libro]
  | insertarOrdenado (libro, actual::resto) =
        if copiasLibro libro >= copiasLibro actual then
            libro :: actual :: resto
        else
            actual :: insertarOrdenado(libro, resto);

(* Ordena los libros por cantidad de copias *)
fun ordenarCopias [] = []
  | ordenarCopias (libro::resto) =
        insertarOrdenado(libro, ordenarCopias resto);

(* Muestra el ranking con numero de posicion *)
fun mostrarRanking ([], posicion) = ()
  | mostrarRanking (libro::resto, posicion) =
        let
            val _ = print(Int.toString(posicion) ^ ". ")
            val _ = mostrarLibro libro
        in
            mostrarRanking(resto, posicion + 1)
        end;

(* Ejecuta la opcion A *)
fun opcionA libros =
    let
        val _ = print("\n===== LIBROS POR RANGO DE COPIAS =====\n")
        val minimo = pedirEnteroPositivo("Cantidad minima de copias: ")
        val maximo = pedirEnteroPositivo("Cantidad maxima de copias: ")
    in
        if minimo > maximo then
            print("\nEl minimo no puede ser mayor al maximo.\n")
        else
            let
                val filtrados = librosEnRango(libros, minimo, maximo)
                val ordenados = ordenarCopias filtrados
            in
                if null ordenados then
                    print("\nNo existen libros dentro de ese rango.\n")
                else
                    let val _ = print("\nRanking de libros:\n\n")
                    in mostrarRanking(ordenados, 1)
                    end
            end
    end;

(* OPCION B - AUTORES CON AL MENOS 5 LIBROS                 *)

(* Verifica si un texto ya existe en una lista *)
fun contieneTexto (valor, []) = false
  | contieneTexto (valor, texto::resto) =
        if minusculas valor = minusculas texto then true
        else contieneTexto(valor, resto);

(* Crea una lista de autores sin repetir *)
fun autoresUnicos [] = []
  | autoresUnicos (libro::resto) =
        let
            val autor = autorLibro libro
            val otrosAutores = autoresUnicos resto
        in
            if contieneTexto(autor, otrosAutores) then otrosAutores
            else autor :: otrosAutores
        end;

(* Cuenta cuantos libros tiene un autor *)
fun contarAutor ([], autorBuscado) = 0
  | contarAutor (libro::resto, autorBuscado) =
        if minusculas(autorLibro libro) = minusculas autorBuscado then
            1 + contarAutor(resto, autorBuscado)
        else
            contarAutor(resto, autorBuscado);

(* Crea una lista de autores con al menos cinco libros *)
fun autoresCinco ([], libros) = []
  | autoresCinco (autor::resto, libros) =
        let val cantidad = contarAutor(libros, autor)
        in
            if cantidad >= 5 then
                (autor, cantidad) :: autoresCinco(resto, libros)
            else
                autoresCinco(resto, libros)
        end;

(* Muestra pares texto-cantidad *)
fun mostrarConteos ([]:(string * int) list) = ()
  | mostrarConteos ((nombre, cantidad)::resto) =
        let val _ = print(nombre ^ ": " ^ Int.toString(cantidad) ^ "\n")
        in mostrarConteos resto
        end;

(* Ejecuta la opcion B *)
fun opcionB libros =
    let
        val autores = autoresUnicos libros
        val resultados = autoresCinco(autores, libros)
        val _ = print("\n===== AUTORES CON AL MENOS 5 LIBROS =====\n")
    in
        if null resultados then
            print("No existen autores con al menos 5 libros.\n")
        else
            mostrarConteos resultados
    end;

(* OPCION C - BUSCAR POR CODIGO O AUTOR*)

(* Busca libros por codigo o autor *)
fun buscarLibros ([], criterio) = []
  | buscarLibros (libro::resto, criterio) =
        if minusculas(codigoLibro libro) = minusculas criterio
           orelse minusculas(autorLibro libro) = minusculas criterio then
            libro :: buscarLibros(resto, criterio)
        else
            buscarLibros(resto, criterio);

(* Ejecuta la opcion C *)
fun opcionC libros =
    let
        val _ = print("\n===== BUSCAR LIBRO =====\n")
        val _ = print("Ingrese el codigo del libro o nombre del autor: ")
        val criterio = leerLinea()
        val resultados = buscarLibros(libros, criterio)
    in
        if null resultados then
            print("\nNo se encontraron libros.\n")
        else
            let val _ = print("\nResultados encontrados:\n\n")
            in mostrarLibros resultados
            end
    end;

(* OPCION D - CANTIDAD DE LIBROS POR GENERO*)

(* Cuenta libros de un genero *)
fun contarGenero ([], generoBuscado) = 0
  | contarGenero (libro::resto, generoBuscado) =
        if minusculas(generoLibro libro) = minusculas generoBuscado then
            1 + contarGenero(resto, generoBuscado)
        else
            contarGenero(resto, generoBuscado);

(* Ejecuta la opcion D *)
fun opcionD libros =
    let
        val _ = print("\n===== CANTIDAD DE LIBROS POR GENERO =====\n")
        val _ = print("Ingrese el genero: ")
        val genero = leerLinea()
        val cantidad = contarGenero(libros, genero)
    in
        print(
            "\nCantidad de libros registrados en " ^
            genero ^ ": " ^
            Int.toString(cantidad) ^ "\n")
    end;

(* FUNCIONES PARA EL RESUMEN GENERAL*)

(* Obtiene generos sin repetir *)
fun generosUnicos [] = []
  | generosUnicos (libro::resto) =
        let
            val genero = generoLibro libro
            val otrosGeneros = generosUnicos resto
        in
            if contieneTexto(genero, otrosGeneros) then otrosGeneros
            else genero :: otrosGeneros
        end;

(* Crea cantidad de libros por genero *)
fun conteoGeneros ([], libros) = []
  | conteoGeneros (genero::resto, libros) =
        (genero, contarGenero(libros, genero)) ::
        conteoGeneros(resto, libros);

(* Crea cantidad de libros por autor *)
fun conteoAutores ([], libros) = []
  | conteoAutores (autor::resto, libros) =
        (autor, contarAutor(libros, autor)) ::
        conteoAutores(resto, libros);

(* Busca el libro con mayor cantidad de copias *)
fun libroMayorAux (actual:libro, []) = actual
  | libroMayorAux (actual, libro::resto) =
        if copiasLibro libro > copiasLibro actual then
            libroMayorAux(libro, resto)
        else
            libroMayorAux(actual, resto);

fun libroConMasCopias [] = NONE
  | libroConMasCopias (libro::resto) =
        SOME(libroMayorAux(libro, resto));

(* Busca el elemento con mayor cantidad *)
fun mayorConteoAux (actual:string * int, []) = actual
  | mayorConteoAux (actual, elemento::resto) =
        if #2 elemento > #2 actual then
            mayorConteoAux(elemento, resto)
        else
            mayorConteoAux(actual, resto);

fun mayorConteo ([]:(string * int) list) = NONE
  | mayorConteo (elemento::resto) =
        SOME(mayorConteoAux(elemento, resto));

(* Obtiene mes y anio de una fecha YYYY-MM-DD *)
fun mesAnio fecha =
    if String.size fecha = 10 then
        String.substring(fecha, 5, 2) ^ "-" ^
        String.substring(fecha, 0, 4)
    else
        "Fecha invalida";

(* Obtiene meses-anio sin repetir *)
fun mesesUnicos [] = []
  | mesesUnicos (libro::resto) =
        let
            val valor = mesAnio(fechaLibro libro)
            val otros = mesesUnicos resto
        in
            if contieneTexto(valor, otros) then otros
            else valor :: otros
        end;

(* Cuenta publicaciones realizadas en un mes-anio *)
fun contarMes ([], valorBuscado) = 0
  | contarMes (libro::resto, valorBuscado) =
        if mesAnio(fechaLibro libro) = valorBuscado then
            1 + contarMes(resto, valorBuscado)
        else
            contarMes(resto, valorBuscado);

(* Crea cantidad de publicaciones por mes-anio *)
fun conteoMeses ([], libros) = []
  | conteoMeses (valor::resto, libros) =
        (valor, contarMes(libros, valor)) ::
        conteoMeses(resto, libros);

(* OPCION E - RESUMEN GENERAL*)

fun opcionE libros =
    if null libros then
        print("\nNo existen libros registrados.\n")
    else
        let
            (* Generos *)
            val generos = generosUnicos libros
            val cantidadesGeneros = conteoGeneros(generos, libros)

            (* Autores *)
            val autores = autoresUnicos libros
            val cantidadesAutores = conteoAutores(autores, libros)

            (* Meses *)
            val meses = mesesUnicos libros
            val cantidadesMeses = conteoMeses(meses, libros)

            val _ = print("       RESUMEN DE LA BIBLIOTECA\n")
            val _ = print("-----------------------------------------\n")

            (* 1. Cantidad por genero *)
            val _ = print("\n1. Cantidad de libros por genero:\n")
            val _ = mostrarConteos cantidadesGeneros

            (* 2. Libro con mas copias *)
            val _ = print("\n2. Libro con mas copias disponibles:\n")
            val _ =
                case libroConMasCopias libros of
                    SOME libro => mostrarLibro libro
                  | NONE => print("No hay libros.\n")

            (* 3. Autor con mas libros *)
            val _ = print("\n3. Autor con mas libros:\n")
            val _ =
                case mayorConteo cantidadesAutores of
                    SOME dato =>
                        print(
                            #1 dato ^ " - " ^
                            Int.toString(#2 dato) ^
                            " libros\n")
                  | NONE => print("No hay autores.\n")

            (* 4. Genero con mas libros *)
            val _ = print("\n4. Genero con mas libros:\n")
            val _ =
                case mayorConteo cantidadesGeneros of
                    SOME dato =>
                        print(
                            #1 dato ^ " - " ^
                            Int.toString(#2 dato) ^
                            " libros\n")
                  | NONE => print("No hay generos.\n")

            (* 5. Mes-anio con mas publicaciones *)
            val _ = print("\n5. Mes-anio con mas publicaciones:\n")
            val _ =
                case mayorConteo cantidadesMeses of
                    SOME dato =>
                        print(
                            #1 dato ^ " - " ^
                            Int.toString(#2 dato) ^
                            " publicaciones\n")
                  | NONE => print("No hay publicaciones.\n")
        in
            ()
        end;

(*MENU*)

fun mostrarMenu () =
    let
        val _ = print("       ANALIZADOR DE LIBROS\n")
        val _ = print("-------------------------------------\n")
        val _ = print("1. Libros por rango de copias\n")
        val _ = print("2. Autores con al menos 5 libros\n")
        val _ = print("3. Buscar libro por codigo o autor\n")
        val _ = print("4. Cantidad de libros por genero\n")
        val _ = print("5. Resumen general\n")
        val _ = print("6. Salir\n")
        val _ = print("Seleccione una opcion: ")
    in
        ()
    end;

(* Controla el menu principal *)
fun menu libros =
    let
        val _ = mostrarMenu()
        val opcion = leerLinea()
    in
        case opcion of
            "1" =>
                let val _ = opcionA libros
                in menu libros
                end
          | "2" =>
                let val _ = opcionB libros
                in menu libros
                end
          | "3" =>
                let val _ = opcionC libros
                in menu libros
                end
          | "4" =>
                let val _ = opcionD libros
                in menu libros
                end
          | "5" =>
                let val _ = opcionE libros
                in menu libros
                end
          | "6" =>
                print("\nPrograma finalizado.\n")
          | _ =>
                let val _ = print("\nOpcion invalida.\n")
                in menu libros
                end
    end;

fun main () =
    let
        val _ = print("       ANALIZADOR DE LIBROS\n")
        val _ = print("---------------------------------------\n")
        val _ = print("Ingrese la ruta del archivo CSV: ")
        val ruta = leerLinea()
    in
        case cargarLibros ruta of
            SOME libros =>
                let
                    val _ = print("\nArchivo cargado correctamente.\n")
                    val _ = print(
                        "Libros encontrados: " ^
                        Int.toString(length libros) ^
                        "\n")
                in
                    menu libros
                end
          | NONE =>
                let
                    val _ = print("\nNo fue posible abrir el archivo.\n")
                    val _ = print("Verifique la ruta e intente nuevamente.\n")
                in
                    main()
                end
    end;