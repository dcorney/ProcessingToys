//Fountain that spews words (as particles)
//David Corney, April 2011

class WordFountain
{
  ArrayList words;  //particles
  ArrayList incomingWords;  //strings from file
  PVector origin;
  PFont font;
  color wCol;
  String filename;
  float basePos;
  WordFountain(String nFilename, PVector nOrigin, color nWCol) {
    filename=nFilename;
    origin=nOrigin;
    wCol=nWCol;
    words=new ArrayList();
    font = loadFont("Gisha-24.vlw");
    incomingWords=readFile(filename);
    basePos=min(height*.9, origin.y+250);  
}


  void addWord() {  // String word) {
    //println("Origin in wf at " + origin);
    

    if (incomingWords.size()==0) {
      incomingWords=readFile(filename);  //re-load text
    }

    String nextWord=(String)incomingWords.get(0);
    incomingWords.remove(0);
    //wf[i].addWord(nextWord);


    words.add(new WordParticle(nextWord, origin, font, basePos, wCol));
  }

  void update() {
    for (int i=0; i<words.size();i++) {
      WordParticle t = (WordParticle)words.get(i);
      t.update();
      if (t.timer<=0) { 
        words.remove(i);
      }
    }
  }

  void display() {
    float w=10, h=250;
    pushMatrix();
    translate(origin.x, origin.y);
    stroke(255);
    strokeWeight(1);
    line( w*.5, 10, w*0, h);  //right side
    line(-w*.5, 10, -w*0, h);  //left side
    line( w*.5, 10, w*.5+20, 0 );  //spout
    line(-w*.5, 10, -w*.5-20, 0 );
    strokeWeight(2);
    line(-w*5,250,w*5,250);
    rotateX(-PI*.5);
    //noFill();
    //ellipse(0,0,40,40);
    arc(0, 0, 40, 40, 0, PI);
    popMatrix();
    for (int i=0; i<words.size();i++) {
      ((WordParticle)words.get(i)).display();
    }
  }


  ArrayList readFile(String filename) {

    ArrayList incomingWords  = new ArrayList();
    BufferedReader reader= createReader(filename);  
    boolean finished=false;
    String line="";
    while (finished==false)
    {
      try {
        line = reader.readLine();
      } 
      catch (IOException e) {
        e.printStackTrace();
        line = null;
        finished=true;
      }
      if (line == null) {
        // Stop reading because of an error or file is empty
        finished=true;
      } 
      else {
        String[] pieces = split(line, " ");
        //println("First word: " + pieces[0] +" of " + pieces.length);
        for (int i=0; i<pieces.length; i++) {
          incomingWords.add(pieces[i]);
        }
      }
    }
    return incomingWords;
  }
}

