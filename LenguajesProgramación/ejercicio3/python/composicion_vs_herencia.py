# Código con algunos errores deliberados (por ejemplo, métodos mal indentados, clases mal nombradas, etc.)
from typing import Protocol

class MovementStrategy(Protocol):
    def move(self) -> str: ...

class WalkStrategy:
    def move(self) -> str:
        return "Caminando paso a paso"

class FlyStrategy:
    def move(self) -> str:
        return "Volando por los aires"

class SwimStrategy:
    def move(self) -> str:
        return "Nadando en el agua"

class JumpStrategy:
    def move(self) -> str:
        return "Saltando alegremente"

class Animal:
    def __init__(self, name: str, movement_strategy: MovementStrategy):
        self.name = name
        self.movement_strategy = movement_strategy
        self.energy = 100

    def move(self) -> str:
        if self.energy > 0:
            self.energy -= 10
            return f"{self.name}: {self.movement_strategy.move()}"
        return f"{self.name} está muy cansado para moverse"

    def rest(self):
        self.energy += 20
        return f"{self.name} descansa"

class AnimalHerencia(Animal):

    pass

class Dog(AnimalHerencia):
    def __init__(self, name, movement_strategy=None):
        # estrategia por defecto: caminar
        if movement_strategy is None:
            movement_strategy = WalkStrategy()
        super().__init__(name, movement_strategy)

class Fish(AnimalHerencia):
    def __init__(self, name, movement_strategy=None):
        # estrategia por defecto: nadar
        if movement_strategy is None:
            movement_strategy = SwimStrategy()
        super().__init__(name, movement_strategy)

class Bird(AnimalHerencia):
    def __init__(self, name, movement_strategy=None):
        # estrategia por defecto: volar
        if movement_strategy is None:
            movement_strategy = FlyStrategy()
        super().__init__(name, movement_strategy)


class FlexibleDuck:
    """Un pato flexible sencillo que puede cambiar su estrategia de movimiento."""
    def __init__(self, name, movement_strategy=None):
        if movement_strategy is None:
            movement_strategy = WalkStrategy()
        self.name = name
        self.movement_strategy = movement_strategy
        self.energy = 100

    def set_movement_strategy(self, strategy):
        self.movement_strategy = strategy

    def move(self) -> str:
        if self.energy > 0:
            # el pato gasta menos energía por movimiento
            self.energy -= 5
            return f"{self.name}: {self.movement_strategy.move()}"
        return f"{self.name} está muy cansado para moverse"


class Kangaroo(AnimalHerencia):
    """Un animal sencillo que salta usando JumpStrategy por defecto."""
    def __init__(self, name, movement_strategy=None):
        if movement_strategy is None:
            movement_strategy = JumpStrategy()
        super().__init__(name, movement_strategy)


def main():
    dog = Dog("Rex")
    print(dog.move())
    # Demostración: pato flexible que cambia estrategia en tiempo de ejecución
    duck = FlexibleDuck("Pato")
    print(duck.move())
    duck.set_movement_strategy(FlyStrategy())
    print(duck.move())
    duck.set_movement_strategy(SwimStrategy())
    print(duck.move())

    # Pruebas simples para composición
    fish = Fish("Nemo")
    print(fish.move())
    bird = Bird("Werty")
    print(bird.move())
    kanguroo = Kangaroo("Kanga")
    print(kanguroo.move())
    

if __name__ == "__main__":
    main()