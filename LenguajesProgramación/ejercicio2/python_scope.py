x = "global"

def funcion_externa():
    # TODO: definir x en el scope enclosing

    def funcion_interna():
        # TODO: definir x en el scope local
        print(f"Local: {x}")

        def funcion_mas_interna():
            print(f"Acceso a enclosing: {x}")  # ¿De qué x se trata?

        funcion_mas_interna()

    print(f"Enclosing: {x}")
    funcion_interna()

print(f"Global: {x}")
funcion_externa()

# TODO: modificar correctamente la variable global y la no-local
