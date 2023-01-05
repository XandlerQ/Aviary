/// TODO;
/// Various constructors;
/// Energy / Age <--> speed, needed food etc.


class Agent {
  
  int role;            // 0 - std, 1 - navigator, 2 - fluctuator;
  
  int status;           //values: 0 - seek base, 1 - seek resource
  
  float x; 
  float y;           //Position 
  float dir;
  float speed;         //Direction (angle in range [0 ; 2PI)) and speed of movement
  float baseSpeed;
  
  float load;
  float maxLoad;
  
  float suppResDir;       //Supposed direction towards resource types, index = type (size = amount of resource types)
  int resReach;        //Supposed distance to go to reach a resourse type, index = type
  
  float suppBaseDir;        //Supposed direction towards base
  int baseReach;         //Supposed distance to go to reach base
  
  int lstnCtrPeak;       //Predetermined value for scrCtr peak value
  int lstnCtr;           //Scream counter, ++ when a step is made, perform a scream when the counter reaches predetrmined peak value of scrCtrPeak
  
  float scrHearDist;      //Perception distance: if scream produced closer than scrHearDist, then change Dir and Dist variables accordingly
  float visualDist;
  
  boolean lockedOn;
  
  color borderCl;
  color innerCl;   //Inner render color
  
  //Constructors
  
  Agent(){
    Random r = new Random();                                //Randomizer
    
    status = 1;
    
    x = DEFX/10 + (4 * DEFX / 5) * r.nextFloat();           //
    y = DEFY/10 + (4 * DEFY / 5) * r.nextFloat();           //Random coordinates accordingly to aviary dimensions
    dir = (float)(2 * Math.PI * r.nextFloat());             //Random initial direction
    speed = (float)(1.0 + 0.6 * r.nextFloat());             //Random speed in range 0.6 -> 1.0
    baseSpeed = speed;
    
    load = 0;
    maxLoad = MAXLOAD;
    
    suppResDir = (float)(2 * Math.PI * r.nextFloat());
    resReach = 0;
    
    suppBaseDir = (float)(2 * Math.PI * r.nextFloat());
    baseReach = 0;
    
    lstnCtrPeak = LSTNCTRPEAK;                                         //Peak for scrCtr, e.g. if scrCtrPeak = 2, scream every third step
    lstnCtr = r.nextInt(lstnCtrPeak);                         //Random initial scream counter value
    
    scrHearDist = SCRHEARDIST;                                       //Fixed perception distance
    visualDist = VISUALDIST;
    
    lockedOn = false;
    
    borderCl = #FFFFFF;
    innerCl = #000000;
  }
  
  Agent(float argX, float argY){
    this();
    x = argX;
    y = argY;
  }
  
  //Getters
  
  int getRole(){
    return role;
  }
  
  int getStatus(){
    return status;
  }
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  float getSpeed(){
    return speed;
  }
 
  int getLstnCtr(){
    return lstnCtr;
  }
  
  int getLstnCtrPeak(){
    return lstnCtrPeak;
  }
  
  int getResReach(){
    return resReach;
  }
  
  int getBaseReach(){
    return baseReach;
  }
  
  float getScrHearDist(){
    return scrHearDist;
  }
  
  float getVisualDist(){
    return visualDist;
  }
  
  float getLoad(){
    return load;
  }
  
  float getMaxLoad(){
    return maxLoad;
  }
  
  boolean locked(){
    return lockedOn;
  }
  
  //Setters
  
  void setRole(int argRole){
    role = argRole;
    if(role == 0){
      borderCl = #FFFFFF;
    }
    if(role == 1){
      borderCl = #6100FF;
    }
    if(role == 2){
      borderCl = #CFFF00;
      lstnCtrPeak *= 2;
    }
  }
  
  void setSpeed(float argSp){
    speed = argSp;
  }
  
  void setInnerColor(color argCl){
    innerCl = argCl;
  }
  
  void setBorderColor(color argCl){
    borderCl = argCl;
  }
  
  void setResReach(int argReach){
    resReach = argReach;
  }
  
  void setBaseReach(int argReach){
    baseReach = argReach;
  }
  
  void setResDir(float argDir){
    suppResDir = argDir;
  }
  
