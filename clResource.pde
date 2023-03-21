import java.util.concurrent.atomic.AtomicInteger;

color STD_RESNODE_COLOR = #FFAA00;
float STD_RESNODE_SIZE = 20;

class Resource {
  protected float res;  //Resource currently stored
  protected float maxRes;  //Max resource amount
  protected float resRepSpeed;  //Resource replenishment speed
  protected int repCtr;  //Replenishment counter
  protected int repCtrPeak;  //Replenishment counter peak
  
  //--------------------------------------
  //-----------  Constructors  -----------
  //---------------------------------------
  
  Resource() {  //Default constructor
    this.res = 0;  //Empty by default
    this.maxRes = 0;  //Zero capacity
    this.resRepSpeed = 0;  //No replenishment speed
    this.repCtr = 0;  //Standard replenishment counter value
    this.repCtrPeak = 0;  //No replenishment counter peak
  }
  
  Resource(float maxRes, float fraction, float resRepSpeed, int repCtrPeak) {  
    //maxRes - Resource capacity;
    //fraction - initial resource amount coefficiency, assumed to be in range [0; 1];
    //resRepSpeed - resource replenishment speed per tick;
    //repCtrPeak - peak value for replenishment counter, determines frequency of resource replenishment.
    this.res = maxRes * fraction;
    this.maxRes = maxRes;
    normalizeRes();  //Normalizes initial this.res value
    this.resRepSpeed = resRepSpeed;
    this.repCtr = 0;
    this.repCtrPeak = repCtrPeak;
    normalizeRepCtrPeak(); //Normalizes initial this.repCtrPeak value
  }
  
  //---------------------------------------
  //---------------------------------------
  
  //---------------------------------
  //-----------  Getters  -----------
  //---------------------------------
  
  float getRes() {  //Returns current this.res value
    return this.res;
  }
  
  boolean empty() {  //Returns boolean for current this.res value being considered empty
    return this.res <= 0;
  }
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Setters  -----------
  //---------------------------------
  
  void setMaxRes(float maxRes) {  //Sets maximum resource amount
    this.maxRes = maxRes;
  }
  
  void setRepCtrPeak(int repCtrPeak) {  //Sets replenishment counter peak
    this.repCtrPeak = repCtrPeak;
  }
  
  void setResRepSpeed(float resRepSpeed) {  //Sets replenishment speed
    this.resRepSpeed = resRepSpeed;
  }  
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Methods  -----------
  //---------------------------------
  
  void normalizeRes() {  //Normalizes current this.res value by projecting it to [0; maxRes]
    if (this.res > this.maxRes) {
      this.res = this.maxRes;
    }
    if (this.res < 0) {
      this.res = 0;
    }
  }
  
  void normalizeRepCtrPeak() { //Normalizes replenishment counter by assuring it is not lower then 0
    if(this.resRepPeak < 0) {
      this.resRepPeak = 0;
    }
  }
  

  float lowerRes(float amount){  //Lowers current this.res by amount
    if (amount > this.res){  //If amount is greater then currently stored resource amount
      float taken = this.res;  //Make new variable representing maximum possible resource withdraw
      this.res = 0;  //Set current resource stored to 0
      this.repCtr = this.repCtrPeak;  //As soon as resource is withdrawn, delay replenishment by this.repCtrPeak frames
      return taken;  //Return maximum possible resource withdraw
    }
    else{  //If amount is less then currently stored resource amount
      this.res -= amount;  //Lower resource currently stored by amount
      this.repCtr = this.repCtrPeak;  //As soon as resource is withdrawn, delay replenishment by this.repCtrPeak frames
      return amount;  //Return withdrawn amount
    }
  }
  
  void replenish(){  //Handles replenishment counter and replenishes stored resource
    if(this.repCtr != 0){  //If the replenishment counter is not 0
      this.repCtr--;  //Lower the replenishment counter
      return;
    }
    else{  //If the replenishment counter is 0
      if(this.res < this.maxRes)  //If resource currently stored is not at maximum
        this.res += this.resRepSpeed;  //Replenish resource currently stored
      if(this.res > this.maxRes)  //If resource currently stored is greater then maximum
        this.res = this.maxRes;  //Set resource currently stored as maximum
    }
  }
  
  //---------------------------------
  //---------------------------------
  
}








AtomicInteger resIdGen = new AtomicInteger(0);


class ResourceNode extends Resource {
  private final int id;
  private Dot coordinates;
  private float size;
  private color cl;
  
  //--------------------------------------
  //-----------  Constructors  -----------
  //---------------------------------------
  
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
  
  //---------------------------------------
  //---------------------------------------
  
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
  
  //---------------------------------
  //-----------  Methods  -----------
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
  
  //---------------------------------
  //---------------------------------
  
  //-----------------------------------
  //-----------  Renderers  -----------
  //-----------------------------------
  
  
  void render(){
    noStroke();
    fill(cl, 255);
    circle(this.coordinates.getX(), this.coordinates.getY(), 2);
    fill(cl, 150);
    circle(this.coordinates.getX(), this.coordinates.getY(), size);
  }
  
  //-----------------------------------
  //-----------------------------------
  
  
}
