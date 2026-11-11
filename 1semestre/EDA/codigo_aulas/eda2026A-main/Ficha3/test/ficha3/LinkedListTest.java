/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ficha3;

import static org.junit.Assert.assertEquals;

/**
 *
 * @author IPT
 */
public class LinkedListTest {

    public static void testIsEmpty(LinkedList l) {
        System.out.println("isEmpty");
        assertEquals(true, l.isEmpty());
        l.addFirst(1);
        assertEquals(false, l.isEmpty());
        l.remove(1);
        assertEquals(true, l.isEmpty());
    }


    public static void testAddFirst(LinkedList l) {
        System.out.println("addFirst");
        l.addFirst(1);
        assertEquals(1, l.peekFirst());
        l.addFirst(2);
        assertEquals(2, l.peekFirst());
        l.addFirst(3);
        assertEquals(3, l.peekFirst());
    }

    public static void testAddLast(LinkedList l) {
        System.out.println("addLast");
        l.addLast(1);
        assertEquals(1, l.peekLast());
        l.addLast(2);
        assertEquals(2, l.peekLast());
        l.addLast(3);
        assertEquals(3, l.peekLast());
    }

    public static void testContains(LinkedList l) {
        System.out.println("contains");
        assertEquals(false, l.contains(1));
        l.addFirst(1);
        assertEquals(true, l.contains(1));
        l.addFirst(2);
        l.addFirst(3);
        assertEquals(true, l.contains(1));
        assertEquals(true, l.contains(2));
        assertEquals(true, l.contains(3));
        assertEquals(false, l.contains(4));     
    }

    public static void testRemove(LinkedList l) {
        System.out.println("remove");
        assertEquals(false, l.remove(1));
        l.addFirst(1);
        l.addFirst(2);
        l.addFirst(3);
        l.addFirst(4);
        assertEquals(true, l.remove(3));
        assertEquals(false, l.contains(3));
        assertEquals(true, l.remove(1));
        assertEquals(false, l.contains(1));
        assertEquals(true, l.remove(4));
        assertEquals(false, l.contains(4));
        assertEquals(true, l.remove(2));
        assertEquals(false, l.contains(2));
    }

    public static void testPeekFirst(LinkedList l) {
        System.out.println("peekFirst");
        assertEquals(null, l.peekFirst());
        l.addFirst(1);
        assertEquals(1, l.peekFirst());
        l.addFirst(2);
        assertEquals(2, l.peekFirst());
        l.remove(2);
        assertEquals(1, l.peekFirst());
        l.remove(1);
        assertEquals(null, l.peekFirst());
    }

    public static void testPeekLast(LinkedList l) {
        System.out.println("peekLast");
        assertEquals(null, l.peekLast());
        l.addLast(1);
        assertEquals(1, l.peekLast());
        l.addLast(2);
        assertEquals(2, l.peekLast());
        l.remove(2);
        assertEquals(1, l.peekLast());
        l.remove(1);
        assertEquals(null, l.peekLast());
    } 
}
