


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
  void setCampusSatelliteImage(String imageFileName)
  {
    campusSatelliteImage = loadImage(imageFileName);
  }
  
  /* ======================================================================
  ====================================================================== */
  PImage getCampusSatelliteImage()
  {
    return campusSatelliteImage;
  }
  
  /* ======================================================================
  ====================================================================== */
  void setCampusPoiImage(String imageFileName)
  {
    campusPoiImage = loadImage(imageFileName);
    player.setPoiMap(campusPoiImage, DEFAULT_BACKGROND_COLOR);
  }
  
  /* ======================================================================
  ====================================================================== */
  void setCampusKeepOutMap(String imageFileName)
  {
    campusKeepOutMap = loadImage(imageFileName);
    player.setKeepOutMap(campusKeepOutMap, DEFAULT_BACKGROND_COLOR);
  }
  
  /* ======================================================================
  For each POI, create a Poi object.  Add this object to the POIs 
  dictionary using the poi's ID as the key and a reference to the Poi 
  object itself as the value.  Using this arrangement, we can get a 
  reference to a POI by simply looking it up by ID# in the dictionary.
  ====================================================================== */
  void addPoi(long colorID, String name, String description, Vect2 marker)
  {
    POIs.put(colorID, new Poi(colorID, name, description, marker));
  }
  
  /* ======================================================================
  Function that returns a Poi given its colorID
  ====================================================================== */
  Poi getPoi(long colorID)
  {
    return (Poi)POIs.get(colorID);
  }


  /* ======================================================================
  ====================================================================== */
  Map getPoiMap()
  {
    return POIs;
  }

  /* ======================================================================
  Function that returns a Poi corresponding to the player's position.
  ====================================================================== */
  Poi getNearbyPoi()
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
  void drawPoiMarkers()
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

}




/* ======================================================================
====================================================================== */