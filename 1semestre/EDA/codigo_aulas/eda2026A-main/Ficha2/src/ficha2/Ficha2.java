/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package ficha2;

/**
 *
 * @author IPT
 */
public class Ficha2 {
    
    public static long runXTimes(Stack s, int x) {
        long sum = 0;
        for(int i = 0; i <= x; i++) {
            long start = System.nanoTime();
            
            for(int j = 0; j < 1000000; j++)
                s.push(Math.random());
            while(!s.isEmpty())
                s.pop();
            
            long end = System.nanoTime();
            sum += end-start;
        }
        return sum/x;
    }

    public static long runXTimes(java.util.Stack s, int x) {
        long sum = 0;
        for(int i = 0; i <= x; i++) {
            long start = System.nanoTime();
            
            for(int j = 0; j < 1000000; j++)
                s.push(Math.random());
            while(!s.isEmpty())
                s.pop();
            
            long end = System.nanoTime();
            sum += end-start;
        }
        return sum/x;
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        System.out.println("Limited Stack  " + runXTimes(new LimitedStack(1000000), 50));
        System.out.println("Ilimited Stack " + runXTimes(new IlimitedStack(), 50));
        System.out.println("Java Stack     " + runXTimes(new java.util.Stack(), 50));

    }
    
}
