import java.util.*;

Random rand = new Random();

boolean blackHole = true;

ArrayList<Planet> planets;
int numPlanets = 0;
float planetSizeMod = 1.0;
boolean planetShadows = true;

int currShader = 0;

int starSize = 1;
int starSizeSpread = 2;
int starCount = 10000;
int starBrightness = 225;
int starBrightnessSpread = 25;

int windowW = 1800;
int windowH = 1000;

int blackHoleDiameter = 300;
color accretionDiskColor = color(255);

int rayCount = 1;
int rayVariability = 100;
int raySize = 20;
float raySpanMultiplier = 1.0;
int rayBrightness = 100;

float galaxyPrimary = 220;
float galaxySecondary = 282;
float hue1Delta = 0.0;
float hue2Delta = 0.0;
float galaxySizeModifier = 0.006;

boolean banding = false;
int bandingAmt = 30;

int sessID;

void setup(){
  sessID = 1000 + rand.nextInt(9000);
  noLoop();
  size(1800, 1000);
  
  
}


void draw(){
  colorMode(RGB);
  planets = new ArrayList<Planet>();
  noiseSeed(rand.nextInt());
  background(0);
  
  // Generate the planets if there are any
  for(int i = 0; i < numPlanets; i++){
    Planet p;
    boolean isColliding;
    do {
      isColliding = false;
      p = new Planet(rand.nextInt(width), rand.nextInt(height), (100 + rand.nextInt(100))  * planetSizeMod, rand.nextInt(255), rand.nextInt(200), rand.nextFloat());
      for(Planet x : planets){
        if(dist(p.x, p.y, x.x, x.y) < p.d / 2 + x.d / 2) isColliding = true;
        if(blackHole && dist(p.x, p.y, width/2, height/2) < blackHoleDiameter/2 + p.d/2) isColliding = true;
      }
    } while(isColliding);
    planets.add(p);
  }



  // Generate a ray across the background  
  stroke(rayBrightness);
  strokeWeight(raySize);
  noFill();
  for (int i = 0; i < rayCount; ++i) {
    switch(rand.nextInt(4)){
      case 0:
        ellipse(width - 100 + rand.nextInt(rayVariability), height - 100 + rand.nextInt(rayVariability), (rand.nextInt(5000) + width) * raySpanMultiplier,  (rand.nextInt(500) + height) * raySpanMultiplier);
        break;
      case 1:
        ellipse(0 - 100 + rand.nextInt(rayVariability), height - 100 + rand.nextInt(rayVariability), (rand.nextInt(5000) + width) * raySpanMultiplier,  (rand.nextInt(500) + height) * raySpanMultiplier);
        break;
      case 2:
        ellipse(width - 100 + rand.nextInt(rayVariability), height - 100 + rand.nextInt(rayVariability), (rand.nextInt(500) + height) * raySpanMultiplier, (rand.nextInt(5000) + width) * raySpanMultiplier);
        break;
      case 3:
        ellipse(width - 100 + rand.nextInt(rayVariability), 0 - 100 + rand.nextInt(rayVariability), (rand.nextInt(500) + height) * raySpanMultiplier, (rand.nextInt(5000) + width) * raySpanMultiplier);
        break;
    }
  }
  
  
  
  
  
  

  // Create the accretion disk for the black hole
  //stroke(red(accretionDiskColor) / 10);
  //circle(width/2, height/2, blackHoleDiameter * 1.1);
  
  noStroke();
  
  if(blackHole){
    fill(accretionDiskColor);
    circle(width/2, height/2, blackHoleDiameter);
  }
  
  //Not happy with how this looks
  //ellipse(width/2, height/2, blackHoleDiameter * 1.2, blackHoleDiameter * .8);
  
  


  // Blur the accretion disk and ray to create a glowing effect
  filter(BLUR, 10); 
  
  // Use perlin noise to generate galaxies surrounding the black hole
  noiseDetail(5, .4);
  float xoff = 0.0;
  colorMode(HSB);
  float tempHue1 = galaxyPrimary;
  float tempHue2 = galaxySecondary;
  int bandingTimeout = rand.nextInt(bandingAmt);
  boolean currBand = false;
  for(int x = 0; x < width; x++){
    xoff += galaxySizeModifier;  
    float yoff = 0.0;
    galaxyPrimary += hue1Delta;
    galaxySecondary += hue2Delta;
    for(int y = 0; y < height; y++){
       yoff += galaxySizeModifier;
       float brightness = noise(xoff, yoff);
       float hue = noise(xoff, yoff, (xoff+yoff)/2);
       
       float brightnessMod = 1.0;
       
       if(dist(x,y,width/2,height/2) < blackHoleDiameter * 1.2 && blackHole){
           float maxDist = (blackHoleDiameter * 1.2);
           brightnessMod = map(dist(width/2,height/2,x,y), 0, maxDist, -1, 1);
       }else if(banding && !blackHole){
          brightnessMod = .25 + (noise(xoff, yoff));
          
       }

       
      if(currBand || brightnessMod > 1.0){
        brightnessMod = 1.0;
      }
       
       
       color c = color(lerp(galaxyPrimary, galaxySecondary, hue),230, (180 * brightness) * brightnessMod);
       
       stroke(c);
       strokeWeight(1);
       point(x, y);
    }
    if(banding){
        if(bandingTimeout > 0){
          bandingTimeout--;
        }else{
          currBand = !currBand;
          bandingTimeout = rand.nextInt(blackHole ? bandingAmt : bandingAmt * 10);
    }
    }
  }
  
  galaxyPrimary = tempHue1;
  galaxySecondary = tempHue2;
  
  
  // Populate space with stars
  colorMode(RGB);
  
  noStroke();
  for(int i = 0; i < starCount; i++){
    int x = rand.nextInt(windowW);
    int y = rand.nextInt(windowH);
    int r = !(starSize == 0) ? ((rand.nextInt(11) % 2) == 0 ? starSize - rand.nextInt(starSizeSpread+1) : starSize + rand.nextInt(starSizeSpread+1)) : 1;
    int b = (rand.nextInt(11) % 2) == 0 ? starBrightness - rand.nextInt(starBrightnessSpread+1) : starBrightness + rand.nextInt(starBrightnessSpread+1);
    fill(b);
    circle(x,y, r);
  }
  
  //Create shadows for the planets
  if(planetShadows){
    for(Planet p : planets){
      int fillLevel = 200;
      float diameter = 1.0;
      while(fillLevel > 0){
        fill(4,4,4,fillLevel);
        circle(p.x * 1.0017, p.y, p.d * diameter);
        diameter += .01;
        fillLevel -= 15;
      }
      
    }
  } 

  // Create the planets
  colorMode(HSB);
  strokeCap(PROJECT);
  xoff = 0.0;
  for(int x = 0; x < width; x++){
    xoff += .02;  
    float yoff = 0.0;
    for(int y = 0; y < height; y++){
      yoff += .02;
      for(Planet p : planets){
        if(dist(x, y, p.x, p.y) < p.d / 2){
          //We are in planets area
          float noiseValue = noise(xoff, yoff);
          float xdist = dist(x, 0, p.x + p.d/1.25, 0);
          float ydist = dist(y, 0, p.y + p.d/1.25, 0);
          color c = color(p.hue, p.sat, ((noiseValue * 180) * map(xdist, 0, p.d, 1.0, p.shadow / 5)));
          
          stroke(c);
          strokeWeight(1);
          point(x, y);
          break;
        }
      }
    }
  }
  strokeCap(ROUND);
  // Finally, create the black hole
  colorMode(RGB);
  fill(0);
  if(blackHole){
    circle(width/2, height/2, blackHoleDiameter * 0.95);
  }

}

