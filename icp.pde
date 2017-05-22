import org.gamecontrolplus.*;
import java.util.Map;
import java.util.Iterator;

/* ======================================================================
Constants & Globals
====================================================================== */
//---------- Game Controller ----------
ControlIO ioController;
ControlDevice gamePad;
Boolean bGameControllerPresent;

//---------- ICP Modes ----------
int icpMode;

public static final int MODE_SPLASH = 0;
public static final int MODE_EXPLORE = 1;
public static final int MODE_QUIT = 10;
public static final int TEXT_REGION_X = 1490;
  
//---------- Points of Interest Color IDs ----------
static public class POI_CLR_ID
{
  static long MOREHOUSE_DECK   = (long)(#808000);  // Morehouse Deck
  static long ABBY_ALDRICH     = (long)(#6666ff);  // Abby Aldrich Rockefeller Hall
  static long ACC              = (long)(#66ff66);  // Academic Computing Center
  static long MANLEY_CENTER    = (long)(#ff66ff);  // Albert E. Manley College Center
  static long SCIENCE_CENTER   = (long)(#cc66ff);  // Albro-Falconer-Manley Science Center
  static long BESSIE_STRONG    = (long)(#00ff00);  // Bessie Strong Hall
  static long BDT_SUITES       = (long)(#ffff66);  // Beverly Daniel Tatum Suites
  static long POST_OFFICE      = (long)(#ccff66);  // Bookstore/Post Office
  static long LLC1             = (long)(#ff0000);  // Donald and Isabel Stewart Living & Learning Center
  static long MANLEY_HALL      = (long)(#804000);  // Dorothy Shepard Manley Hall
  static long FMS              = (long)(#008080);  // Facilities Management & Services
  static long GILES            = (long)(#ff6fcf);  // Giles Hall
  static long HOWARD_HARRELD   = (long)(#008040);  // Howard-Harreld Hall
  static long FINE_ARTS        = (long)(#ff00ff);  // John D. Rockefeller Fine Arts Building
  static long LLC2             = (long)(#66ffcc);  // Johnnetta Betsch Cole Living & Learning Center
  static long LAURA_SPELMAN    = (long)(#ffff00);  // Laura Spelman Hall
  static long LLC2_AUDITORIUM  = (long)(#004080);  // LLC II Auditorium
  static long MACVICAR         = (long)(#0080ff);  // MacVicar Health Services
  static long MILIGAN          = (long)(#ff6666);  // Milligan Building
  static long MOREHOUSE_JAMES  = (long)(#80ff00);  // Morehouse-James Hall
  static long PACKARD          = (long)(#00ffff);  // Packard Hall
  static long READ             = (long)(#ff0080);  // Read Hall
  static long REYNOLDS_COTTAGE = (long)(#800080);  // Reynolds Cottage
  static long ROCKEFELLER      = (long)(#8000ff);  // Rockefeller Hall
  static long MCALPIN          = (long)(#66ccff);  // Sally Sage McAlpin Hall
  static long SISTERS_CHAPEL   = (long)(#408000);  // Sisters Chapel
  static long TAPLEY           = (long)(#ffcc66);  // Tapley Hall
  static long COSBY            = (long)(#00ff80);  // The Camille Olivia Hanks Cosby, Ed.D. Academic Center
  static long WEST_PARKING     = (long)(#ff8000);  // West Campus Parking Deck/ Public Safety
  static long FOUNTAIN         = (long)(#6648a3);  // Oval fountain
  static long ARCH             = (long)(#c8bfe7);  // Arch
  static long OVAL             = (long)(#008000);  // The Oval
  static long SPELMAN_LN       = (long)(#ffffbf);  // Spelman Ln
  static long GREENSFERRY_AVE  = (long)(#ff871c);  // Greensferry Ave
  static long WESTVIEW_DR      = (long)(#40ff00);  // Westview Dr
  static long LEE_ST           = (long)(#602224);  // Lee St
  static long WEST_END_AVE     = (long)(#534dc5);  // West End Ave
  static long CHAPEL_ST        = (long)(#ff82c4);  // Chapel St
  //static long WAR_GARDEN       = (long)();
  //static long PACKARD_GARDEN   = (long)();
}


//---------- Globals ----------
double frame_period_ms;  //draw() function refresh period in ms
Ic ic;    //the main 'Interactive Campus' object
double key_vx, key_vy;    //X and Y velocities based on keyboard input
Boolean bDisplayPixels = false;  //by default, we will display GIS coordinates, not pixels
PImage splashScreen;

/* ======================================================================
====================================================================== */
public void setup() 
{
  //must match ICP.SCREEN_WIDTH and ICP.SCREEN_HEIGHT
  size(1920, 1080);
  
  // Initialize the ControlIO
  ioController = ControlIO.getInstance(this);
      
  // Find the game pad device described in the configuration file
  bGameControllerPresent = true;  //assume a game controller is present
  gamePad = ioController.getMatchedDeviceSilent("icp_controller_config.txt");
  if (gamePad == null)
  {
    println("No suitable game controller found.");
    bGameControllerPresent = false;    //indicate that a controller is not present
    //System.exit(-1); // End the program NOW!
  }

  //---------- instantiate the ic object ----------
  ic = new Ic(width, height);
  
  //set ic images
  ic.setCampusSatelliteImage("SpelmanSatelliteImage_1920x1080.jpg");
  ic.setCampusPoiImage("CampusPoi_1920x1080.png");
  ic.setCampusKeepOutMap("CampusKeepoutMap_1920x1080.png");
    
  //set initial mode
  icpMode = MODE_SPLASH;
  
  frame_period_ms = 1000.0/frameRate;

  /* Add POIs to the Ic object */
  ic.addPoi(POI_CLR_ID.MOREHOUSE_DECK, "Morehouse Deck", "MOREHOUSE_DECK", null);
  ic.addPoi(POI_CLR_ID.ABBY_ALDRICH, "Abby Aldrich Rockefeller Hall", "ABBY_ALDRICH", null);
  ic.addPoi(POI_CLR_ID.ACC, "Academic Computing Center", "ACC", null);
  ic.addPoi(POI_CLR_ID.MANLEY_CENTER, "Albert E. Manley College Center", "MANLEY_CENTER", null);
  ic.addPoi(POI_CLR_ID.SCIENCE_CENTER, "Albro-Falconer-Manley Science Center", "SCIENCE_CENTER", null);
  ic.addPoi(POI_CLR_ID.BESSIE_STRONG, "Bessie Strong Hall", "BESSIE_STRONG", null);
  ic.addPoi(POI_CLR_ID.BDT_SUITES, "Beverly Daniel Tatum Suites", "BDT_SUITES", null);
  ic.addPoi(POI_CLR_ID.POST_OFFICE, "Bookstore & Post Office", "POST_OFFICE", null);
  ic.addPoi(POI_CLR_ID.LLC1, "Donald and Isabel Stewart Living & Learning Center", "LLC1", null);
  ic.addPoi(POI_CLR_ID.MANLEY_HALL, "Dorothy Shepard Manley Hall", "MANLEY_HALL", null);
  ic.addPoi(POI_CLR_ID.FMS, "Facilities Management & Services", "FMS", null);
  ic.addPoi(POI_CLR_ID.GILES, "Giles Hall", "GILES", null);
  ic.addPoi(POI_CLR_ID.HOWARD_HARRELD, "Howard-Harreld Hall", "HOWARD_HARRELD", null);
  ic.addPoi(POI_CLR_ID.FINE_ARTS, "John D. Rockefeller Fine Arts Building", "FINE_ARTS", null);
  ic.addPoi(POI_CLR_ID.LLC2, "Johnnetta Betsch Cole Living & Learning Center", "LLC2", null);
  ic.addPoi(POI_CLR_ID.LAURA_SPELMAN, "Laura Spelman Hall", "LAURA_SPELMAN", null);
  ic.addPoi(POI_CLR_ID.LLC2_AUDITORIUM, "LLC II Auditorium", "LLC2_AUDITORIUM", null);
  ic.addPoi(POI_CLR_ID.MACVICAR, "MacVicar Health Services", "MACVICAR", null);
  ic.addPoi(POI_CLR_ID.MILIGAN, "Milligan Building", "MILIGAN", null);
  ic.addPoi(POI_CLR_ID.MOREHOUSE_JAMES, "Morehouse-James Hall", "MOREHOUSE_JAMES", null);
  ic.addPoi(POI_CLR_ID.PACKARD, "Packard Hall", "PACKARD", null);
  ic.addPoi(POI_CLR_ID.READ, "Read Hall", "READ", null);
  ic.addPoi(POI_CLR_ID.REYNOLDS_COTTAGE, "Reynolds Cottage", "REYNOLDS_COTTAGE", null);
  ic.addPoi(POI_CLR_ID.ROCKEFELLER, "Rockefeller Hall", "ROCKEFELLER", null);
  ic.addPoi(POI_CLR_ID.MCALPIN, "Sally Sage McAlpin Hall", "MCALPIN", null);
  ic.addPoi(POI_CLR_ID.SISTERS_CHAPEL, "Sisters Chapel", "SISTERS_CHAPEL", null);
  ic.addPoi(POI_CLR_ID.TAPLEY, "Tapley Hall", "TAPLEY", null);
  ic.addPoi(POI_CLR_ID.COSBY, "The Camille Olivia Hanks Cosby, Ed.D. Academic Center", "COSBY", null);
  ic.addPoi(POI_CLR_ID.WEST_PARKING, "West Campus Parking Deck & Public Safety", "WEST_PARKING", null);
  ic.addPoi(POI_CLR_ID.FOUNTAIN, "Oval Fountain", "FOUNTAIN", new Vect2(993, 364));
  ic.addPoi(POI_CLR_ID.ARCH, "The Arch", "ARCH", new Vect2(1049,557));
  ic.addPoi(POI_CLR_ID.OVAL, "The Oval", "OVAL", null);
  ic.addPoi(POI_CLR_ID.SPELMAN_LN, "Spelman Lane SW", "SPELMAN_LN", null);
  ic.addPoi(POI_CLR_ID.GREENSFERRY_AVE, "Greensferry Avenue SW", "GREENSFERRY_AVE", null);
  ic.addPoi(POI_CLR_ID.WESTVIEW_DR, "Westview Drive SW", "WESTVIEW_DR", null);
  ic.addPoi(POI_CLR_ID.LEE_ST, "Lee Street SW", "LEE_ST", null);
  ic.addPoi(POI_CLR_ID.WEST_END_AVE, "West End Avenue SW", "WEST_END_AVE", null);
  ic.addPoi(POI_CLR_ID.CHAPEL_ST, "Chapel Street SW", "CHAPEL_ST", null);
  //ic.addPoi(POI_CLR_ID.WAR_GARDEN, "The War Garden", "WAR_GARDEN", null);
  //ic.addPoi(POI_CLR_ID.PACKARD_GARDEN, "Sarah Packard Memorial Garden", "PACKARD_GARDEN", null);
  
  key_vx = 0.0;
  key_vy = 0.0;
  
  splashScreen = loadImage("splash/icp_splash_1920x1080.png");
  //DoeLogo = loadImage();
  //BoeingLogo = loadImage();
}

/* ======================================================================
====================================================================== */
public void draw()
{
  double vx = 0.0;
  double vy = 0.0;
  Poi poi;
  
  //stroke(0, 96, 0);
  //strokeWeight(3);
  //fill(255);


  switch(icpMode)
  {
    case MODE_SPLASH:
      background(0, 0, 0);
      
      image(splashScreen, 0, 0);
      //to do: wait a few seconds then switch modes
      icpMode = MODE_EXPLORE;
      break;
      
    case MODE_EXPLORE:
      background(ic.getCampusSatelliteImage());
      ic.drawPoiMarkers();
      //image(highlight, 0, 0);

      if (bGameControllerPresent == true)
      {
        vx = 0.05 * gamePad.getSlider("LEFT_JOY_X").getValue();
        vy = 0.05 * gamePad.getSlider("LEFT_JOY_Y").getValue();
      }
      
      vx += key_vx;
      vy += key_vy;
      
      key_vx = 0.0;
      key_vy = 0.0;
      
      textSize(14);
      fill(220, 220, 220);
      if (bDisplayPixels == true)    //display coordinates in pixels
        text(ic.player.getLocation().format(), TEXT_REGION_X+10, 800, width-TEXT_REGION_X-1, height-800);  // Text wraps within text box
      else    //display GIS coordinates
      {
        GisCoord g = Gis.Pixel2Gis(ic.player.getLocation());
        text(g.longitude.toString() + ", " + g.latitude.toString(), TEXT_REGION_X+10, 800, width-TEXT_REGION_X-1, height-800);  // Text wraps within text box
      }
      
      //gamePad.getButton("BTN_1").pressed()
      //ellipse(x, y, 10, 10);
      ic.player.setVelocity(vx, vy);
      ic.player.updatePosition(frame_period_ms);
      ic.player.Draw();
      
      poi = ic.getNearbyPoi();
      if (poi != null)
      {
        textSize(24);
        fill(220, 220, 220);
        text(poi.name, TEXT_REGION_X+10, 10, width-TEXT_REGION_X-10, height -10);  // Text wraps within text box
        
        image(poi.img, TEXT_REGION_X + 10, 100, 400, 400);
        
        textSize(14);
        fill(220, 220, 220);
        text(poi.description, TEXT_REGION_X+10, 550, width-TEXT_REGION_X-10-10, height -560);  // Text wraps within text box
    }

      break;
  
    case MODE_QUIT:
      System.exit(0); // End the program NOW!
      break;
  }
}

/* ======================================================================

====================================================================== */
void drawPoiMarkers()
{
  Iterator it;
  Map pois = ic.getPoiMap();
  it = pois.entrySet().iterator();
  Poi poi;
  long colorKey;
  
  while (it.hasNext())
  {
      Map.Entry entry = (Map.Entry)it.next();
      colorKey = (long)entry.getKey();
      poi = (Poi)entry.getValue();
      
      if (poi.marker != null)
        println(colorKey, poi.marker.format());
      //System.out.println(entry.getKey() + " = " + entry.getValue());
      //it.remove(); // avoids a ConcurrentModificationException
  }

}

/* ======================================================================
====================================================================== */
void keyPressed()
{
  key_vx = 0.0;
  key_vy = 0.0;
  switch (key)
  {
    case CODED:
      if (keyCode == ESC)
        icpMode = MODE_QUIT;
      if (keyCode == UP)
        key_vy = -0.1;
      if (keyCode == DOWN)
        key_vy = +0.1;
      if (keyCode == LEFT)
        key_vx = -0.1;
      if (keyCode == RIGHT)
        key_vx = +0.1;       
      break;    //case CODED
    
    case 'g':  //display GIS coordinates
      bDisplayPixels = false;
      break;
      
    case 'p':  //display coordinates in pixels
      bDisplayPixels = true;
      break;
      
    case 'q':
    case 'Q':
      icpMode = MODE_QUIT;
      break;
      
    case 's':
      icpMode = MODE_SPLASH;
      break;
      
    case 'e':
      icpMode = MODE_EXPLORE;
      break;
      
    case 'f':    //toggle fly over
      ic.player.bFlyOver = !ic.player.bFlyOver;
      break;
    
    case 'x':
      drawPoiMarkers();
      break;
      
    default:
      break;
  }
}


/* ======================================================================
====================================================================== */



/* ======================================================================
====================================================================== */

//----------  ----------
//----------  ----------
//----------  ----------