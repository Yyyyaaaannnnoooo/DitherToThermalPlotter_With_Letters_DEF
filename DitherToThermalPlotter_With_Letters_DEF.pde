//to add pixel resize
// istead of picking a portion of the image show the image as a long strip
import processing.serial.*;
import controlP5.*;
import geomerative.*;

// Declare the objects we are going to use, so that they are accesible from setup() and from draw()
RFont f;
RShape grp;
RPoint[] points;
GradientLetter GL;
ControlP5 cp5;
Range range;
Serial therm;
Dither d;
PFont mono;
String ditherToString = "", thermID = "/dev/tty.usbserial";
boolean getImage = false, radialGradient = true, txtMode = true;
float [][] ditherKernel = {{0, 0, 0 }, {0, 0, 0.0}, {0.0, 0.0, 0.0}};
float pix1 = 0, pix2 = 0, pix3 = 0, pix4 = 0, prev1 = 0, prev2 = 0, prev3 = 0, prev4 = 0, fac = 0;
int p, x = 0, hexCount = 0; //the maximum number of chars the plotter can print in each line
void settings() {
  size(800, 800);
}
void setup() {
  //fullScreen();
  mono = createFont("courier", 8, true);
  therm = new Serial(this, thermID, 9600);
  thermInit(); 
  // VERY IMPORTANT: Allways initialize the library in the setup
  //do this before initialiying the gradinetletter class
  RG.init(this);
  GL = new GradientLetter("D");
  d = new Dither();
  p = d.pixSize;//get the value of the pixel size
  cp5 = new ControlP5(this);
  initControllers();
  background(51);
  noFill();
}
void draw() {  
  background(51);
  //here we check if the value of the kernel has been changed if yes
  //the previous value is updated to the new value and we generate a new dither
  //with the new values
  if (prev1 != pix1 || prev2 != pix2 || prev3 != pix3 || prev4 != pix4) {
    //update the kernel
    d.kernel[1][2] = (float)pix1;
    d.kernel[2][0] = (float)pix2;
    d.kernel[2][1] = (float)pix3;
    d.kernel[2][2] = (float)pix4;
    //update the previous value
    prev1 = pix1;
    prev2 = pix2;
    prev3 = pix3;
    prev4 = pix4;
    d.generateDither();
  }
  d.displayDither();
  //////////////////////////////////
  x = floor(map(mouseX, 0, width, 1, d.dither.width - d.charXline));
  //if (getImage)showImageToPrint();
}

void keyPressed() {
  if (key == ' ') {
    printImage(d.dither.get(1, 1, d.charXline, d.dither.height - 1));
    thermPrint(ditherToString);
    //getImage = !getImage;
  } else {
    if (txtMode) {
      String s = str(key);
      GL = new GradientLetter(s.toUpperCase());
      d = new Dither(GL.gradientletter());
      //need to generate the dither otherwise it shows a black image
      d.generateDither();
    }
  }
}

void mouseClicked() {
  if (getImage)printImage(d.dither.get(x, 1, d.charXline, d.dither.height - 1));
}




//cp5 control event to set factor and the color of the gradient
void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("FACTOR")) {
    fac = theControlEvent.getController().getValue();
    d.setFactor(fac);
  }
  if (theControlEvent.isFrom("RADIAL")) {    
    radialGradient = !radialGradient;
    d.setRadiant(radialGradient);
  }
  if (theControlEvent.isFrom("TEXT MODE")) {
    txtMode = !txtMode;
    if (txtMode) {
      d = new Dither(GL.gradientletter());
      //need to generate the dither otherwise it shows a black image
      d.generateDither();
    } else {
      d = new Dither();
      //need to generate the dither otherwise it shows a black image
      d.generateDither();
    }
  }
  if (theControlEvent.isFrom("PIXEL SIZE")) {
    int PS = (int)theControlEvent.getController().getValue();
    d.setPixelSize(PS);
  }
  if (theControlEvent.isFrom("COLORS")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue().
    // min is at index 0, max is at index 1.
    color colorMin = color(int(theControlEvent.getController().getArrayValue(0)));
    color colorMax = color(int(theControlEvent.getController().getArrayValue(1)));
    d.setColor(colorMin, colorMax);
  }
}
//initialize the cp5 controllers
void initControllers() {
  int w = 40, h = 25, top = 100;
  float sensitivity = 0.02;
  color black = color(0), grey = color(150), green = color(0, 255, 0);

  //the range object, cntrols the black and white value
  range = cp5.addRange("COLORS")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
    .setPosition(20, 50)
    .setSize(200, 40)
    .setHandleSize(10)
    .setRange(0, 255)
    .setRangeValues(50, 100)
    // after the initialization we turn broadcast back on again
    .setBroadcast(true)
    .setColorForeground(grey)
    .setColorBackground(black)
    .setColorCaptionLabel(green);

  //kernel controllers
  cp5.addNumberbox("pix1")
    .setPosition(120, top)
    .setSize(w, h)
    .setScrollSensitivity(sensitivity)
    .setValue(7)
    .setColorBackground(grey)
    .setColorCaptionLabel(green);

  cp5.addNumberbox("pix2")
    .setPosition(20, top + 50)
    .setSize(w, h)
    .setScrollSensitivity(sensitivity)
    .setValue(3)
    .setColorBackground(grey)
    .setColorCaptionLabel(green);

  cp5.addNumberbox("pix3")
    .setPosition(70, top + 50)
    .setSize(w, h)
    .setScrollSensitivity(sensitivity)
    .setValue(5)
    .setColorBackground(grey)
    .setColorCaptionLabel(green);

  cp5.addNumberbox("pix4")
    .setPosition(120, top + 50)
    .setSize(w, h)
    .setScrollSensitivity(sensitivity)
    .setValue(1)
    .setColorBackground(grey)
    .setColorCaptionLabel(green);

  //factor controller
  cp5.addSlider("FACTOR")
    .setPosition(20, top + 100)
    .setRange(-10, 50)
    .setSize(200, 30)
    .setColorCaptionLabel(green)
    .setValue(16)
    .setColorForeground(grey)
    .setColorBackground(black)
    .setColorCaptionLabel(green);
  //pixel size controller
  cp5.addSlider("PIXEL SIZE")
    .setPosition(20, top + 150)
    .setRange(1, 10)
    .setSize(200, 30)
    .setColorCaptionLabel(green)
    .setValue(10)
    .setNumberOfTickMarks(10)
    .setColorForeground(grey)
    .setColorBackground(black)
    .setColorCaptionLabel(green);
  // radial gradient button
  cp5.addButton("RADIAL")
    .setValue(0)
    .setPosition(20, top + 200)
    .setSize(200, 19)
    .setColorForeground(grey)
    .setColorBackground(black)
    .setColorCaptionLabel(green);
  //textMode button
  cp5.addButton("TEXT MODE")
    .setValue(0)
    .setPosition(20, top + 250)
    .setSize(200, 19)
    .setColorForeground(grey)
    .setColorBackground(black)
    .setColorCaptionLabel(green);
}