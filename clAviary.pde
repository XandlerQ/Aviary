color WALLCOLOR = #023600;                                                            //Color of aviary boundaries
float WALLTHICKNESS = 1;




class AviaryRivalry {                                                                       //Agent counter
  
  ResourceNet net;
  ArrayList<Agent> agents;                                                         
  ArrayList<Pack> packs;
  
  int popSp1Ctr;
  int popSp2Ctr;
  
  Graph grSp1Pop;
  Graph grSp2Pop;
  
  int infCtr = INFOREPCTRPEAK;
  

  //Constructors
  
  AviaryRivalry(){                                           
    
    net = new ResourceNet();
    agents = new ArrayList<Agent>(INITAGENTAMOUNT1 + INITAGENTAMOUNT2);                                //Making ArrayLists
    packs = new ArrayList<Pack>();
    
    popSp1Ctr = INITAGENTAMOUNT1;
    popSp2Ctr = INITAGENTAMOUNT2;
    
    for(int i = 0; i < INITAGENTAMOUNT1; i++){                                                //
      agents.add(new Agent(0));
      
    }                                                                                 //Add agents 
    for(int i = 0; i < INITAGENTAMOUNT2; i++){                                                //
      agents.add(new Agent(1));                                                      //
    }                                                                                 //Add agents 
    println("INITIAL AGENT COUNT: ", INITAGENTAMOUNT1 + "   " + INITAGENTAMOUNT2);
    
    int graphWidth = 690;
    int graphHeight = 165;
    
    /*grSp1Pop = new Graph(DEFX + 6, 1);
    grSp1Pop.setSize(graphWidth,graphHeight);
    grSp1Pop.setType(1);
    grSp1Pop.setXAmnt(1000);
    grSp1Pop.setBordColor(#980000);
    grSp1Pop.setColor(#FF1A00);
    grSp1Pop.setLineColor(#FFFFFF);
    grSp1Pop.setTextColor(#FFFFFF);
    grSp1Pop.setBackgroundColor(#101010);
    grSp1Pop.setGraphTitle("Популяция кр. агентов");
    
    grSp2Pop = new Graph(DEFX + 6, graphHeight + 4);
    grSp2Pop.setSize(graphWidth,graphHeight);
    grSp2Pop.setType(1);
    grSp2Pop.setXAmnt(1000);
    grSp2Pop.setBordColor(#499D00);
    grSp2Pop.setColor(#83FF00);
    grSp2Pop.setLineColor(#FFC800);
    grSp2Pop.setTextColor(#FFD900);
    grSp2Pop.setBackgroundColor(#101010);
    grSp2Pop.setGraphTitle("Популяция зел. агентов");*/
    
  }
  
  //Getters
  
  ResourceNet getNet(){
    return net;
  }
  
  //Setters
  
  void updateValences(){
    agents.forEach((ag) -> {ag.updateValence();});
  }
  
  void updateMaxRes(){
    net.updateMaxRes();
  }
  
  void updateResRepSpeed(){
    net.updateResRepSpeed();
  }
  
  void updateRepDelay(){
    net.updateRepDelay();
  }
  
  //Methods
  
  Pack getPack(Agent argAg){
    
    if(argAg.getConCount() == 0)
      return null;
      
    for (Iterator<Pack> iter = packs.iterator(); iter.hasNext();){
      Pack pck = iter.next();
      if(pck.contains(argAg)){
        return pck;
      }
    }
    return null;
  }
  
  void removeAgentFromPacks(Agent argAg){
    //int at = 0;
    for (Iterator<Pack> iter = packs.iterator(); iter.hasNext();){
      Pack pack = iter.next();
      if(pack.contains(argAg)){
        //println("PACK IDX", at, "CONTAINED THIS AGENT, REMOVING AGENT FROM THIS PACK");
        pack.removeAgent(argAg);
        if(pack.empty()){
        //println("PACK TURNED OUT TO BE EMPTY, REMOVING THE WHOLE PACK");
          iter.remove();
        }
        break;
      }
      
    }
    //println("maybe removed a pack, current pack count:", packs.size());
  }
  
