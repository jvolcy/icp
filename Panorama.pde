public class Panorama
{

  /* ======================================================================
  Class members
  ====================================================================== */  
  protected PImage panorama;
  protected PImage rightImage;
  protected int refPixel;
  protected float refAngle;
      
  /* ======================================================================
  Constructor - accepts a PImage object from which to build the panorama
  ====================================================================== */
  //---------- constructors ----------
  Panorama(PImage rawImage, int leftCrop, int rightCrop, int topCrop, int bottomCrop)
  {
    init(rawImage, leftCrop, rightCrop, topCrop, bottomCrop);
  }

   /* ======================================================================
   Constructor - accepts a filename that references the image file from
   which to build the panorama
  ====================================================================== */
  Panorama(String imgFileName, int leftCrop, int rightCrop, int topCrop, int bottomCrop)
  {
    PImage img = loadImage(imgFileName);
    init(img, leftCrop, rightCrop, topCrop, bottomCrop);
  }

   /* ======================================================================
   private function to initialize the Panorama object.  This function
   is called by the constructors and exists simply to allow multiple
   constructors to share a common initialization procedure.
  ====================================================================== */
  private void init(PImage rawImage, int leftCrop, int rightCrop, int topCrop, int bottomCrop)
  {
    this.refPixel = 0;
    this.refAngle = 0.0;
        
    int imageWidth = rawImage.width - leftCrop - rightCrop;
    int imageHeight = rawImage.height - bottomCrop - topCrop;
    
    panorama = rawImage.get(leftCrop, topCrop, imageWidth, imageHeight);
    rightImage = panorama.get(0, 0, width, panorama.height);
    
  }
  
   /* ======================================================================
   Reference angle is measured with 0 degrees representing North; 90 degrees
   represents East; 180 represents South and 270 represents West.
   The reference pixel is the image X offset (drawn at screen position x=0)
   corresponding to the reference angle.  For example, if when the image
   offset is 1800, the image is a view looking north, then refPixel should
   be set to 1800 and refAngle set to 0.
  ====================================================================== */
  public void setReferenceOrientation(int refPixel, float refAngle)
  {
    this.refPixel = refPixel;
    this.refAngle = refAngle;
  }
  
  /* ======================================================================
  Draw the section of the panorama corresponding to the provided angle.
  The x and y offsets control where on the physical screen to draw the
  specified section.  Normally, xOffset should be zero.  yOffset may be
  set to a value that vertically centers the panorama on the screen.
  Set yOffset to 0 to align the panorama to the top of the screen.
  ====================================================================== */
  public void Draw(int xOffset, int yOffset, float angle)
  {
    int x;
    while (angle > 360.0) angle -= 360.0;
    while (angle < 0) angle += 360.0;
    x = int(refPixel + (angle - refAngle) * panorama.width/360.0);
    
    while (x > panorama.width) x -= panorama.width;
    while (x < 0) x += panorama.width;
    
    image(panorama, xOffset -x, yOffset);
    image(rightImage, xOffset + panorama.width - x, yOffset);
  
  }
}