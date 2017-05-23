
public class CampusExplorer extends Actor
{
  /* ======================================================================
  Class members
  ====================================================================== */
  PImage keepOutMap;
  color keepOutBackColor;
  PImage poiMap;
  color buildingMapBackColor;
  Boolean bFlyOver;    //allows the user to "fly over" buildings
  
  /* ======================================================================
  Constructors
  ====================================================================== */
  //---------- default constructor ----------
  public CampusExplorer()
  {
    bFlyOver = false;
  }

  /* ======================================================================
  ====================================================================== */
  public void setPoiMap(PImage img, color backgroundColor)
  {
    poiMap = img;
    buildingMapBackColor = backgroundColor;
  }

  /* ======================================================================
  ====================================================================== */
  public void setKeepOutMap(PImage img, color backgroundColor)
  {
    keepOutMap = img;
    keepOutBackColor = backgroundColor;
  }
  
  /* ======================================================================
    function to update position of Actor; call once every game loop; 
    pass elapsed time since last call in ms
  ====================================================================== */
  public void updatePosition(double elapsed_ms)
  {
    //store the current location
    Vect2 oldLocation = getLocation();

    //update the position of the object based on the time that has 
    //elapsed since the last call
    super.updatePosition(elapsed_ms);

    //if we are in the keepout region, restore our old location
    if (inKeepOutRegion() == true)
      {
        setLocation(oldLocation);
        
        //avoid being trapped inside a keepout region after disabling
        //flyover here
        while(inKeepOutRegion() == true)
        {
          oldLocation.i++;
          setLocation(oldLocation);
        }
      }
      
  }


  /* ======================================================================
  ====================================================================== */
  public Boolean inKeepOutRegion()
  {
    if (bFlyOver == true) return false;
    
    if(keepOutMap.pixels[(int)location.j*keepOutMap.width+(int)location.i] == keepOutBackColor)
      return false;
    
    return true;
  }

  /* ======================================================================
  ====================================================================== */
  public color getNearbyBuilding()
  {
    return poiMap.pixels[(int)location.j*keepOutMap.width+(int)location.i];

  }
}