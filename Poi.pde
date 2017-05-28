
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class Poi
{
  /* ======================================================================
  Class members
  ====================================================================== */
  protected long id;
  protected String name;
  //protected String baseFileName;  //used to form the description image file names by appending ".txt" and ."jpg"
  protected String description;
  protected PImage img;
  protected String desc_filename;
  protected String img_filename;
  public Vect2 marker;
  //List <Vect2> poiMarkers; // = new ArrayList Vect2();

  /* ======================================================================
  Constructors
  baseFileName is used to form the description image file names by appending ".TXT" and ."JPG"
  ====================================================================== */
  //---------- constructor ----------
  Poi(long id, String name, String baseFileName, Vect2 marker)
  {
    this.id = id;
    this.name = name;
    description = "";
    img = null;
    desc_filename =  sketchPath("") + "data/poi/" + baseFileName + ".TXT";
    img_filename =  sketchPath("") + "data/poi/" + baseFileName + ".JPG";
    
    try
    {
      description = new String(Files.readAllBytes(Paths.get(desc_filename)));
      //println(desc_filename);
    }
    catch(IOException e) 
    {
      println(e);
    }
    
    img = loadImage(img_filename);
    img.resize(400, 0);
    
    this.marker = marker;
    //poiMarkers = new ArrayList <Vect2>();
  }
  
  /* ======================================================================
  ====================================================================== */
  long getId()
  {
    return id;
  }
  
  /* ======================================================================
  ====================================================================== */
  String getName()
  {
    return name;
  }
  
  /* ======================================================================
  ====================================================================== */
  void setDescription(String desc)
  {
    description = desc;
  }
  
  /* ======================================================================
  ====================================================================== */
  String getDescription()
  {
    return description;
  }
  
  /* ======================================================================
  ====================================================================== */
  void setImage(PImage img)
  {
    this.img = img;
  }
  
  /* ======================================================================
  ====================================================================== */
  PImage getImage()
  {
    return img;
  }
  
}