trait Drawable {
    fn draw(&self) -> String;
    fn area(&self) -> f64;
}

trait Resizable {
    fn resize(&mut self, scale: f64);
}

struct Circle {
    radius: f64,
    x: f64,
    y: f64,
}

impl Drawable for Circle {
    fn draw(&self) -> String {
        format!("Círculo en ({}, {})", self.x, self.y)
    }

    fn area(&self) -> f64 {
        3.14 * self.radius * self.radius
    }
}

// Falta implementar Resizable para Circle

fn main() {
    let c = Circle { radius: 3.0, x: 0.0, y: 0.0 };
    println!("{}", c.draw());
    // println!("{}", c.description()); // Método no implementado
}