void mousePressed(){
  print("Regenerating the universe...\n");
  redraw(); 
}

// Controls
void keyPressed(){
  switch(key){
    case '[':
      galaxyPrimary--;
      print("Galaxy hue 1: " + galaxyPrimary + "\n");
      break;
    case ']':
      galaxyPrimary++;
      print("Galaxy hue 1: " + galaxyPrimary + "\n");
      break;
    case ';':
      galaxySecondary--;
      print("Galaxy hue 2: " + galaxySecondary + "\n");
      break;
    case '\'':
      galaxySecondary++;
      print("Galaxy hue 2: " + galaxySecondary + "\n");
      break;
    case '.':
      raySpanMultiplier -= 0.1;
      print("Ray span multiplier: " + raySpanMultiplier + "\n");
      break;
    case 't':
      rayCount--;
      print("Ray count: " + rayCount + "\n");
      break;
    case 'y':
      rayCount++;
      print("Ray count: " + rayCount + "\n");
      break;
    case '/':
      raySpanMultiplier += 0.1;
      print("Ray span multiplier: " + raySpanMultiplier + "\n");
      break;
    case 'q':
      starCount -= 250;
      print("Star count: " + starCount + "\n");
      break;
    case 'w':
      starCount += 250;
      print("Star count: " + starCount + "\n");
      break;
    case 'a':
      starSize--;
      print("Star size: " + starSize + "\n");
      break;
    case 's':
      starSize++;
      print("Star size: " + starSize + "\n");
      break;
    case 'z':
      starSizeSpread--;
      print("Star size spread: " + starSizeSpread + "\n");
      break;
    case 'x':
      starSizeSpread++;
      print("Star size spread: " + starSizeSpread + "\n");
      break;
    case ' ':
      blackHole = !blackHole;
      print("Black hole toggled " + (blackHole ? "on" : "off") + "\n");
      break;
    case 'b':
      banding = !banding;
      print("Banding toggled " + (banding ? "on" : "off") + "\n");
      break;
    case 'v':
      bandingAmt--;
      print("Banding amount: " + bandingAmt + "\n");
      break;
    case 'n':
      bandingAmt++;
      print("Banding amount: " + bandingAmt + "\n");
      break;
    case 'c':
      print("Creating chaos...\n");
      galaxyPrimary = rand.nextInt(360);
      galaxySecondary = rand.nextInt(360);
      blackHole = boolean(rand.nextInt(2));
      hue1Delta = (rand.nextFloat() - 0.5) / 10;
      hue2Delta = (rand.nextFloat() - 0.5) / 10;
      if(rand.nextInt(3) == 0) { 
        banding = !banding; 
        bandingAmt = 10 + rand.nextInt(45);
      }
      if(rand.nextInt(2) == 0 && !blackHole){
        numPlanets = rand.nextInt(6) + 1;
        planetSizeMod = rand.nextInt(2) + rand.nextFloat();
      }else{
        numPlanets = 0;
      }
      if(rand.nextInt(4) == 0){
        rayCount = rand.nextInt(5);
      }else{
        rayCount = 1;
      }
      redraw();
      break;
    case 'r':
      print("Reset the hue deltas.\n");
      hue1Delta = 0;
      hue2Delta = 0;
      break;
    case 'i':
      hue1Delta -= 0.02;
      print("Primary hue delta: " + hue1Delta +"\n");
      break;
    case 'o':
      hue1Delta += 0.02;
      print("Primary hue delta: " + hue1Delta +"\n");
      break;
    case 'j':
      hue2Delta -= 0.02;
      print("Secondary hue delta: " + hue2Delta +"\n");
      break;
    case 'k':
      hue2Delta += 0.02;
      print("Secondary hue delta: " + hue2Delta +"\n");
      break;
    case '\n':
      print("Saving image...\n");
      saveFrame("universe-" + sessID + "-####.png");
      break;
    default:  
  }
  switch(keyCode){
    case UP:
      numPlanets++;
      print("Planet count: " + numPlanets + "\n");
      break;
    case DOWN:
      numPlanets--;
      print("Planet count: " + numPlanets + "\n");
      break;
    case LEFT:
      planetSizeMod -= 0.1;
      print("Planet size modifier: " + planetSizeMod + "\n");
      break;
    case RIGHT:
      planetSizeMod += 0.1;
      print("Planet size modifier: " + planetSizeMod + "\n");
      break;
    case SHIFT:
      planetShadows = !planetShadows;
      print("Planet shadows toggled " + (planetShadows ? "on" : "off") + "\n");
      break;
    default:
  }
}

class Planet {
  int x;
  int y;
  float d;
  int hue;
  int sat;
  float shadow;
  public Planet(int x, int y, float d, int hue, int sat, float shadow){
    this.x = x;
    this.y = y;
    this.d = d;
    this.hue = hue;
    this.sat = sat;
    this.shadow = shadow;
  }
}