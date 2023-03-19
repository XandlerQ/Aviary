class Pair <Type> {
  private Type l;
  private Type r;
  
  Pair(Type l, Type r) {
    this.l = l;
    this.r = r;
  }
  
  Pair(Pair<Type> other) {
    this.l = other.l;
    this.r = other.r;
  }
  
  public Type getL() { return this.l; }
  public Type getR() { return this.r; }
  
  public void setL(Type l) { this.l = l; }
  public void setR(Type r) { this.r = r; }
}

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
}
