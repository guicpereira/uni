/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package ficha0;

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
public class ComplexTest {
    
    public ComplexTest() {
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
     * Test of getParteReal method, of class Complex.
     */
    @Test
    public void testGetParteReal() {
        System.out.println("getParteReal");
        assertEquals(2, new Complex(2,3).getRealPart(), 0);
        assertEquals(-2, new Complex(-2,3).getRealPart(), 0);
        assertEquals(0, new Complex().getRealPart(), 0);
    }

    /**
     * Test of getParteImaginaria method, of class Complex.
     */
    @Test
    public void testGetParteImaginaria() {
        System.out.println("getParteImaginaria");
        assertEquals(3, new Complex(2,3).getParteImaginaria(), 0);
        assertEquals(-3, new Complex(2,-3).getParteImaginaria(), 0);
        assertEquals(0, new Complex().getParteImaginaria(), 0);
    }

    /**
     * Test of sum method, of class Complex.
     */
    @Test
    public void testSum() {
        System.out.println("sum");
        Complex c1 = new Complex(2,2);
        Complex c2 = new Complex(3,3);
        Complex expResult = new Complex(5,5);
        Complex result = Complex.sum(c1, c2);
        assertEquals(expResult, result);
        
        c1 = new Complex(2,-2);
        c2 = new Complex(-3,3);
        expResult = new Complex(-1,1);
        result = Complex.sum(c1, c2);
        assertEquals(expResult, result);
    }

    /**
     * Test of sub method, of class Complex.
     */
    @Test
    public void testSub() {
        System.out.println("sub");
        Complex c1 = new Complex(2,2);
        Complex c2 = new Complex(3,3);
        Complex expResult = new Complex(-1,-1);
        Complex result = Complex.sub(c1, c2);
        assertEquals(expResult, result);
        
        c1 = new Complex(2,-2);
        c2 = new Complex(-3,3);
        expResult = new Complex(5,-5);
        result = Complex.sub(c1, c2);
        assertEquals(expResult, result);
    }

    /**
     * Test of mul method, of class Complex.
     */
    @Test
    public void testMul() {
        System.out.println("mul");
        Complex c1 = new Complex(2,2);
        Complex c2 = new Complex(3,3);
        Complex expResult = new Complex(0,12);
        Complex result = Complex.mul(c1, c2);
        assertEquals(expResult, result);
        
        c1 = new Complex(2,-2);
        c2 = new Complex(-3,3);
        expResult = new Complex(0,12);
        result = Complex.mul(c1, c2);
        assertEquals(expResult, result);
    }

    /**
     * Test of div method, of class Complex.
     */
    @Test
    public void testDiv() {
        System.out.println("div");
        Complex c1 = new Complex(2,2);
        Complex c2 = new Complex(3,3);
        Complex expResult = new Complex(12.0/18,0);
        Complex result = Complex.div(c1, c2);
        assertEquals(expResult, result);
    }

    /**
     * Test of conjugate method, of class Complex.
     */
    @Test
    public void testConjugate() {
        System.out.println("conjugate");
        assertEquals(new Complex(1,-1), Complex.conjugate(new Complex(1,1)));
  
    }

    /**
     * Test of toString method, of class Complex.
     */
    @Test
    public void testToString() {
        System.out.println("toString");
        assertEquals("1.0+1.0i", new Complex(1,1).toString());
        assertEquals("-1.0+1.0i", new Complex(-1,1).toString());
        assertEquals("1.0-1.0i", new Complex(1,-1).toString());
        assertEquals("-1.0-1.0i", new Complex(-1,-1).toString());
    }


    /**
     * Test of clone method, of class Complex.
     */
    @Test
    public void testClone() {
        System.out.println("clone");

        assertEquals(new Complex(1,2), new Complex(1,2).clone());

    }
    
}
