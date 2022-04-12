color WALLCOLOR = #023600;                                                            //Color of aviary boundaries
float WALLTHICKNESS = 1;




class AviaryRivalry {
  
  int agentCounter;                                                                       //Agent counter
  
  ResourceNet net;
  ArrayList<Agent> agents;                                                         
  ArrayList<Pack> packs;
  

  //Constructors
  
  AviaryRivalry(int argInitAgentAmnt){
    
    agentCounter = argInitAgentAmnt;                                                      //Set amounts
    
    net = new ResourceNet();
    agents = new ArrayList<Agent>(argInitAgentAmnt);                                //Making ArrayLists
    packs = new ArrayList<Pack>();
    
    
    for(int i = 0; i < agentCounter; i++){                                                //
      agents.add(new Agent());                                                      //
    }                                                                                 //Add agents 
  }
  
  //Getters
  
  //Setters
  
  //Methods
  
  int getPack(Agent argAg){
    int idx = -1;
    int at = 0;
    for (Iterator<Pack> iter = packs.iterator(); iter.hasNext();){
      Pack pck = iter.next();
      if(pck.contains(argAg))
        idx = at;
      at++;
    }
    return idx;
  } 
  
  void removeAgentFromPacks(Agent argAg){
      packs.forEach((pack) ->{pack.removeAgent(argAg);});
      for (Iterator<Pack> iter = packs.iterator(); iter.hasNext();){
        Pack pack = iter.next();
        if(pack.empty()){
          iter.remove();
          println("removed a pack, current pack count:", packs.size());
        }
      }
  }
    
  void agEat(Agent argAg, int quadX, int quadY){

    float resToEat = net.lowerRes(quadX, quadY, RESEATENPERSTEP);
    argAg.eat(resToEat);
  }
  
  float getGradDir(Agent argAg, int quadX, int quadY){
    
    float dirX;
    float dirY;
    
    if(quadX == 0){
      if(quadY == 0){
        dirX = net.getRes(quadX + 1, quadY) + net.getRes(quadX + 1, quadY + 1);
        dirY = net.getRes(quadX, quadY + 1) + net.getRes(quadX + 1, quadY + 1);
      }
      else if(quadY == QUADY - 1){
        dirX = net.getRes(quadX + 1, quadY) + net.getRes(quadX + 1, quadY - 1);
        dirY = -(net.getRes(quadX, quadY - 1) + net.getRes(quadX + 1, quadY - 1));
      }
      else{
        dirX = net.getRes(quadX + 1, quadY - 1) + net.getRes(quadX + 1, quadY) + net.getRes(quadX + 1, quadY + 1);
        dirY = net.getRes(quadX, quadY + 1) + net.getRes(quadX + 1, quadY + 1) - (net.getRes(quadX, quadY - 1) + net.getRes(quadX + 1, quadY - 1));
      }
    }
    else if(quadX == QUADX - 1){
      if(quadY == 0){
        dirX = -(net.getRes(quadX - 1, quadY) + net.getRes(quadX - 1, quadY + 1));
        dirY = net.getRes(quadX, quadY + 1) + net.getRes(quadX - 1, quadY + 1);
      }
      else if(quadY == QUADY - 1){
        dirX = -(net.getRes(quadX - 1, quadY) + net.getRes(quadX - 1, quadY - 1));
        dirY = -(net.getRes(quadX, quadY - 1) + net.getRes(quadX - 1, quadY - 1));
      }
      else{
        dirX = -(net.getRes(quadX - 1, quadY - 1) + net.getRes(quadX - 1, quadY) + net.getRes(quadX - 1, quadY + 1));
        dirY = net.getRes(quadX, quadY + 1) + net.getRes(quadX - 1, quadY + 1) - (net.getRes(quadX, quadY - 1) + net.getRes(quadX - 1, quadY - 1));
      }
    }
    else{
      if(quadY == 0){
        dirX = net.getRes(quadX + 1, quadY) + net.getRes(quadX + 1, quadY + 1) - (net.getRes(quadX - 1, quadY) + net.getRes(quadX - 1, quadY + 1));
        dirY = net.getRes(quadX - 1, quadY + 1) + net.getRes(quadX, quadY + 1) + net.getRes(quadX + 1, quadY + 1);
      }
      else if(quadY == QUADY - 1){
        dirX = net.getRes(quadX + 1, quadY) + net.getRes(quadX + 1, quadY - 1) - (net.getRes(quadX - 1, quadY) + net.getRes(quadX - 1, quadY - 1));
        dirY = -(net.getRes(quadX - 1, quadY - 1) + net.getRes(quadX, quadY - 1) + net.getRes(quadX + 1, quadY - 1));
      }
      else{
        dirX = (net.getRes(quadX + 1, quadY - 1) + net.getRes(quadX + 1, quadY) + net.getRes(quadX + 1, quadY + 1)) 
             - (net.getRes(quadX - 1, quadY - 1) + net.getRes(quadX - 1, quadY) + net.getRes(quadX - 1, quadY + 1));
        dirY = (net.getRes(quadX - 1, quadY + 1) + net.getRes(quadX, quadY + 1) + net.getRes(quadX + 1, quadY + 1)) 
             - (net.getRes(quadX - 1, quadY - 1) + net.getRes(quadX, quadY - 1) + net.getRes(quadX + 1, quadY - 1));
      }
    }
    
    return argAg.dirToFace(argAg.getX() + dirX, argAg.getY() + dirY);
        
    
  }
  
