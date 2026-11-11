/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ficha3;

/**
 *
 * @author IPT
 */
public class aulaTP {
    public static void main(String[] args) {
        LinkedDupleList l = new LinkedDupleList();
        l.addLast(1);
        l.addLast(2);
        l.addLast(1);
        l.addLast(3);
        l.addLast(2);
        l.show();
        l.removeDuplicates();
        l.show();
        
     
    }
    
}
