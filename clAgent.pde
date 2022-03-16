/// TODO;
/// Various constructors;
/// Energy / Age <--> speed, needed food etc.


class Agent {
  
  int flag;             //Action flag, determines where to go, e.g. if flag == 0, then seek base
                        //values: 0 - seek base, 1 -> resTpAmnt - seek resource indexed accordingly
  
  float x, y,           //Position 
    dir, speed;         //Direction (angle in range [0 ; 2PI)) and speed of movement
    
  int resTpAmnt;
  
  int[] resAmount;      //Amount of resources carried, index = type (size = amount of resource types)
  
  float[] resDir;       //Supposed direction towards resource types, index = type (size = amount of resource types)
  int[] resDist;        //Supposed distance to go to reach a resourse type, index = type
  
  float baseDir;        //Supposed direction towards base
  int baseDist;         //Supposed distance to go to reach base
  
  int scrCtrPeak;       //Predetermined value for scrCtr peak value
  int scrCtr;           //Scream counter, ++ when a step is made, perform a scream when the counter reaches predetrmined peak value of scrCtrPeak
  
  int scrHearDist;      //Perception distance: if scream produced closer than scrHearDist, then change Dir and Dist variables accordingly
  
  color cl = #000000;   //Inner render color
  
  //Constructors
  
  Agent(){
    Random r = new Random();                                //Randomizer
    
    
    resTpAmnt = 1;                                          //Single resource type by default
    flag = r.nextInt(resTpAmnt);                            //Initially seek either base or resource
    
    x = DEFX/10 + (4 * DEFX / 5) * r.nextFloat();           //
    y = DEFY/10 + (4 * DEFY / 5) * r.nextFloat();           //Random coordinates accordingly to aviary dimensions
    dir = (float)(2 * Math.PI * r.nextFloat());             //Random initial direction
    speed = (float)(0.6 + 0.4 * r.nextFloat());             //Random speed in range 0.6 -> 1.0
    
    
    resAmount = new int[resTpAmnt];                         //
    resDir = new float[resTpAmnt];                          //
    resDist = new int[resTpAmnt];                           //Resource related variables accordingly to the amount of resource types
    
    for(int i = 0; i < resTpAmnt; i++){
      resAmount[i] = 0;                                     //Initially no resources carried
      resDir[i] = (float)(2 * Math.PI * r.nextFloat());     //Random initial supposed direction to all resource types
      resDist[i] = DEFX/5;                                  //SAME(essential) initial supposed distance to all resource types
    }
    
    baseDir = (float)(2 * Math.PI * r.nextFloat());         //Random initial supposed direction to base
    baseDist = DEFX/5;                                      //SAME(essential) initial supposed distance to base
    
    scrCtrPeak = 7;                                         //Peak for scrCtr, e.g. if scrCtrPeak = 2, scream every third step
    scrCtr = r.nextInt(scrCtrPeak);                         //Random initial scream counter value
    
    scrHearDist = 60;                                       //Fixed perception distance
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
    return flag;
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
    baseDir = argBaseDir;
  }
  
  void setResDir(float[] argResDir){
    resDir = argResDir;
  }
  
  void setResDir(int argIdx, float argDist){
    resDir[argIdx] = argDist;
  }
  
  void setDir(float argDir){
    dir = argDir;
  }
  
  void setFlag(int argFlag){
    flag = argFlag;
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
  
  void fixDir(){                                                    //Fix direction to range [0 ; 2PI)
    while(dir < 0){
      dir += 2 * (float)Math.PI;
    }
    while(dir >= 2 * Math.PI){
      dir -= 2 * (float)Math.PI;
    }
  }
  
  float dirToFace(float argX, float argY, float argDist){           //Returns direction (angle in range [0 ; 2PI)) to face point (argX,argY), if distance to it is argDist
    
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
     
     for (int i = 0; i < resTpAmnt; i++){                           //
       resDist[i]++;                                                //
     }                                                              //Increment supposed distances to all resources by 1 with each step
     
     baseDist++;                                                    //Increment supposed distances to base by 1 with each step
     
     dir += -0.1 + (0.2) * r.nextFloat();                           //Randomly change direction of movement to eliminate linear movement
     
     fixDir();                                                      //Fix new direction if it is not in range [0 ; 2PI)
     
     float newX = x + speed * cos(dir);                             //
     float newY = y + speed * sin(dir);                             //Calculate new coordinates
     
     color cl = get(int(newX),int(newY));                           //Get color in new coordinates
     
     if (newX > DEFX - WALLTHICKNESS ||
         newX < WALLTHICKNESS ||
         newY > DEFY - WALLTHICKNESS ||
         newY < WALLTHICKNESS){                                     //If a wall is hit
       dir += (float)(Math.PI);                                     //Turn around
       newX = x + speed * cos(dir);                                 //
       newY = y + speed * sin(dir);                                 //Set new coordinates according to new direction
     }
     
     x = newX;                                                      //
     y = newY;                                                      //Change coordinates
     
     scrCtr += 1;                                                   //Increment scream counter
     
     if(scrCtr > scrCtrPeak){                                       //If screamed previous step
       scrCtr = 0;                                                  //Reset scream counter
     }
     
     return cl;                                                     //Returns color of new position
  }
  
  void updateDir(){                                                 //Update direction of movement accordingly to current action flag value
    if(flag == 0){                                                  //If seeking base
      dir = baseDir;                                                //Set direction of movement to supposed base direction
    }
    else{                                                           //If seeking resource
      dir = resDir[flag - 1];                                       //Set direction of movement to supposed resource type direction
    }
  }
  
  //Renderers
  
  void render()
  {
    stroke(#ffffff);  strokeWeight(1);
    fill(cl);
    ellipse(x, y, 3, 3);
  }
  
  void render(float sz)
  {
    fill(cl);
    ellipse(x, y, sz, sz);
  }
  
}
