color WALLCOLOR = #023600;                                                            //Color of aviary boundaries
int WALLTHICKNESS = 20;                                                               //Thickness of aviary boundaries (!!!KEEP MORE THAN MAXIMUM AGENT SPEED!!!)




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
  
  void scream(Agent argAg){                                                           //Performs scream of agent
    
    
  
    agents.forEach((ag) -> {                                                       //For each agent
    
      int argPackIdx = getPack(argAg);
      
      if(ag != argAg){
        float distance = ag.getDistTo(argAg.getX(), argAg.getY());                     //Calculate distance to screamer
        float scrHearDist = ag.getScrHearDist();                                         //Get hearing distance
        
        int packIdx = getPack(ag);
      
        if(distance <= scrHearDist && argAg.getSpecies() == ag.getSpecies()){
          if(distance <= CONNECTDIST){
            if(argPackIdx == -1 && packIdx == -1){
              Pack newPack = new Pack();
              newPack.addAgent(argAg);
              newPack.addAgent(ag);
              packs.add(newPack);
              println("added new pack, current pack count:", packs.size());
            }
            else if (argPackIdx == -1){
              packs.get(packIdx).addAgent(argAg);
            }
            else if (packIdx == -1){
              packs.get(argPackIdx).addAgent(ag);
            }
          }
          if(distance >= argAg.getComfDist())
            ag.setDir((ag.directionToFace(argAg.getX(), argAg.getY(), distance) + ag.getDir()) / 2);
          else
            ag.setDir(ag.directionToFace(argAg.getX(), argAg.getY(), distance) + (float)Math.PI);
        }
      }
    });
  }
  
  void screams(){                                                                     //Perform screams if ready
    agents.forEach((agent) -> {
      if(agent.ifReadyToPack() && agent.ifReadyToAct())
        scream(agent);
    });
  }
  
  
  void run(){                                                       //Main method
    tick();                                                                           //Perform animation tick
    render();
    renderAgent();                                                                    //Render agants
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
    
  
  
  void tick(){                                                                        //Performes animation tick
    
    for (Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      
      int quadX = ag.getQuadX();
      int quadY = ag.getQuadY();
      
      if(ag.ifReadyToAct()){
        float dirX;
        float dirY;
      
        dirX = -(net.getRes(quadX, quadY) + net.getRes(quadX, quadY + 1)) / (2 * net.getMaxRes()) 
               +(net.getRes(quadX + 1, quadY) + net.getRes(quadX + 1, quadY + 1)) / (2 * net.getMaxRes());
        dirY = -(net.getRes(quadX, quadY) + net.getRes(quadX + 1, quadY)) / (2 * net.getMaxRes()) 
               +(net.getRes(quadX, quadY + 1) + net.getRes(quadX + 1, quadY + 1)) / (2 * net.getMaxRes());
          
        if (dirX != 0 || dirY != 0){
          ag.setDir(ag.directionToFace(ag.getX() + dirX, ag.getY() + dirY));
        }
      }
      
      int resToLower = whichRes(ag, quadX, quadY);
      float resToEat = 0;
      
      switch(resToLower){
        case 0:
          resToEat = net.lowerRes(quadX, quadY, RESEATENPERSTEP * 0.4) + net.lowerRes(quadX, quadY + 1, RESEATENPERSTEP * 0.15) + net.lowerRes(quadX + 1, quadY, RESEATENPERSTEP * 0.15) + net.lowerRes(quadX + 1, quadY + 1, RESEATENPERSTEP * 0.15);
          break;
        case 1:
          resToEat = net.lowerRes(quadX, quadY, RESEATENPERSTEP * 0.15) + net.lowerRes(quadX, quadY + 1, RESEATENPERSTEP * 0.4) + net.lowerRes(quadX + 1, quadY, RESEATENPERSTEP * 0.15) + net.lowerRes(quadX + 1, quadY + 1, RESEATENPERSTEP * 0.15);
          break;
        case 2:
          resToEat = net.lowerRes(quadX, quadY, RESEATENPERSTEP * 0.15) + net.lowerRes(quadX, quadY + 1, RESEATENPERSTEP * 0.15) + net.lowerRes(quadX + 1, quadY, RESEATENPERSTEP * 0.4) + net.lowerRes(quadX + 1, quadY + 1, RESEATENPERSTEP * 0.15);
          break;
        case 3:
          resToEat = net.lowerRes(quadX, quadY, RESEATENPERSTEP * 0.15) + net.lowerRes(quadX, quadY + 1, RESEATENPERSTEP * 0.15) + net.lowerRes(quadX + 1, quadY, RESEATENPERSTEP * 0.15) + net.lowerRes(quadX + 1, quadY + 1, RESEATENPERSTEP * 0.4);
          break;
        default:
      }
      
      ag.step();
      ag.eat(resToEat);
      ag.updateStatus();
      if(ag.dead()){
        removeAgentFromPacks(ag);
        iter.remove();
      }
    }
    net.replenish();
    screams();                                                                        //Perform screams
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
