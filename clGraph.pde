class TimeGraph {
  
  public static enum Mode {
    SCROLLING, STATIONARY
  }
  
  private int originX;
  private int originY;
  
  private int dimX;
  private int dimY;
  
  private int capacity;
  
  private boolean filled;
  
  private int mode;
  
  private ArrayList<Dot> dots;
  
  private float maxY;
  private float minY;
  
  //Colors
  
  color plainCl;
  color borderCl;
  color dotCl;
  color lineCl;
  color levelLineCl;
  color valueTextCl;
  
    
  //--------------------------------------
  //-----------  Constructors  -----------
  //---------------------------------------
  
  TimeGraph() {
    this.originX = 0;
    this.originY = 0;
    this.dimX = 200;
    this.dimY = 100;
    this.capacity = 0;
    this.mode = 0;
    this.dots = new ArrayList<Dot>();
    this.maxY = 0;
    this.minY = 0;
  }
  
  TimeGraph(int capacity) {
    this();
    this.capacity = capacity;
  }
  
  TimeGraph(int dimX, int dimY, int capacity) {
    this(capacity);
    this.dimX = dimX;
    this.dimY = dimY;
  }
  
  TimeGraph(int dimX, int dimY, int capacity, int mode) {
    this(dimX, dimY, capacity);
    this.mode = mode;
  }
  
  //---------------------------------------
  //---------------------------------------
  
  //---------------------------------
  //-----------  Getters  -----------
  //---------------------------------
  
  int getDimX() { return this.dimX; }
  int getDimY() { return this.dimY; }
  
  int getCapacity() { return this.capacity; }
  
  int filled() { return this.filled; }
  
  ArrayList<Dot> getDots() { return this.dots; }
  
  float getValue(int index) {
    if(index < 0 || index >= this.dots.size()) {
      return null;
    }
    
    return this.dots.get(index);
  }
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Setters  -----------
  //---------------------------------
  
  void setOriginX(int originX) { this.originX = originX; }
  void setOriginY(int originY) { this.originY = originY; }
  
  void setOrigin(int originX, int originY) {
    this.originX = originX;
    this.originY = originY;
  }
  
  void setDimX(int dimX) { this.dimX = dimX; }
  void setDimY(int dimY) { this.dimY = dimY; }
  
  void setCapacity(int capacity) { this.capacity = capacity; }
  
  void setMode(int mode) { this.mode = mode; }
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Methods  -----------
  //---------------------------------
  
  void addValue(float val) {
    
    Dot newDot = new Dot(millis() / 1000, val);
    
    if(filled) {
      if(mode == STATIONARY) return;
      else if(mode == SCROLLING) removeFirstDot();
    }
    
    this.dots.add(newDot);
    
    if(this.dots.size() == capacity) filled = true;
    
    if(this.maxY < val) this.maxY = val;
    if(this.minY > val) this.minY = val;
  }
  
  void removeFirstDot() {
    Dot firstDot = this.dots.get(0);
    float firstY = firstDot.getY();
    this.dots.remove(0);
    if(firstY == this.minY) updateMinY();
    if(firstY == this.maxY) updateMaxY();
  }
  
  void updateMinY() {
    float newMinY = this.maxY;
    
    for (Iterator<Dot> iter = this.dots.iterator(); iter.hasNext();){
      Dot dot = iter.next();
      float y = dot.getY();
      if(y < newMinY) newMinY = y;
    }
    
    this.minY = newMinY;
  }
  
  void updateMaxY() {
    float newMaxY = this.minY;
    
    for (Iterator<Dot> iter = this.dots.iterator(); iter.hasNext();){
      Dot dot = iter.next();
      float y = dot.getY();
      if(y > newMaxY) newMaxY = y;
    }
    
    this.maxY = newMaxY;
  }
  
  
  
  //---------------------------------
  //---------------------------------
  
  //-----------------------------------
  //-----------  Renderers  -----------
  //-----------------------------------
  
  void renderPlain() {
    strokeWeight(1);
    stroke(this.borderCl);
    fill(this.plainCl);
    rect(this.originX, this.originY, this.dimX, this.dimY);
  }
  
  void renderDots() {
    int maxX = millis();
    
    float previousAbsoluteX = 0;
    float previousAbsoluteY = 0;
    
    for(int dotIdx = 0; dotIdx < this.dots.size(); dotIdx++) {
      Dot dot = this.dots.get(dotIdx);
      float absoluteX = this.originX + this.dimX * (dot.getX() / this.maxX);
      float absoluteY = this.originY + this.dimY * (1 - 0.8 * dot.getY() / (this.maxY - this.minY));
      
      strokeWeight(1);
      stroke(this.dotCl);
      fill(this.dotCl);
      circle(absoluteX, absoluteY, 2);
      
      if(dotIdx != 0) {
        strokeWeight(1);
        stroke(this.lineCl);
        
        line(previousAbsoluteX, previousAbsoluteY, absoluteX, absoluteY);
      }
      
      previousAbsoluteX = absoluteX;
      previousAbsoluteY = absoluteY;
    }
  }
  
  //-----------------------------------
  //-----------------------------------
  
}
