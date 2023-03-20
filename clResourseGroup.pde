color STD_RES_GR_NET_COLOR = #FFAA00;

class ResourceGroup{
  private int grCtX;  //Amount of areas along X axis
  private int grCtY;  //Amount of areas along Y axis
  private float defX;  //Group dimension along X axis
  private float defY;  //Group dimension along Y axis
  private float sideX;  //Area dimension along X axis
  private float sideY;  //Area dimension along Y axis
  
  private int density;  //Amount of resource nodes in area
  private ArrayList<ResourceNode> resNodes;  //Resource nodes
  private int resCount;
  
  //--------------------------------------
  //-----------  Constructors  -----------
  //---------------------------------------
  
  ResourceGroup() {
    this.grCtX = 0;
    this.grCtY = 0;
    this.defX = 0;
    this.defY = 0;
    this.sideX = 0;
    this.sideY = 0;
    
    this.density = 0;
    this.resNodes = null;
    this.resCount = 0;
  }
  
  ResourceGroup(int grCtX, int grCtY, float defX, float defY, int density) {
    this.grCtX = grCtX;
    this.grCtY = grCtY;
    this.defX = defX;
    this.defY = defY;
    this.sideX = defX / grCtX;
    this.sideY = defY / grCtY;
    
    this.density = density;
    this.resCount = grCtX * grCtY * density;
    
    this.resNodes = new ArrayList<ResourceNode> (this.resCount);
    //ResourceNode(float maxRes, float fraction, float resRepSpeed, int repCtrPeak,
    //           Dot coordinates) {
  }
  
  //---------------------------------------
  //---------------------------------------
  
  //---------------------------------
  //-----------  Getters  -----------
  //---------------------------------
  
  ArrayList<ResourceNode> getResourceNodes(){
    return resNodes;
  }
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Setters  -----------
  //---------------------------------
  
  void setNodesMaxRes(float maxRes){
    this.resNodes.forEach((node) -> {node.setMaxRes(maxRes);});
  }
  
  void setNodesResRepSpeed(float resRepSpeed){
    this.resNodes.forEach((node) -> {node.setResRepSpeed(resRepSpeed);});
  }
  
  void setNodesRepCtrPeak(int repCtrPeak){
    this.resNodes.forEach((node) -> {node.setRepCtrPeak(repCtrPeak);});
  }
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Methods  -----------
  //---------------------------------
  
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
          this.resNodes.add(
            new ResourceNode(
              maxRes, 
              fraction, 
              resRepSpeed, 
              repCtrPeak, 
              getRndCoordInArea(i * sideX, j * sideY, sideX, sideY)
            )
          );
        }
      }
    }
  }
  
  void replenishNodes(){
    this.resNodes.forEach((node) -> {node.replenish();});
  }
  
  ArrayList<ResourceNode> getVisibleResNodes(float posX, float posY, float radius){
    
    if(posX > DEFX)
      posX = DEFX;
    if(posY > DEFY)
      posY = DEFY;
    
    int posQuadX = 0;
    posQuadX = (int)((posX - (posX % this.sideX)) / this.sideX);
    if(posQuadX >= this.grCtX)
      posQuadX = this.grCtX - 1;
    int posQuadY = 0;
    posQuadY = (int)((posY - (posY % this.sideY)) / this.sideY);
    if(posQuadY >= this.grCtY)
      posQuadY = this.grCtY - 1;
    
    int moreL = 0;
    int moreR = 0;
    int moreT = 0;
    int moreB = 0;
    
    float radiusOverlapL = posQuadX * this.sideX - (posX - radius);
    float radiusOverlapR = (posX + radius) - (posQuadX + 1) * this.sideX;
    float radiusOverlapT = posQuadY * this.sideY - (posY - radius);
    float radiusOverlapB = (posY + radius) - (posQuadY + 1) * this.sideY;
    
    int quadLeftL = posQuadX;
    int quadLeftR = this.grCtX - (posQuadX + 1);
    int quadLeftT = posQuadY;
    int quadLeftB = this.grCtY - (posQuadY + 1);
    
    if(radiusOverlapL > 0){
      moreL = (int)((radiusOverlapL - radiusOverlapL % this.sideX) / this.sideX) + 1;
      if(moreL > quadLeftL){
        moreL = quadLeftL;
      }
    }
    if(radiusOverlapR > 0){
      moreR = (int)((radiusOverlapR - radiusOverlapR % this.sideX) / this.sideX) + 1;
      if(moreR > quadLeftR){
        moreR = quadLeftR;
      }
    }
    if(radiusOverlapT > 0){
      moreT = (int)((radiusOverlapT - radiusOverlapT % this.sideY) / this.sideY) + 1;
      if(moreT > quadLeftT){
        moreT = quadLeftT;
      }
    }
    if(radiusOverlapB > 0){
      moreB = (int)((radiusOverlapB - radiusOverlapB % this.sideY) / this.sideY) + 1;
      if(moreB > quadLeftB){
        moreB = quadLeftB;
      }
    }

    ArrayList<ResourceNode> visibleResNodes = new ArrayList<ResourceNode>();
    
    for(int i = posQuadX - moreL; i <= posQuadX + moreR; i++){
      for(int j = posQuadY - moreT; j <= posQuadY + moreB; j++){
        for(int k = 0; k < this.density; k++){
          visibleResNodes.add(this.resNodes.get(i * this.grCtY * this.density + j * this.density + k));
        }
      }
    }
    
    return visibleResNodes;
  }
  
  //Renderers
  
  void render()
  {
    this.resNodes.forEach((node) -> {node.render();});
    stroke(STD_RES_GR_NET_COLOR, 100);
    strokeWeight(2);
    for(int i = 0; i < this.grCtX + 1; i++){
      line(i * this.sideX, 0, i * this.sideX, this.defY);
    }
    for(int j = 0; j < this.grCtY + 1; j++){
      line(0, j * this.sideY, this.defX, j * this.sideY);
    }
  }
    
  
}
