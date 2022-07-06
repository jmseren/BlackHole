import java.util.*;

Random rand = new Random();

final int starSize = 1;
final int starSizeSpread = 2;
final int starCount = 10000;
final int starBrightness = 225;
final int starBrightnessSpread = 25;

final int windowW = 1800;
final int windowH = 1000;

final int blackHoleDiameter = 300;
color accretionDiskColor = color(255);

final int raySize = 20;
final int rayBrightness = 100;

color galaxyPrimary = 220;
color galaxySecondary = 282;
float galaxySizeModifier = 0.006;

void setup(){
  noLoop();
  size(1800, 1000);
  background(0);
  
  
  
  
  
  // Generate a ray across the background  
  stroke(rayBrightness);
  strokeWeight(raySize);
  line(rand.nextInt(width), -10, rand.nextInt(width), height+10);
  
  
  
  
  
  
  // Create the accretion disk for the black hole
  noStroke();
  fill(accretionDiskColor);
  circle(width/2, height/2, blackHoleDiameter);
  
  //Not happy with how this looks
  //ellipse(width/2, height/2, blackHoleDiameter * 1.2, blackHoleDiameter * .8);
  
  
  // Blur the accretion disk and ray to create a glowing effect
  filter(BLUR, 10); 
  
  // Use perlin noise to generate galaxies surrounding the black hole
  noiseDetail(5, .4);
  float xoff = 0.0;
  colorMode(HSB);
  for(int x = 0; x < width; x++){
    xoff += galaxySizeModifier;  
    float yoff = 0.0;   
    for(int y = 0; y < height; y++){
       yoff += galaxySizeModifier;
       float brightness = noise(xoff, yoff);
       float hue = noise(xoff, yoff, (xoff+yoff)/2);
       
       float brightnessMod = 1.0;
       if(dist(x,y,width/2,height/2) < blackHoleDiameter * 1.2){
           float maxDist = (blackHoleDiameter * 1.2);
           brightnessMod = map(dist(width/2,height/2,x,y), 0, maxDist, -1, 1);
       }
       
       
       color c = color(lerp(galaxyPrimary, galaxySecondary, hue),230, (180 * brightness) * brightnessMod);
       
       stroke(c);
       strokeWeight(1);
       point(x, y);
    }
  }
  
  colorMode(RGB);
  
  noStroke();
  
  
  
  // Populate space with stars
  for(int i = 0; i < starCount; i++){
    int x = rand.nextInt(windowW);
    int y = rand.nextInt(windowH);
    int r = !(starSize == 0) ? ((rand.nextInt(11) % 2) == 0 ? starSize - rand.nextInt(starSizeSpread+1) : starSize + rand.nextInt(starSizeSpread+1)) : 1;
    int b = (rand.nextInt(11) % 2) == 0 ? starBrightness - rand.nextInt(starBrightnessSpread+1) : starBrightness + rand.nextInt(starBrightnessSpread+1);
    fill(b);
    circle(x,y, r);
  }
  
  fill(0);
  
  // Finally, create the black hole
  circle(width/2, height/2, blackHoleDiameter * 0.95);
}
