/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ficha0;

/**
 *
 * @author IPT
 */
public class Complex {
    
    private double r, i;

    public Complex() {
        // cria o seguinte número complexo:  0+0i 
        this(0,0);
    }

    /**
     * Creates a complex number
     * @param a real part of the number
     * @param b imaginary part of the number
     */
    public Complex(double a, double b) {
        // cria o seguinte número complexo: a+bi 
        r=a; 
        i=b;
    } 
    
    public double getRealPart() {
        // devolve a parte real do complexo
        return r;
        
    }

    public double getParteImaginaria() {
        // devolve a parte imaginaria do complexo
        return i;
    }

    public static Complex sum(Complex c1, Complex c2) {
        // devolve um número complexo com a soma de c1 e c2
        double r = c1.r+c2.r;
        double i = c1.i+c2.i;
        return new Complex(r,i);
    }

    public static Complex sub(Complex c1, Complex c2) {
        // devolve um número complexo com a subtracção de c1 e c2
        double r = c1.r-c2.r;
        double i = c1.i-c2.i;
        return new Complex(r,i);
    }

    public static Complex mul(Complex c1, Complex c2) {
        // devolve um número complexo com a multiplicação de c1 e c2
        double r = c1.r*c2.r-c1.i*c2.i;
        double i = c1.r*c2.i+c1.i*c2.r;
        return new Complex(r,i);
    }

    public static Complex div(Complex c1, Complex c2) {
        // devolve um número complexo com a divisão de c1 e c2 
        Complex num = mul(c1, conjugate(c2));
        Complex den = mul(c2, conjugate(c2));
        return new Complex(num.r/den.r, num.i/den.r);
    }

    public static Complex conjugate(Complex c) {
        // devolve um número complexo com o conjugado de c 
        return new Complex(c.r, -1*c.i);
    }

    @Override
    public String toString() {
        // devolve uma string no formato a+bi ou a-bi ou -a+bi ou -a-bi 
        // consoante os termos reais e imaginários sejam positivos ou 
        // negativos 
        String str =String.valueOf(r);
        if (i>=0)
            str += "+";
        str += String.valueOf(i);
        str += "i";
        return str;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Complex other = (Complex) obj;
        if (Double.doubleToLongBits(this.r) != Double.doubleToLongBits(other.r)) {
            return false;
        }
        return Double.doubleToLongBits(this.i) == Double.doubleToLongBits(other.i);
    }

    @Override
    public Object clone() {
        // devolve um novo número complexo com o mesmo valor 
        return new Complex(r,i);
    }  
}
