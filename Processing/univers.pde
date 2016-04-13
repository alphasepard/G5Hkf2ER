PShape particles;
PImage sprite;  

int zoneCourante, it, npartTotal = 150, ligneTotal =6;
boolean zoom, unZoom, zoomed = false, fini = true;
float partSize = 20.0, zoomRate = 1.0;
float centerx, centery, x, y, movex, movey, coordX = 0.0, coordY = 0.0;

int fcount, lastm;
float frate;
int fint = 3;

Zone zones[];

void setup() {

  sprite = loadImage("sprite.png");
  
  zoneCourante = 0;
  //size(800, 600, P3D);
  fullScreen(P3D,1);
  frameRate(60);
  centerx = width/2;
  centery = height/2;
  x = 0;
  y = 0;

  zones = new Zone[ligneTotal*ligneTotal];
  
  particles = createShape(PShape.GROUP);
  sprite = loadImage("sprite.png");

  for (int x = 0; x < ligneTotal; x++) {
    for (int y = 0; y < ligneTotal; y++) {
      if (zoneCourante > ligneTotal*ligneTotal) {
        break;
      }
      zones[zoneCourante] = new Zone(x*(width/ligneTotal),y*(height/ligneTotal),npartTotal);
      for (int n = 0; n < npartTotal; n++) {
        float cx = random(0, width/6);
        float cy = random(0, height/6); 
        float cz = random(2, 6);
        zones[zoneCourante].stars[n] = new Star(cx, cy, cz);
      }
      zoneCourante++;
    }
  }
  zoneCourante = 0;
  
  if (!zoomed) {
        it = 0;
        fini = false;
        movex = (zones[zoneCourante].xo)/10.0;
        movey = (zones[zoneCourante].yo)/10.0;
        zoom = true;
        zoomed = true;
      }

  // Writing to the depth buffer is disabled to avoid rendering
  // artifacts due to the fact that the particles are semi-transparent
  // but not z-sorted.
  hint(DISABLE_DEPTH_MASK);
  ortho();
}

void aspire() {
  Star stars[] = zones[zoneCourante].stars;
  Star s;
  if (fini && zoomed) {
    for (int i=0; i<stars.length; i++) {
       s = stars[i];
       if ((abs(coordX-(s.x/(width/6))) < 0.05) && (abs(coordY-(s.y/(height/6))) < 0.05) && (s.opac > 0) && zoomed) {
           zones[zoneCourante].stars[i].opac -= 100;
           if (zones[zoneCourante].stars[i].opac <= 0) {
             zones[zoneCourante].leftEtoile--;
           }
       }
    }
  }
  if (zones[zoneCourante].leftEtoile == 0) {
    if (zoomed && fini) {
        it = 0;
        fini = false;
        movex = (zones[zoneCourante].xo)/10.0;
        movey = (zones[zoneCourante].yo)/10.0;
        unZoom = true;
        zoomed = false;
    } else if (fini) {
        zoneCourante++;
        it = 0;
        fini = false;
        movex = (zones[zoneCourante].xo)/10.0;
        movey = (zones[zoneCourante].yo)/10.0;
        zoom = true;
        zoomed = true;
    }
    if (zoneCourante >= ligneTotal*ligneTotal) {
        zoneCourante = 0;
    }
  }
}

void update() {
  particles = createShape(PShape.GROUP);
  int opac = 0;
  for (int l = 0; l < (ligneTotal*ligneTotal); l++) {
    if ((zoomed && (l == zoneCourante)) || (!zoomed) || (!fini)) {
      for (int n = 0; n < zones[l].leftEtoile; n++) {
        float cx = (zones[l].stars[n].x)+(zones[l].xo);
        float cy = (zones[l].stars[n].y)+(zones[l].yo);
        float cz = (zones[l].stars[n].z);
        
        PShape part = createShape();
        part.beginShape(QUAD);
        part.noStroke();
        opac = zones[l].stars[n].opac-20+(int)(random(-20,+20));
        part.tint(opac,opac,opac,opac);
        part.texture(sprite);
        part.normal(0, 0, 1);
        part.vertex(cx - cz/2, cy - cz/2, cz, 0, 0);
        part.vertex(cx + cz/2, cy - cz/2, cz, sprite.width, 0);
        part.vertex(cx + cz/2, cy + cz/2, cz, sprite.width, sprite.height);
        part.vertex(cx - cz/2, cy + cz/2, cz, 0, sprite.height);    
        part.endShape();    
        particles.addChild(part);
      }
    }
  }
}

void toZoom() {
  if (it >= 60) {
     zoom = false;
     fini = true;
  } else {
     x -= movex;
     y -= movey;
     zoomRate += 0.084;
  }
  it++;
}

void toUnZoom() {
  if (it >= 60) {
     zoom = false;
     fini = true;
  } else {
     x += movex;
     y += movey;
     zoomRate -= 0.084;
  }
  it++;
}

void keyPressed()
{
  if(key == CODED)
  {
    if (!zoomed && keyCode == RIGHT)
    {
      zoneCourante++;
    }
    if(keyCode == DOWN) {
      if (!zoomed && fini) {
        it = 0;
        fini = false;
        movex = (zones[zoneCourante].xo)/10.0;
        movey = (zones[zoneCourante].yo)/10.0;
        zoom = true;
        zoomed = true;
      }
    }
    if(keyCode == LEFT) {
      if (zoomed && fini) {
        it = 0;
        fini = false;
        movex = (zones[zoneCourante].xo)/10.0;
        movey = (zones[zoneCourante].yo)/10.0;
        unZoom = true;
        zoomed = false;
      }
    }
    if (zoneCourante >= ligneTotal*ligneTotal) {
        zoneCourante = 0;
    }
  }
}

void draw () {
  background(0);
  
  translate(x, y);
  scale(zoomRate);

  if (zoom) {
    toZoom(); 
  }
  else if (unZoom) {
    toUnZoom();
  }
  if(mousePressed) {
    textSize(15);
    text("nb etoile:"+zones[zoneCourante].leftEtoile, (zones[zoneCourante].xo)+20, (zones[zoneCourante].yo)+20);
    text("zone:"+zoneCourante, (zones[zoneCourante].xo)+20, (zones[zoneCourante].yo)+40);
  }
  
  update();
  shape(particles);
  
  fcount += 1;
  int m = millis();
  if (m - lastm > 300 * fint) {
    frate = float(fcount) / fint;
    fcount = 0;
    lastm = m;
    println("fps: " + frate);
    aspire();
  }  
}