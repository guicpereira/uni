/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package ficha1;

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
public class MathTest {
    
    public MathTest() {
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
     * Test of factorialI method, of class Math.
     */
    @Test
    public void testFactorialI() {
        assertEquals(1, Math.factorialI(0));
        assertEquals(1, Math.factorialI(1));
        assertEquals(2, Math.factorialI(2));
        assertEquals(6, Math.factorialI(3));
        assertEquals(24, Math.factorialI(4));
        assertEquals(120, Math.factorialI(5));
    }

    /**
     * Test of factorialR method, of class Math.
     */
    @Test
    public void testFactorialR() {
        System.out.println("factorialR");
        assertEquals(1, Math.factorialR(0));
        assertEquals(1, Math.factorialR(1));
        assertEquals(2, Math.factorialR(2));
        assertEquals(6, Math.factorialR(3));
        assertEquals(24, Math.factorialR(4));
        assertEquals(120, Math.factorialR(5));
    }
    
}
