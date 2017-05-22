// 2D vector class
/* ======================================================================
Angle convention for the Vect2 class

                 +90 (+j)
                    ^
                    |
                    |
+/-180 (-i) <------- -------> 0 (+i)
                    |
                    |
                    v
                 -90 (-j)


====================================================================== */
public static class Vect2
{    
  /* ======================================================================
  Class members
  ====================================================================== */
    protected double i;
    protected double j;
    
  /* ======================================================================
  Constructors
  ====================================================================== */
  //---------- default constructor ----------
    public Vect2()
    {
        i = 0;
        j = 0;
    }
  
  //---------- constant initializer ----------
    public Vect2(double x, double y)
    {
        i = x;
        j = y;
    }

  //---------- copy constructor ----------
    public Vect2(Vect2 v)
    {
      i = v.i;
      j = v.j;
    }

  /* ======================================================================
  returns a string formatted representation of the vector
  ====================================================================== */
    public String format()
    {
        return String.format("[%.4f i + %.4f j]", i, j);
    }
    
  /* ======================================================================
    Initialize Vect2 from an angle in degrees
  ====================================================================== */
    public static Vect2 from_degrees(double degrees)
    {
        return Vect2.from_rads(degrees*Math.PI/180.0);
    }

  /* ======================================================================
    Initialize Vect2 from an angle in radians'''
  ====================================================================== */
    public static Vect2 from_rads(double radians)
    {
        double i_ = Math.cos(radians);
        double j_ = Math.sin(radians);
        return new Vect2(i_, j_);
    }
  /* ======================================================================
  Add the supplied vector
  ====================================================================== */
    public void add (Vect2 v)
    {
        i += v.i;
        j += v.j;
    }

  /* ======================================================================
  Subtract the supplied vector
  ====================================================================== */
    public void sub(Vect2 v)
    {
        i -= v.i;
        j -= v.j;
    }

  /* ======================================================================
  Scale the vector by the supplied scaling constant
  ====================================================================== */
    public void scale(double scalar)
    {
      i *= scalar;
      j *= scalar;
    }

  /* ======================================================================
  Creates and returns a new vector that is the sum of the two supplied vectors
  ====================================================================== */
    public static Vect2 add (Vect2 v1, Vect2 v2)
    {
        return new Vect2(v1.i + v2.i, v1.j + v2.j);
    }

  /* ======================================================================
  Creates and returns a new vector that is the difference of the two supplied vectors
  ====================================================================== */
    public static Vect2 sub(Vect2 v1, Vect2 v2)
    {
        return new Vect2(v1.i - v2.i, v1.j - v2.j);
    }

  /* ======================================================================
  Creates and returns a new vector that is the scaled version of the supplied vector
  ====================================================================== */
    public static Vect2 scale(Vect2 v, double scalar)
    {
        return new Vect2(v.i * scalar, v.j * scalar);
    }


  /* ======================================================================
  returns the magnitude of the vector
  ====================================================================== */
    public double magnitude()
    {
        return(Math.sqrt(Math.pow(i, 2) + Math.pow(j, 2)));
    }

  /* ======================================================================
  returns the angle of the vector in radians
  ====================================================================== */
    public double angle()
    {
        return Math.atan2(j, i);
    }

  /* ======================================================================
  returns a unit vector for the current vector
  ====================================================================== */
    public Vect2 unit_vector()
    {
        double mag = magnitude();
        if (mag == 0)
            return new Vect2(1, 0);
        else
            return new Vect2(i/mag, j/mag);
    }

/*
    Vect2 point1 = new Vect2(3, 4);
    Vect2 point2 = new Vect2(1.0, 1.0);
    Vect2 point3 = Vect2.scale(point1, 2);
    
    point2.scale(3);
    
    println ("point1=", point1.format());
    println ("point2=", point2.format());
    println ("point3=", point3.format());

    println("179 -->" , Vect2.from_degrees(179).format());
    println("-179 -->" , Vect2.from_degrees(-179).format());
    println("90 -->" , Vect2.from_degrees(90).format());
    println("-90 -->" , Vect2.from_degrees(-90).format());
*/

}  //class


/* ======================================================================
====================================================================== */

//----------  ----------
//----------  ----------
//----------  ----------