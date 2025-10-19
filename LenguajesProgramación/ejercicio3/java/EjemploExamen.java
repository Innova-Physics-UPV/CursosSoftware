class Examen{
    String nombre;
    private double test;
    private double problemas;
    double nota;

    public Examen(String nombre,double test,double problemas){
        this.nombre=nombre;
        this.test=test;
        this.problemas=problemas;
        this.nota=0.5*test+0.5*problemas;
    }

    public void nota(){
        System.out.println("Nombre: "+nombre);
        System.out.println("Nota: "+nota);
    }
}

class Examen_práctico extends Examen{
    double práctica;
    double nota_con_práctica;

    public Examen_práctico(String nombre, double test, double problemas, double práctica){
        super(nombre,test,problemas);
        this.práctica=práctica;
        this.nota_con_práctica=0.8*nota+0.2*práctica;
    }

    public void nota(){
        System.out.println("Nombre: "+nombre);
        System.out.println("Nota: "+nota_con_práctica);
    }
}
public class class_java {
    public static void main(String[] args){
        Examen examen_l=new Examen("Luiscarlos",9,8.5);
        Examen_práctico examen_s=new Examen_práctico("Sebastián",5,7,5.5);
        examen_l.nota();
        examen_s.nota();
        }
}

