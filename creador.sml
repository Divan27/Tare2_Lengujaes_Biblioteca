val nombreArchivo = "libros.csv";
val encabezado = "codigo,autor,genero,fecha_publicacion,copias_disponibles\n";

(* Elimina el salto de linea del texto ingresado *)
fun quitarSalto texto =
    let val largo = String.size texto
    in
        if largo > 0 then String.substring(texto, 0, largo - 1)
        else ""
    end;

(* Lee una linea escrita por el usuario *)
fun leerLinea () =
    case TextIO.inputLine TextIO.stdIn of
        SOME texto => quitarSalto texto
      | NONE => "";

(* Valida que un texto no este vacio *)
fun textoValido texto = String.size texto > 0;

(* Valida que el codigo inicie con LIB *)
fun codigoValido codigo =
    if String.size codigo >= 4 then
        String.substring(codigo, 0, 3) = "LIB"
    else
        false;

(* Valida el formato YYYY-MM-DD de la fecha *)
fun fechaValida fecha =
    if String.size fecha = 10 then
        String.sub(fecha, 4) = #"-" andalso
        String.sub(fecha, 7) = #"-"
    else
        false;

(* Solicita y valida el codigo del libro *)
fun pedirCodigo () =
    let
        val _ = print("Codigo del libro: ")
        val codigo = leerLinea()
    in
        if codigoValido codigo then
            codigo
        else
            let val _ = print("Codigo invalido. Debe iniciar con LIB.\n")
            in pedirCodigo()
            end
    end;

(* Solicita y valida el autor *)
fun pedirAutor () =
    let
        val _ = print("Autor: ")
        val autor = leerLinea()
    in
        if textoValido autor then
            autor
        else
            let val _ = print("El autor no puede estar vacio.\n")
            in pedirAutor()
            end
    end;

(* Solicita y valida el genero *)
fun pedirGenero () =
    let
        val _ = print("Genero: ")
        val genero = leerLinea()
    in
        if textoValido genero then
            genero
        else
            let val _ = print("El genero no puede estar vacio.\n")
            in pedirGenero()
            end
    end;

(* Solicita y valida la fecha *)
fun pedirFecha () =
    let
        val _ = print("Fecha de publicacion (YYYY-MM-DD): ")
        val fecha = leerLinea()
    in
        if fechaValida fecha then
            fecha
        else
            let val _ = print("Fecha invalida. Use el formato YYYY-MM-DD.\n")
            in pedirFecha()
            end
    end;

(* Solicita y valida el numero de copias *)
fun pedirCopias () =
    let
        val _ = print("Numero de copias disponibles: ")
        val texto = leerLinea()
    in
        case Int.fromString texto of
            SOME numero =>
                if numero >= 0 then
                    numero
                else
                    let val _ = print("Las copias no pueden ser negativas.\n")
                    in pedirCopias()
                    end
          | NONE =>
                let val _ = print("Debe ingresar un numero entero.\n")
                in pedirCopias()
                end
    end;

(* Agrega un nuevo libro al final del archivo *)
fun agregarLibro () =
    let
        val _ = print("\n===== AGREGAR NUEVO LIBRO =====\n")
        val codigo = pedirCodigo()
        val fecha = pedirFecha()
        val autor = pedirAutor()
        val genero = pedirGenero()
        val copias = pedirCopias()

        val registro =
            codigo ^ "," ^
            autor ^ "," ^
            genero ^ "," ^
            fecha ^ "," ^
            Int.toString(copias) ^ "\n"

        val archivo = TextIO.openAppend nombreArchivo
        val _ = TextIO.output(archivo, registro)
        val _ = TextIO.closeOut archivo
        val _ = print("\nLibro agregado correctamente.\n")
    in
        ()
    end;

(* Limpia el catalogo y conserva el encabezado *)
fun limpiarCatalogo () =
    let
        val archivo = TextIO.openOut nombreArchivo
        val _ = TextIO.output(archivo, encabezado)
        val _ = TextIO.closeOut archivo
        val _ = print("\nCatalogo limpiado correctamente.\n")
    in
        ()
    end;

(* Muestra el menu principal *)
fun mostrarMenu () =
    let
        val _ = print("        CREADOR DE CATALOGO\n")
        val _ = print("-------------------------------------\n")
        val _ = print("1. Agregar nuevo libro\n")
        val _ = print("2. Limpiar catalogo\n")
        val _ = print("3. Salir\n")
        val _ = print("Seleccione una opcion: ")
    in
        ()
    end;

(* Controla las opciones del menu *)
fun menu () =
    let
        val _ = mostrarMenu()
        val opcion = leerLinea()
    in
        case opcion of
            "1" =>
                let val _ = agregarLibro()
                in menu()
                end
          | "2" =>
                let val _ = limpiarCatalogo()
                in menu()
                end
          | "3" =>
                print("\nPrograma finalizado.\n")
          | _ =>
                let val _ = print("\nOpcion invalida.\n")
                in menu()
                end
    end;

fun main () = menu();