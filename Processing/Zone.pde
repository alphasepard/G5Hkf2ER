public class Zone {
  int xo;
  int yo;
  int leftEtoile;
  Star stars[];
  
  public Zone (int xo, int yo, int size) {
    this.xo = xo;
    this.yo = yo;
    stars = new Star[size];
    leftEtoile = size;
  }
}