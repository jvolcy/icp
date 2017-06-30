import org.gamecontrolplus.*;
//import java.util.Map;
import java.util.Iterator;

/* ======================================================================
Constants & Globals
====================================================================== */
//---------- Credits ----------
final String credits =   "Thulani A. Vereen '20, 3D Campus Modeling & Fabrication\n"
                       + "Lauren-Jenay Kelley '18, ICP Software/Layered Maps\n"
                       + "Cierra L. Lewis '17, ICP Mobile App/GIS Mapping\n"
                       + "Jerry Volcy, Advisor";
 
//---------- Game Controller ----------
ControlIO ioController;
ControlDevice gamePad;
/* if a gamecontroller is not present, we can operate the icp with the keyboard. */
Boolean bGameControllerPresent;  //set to true if we find a game controller

//---------- ICP Modes ----------
//the made draw() function operates as a state machine.  The variable icpMode
//is the state variable.
int icpMode;

//possible values for icpMode defined below
public static final int MODE_SPLASH = 0;
public static final int MODE_EXPLORE = 1;
public static final int MODE_HELP = 2;
public static final int MODE_QUIT = 10;
public static final int MODE_REGISTRATION = 11;

//---------- Information Panel Constants ----------
public static final int TEXT_REGION_X = 1490;
public static final int GIS_TEXT_X_LOCATION = 1500;
  
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
  static long OVAL             = (long)(#008000);  // The Oval
  static long SPELMAN_LN       = (long)(#ffffbf);  // Spelman Ln
  static long GREENSFERRY_AVE  = (long)(#ff871c);  // Greensferry Ave
  static long WESTVIEW_DR      = (long)(#40ff00);  // Westview Dr
  static long LEE_ST           = (long)(#602224);  // Lee St
  static long WEST_END_AVE     = (long)(#534dc5);  // West End Ave
  static long CHAPEL_ST        = (long)(#ff82c4);  // Chapel St
  static long TENNIS_COURTS    = (long)(#6400a6);  // Tennis Courts
  static long NEW_OVAL         = (long)(#ffb800);  // The New Oval
  static long AMPHITHEATER     = (long)(#644b0f);  // Amphitheater
  static long PARK             = (long)(#442525);  // The Park!!!
}


//---------- Globals ----------
double frame_period_ms;  //draw() function refresh period in ms
Ic ic;    //the main 'Interactive Campus' object
double key_vx, key_vy;    //X and Y velocities based on keyboard input
Boolean bDisplayPixels = false;  //by default, we will display GIS coordinates, not pixels
PImage splashScreen;    //splash screen
PImage icpHelpScreen;  //help screen
PImage architectureDrawing;  //architectural drawing
static int IDLE_SECONDS = 300;    //5 minutes
int idleCounter;    //a counter to check how long the system has been idle (in this case, idle is defined as the joystick not moving)

//---------- selected_background_image ----------
//In explorer mode, we can choose between a number of background images.  These are identified through the following constants
final int BKGND_SATELLITE = 0;
final int BKGND_POI = 1;
final int BKGND_KEEPOUT = 2;
final int BKGND_ARCHITECTURE = 3;

//define an integer to specify the current background image
int SelectedBackgroundImage = BKGND_SATELLITE;    //by default, use satellite view

//---------- Help String ----------
/* The keyboard help is displayed in two columns.  Correspondingly, there are two help strings. */
//help1 letters: A, C, E, G, I, K, M, O, Q, S, U, W, Y
final String icpKeyboardHelpLeft = "E – Explorer Mode\n"
                              +"G – Display GIS Coords\n"
                              +"M – Toggle Display Maps\n"
                              +"Q - Quit\n"
                              +"S – Display Splash Screen\n"
                              ;

//help2 letters: B, D, F, H, J, L, N, P, R, T, V, X, Z
final String icpKeyboardHelpRight = "F – Toggle Flyover\n"
                              +"H - Help\n"
                              +"P – Display XY Coords in Pixels\n"
                              +"R - Registration Pattern\n"
                              ;

//define the help string for the gamepad
final String icpGamepadHelp = " 1 - Satellite View\n"
                               +" 2 - Architectural Map\n"
                               +" 3 - Keepout Map\n"
                               +" 4 - POI Map\n"
                               +" 5 - Not Used\n"
                               +" 6 - Accelerate\n"
                               +" 7 - Not Used\n"
                               +" 8 - Flyover\n"
                               +" 9 - Help Screen\n"
                               +"10 - Help Screen\n"
                               +"11 - Not Used\n"
                               +"12 - Not Used\n"
                               +"13 - Main Explorer Control\n"
                               +"14 - Not Used\n";
                               
                               
/* ======================================================================
====================================================================== */
public void setup() 
{
  //must match ICP.SCREEN_WIDTH and ICP.SCREEN_HEIGHT
  fullScreen();
  
  //size(1920, 1080);

  //display the splash screen while we do initializations
  background(0, 0, 0);
  splashScreen = loadImage("icp_splash_1920x1080.png");
  image(splashScreen, 0, 0);
  idleCounter = 0;

  // Initialize the ControlIO
  ioController = ControlIO.getInstance(this);
      
  // Find the game pad device described in the configuration file
  bGameControllerPresent = true;  //assume a game controller is present
  gamePad = ioController.getMatchedDeviceSilent("icp_controller_config.txt");
  if (gamePad == null)
  {
    println("No suitable game controller found.");
    bGameControllerPresent = false;    //indicate that a controller is not present
  }

  //---------- instantiate the ic object ----------
  ic = new Ic(width, height);
  
  //set ic images
  ic.setCampusSatelliteImage("SpelmanSatelliteImage_1920x1080.jpg");
  ic.setCampusPoiImage("CampusPoi_1920x1080.png");
  ic.setCampusKeepOutMap("CampusKeepoutMap_1920x1080.png");
    
  //set initial mode
  icpMode = MODE_SPLASH;
  
  //calculate the frame period in milliseconds.  This is the amount of time
  //between automatic calls to the draw() function
  frame_period_ms = 1000.0/frameRate;

  /* Add POIs to the Ic object */
  ic.addPoi(POI_CLR_ID.MOREHOUSE_DECK, "Morehouse Deck", "MOREHOUSE_DECK");
  ic.addPoi(POI_CLR_ID.ABBY_ALDRICH, "Abby Aldrich Rockefeller Hall", "ABBY_ALDRICH");
  ic.addPoi(POI_CLR_ID.ACC, "Academic Computing Center", "ACC");
  ic.addPoi(POI_CLR_ID.MANLEY_CENTER, "Albert E. Manley College Center", "MANLEY_CENTER");
  ic.addPoi(POI_CLR_ID.SCIENCE_CENTER, "Albro-Falconer-Manley Science Center", "SCIENCE_CENTER");
  ic.addPoi(POI_CLR_ID.BESSIE_STRONG, "Bessie Strong Hall", "BESSIE_STRONG");
  ic.addPoi(POI_CLR_ID.BDT_SUITES, "Beverly Daniel Tatum Suites", "BDT_SUITES");
  ic.addPoi(POI_CLR_ID.POST_OFFICE, "Bookstore & Post Office", "POST_OFFICE");
  ic.addPoi(POI_CLR_ID.LLC1, "Donald and Isabel Stewart Living & Learning Center", "LLC1");
  ic.addPoi(POI_CLR_ID.MANLEY_HALL, "Dorothy Shepard Manley Hall", "MANLEY_HALL");
  ic.addPoi(POI_CLR_ID.FMS, "Facilities Management & Services", "FMS");
  ic.addPoi(POI_CLR_ID.GILES, "Giles Hall", "GILES");
  ic.addPoi(POI_CLR_ID.HOWARD_HARRELD, "Howard-Harreld Hall", "HOWARD_HARRELD");
  ic.addPoi(POI_CLR_ID.FINE_ARTS, "John D. Rockefeller Fine Arts Building", "FINE_ARTS");
  ic.addPoi(POI_CLR_ID.LLC2, "Johnnetta Betsch Cole Living & Learning Center", "LLC2");
  ic.addPoi(POI_CLR_ID.LAURA_SPELMAN, "Laura Spelman Hall", "LAURA_SPELMAN");
  ic.addPoi(POI_CLR_ID.LLC2_AUDITORIUM, "LLC II Auditorium", "LLC2_AUDITORIUM");
  ic.addPoi(POI_CLR_ID.MACVICAR, "MacVicar Health Services", "MACVICAR");
  ic.addPoi(POI_CLR_ID.MILIGAN, "Milligan Building", "MILIGAN");
  ic.addPoi(POI_CLR_ID.MOREHOUSE_JAMES, "Morehouse-James Hall", "MOREHOUSE_JAMES");
  ic.addPoi(POI_CLR_ID.PACKARD, "Packard Hall", "PACKARD");
  ic.addPoi(POI_CLR_ID.READ, "Read Hall", "READ");
  ic.addPoi(POI_CLR_ID.REYNOLDS_COTTAGE, "Reynolds Cottage", "REYNOLDS_COTTAGE");
  ic.addPoi(POI_CLR_ID.ROCKEFELLER, "Rockefeller Hall", "ROCKEFELLER");
  ic.addPoi(POI_CLR_ID.MCALPIN, "Sally Sage McAlpin Hall", "MCALPIN");
  ic.addPoi(POI_CLR_ID.SISTERS_CHAPEL, "Sisters Chapel", "SISTERS_CHAPEL");
  ic.addPoi(POI_CLR_ID.TAPLEY, "Tapley Hall", "TAPLEY");
  ic.addPoi(POI_CLR_ID.COSBY, "The Camille Olivia Hanks Cosby, Ed.D. Academic Center", "COSBY");
  ic.addPoi(POI_CLR_ID.WEST_PARKING, "West Campus Parking Deck & Public Safety", "WEST_PARKING");
  ic.addPoi(POI_CLR_ID.OVAL, "The Oval", "OVAL");
  ic.addPoi(POI_CLR_ID.SPELMAN_LN, "Spelman Lane SW", "SPELMAN_LN");
  ic.addPoi(POI_CLR_ID.GREENSFERRY_AVE, "Greensferry Avenue SW", "GREENSFERRY_AVE");
  ic.addPoi(POI_CLR_ID.WESTVIEW_DR, "Westview Drive SW", "WESTVIEW_DR");
  ic.addPoi(POI_CLR_ID.LEE_ST, "Lee Street SW", "LEE_ST");
  ic.addPoi(POI_CLR_ID.WEST_END_AVE, "West End Avenue SW", "WEST_END_AVE");
  ic.addPoi(POI_CLR_ID.CHAPEL_ST, "Chapel Street SW", "CHAPEL_ST");
  ic.addPoi(POI_CLR_ID.TENNIS_COURTS, "Tennis Courts", "POIXXX");
  ic.addPoi(POI_CLR_ID.NEW_OVAL, "The New Oval", "POIXXX");
  ic.addPoi(POI_CLR_ID.AMPHITHEATER, "Amphitheater", "POIXXX");
  ic.addPoi(POI_CLR_ID.PARK, "The Park!!!", "POIXXX");

  //add user-specified point POIs
  ic.processPoiFile(sketchPath("") + "data/poi/poi.txt");
        
  //initialize keyboard velocities to 0
  key_vx = 0.0;
  key_vy = 0.0;
  
  //load static background images for later use
  architectureDrawing = loadImage("architecture_map_1920x1080.png");
  icpHelpScreen = loadImage("icp_help.png");
  

}

/* ======================================================================
Function to convert a long to a color object
====================================================================== */
color long2Color(long clr_long)
{
  long r = (clr_long >> 16) & 0xff;  // red
  long g = (clr_long >> 8) & 0xff;   // green
  long b = clr_long & 0xff;          // blue
  return color(r, g, b);
}

/* ======================================================================
====================================================================== */
public void draw()
{
  double vx = 0.0;
  double vy = 0.0;
  Poi poi;
  
  switch(icpMode)
  {
    case MODE_SPLASH:
      //display the splash screen against a black background
      background(0, 0, 0);
      image(splashScreen, 0, 0);
    
      //add text in white
      fill(255, 255, 255);
      textSize(36);
      text("Interactive Campus Project", 20, 50);
      textSize(18);
      text(credits, 20, 70, 1000, 1800);  // Text wraps within text box
      textSize(30);
      text("Spelman Innovation Lab", 565, 1010);

      //wait for left joystick to be moved to begin
      if ((bGameControllerPresent == true) && (gamePad.getSlider("LEFT_JOY_Y").getValue() != 0))
        icpMode = MODE_EXPLORE;
      
      //reset the idle counter while in splash mode
      idleCounter = (int)(IDLE_SECONDS * frameRate);
      
      break;
      
    case MODE_EXPLORE:
      //this is the main operating mode
      switch (SelectedBackgroundImage)
      {
        case 0:
          background(ic.getCampusSatelliteImage());
          ic.drawPoiMarkers();
          break;
        case 1:
          background(ic.getCampusPoiImage());
          break;
        case 2:
          background(ic.getCampusKeepOutMap());
          break;
        case 3:
          background(architectureDrawing);
          break;
        default:
          SelectedBackgroundImage = 0;
      }


      if (bGameControllerPresent == true)
      {
        //read the joystick
        vx = 0.02 * gamePad.getSlider("LEFT_JOY_X").getValue();
        vy = 0.02 * gamePad.getSlider("LEFT_JOY_Y").getValue();
        
        //reset the idle counter if the joystick was moved
        if (vy != 0)    //still active; reset the idle counter
          idleCounter = (int)(IDLE_SECONDS * frameRate);

        //check button 6 (accelerate):  increase speed by 5 if pressed
        if (gamePad.getButton("BTN_6").pressed())
        {  
          vx *= 5;
          vy *= 5;
        }
        
        //check button 1 (change to satellite background image)
        if (gamePad.getButton("BTN_1").pressed())
        {  
          SelectedBackgroundImage = BKGND_SATELLITE;
        }
        
        //check button 2 (change to POI map backgroiund image)
        if (gamePad.getButton("BTN_2").pressed())
        {  
          SelectedBackgroundImage = BKGND_POI;
        }
        
        //check button 3 (change to keepout map background image)
        if (gamePad.getButton("BTN_3").pressed())
        {  
          SelectedBackgroundImage = BKGND_KEEPOUT;
        }
        
        //check button 4 (change to architectural background image)
        if (gamePad.getButton("BTN_4").pressed())
        {  
          SelectedBackgroundImage = BKGND_ARCHITECTURE;
        }
        
        //check button 8 (flyover)
        ic.player.bFlyOver = gamePad.getButton("BTN_8").pressed();
        
        //check button 9; if pressed, switch to help mode
        if (gamePad.getButton("BTN_9").pressed())
        {
          icpMode = MODE_HELP;
        }
        
        //check button 10; if pressed, switch to help mode
        if (gamePad.getButton("BTN_10").pressed())
        {
          icpMode = MODE_HELP;
        }
        
      }
      
      //add any keyboard component to velocity that may exist
      vx += key_vx;
      vy += key_vy;
      
      //reset keyboard velocity values
      key_vx = 0.0;
      key_vy = 0.0;
      
      //display the pixel or GIS coordinates
      textSize(12);  //small text
      fill(155, 155, 155);  //text will be shade of light gray
      if (bDisplayPixels == true)    //display coordinates in pixels
        text(ic.player.getLocation().format(), GIS_TEXT_X_LOCATION+10, height-20, width-GIS_TEXT_X_LOCATION, 20);  // Text wraps within text box
      else    //display GIS coordinates
      {
        GisCoord g = Gis.Pixel2Gis(ic.player.getLocation());
        text(String.format("%.6f", g.latitude) + ", " + String.format("%.6f", g.longitude), GIS_TEXT_X_LOCATION+10, height-20, width-GIS_TEXT_X_LOCATION, 20);  // Text wraps within text box
      }

      //move and re-draw the explorer
      ic.player.setVelocity(vx, vy);
      ic.player.updatePosition(frame_period_ms);
      ic.player.Draw();
      
      //check to see if we are in proximity of one of the POIs
      //Note the getNearbyPoi() function returns null if we are not near a POI.
      //Otherwise, the function returns a POI object
      poi = ic.getNearbyPoi();
      if (poi != null)
      {
        //update the name of the POI on the righthand panel
        textSize(24);
        fill(220, 220, 220);
        text(poi.name, TEXT_REGION_X+10, 10, width-TEXT_REGION_X-10, height -10);  // Text wraps within text box
        
        //update the image for the POI on the righthand panel
        image(poi.img, TEXT_REGION_X + 10, 100, 400, 400);
        
        //update the description of the POI on the righthand pane
        textSize(14);
        fill(220, 220, 220);
        text(poi.description, TEXT_REGION_X+10, 550, width-TEXT_REGION_X-10-10, height-550-30);  // Text wraps within text box
      }

      //after 5 minutes of idle time, return to the splash screen
      idleCounter--;
      if (idleCounter <= 0)
        icpMode = MODE_SPLASH;
        
      break;
  
    case MODE_HELP:
      background(0, 0, 0);    //black background
      image(icpHelpScreen, 0, 0);  //background image for help screen
      
      fill(255, 255, 255);  //white letters
      textSize(18);
      text("Spelman Innovation Lab", 300, 275);
      
      //display gamepad controller help text
      textSize(24);
      text(icpGamepadHelp, 1400, 50, 500, 600);
      
      //print the 2 help columns
      fill(200, 170, 0);  //shade of yellow
      text(icpKeyboardHelpLeft, 50, 800, 400, 200);  // Text wraps within text box
      text(icpKeyboardHelpRight, 450, 800, 400, 200);  // Text wraps within text box
      
      //after 5 minutes of idle time, return to the splash screen
      idleCounter--;
      if (idleCounter <= 0)
        icpMode = MODE_SPLASH;

      break;
      
    case MODE_QUIT:
      System.exit(0); // End the program NOW!
      break;
      
    case MODE_REGISTRATION:
      //display the projector alignment pattern
      //The pattern is a 40" x 30" rectangle
      final float registrationInchesWidth = 40.0;
      final float registrationInchesHeight = 23.0;
      final int registrationPixelWidth = 1744;    //pixels corresponding to 40" horizontally
      final int registrationPixelHeight = 1004;    //pixels corresponding to 23" vertically
      int registrationX = (width - registrationPixelWidth) / 2;
      int registrationY = (height - registrationPixelHeight) / 2;
      
      background(0, 0, 0);  //black backgroiund
      stroke(255, 255, 255);  //white lines
      strokeWeight(1);
      fill(0, 0, 0);
      rect(registrationX, registrationY, registrationPixelWidth, registrationPixelHeight);
      line(width/2 - 200, height/2, width/2 + 200, height/2);
      line(width/2, height/2 - 200, width/2, height/2 + 200);
      
      fill(255, 255, 255);
      textSize(30);
      text(String.format("%.2f", registrationInchesWidth) + "\" x " + String.format("%.2f\"", registrationInchesHeight), 1200, 900);
      
    
      break;
  }
}


/* ======================================================================
Built-in keyboard Processing callback function for keyboard key presses.
====================================================================== */
void keyPressed()
{
  key_vx = 0.0;    //x-velocity from pressing left and right arrow keys
  key_vy = 0.0;    //y-velocity from pressing up and down arrow keys
  switch (key)
  {
    case CODED:    //coded keys
      if (keyCode == ESC)    //quit
        icpMode = MODE_QUIT;
      if (keyCode == UP)      //move explorer up (decrease vy)
        key_vy = -0.1;
      if (keyCode == DOWN)    //move explorer down (increase vy)
        key_vy = +0.1;
      if (keyCode == LEFT)    //move explorer left (decrease vx)
        key_vx = -0.1;
      if (keyCode == RIGHT)   //move explorer right (increase vx)
        key_vx = +0.1;       
      break;    //case CODED
    
    case 'g':  //display GIS coordinates; use 'P' to display pixels
      bDisplayPixels = false;
      break;
      
    case 'p':  //display coordinates in pixels; use 'G' to display GIS coordinates
      bDisplayPixels = true;
      break;
      
    case 'q':  //quit
    case 'Q':
      icpMode = MODE_QUIT;
      break;
    
    case 'r':    //display projector registration pattern
      icpMode = MODE_REGISTRATION;
      break;
      
    case 's':    //display the splash screen
      icpMode = MODE_SPLASH;
      break;
      
    case 'e':    //enter campus exploring mode
      icpMode = MODE_EXPLORE;
      break;
      
    case 'f':    //toggle fly over
      ic.player.bFlyOver = !ic.player.bFlyOver;
      break;
      
    case 'h':    //help
      icpMode = MODE_HELP;
      break;
    
    case 'm':    //toggle background
      SelectedBackgroundImage++;
      if (SelectedBackgroundImage > 3) SelectedBackgroundImage = 0;  //wrap
      break;
      
    case 'x':
      //PImage img = ic.getCampusKeepOutMap();
      //ic.createPoi(color(255,0,0), "POIxxx", "ACC", new Vect2(1000,500));
        /*
      for (int i=0; i < 500; i++)
        img.pixels[10*1920+i] = color(255, 255, 0);
        img.ellipse(100, 100, 10, 10);
        */
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