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
  color cl = #03FFF9;
  float[][] maxRes;
  float repSpeed;
  
  //Constructors
  
  ResourceNet(){
    
    quadX = QUADX;
    quadY = QUADY;
    
    sideX = DEFX / QUADX;
    sideY = DEFY / QUADY;
    
    quads = new float[quadX][quadY];
    maxRes = new float[quadX][quadY];
    
    repSpeed = RESREPSPEED;
    
    if(RESTYPE == 0){
      for(int i = 0; i < quadX; i++)
        for(int j = 0; j < quadY; j++){
            quads[i][j] = BASERES / 2;
            maxRes[i][j] = BASERES;
        }  
    }
    if(RESTYPE == 1){
      
      for(int i = 0; i < quadX; i++){
        for(int j = 0; j < quadY; j++){
            quads[i][j] = BASERES / 2 - BASERES * (Math.abs((float)i - (quadX - 1) / 2) / (quadX - 1)) / 2;
            maxRes[i][j] = BASERES - BASERES * (Math.abs((float)i - (quadX - 1) / 2) / (quadX - 1));
        }
      }
    }
    if(RESTYPE == 2){
      for(int i = 0; i < quadX; i++){
        for(int j = 0; j < quadY; j++){
            quads[i][j] = BASERES / 2 - BASERES * ((Math.abs((float)i - (quadX - 1) / 2) / (quadX - 1)) + (Math.abs((float)j - (quadY - 1) / 2) / (quadY - 1))) / 4;
            maxRes[i][j] = BASERES - BASERES * ((Math.abs((float)i - (quadX - 1) / 2) / (quadX - 1)) + (Math.abs((float)j - (quadY - 1) / 2) / (quadY - 1))) / 2;
        }
      }
    }
    else if (RESTYPE == 3){
      Random r = new Random();
      for(int i = 0; i < quadX; i++){
        for(int j = 0; j < quadY; j++){
            quads[i][j] = BASERES * r.nextFloat() / 1.5;
            maxRes[i][j] = BASERES - BASERES * r.nextFloat() / 1.5;
        }
      }
    }
  }
  
  //Getters
  
  float getMaxRes(int argI, int argJ){
    return maxRes[argI][argJ];
  }
  
  float getRes(int argI, int argJ){
    return quads[argI][argJ];
  }
  
  //Setters
  
  void setRepSpeed(float argRepSpeed){
    repSpeed = argRepSpeed;
  }
  
  //Methods
  
  void updateMaxRes(){
    if(RESTYPE == 0){
      for(int i = 0; i < quadX; i++)
        for(int j = 0; j < quadY; j++){
            maxRes[i][j] = BASERES;
        }  
    }
    if(RESTYPE == 1){
      
      for(int i = 0; i < quadX; i++){
        for(int j = 0; j < quadY; j++){
            maxRes[i][j] = BASERES - BASERES * (Math.abs((float)i - (quadX - 1) / 2) / (quadX - 1));
        }
      }
    }
    if(RESTYPE == 2){
      for(int i = 0; i < quadX; i++){
        for(int j = 0; j < quadY; j++){
            maxRes[i][j] = BASERES - BASERES * ((Math.abs((float)i - (quadX - 1) / 2) / (quadX - 1)) + (Math.abs((float)j - (quadY - 1) / 2) / (quadY - 1))) / 2;
        }
      }
    }
    else if (RESTYPE == 3){
      Random r = new Random();
      for(int i = 0; i < quadX; i++){
        for(int j = 0; j < quadY; j++){
            maxRes[i][j] = BASERES - BASERES * r.nextFloat() / 1.5;
        }
      }
    }
  }
  
  void updateResRepSpeed(){
    repSpeed = RESREPSPEED;
  }
    
  
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
        if(quads[i][j] < maxRes[i][j]){
          quads[i][j] += repSpeed;
        }
        else
        {
          quads[i][j] = maxRes[i][j];
        }
      }
  }
  
  //Renderers
  
  void render()
  {
    noStroke();
    for(int i = 0; i < quadX; i++)
      for(int j = 0; j < quadY; j++){
        fill(cl, 50 * (quads[i][j]) / BASERES);
        rect(ORIGINX + i * sideX, ORIGINY + j * sideY, sideX, sideY);
        /*fill(cl, 50);
        circle(i * sideX + sideX/2, j * sideY + sideY/2, sideX * (quads[i][j]) / maxRes);*/
      }
  }
    
  
}
