/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package ficha3;

import java.util.Iterator;
import java.util.Random;

/**
 *
 * @author IPT
 */
public class Ficha3 {

    public static int LINKEDSINGLELIST = 1;
    public static int LINKEDDUPLELIST = 2;
    public static int LINKELISTJAVA = 3;

    
    public static long runXTimes(int listType, int x) {
        long sum = 0;
        for(int i = 0; i < x; i++) {
            long start = System.nanoTime();
            if (listType == LINKELISTJAVA) {
                java.util.LinkedList l = new java.util.LinkedList();
                Random r =new Random();
                for(int j = 0; j < 1000000; j++)
                    l.addFirst(r.nextInt(100)+1);
                for(int j = 1; j <= 100; j++) {
                    Iterator it = l.iterator();
                    int count = 0;
                    while (it.hasNext()) {
                        Object o = it.next();
                        if (o.equals(j))
                            count++;
                    }
                }
            } else {
                LinkedList l;
                if (listType == LINKEDSINGLELIST)
                    l = new LinkedSingleList();
                else
                    l = new LinkedDupleList();
                Random r =new Random();
                for(int j = 0; j < 1000000; j++)
                    l.addFirst(r.nextInt(100)+1);
                for(int j = 1; j <= 100; j++)
                    l.count(j);
            }
            
            long end = System.nanoTime();
            sum += end-start;
        }
        return sum/x;
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        System.out.println("LinkedSingleList " +  runXTimes(LINKEDSINGLELIST,10));
        System.out.println("LinkedDupleList  " +  runXTimes(LINKEDDUPLELIST,10));
        System.out.println("Java LinkedList  " +  runXTimes(LINKELISTJAVA,10));
    }
    
}
