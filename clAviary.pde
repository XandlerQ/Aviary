color WALLCOLOR = #023600;                                                            //Color of aviary boundaries
int WALLTHICKNESS = 20;                                                               //Thickness of aviary boundaries (!!!KEEP MORE THAN MAXIMUM AGENT SPEED!!!)


float directionAddition(float dir1, float dir2){
  float resDir = -1;
  float x1, y1, x2, y2;
  x1 = cos(dir1);
  y1 = sin(dir1);
  x2 = cos(dir2);
  y2 = sin(dir2);
  
  float xres, yres;
  
  xres = x1 + x2;
  yres = y1 + y2;
  
  float module = sqrt((xres * xres) + (yres * yres));
  
  if (module == 0){
    Random r = new Random();
    resDir = (float)(2 * Math.PI * r.nextFloat());
  }
  else{
    xres /= module;
    yres /= module;
    resDir = acos(xres);
    if(yres < 0)
      resDir = 2 * (float)Math.PI - resDir;
  }
  return resDir;
}

class Aviary {
  
  int resourceTypeAmount;                                                                      //Amount of resource types
  
  int baseAmount;                                                                       //Amount of bases
  int resourceAmount;                                                                        //Amount of resources TODO: MAKE IT AN ARRAY SIZED resourceTypeAmount TO KEEP AMOUNTS OF RESOURCES OF EACH TYPE
  
  int agentCounter;                                                                       //Agent counter
  
  color baseCl = #3483FF;                                                             //Base color (single)
  color resCl = #FFAA00;                                                              //Resource color TODO: MAKE IT AN ARRAY SIZED resourceTypeAmount TO KEEP COLORS OF EACH RESOURCE TYPE
  
  ArrayList<Base> bases;                                                              //
  ArrayList<Resource> resources;                                                         //
  ArrayList<Agent> agents;                                                          //ArrayLists TODO: MAKE IT MULTIPLE RESOURCE TYPE COMPATIBLE
  ArrayList<Float> x;
  ArrayList<Float> y;
  

  //Constructors
  
  Aviary(int argBaseAmnt,                                                             //Amount of bases
         int argResAmnt,                                                              //Amount of resources
         int argInitAgentAmnt                                                         //Initial amount of agents
         ){
    
    resourceTypeAmount = 1;                                                                    //Single resource type by default
    
    baseAmount = argBaseAmnt;                                                           //
    resourceAmount = argResAmnt;                                                             //
    agentCounter = argInitAgentAmnt;                                                      //Set amounts
    
    bases = new ArrayList<Base>(argBaseAmnt);                                         //
    resources = new ArrayList<Resource>(argResAmnt);                                     //
    agents = new ArrayList<Agent>(argInitAgentAmnt);                                //Making ArrayLists
    
    x = new ArrayList<Float>();
    y = new ArrayList<Float>();
    
    for(int i = 0; i < baseAmount; i++){                                                //
      bases.add(new Base());                                                          //
    }                                                                                 //Add bases
    
    for(int i = 0; i < resourceAmount; i++){                                                 //
      resources.add(new Resource());                                                     //
    }                                                                                 //Add resources
    
    for(int i = 0; i < agentCounter / 2; i++){                                                //
      agents.add(new Agent());                                                      //
    }                                                                                 //Add agents
    
    for(int i = 0; i < agentCounter / 2; i++){
      Agent ag = new Agent();
      ag.setRole(2);
      agents.add(ag);
    }
    
    for(int i = 0; i < 0*agentCounter / 8; i++){
      Agent ag = new Agent();
      ag.setRole(1);
      agents.add(ag);
    }
  }
  
  void addBord(float argX, float argY){
    x.add(argX);
    y.add(argY);
  }
  
  void clearBord(){
    x.clear();
    y.clear();
  }
  
  void addRes(float argX, float argY){
    resources.add(new Resource(argX, argY));
  }
  
  //Getters
  
  //Setters
  
  //Methods
  
