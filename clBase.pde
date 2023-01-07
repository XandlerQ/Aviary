color STDBASECOLOR = #3483FF;


class Base{
  
  float x, y;                                                                        //Position
  float res;                                                                         //Array for stored resources by type
  float maxRes;
  color cl = #3483FF;                                                                //Base color
  float size = 40;                                                                   //Base size px
  
  //Constructors
  
  Base(){
    Random r = new Random();                                                         //Randomizer
    x = DEFX/5 + (3 * DEFX / 5) * r.nextFloat();                                     //
    y = DEFY/5 + (3 * DEFY / 5) * r.nextFloat();                                     //Random position
    maxRes = 50;
    res = 0;                                                        //Make stored resources by type array
  }
  
  //Getters
  
  float getSize(){
    return size;
  }
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  float getRadius(){
    return size/2;
  }
  
  //Setters
  
  void setPos(float argX, float argY){
    x = argX;
    y = argY;
  }
  
  //Methods
  
  void addRes(float argRes){                                         //Adds resource to storage
    if(res + argRes > maxRes){
      res = maxRes;
    }
    else{
      res += argRes;
    }
  }
  
  //Renderers
  
  void render()                                                                      //Renders base
  {
    noStroke();
    fill(cl);
    circle(x, y, size);
  }
  
}
