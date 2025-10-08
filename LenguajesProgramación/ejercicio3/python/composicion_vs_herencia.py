# Código con algunos errores deliberados (por ejemplo, métodos mal indentados, clases mal nombradas, etc.)
from abc import ABC, abstractmethod
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

class Dog(ABC):
    def __init__(self, name):
        self.name = name
        self.energy = 100

    def move(self) -> str:
        if self.energy > 0:
            self.energy -= 10
            return f"{self.name} corre felizmente"
        return f"{self.name} está muy cansado para correr"

def main():
    dog = Animal("Rex", WalkStrategy())
    print(dog.move())
    # Faltan más pruebas e implementación heredada

if __name__ == "__main__":
    main()