  void listen(Agent agent){                                                           //Performs scream of agent
  
    if(agent.locked())
      return;
    
    float minBaseReach = agents.get(0).getBaseReach();
    float minResReach = agents.get(0).getResReach();
    int minBaseReachIdx = -1;
    int minResReachIdx = -1;
    int curIdx = -1;
    float scrHearDist = agent.getScrHearDist();
  
    for(Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      curIdx++;
      
      float distance = agent.getDistTo(ag.getX(), ag.getY());                     //Calculate distance to screamer
      
      if(agent.hearFrom(distance)){                                                   //If agent can hear
        int bsReach = ag.getBaseReach();
        float resReach = ag.getResReach();
        
        if(bsReach < minBaseReach){
          minBaseReach = bsReach;
          minBaseReachIdx = curIdx;
        }
        
        if(resReach < minResReach){
          minResReach = resReach;
          minResReachIdx = curIdx;
        }
      } 
    }
    
    boolean needToScream = false;
    
    if(minBaseReachIdx != -1){
      Agent ag = agents.get(minBaseReachIdx);
      if(agent.getBaseReach() > minBaseReach + scrHearDist / agent.getSpeed()){                                 //If screamer is supposedly closer to base, !!!considering hearing distance!!!
        agent.setBaseReach((int)(minBaseReach + scrHearDist / agent.getSpeed()));                                      //Set new supposed base distance for hearer
        float baseDir;
        baseDir = agent.dirToFace(ag.getX(), ag.getY());
        agent.setBaseDir(baseDir);  //Set new supposed base direction for hearer !!!as a direction to the screamer, not screamers supposed direction to the base!!!
        needToScream = true;
        //stroke(#FFFFFF, 100);  strokeWeight(1);
        //line(agent.getX(), agent.getY(), ag.getX(), ag.getY());
        if(agent.getStatus() == 0) agent.updateDir();                                     //If hearer is currently seeking base                                                          //Update his current direction
      }
    }
                   
    if(minResReachIdx != -1 && !(agent.getRole() == 1)){
      Agent ag = agents.get(minResReachIdx);
      if(agent.getResReach() > minResReach + scrHearDist / agent.getSpeed()){            
        agent.setResReach((int)(minResReach + scrHearDist / agent.getSpeed()));
        float resDir;
        resDir = agent.dirToFace(ag.getX(), ag.getY());
        agent.setResDir(resDir);
        needToScream = true;
        //stroke(#FFFFFF, 100);  strokeWeight(1);
        //line(agent.getX(), agent.getY(), ag.getX(), ag.getY());
        if(agent.getStatus() == 1)  agent.updateDir();                                                        //Do the same for all resource types
      }
    }
    
    if(needToScream)
      scream(agent);
  }
  
  void scream(Agent agent){                                                           //Performs scream of agent
  
    agents.forEach((ag) -> {                                                       //For each agent
      
      float distance = ag.getDistTo(agent.getX(), agent.getY());                     //Calculate distance to screamer
      float scrHearDist = ag.getScrHearDist();                                         //Get hearing distance
      
      if(ag.hearFrom(distance)){                                                   //If agent can hear
        int bsReach = agent.getBaseReach();                                             //Get screamers supposed base distance
        
        if(ag.getBaseReach() > bsReach + scrHearDist / agent.getSpeed()){                                 //If screamer is supposedly closer to base, !!!considering hearing distance!!!
          ag.setBaseReach((int)(bsReach + scrHearDist / agent.getSpeed()));                                      //Set new supposed base distance for hearer
          float baseDir;
          baseDir = ag.dirToFace(agent.getX(), agent.getY());
          ag.setBaseDir(baseDir);
          //scream(ag);
          //stroke(#FFFFFF, 100);  strokeWeight(1);
          //line(agent.getX(), agent.getY(), ag.getX(), ag.getY());
          if(ag.getStatus() == 0) ag.updateDir();                                     //If hearer is currently seeking base                                                          //Update his current direction
        }
                   
        float resReach = agent.getResReach();                            
        if(ag.getResReach() > resReach + scrHearDist / agent.getSpeed() && !(ag.getRole() == 1)){            
          ag.setResReach((int)(resReach + scrHearDist / agent.getSpeed()));
          float resDir;
          resDir = ag.dirToFace(agent.getX(), agent.getY());
          ag.setResDir(resDir);
          //scream(ag);
          //stroke(#FFFFFF, 100);  strokeWeight(1);
          //line(agent.getX(), agent.getY(), ag.getX(), ag.getY());
          if(ag.getStatus() == 1)  ag.updateDir();                                                        //Do the same for all resource types
        }
      } 
    });
  }
  
