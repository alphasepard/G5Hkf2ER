
 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

float coordX;
float coordY;

void setup() {
  size(400,400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,7111);
  
}


void draw() {
  background(0);  
}



/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

  //reception des coordonnees X et Y :
   
  if (theOscMessage.addrPattern().equals("/X") == true)
  {
   coordX = theOscMessage.get(0).floatValue();
  }
  //println("X =" + coordX);
  
  if (theOscMessage.addrPattern().equals("/Y") == true)
  {
   coordY = theOscMessage.get(0).floatValue();
  }
  //println("Y =" + coordY);
 
}