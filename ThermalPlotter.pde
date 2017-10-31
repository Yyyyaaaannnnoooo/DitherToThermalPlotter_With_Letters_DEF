void printImage(PImage img) {
  ditherToString = "";
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    float b = brightness(c);
    //String s = b < 150 ? "\u25FC" : "\u25FD";//black square and white square
    //String s = b < 150 ? "\u2591" : "\u2592";//black square and white square
    //String s = b < 150 ? "\u2588" : "\u2594";//black square and white square
    //String h = "\u005C";
    //String s = b < 150 ? "/" : "|"; //black square and white square
    //String s = b < 150 ? "1" : "0"; //black square and white square
    String s = b < 150 ? "a" : "b";
    //String s = b < 150 ? "\u2588" : "\u202F";//black square and white square sourceCodePro
    //String s = b < 150 ? "\u25E2" : "\u25E3";//triangle different rotation really nice
    //if (i > 1 && i % 42 == 0)ditherToString = ditherToString.concat("\n");
    ditherToString = ditherToString.concat(s);
  }
}
//
void thermInit() {
  byte[] d;
  d = new byte[] {0x1B, 0x40};
  therm.write(d);
}
//
void thermPrint(String img) {//String Title, String myText, 
  byte[] d;
  d = new byte[] {0x1B, 0x40, 0x1B, 0x61, byte(1), };  
  therm.write(d);
  for (int i = 0; i < img.length(); i++) {
    if (i > 1 && i % 42 == 0)therm.write("\n");
    if (img.charAt(i) == 'a')therm.write(0xDB);//fullblack
    else therm.write(0xB0);//semi-white
  }
  //therm.write(0xDB);//fullBlack
  //therm.write(0xDB);//white
  //therm.write(0xB0);
  //therm.write(0xB0);
  //therm.write(img + "\n\n");
  //// set print mode (2xwidth, 2xheight, emph)  
  //therm.write(0x1B); // ESC
  //therm.write(0x21); // !
  //therm.write(48); // double-height

  //therm.write(Title + "\n\n"); // header horoscope
  //therm.write("/////////////////////\n");
  //// set print mode (default)  
  //therm.write(0x1B); // ESC
  //therm.write(0x21); // !
  //therm.write(0); // double-height

  ////therm.write("MORE TEXT\n");
  //therm.write(0x0A); //LF
  //therm.write(0x0D); //CR
  //therm.write(myText); //here comes the horoscope text
  //therm.write(0x0A); //LF


  //// set print mode (2xwidth, 2xheight, emph)  
  //therm.write(0x1B); // ESC
  //therm.write(0x21); // !
  //therm.write(56); // double-height
  //therm.write("\n/////////////////////\n\n");
  //// set print mode (default)  
  //therm.write(0x1B); // ESC
  //therm.write(0x21); // !
  //therm.write(0); // double-height
  //therm.write("Horoscopes by Rob Brezsny\n@ freewillastrology.com");
  //therm.write("\nTexts composed with RiTa 1.12\n@ rednoise.org/rita");
  //therm.write(0x1B); // ESC
  //therm.write(0x21); // !
  //therm.write(0); // default

  therm.write(0x0A); //LF
  //therm.write("Last line of text.. then feed some lines and cut!");
  therm.write(0x0A); //LF
  therm.write(0x0A); //LF
  therm.write(0x0A); //LF
  therm.write(0x0D); //CR
  therm.write(0x1D); //GS
  therm.write(0x56); //V
  therm.write(66); //
  therm.write(3); //3 lines
}