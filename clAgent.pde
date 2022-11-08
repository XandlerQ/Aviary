color SPEC1CL = #FF0004;
color SPEC2CL = #2DFF00;

class Agent {
  
  int species;
  int status;
  
  float x; 
  float y;           //Position 
  float direction;
  Resource lockedRes;
  float speed;         //Direction (angle in range [0 ; 2PI)) and speed of movement
  float delta;
  
  float age;
  float maxAge;
  float agePerStep;
  
  float energy;
  float suffEnergy;
  float maxEnergy;
  
  float collectedRes;
  
  int valence;
  int conCount;
  
  float lastHeardAge;
  
  boolean dieFlag;
  
  int actCtrPeak;       //Predetermined value for scrCtr peak value
  int actCtr;           //Scream counter, ++ when a step is made, perform a scream when the counter reaches predetrmined peak value of scrCtrPeak
  
  color cl = #000000;   //Inner render color
  
  boolean stationary;
  
  //Constructors
  
  Agent(){
    
    Random r = new Random();                                //Randomizer
    
    status = 1;
    species = 0;
  
    age = r.nextFloat() * BASEMAXAGE;
    maxAge = 0.8 * BASEMAXAGE + 0.4 * BASEMAXAGE * r.nextFloat();
    agePerStep = AGEPERSTEP;
      
    energy = SUFFENERGY / 2 + SUFFENERGY * r.nextFloat();
    suffEnergy = SUFFENERGY;
    maxEnergy = MAXENERGY;
    
    collectedRes = 0;
      
    valence = VALENCE1;
    conCount = 0;
    lastHeardAge = -1;
    
    dieFlag = false;
    
    x = DEFX/10 + (4 * DEFX / 5) * r.nextFloat();           //
    y = DEFY/10 + (4 * DEFY / 5) * r.nextFloat();           //Random coordinates accordingly to aviary dimensions
    direction = (float)(2 * Math.PI * r.nextFloat());             //Random initial direction
    lockedRes = null;
    delta = r.nextFloat();
    speed = BASESPEED1 + SPEEDRANDOMNESS1 * delta - SPEEDAGECOEFF * (age - maxAge/2) * (age - maxAge/2) / (maxAge * maxAge);             //Random speed in range 0.6 -> 1.0
      
    actCtrPeak = ACTCTRPEAK;                                         //Peak for scrCtr, e.g. if scrCtrPeak = 2, scream every third step
    actCtr = r.nextInt(actCtrPeak);                         //Random initial scream counter value
    
    stationary = false;
  }
  
  Agent(int argSpec){
    this();
    species = argSpec;
    if(species == 0){
      valence = VALENCE1;
      if(SYSSPAWN){
        Random r = new Random();
        x = DEFX/10 + (2 * DEFX / 5) * r.nextFloat();
        y = DEFY/10 + (4 * DEFY / 5) * r.nextFloat();
      }
      speed = BASESPEED1 + SPEEDRANDOMNESS1 * delta - SPEEDAGECOEFF * (age - maxAge/2) * (age - maxAge/2) / (maxAge * maxAge);
    }
    else{
      valence = VALENCE2;
      if(SYSSPAWN){
        Random r = new Random();
        x = 9 * DEFX/10 - (2 * DEFX / 5) * r.nextFloat();
        y = DEFY/10 + (4 * DEFY / 5) * r.nextFloat();
      }
      speed = BASESPEED2 + SPEEDRANDOMNESS2 * delta - SPEEDAGECOEFF * (age - maxAge/2) * (age - maxAge/2) / (maxAge * maxAge);
    }
  }
  
  Agent(int argSpec, float argX, float argY){
    this(argSpec);
    x = argX;
    y = argY;
  }
  
  //Getters
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  float getDir(){
    return direction;
  }
  
  Resource getLockedRes(){
    return lockedRes;
  }
  
  float getSpeed(){
    return speed;
  }
 
  int getActCtr(){
    return actCtr;
  }
  