  void setBaseDir(float argDir){
    suppBaseDir = argDir;
  }
  
  void setDir(float argDir){
    dir = argDir;
  }
  
  void setStatus(int argStatus){
    status = argStatus;
    updateColor();
  }
  
  void addLoad(float argLoad){
    load += argLoad;
  }
  
  void dropLoad(){
    load = 0;
  }
  
  void resetResReach(){
    resReach = 0;
  }
  
  void resetBaseReach(){
    baseReach = 0;
  }
  
  void lock(){
    lockedOn = true;
  }
  
  void unlock(){
    lockedOn = false;
  }
  
  //Methods
  
  float getDistTo(float argX, float argY){                          //Get distance from self to point
    return dist(x, y, argX, argY);
  }
  
  boolean hearFrom(float argDist){                                //True if hear from distance, false otherwise
    return argDist <= scrHearDist;
  }
  
  boolean readyToListen(){                                        //True if ready to scream
    return lstnCtr == 0;
  }
  
  void peakLstnCtr(){                                  //Peaks scream counter
    lstnCtr = 0;
  }
  
  void resetLstnCtr(){
    lstnCtr = lstnCtrPeak;
  }
  
  void updateColor(){                                        //Updates color accordingly to status
    if(status == 0)
      innerCl = #FF8400;
    else
      innerCl = #000000;
  }
  
  void fixDir(){                                                    //Fix direction to range [0 ; 2PI)
    while(dir < 0){
      dir += 2 * (float)Math.PI;
    }
    while(dir >= 2 * Math.PI){
      dir -= 2 * (float)Math.PI;
    }
  }
  
  float dirToFace(float argX, float argY){
    float dist = getDistTo(argX, argY);
    float direct = acos((argX - x)/dist);
    if(argY > y) {
      return direct;
    }
    else{
      return 2 * (float)Math.PI - direct;
    }
  }
  
  void face(float argX, float argY){
    setDir(dirToFace(argX, argY));
  }
  
  void updateSpeed(color cl){
    if(cl == #202020){
      setSpeed(baseSpeed / 2);
    }
    else{
      setSpeed(baseSpeed);
    }
  }
  
  void step() {                                                    //Make step, returns color of next position
     Random r = new Random();                                       //Randomizer
     
     resReach += 1;
     baseReach += 1;
     
     if(role == 2){
       dir += (-0.08 + (0.16) * r.nextFloat()) * 2;                           //Randomly change direction of movement to eliminate linear movement
     }
     else{
       dir += -0.08 + (0.16) * r.nextFloat();                           //Randomly change direction of movement to eliminate linear movement
     }
       
     
     fixDir();                                                      //Fix new direction if it is not in range [0 ; 2PI)
     
     float newX = x + speed * cos(dir);                             //
     float newY = y + speed * sin(dir);                             //Calculate new coordinates
     
     if (newX > DEFX - WALLTHICKNESS ||
         newX < WALLTHICKNESS ||
         newY > DEFY - WALLTHICKNESS ||
         newY < WALLTHICKNESS){                                     //If a wall is hit
       dir += (float)(Math.PI);                                     //Turn around
       fixDir();
       newX = x + speed * cos(dir);                                 //
       newY = y + speed * sin(dir);                                 //Set new coordinates according to new direction
     }
     
     x = newX;                                                      //
     y = newY;                                                      //Change coordinates
     
     lstnCtr -= 1;                                                   //Increment scream counter
     
     if(lstnCtr < 0){                                       //If screamed previous step
       resetLstnCtr();                                                  //Reset scream counter
     }
     
     updateSpeed(get(int(newX),int(newY)));
  }
  
  void updateDir(){                                                 //Update direction of movement accordingly to current action status value
    if(status == 0){                                                  //If seeking base
      dir = suppBaseDir;                                                //Set direction of movement to supposed base direction
    }
    else{                                                           //If seeking resource
      dir = suppResDir;                                       //Set direction of movement to supposed resource type direction
    }
  }
  
  //Renderers
  
  void render()
  {
    stroke(borderCl);  strokeWeight(1);
    fill(innerCl);
    circle(x, y, 4);
  }
  
}
