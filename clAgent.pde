color SPECIES_COLORS[] = {#FF0004, #2DFF00};

AtomicInteger agentIdGen = new AtomicInteger(0);

class Agent {
  
  private int id;
  private int species;
  
  private Dot coordinates;
  private float direction;
  private float baseSpeed;
  private float speed;
  
  private float age;
  private float maxAge;
  private float ageIncr;
  
  private float energy;
  private float maxEnergy;
  private float suffEnergy;
  private float energyDecr;
  
  private ResourceNode lockedRes;
  private float collectedRes;
  
  private int valence;
  private int conCount;
  private float lastHeardAge;
  
  private int actCtr;
  private int actCtrPeak;
  
  private boolean stationary;
  
  
  //--------------------------------------
  //-----------  Constructors  -----------
  //---------------------------------------
  
  Agent() {
    this.id = agentIdGen.incrementAndGet();
    this.species = 0;
    
    this.coordinates = new Dot();
    this.direction = 0;
    this.baseSpeed = 1;
    this.speed = 0;
    
    this.age = 0;
    this.maxAge = 1;
    this.ageIncr = 0;
    
    this.energy = 1;
    this.maxEnergy = 1;
    this.suffEnergy = 1;
    this.energyDecr = 0;
    
    this.lockedRes = null;
    this.collectedRes = 0;
    
    this.valence = 0;
    this.conCount = 0;
    this.lastHeardAge = -1;
    
    
    this.actCtr = 0;
    this.actCtrPeak = 0;
    
    this.stationary = false;
  }
  
  //---------------------------------------
  //---------------------------------------
  
  //---------------------------------
  //-----------  Getters  -----------
  //---------------------------------
  
  
  
  int getId() { return this.id; }
  int getSpecies() { return this.species; }
  
  float getX() { return this.coordinates.getX(); }
  float getY() { return this.coordinates.getY(); }
  Dot getCoordinates() { return this.coordinates; }
  float getDirection() { return this.direction; }
  float getBaseSpeed() { return this.baseSpeed; }
  float getSpeed() { return this.speed; }
  
  float getAge() { return this.age; }
  float getMaxAge() { return this.maxAge; }
  float getAgeIncr() { return this.ageIncr; }
  
  float getEnergy() { return this.energy; }
  float getMaxEnergy() { return this.maxEnergy; }
  float getSuffEnergy() { return this.suffEnergy; }
  float getEnergyDecr() { return this.energyDecr; }
  
  float getHunger() { return this.maxEnergy - this.energy; }
  boolean wellFed() { return this.energy >= this.suffEnergy; }
  
  ResourceNode getLockedRes() { return this.lockedRes; }
  float getCollectedRes() { return this.collectedRes; }
  
  int getValence() { return this.valence; }
  int getConCount() { return this.conCount; }
  float getLastHeardAge() { return this.lastHeardAge; }
  boolean topCon() { return this.conCount >= this.valence; }
  
  int getActCounter() { return this.actCtr; }
  int getActCounterPeak() { return this.actCtrPeak; }
  
  boolean readyToAct() { return this.actCtr == 0; }
  
  boolean stationary() { return this.stationary; }
  
  boolean dead() { return this.energy <= 0 || this.age > this.maxAge; }
  
  
  
  //---------------------------------
  
  float getDistTo(float x, float y) { return dist(this.coordinates.getX(), this.coordinates.getY(), x, y); }
  float getDistTo(Dot dot) { return getDistTo(dot.getX(), dot.getY()); }
  
  float getEnergyOver() { return this.energy - this.maxEnergy; }
  
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Setters  -----------
  //---------------------------------
  
  void setSpecies(int species) { this.species = species; }
  
  void setCoordinates(Dot coordinates) { this.coordinates = coordinates; }
  void setCoordinates(float x, float y) { this.coordinates.setXY(x, y); }
  void setDirection(float direction) { this.direction = fixDir(direction); }
  void setBaseSpeed(float baseSpeed) { this.baseSpeed = baseSpeed; }
  
  
  void setAgeIncr(float ageIncr) { this.ageIncr = ageIncr; }
  
  void setEnergy(float energy) { 
    this.energy = energy;
    normalizeEnergy();
  }
  
  void setMaxEnergy(float maxEnergy) { this.maxEnergy = maxEnergy; }
  void setSuffEnergy(float suffEnergy) { this.suffEnergy = suffEnergy; }
  void setEnergyDecr(float energyDecr) { this.energyDecr = energyDecr; }
  
  void setLockedRes(ResourceNode resNode) { this.lockedRes = resNode; }
  void setCollectedRes(float collectedRes) { this.collectedRes = collectedRes; }
  void collect(float res) { this.collectedRes += res; }
  void resetCollectedRes() { this.collectedRes = 0; }
  
  void setValence(int valence) { this.valence = valence; }
  void setLastHeardAge(float age) { this.lastHeardAge = age; }
  void resetLastHeardAge() { this.lastHeardAge = -1; }
  void resetConCount() { this.conCount = 0; }
  
  
  void setActCtrPeak(int actCtrPeak) { this.actCtrPeak = actCtrPeak; }
  void getReadyToAct() { this.actCtr = 0; }
  void resetActCtr() { this.actCtr = this.actCtrPeak; }
  
  void setStationary(boolean stationary) { this.stationary = stationary; }
  void lock() { this.stationary = true; }
  void unlock() { this.stationary = false; }
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Methods  -----------
  //---------------------------------
  
  private void normalizeEnergy() {
    if(this.energy > maxEnergy) {
      this.energy = maxEnergy;
    }
    if(this.energy < 0) {
      this.energy = 0;
    }
  }
  
  void addToEnergy(float nrg) {
    this.energy += nrg;
    normalizeEnergy();
  }
  
  void eat(float res) { 
    this.energy += res;
    normalizeEnergy();
  }
  
  void eatCollected() {
    eat(this.collectedRes);
    resetCollected();
  }
  
  //---------------------------------
  
  boolean addCon() {
    if(topCon()) return false;
    this.conCount++;
    return true;
  }
  
  boolean removeCon() {
    if(this.conCount == 0) return false;
      this.conCount--;
      return true;
  }
  
  //---------------------------------
  
  void updateSpeed() {
    this.speed = this.baseSpeed 
                 - (this.baseSpeed / 4) 
                 * (4 * (this.age - this.maxAge/2) * (this.age - this.maxAge/2) / (this.maxAge * this.maxAge));
  }
  
  //---------------------------------
  
  void normalizeDirection() {
    while(this.direction < 0) this.direction += 2 * (float)Math.PI;
    while(this.direction >= 2 * Math.PI) this.direction -= 2 * (float)Math.PI;
  }
  
  float dirToFace(float x, float y) {
    float distance = dist(this.coordinates.getX(), this.coordinates.getY(), x, y);
    
    if(distance == 0) {
      Random r = new Random();
      return (float)(2 * Math.PI * r.nextFloat());
    }
    
    float direction = acos((x - this.coordinates.getX()) / distance);
    if(y > this.coordinates.getY()) return direction;
    else return 2 * (float)Math.PI - direction;
  }
  
  float dirToFace(Dot dot) { return dirToFace(dot.getX(), dot.getY()); }
  
  void face(float x, float y) { this.direction = dirToFace(x, y); }
  void face(Dot dot) { this.direction = dirToFace(dot); }
  
  //---------------------------------
  
  void step() {
    
     this.age += this.ageIncr;
     updateSpeed();
     
     this.energy -= this.energyDecr * ((this.speed * this.speed) / (this.baseSpeed * this.baseSpeed));
     
     if(this.actCtr > 0) this.actCtr -= 1;
     else resetActCtr();
     
     if(stationary) return;
     
     Random r = new Random();
     
     this.direction += -0.16 + (0.32) * r.nextFloat();
     fixDir();
     
     float newX = this.coordinates.getX() + this.speed * cos(this.direction);
     float newY = this.coordinates.getY() + this.speed * sin(this.direction);
     
     if(newX > DEFX - WALLTHICKNESS ||
        newX < WALLTHICKNESS ||
        newY > DEFY - WALLTHICKNESS ||
        newY < WALLTHICKNESS) {
         direction += (float)(Math.PI);
         fixDir();
         newX = this.coordinates.getX() + this.speed * cos(this.direction);
         newY = this.coordinates.getY() + this.speed * sin(this.direction);
     }
     
     this.setCoordinates(newX, newY);
  }
  
  //---------------------------------
    
  @Override
  public boolean equals(Object obj){
    if (this == obj)
      return true;
    if (obj == null)
      return false;
    Agent arg = (Agent) obj;
    return this.id == arg.id;
  }
  
  //---------------------------------
  //---------------------------------
  
  //-----------------------------------
  //-----------  Renderers  -----------
  //-----------------------------------
  
  void render()
  {
    stroke(SPECIES_COLORS[this.species]);
    strokeWeight(1);
    if (this.energy >= this.suffEnergy) fill(SPECIES_COLORS[this.species], 150);
    else fill(0);
      
    circle(ORIGINX + this.coordinates.getX(), ORIGINY + this.coordinates.getY(), 4);
    line(ORIGINX + this.coordinates.getX(), ORIGINY + this.coordinates.getY(),
         ORIGINX + this.coordinates.getX() + 6 * cos(direction), ORIGINY + this.coordinates.getY() + 6 * sin(direction)
    );
  }
  
  //-----------------------------------
  //-----------------------------------
}
