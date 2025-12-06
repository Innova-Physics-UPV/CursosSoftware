trait Drawable {
    fn draw(&self) -> String;
    fn area(&self) -> f64;    fn description(&self) -> String {
        format!("{} (área: {:.2})", self.draw(), self.area())
    }
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

impl Resizable for Circle {
    fn resize(&mut self, scale: f64) {
        self.radius *= scale;
    }
}

struct Rectangle {
    width: f64,
    height: f64,
    x: f64,
    y: f64,
}

impl Drawable for Rectangle {
    fn draw(&self) -> String {
        format!("Rectángulo en ({}, {})", self.x, self.y)
    }

    fn area(&self) -> f64 {
        self.width * self.height
    }
}

impl Resizable for Rectangle {
    fn resize(&mut self, scale: f64) {
        self.width *= scale;
        self.height *= scale;
    }
}

fn main() {
    let mut c = Circle { radius: 3.0, x: 0.0, y: 0.0 };
    let mut r = Rectangle { width: 4.0, height: 2.0, x: 1.0, y: 1.0 };

    // Dibujar sin modificar usando una función genérica
    draw_shape(&c);
    draw_shape(&r);

    // Redimensionar y dibujar usando función genérica que requiere Resizable
    resize_and_draw(&mut c, 1.5);
    resize_and_draw(&mut r, 2.0);
}

// Función genérica que dibuja cualquier cosa que implemente Drawable
fn draw_shape<T: Drawable>(shape: &T) {
    println!("Dibujando: {}", shape.description());
}

// Función genérica que redimensiona (si es posible) y dibuja
fn resize_and_draw<T>(shape: &mut T, scale: f64)
where
    T: Drawable + Resizable,
{
    println!("Antes: {}", shape.description());
    shape.resize(scale);
    println!("Después: {}", shape.description());
}