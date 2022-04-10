color STDRESOURCECOLOR = #FFAA00;


class Resource{
  
  int type;                                                              //Type index
  float x, y;                                                            //Position
  int res;                                                               //Amount of resource held
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
  
  //Setters
  
  //Methods
  
  boolean lowerRes(){                                                    //Lower stored resource amount
    res--;
    size = 20 + res/10;
    return (res == 0);
    
  }
  
  //Renderers
    
  void render(){                                                         //Renders resource
    noStroke();
    fill(cl);
    circle(x, y, size);
  }
  
}

class ResourceNet{
  
  int quadX;
  int quadY;
  float[][] resNet;
  color cl = #FFAA00;
  float maxRes;
  float repSpeed;
  
  //Constructors
  
  ResourceNet(){
    
    quadX = QUADX;
    quadY = QUADY;
    
    resNet = new float[quadX][quadY];
    
    maxRes = MAXRES;
    repSpeed = RESREPSPEED;
    
    for(int i = 0; i < quadX; i++)
      for(int j = 0; j < quadY; j++)
        resNet[i][j] = MAXRES / 2;
  }
  
  //Getters
  
  float getMaxRes(){
    return maxRes;
  }
  
  float getRes(int argI, int argJ){
    return resNet[argI][argJ];
  }
  
  //Setters
  
  void setRepSpeed(float argRepSpeed){
    repSpeed = argRepSpeed;
  }
  
  //Methods
  
  float calculateX(int argI){
    float h = (DEFX / (quadX - 1));
    return argI * h;
  }
  
  float calculateY(int argJ){
    float h = (DEFY / (quadY - 1));
    return argJ * h;
  }
  
  float lowerRes(int argI, int argJ, float argAm){
    if(resNet[argI][argJ] < argAm){
      float retRes = resNet[argI][argJ];
      resNet[argI][argJ] = 0;
      return retRes;
    }
    else{
      resNet[argI][argJ] -= argAm;
      return argAm;
    }      
  }
  
  void replenish(){
    for(int i = 0; i < quadX; i++)
      for(int j = 0; j < quadY; j++){
        if(resNet[i][j] < maxRes){
          resNet[i][j] += repSpeed;
        }
      }
  }
  
  //Renderers
  
  void render()
  {
    noStroke();
    fill(cl, 40);
    
    for(int i = 0; i < quadX; i++)
      for(int j = 0; j < quadY; j++)
        circle(calculateX(i), calculateY(j), (resNet[i][j] / maxRes) * (DEFX / quadX));
  }
    
  
}
