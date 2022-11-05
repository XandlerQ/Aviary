color STDRESOURCECOLOR = #FFAA00;


class Resource{

  float x, y;                                                            //Position
  float res;                                                               //Amount of resource held
  float maxRes;
  float resRepSpeed;
  float size;
  color cl = #FFAA00;                                                    //Color
  int repCtr;
  int repCtrPeak;
  
  //Constructors
  
  Resource(){
    Random r = new Random();                                             //Randomizer
    x = DEFX/5 + (3 * DEFX / 5) * r.nextFloat();                         //
    y = DEFY/5 + (3 * DEFY / 5) * r.nextFloat();                         //Random position
    
    res = BASERES / 2;                                                            //Initial resource stored by default
    maxRes = BASERES;
    resRepSpeed = RESREPSPEED;
    updateSize();
    
    repCtr = 0;
    repCtrPeak = REPCTRPEAK;
  }
  
  Resource(float origX, float origY, float sideX, float sideY){
    this();
    Random r = new Random();
    x = origX + sideX/20 + (18 * sideX / 20) * r.nextFloat();                         //
    y = origY + sideY/20 + (18 * sideY / 20) * r.nextFloat();                         //Random position in square
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
  
  boolean empty(){
    return res <= 0;
  }
  
  //Setters
  
  void updateMaxRes(){
    maxRes = BASERES;
  }
  
  void updateResRepSpeed(){
    resRepSpeed = RESREPSPEED;
  }
  
  void updateRepDelay(){
    repCtrPeak = REPCTRPEAK;
  }
  
  //Methods
  
  void updateSize(){
    size = res;
  }
  
  float lowerRes(float amount){                                                    //Lower stored resource amount
    if (amount > res){
      float taken = res;
      res = 0;
      updateSize();
      repCtr = repCtrPeak;
      return taken;
    }
    else{
      res -= amount;
      updateSize();
      repCtr = repCtrPeak;
      return amount;
    }
  }
  
  void replenish(){
    if(repCtr != 0){
      repCtr--;
      return;
    }
    else{
      if(res < maxRes)
        res += resRepSpeed;
      if(res > maxRes)
        res = maxRes;
      updateSize();
    }
  }
  
  //Renderers
    
  void render(){                                                         //Renders resource
    noStroke();
    fill(cl, 255);
    circle(x, y, 2);
    fill(cl, 150);
    circle(x, y, size);
  }
  
}

class ResourceNet{
  
  int quadX;
  int quadY;
  float dimX;
  float dimY;
  int quadAmount;
  ArrayList<Resource> resources;  
  
  //Constructors
  
  ResourceNet(){
    quadX = QUADX;
    quadY = QUADY;
    dimX = DEFX / quadX;
    dimY = DEFY / quadY;
    quadAmount = RESPERQUAD;
    
    int resCount = QUADX * QUADY * RESPERQUAD;
    resources = new ArrayList<Resource>(resCount);
    
    for(int i = 0; i < quadX; i++){
      for(int j = 0; j < quadY; j++){
        for (int k = 0; k < quadAmount; k++){
          resources.add(new Resource(i * dimX, j * dimY, dimX, dimY));
        }
      }
    }
  }
  
  //Getters
  
  ArrayList<Resource> getResources(){
    return resources;
  }
  
  //Setters
  
  void updateMaxRes(){
    resources.forEach((res) -> {res.updateMaxRes();});
  }
  
  void updateResRepSpeed(){
    resources.forEach((res) -> {res.updateResRepSpeed();});
  }
  
  void updateRepDelay(){
    resources.forEach((res) -> {res.updateRepDelay();});
  }
  
  //Methods
  
  void replenish(){
    resources.forEach((res) -> {res.replenish();});
  }
  
  ArrayList<Resource> getVisibleResources(float posX, float posY, float radius){
    
    if(posX > DEFX)
      posX = DEFX;
    if(posY > DEFY)
      posY = DEFY;
    
    int posQuadX = 0;
    posQuadX = (int)((posX - (posX % dimX)) / dimX);
    if(posQuadX >= quadX)
      posQuadX = quadX - 1;
    int posQuadY = 0;
    posQuadY = (int)((posY - (posY % dimY)) / dimY);
    if(posQuadY >= quadY)
      posQuadY = quadY - 1;
    
    int moreL = 0;
    int moreR = 0;
    int moreT = 0;
    int moreB = 0;
    
    float radiusOverlapL = posQuadX * dimX - (posX - radius);
    float radiusOverlapR = (posX + radius) - (posQuadX + 1) * dimX;
    float radiusOverlapT = posQuadY * dimY - (posY - radius);
    float radiusOverlapB = (posY + radius) - (posQuadY + 1) * dimY;
    
    int quadLeftL = posQuadX;
    int quadLeftR = quadX - (posQuadX + 1);
    int quadLeftT = posQuadY;
    int quadLeftB = quadY - (posQuadY + 1);
    
    if(radiusOverlapL > 0){
      moreL = (int)((radiusOverlapL - radiusOverlapL % dimX) / dimX) + 1;
      if(moreL > quadLeftL){
        moreL = quadLeftL;
      }
    }
    if(radiusOverlapR > 0){
      moreR = (int)((radiusOverlapR - radiusOverlapR % dimX) / dimX) + 1;
      if(moreR > quadLeftR){
        moreR = quadLeftR;
      }
    }
    if(radiusOverlapT > 0){
      moreT = (int)((radiusOverlapT - radiusOverlapT % dimY) / dimY) + 1;
      if(moreT > quadLeftT){
        moreT = quadLeftT;
      }
    }
    if(radiusOverlapB > 0){
      moreB = (int)((radiusOverlapB - radiusOverlapB % dimY) / dimY) + 1;
      if(moreB > quadLeftB){
        moreB = quadLeftB;
      }
    }

    ArrayList<Resource> visibleRes = new ArrayList<Resource>();
    
    for(int i = posQuadX - moreL; i <= posQuadX + moreR; i++){
      for(int j = posQuadY - moreT; j <= posQuadY + moreB; j++){
        for(int k = 0; k < quadAmount; k++){
          visibleRes.add(resources.get(i * quadY * quadAmount + j * quadAmount + k));
        }
      }
    }
    
    return visibleRes;
  }
  
  //Renderers
  
  void render()
  {
    resources.forEach((res) -> {res.render();});
    stroke(#FFAA00, 100);
    strokeWeight(2);
    for(int i = 0; i < quadX + 1; i++){
      line(i * dimX, 0, i * dimX, DEFY);
    }
    for(int j = 0; j < quadY + 1; j++){
      line(0, j * dimY, DEFX, j * dimY);
    }
  }
    
  
}
