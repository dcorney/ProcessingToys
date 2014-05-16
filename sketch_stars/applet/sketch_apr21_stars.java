import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class sketch_apr21_stars extends PApplet {


int numStars;
StarField sField;
float gridHeight, dGridHeight, maxGridHeight, gridSize;
int numThreads;
ArrayList threads;  //contains list of starThread
int gridAlpha;
int numGrids;    //how many squares in grid


public void setup() {
  size(1200, 800, P3D);
  numStars=700;
  sField=new StarField(numStars);
  //sField.addSun();
  frameRate(25);
  maxGridHeight=125;
  gridHeight=maxGridHeight;
  dGridHeight=1;
  gridAlpha=0;
  gridSize=200;
  numGrids=3;
  numThreads=3;
  //threads=new starThread[numThreads];
  threads=new ArrayList();
//  for (int i=0; i<numThreads;i++) {
  int i=0;
    float R= 256.0f-(( (float)i/numThreads)*256) % 256;
    float G=(((float)i/numThreads)*256) % 256 ;
    float B=(((float)i/numThreads)*256-128) % 256 + 128;
    //println("RBB=" + R +" " + G + " " + B);
    int threadCol= color(R, G, B);
    starThread thisThread=new starThread( threadCol);
    thisThread.addToPath( PApplet.parseInt(random(0, numStars)));  //add first star
    //threads.add(thisThread);
//  }
}

public void draw() {
  //  lights();
  background(0);

  // Change height of the camera with mouseY
  //float eyeY = sin(-frameCount*.01)* 500;
  float eyeX = (sin(frameCount*.005f));
  float eyeZ = (cos(frameCount*.005f));
  float eyeY = sin(-.5f-frameCount*.0001f);
  float d=sqrt(pow(eyeX, 2) + pow(eyeY, 2) + pow(eyeZ, 2));    //distance from centre
  eyeX=500*eyeX/d;
  eyeY=500*eyeY/d;
  eyeZ=500*eyeZ/d;

  d=pow(eyeX, 2) + pow(eyeZ, 2) + pow(eyeY, 2);    //distance from centre

  camera(
  eyeX, eyeY, eyeZ, // eyeX, eyeY, eyeZ
  0.0f, 0.0f, 0.0f, // centerX, centerY, centerZ
  0.0f, 1.0f, 0.0f); // upX, upY, upZ


  if (frameCount % 500 == 0 && frameCount>50) {
    if (threads.size()<numThreads){
        starThread thisThread=new starThread();
        threads.add(thisThread);
    }
    //thread1.addToPath( int(random(0, numStars)));
    //println("Added star\n");
  }
  
  if (frameCount % 10 ==0 && gridAlpha<200 && frameCount>50) {
    gridAlpha++;
  }

  //   println("Eye at " + int(eyeX) + "," + int(eyeY) + "," + int(eyeZ) + " d=" + int(d));

  sField.display();
  for (int i=0; i<threads.size();i++) {
    starThread thisThread = (starThread)threads.get(i);
    thisThread.move();
    thisThread.display();
  }

  //move grid
  gridHeight+=dGridHeight;
  //hit top
  if (gridHeight > maxGridHeight) {
    gridHeight= maxGridHeight; 
    dGridHeight=-dGridHeight;
    
  }
  //hit bottom
  if (gridHeight <-maxGridHeight) {
    gridHeight=-maxGridHeight; 
    dGridHeight=-dGridHeight;
    if (numGrids<10) {numGrids++;}
  }  
  //draw grid
  pushMatrix();
  noFill();
  stroke(200, 200, 255, gridAlpha);
  box(gridSize*2, maxGridHeight*2, gridSize*2);
  popMatrix();
  pushMatrix();
  rotateX(PI/2);
  translate(0, 0, gridHeight);
  stroke(200, 200, 255, gridAlpha);

  rect(-gridSize, -gridSize, gridSize*2, gridSize*2);

  for (float i=-gridSize; i<gridSize; i+=round(gridSize/((float)numGrids/2.0f))) {
    line(i, -gridSize, i, gridSize); 
    line(-gridSize, i, gridSize, i);
  }
  popMatrix();
}



class Stars
{
  PVector loc;
  float r;

  Stars(float x, float y, float z, float sz) {
    loc=new PVector();
    loc.x=x; 
    loc.y=y; 
    loc.z=z;
    r=sz;    //radius
  } 

  public void display() {

    //point(loc.x,loc.y,loc.z);
    if (r==1) {
      stroke(255);    
      point(loc.x, loc.y, loc.z);
    }
    else {

      pushMatrix();

      noStroke();
      fill(255, 255, 200);
      translate(loc.x, loc.y, loc.z);
      sphere(r);

      popMatrix();
    }
  }
}

class StarField
{
  Stars[] stars;
  int numStars;

  StarField(int numNewStars) {
    numStars=numNewStars;
    stars= new Stars[numStars];
    for (int i=0; i<numStars;i++) {
      //random(-width/2,width/2), random(-height/2,height/2), random(-100,100)
      //float x=exp(-pow(random(1),2));
      float x = sqrt( -2 * (log(random(1)))) * cos(2  * PI * random(1)) *width/20;
      float y=  sqrt( -2 * (log(random(1)))) * sin(2  * PI * random(1)) *width/40;
      float z= sqrt( -2 * (log(random(1)))) * cos(2  * PI * random(1)) *width/20;
      //println("x= " + x + " y= " + y + " z= " + z);  
      float r = random(1);
      if (r<9) 
      {
        r=1;
      }
      else
      { 
        r=random(2);
      }
      stars[i]=new Stars(x, y, z, r);
    }
  }

  public void addSun() {
    stars[0]=new Stars(0, 0, 0, 7);
  }

  public void display() {
    for (int i=0; i<numStars;i++) {
      stars[i].display();
    }
  }

  public PVector getStarPos(int idx) {
    PVector pos = new PVector(stars[idx].loc.x, stars[idx].loc.y, stars[idx].loc.z);
    return pos;
  }
}



class starThread
{
  ArrayList path;      //list of stars already connected
  int nextStar;      //where we're heading next
  int lastStar;       //where we're heading from
  float d;            //how far along the path we've gone (0...1)
  float speed;        //speed of movement
  int threadCol;     //colour of thread

  starThread(int newCol)
  {
    path=new ArrayList(); 
    threadCol=newCol;
  }

  starThread()
  {
    float R= random(0, 256);
    float G= random(0, 256);
    float B= random(0, 256);
    ;
    //println("RBB=" + R +" " + G + " " + B);
    threadCol= color(R, G, B);
    path=new ArrayList(); 
    //    threadCol=newCol;
  }


  public void addToPath(int idx) {

    //start path towards next star; only when we reach it, do we add that star to the path
    //path.add(new starId(idx));
    nextStar=idx;
    if (path.size()>0) {
      starId thisStar=(starId)path.get(path.size()-1);
      lastStar=thisStar.id;
      d=0;
    }
    else
    {
      d=1;
      path.add(new starId(idx));
    }

    if (path.size()>12) {
      path.remove(0);
    }
  }

  public void display() {



    //show current journey
    PVector home=sField.getStarPos(lastStar);
    PVector dest=sField.getStarPos(nextStar);
    if (d>0) {
      float toX= (dest.x-home.x)*d + home.x;
      float toY= (dest.y-home.y)*d + home.y;    
      float toZ= (dest.z-home.z)*d + home.z;
      stroke(threadCol);
      strokeWeight(2);
      line(home.x, home.y, home.z, toX, toY, toZ);
      strokeWeight(1);
      pushMatrix();
      translate(toX, toY, toZ);
      sphere(1);
      strokeWeight(1);
      popMatrix();
    }

    if (path.size()<2)
    {
      return;
    }   //nothing more to show...

    //show completed path
    for (int i=1; i< path.size(); i++) {
      starId starId1=(starId)(path.get(i-1));
      starId starId2=(starId)path.get(i);
      PVector pos1=sField.getStarPos(starId1.id);
      PVector pos2=sField.getStarPos(starId2.id);

      stroke(threadCol, PApplet.parseInt( (float)i/path.size()*255));
      if (i> (int)(path.size()*0.5f))
      {strokeWeight(2);  }
      else {  strokeWeight(1); }
      line(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z);
      strokeWeight(1);
    }
  }

  public void move() {
    d=d+speed;
    if (d<.5f) {
      speed=speed+0.001f;
    }
    if (d>.5f) {
      speed=speed-0.001f;
    }   
    if (d>=1) {
      d=0;
      speed=0.005f;
      path.add(new starId(nextStar));    //we got to our destination!

      //add another target
      int tournSize=10;    //tournament selection
      float nearestD=100000000;
      int bestSoFar=0;
      for (int i=0; i<tournSize;i++)
      {
        int next= (int)random(0, numStars);
        PVector pos1=sField.getStarPos(next);
        //starId starId2=(starId)path.get(path.size()-1);  //where we just arrived...
        PVector pos2=sField.getStarPos(nextStar);    //where we just arrived...
        float dd=PVector.dist(pos1,pos2);
        if (dd<nearestD) {
         nearestD=dd;
         bestSoFar=next;
        }
      }
      addToPath(bestSoFar);

    }
  }
}

class starId
{
  int id;
  starId(int newId) {
    id=newId;
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--stop-color=#cccccc", "sketch_apr21_stars" });
  }
}
