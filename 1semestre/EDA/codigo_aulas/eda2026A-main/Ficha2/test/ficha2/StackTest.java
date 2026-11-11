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
public class StackTest {
    
    public StackTest() {
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

    public void testIsEmpty(Stack s) {
        System.out.println("isEmpty");
        assertEquals(true, s.isEmpty());
        s.push(1);
        assertEquals(false, s.isEmpty());
        s.pop();
        assertEquals(true, s.isEmpty());
    }

    public void testPush(Stack s) {
        System.out.println("push");
        for(int i = 0; i < 10; i++) {
            s.push(i);
            assertEquals(i,s.peek());
        }
    }
    
    public void testPushFullStack(Stack s) {
        System.out.println("push");
        for(int i = 0; i < 10; i++) {
            s.push(i);
        }
        try {
            s.push(10);
            fail("StackFullException must be raised.");
        } catch (StackFullException e) {
            assertEquals(true, true);
        }
    }

    public void testPop(Stack s) {
        System.out.println("pop");
        assertEquals(null, s.pop());
        for(int i = 1; i<=10; i++)
            s.push(i);
        for(int i = 10; i>=1; i--)
            assertEquals(i, s.pop());
        assertEquals(null, s.pop());
    }

    public void testPeek(Stack s) {
        System.out.println("peek");
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
    
    @Test
    public void testLimitedStack() {
        testIsEmpty(new LimitedStack(10));
        testPush(new LimitedStack(10));
        testPushFullStack(new LimitedStack(10));
        testPop(new LimitedStack(10));
        testPeek(new LimitedStack(10));
    }
    
    @Test
    public void testIlimitedStack() {
        testIsEmpty(new IlimitedStack());
        testPush(new IlimitedStack());
        testPop(new IlimitedStack());
        testPeek(new IlimitedStack());
    }
}
