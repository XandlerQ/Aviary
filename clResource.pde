color STDRESOURCECOLOR = #FFAA00;


class Resource{
  
  int type;                                                              //Type index
  float x, y;                                                            //Position
  float res;                                                               //Amount of resource held
  float size;
  color cl = #FFAA00;                                                    //Color
  
  //Constructors
  
  Resource(){
    Random r = new Random();                                             //Randomizer
    x = DEFX/5 + (3 * DEFX / 5) * r.nextFloat();                         //
    y = DEFY/5 + (3 * DEFY / 5) * r.nextFloat();                         //Random position
    
    type = 0;                                                            //Type 0 by default
    
    res = 200;                                                            //Initial resource stored by default
    size = 20 + res/10;
    
  }
  
  //Getters
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  float getSize(){
    return size;
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
  
  float lowerRes(float argRes){                                                    //Lower stored resource amount
    if(res < argRes){
      res = 0;
      return argRes;
    }
    else{
      res -= argRes;
      updateSize();
      return argRes;
    }
  }
  
  void updateSize(){
    size = 20 + res/10;
  }
  
  boolean empty(){
    return res <= 0;
  }
  
  //Renderers
    
  void render(){                                                         //Renders resource
    noStroke();
    fill(cl);
    circle(x, y, size);
  }
  
}
