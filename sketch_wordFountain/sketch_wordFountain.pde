//Fountain of words. Because, why not?!
//David Corney, April 2011

//TODO: add cross wind - mouse controlled?
//DONE! better collisions - measure extent of each word
//TODO: better coll.2 - rotate word as it bounces "realistically"
//DONE! then add a bottom to the fountain, so that the words bounce off
//TODO: vary font size? 
//TODO: automate fountain placement (3D?)
//DONE! move file reading into WordFountain class
//     - so init with location, colour, filename...
//TODO: better fountain "pipe" graphics - cylinder? shading?
//TODO: replace text source with Twitter stream/Gmail etc.

WordFountain[] wf;
ArrayList[] incomingWords;
String[] filenames;

void setup() {
  size(640, 500, P3D);
  colorMode(RGB, 255, 255, 255, 100);
  //color c1 = color(150,150,255);
  wf = new WordFountain[2];
  wf[0] = new WordFountain("leafExtract.txt",new PVector(width*.66, height*.25),color(150,150,255));
  wf[1] = new WordFountain("wikiES.txt",new PVector(width*.33, height*.25),color(150,250,150));
  smooth();
}

void draw() {
  background(50,30,20);
  for (int i=0; i<wf.length;i++) {
    //if (frameCount % 30==1) {  //add words (if any left to add)
    if (random(0,1)<0.2){
    //if(frameCount==10){ 
      /*if (incomingWords[i].size()>0) {
        String nextWord=(String)incomingWords[i].get(0);
        incomingWords[i].remove(0);
        wf[i].addWord(nextWord);
      }
      else
      {
       incomingWords[i]=readFile(filenames[i]);  //re-load text        
      }
      */
      wf[i].addWord();
    }

    wf[i].update();
    wf[i].display();
  }
}


