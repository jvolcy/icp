/* ======================================================================
// Base actor object
====================================================================== */

public class Actor
{   
  /* ======================================================================
  Class members
  ====================================================================== */
    /* the border policy controls what happens to the actor when it attempts to
    move beyond the boders of the screen. */
    protected static final int BORDER_POLICY_NONE = 0;    //no policy at the screen border
    protected static final int  BORDER_POLICY_WRAP = 1;    //wrap around to the other side of the screen
    protected static final int  BORDER_POLICY_CLIP = 2;    //do not go outside the borders of the screen 

    protected static final int LEFT_BORDER = 0;
    protected static final int RIGHT_BORDER = 1;
    protected static final int TOP_BORDER = 2;
    protected static final int BOTTOM_BORDER = 3;
    
    protected int borders[] = new int[4];
    protected int borderPolicy[] = new int[4];
    protected int screenWidth;
    protected int screenHeight;
    
    protected Vect2 location;
    protected Vect2 heading;
    protected Vect2 velocity;
    protected double max_velocity;
    protected Vect2 acceleration;
    
  /* ======================================================================
  Constructors
  ====================================================================== */
  //---------- default constructor ----------
    public Actor()
    {
        //---------- set the default border policies ----------
        borderPolicy[LEFT_BORDER] = BORDER_POLICY_NONE;
        borderPolicy[RIGHT_BORDER] = BORDER_POLICY_NONE;
        borderPolicy[TOP_BORDER] = BORDER_POLICY_NONE;
        borderPolicy[BOTTOM_BORDER] = BORDER_POLICY_NONE;

        //---------- set the default borders & screen dimensions ----------
        setBorders(0, 0, 100, 100);
    
        //---------- set default location and heading ----------
        location = new Vect2(0, 0);
        heading = new Vect2(0, 1);    //north
        
        //---------- set velocity and acceleration (magnitudes) ----------
        max_velocity = 0;       //no max
        velocity = new Vect2(0, 0);
        acceleration = new Vect2(0, 0);

        //----------  ----------
        //----------  ----------

    }

  /* ======================================================================
  ====================================================================== */
    public void setBorders(int left, int top, int width, int height)
    {
      screenWidth = width;
      screenHeight = height;
      
      //---------- set the borders for the actor ----------
      borders[LEFT_BORDER] = left;
      borders[RIGHT_BORDER] = left + screenWidth - 1;
      borders[TOP_BORDER] = top;
      borders[BOTTOM_BORDER] = top + screenHeight - 1;
    }


  /* ======================================================================
  ====================================================================== */
  public void setBorderPolicies(int leftPolicy, 
      int rightPolicy, int topPolicy, 
      int bottomPolicy)
  {
      borderPolicy[LEFT_BORDER] = leftPolicy;
      borderPolicy[RIGHT_BORDER] = rightPolicy;
      borderPolicy[TOP_BORDER] = topPolicy;
      borderPolicy[BOTTOM_BORDER] = bottomPolicy;
  }

  /* ======================================================================
  ====================================================================== */
  public Vect2 getLocation()
  {
    return new Vect2(location);
  }
  
  /* ======================================================================
  ====================================================================== */
  public void setLocation(Vect2 v)
  {
    location.i = v.i;
    location.j = v.j;
    
    if (location.i > borders[RIGHT_BORDER])
        //gone too far right
        if (borderPolicy[RIGHT_BORDER] == BORDER_POLICY_WRAP)
            location.i -= borders[RIGHT_BORDER] - borders[LEFT_BORDER];
        else if (borderPolicy[RIGHT_BORDER] == BORDER_POLICY_CLIP)
            location.i = borders[RIGHT_BORDER];

    if (location.i < borders[LEFT_BORDER])
        //gone too far left
        if (borderPolicy[RIGHT_BORDER] == BORDER_POLICY_WRAP)
            location.i += borders[RIGHT_BORDER] - borders[LEFT_BORDER];
        else if (borderPolicy[RIGHT_BORDER] == BORDER_POLICY_CLIP)
            location.i = borders[LEFT_BORDER];

    if (location.j > borders[BOTTOM_BORDER])
        //gone too far down
        if (borderPolicy[BOTTOM_BORDER] == BORDER_POLICY_WRAP)
            location.j -= borders[BOTTOM_BORDER] - borders[TOP_BORDER];
        else if (borderPolicy[BOTTOM_BORDER] == BORDER_POLICY_CLIP)
            location.j = borders[BOTTOM_BORDER];

    if (location.j < borders[TOP_BORDER])
        //gone too far up
        if (borderPolicy[TOP_BORDER] == BORDER_POLICY_WRAP)
            location.j += borders[BOTTOM_BORDER] - borders[TOP_BORDER];
        else if (borderPolicy[TOP_BORDER] == BORDER_POLICY_CLIP)
            location.j = borders[TOP_BORDER];

  }
  
  /* ======================================================================
  ====================================================================== */
  public Vect2 getHeading()
  {
    return new Vect2(heading);
  }
  
  /* ======================================================================
  ====================================================================== */
  public void setHeading(Vect2 v)
  {
    heading = v.unit_vector();
    //adjust_image();
  }
  
  /* ======================================================================
  ====================================================================== */
  public Vect2 getVeolociy()
  {
    return new Vect2(velocity);
  }
  
  /* ======================================================================
  ====================================================================== */
  public void setVelocity(double vx, double vy)
  {
    setVelocity(new Vect2(vx, vy));
  }
  
  /* ======================================================================
  ====================================================================== */
  public void setVelocity(Vect2 v)
  {
    //ensure that the velocity does not exceed the max
    if ( (max_velocity > 0) && (v.magnitude() > max_velocity) )
    {
        //keep the direction, change the magnitude
        velocity = v.unit_vector();
        velocity.scale(max_velocity);
    }
    else
    {
      velocity.i = v.i;
      velocity.j = v.j;
    }
  }

  /* ======================================================================
  ====================================================================== */
  public Vect2 getAcceleration()
  {
    return new Vect2(acceleration);
  }
  
  /* ======================================================================
  ====================================================================== */
  public void setAcceleration(Vect2 v)
  {
    acceleration.i = v.i;
    acceleration.j = v.j;
  }
  

  /* ======================================================================
  returns a string formatted representation of the actor
  ====================================================================== */
  public String format()
  {
      return String.format("loc= %s; vel= %s; accel= %s; heading= %s", 
          location.format(), velocity.format(), 
          acceleration.format(), heading.format());
  }
    
  /* ======================================================================
    function to update position of Actor; call once every game loop; 
    pass elapsed time since last call in ms
  ====================================================================== */
  public void updatePosition(double elapsed_ms)
  {
        //update the position of the object based on the time that has 
        //elapsed since the last call
        setVelocity(Vect2.add(velocity, Vect2.scale(acceleration, elapsed_ms)));
        setLocation(Vect2.add(location, Vect2.scale(velocity, elapsed_ms)));
  }
  
  
  /* ======================================================================
  ====================================================================== */
  public void Draw()
  {
    stroke(50, 100, 255);
    fill(50, 100, 255);
    ellipse((float)location.i, (float)location.j, 10, 10);
  }
  
  /* ======================================================================
  ====================================================================== */

  /* ======================================================================
  ====================================================================== */

  /* ======================================================================
  ====================================================================== */

  /* ======================================================================
  ====================================================================== */

}

/* ======================================================================
====================================================================== */

//----------  ----------
//----------  ----------
//----------  ----------