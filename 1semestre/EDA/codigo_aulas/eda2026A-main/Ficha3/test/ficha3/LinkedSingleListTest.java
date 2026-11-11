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
public class LinkedSingleListTest {
    
    public LinkedSingleListTest() {
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
     * Test of isEmpty method, of class LinkedSingleList.
     */
    @Test
    public void testIsEmpty() {
        LinkedListTest.testIsEmpty(new LinkedSingleList());
    }

    /**
     * Test of addFirst method, of class LinkedSingleList.
     */
    @Test
    public void testAddFirst() {
        LinkedListTest.testAddFirst(new LinkedSingleList());
    }

    /**
     * Test of addLast method, of class LinkedSingleList.
     */
    @Test
    public void testAddLast() {
        LinkedListTest.testAddLast(new LinkedSingleList());
    }

    /**
     * Test of contains method, of class LinkedSingleList.
     */
    @Test
    public void testContains() {
        LinkedListTest.testContains(new LinkedSingleList());
    }

    /**
     * Test of remove method, of class LinkedSingleList.
     */
    @Test
    public void testRemove() {
        System.out.println("remove");
        LinkedListTest.testRemove(new LinkedSingleList());
    }

    /**
     * Test of peekFirst method, of class LinkedSingleList.
     */
    @Test
    public void testPeekFirst() {
        LinkedListTest.testPeekFirst(new LinkedSingleList());
    }

    /**
     * Test of peekLast method, of class LinkedSingleList.
     */
    @Test
    public void testPeekLast() {
        LinkedListTest.testPeekLast(new LinkedSingleList());
    }
    
    
}
