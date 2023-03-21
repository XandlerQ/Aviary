color SPECIES_COLORS[] = {#FF0004, #2DFF00};

AtomicInteger agentIdGen = new AtomicInteger(0);

class Agent {
  
  private int id;
  
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
  
  private int actCtr;
  private int actCtrPeak;
  
  private boolean stationary;
  
  
  //--------------------------------------
  //-----------  Constructors  -----------
  //---------------------------------------
  
  Agent() {
    this.id = agentIdGen.incrementAndGet();
    
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
    
    this.actCtr = 0;
    this.actCtrPeak = 0;
    
    this.stationary = false;
  }
  
  //---------------------------------------
  //---------------------------------------
  
  //---------------------------------
  //-----------  Getters  -----------
  //---------------------------------
  
  /*
  private int id;
  
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
  
  private float collectedRes;
  
  private int valence;
  private int conCount;
  
  private int actCtr;
  private int actCtrPeak;
  
  private boolean stationary;
  */
  
  int getId() { return this.id; }
  
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
  
  ResourceNode getLockedRes() { return this.lockedRes; }
  float getCollectedRes() { return this.collectedRes; }
  
  int getValence() { return this.valence; }
  int getConCount() { return this.conCount; }
  
  int getActCounter() { return this.actCtr; }
  int getActCounterPeak() { return this.actCtrPeak; }
  
  boolean stationary() { return this.stationary; }
  
  boolean dead() { return this.energy <= 0 || this.age > this.maxAge; }
  
  float getHunger() { return this.maxEnergy - this.energy; }
  
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Setters  -----------
  //---------------------------------
  
  void setCoordinates(Dot coordinates) { this.coordinates = coordinates; }
  void setDirection(float direction) { this.direction = fixDir(direction); }
  void setLockedRes(ResourceNode resNode) { this.lockedRes = resNode; }
  
  void setEnergy(float energy) { 
    this.energy = energy;
    normalizeEnergy();
  }
  
  
  
  
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Methods  -----------
  //---------------------------------
  
  //---------------------------------
  //---------------------------------
  
  //-----------------------------------
  //-----------  Renderers  -----------
  //-----------------------------------
  
  void render()
  {
    if(species == 0)
      stroke(SPEC1CL);
    else
      stroke(SPEC2CL);
    strokeWeight(1);
    fill(cl);
    circle(ORIGINX + x, ORIGINY + y, 4);
    line(ORIGINX + x, ORIGINY + y, ORIGINX + x + 6 * cos(direction), ORIGINY + y + 6 * sin(direction));
  }
  
  //-----------------------------------
  //-----------------------------------
}
