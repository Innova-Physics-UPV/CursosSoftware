class Examen:
    def __init__(self,nombre,test,problemas):
        self.nombre=nombre
        self.test=test
        self.problemas=problemas
        self.nota=1/2*test+1/2*problemas
    
    def mostrar_nota(self):
        print(f"Nombre:{self.nombre}" )
        print(f"Nota: {self.nota}")

class Examen_práctico(Examen):
    def __init__(self,nombre,test,problemas,práctica):
        super().__init__(nombre,test,problemas)
        self.práctica=práctica
        self.nota_con_práctica=4/5*self.nota+1/5*práctica

    def mostrar_nota(self):
        print(f"Nombre:{self.nombre}" )
        print(f"Nota: {self.nota_con_práctica}")

examen_l=Examen("Luiscarlos",9,8.5)
examen_s=Examen_práctico("Sebastián",5,7,5.5)
examen_l.mostrar_nota()
examen_s.mostrar_nota()