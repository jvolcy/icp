/* ======================================================================
====================================================================== */
public static class GisCoord
{
  public Double longitude;
  public Double latitude;
  
  public GisCoord(Double longitude, Double latitude)
  {
    this.longitude = longitude;
    this.latitude = latitude;
  }
}


public static class Gis
{

//---------- Pixel to GIS conversion constants ----------
  public static final int PIXEL_X1 = 107;
  public static final int PIXEL_Y1 = 203;
  public static final int PIXEL_X2 = 1283;
  public static final int PIXEL_Y2 = 1060;
  public static final Double LATITUDE1 = 33.746511111d;
  public static final Double LONGITUDE1 = -84.414425000d;
  public static final Double LATITUDE2 = 33.7433194444444d;
  public static final Double LONGITUDE2 = -84.4091305556d;

  //public Vect2 pixel;
  //public GisCoord gis;


  /* ======================================================================
  ====================================================================== */
  public static Vect2 Gis2Pixel(Double longitude, Double latitude)
  {
    double pixelX, pixelY;
    pixelX = PIXEL_X1 + ((PIXEL_X2-PIXEL_X1)/(LONGITUDE2-LONGITUDE1)) * (longitude - LONGITUDE1);
    pixelY = PIXEL_Y1 + ((PIXEL_Y2-PIXEL_Y1)/(LATITUDE2-LATITUDE1)) * (latitude - LATITUDE1);
    //println(pixelX + ", " + pixelY);
    return new Vect2(pixelX, pixelY);
  }
  
  /* ======================================================================
  ====================================================================== */
  public static Vect2 Gis2Pixel(GisCoord gc)
  {
    return Gis2Pixel(gc.longitude, gc.latitude);
  }
  
  /* ======================================================================
  ====================================================================== */
  public static GisCoord Pixel2Gis(Double pixelX, Double pixelY)
  {
    double longitude, latitude;
    longitude = LONGITUDE1 + ((LONGITUDE2 - LONGITUDE1) / (PIXEL_X2 - PIXEL_X1))  * (pixelX - PIXEL_X1);
    latitude = LATITUDE1 + ((LATITUDE2 - LATITUDE1) / (PIXEL_Y2 - PIXEL_Y1))  * (pixelY - PIXEL_Y1);
    return new GisCoord(longitude, latitude);
  }

  /* ======================================================================
  ====================================================================== */
  public static GisCoord Pixel2Gis(Vect2 pixel)
  {
    return Pixel2Gis(pixel.i, pixel.j);
  }
  
}



/* ======================================================================
====================================================================== */

//----------  ----------
//----------  ----------
//----------  ----------