  void agResCollection(Agent argAg){
    Resource lockedRes = argAg.getLockedRes();
    if(lockedRes == null){
      argAg.setStationary(false);
      return;
    }
    float dist = argAg.getDistTo(lockedRes.getX(), lockedRes.getY());
    if(dist <= lockedRes.getSize() + 4){
      if(argAg.getConCount() == 0){
        float hunger = argAg.howHungry();
        if(hunger == 0){
          argAg.lockInResource(null);
          argAg.setStationary(false);
        }
        else{
          argAg.collectRes(lockedRes.lowerRes(min(hunger, RESECOLLECTEDPERSTEP)));
          argAg.setStationary(true);
        }
      }
      else{
        Pack pck = getPack(argAg);
        if(pck != null){
          float packHunger = getPack(argAg).getMedHunger();
          argAg.collectRes(lockedRes.lowerRes(min(packHunger, RESECOLLECTEDPERSTEP)));
          argAg.setStationary(true);
        }
        else{
          float hunger = argAg.howHungry();
          argAg.collectRes(lockedRes.lowerRes(min(hunger, RESECOLLECTEDPERSTEP)));
          argAg.setStationary(true);
        }
      }
    }
    else{
      argAg.setStationary(false);
    }
  }
  
  float getPackDirFar(Agent argAg){

    Pack argPack = getPack(argAg);
    
    if(argPack != null){
      ArrayList<Agent> conAg = argPack.getConnected(argAg);
      ArrayList<Float> dirs = new ArrayList<Float>(conAg.size());
      conAg.forEach((ag) -> {
        if(argAg.getDistTo(ag.getX(), ag.getY()) > PACKDIST)
          dirs.add(argAg.dirToFace(ag.getX(), ag.getY()));
      });
      float resDir = directionAddition(dirs);
      return resDir;
    }
    else
      return -1;
  }
  
  float getPackDirClose(Agent argAg){
    
    Pack argPack = getPack(argAg);
    
    if(argPack != null){
      ArrayList<Agent> conAg = argPack.getConnected(argAg);
      ArrayList<Float> dirs = new ArrayList<Float>(conAg.size());
      conAg.forEach((ag) -> {
        if(argAg.getDistTo(ag.getX(), ag.getY()) < COMDIST)
          dirs.add(argAg.dirToFace(ag.getX(), ag.getY()));
      });
      float resDir = directionAddition(dirs);
      if(resDir == -1){
        return -1;
      }
      resDir += (float)Math.PI;
      resDir = fixDir(resDir);
      return resDir;
    }
    else
      return -1;
  }
  
  Pack getSameSpeciesClosestUncomPack(Agent argAg){
    Pack packTooClose = null;
    float minDist = DEFX;
    Pack argPack = getPack(argAg);
    if(argPack == null)
      return null;
    float argX = argPack.getPackCenterX();
    float argY = argPack.getPackCenterY();
    
    for (Iterator<Pack> iter = packs.iterator(); iter.hasNext();){
      Pack pack = iter.next();
      if(!pack.contains(argAg) && pack.getPackSpecies() == argAg.getSpecies()){
        float x = pack.getPackCenterX();
        float y = pack.getPackCenterY();
        float distance = dist(x, y, argX, argY);
        if (minDist > distance && distance < PACKCOMDIST){
          minDist = distance;
          packTooClose = pack;
        }
      }
    }
    return packTooClose;
  }
  
  void directionDecision(Agent argAg){    //Direction decision for a single agent, for lone agents only food decisioning, for pack agents depending on locked bolean variable value either only food, or only pack
    
    agResourceLocking(argAg);
    
    float foodDir = foodDirectionDecision(argAg);
    float packDir = packDirectionDecision(argAg);
    
    if(packDir == -2){
      if(foodDir != -1){
        argAg.setDir(foodDir);
      }
    }
    else{
      if(foodDir != -1){
        argAg.setDir(foodDir);
      }
      else{
        if(packDir != -1){
          argAg.setDir(packDir);
        }
      }
    }
  }
  