  float getPackDir(Agent argAg){

    int packIdx = getPack(argAg);
    if(packIdx != -1){
      return argAg.dirToFace(packs.get(packIdx).getPackCenterX(), packs.get(packIdx).getPackCenterY());
    }
    else
      return 0;
  }
  
  float getPackDist(Agent argAg){
    
    int packIdx = getPack(argAg);
    if(packIdx != -1){
      ArrayList<Agent> conAg = packs.get(packIdx).getConnected(argAg);
      float maxDist = 0;
      for (Iterator<Agent> iter = conAg.iterator(); iter.hasNext();){
        Agent ag = iter.next();
        float distTo = argAg.getDistTo(ag.getX(), ag.getY());
        if (maxDist < distTo)
          maxDist = distTo;
      }
      return maxDist;
    }
    else{
      return -1;
    }
  }
  
  void screams(){                                                                     //Perform screams if ready
    agents.forEach((agent) -> {
      if(agent.ifReadyToAct())
        scream(agent);
    });
  }
  
  float calculateDir(float gradDir, float packDir, float packDist){
    
    if(packDist < 0){
      return gradDir;
    }
    else{
      if(packDist < COMDIST){
        return packDir + (float)Math.PI;
      }
      else if (packDist < SCRHEARDIST){
        return gradDir;
      }
      else{
        println("TO FAR");
        return packDir;
      }
    }
    
  }
  
  void scream(Agent argAg){                                                           //Performs scream of agent                                                     //For each agent
    
    int packIdx = getPack(argAg);
    
    if(!argAg.wellFed()){
      
      if(packIdx != -1){
        Pack pack = packs.get(packIdx);
        pack.removeAgent(argAg);
      }
      argAg.setDir(calculateDir( 
                                getGradDir(argAg, argAg.getQuadX(), argAg.getQuadY()),
                                getPackDir(argAg),
                                getPackDist(argAg)
                                )
      );
    }
    
    else{
      
      if(packIdx != -1){
        argAg.setDir(calculateDir(
                                  getGradDir(argAg, argAg.getQuadX(), argAg.getQuadY()),
                                  getPackDir(argAg),
                                  getPackDist(argAg)
                                  )
        );
      }
      
      
      
      else{
        
        for (Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
          
          Agent ag = iter.next();
          if(argAg != ag){
            
            float distance = argAg.getDistTo(ag.getX(), ag.getY());
          
            if(argAg.getSpecies() == ag.getSpecies()){
            
              if(distance <= CONNECTDIST){
                int agPackIdx = getPack(ag);
              
                if(agPackIdx != -1){
                  packs.get(agPackIdx).addAgent(argAg);
                }
              
                else{
                  Pack newPack = new Pack();
                  newPack.addAgent(argAg);
                  newPack.addAgent(ag);
                  packs.add(newPack);
                }
              
                argAg.setDir(calculateDir( 
                                          getGradDir(argAg, argAg.getQuadX(), argAg.getQuadY()),
                                          getPackDir(argAg),
                                          getPackDist(argAg)
                                          )
                );
              
              }
            }
          }
        }
      }
      
      
    }
  }
  
  /*void fights(){
    agents.forEach((agent) -> {
        fight(agent);
    });
  }
  
  void fight(Agent argAg){
  }*/
  
  void tick(){                                                                        //Performes animation tick
    screams(); 
    net.replenish();
    for (Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      
      int quadX = ag.getQuadX();
      int quadY = ag.getQuadY();
      
      agEat(ag, quadX, quadY);
      ag.step();
      ag.updateStatus();
      if(ag.dead()){
        removeAgentFromPacks(ag);
        iter.remove();
      }
    }
                                                                   //Perform screams
  }
  
  void run(){                                                       //Main method
    tick();                                                                           //Perform animation tick
    render();
    renderAgent();                                                                    //Render agants
  }
  
  
  //Renderers
  
  void renderRes(){                                                                   //Renders resources
    net.render();
  }
  
  void renderPacks(){
    packs.forEach((pack) -> {pack.render();});
  }
  
  void renderAgent(){                                                                 //Renders agents
    agents.forEach((agent) -> agent.render());
  }
  
  void render(){                                                    //Renders aviary
    background(0);
    renderRes();
    renderPacks();
    fill(255);  // инструкция
  }
  
  
}
