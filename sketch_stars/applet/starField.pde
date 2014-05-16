

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

  void display() {

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

  void addSun() {
    stars[0]=new Stars(0, 0, 0, 7);
  }

  void display() {
    for (int i=0; i<numStars;i++) {
      stars[i].display();
    }
  }

  PVector getStarPos(int idx) {
    PVector pos = new PVector(stars[idx].loc.x, stars[idx].loc.y, stars[idx].loc.z);
    return pos;
  }
}

