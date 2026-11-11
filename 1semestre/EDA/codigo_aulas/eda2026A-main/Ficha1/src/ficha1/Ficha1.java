/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package ficha1;

/**
 *
 * @author IPT
 */
public class Ficha1 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Math.factorialBigI(0);
        // TODO code application logic here
        for(int i = 1000; i <= 20000; i+=1000) {
            System.out.println(i+"-" + runFactoriaIXTimes(10, i) );
        }
        
        System.out.println("------------------------");
        
        for(int i = 1000; i <= 20000; i+=1000) {
            System.out.println(i+"-" + runFactoriaRXTimes(10, i) );
        }
    }
    
    public static long runFactoriaIXTimes(int x, int num) {
        long sum=0;
        for(int i = 0; i < x; i++) {
            long start = System.nanoTime();
            Math.factorialBigI(num);
            long end = System.nanoTime();
            sum += end-start;
        }
        return sum/x;
    }
    
    public static long runFactoriaRXTimes(int x, int num) {
        long sum=0;
        for(int i = 0; i < x; i++) {
            long start = System.nanoTime();
            Math.factorialBigR(num);
            long end = System.nanoTime();
            sum += end-start;
        }
        return sum/x;
    }
}