  int getActCtrPeak(){
    return actCtrPeak;
  }
  
  int getStatus(){
    return status;
  }
  
  int getConCount(){
    return conCount;
  }
  
  int getSpecies(){
    return species;
  }
  
  float getEnergy(){
    return energy;
  }
  
  float getCollectedRes(){
    return collectedRes;
  }
  
  float getLastHeardAge(){
    return lastHeardAge;
  }
  
  float getAge(){
    return age;
  }
  
  int getValence(){
    return valence;
  }
  
  boolean dead(){
    return dieFlag;
  }
  
  boolean readyToReproduct(){
    return age >= REPRODUCTLOW && age <= REPRODUCTHIGH && energy + collectedRes >= SUFFENERGY + REPRODUCTCOST * 1.5; //&& conCount > 0;
  }
  
  float howHungry(){
    float hunger = maxEnergy - energy;
    if(hunger < 0)
      return 0;
    else
      return hunger;
  }
  
  //Setters
  
  void setColor(color argCl){
    cl = argCl;
  }
  
  void setDir(float argDir){
    direction = argDir;
    fixDir();
  }
  
  void lockInResource(Resource argRes){
    lockedRes = argRes;
  }
  
  void setStatus(int argStatus){
    status = argStatus;
    updateColor();
  }
  
  void setEnergy(float argNrg){
    energy = argNrg;
    updateStatus();
  }
  
  void setNewBornEnergy(){
    energy = SUFFENERGY + SUFFENERGY/4;
    updateStatus();
  }
  
  void updateValence(){
    if(species == 0){
      valence = VALENCE1;
    }
    else{
      valence = VALENCE2;
    }
  }
  
  void setLastHeardAge(float argAge){
    lastHeardAge = argAge;
  }
  
  void resetCollected(){
    collectedRes = 0;
  }
  
  void resetLastHeardAge(){
    lastHeardAge = -1;
  }
  
  void setStationary(boolean flag){
    stationary = flag;
  }
    
  
  //Methods
  @Override
  public boolean equals(Object obj){
    if (this == obj)
      return true;
    if (obj == null)
      return false;
    Agent arg = (Agent) obj;
    return x == arg.getX() 
           && y == arg.getY()
           && direction == arg.getDir()
           && speed == arg.getSpeed();
  }
  
  float getDistTo(float argX, float argY){                          //Get distance from self to point
    return dist(x, y, argX, argY);
  }
  
  int getQuadX(){
    int quadX = 0;
    float h = DEFX / QUADX;
    quadX = (int)((x - (x % h)) / h);
    if(quadX < QUADX)
      return quadX;
    else
      return QUADX - 1;
  }
  
  int getQuadY(){
    int quadY = 0;
    float h = DEFY / QUADY;
    quadY = (int)((y - (y % h)) / h);
    if(quadY < QUADY)
      return quadY;
    else
      return QUADY - 1;
  }
  
  float getEnergyLeftover(){
    return energy - suffEnergy;
  }
  
  void addToEnergy(float argAm){
    energy += argAm;
    if(energy <= 0){
       dieFlag = true;
       return;
    }
    if(energy > maxEnergy){
      energy = maxEnergy;
    }
    updateStatus();
  }
  
  boolean ifHearFrom(float argDist){                                //True if hear from distance, false otherwise
    return argDist <= SCRHEARDIST;
  }
  
  boolean wellFed(){
    return status == 0;
  }
  
  boolean readyToAct(){                                        //True if ready to scream
    return actCtr == actCtrPeak;
  }
  
  void peakActCounter(){                                  //Peaks scream counter
    actCtr = actCtrPeak;
  }
  
  void resetActCounter(){                                  //Resets scream counter
    actCtr = actCtrPeak;
  }
  
  void resetConCount(){
    conCount = 0;
  }
  
  boolean isTopCon(){
    return conCount >= valence;
  }
  
  void addCon(){
    conCount++;
  }
  
