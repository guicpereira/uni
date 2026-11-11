/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ficha2;

/**
 *
 * @author IPT
 */
public class IlimitedStack implements Stack {
    
    private Item top;
    
    public IlimitedStack() {
        top = null;
    }

    @Override
    public boolean isEmpty() {
        return top == null;
    }

    @Override
    public void push(Object data) {
        Item item = new Item();
        item.data = data;
        item.next = top;
        top = item;
    }

    @Override
    public Object pop() {
        if (isEmpty())
            return null;
        else {
            Object data = top.data;
            top = top.next;
            return data;
        }
    }

    @Override
    public Object peek() {
         if (isEmpty())
            return null;
        else 
            return top.data;
    }
    
    private class Item {
        Object data;
        Item next;
    }
    
}
