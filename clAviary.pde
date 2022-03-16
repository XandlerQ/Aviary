color WALLCOLOR = #135A00;                                                            //Color of aviary boundaries
int WALLTHICKNESS = 20;                                                               //Thickness of aviary boundaries (!!!KEEP MORE THAN MAXIMUM AGENT SPEED!!!)




class Aviary{
  
  int resTpAmnt;                                                                      //Amount of resource types
  
  int baseAmnt;                                                                       //Amount of bases
  int resAmnt;                                                                        //Amount of resources TODO: MAKE IT AN ARRAY SIZED resTpAmnt TO KEEP AMOUNTS OF RESOURCES OF EACH TYPE
  
  int agentCtr;                                                                       //Agent counter
  
  color baseCl = #3483FF;                                                             //Base color (single)
  color resCl = #FFAA00;                                                              //Resource color TODO: MAKE IT AN ARRAY SIZED resTpAmnt TO KEEP COLORS OF EACH RESOURCE TYPE
  
  ArrayList<Base> bsArr;                                                              //
  ArrayList<Resource> resArr;                                                         //
  ArrayList<Agent> agentArr;                                                          //ArrayLists TODO: MAKE IT MULTIPLE RESOURCE TYPE COMPATIBLE
  

  //Constructors
  
  Aviary(int argBaseAmnt,                                                             //Amount of bases
         int argResAmnt,                                                              //Amount of resources
         int argInitAgentAmnt                                                         //Initial amount of agents
         ){
    
    resTpAmnt = 1;                                                                    //Single resource type by default
    
    baseAmnt = argBaseAmnt;                                                           //
    resAmnt = argResAmnt;                                                             //
    agentCtr = argInitAgentAmnt;                                                      //Set amounts
    
    bsArr = new ArrayList<Base>(argBaseAmnt);                                         //
    resArr = new ArrayList<Resource>(argResAmnt);                                     //
    agentArr = new ArrayList<Agent>(argInitAgentAmnt);                                //Making ArrayLists
    
    for(int i = 0; i < baseAmnt; i++){                                                //
      bsArr.add(new Base());                                                          //
    }                                                                                 //Add bases
    
    for(int i = 0; i < resAmnt; i++){                                                 //
      resArr.add(new Resource());                                                     //
    }                                                                                 //Add resources
    
    for(int i = 0; i < agentCtr; i++){                                                //
      agentArr.add(new Agent());                                                      //
    }                                                                                 //Add agents 
  }
  
  //Getters
  
  //Setters
  
  //Methods
  
  void scream(Agent argAg){                                                           //Performs scream of argAg
  
    agentArr.forEach((arg) -> {                                                       //For each agent
      
      float distance = arg.getDistTo(argAg.getX(), argAg.getY());                     //Calculate distance to screamer
      int scrHearDist = arg.getScrHearDist();                                         //Get hearing distance
      
      if(arg.ifHearFrom(distance)){                                                   //If agent can hear
        int bsDist = argAg.getBaseDist();                                             //Get screamers supposed base distance
        
        if(bsDist + scrHearDist < arg.getBaseDist()){                                 //If screamer is supposedly closer to base, !!!considering hearing distance!!!
          arg.setBaseDist(bsDist + scrHearDist);                                      //Set new supposed base distance for hearer
          arg.setBaseDir(arg.dirToFace(argAg.getX(), argAg.getY(), distance));        //Set new supposed base direction for hearer !!!as a direction to the screamer, not screamers supposed direction to the base!!!
          if(arg.getFlag() == 0)                                                      //If hearer is currently seeking base
            arg.updateDir();                                                          //Update his current direction
        }
        
        for(int i = 0; i < resTpAmnt; i++){                                           //
          int resDist = argAg.getResDist(i);                                          //
          if(resDist + scrHearDist < arg.getResDist(i)){                              //
            arg.setResDist(i, resDist + arg.getScrHearDist());                        //
            arg.setResDir(i, arg.dirToFace(argAg.getX(), argAg.getY(), distance));    //
            if(arg.getFlag() == i + 1)                                                //
              arg.updateDir();                                                        //Do the same for all resource types
          }
        } 
      }
    });
  }
  
  void screams(){                                                                     //Perform screams if ready
    agentArr.forEach((arg) -> {
      if(arg.ifReadyToScream())
        scream(arg);
    });
  }
  
  void run(int defX, int defY){                                                       //Main method
    render(defX, defY);                                                               //Render boundaries, bases and resources
    tick();                                                                           //Perform animation tick
    renderAgent();                                                                    //Render agants
  }
    
  
  void tick(){                                                                        //Performes animation tick
    agentArr.forEach((arg) -> {                                                       //For each agent
      color curCl = arg.step();                                                       //Perform step, get color from new location
      if(curCl == baseCl){                                                            //If found base
        arg.setFlag(1);                                                               //Set action flag to seek resource
        arg.setBaseDist(0);                                                           //!!!Set supposed distance to base to 0!!!
        arg.updateDir();                                                              //!!!Update direction accordingly to new action flag!!!
      }
      if(curCl == resCl){                                                             //If found resource
        arg.setFlag(0);                                                               //Set action flag to seek base
        arg.setResDist(0, 0);                                                         //!!!Set supposed distance to resource to 0!!!
        arg.updateDir();                                                              //!!!Update direction accordingly to new action flag!!!
      }
    });    
    screams();                                                                        //Perform screams
  }
  
  //Renderers
  
  void renderBounds(int defX, int defY){                                              //Renders boundaries of aviary

  strokeWeight(WALLTHICKNESS);  stroke(WALLCOLOR);
  line(WALLTHICKNESS / 2, WALLTHICKNESS / 2, WALLTHICKNESS / 2, defY - WALLTHICKNESS / 2);
  line(WALLTHICKNESS / 2, WALLTHICKNESS / 2, defX - WALLTHICKNESS / 2, WALLTHICKNESS / 2);
  line(defX - WALLTHICKNESS / 2, defY - WALLTHICKNESS / 2, defX - WALLTHICKNESS / 2, WALLTHICKNESS / 2);
  line(defX - WALLTHICKNESS / 2, defY - WALLTHICKNESS / 2, WALLTHICKNESS / 2, defY - WALLTHICKNESS / 2);
  
}

  void renderBase(){                                                                  //Renders bases
    bsArr.forEach((arg) -> arg.render());
  }
  
  void renderRes(){                                                                   //Renders resources
    resArr.forEach((arg) -> arg.render());
  }
  
  void renderAgent(){                                                                 //Renders agents
    agentArr.forEach((arg) -> arg.render());
  }
  
  void render(int defX, int defY){                                                    //Renders aviary
    background(0);
    renderBounds(defX, defY);
    renderBase();
    renderRes();
  }
  
  
}
