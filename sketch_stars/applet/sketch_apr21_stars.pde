
int numStars;
StarField sField;
float gridHeight, dGridHeight, maxGridHeight, gridSize;
int numThreads;
ArrayList threads;  //contains list of starThread
int gridAlpha;
int numGrids;    //how many squares in grid


void setup() {
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
    float R= 256.0-(( (float)i/numThreads)*256) % 256;
    float G=(((float)i/numThreads)*256) % 256 ;
    float B=(((float)i/numThreads)*256-128) % 256 + 128;
    //println("RBB=" + R +" " + G + " " + B);
    color threadCol= color(R, G, B);
    starThread thisThread=new starThread( threadCol);
    thisThread.addToPath( int(random(0, numStars)));  //add first star
    //threads.add(thisThread);
//  }
}

void draw() {
  //  lights();
  background(0);

  // Change height of the camera with mouseY
  //float eyeY = sin(-frameCount*.01)* 500;
  float eyeX = (sin(frameCount*.005));
  float eyeZ = (cos(frameCount*.005));
  float eyeY = sin(-.5-frameCount*.0001);
  float d=sqrt(pow(eyeX, 2) + pow(eyeY, 2) + pow(eyeZ, 2));    //distance from centre
  eyeX=500*eyeX/d;
  eyeY=500*eyeY/d;
  eyeZ=500*eyeZ/d;

  d=pow(eyeX, 2) + pow(eyeZ, 2) + pow(eyeY, 2);    //distance from centre

  camera(
  eyeX, eyeY, eyeZ, // eyeX, eyeY, eyeZ
  0.0, 0.0, 0.0, // centerX, centerY, centerZ
  0.0, 1.0, 0.0); // upX, upY, upZ


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

  for (float i=-gridSize; i<gridSize; i+=round(gridSize/((float)numGrids/2.0))) {
    line(i, -gridSize, i, gridSize); 
    line(-gridSize, i, gridSize, i);
  }
  popMatrix();
}

