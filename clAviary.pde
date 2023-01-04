color WALLCOLOR = #023600;                                                            //Color of aviary boundaries
int WALLTHICKNESS = 20;                                                               //Thickness of aviary boundaries (!!!KEEP MORE THAN MAXIMUM AGENT SPEED!!!)




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
    
    for(int i = 0; i < baseAmount; i++){                                                //
      bases.add(new Base());                                                          //
    }                                                                                 //Add bases
    
    for(int i = 0; i < resourceAmount; i++){                                                 //
      resources.add(new Resource());                                                     //
    }                                                                                 //Add resources
    
    for(int i = 0; i < agentCounter; i++){                                                //
      agents.add(new Agent());                                                      //
    }                                                                                 //Add agents 
  }
  
  //Getters
  
  //Setters
  
  //Methods
  
  void scream(Agent agent){                                                           //Performs scream of agent
  
    agents.forEach((ag) -> {                                                       //For each agent
      
      float distance = ag.getDistTo(agent.getX(), agent.getY());                     //Calculate distance to screamer
      float scrHearDist = ag.getScrHearDist();                                         //Get hearing distance
      
      if(ag.hearFrom(distance)){                                                   //If agent can hear
        int bsDist = agent.getBaseReach();                                             //Get screamers supposed base distance
        
        if(ag.getBaseReach() > bsDist + scrHearDist){                                 //If screamer is supposedly closer to base, !!!considering hearing distance!!!
          ag.setBaseReach((int)(bsDist + scrHearDist));                                      //Set new supposed base distance for hearer
          ag.setBaseDir(ag.dirToFace(agent.getX(), agent.getY()));  //Set new supposed base direction for hearer !!!as a direction to the screamer, not screamers supposed direction to the base!!!
          ag.peakScrCtr();
          stroke(#FFFFFF, 100);  strokeWeight(1);
          line(agent.getX(), agent.getY(), ag.getX(), ag.getY());
          if(ag.getStatus() == 0) ag.updateDir();                                     //If hearer is currently seeking base                                                          //Update his current direction
        }
                   
        float resDist = agent.getResReach();                            
        if(ag.getResReach() > resDist + scrHearDist){            
          ag.setResReach((int)(resDist + ag.getScrHearDist()));
          ag.setResDir(ag.dirToFace(agent.getX(), agent.getY()));
          ag.peakScrCtr();
          stroke(#FFFFFF, 100);  strokeWeight(1);
          line(agent.getX(), agent.getY(), ag.getX(), ag.getY());
          if(ag.getStatus() == 1)  ag.updateDir();                                                        //Do the same for all resource types
        }
      } 
    });
  }
  
  void screams(){                                                                     //Perform screams if ready
    agents.forEach((agent) -> {
      if(agent.readyToScream())
        scream(agent);
    });
  }
  
  void run(){                                                       //Main method
    render();                                                               //Render boundaries, bases and resources
    tick();                                                                           //Perform animation tick
    renderAgent();                                                                    //Render agants
  }
    
  
  void tick(){                                                                        //Performes animation tick
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
        ag.peakScrCtr();
        
        if(status == 0){
          float res = ag.getLoad();
          ag.dropLoad();
          bases.get(bsIdx).addRes(res);
          ag.setStatus(1);
          ag.updateDir();
        }
      }
      
      if(resIdx != -1){
        ag.setResReach(0);
        ag.peakScrCtr();
        
        if(status == 1){
          float res = resources.get(resIdx).lowerRes(MAXLOAD);
          ag.addLoad(res);
          ag.setStatus(0);
          ag.updateDir();
          if(resources.get(resIdx).empty()){
            resources.remove(resIdx);
            resources.add(new Resource());
          }
        }
      }
    });    
    screams();                                                                        //Perform screams
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
  
  void render(){                                                    //Renders aviary
    background(0);
    renderBase();
    renderRes();
    stroke(#202020);
    strokeWeight(0);
    fill(#202020);
    circle(DEFX/2, DEFY/2, 150);
  }
  
  
}
