import java.util.*;

Random rand = new Random();

boolean blackHole = true;

ArrayList<PShader> shaders = new ArrayList();
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

int rayVariability = 100;
int raySize = 20;
float raySpanMultiplier = 1.0;
int rayBrightness = 100;

float galaxyPrimary = 220;
float galaxySecondary = 282;
float hue1Delta = 0.0;
float hue2Delta = 0.0;
float galaxySizeModifier = 0.006;

int sessID = 0000;

void setup(){
  sessID = 1000 + rand.nextInt(9000);
  noLoop();
  size(1800, 1000);
  
  
}


void draw(){
  noiseSeed(rand.nextInt());
  background(0);
  
  // Generate a ray across the background  
  stroke(rayBrightness);
  strokeWeight(raySize);
  noFill();
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
       }
       
       
       color c = color(lerp(galaxyPrimary, galaxySecondary, hue),230, (180 * brightness) * brightnessMod);
       
       stroke(c);
       strokeWeight(1);
       point(x, y);
    }
  }
  
  galaxyPrimary = tempHue1;
  galaxySecondary = tempHue2;

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
    case 'c':
      print("Creating chaos...\n");
      galaxyPrimary = rand.nextInt(360);
      galaxySecondary = rand.nextInt(360);
      blackHole = boolean(rand.nextInt(2));
      hue1Delta = (rand.nextFloat() - 0.5) / 10;
      hue2Delta = (rand.nextFloat() - 0.5) / 10;
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

}