  void agResourceLocking(Agent argAg){
    
    Resource lockedRes = argAg.getLockedRes();
    
    if(lockedRes != null){
      if(lockedRes.empty()){
        argAg.lockInResource(null);
      }
    }
    else{
      if(argAg.getConCount() == 0 && argAg.wellFed()){
        return;
      }
      ArrayList<Resource> resources = net.getVisibleResources(argAg.getX(), argAg.getY(), VISUALDIST);
      float minDist = argAg.getDistTo(resources.get(0).getX(), resources.get(0).getY()) + 1;
      int minDistIdx = -1;
      int idx = 0;
      for(Iterator<Resource> iter = resources.iterator(); iter.hasNext();){
        Resource res = iter.next();
        if(!res.empty()){
          float currDist = argAg.getDistTo(res.getX(), res.getY());
          if(minDist > currDist){
            minDist = currDist;
            minDistIdx = idx;
          }
        }
        idx++;
      }
      if(minDistIdx != -1){
        if(minDist <= VISUALDIST){
          Resource foundRes = resources.get(minDistIdx);
          argAg.lockInResource(foundRes);
          return;
        }
      }
      argAg.lockInResource(null);
    }
  }
  
  float foodDirectionDecision(Agent argAg){
    
    if(argAg.getLockedRes() != null){
      return argAg.dirToFace(argAg.getLockedRes().getX(),
                             argAg.getLockedRes().getY()
                             );
    }
    else{
      return -1;
    }
  }
  
  float packDirectionDecision(Agent argAg){
    Pack argPack = getPack(argAg);
    if(argPack == null){
      return -2;
    }
    
    if(argAg == argPack.getLeader()){
      return -1;
    }
    
    Pack closestUncomPack = getSameSpeciesClosestUncomPack(argAg);
    
    float packDirFar = getPackDirFar(argAg);
    float packDirClose = getPackDirClose(argAg);
    
    if(packDirFar != -1){
      return packDirFar;
    }
    
    if(packDirClose != -1 && !argAg.getPackPosIndiff()){
      return packDirClose;
    }
    
    if(closestUncomPack != null && !argAg.getPackPosIndiff()){
      return fixDir(argAg.dirToFace(closestUncomPack.getPackCenterX(), closestUncomPack.getPackCenterY()) + (float)Math.PI);
    }
    
    return -1;
  }
  
  void scream(Agent argAg){
    if(argAg.getConCount() == 0 && argAg.wellFed() && argAg.getLockedRes() == null && argAg.readyToAct()){
      loneAgentConnectionListen(argAg);
    }
    if(argAg.getConCount() == 0 && argAg.getLockedRes() != null){
      loneAgentResScream(argAg);
    }
    if(argAg.getConCount() != 0 && (argAg.getLockedRes() != null || argAg.getLastHeardAge() != -1)){
      packAgentResScream(argAg);
    }
  }
  
  void loneAgentConnectionListen(Agent argAg){
    
    if(argAg.getValence() == 0)
      return;
    
    for(Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      if(ag != argAg && ag.getSpecies() == argAg.getSpecies()){    //Different agent, same species
        float dist = argAg.getDistTo(ag.getX(), ag.getY());
        if(dist <= CONNECTDIST){
          Pack agPack = getPack(ag);
          if(agPack != null){
            if(agPack.addAgent(argAg)){
              break;
            }
          }
          else{
            Pack newPack = new Pack();
            newPack.addAgent(argAg);
            if(newPack.addAgent(ag)){
              packs.add(newPack);
              break;
            }
          }
        }
        else if(dist < SCRHEARDIST){
          argAg.setDir(argAg.dirToFace(ag.getX(), ag.getY()));
        }
      }
    }
  }
  
  void loneAgentResScream(Agent argAg){
    for(Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      float distance = argAg.getDistTo(ag.getX(), ag.getY());
      if(ag.getLockedRes() == null 
      && ag.getConCount() == 0 
      && ag.getSpecies() == argAg.getSpecies() 
      && distance < SCRHEARDIST){
        if(ag.getValence() == 0){
          if(!ag.wellFed()){
            ag.setDir(ag.dirToFace(argAg.getX(), argAg.getY()));
          }
        }
        else{
          ag.setDir(ag.dirToFace(argAg.getX(), argAg.getY()));
        }
      }
    }
  }
  