  void removeCon(){
    conCount--;
  }
  
  void updateStatus(){
    if(energy > suffEnergy)
      status = 0;
    else
      status = 1;
    updateColor();
  }
  
  void updateColor(){                                        //Updates color accordingly to status
    if(status == 0)
      cl = #FF8400;
    else
      cl = #000000;
  }
  
  void updateSpeed(){
    if(species == 0){
        speed = BASESPEED1 + SPEEDRANDOMNESS1 * delta - SPEEDAGECOEFF * (age - maxAge/2) * (age - maxAge/2) / (maxAge * maxAge);
    }
    else{
        speed = BASESPEED2 + SPEEDRANDOMNESS2 * delta - SPEEDAGECOEFF * (age - maxAge/2) * (age - maxAge/2) / (maxAge * maxAge);
    }
  }
  
  void fixDir(){                                                    //Fix direction to range [0 ; 2PI)
    while(direction < 0){
      direction += 2 * (float)Math.PI;
    }
    while(direction >= 2 * Math.PI){
      direction -= 2 * (float)Math.PI;
    }
  }
  
  float dirToFace(float argX, float argY, float argDist){           //Returns direction (angle in range [0 ; 2PI)) to face point (argX,argY), if distance to it is argDist
    
    Random r = new Random();
    
    if(argDist == 0)
      return (float)(2 * Math.PI * r.nextFloat());
    
    float direct = acos((argX - x)/argDist);
    if(argY > y) {
      return direct;
    }
    else{
      return 2 * (float)Math.PI - direct;
    }
  }
  
  float dirToFace(float argX, float argY){
    return dirToFace(argX, argY, getDistTo(argX, argY));
  }
  
  void collectRes(float argRes){
    collectedRes = argRes;
  }
  
  void eatCollected(){
    eat(collectedRes);
    if(howHungry() == 0){
      setStationary(false);
      lockInResource(null);
    }
  }
  
  void eat(float argRes){
    if(energy <= maxEnergy){
      energy += argRes;
    }
    updateStatus();
    resetCollected();
  }
  
  void step() {                                                    //Make step, returns color of next position
    Random r = new Random();                                       //Randomizer
     
    age += agePerStep;
    updateSpeed();
    
    if(species == 0){
      energy -= NRGPERSTEP1 * (speed * speed/(BASESPEED1 * BASESPEED1));
    }
    else{
      energy -= NRGPERSTEP2 * (speed * speed/(BASESPEED2 * BASESPEED2));
    }
     
     
     if(energy <= 0 || age > maxAge){
       dieFlag = true;
       return;
     }
     
     updateStatus();
     
     if(!stationary){
       direction += -0.16 + (0.32) * r.nextFloat();                           //Randomly change direction of movement to eliminate linear movement
       
       fixDir();                                                      //Fix new direction if it is not in range [0 ; 2PI)
       
       float newX = x + speed * cos(direction);                             //
       float newY = y + speed * sin(direction);                             //Calculate new coordinates
         
       if (newX > DEFX - WALLTHICKNESS ||
           newX < WALLTHICKNESS ||
           newY > DEFY - WALLTHICKNESS ||
           newY < WALLTHICKNESS){                                     //If a wall is hit
         direction += (float)(Math.PI);                                     //Turn around
         fixDir();
         newX = x + speed * cos(direction);                                 //
         newY = y + speed * sin(direction);                                 //Set new coordinates according to new direction
       }
       
       x = newX;                                                      //
       y = newY;                                                      //Change coordinates
     }
     
     actCtr -= 1;                                                   //Increment scream counter
     
     if(actCtr == 0){                                       //If screamed previous step
       resetActCounter();                                                  //Reset scream counter
     }
     
     
  }
  
  //Renderers
  
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
    /*fill(0,0);
    stroke(SPEC2CL, 50);
    circle(ORIGINX + x, ORIGINY + y, VISUALDIST * 2);*/
  }
}
