color WALLCOLOR = #023600;                                                            //Color of aviary boundaries
float WALLTHICKNESS = QUADDIM;




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
  
  int whichRes(Agent argAg, int argQuadX, int argQuadY){
    
    float hx = (DEFX / (QUADX - 1));
    float hy = (DEFY / (QUADY - 1));
    
    float localX = argAg.getX() - argQuadX * hx;
    float localY = argAg.getY() - argQuadY * hy;
    
    if(localX <= hx / 2){
      if(localY <= hy / 2)
        return 0;
      else
        return 1;
    }
    else{
      if(localY <= hy / 2)
        return 2;
      else
        return 3;
    }
  }
    
  void agEat(Agent argAg, int quadX, int quadY){
    
    int resToLower = whichRes(argAg, quadX, quadY);
    float resToEat = 0;
      
    switch(resToLower){
      case 0:
        resToEat = net.lowerRes(quadX, quadY, RESEATENPERSTEP * 0.3) + net.lowerRes(quadX, quadY + 1, RESEATENPERSTEP * 0.233333) + net.lowerRes(quadX + 1, quadY, RESEATENPERSTEP * 0.233333) + net.lowerRes(quadX + 1, quadY + 1, RESEATENPERSTEP * 0.233333);
        break;
      case 1:
        resToEat = net.lowerRes(quadX, quadY, RESEATENPERSTEP * 0.233333) + net.lowerRes(quadX, quadY + 1, RESEATENPERSTEP * 0.3) + net.lowerRes(quadX + 1, quadY, RESEATENPERSTEP * 0.233333) + net.lowerRes(quadX + 1, quadY + 1, RESEATENPERSTEP * 0.233333);
        break;
      case 2:
        resToEat = net.lowerRes(quadX, quadY, RESEATENPERSTEP * 0.233333) + net.lowerRes(quadX, quadY + 1, RESEATENPERSTEP * 0.233333) + net.lowerRes(quadX + 1, quadY, RESEATENPERSTEP * 0.3) + net.lowerRes(quadX + 1, quadY + 1, RESEATENPERSTEP * 0.233333);
        break;
      case 3:
        resToEat = net.lowerRes(quadX, quadY, RESEATENPERSTEP * 0.233333) + net.lowerRes(quadX, quadY + 1, RESEATENPERSTEP * 0.233333) + net.lowerRes(quadX + 1, quadY, RESEATENPERSTEP * 0.233333) + net.lowerRes(quadX + 1, quadY + 1, RESEATENPERSTEP * 0.3);
        break;
      default:
    }

    argAg.eat(resToEat);
  }
  
  float getGradDir(Agent argAg, int quadX, int quadY){
    
    float dirX = -(net.getRes(quadX, quadY) + net.getRes(quadX, quadY + 1)) / (2 * net.getMaxRes()) 
           +(net.getRes(quadX + 1, quadY) + net.getRes(quadX + 1, quadY + 1)) / (2 * net.getMaxRes());
    float dirY = -(net.getRes(quadX, quadY) + net.getRes(quadX + 1, quadY)) / (2 * net.getMaxRes()) 
           +(net.getRes(quadX, quadY + 1) + net.getRes(quadX + 1, quadY + 1)) / (2 * net.getMaxRes());
          
    if (dirX != 0 || dirY != 0){
      return argAg.dirToFace(argAg.getX() + dirX, argAg.getY() + dirY);
    }
    else
      return 0;
  }
  
  float getPackDir(Agent argAg){
    float packDir = 0;
    int packIdx = getPack(argAg);
    if(packIdx != -1){
      ArrayList<Agent> conAg = packs.get(packIdx).getConnected(argAg);
      for (Iterator<Agent> iter = conAg.iterator(); iter.hasNext();){
        Agent ag = iter.next();
        float distance = argAg.getDistTo(ag.getX(), ag.getY());
        if(distance >= argAg.getComfDist())
            packDir += argAg.dirToFace(ag.getX(), ag.getY(), distance) / conAg.size();
          else
            packDir += (argAg.dirToFace(ag.getX(), ag.getY(), distance) + (float)Math.PI) / conAg.size();
      }
      return packDir;
    }
    else
      return 0;
  }
  
  float getPackDist(Agent argAg){
    
    int packIdx = getPack(argAg);
    if(packIdx != -1){
      ArrayList<Agent> conAg = packs.get(packIdx).getConnected(argAg);
      float sumDist = 0;
      for (Iterator<Agent> iter = conAg.iterator(); iter.hasNext();){
        Agent ag = iter.next();
        sumDist += argAg.getDistTo(ag.getX(), ag.getY());
      }
      return sumDist / conAg.size();
    }
    return 0;
  }
  
  void screams(){                                                                     //Perform screams if ready
    agents.forEach((agent) -> {
      if(agent.ifReadyToAct())
        scream(agent);
    });
  }
  
  float calculateDir(Agent argAg, float gradDir, float packDir, float packDist){
    float cDC = argAg.getDistTo(DEFX / 2, DEFY / 2) / (DEFX / 10);
    float pDC = packDist / (SCRHEARDIST * 0.3);
    float gDC = 0.8 * argAg.getEnergyLeftover();
    if(gDC < 0){
      return (cDC * argAg.dirToFace(DEFX / 2, DEFY / 2) + argAg.getDir() - gDC * gradDir) / (cDC + 1 - gDC);
    }
    else{
      return (cDC * argAg.dirToFace(DEFX / 2, DEFY / 2) + argAg.getDir() + (1 / gDC * 0.2) * gradDir + pDC * packDir) / (cDC + 1 + (1 / gDC * 0.2) + pDC);
    }
  }
  
  void scream(Agent argAg){                                                           //Performs scream of agent                                                     //For each agent
    
    int packIdx = getPack(argAg);
    
    if(!argAg.wellFed()){
      
      if(packIdx != -1){
        Pack pack = packs.get(packIdx);
        pack.removeAgent(argAg);
      }
      argAg.setDir(calculateDir(argAg, 
                                getGradDir(argAg, argAg.getQuadX(), argAg.getQuadY()),
                                0,
                                0
                                )
      );
    }
    
    else{
      
      if(packIdx != -1){
        argAg.setDir(calculateDir(argAg, 
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
              
                argAg.setDir(calculateDir(argAg, 
                                  getGradDir(argAg, argAg.getQuadX(), argAg.getQuadY()),
                                  getPackDir(argAg),
                                  getPackDist(argAg)
                                  )
                );
              
              }
            
              else if(distance <= SCRHEARDIST){
                argAg.setDir((getGradDir(argAg, argAg.getQuadX(), argAg.getQuadY()) + 2 * argAg.dirToFace(ag.getX(), ag.getY(), distance)) / 3);
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