  void packAgentResScream(Agent argAg){
    Pack argPack = getPack(argAg);
    if(argPack == null)
      return;
    ArrayList<Agent> connAg = argPack.getConnected(argAg);
    connAg.forEach((ag) -> {
      if(argAg.getLockedRes() == null){
        if(ag.getLockedRes() == null){
          if(ag.getLastHeardAge() < argAg.getLastHeardAge()){
            ag.setDir(ag.dirToFace(argAg.getX(), argAg.getY()));
            ag.setLastHeardAge(argAg.getLastHeardAge());
            ag.setPackPosIndiff(true);
          }
        }
        else{
          if(ag.getAge() < argAg.getLastHeardAge()){
            ag.setDir(ag.dirToFace(argAg.getX(), argAg.getY()));
            ag.setLastHeardAge(argAg.getLastHeardAge());
            ag.setPackPosIndiff(true);
            ag.lockInResource(null);
          }
        }        
      }
      else{
        if(ag.getLockedRes() == null){
          if(ag.getLastHeardAge() < argAg.getAge()){
            ag.setDir(ag.dirToFace(argAg.getX(), argAg.getY()));
            ag.setLastHeardAge(argAg.getAge());
            ag.setPackPosIndiff(true);
          }
        }
        else{
          if(ag.getAge() < argAg.getAge()){
            if(ag.getLockedRes() != argAg.getLockedRes()){
              ag.setDir(ag.dirToFace(argAg.getX(), argAg.getY()));
              ag.setLastHeardAge(argAg.getAge());
              ag.setPackPosIndiff(true);
              ag.lockInResource(null);
            }
          }
        }
      }
    });
  }
  
  void fights(){
    
  }
  
  void fight(Agent argAg1, Agent argAg2){
    
    stroke(#CF00FF,100); 
    strokeWeight(2);     
    line(ORIGINX + argAg1.getX(), ORIGINY + argAg1.getY(), ORIGINX + argAg2.getX(), ORIGINY + argAg2.getY());
    
  }
  
  void reproduction(Agent argAg){
    Random r = new Random();
    boolean rep = false;
    float tech = r.nextFloat();
    
    if(argAg.getSpecies() == 0){
      if(tech <= REPRODUCTPROB1)
        rep = true;
    }
    else{
      if(tech <= REPRODUCTPROB2)
        rep = true;
    }
    
    if(rep){
      Agent child = new Agent(argAg.getSpecies(), argAg.getX(), argAg.getY());
      if(argAg.getSpecies() == 0)
        popSp1Ctr++;
      else
        popSp2Ctr++;
      //println("ADDED AGENT CHILD, AGENT COUNT:", agents.size());
      child.setNewBornEnergy();
      argAg.addToEnergy(-REPRODUCTCOST);
      agents.add(child);
      Pack parentPack = getPack(argAg);
      if(parentPack != null){
        parentPack.addAgent(child);
      }
      else{
        Pack newPack = new Pack();
        newPack.addAgent(argAg);
        if(newPack.addAgent(child)){
          packs.add(newPack);
        }
      }
    }
  }
  
  void tick(){                                                                        //Performes animation tick
    ArrayList<Agent> reproductList = new ArrayList<Agent>();
    
    net.replenish();
    
    for (Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
      
      Agent ag = iter.next();
      
      if(ag.dead()){
        removeAgentFromPacks(ag);
        if(ag.getSpecies() == 0)
          popSp1Ctr--;
        else
          popSp2Ctr--;
          
        iter.remove();
        //println("REMOVED DEAD AGENT, AGENT COUNT:", agents.size());
      }
      else{
        
        if(!ag.wellFed() && ag.getConCount() != 0){
          removeAgentFromPacks(ag);
        }
        
        directionDecision(ag);
        scream(ag);
        ag.step();
        agResCollection(ag);
        
        
        if(ag.readyToReproduct()){
          reproductList.add(ag);
        }
        
        if(ag.getConCount() == 0){
          ag.eatCollected();
        }
      }
    }
    
    reproductList.parallelStream().forEach((ag) -> {reproduction(ag);});
    
    packs.parallelStream().forEach((pack) -> {pack.resDistribution();});
    
    fights();
    
    agents.forEach((ag) -> {
      ag.resetCollected();
      ag.resetLastHeardAge();
    });
    
  }
  
  void run(){                                                       //Main method                                                                           //Perform animation tick
    tick();
    render();
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
  
  void renderGraphs(){
    /*grSp1Pop.render();
    grSp2Pop.render();*/
  }
  
  void render(){                                                    //Renders aviary
    background(0);
    renderRes();
    renderPacks();
    renderAgent();
    renderGraphs();
  }
  
  
}
