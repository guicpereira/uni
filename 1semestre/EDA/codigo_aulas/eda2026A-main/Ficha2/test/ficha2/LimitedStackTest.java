/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package ficha2;

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
public class LimitedStackTest {
    
    public LimitedStackTest() {
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
     * Test of isEmpty method, of class LimitedStack.
     */
    @Test
    public void testIsEmpty() {
        System.out.println("isEmpty");
        LimitedStack s = new LimitedStack(10);
        assertEquals(true, s.isEmpty());
        s.push(1);
        assertEquals(false, s.isEmpty());
        s.pop();
        assertEquals(true, s.isEmpty());
    }

    /**
     * Test of push method, of class LimitedStack.
     */
    @Test
    public void testPush() {
        System.out.println("push");
        LimitedStack s = new LimitedStack(10);
        for(int i = 0; i < 10; i++) {
            s.push(i);
            assertEquals(i,s.peek());
        }
        try {
            s.push(10);
            fail("StackFullException must be raised.");
        } catch (StackFullException e) {
            assertEquals(true, true);
        }
    }

    /**
     * Test of pop method, of class LimitedStack.
     */
    @Test
    public void testPop() {
        System.out.println("pop");
        LimitedStack s = new LimitedStack(10);
        assertEquals(null, s.pop());
        for(int i = 1; i<=10; i++)
            s.push(i);
        for(int i = 10; i>=1; i--)
            assertEquals(i, s.pop());
        assertEquals(null, s.pop());
    }

    /**
     * Test of peek method, of class LimitedStack.
     */
    @Test
    public void testPeek() {
        System.out.println("peek");
        LimitedStack s = new LimitedStack(10);
        assertEquals(null, s.peek());
        for(int i = 1; i<=10; i++) {
            s.push(i);
            assertEquals(i, s.peek());
        }
        for(int i = 10; i>=1; i--) {
            s.pop();
            if (i == 1)
                assertEquals(null, s.peek());
            else
                assertEquals(i-1, s.peek());
        }
    }
    
}
