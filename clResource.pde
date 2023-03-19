import java.util.concurrent.atomic.AtomicInteger;

color STD_RESNODE_COLOR = #FFAA00;
float STD_RESNODE_SIZE = 20;

class Resource {
  protected float res;  //Current resource amount
  protected float maxRes;  //Max resource amount
  protected float resRepSpeed;
  protected int repCtr;  //Replenishment counter
  protected int repCtrPeak;  //Replenishment counter peak
  
  Resource() {
    this.res = 0;
    this.maxRes = 0;
    this.resRepSpeed = 0;
    this.repCtr = 0;
    this.repCtrPeak = 0;
  }
  
  Resource(float maxRes, float fraction, float resRepSpeed, int repCtrPeak) {
    this.res = maxRes * fraction;  //fraction is assumed to be in range [0; 1]
    this.maxRes = maxRes;
    normalizeRes();
    this.resRepSpeed = resRepSpeed;
    this.repCtr = 0;
    this.repCtrPeak = repCtrPeak;
  }
  
  //---------------------------------
  //-----------  Getters  -----------
  //---------------------------------
  
  float getRes() {
    return this.res;
  }
  
  boolean empty() {
    return this.res <= 0;
  }
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Setters  -----------
  //---------------------------------
  
  void setMaxRes(float maxRes) {
    this.maxRes = maxRes;
  }
  
  void setRepCtrPeak(int repCtrPeak) {
    this.repCtrPeak = repCtrPeak;
  }
  
  void setResRepSpeed(float resRepSpeed) {
    this.resRepSpeed = resRepSpeed;
  }  
  
  //---------------------------------
  //---------------------------------
  
  void normalizeRes() {
    if (this.res > this.maxRes) {
      this.res = this.maxRes;
    }
    if (this.res < 0) {
      this.res = 0;
    }
  }
  

  float lowerRes(float amount){
    if (amount > this.res){
      float taken = this.res;
      this.res = 0;
      this.repCtr = this.repCtrPeak;
      return taken;
    }
    else{
      this.res -= amount;
      this.repCtr = this.repCtrPeak;
      return amount;
    }
  }
  
  void replenish(){
    if(this.repCtr != 0){
      this.repCtr--;
      return;
    }
    else{
      if(this.res < this.maxRes)
        this.res += this.resRepSpeed;
      if(this.res > this.maxRes)
        this.res = this.maxRes;
    }
  }
}








AtomicInteger resIdGen = new AtomicInteger(0);


class ResourceNode extends Resource {
  private final int id;
  private Dot coordinates;
  private float size;
  private color cl;
  
  ResourceNode() {
    super();
    this.id = resIdGen.incrementAndGet();
    this.coordinates = null;
    this.size = 0;
    this.cl = STD_RESNODE_COLOR;
  }
  
  ResourceNode(float maxRes, float fraction, float resRepSpeed, int repCtrPeak,
               float x, float y) {
    super(maxRes, fraction, resRepSpeed, repCtrPeak);
    this.id = resIdGen.incrementAndGet();
    this.coordinates = new Dot(x, y);
    this.size = STD_RESNODE_SIZE * super.res / super.maxRes;
    this.cl = STD_RESNODE_COLOR;
  }
  
  ResourceNode(float maxRes, float fraction, float resRepSpeed, int repCtrPeak,
               Dot coordinates) {
    this(maxRes, fraction, resRepSpeed, repCtrPeak, coordinates.getX(), coordinates.getY());
  }
  
  //---------------------------------
  //-----------  Getters  -----------
  //---------------------------------
  
  int getId() {
    return this.id;
  }
  
  float getX() {
    return this.coordinates.getX();
  }
  
  float getY() {
    return this.coordinates.getY();
  }
  
  Dot getCoordinates() {
    return this.coordinates;
  }
  
  float getSize() {
    return this.size;
  }
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Setters  -----------
  //---------------------------------
  
  void setCoordinates(float x, float y) {
    this.coordinates.setXY(x, y);
  }
  
  void setColor(color cl) {
    this.cl = cl;
  }
  
  //---------------------------------
  //---------------------------------
  
  void recalculateSize() {
    this.size = STD_RESNODE_SIZE * this.res / this.maxRes;
  }
  
  
  
  @Override
  public boolean equals(Object obj){
    if (this == obj)
      return true;
    if (obj == null)
      return false;
    ResourceNode arg = (ResourceNode) obj;
    return this.id == arg.getId();
  }
  
  
  void render(){
    noStroke();
    fill(cl, 255);
    circle(this.coordinates.getX(), this.coordinates.getY(), 2);
    fill(cl, 150);
    circle(this.coordinates.getX(), this.coordinates.getY(), size);
  }
  
  
}
