
color SPEC1CL = #FF0004;
color SPEC2CL = #2DFF00;

class Agent {
  
  int species;
  int status;
  
  float x; 
  float y;           //Position 
  float direction;
  float speed;         //Direction (angle in range [0 ; 2PI)) and speed of movement
  
  float age;
  float maxAge;
  float energy;
  float suffEnergy;
  
  int valence;
  int conCount;
  
  boolean dieFlag;
  
  float agePerStep;
  float energyPerStep;
  
  
  int ActCtrPeak;       //Predetermined value for scrCtr peak value
  int actCtr;           //Scream counter, ++ when a step is made, perform a scream when the counter reaches predetrmined peak value of scrCtrPeak
  
  float scrHearDist;      //Perception distance: if scream produced closer than scrHearDist, then change Dir and Dist variables accordingly
  float comfDist;
  
  color cl = #000000;   //Inner render color
  
  //Constructors
  
  Agent(){
    
    Random r = new Random();                                //Randomizer
    
    status = 1;
    species = 0;
  
    age = r.nextFloat() * MAXAGE / 4;
    maxAge = 0.6 * MAXAGE + 0.4 * MAXAGE * r.nextFloat();
    agePerStep = AGEPERSTEP;
      
    energy = SUFFENERGY / 2 + SUFFENERGY * r.nextFloat();
    suffEnergy = SUFFENERGY;
    energyPerStep = ENERGYPERSTEP;
      
    valence = VALENCE;
    conCount = 0;
    
    dieFlag = false;
    
    x = DEFX/10 + (4 * DEFX / 5) * r.nextFloat();           //
    y = DEFY/10 + (4 * DEFY / 5) * r.nextFloat();           //Random coordinates accordingly to aviary dimensions
    direction = (float)(2 * Math.PI * r.nextFloat());             //Random initial direction
    speed = 0.6 + 0.4 * r.nextFloat() - 0.5 * (age - maxAge/2) * (age - maxAge/2) / (maxAge * maxAge);             //Random speed in range 0.6 -> 1.0
      
    ActCtrPeak = ACTCTRPEAK;                                         //Peak for scrCtr, e.g. if scrCtrPeak = 2, scream every third step
    actCtr = r.nextInt(ActCtrPeak);                         //Random initial scream counter value
      
    scrHearDist = SCRHEARDIST;                                       //Fixed perception distance
    comfDist = COMDIST;
  }
  
  Agent(int argSpec){
    this();
    species = argSpec;
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
  
  float getSpeed(){
    return speed;
  }
 
  int getActCtr(){
    return actCtr;
  }
  
  int getActCtrPeak(){
    return ActCtrPeak;
  }
  
  float getScrHearDist(){
    return scrHearDist;
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
  
  float getComfDist(){
    return comfDist;
  }
  
  boolean dead(){
    return dieFlag;
  }
  
  //Setters
  
  void setColor(color argCl){
    cl = argCl;
  }
  
  void setDir(float argDir){
    direction = argDir;
    fixDir();
  }
  
  void setStatus(int argStatus){
    status = argStatus;
    updateColor();
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
    float h = (DEFX / (QUADX - 1));
    while(x > h + quadX * h)
      quadX++;
    return quadX;
  }
  
  int getQuadY(){
    int quadY = 0;
    float h = (DEFY / (QUADY - 1));
    while(y > h + quadY * h)
      quadY++;
    return quadY;
  }
  
  boolean ifHearFrom(float argDist){                                //True if hear from distance, false otherwise
    return argDist <= scrHearDist;
  }
  
  boolean ifReadyToPack(){
    return status == 0;
  }
  
  boolean ifReadyToAct(){                                        //True if ready to scream
    return actCtr == ActCtrPeak;
  }
  
  void peakActCounter(){                                  //Peaks scream counter
    actCtr = ActCtrPeak;
  }
  
  void resetActCounter(){                                  //Resets scream counter
    actCtr = 0;
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
    speed = speed 
            + (0.5 * (age - agePerStep - maxAge/2) * (age - agePerStep - maxAge/2) / (maxAge * maxAge)) 
            - (0.5 * (age - maxAge/2) * (age - maxAge/2) / (maxAge * maxAge));
  }
  
  void fixDir(){                                                    //Fix direction to range [0 ; 2PI)
    while(direction < 0){
      direction += 2 * (float)Math.PI;
    }
    while(direction >= 2 * Math.PI){
      direction -= 2 * (float)Math.PI;
    }
  }
  
  float directionToFace(float argX, float argY, float argDist){           //Returns direction (angle in range [0 ; 2PI)) to face point (argX,argY), if distance to it is argDist
    
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
  
  float directionToFace(float argX, float argY){
    return directionToFace(argX, argY, getDistTo(argX, argY));
  }
  
  void eat(float argRes){
    energy += argRes;
  }
  
  void step() {                                                    //Make step, returns color of next position
     Random r = new Random();                                       //Randomizer
     
     age += agePerStep;
     updateSpeed();
     
     energy -= energyPerStep;
     
     if(energy <= 0 || age > maxAge){
       dieFlag = true;
       return;
     }
     
     updateStatus();
     
     direction += -0.08 + (0.16) * r.nextFloat();                           //Randomly change direction of movement to eliminate linear movement
     
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
     
     actCtr += 1;                                                   //Increment scream counter
     
     if(actCtr > ActCtrPeak){                                       //If screamed previous step
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
    circle(x, y, 4);
  }
  
  void render(float sz)
  {
    if(species == 0)
      stroke(SPEC1CL);
    else
      stroke(SPEC2CL);
    strokeWeight(1);
    fill(cl);
    circle(x, y, sz);
  }
  
}
