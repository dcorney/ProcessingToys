//Models/animates a string as a particle
//David Corney, April 2011

class WordParticle
{
  String word; 
  PVector pos;
  PVector vel;
  float grav=0.075;
  PFont font;
  int timer;    //set to 0 when item is dead & to be removed
  float theta;    //angle to show word at: -ve head topleft; +ve head topright
  float dTheta;
  float basePos;  //height of base of fountain
  color wCol;    //word colour e.g. 150,150,255
  float wordWidth;
  
  WordParticle(String nWord, PVector nPos, PFont nFont, float nbasePos, color nwCol)
  {
    word=nWord; 
    pos=new PVector(nPos.x, nPos.y);
    font=nFont;
    wordWidth=textWidth(word);

    wCol=nwCol;
    basePos=nbasePos;
    timer=350;
    vel=new PVector(random(-0.3, 0.3), random(-3, -2));
    theta=random(0, HALF_PI)*0.5;
    dTheta=random(0.005, 0.015);
    if (vel.x<0) {
      theta=-theta; 
      dTheta=-dTheta;
    }
    //println("New word " + word + " width " + wordWidth + " \tat (" + pos.x + "," + pos.y + ")");
  }

  void update() {
    vel.y=vel.y+grav;
    pos.add(vel);
    timer=timer-1;
    edgeCollisions();
    //    if (theta<=0) {theta=theta-0.01;}
    //    else {theta=theta+0.01;}
    theta=theta+dTheta;
  }

  void edgeCollisions() {
    if (pos.x < 50) {
      pos.x=50; 
      vel.x=abs(vel.x);
    }
    if (pos.x > width-50) {
      pos.x=width-50; 
      vel.x=-abs(vel.x);
    }
    float botPos=abs(sin(theta))*wordWidth*.5+pos.y;
    //point(pos.x,botPos); //show where the bottom-most point is
    if (botPos > basePos) {
      //timer=0;  //kill it 
	//println(word + " hit base (" + basePos + ") at " + round(botPos*100)/100.0 + " at angle " + round(theta*100)/100.0);
      pos.y = basePos - abs(sin(theta))*wordWidth*.5;
      vel.y=-abs(vel.y)*.5;
      vel.x*=2;
      vel.x=constrain(vel.x, -2, 2);
    }
  }

  void display() {
    pushMatrix();
    textFont(font); 
    textSize(14);
    //println(red(wCol) + " " + green(wCol) + " " + blue(wCol) + " a=" +timer/2);
    fill(wCol, timer/3.5);
    translate(pos.x, pos.y);
    rotateZ(theta);

    //rect(-20,-20,40,40);
    textAlign(CENTER);
    text(word, 0, 0);
    //stroke(255);
    //line(-wordWidth*.5,0,wordWidth*.5,0);
    //println("(" + pos.x + "," + pos.y + ") \t"+word + "\t theta="+theta);
    popMatrix();
  }
}

