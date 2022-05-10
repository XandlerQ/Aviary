color WALLCOLOR = #023600;                                                            //Color of aviary boundaries
float WALLTHICKNESS = 1;




class AviaryRivalry {                                                                       //Agent counter
  
  ResourceNet net;
  ArrayList<Agent> agents;                                                         
  ArrayList<Pack> packs;
  
  int popSp1Ctr;
  int popSp2Ctr;
  
  Graph grPop;
  Graph grSp1Pop;
  Graph grSp2Pop;
  Graph grPopPack;
  
  int infCtr = INFOREPCTRPEAK;
  

  //Constructors
  
  AviaryRivalry(int argInitAgentAmnt){                                           
    
    net = new ResourceNet();
    agents = new ArrayList<Agent>(argInitAgentAmnt);                                //Making ArrayLists
    packs = new ArrayList<Pack>();
    
    popSp1Ctr = argInitAgentAmnt / 2;
    popSp2Ctr = argInitAgentAmnt / 2;
    
    for(int i = 0; i < argInitAgentAmnt / 2; i++){                                                //
      agents.add(new Agent(0));                                                      //
    }                                                                                 //Add agents 
    for(int i = 0; i < argInitAgentAmnt / 2; i++){                                                //
      agents.add(new Agent(1));                                                      //
    }                                                                                 //Add agents 
    println("INITIAL AGENT COUNT:", argInitAgentAmnt);
    
    grPop = new Graph(DEFX, 0);
    grPop.setType(1);
    
    /*
    void setgraphBordColor(color argCl){
    graphBordColor = argCl;
  }
  
  void setgraphColor(color argCl){
    graphColor = argCl;
  }
  
  void setgraphLineColor(color argCl){
    graphLineColor = argCl;
  }
  
  void setgraphTextColor(color argCl){
    graphTextColor = argCl;
  }
  */
    
    grSp1Pop = new Graph(DEFX, 200);
    grSp1Pop.setType(1);
    grSp1Pop.setgraphBordColor(#AF0000);
    grSp1Pop.setgraphColor(#FF2E2E);
    grSp1Pop.setgraphLineColor(#FF8B8B);
    grSp1Pop.setgraphTextColor(#FF9203);
    
    grSp2Pop = new Graph(DEFX, 400);
    grSp2Pop.setType(1);
    grSp2Pop.setgraphBordColor(#0AAA00);
    grSp2Pop.setgraphColor(#10FF00);
    grSp2Pop.setgraphLineColor(#53FF48);
    grSp2Pop.setgraphTextColor(#03FFCA);
    
    grPopPack = new Graph(0, 600);
    grPopPack.setSize(1000,200);
    grPopPack.setType(0);
    grPopPack.setXAmnt(400);
  }
  
  //Getters
  
  //Setters
  
  //Methods
  
  int getPack(Agent argAg){
    int idx = -1;
    int at = 0;
    for (Iterator<Pack> iter = packs.iterator(); iter.hasNext();){
      Pack pck = iter.next();
      if(pck.contains(argAg)){
        idx = at;
        return idx;
      }
      at++;
    }
    return idx;
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
  
  int countLoneAgent(){
    int Ctr = 0;
    for (Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      int packIdx = getPack(ag);
      if(packIdx == -1)
        Ctr++;
    }
    return Ctr;
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
      
    /*if(packIdx != -1 && packs.get(packIdx).getAgent(0) != argAg)
      return argAg.dirToFace(packs.get(packIdx).getAgent(0).getX(), packs.get(packIdx).getAgent(0).getY());
    else
      return 0;*/
  }
  
  float getPackMaxDist(Agent argAg){
    
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
  
  float getPackMinDist(Agent argAg){
    
    int packIdx = getPack(argAg);
    if(packIdx != -1){
      ArrayList<Agent> conAg = packs.get(packIdx).getConnected(argAg);
      float minDist = DEFX;
      for (Iterator<Agent> iter = conAg.iterator(); iter.hasNext();){
        Agent ag = iter.next();
        float distTo = argAg.getDistTo(ag.getX(), ag.getY());
        if (minDist > distTo)
          minDist = distTo;
      }
      return minDist;
    }
    else{
      return -1;
    }
  }
  
  /*void screams(){                                                                     //Perform screams if ready
    agents.forEach((agent) -> {
      if(agent.ifReadyToAct())
        scream(agent);
    });
  }*/
  
  Pack getSameSpeciesClosestUncomPack(Agent argAg){
    Pack packTooClose = null;
    float minDist = DEFX;
    int argPackIdx = getPack(argAg);
    if(argPackIdx == -1)
      return null;
    Pack argPack = packs.get(argPackIdx);
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
  
  float calculateDir(Agent argAg){
    
    float packMaxDist = getPackMaxDist(argAg);
    float packMinDist = getPackMinDist(argAg);
    float gradDir = getGradDir(argAg, argAg.getQuadX(), argAg.getQuadY());
    float packDir = getPackDir(argAg);
    
    if(packMinDist < 0 || packMaxDist < 0){
      return gradDir;
    }
    else{
      
      if(packMaxDist > SCRHEARDIST){
        return packDir;
      }
      if(packMinDist < COMDIST){
        ArrayList<Agent> closeAg = packs.get(getPack(argAg)).getTooClose(argAg);
        float tooCloseX = 0;
        float tooCloseY = 0;
        int tooCloseCount = closeAg.size();
        for (Iterator<Agent> iter = closeAg.iterator(); iter.hasNext();){
          Agent ag = iter.next();
          tooCloseX += ag.getX() / tooCloseCount;
          tooCloseY += ag.getY() / tooCloseCount;
        }
        return (argAg.dirToFace(tooCloseX, tooCloseY) + (float)Math.PI);
      }
      Pack packTooClose = getSameSpeciesClosestUncomPack(argAg);
      if(packTooClose != null){
        //println("\nFOUND PACK TOO CLOSE, TRY TO GO AWAY!!!!!!!\n");
        return (argAg.dirToFace(packTooClose.getPackCenterX(), packTooClose.getPackCenterY()) + (float)Math.PI); 
      }
        
    }
      return gradDir;
  }
  
  void scream(Agent argAg){                                                           //Performs scream of agent                                                     //For each agent
    //println("START OF AGENT SCREAM //////////////////////////////////");
    int packIdx = getPack(argAg);
    //println("SCREAMING AGENT IDX:", agents.indexOf(argAg));
    //println("PACK OF SCREAMER:", packIdx);
    float dirToSet = 0;
    
    if(!argAg.wellFed()){
      //println("NOT WELL FED");
      if(packIdx != -1){
        //println("PACK OF SCREAMER:", packIdx, "REMOVING AGENT FROM PACKS:");
        removeAgentFromPacks(argAg);
      }
      dirToSet = calculateDir(argAg);
    }
    else{
      //println("WELL FED");
      if(packIdx != -1){
        //println("ALLREADY IN PACK");
        dirToSet = calculateDir(argAg);
      }
      else{
        //println("NOT IN PACK");
        for (Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
          Agent ag = iter.next();
          if(argAg != ag){
            if(ag.wellFed()){
              //println("OTHER AGENT IS ALSO WELL FED");
              float dist = argAg.getDistTo(ag.getX(), ag.getY());
            
              if(argAg.getSpecies() == ag.getSpecies()){
                if(dist < CONNECTDIST){
                  //println("CONNECTION DISTANCE");
                  int agPackIdx = getPack(ag);
                  //println("PACK OF OTHER:", agPackIdx);
                  if(agPackIdx != -1){
                    //println("PACK EXISTS, ADDING CURRENT AGENT TO PACK:", agPackIdx);
                    if(packs.get(agPackIdx).addAgent(argAg)){
                      break;
                    }
                  }
                  else{
                    //println("PACK DOESN'T EXIST, MAKING NEW PACK");
                    Pack newPack = new Pack();
                    newPack.addAgent(argAg);
                    //println("AGENTS OF INDEXES ENTERED NEW PACK:", agents.indexOf(argAg), agents.indexOf(ag));
                    if(newPack.addAgent(ag)){
                      packs.add(newPack);
                      dirToSet = calculateDir(argAg);
                      break;
                    }
                    //println("added new pack, current pack count:", packs.size());
                  }
                  
                }
                else if(dist < SCRHEARDIST){
                  //println("NOT CONNECTION DIST, SCRHEAR");
                  dirToSet = argAg.dirToFace(ag.getX(), ag.getY());
                }
                else{
                  //println("NOT CONNECTION DIST, TOO FAR");
                  dirToSet = calculateDir(argAg);
                }
              }
              else{
                dirToSet = calculateDir(argAg);
              }
            }
            else{
              //println("OTHER AGENT IS NOT WELL FED");
            }
          }
          else{
            //println("SAME AGENT FOUND");
            dirToSet = calculateDir(argAg);
          }
        }
      }
    }
    
    argAg.setDir(dirToSet);
    //println("FINISH //////////////////////////////////\n");
    //println("\n -----------------------------\n PACK COUNT FOR THIS SCREAM:", packs.size(), "\n----------------------------------------\n");
  }
  
  void fights(){
    for (Iterator<Agent> iter1 = agents.iterator(); iter1.hasNext();){
      Agent ag1 = iter1.next();
      for (Iterator<Agent> iter2 = agents.iterator(); iter2.hasNext();){
        Agent ag2 = iter2.next();
        if(LONEFIGHTERS != true){
          int packIdx1 = getPack(ag1);
          int packIdx2 = getPack(ag2);
          if(packIdx1 != -1 || packIdx2 != -1)
            if(ag1.getSpecies() != ag2.getSpecies() && ag1.getDistTo(ag2.getX(), ag2.getY()) <= FIGHTDIST){
            fight(ag1, ag2);
          }
        }
        else{
          if(ag1.getSpecies() != ag2.getSpecies() && ag1.getDistTo(ag2.getX(), ag2.getY()) <= FIGHTDIST){
            fight(ag1, ag2);
          }
        }
      }
    }
  }
  
  void fight(Agent argAg1, Agent argAg2){
    int packIdx1 = getPack(argAg1);
    int packIdx2 = getPack(argAg2);
    int coef1;
    int coef2;
    
    if(packIdx1 != -1){
      coef1 = argAg1.getConCount() + 1;
    }
    else{
      coef1 = 1;
    }
    
    if(packIdx2 != -1){
      coef2 = argAg2.getConCount() + 1;
    }
    else{
      coef2 = 1;
    }
        
    argAg1.addToEnergy(-ENERGYPERFIGHT / coef1);
    argAg2.addToEnergy(-ENERGYPERFIGHT / coef2);
    
    stroke(#CF00FF,100); 
    strokeWeight(2);     
    line(argAg1.getX(), argAg1.getY(), argAg2.getX(), argAg2.getY());
    
  }
  
  void reproduction(Agent argAg){
    Random r = new Random();
    
    float tech = r.nextFloat();
    if(tech <= REPRODUCTPROB){
      Agent child = new Agent(argAg.getSpecies(), argAg.getX(), argAg.getY());
      if(argAg.getSpecies() == 0)
        popSp1Ctr++;
      else
        popSp2Ctr++;
      //println("ADDED AGENT CHILD, AGENT COUNT:", agents.size());
      child.setNewBornEnergy();
      argAg.addToEnergy(-REPRODUCTCOST);
      agents.add(child);
      int parentPackIdx = getPack(argAg);
      if(parentPackIdx != - 1){
        packs.get(parentPackIdx).addAgent(child);
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
      
      int quadX = ag.getQuadX();
      int quadY = ag.getQuadY();
      
      agEat(ag, quadX, quadY);
      
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
        ag.step();
        
        if(ag.ifReadyToAct()){
          scream(ag);
        }
        if(ag.readyToReproduct()){
          reproductList.add(ag);
        }
      }
    }
    
    reproductList.forEach((ag) -> {reproduction(ag);});
    
    packs.forEach((pack) -> {pack.energyBalancing();});
    fights();
                                                                   //Perform screams
    if(infCtr == INFOREPCTRPEAK){
      grPop.addTimePoint(agents.size());
      grSp1Pop.addTimePoint(popSp1Ctr);
      grSp2Pop.addTimePoint(popSp2Ctr);
      grPopPack.addPoint(countLoneAgent(), packs.size());
    }
    
    infCtr++;
    
    if(infCtr > INFOREPCTRPEAK){
      infCtr = 0;
    }
  }
  
  void run(){                                                       //Main method                                                                           //Perform animation tick
    render();
    tick();
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
    grPop.render();
    grSp1Pop.render();
    grSp2Pop.render();
    grPopPack.render();
  }
  
  void render(){                                                    //Renders aviary
    background(0);
    renderRes();
    renderPacks();
    renderAgent();
    renderGraphs();
  }
  
  
}
