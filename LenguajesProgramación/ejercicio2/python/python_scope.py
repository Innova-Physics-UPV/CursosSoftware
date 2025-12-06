x = "global"

def funcion_externa():
    # TODO: definir x en el scope enclosing
    x = "enclosing"

    def funcion_interna():
        # TODO: definir x en el scope local
        x = "local"
        print(f"Local: {x}")

        def funcion_mas_interna():
            print(f"Acceso a enclosing: {x}")  # ¿De qué x se trata?

        funcion_mas_interna()

    print(f"Enclosing: {x}")
    funcion_interna()

print(f"Global: {x}")
funcion_externa()

# TODO: modificar correctamente la variable global y la no-local
def modificar_global():
    global x
    x = "global modificado"

def modificar_local():
    y = "enclosing"
    def inner():
        nonlocal y
        y = "nonlocal modificado"
    inner()
    print(f'Variable nonlocal modificada: {y}')

modificar_global()
print(f'Global después de modificar: {x}')
modificar_local()

