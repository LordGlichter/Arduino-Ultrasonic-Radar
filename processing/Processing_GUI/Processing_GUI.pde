import processing.serial.*; 

Serial myPort; 
String angle = "";
String distance = "";
String data = "";
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;

void setup() {
  size(1200, 700); 
  smooth();
  myPort = new Serial(this, "COM3", 9600); 
  myPort.bufferUntil('.'); 
  background(0);
}

void draw() {
  noStroke();
  fill(0, 7); 
  rect(0, 0, width, height); 
  
  drawRadarGrid();
  drawRadarSweep();
  drawText();
}

void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');
  if (data != null) {
    data = data.trim();
    index1 = data.indexOf(","); 
    if (index1 != -1) {
      angle = data.substring(0, index1);
      distance = data.substring(index1 + 1, data.length());
      
      iAngle = int(angle);
      iDistance = int(distance);
    }
  }
}

void drawRadarGrid() {
  pushMatrix();
  translate(width/2, height - height*0.074); 
  noFill();
  strokeWeight(2);
  stroke(0, 255, 0); 
  
  arc(0, 0, (width-width*0.06), (width-width*0.06), PI, TWO_PI);
  arc(0, 0, (width-width*0.38), (width-width*0.38), PI, TWO_PI);
  arc(0, 0, (width-width*0.7), (width-width*0.7), PI, TWO_PI);
  arc(0, 0, (width-width*1.02), (width-width*1.02), PI, TWO_PI);
  
  line(-width/2, 0, width/2, 0);
  line(0, 0, (-width/2)*cos(radians(30)), (-width/2)*sin(radians(30)));
  line(0, 0, (-width/2)*cos(radians(60)), (-width/2)*sin(radians(60)));
  line(0, 0, (-width/2)*cos(radians(90)), (-width/2)*sin(radians(90)));
  line(0, 0, (-width/2)*cos(radians(120)), (-width/2)*sin(radians(120)));
  line(0, 0, (-width/2)*cos(radians(150)), (-width/2)*sin(radians(150)));
  popMatrix();
}

void drawRadarSweep() {
  pushMatrix();
  strokeWeight(7); // Thick line so it fills in densely
  translate(width/2, height - height*0.074); 
  
  // Calculate where the max edge of the radar screen is
  float maxPixsDistance = 40 * ((height - height * 0.166) * 0.025); 
  // Calculate where the object actually is
  pixsDistance = iDistance * ((height - height * 0.166) * 0.025); 
  
  if (iDistance > 0 && iDistance < 40) {
    stroke(30, 250, 30); 
    line(0, 0, pixsDistance*cos(radians(iAngle)), -pixsDistance*sin(radians(iAngle)));
    
    stroke(255, 10, 10); 
    line(pixsDistance*cos(radians(iAngle)), -pixsDistance*sin(radians(iAngle)), 
         maxPixsDistance*cos(radians(iAngle)), -maxPixsDistance*sin(radians(iAngle)));
  } 
  else {
    stroke(30, 250, 30); 
    line(0, 0, maxPixsDistance*cos(radians(iAngle)), -maxPixsDistance*sin(radians(iAngle)));
  }
  
  popMatrix();
}

void drawText() {
  pushMatrix();
  noStroke();
  fill(0);
  rect(0, height - height*0.09, width, height*0.1); 
  
  fill(0,255,0);
  textSize(20);
  text("Angle: " + iAngle + " °", width*0.1, height*0.93);
  text("Distance: " + iDistance + " cm", width*0.5, height*0.93);
  popMatrix();
}
