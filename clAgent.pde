/// TODO;
/// Various constructors;
/// Energy / Age <--> speed, needed food etc.


class Agent {
  
  int status;             //Action status, determines where to go, e.g. if status == 0, then seek base
                        //values: 0 - seek base, 1 -> resourceTypeAmount - seek resource indexed accordingly
  
  float x; 
  float y;           //Position 
  float direction;
  float speed;         //Direction (angle in range [0 ; 2PI)) and speed of movement
    
  int resourceTypeAmount;
  
  int[] resAmount;      //Amount of resources carried, index = type (size = amount of resource types)
  int load;
  int maxLoad;
  
  float[] resDirection;       //Supposed direction towards resource types, index = type (size = amount of resource types)
  int[] resDist;        //Supposed distance to go to reach a resourse type, index = type
  
  float baseDirection;        //Supposed direction towards base
  int baseDist;         //Supposed distance to go to reach base
  
  int scrCtrPeak;       //Predetermined value for scrCtr peak value
  int scrCtr;           //Scream counter, ++ when a step is made, perform a scream when the counter reaches predetrmined peak value of scrCtrPeak
  
  int scrHearDist;      //Perception distance: if scream produced closer than scrHearDist, then change Dir and Dist variables accordingly
  
  color cl = #000000;   //Inner render color
  
  //Constructors
  
  Agent(){
    Random r = new Random();                                //Randomizer
    
    
    resourceTypeAmount = 1;                                          //Single resource type by default
    status = r.nextInt(resourceTypeAmount + 1);                            //Initially seek either base or resource
    updateColor();                                                 //Update color accordingly
    
    x = DEFX/10 + (4 * DEFX / 5) * r.nextFloat();           //
    y = DEFY/10 + (4 * DEFY / 5) * r.nextFloat();           //Random coordinates accordingly to aviary dimensions
    direction = (float)(2 * Math.PI * r.nextFloat());             //Random initial direction
    speed = (float)(0.6 + 0.4 * r.nextFloat());             //Random speed in range 0.6 -> 1.0
    
    
    resAmount = new int[resourceTypeAmount];                         //
    resDirection = new float[resourceTypeAmount];                          //
    resDist = new int[resourceTypeAmount];                           //Resource related variables accordingly to the amount of resource types
    
    for(int i = 0; i < resourceTypeAmount; i++){
      resAmount[i] = 0;                                     //Initially no resources carried
      resDirection[i] = (float)(2 * Math.PI * r.nextFloat());     //Random initial supposed direction to all resource types
      resDist[i] = DEFX/5;                                  //SAME(essential) initial supposed distance to all resource types
    }
    
    maxLoad = 1;
    
    if(status == 0){
      resAmount[0] = 1;
      load = maxLoad;
    }
    
    baseDirection = (float)(2 * Math.PI * r.nextFloat());         //Random initial supposed direction to base
    baseDist = DEFX/5;                                      //SAME(essential) initial supposed distance to base
    
    scrCtrPeak = 7;                                         //Peak for scrCtr, e.g. if scrCtrPeak = 2, scream every third step
    scrCtr = r.nextInt(scrCtrPeak);                         //Random initial scream counter value
    
    scrHearDist = 45;                                       //Fixed perception distance
  }
  
  //Getters
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
 
  int getScrCtr(){
    return scrCtr;
  }
  
  int getScrCtrPeak(){
    return scrCtrPeak;
  }
  
  int[] getResDist(){
    return resDist;
  }
  
  int getResDist(int argIdx){
    return resDist[argIdx];
  }
  
  int getBaseDist(){
    return baseDist;
  }
  
  int getScrHearDist(){
    return scrHearDist;
  }
  
  int getFlag(){
    return status;
  }
  
  int getRes(int argIdx){
    return resAmount[argIdx];
  }
  
  int getLoad(){
    return load;
  }
  
  int getMaxLoad(){
    return maxLoad;
  }
  
  //Setters
  
  void setColor(color argCl){
    cl = argCl;
  }
  
  void setResDist(int[] argResDist){
    resDist = argResDist;
  }
  
  void setResDist(int argIdx, int argDist){
    resDist[argIdx] = argDist;
  }
  
  void setBaseDist(int argBaseDist){
    baseDist = argBaseDist;
  }
  
  void setBaseDir(float argBaseDir){
    baseDirection = argBaseDir;
  }
  
  void setResDir(float[] argResDir){
    resDirection = argResDir;
  }
  
  void setResDir(int argIdx, float argDist){
    resDirection[argIdx] = argDist;
  }
  
  void setDir(float argDir){
    direction = argDir;
  }
  
  void setFlag(int argStatus){
    status = argStatus;
    updateColor();
  }
  
  void addRes(int argIdx){
    resAmount[argIdx]++;
    load++;
  }
  
  void dropResources(){
    for(int i = 0; i < resourceTypeAmount; i++)
      resAmount[i] = 0;
    load = 0;
  }
  
  //Methods
  
  float getDistTo(float argX, float argY){                          //Get distance from self to point
    return dist(x, y, argX, argY);
  }
  
  boolean ifHearFrom(float argDist){                                //True if hear from distance, false otherwise
    return argDist <= scrHearDist;
  }
  
  boolean ifReadyToScream(){                                        //True if ready to scream
    return scrCtr == scrCtrPeak;
  }
  
  void peakScreamCounter(){                                  //Peaks scream counter
    scrCtr = scrCtrPeak;
  }
  
  void resetScreamCounter(){                                  //Resets scream counter
    scrCtr = 0;
  }
  
  void updateColor(){                                        //Updates color accordingly to status
    if(status == 0)
      cl = #FF8400;
    else
      cl = #000000;
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
    
    float direct = acos((argX - x)/argDist);
    if(argY > y) {
      return direct;
    }
    else{
      return 2 * (float)Math.PI - direct;
    }
  }
  
  color step() {                                                    //Make step, returns color of next position
     Random r = new Random();                                       //Randomizer
     
     for (int i = 0; i < resourceTypeAmount; i++){                           //
       resDist[i]++;                                                //
     }                                                              //Increment supposed distances to all resources by 1 with each step
     
     baseDist++;                                                    //Increment supposed distances to base by 1 with each step
     
     direction += -0.08 + (0.16) * r.nextFloat();                           //Randomly change direction of movement to eliminate linear movement
     
     fixDir();                                                      //Fix new direction if it is not in range [0 ; 2PI)
     
     float newX = x + speed * cos(direction);                             //
     float newY = y + speed * sin(direction);                             //Calculate new coordinates
     
     color cl = get(int(newX),int(newY));                           //Get color in new coordinates
     
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
     
     scrCtr += 1;                                                   //Increment scream counter
     
     if(scrCtr > scrCtrPeak){                                       //If screamed previous step
       resetScreamCounter();                                                  //Reset scream counter
     }
     
     return cl;                                                     //Returns color of new position
  }
  
  void updateDir(){                                                 //Update direction of movement accordingly to current action status value
    if(status == 0){                                                  //If seeking base
      direction = baseDirection;                                                //Set direction of movement to supposed base direction
    }
    else{                                                           //If seeking resource
      direction = resDirection[status - 1];                                       //Set direction of movement to supposed resource type direction
    }
  }
  
  //Renderers
  
  void render()
  {
    stroke(#ffffff);  strokeWeight(1);
    fill(cl);
    circle(x, y, 4);
  }
  
  void render(float sz)
  {
    stroke(#ffffff);  strokeWeight(1);
    fill(cl);
    circle(x, y, sz);
  }
  
}