  void look(Agent agent){
    int bsIdx = -1;
    int curIdx = -1;
    for(Iterator<Base> iter = bases.iterator(); iter.hasNext();){
      Base bs = iter.next();
      curIdx += 1;
      if(agent.getDistTo(bs.getX(), bs.getY()) - bs.getRadius() < agent.getVisualDist()){
        bsIdx = curIdx;
      }
    }
    
    int resIdx = -1;
    curIdx = -1;
    for(Iterator<Resource> iter = resources.iterator(); iter.hasNext();){
      Resource res = iter.next();
      curIdx += 1;
      if(agent.getDistTo(res.getX(), res.getY()) - res.getRadius() < agent.getVisualDist()){
        resIdx = curIdx;
      }
    }
    
    if(bsIdx != -1){
      Base bs = bases.get(bsIdx);
      agent.setBaseReach((int)(agent.getDistTo(bs.getX(), bs.getY()) / agent.getSpeed()));
      agent.setBaseDir(agent.dirToFace(bs.getX(), bs.getY()));
      
      if(agent.getStatus() == 0){
        agent.lock();
        agent.updateDir();
      }
    }
    
    if(resIdx != -1){
      Resource res = resources.get(resIdx);
      agent.setResReach((int)(agent.getDistTo(res.getX(), res.getY()) / agent.getSpeed()));
      agent.setResDir(agent.dirToFace(res.getX(), res.getY()));
      
      if(agent.getStatus() == 1){
        agent.lock();
        agent.updateDir();
      }
    }
  }
  
  void listens(){                                                                     //Perform screams if ready
    agents.forEach((ag) -> {
      if(ag.readyToListen())
        listen(ag);
    });
  }
  
  void looks(){
    agents.forEach((ag) -> {
      look(ag);
    });
  }
  
  void run(){                                                       //Main method
    render();                                                               //Render boundaries, bases and resources
    tick();                                                                           //Perform animation tick
    renderAgent();                                                                    //Render agants
  }
    
  
  void tick(){                                                                        //Performes animation tick
    looks();
    listens();
    agents.forEach((ag) -> {                                                       //For each agent
      ag.step();                                                       //Perform step, get color from new location
      
      int status = ag.getStatus();
      
      int bsIdx = -1;
      int curIdx = -1;
      for(Iterator<Base> iter = bases.iterator(); iter.hasNext();){
        Base bs = iter.next();
        curIdx += 1;
        if(ag.getDistTo(bs.getX(), bs.getY()) < bs.getRadius()){
          bsIdx = curIdx;
        }
      }
      
      int resIdx = -1;
      curIdx = -1;
      for(Iterator<Resource> iter = resources.iterator(); iter.hasNext();){
        Resource res = iter.next();
        curIdx += 1;
        if(ag.getDistTo(res.getX(), res.getY()) < res.getRadius()){
          resIdx = curIdx;
        }
      }
      
      if(bsIdx != -1){
        ag.setBaseReach(0);
        scream(ag);
        ag.peakLstnCtr();
        
        if(status == 0){
          float res = ag.getLoad();
          ag.dropLoad();
          bases.get(bsIdx).addRes(res);
          ag.setStatus(1);
          ag.updateDir();
          ag.unlock();
        }
      }
      
      if(resIdx != -1){
        ag.setResReach(0);
        scream(ag);
        ag.peakLstnCtr();
        
        if(status == 1){
          float res = resources.get(resIdx).lowerRes(MAXLOAD);
          ag.addLoad(res);
          ag.setStatus(0);
          ag.updateDir();
          ag.unlock();
          if(resources.get(resIdx).empty()){
            resources.remove(resIdx);
            resources.add(new Resource());
          }
        }
      }
    });                                                                         //Perform screams
  }
  
  void moveBase(int baseId, float argX, float argY){
    bases.get(baseId).setPos(argX, argY);
  }
  
  void moveRes(int resId, float argX, float argY){
    resources.get(resId).setPos(argX, argY);
  }
  
  //Renderers

  void renderBase(){                                                                  //Renders bases
    bases.forEach((base) -> base.render());
  }
  
  void renderRes(){                                                                   //Renders resources
    resources.forEach((res) -> res.render());
  }
  
  void renderAgent(){                                                                 //Renders agents
    agents.forEach((agent) -> agent.render());
  }
  
  void renderBord(){
    stroke(#202020);
    strokeWeight(0);
    fill(#202020);
    for(int i = 0; i < x.size(); i++){
      circle(x.get(i), y.get(i), 25);
    }
  }
  
  void render(){                                                    //Renders aviary
    background(0);
    renderBase();
    renderRes();
    stroke(#00FFFD, 50);
    strokeWeight(4);
    line(bases.get(0).getX(), bases.get(0).getY(), resources.get(0).getX(), resources.get(0).getY());
    renderBord();
  }
  
  
}
