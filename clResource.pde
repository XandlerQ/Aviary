color STDRESOURCECOLOR = #FFAA00;


/*class Resource{
  
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
  
}*/

class ResourceNet{
  
  int quadX;
  int quadY;
  float sideX;
  float sideY;
  float[][] quads;
  color cl = #FFFFFF;
  float maxRes;
  float repSpeed;
  
  //Constructors
  
  ResourceNet(){
    
    quadX = QUADX;
    quadY = QUADY;
    
    sideX = DEFX / QUADX;
    sideY = DEFY / QUADY;
    
    quads = new float[quadX][quadY];
    
    maxRes = MAXRES;
    repSpeed = RESREPSPEED;
    
    for(int i = 0; i < quadX; i++)
      for(int j = 0; j < quadY; j++)
          quads[i][j] = MAXRES / 2;
  }
  
  //Getters
  
  float getMaxRes(){
    return maxRes;
  }
  
  float getRes(int argI, int argJ){
    return quads[argI][argJ];
  }
  
  //Setters
  
  void setRepSpeed(float argRepSpeed){
    repSpeed = argRepSpeed;
  }
  
  //Methods
  
  float lowerRes(int argI, int argJ, float argAm){
    if(quads[argI][argJ] < argAm){
      float retRes = quads[argI][argJ];
      quads[argI][argJ] = 0;
      return retRes;
    }
    else{
      quads[argI][argJ] -= argAm;
      return argAm;
    }      
  }
  
  void replenish(){
    for(int i = 0; i < quadX; i++)
      for(int j = 0; j < quadY; j++){
        if(quads[i][j] < maxRes){
          quads[i][j] += repSpeed;
        }
      }
  }
  
  //Renderers
  
  void render()
  {
    noStroke();
    for(int i = 0; i < quadX; i++)
      for(int j = 0; j < quadY; j++){
        fill(cl, 50 * (quads[i][j]) / maxRes);
        rect(i * sideX, j * sideY, sideX, sideY);
        /*fill(cl, 50);
        circle(i * sideX + sideX/2, j * sideY + sideY/2, sideX * (quads[i][j]) / maxRes);*/
      }
  }
    
  
}
