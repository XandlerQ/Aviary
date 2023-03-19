

class ResourceGroup{
  private int grCtX;  //Amount of areas along X axis
  private int grCtY;  //Amount of areas along Y axis
  private float defX;  //Group dimension along X axis
  private float defY;  //Group dimension along Y axis
  private int density;  //Amount of resource nodes in area
  private ArrayList<ResourceNode> resNodes;  //Resource nodes
  private int resCount;
  
  //Constructors
  
  ResourceGroup() {
    this.grCtX = 0;
    this.grCtY = 0;
    this.defX = 0;
    this.defY = 0;
    this.density = 0;
    this.resNodes = null;
    this.resCount = 0;
  }
  
  ResourceGroup(int grCtX, int grCtY, float defX, float defY, int density) {
    this.grCtX = grCtX;
    this.grCtY = grCtY;
    this.defX = defX;
    this.defY = defY;
    this.density = density;
    this.resCount = grCtX * grCtY * density;
    
    this.resNodes = new ArrayList<ResourceNode> (this.resCount);
    //ResourceNode(float maxRes, float fraction, float resRepSpeed, int repCtrPeak,
    //           Dot coordinates) {
  }
    
    
  Dot getRndCoordInArea(float origX, float origY, float sideX, float sideY) {
    Random r = new Random();
    Dot coordinates = new Dot();
    coordinates.setX(origX + sideX/20 + (18 * sideX / 20) * r.nextFloat());
    coordinates.setY(origY + sideY/20 + (18 * sideY / 20) * r.nextFloat());
    return coordinates;
  }
  
  void fillResNodes(float maxRes, float fraction, float resRepSpeed, int repCtrPeak) {
    for(int i = 0; i < grCtX; i++){
      for(int j = 0; j < grCtY; j++){
        for (int k = 0; k < density; k++){
          resNodes.add(
            new ResourceNode(
              maxRes, 
              fraction, 
              resRepSpeed, 
              repCtrPeak, 
              getRndCoordInArea(i * defX, j * defY, defX, defY)
            )
          );
        }
      }
    }
  }
  
  //Getters
  
  ArrayList<Resource> getResources(){
    return resNodes;
  }
  
  //Setters
  
  void updateMaxRes(){
    resNodes.forEach((res) -> {res.updateMaxRes();});
  }
  
  void updateResRepSpeed(){
    resNodes.forEach((res) -> {res.updateResRepSpeed();});
  }
  
  void updateRepDelay(){
    resNodes.forEach((res) -> {res.updateRepDelay();});
  }
  
  //Methods
  
  void replenish(){
    resNodes.forEach((res) -> {res.replenish();});
  }
  
  ArrayList<Resource> getVisibleResources(float posX, float posY, float radius){
    
    if(posX > DEFX)
      posX = DEFX;
    if(posY > DEFY)
      posY = DEFY;
    
    int posQuadX = 0;
    posQuadX = (int)((posX - (posX % defX)) / defX);
    if(posQuadX >= grCtX)
      posQuadX = grCtX - 1;
    int posQuadY = 0;
    posQuadY = (int)((posY - (posY % defY)) / defY);
    if(posQuadY >= grCtY)
      posQuadY = grCtY - 1;
    
    int moreL = 0;
    int moreR = 0;
    int moreT = 0;
    int moreB = 0;
    
    float radiusOverlapL = posQuadX * defX - (posX - radius);
    float radiusOverlapR = (posX + radius) - (posQuadX + 1) * defX;
    float radiusOverlapT = posQuadY * defY - (posY - radius);
    float radiusOverlapB = (posY + radius) - (posQuadY + 1) * defY;
    
    int quadLeftL = posQuadX;
    int quadLeftR = grCtX - (posQuadX + 1);
    int quadLeftT = posQuadY;
    int quadLeftB = grCtY - (posQuadY + 1);
    
    if(radiusOverlapL > 0){
      moreL = (int)((radiusOverlapL - radiusOverlapL % defX) / defX) + 1;
      if(moreL > quadLeftL){
        moreL = quadLeftL;
      }
    }
    if(radiusOverlapR > 0){
      moreR = (int)((radiusOverlapR - radiusOverlapR % defX) / defX) + 1;
      if(moreR > quadLeftR){
        moreR = quadLeftR;
      }
    }
    if(radiusOverlapT > 0){
      moreT = (int)((radiusOverlapT - radiusOverlapT % defY) / defY) + 1;
      if(moreT > quadLeftT){
        moreT = quadLeftT;
      }
    }
    if(radiusOverlapB > 0){
      moreB = (int)((radiusOverlapB - radiusOverlapB % defY) / defY) + 1;
      if(moreB > quadLeftB){
        moreB = quadLeftB;
      }
    }

    ArrayList<Resource> visibleRes = new ArrayList<Resource>();
    
    for(int i = posQuadX - moreL; i <= posQuadX + moreR; i++){
      for(int j = posQuadY - moreT; j <= posQuadY + moreB; j++){
        for(int k = 0; k < density; k++){
          visibleRes.add(resNodes.get(i * grCtY * density + j * density + k));
        }
      }
    }
    
    return visibleRes;
  }
  
  //Renderers
  
  void render()
  {
    resNodes.forEach((res) -> {res.render();});
    stroke(#FFAA00, 100);
    strokeWeight(2);
    for(int i = 0; i < grCtX + 1; i++){
      line(i * defX, 0, i * defX, DEFY);
    }
    for(int j = 0; j < grCtY + 1; j++){
      line(0, j * defY, DEFX, j * defY);
    }
  }
    
  
}
