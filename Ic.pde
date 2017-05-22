


public class Ic
{

  /* ======================================================================
  Class members
  ====================================================================== */  
  protected int screenWidth;
  protected int screenHeight;
  
  protected PImage campusSatelliteImage;
  protected PImage campusPoiImage;
  protected PImage campusKeepOutMap;

  public CampusExplorer player;

  protected Map POIs; // = new HashMap();
  
  public final color BLACK = color(0, 0, 0);
  private color DEFAULT_BACKGROND_COLOR = BLACK;
   
    
  /* ======================================================================
  Constructors
  ====================================================================== */
  //---------- constructor ----------
  Ic(int screenWidth, int screenHeight)
  {
    this.screenWidth = screenWidth;
    this.screenHeight = screenHeight;
    
    //create the player
    player = new CampusExplorer();
    player.setBorders(0, 0, 1490, height);
    player.setBorderPolicies(Actor.BORDER_POLICY_CLIP, 
          Actor.BORDER_POLICY_CLIP, 
          Actor.BORDER_POLICY_CLIP, 
          Actor.BORDER_POLICY_CLIP);
          
    POIs = new HashMap();        
  }
 
  /* ======================================================================
  ====================================================================== */
  public void setCampusSatelliteImage(String imageFileName)
  {
    campusSatelliteImage = loadImage(imageFileName);
  }
  
  /* ======================================================================
  ====================================================================== */
  public PImage getCampusSatelliteImage()
  {
    return campusSatelliteImage;
  }
  
  /* ======================================================================
  ====================================================================== */
  public void setCampusPoiImage(String imageFileName)
  {
    campusPoiImage = loadImage(imageFileName);
    player.setPoiMap(campusPoiImage, DEFAULT_BACKGROND_COLOR);
  }
  
  /* ======================================================================
  ====================================================================== */
  public PImage getCampusPoiImage()
  {
    return campusPoiImage;
  }
  
  /* ======================================================================
  ====================================================================== */
  public void setCampusKeepOutMap(String imageFileName)
  {
    campusKeepOutMap = loadImage(imageFileName);
    player.setKeepOutMap(campusKeepOutMap, DEFAULT_BACKGROND_COLOR);
  }
  
  /* ======================================================================
  ====================================================================== */
  public PImage getCampusKeepOutMap()
  {
    return campusKeepOutMap;
  }
  
  /* ======================================================================
  For each POI, create a Poi object.  Add this object to the POIs 
  dictionary using the poi's ID as the key and a reference to the Poi 
  object itself as the value.  Using this arrangement, we can get a 
  reference to a POI by simply looking it up by ID# in the dictionary.
  ====================================================================== */
  public void addPoi(long colorID, String name, String baseFileName)
  {
    POIs.put(colorID, new Poi(colorID, name, baseFileName, null));
  }
  
  /* ======================================================================
  ====================================================================== */
  public void createPoi(long colorID, String name, String baseFileName, Vect2 marker)
  {
    //campusPoiImage
    drawCircleOnImage(campusPoiImage, (int)marker.i, (int)marker.j, 10, (color)colorID);
    POIs.put(colorID, new Poi(colorID, name, baseFileName, marker));
  }
  

  /* ======================================================================
  Function that returns a Poi given its colorID
  ====================================================================== */
  public Poi getPoi(long colorID)
  {
    return (Poi)POIs.get(colorID);
  }


  /* ======================================================================
  ====================================================================== */
  public Map getPoiMap()
  {
    return POIs;
  }

  /* ======================================================================
  Function that returns a Poi corresponding to the player's position.
  ====================================================================== */
  protected Poi getNearbyPoi()
  {
    long x = player.getNearbyBuilding();
    if (x != DEFAULT_BACKGROND_COLOR)
    {      
      return getPoi(x);
    }
      
    return null;
  }

  /* ======================================================================
  Function that draws markers for POIs with specified coordinates.
  ====================================================================== */
  public void drawPoiMarkers()
  {
    Iterator it = POIs.entrySet().iterator();
    Poi poi;
    //long colorKey;
    
    while (it.hasNext())
    {
        Map.Entry entry = (Map.Entry)it.next();
        //colorKey = (long)entry.getKey();
        poi = (Poi)entry.getValue();
        
        if (poi.marker != null)
        {
//        println(colorKey, poi.marker.format());
          stroke(255, 255, 0, 80);
          strokeWeight(4);
          //fill(255, 255, 0);
          noFill();
          ellipse((float)poi.marker.i, (float)poi.marker.j, 10, 10);
          //stroke(0, 0, 0);
          //fill(0, 0, 0);
          //ellipse((float)poi.marker.i, (float)poi.marker.j, 4, 4);
        }
    }
  }

  /* ======================================================================
  ====================================================================== */
  protected void drawCircleOnImage(PImage img, int x, int y, int radius, color clr)
  {
    float distance2;
    for(int j=y-radius; j<y+radius; j++)
      for(int i=x-radius; i<x+radius; i++)
      {
        distance2 = (i-x)*(i-x) + (j-y)*(j-y);
        if(distance2 < radius * radius)
        {
          int index = j*img.width+i;
          if (index < 0) index = 0;
          img.pixels[index] = clr;
        }
      }
  }
  
}




/* ======================================================================
====================================================================== */