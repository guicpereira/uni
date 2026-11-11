/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ficha3;

/**
 *
 * @author IPT
 */
public class LinkedSingleList implements LinkedList{
    
    private Item head, tail;
    
    public LinkedSingleList() {
        head = null;
        tail = null;
    }

    @Override
    public boolean isEmpty() {
        return head == null;
    }

    @Override
    public void addFirst(Object o) {
        Item item = new Item();
        item.data = o;
        item.next = null;
        if (isEmpty()) { 
            head = item;
            tail = item;
        } else {
            item.next = head;          
            head = item;
        }
    }

    @Override
    public void addLast(Object o) {
        Item item = new Item();
        item.data = o;
        item.next = null;
        if (isEmpty()) { 
            head = item;
            tail = item;
        } else {
            tail.next = item;
            tail = item;
        }
    }

    @Override
    public boolean contains(Object o) {
        Item i = head;
        while (i != null && !i.data.equals(o))
            i = i.next;
        if (i == null)
            return false;
        else
            return true;  
    }

    @Override
    public boolean remove(Object o) {
        if (head == null)  // Empty List
            return false;
        else {
            Item i = head;
            if (i.data.equals(o)) {  // Value to remove on begining of List
                if (head == tail) { // List with one value 
                    head = null;
                    tail = null;
                } else // List with more that one value
                    head = head.next;
                return true;
            }
            while (i.next != null && !i.next.data.equals(o))
                i = i.next;
            if (i.next != null) {
                if (i.next == tail) // value to remove on ending of list
                    tail = i;
                i.next = i.next.next; // value to remove on middle of list
                return true;
            }
            return false; // value to remove doesn't exits on list 
        }
    }

    @Override
    public Object peekFirst() {
        if (isEmpty())
            return null;
        else
            return head.data;
    }

    @Override
    public Object peekLast() {
        if (isEmpty())
            return null;
        else
            return tail.data;
    }
    
    @Override
    public int count(Object o) {
        Item aux = head;
        int count = 0;
        while(aux != null) {
            if (aux.data.equals(o))
                count++;
            aux=aux.next;
        }
        return count;
    }
    
    private class Item {
        Object data;
        Item next;
    }
    
}
