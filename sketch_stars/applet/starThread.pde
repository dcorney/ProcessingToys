

class starThread
{
  ArrayList path;      //list of stars already connected
  int nextStar;      //where we're heading next
  int lastStar;       //where we're heading from
  float d;            //how far along the path we've gone (0...1)
  float speed;        //speed of movement
  color threadCol;     //colour of thread

  starThread(color newCol)
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


  void addToPath(int idx) {

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

  void display() {



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

      stroke(threadCol, int( (float)i/path.size()*255));
      if (i> (int)(path.size()*0.5))
      {strokeWeight(2);  }
      else {  strokeWeight(1); }
      line(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z);
      strokeWeight(1);
    }
  }

  void move() {
    d=d+speed;
    if (d<.5) {
      speed=speed+0.001;
    }
    if (d>.5) {
      speed=speed-0.001;
    }   
    if (d>=1) {
      d=0;
      speed=0.005;
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

