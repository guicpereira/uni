/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package ficha3;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author IPT
 */
public class LinkedDupleListTest {
    
    public LinkedDupleListTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    /**
     * Test of isEmpty method, of class LinkedDupleList.
     */
    @Test
    public void testIsEmpty() {
        LinkedListTest.testIsEmpty(new LinkedDupleList());
    }

    /**
     * Test of addFirst method, of class LinkedDupleList.
     */
    @Test
    public void testAddFirst() {
        LinkedListTest.testAddFirst(new LinkedDupleList());
    }

    /**
     * Test of addLast method, of class LinkedDupleList.
     */
    @Test
    public void testAddLast() {
        LinkedListTest.testAddLast(new LinkedDupleList());
    }

    /**
     * Test of contains method, of class LinkedDupleList.
     */
    @Test
    public void testContains() {
        LinkedListTest.testContains(new LinkedDupleList());
    }

    /**
     * Test of remove method, of class LinkedDupleList.
     */
    @Test
    public void testRemove() {
        System.out.println("remove");
        LinkedListTest.testRemove(new LinkedDupleList());
    }

    /**
     * Test of peekFirst method, of class LinkedDupleList.
     */
    @Test
    public void testPeekFirst() {
        LinkedListTest.testPeekFirst(new LinkedDupleList());
    }

    /**
     * Test of peekLast method, of class LinkedDupleList.
     */
    @Test
    public void testPeekLast() {
        LinkedListTest.testPeekLast(new LinkedDupleList());
    }
    
    
}
