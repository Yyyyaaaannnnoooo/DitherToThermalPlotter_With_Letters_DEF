class GradientLetter {
  String word;
  PImage img;
  int r = 75;
  GradientLetter(String _word) {
    word = _word;
    //initialize image
    img = createImage(44, 44, RGB);//this size is for the thremo printer
    //  Load the font file we want to use (the file must be in the data folder in the sketch floder), with the size 60 and the alignment CENTER
    grp = RG.getText(word, "SourceCodePro-Black.ttf", 40, CENTER);
  }

  PImage gradientletter() {
    RG.setPolygonizer(RG.ADAPTATIVE);
    grp.draw();
    RG.setPolygonizer(RG.UNIFORMLENGTH);
    float numberOfPoints = 3;//map(mouseX, 0, width, 3, 200);make this a variable that can be updated!!
    println(numberOfPoints);
    RG.setPolygonizerLength(numberOfPoints);
    points = grp.getPoints();

    // If there are any points
    if (points != null) {  
      img.loadPixels();
      fill(0);
      stroke(0);
      for (int y = 0; y < img.height; y++) {
        for (int x=0; x < img.width; x++) {
          int index = x + y * img.width;
          float sum = 0;
          for (int i=0; i<points.length; i++) {
            float d = dist(x, y, img.width * 0.5 + points[i].x, img.height * 0.8 + points[i].y);
            if(d < 5)sum += r / d;//improve this!!!!!
            //sum += d % 255;
            img.pixels[index] = color(255 - sum);
          }
        }
      }
      img.updatePixels();
    }
    return img;
  }
}