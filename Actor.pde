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
  set the bounds of the allowable position for the actor
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
  Function to set the 4 border policies.
  The border policy specifies what happes to the actor when it reaches
  one of the border.  Allowable policies include
  Actor.BORDER_POLICY_NONE --> no policy at the screen border
  Actor.BORDER_POLICY_WRAP --> wrap around to the other side of the screen
  Actor.BORDER_POLICY_CLIP --> do not go outside the borders of the screen 
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
  getLocation() returns the actor's location as a Vect2 object
  ====================================================================== */
  public Vect2 getLocation()
  {
    return new Vect2(location);
  }
  
  /* ======================================================================
  setLocation() sets the actor's location from a Vect2 object.
  The function is respectful of the border policy and behaves according
  to the border policy in place when invoked.
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
  getHeading() returns the heading of the actor.  This is useful mostly
  when we have a non-zero acceleration.  The function returns a Vect2
  (unit vector) ojbect.
  ====================================================================== */
  public Vect2 getHeading()
  {
    return new Vect2(heading);
  }
  
  /* ======================================================================
  setHeading() sets the actor's heading.  The function expects a Vect2
  object.
  ====================================================================== */
  public void setHeading(Vect2 v)
  {
    heading = v.unit_vector();
    //adjust_image();
  }
  
  /* ======================================================================
  getVelocity() - returns the actors velocity as a Vect2 object
  ====================================================================== */
  public Vect2 getVeolociy()
  {
    return new Vect2(velocity);
  }
  
  /* ======================================================================
  setVelocity() sets the actor's velocity from an X (vx) and Y (vy)
  component pair.
  ====================================================================== */
  public void setVelocity(double vx, double vy)
  {
    setVelocity(new Vect2(vx, vy));
  }
  
  /* ======================================================================
  setVelocity() sets the actor's velocity from a Vect2 object
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
  getAcceleration() returns the actor's acceleration vector as a Vect2
  object
  ====================================================================== */
  public Vect2 getAcceleration()
  {
    return new Vect2(acceleration);
  }
  
  /* ======================================================================
  setAcceleratin() sets the actor's acceleration vector from a Vect2
  object
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
  The Draw() function causes the actor to draw itself onto the screen at
  its current x and y location.
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