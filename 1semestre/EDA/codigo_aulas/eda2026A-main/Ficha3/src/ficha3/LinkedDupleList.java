/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ficha3;

import java.util.ArrayList;


/**
 *
 * @author IPT
 */
public class LinkedDupleList implements LinkedList{
    
    private Item head, tail;
    
    public LinkedDupleList() {
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
        item.previous = null;
        if (isEmpty()) { 
            head = item;
            tail = item;
        } else {
            item.next = head;  
            head.previous = item;
            head = item;
        }
    }

    @Override
    public void addLast(Object o) {
        Item item = new Item();
        item.data = o;
        item.next = null;
        item.previous = null;
        if (isEmpty()) { 
            head = item;
            tail = item;
        } else {
            item.previous = tail;
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
        if (head == null)  
            return false;
        else {
            if (o.equals(head.data)) {
                if (head == tail) {
                    head = null;
                    tail = null;
                } else {
                    head = head.next;
                    head.previous = null;
                }
                return true;
            }
            Item i = head.next;
            while (i != null && !o.equals(i.data))
                i = i.next;
            if (i == tail) {
                tail = tail.previous;
                tail.next = null;
                return true;
            } else {
                if (i != null) {
                    i.previous.next = i.next;
                    i.next.previous = i.previous;
                    return true;
                }
            }
            return false;
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
            aux = aux.next;
        }
        return count;
    }
    
    public void show(int dir) {
        Item i = dir>0?head:tail;
        while (i!=null) {
            System.out.print(i.data+"->");
            i = dir>0?i.next:i.previous;
        }
        System.out.println("null");
    }
    
    public void show() {
        Item i = head;
        while (i!=null) {
            System.out.print(i.data+"->");
            i = i.next;
        }
        System.out.println("null");
    }
    
    public int size() {
        Item i = head;
        int c = 0;
        while (i!=null) {
            c++;
            i = i.next;
        }
        return c;
    }
    
    public int replaceAll(Object o1, Object o2) {
        Item i = head;
        int c = 0;
        while (i!=null) {
            if (i.data.equals(o1)) {
                i.data = o2;
                c++;
            }
            i = i.next;
        }
        return c;
    }
    
    public void insertSort(Comparable o) {
        Item item = new Item();
        item.data = o;
        item.next = null;
        item.previous = null;
        if (head == null) {// empty list 
            head = item;
            tail = item;
        } else if (o.compareTo(head.data)<0) { // add first
            item.next = head;
            head.previous = item;
            head = item;
        } else if (o.compareTo(tail.data)>0) { // add last
            tail.next = item;
            item.previous = tail;
            tail = item;
        } else { // add on the middle of the list
            Item i = head;
            while (o.compareTo(i.data)>0)
                i = i.next;
            i.previous.next = item;
            item.previous = i.previous;
            item.next = i;
            i.previous = item;
        }     
    }
    
    public void addNext(int i, Object o) {
        if (i<0) 
            addFirst(o);
        Item aux = head;
        int index = 0;
        while (aux != null && index < i) {
            index++;
            aux = aux.next;  
        }
        if (i >= index)
            addLast(o);
        else {
            Item item = new Item();
            item.data = o;
            item.previous = aux;
            item.next = aux.next;
            aux.next.previous = item;
            aux.next = item;
        }
    }
    
    public Object removeLast() {
        if (head == null)
            return null;
        Object aux = tail.data;
        
        if (head == tail) 
            head = tail = null;
        else {
            tail = tail.previous;
            tail.next = null;
        }
        return aux;
    }
    
    public void invert() {
        java.util.Stack s = new java.util.Stack();
        while (!isEmpty())
            s.push(removeLast());
        while (!s.empty())
            addFirst(s.pop());
                    
    }  
    
  
    public void removeDuplicates() {
        ArrayList a = new ArrayList();
        Item aux = head;
        while (aux != null) {
            if (count(aux.data)>1 && !a.contains(aux.data))
                a.add(aux.data);
            aux = aux.next;
        }
        for(Object o:a)
            while (count(o)>1)
                remove(o);
            
    }
    
    public void removeAll(LinkedDupleList l1) {
        Item i = l1.head;
        while(i!=null) {
            remove(i.data);
            i = i.next;
        }
    }
    
    private class Item {
        Object data;
        Item next;
        Item previous;
    }
    
}
