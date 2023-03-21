class Dot {
  private float x;
  private float y;
  
  Dot() {
    this.x = 0;
    this.y = 0;
  }
  
  Dot(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  Dot(Dot other) {
    this.x = other.x;
    this.y = other.y;
  }
  
  public float getX() { return this.x; }
  public float getY() { return this.y; }
  
  public void setX(float x) { this.x = x; }
  public void setY(float y) { this.y = y; }
  public void setXY(float x, float Y) { setX(x); setY(y); }
  public void setXY(Dot other) { setX(other.getX()); setY(other.getY()); }
  
  @Override
  public boolean equals(Object obj){
    if (this == obj)
      return true;
    if (obj == null)
      return false;
    Dot arg = (Dot) obj;
    return (arg.getX() == this.x && arg.getY() == this.y);
  }
}

class Connection {
  public Agent ag1;
  public Agent ag2;
  
  Connection() {
    this.ag1 = null;
    this.ag2 = null;
  }
  
  Connection(Agent ag1, Agent ag2){
    this.ag1 = ag1;
    this.ag2 = ag2;
  }
  
  boolean contains(Agent ag){ return this.ag1 == ag || this.ag2 == ag; }
  
  Agent pairOf(Agent ag){
    if(contains(ag)){
      if(this.ag1 == ag)
        return this.ag2;
      else
        return this.ag1;
    }
    return null;
  }
  
  Agent getFirst(){ return this.ag1; }
  
  Agent getSecond(){ return this.ag2; }
  
  @Override
  public boolean equals(Object obj){
    if (this == obj)
      return true;
    if (obj == null)
      return false;
    Connection arg = (Connection) obj;
    return (arg.getFirst() == this.ag1 && arg.getSecond() == this.ag2)
            ||(arg.getFirst() == this.ag2 && arg.getSecond() == this.ag1);
  }
}
