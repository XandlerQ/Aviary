
class Connection{
  public Agent ag1;
  public Agent ag2;
  
  Connection(Agent argAg1, Agent argAg2){
    ag1 = argAg1;
    ag2 = argAg2;
  }
  
  boolean contains(Agent argAg){
    return ag1 == argAg || ag2 == argAg;
  }
  
  @Override
  public boolean equals(Object obj){
    if (this == obj)
      return true;
    if (obj == null)
      return false;
    Connection arg = (Connection) obj;
    return (arg.getFirst() == ag1 && arg.getSecond() == ag2)
            ||(arg.getFirst() == ag2 && arg.getSecond() == ag1);
  }
  
  Agent pairOf(Agent argAg){
    if(contains(argAg)){
      if(ag1 == argAg)
        return ag2;
      else
        return ag1;
    }
    return null;
  }
  
  Agent getFirst(){
    return ag1;
  }
  
  Agent getSecond(){
    return ag2;
  }
  
  
}

class Pack{
  
  ArrayList<Agent> agents;
  
  float connectDist;
  
  ArrayList<Connection> connections;
  
  //Constructors
  
  Pack(){
    agents = new ArrayList<Agent>();
    connectDist = CONNECTDIST;
    connections = new ArrayList<Connection>();
  }
  
  //Methods
  
  boolean addAgent(Agent argAg){
    
    boolean everConnected = false;
    
    if(agents.size() == 0){
      //println("added agent to empty pack");
      agents.add(argAg);
      everConnected = true;
      return everConnected;
    }
    
    if(agents.contains(argAg)){
      //println("tried to enter your own pack");
      everConnected = true;
      return everConnected;
    }

    for (Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      if(!ag.isTopCon()
         && !argAg.isTopCon() 
         && argAg.getDistTo(ag.getX(), ag.getY()) <= CONNECTDIST + 10){
        everConnected = true;
        Connection newCon = new Connection(argAg, ag);
        if(!connections.contains(newCon))
          connections.add(newCon);
        //println("added connection, total connection amount for this pack: ", connections.size());
        ag.addCon();
        argAg.addCon();
      }
    }
    if(everConnected){
      agents.add(argAg);
    }
    return everConnected;
  }
  
  void removeAgent(Agent argAg){
    if(!agents.contains(argAg)){
      //println("removing agent from pack: THIS AGENT IS NOT IN THIS PACK");
      return;
    }
    //println("removing agent from pack");
    ArrayList<Agent> agToConnect = new ArrayList<Agent>();
    for (Iterator<Connection> iter = connections.iterator(); iter.hasNext();){
      Connection con = iter.next();
      if(con.contains(argAg)){
        //println("found a connection to delete");
        agToConnect.add(con.pairOf(argAg));
        con.pairOf(argAg).removeCon();
        iter.remove();
      }
    }
    agents.remove(argAg);
    argAg.resetConCount();
    //println("agToConnect size for this deletion:", agToConnect.size());
    if(agToConnect.size() >= 2)
      reconnect(agToConnect);
    
  }
  
  void energyBalancing(){
    for (Iterator<Connection> iter = connections.iterator(); iter.hasNext();){
      Connection con = iter.next();
      Agent ag1 = con.getFirst();
      Agent ag2 = con.getSecond();
      float difference = ag1.getEnergy() - ag2.getEnergy();
      if(Math.abs(difference) < ENERGYBALANCESPEED){
          ag1.addToEnergy(-difference / 2);
          ag2.addToEnergy(difference / 2);
      }
      else{
        if(difference > 0){
          ag1.addToEnergy(-ENERGYBALANCESPEED);
          ag2.addToEnergy(ENERGYBALANCESPEED);
        }
        else{
          ag1.addToEnergy(ENERGYBALANCESPEED);
          ag2.addToEnergy(-ENERGYBALANCESPEED);
        }
      }
    }
  }
  
  void reconnect(ArrayList<Agent> agToConnect){
    for(int i = 0; i < agToConnect.size(); i++){
      for(int j = i + 1; j < agToConnect.size(); j++){
        Agent ag1 = agToConnect.get(i);
        Agent ag2 = agToConnect.get(j);
        Connection newCon = new Connection(ag1, ag2);
        if(!ag1.isTopCon()
         && !ag2.isTopCon()
         && !connections.contains(newCon)){
          //println("added a reconnection!!!");
          connections.add(newCon);
          ag1.addCon();
          ag2.addCon();
         }
      }
    }
  }
  
  boolean contains(Agent argAg){
    return agents.contains(argAg);
  }
  
  boolean empty(){
    return agents.size() < 2 || connections.size() == 0;
  }
  
  ArrayList<Agent> getConnected(Agent argAg){
    ArrayList<Agent> conAg = new ArrayList<Agent>();
    for (Iterator<Connection> iter = connections.iterator(); iter.hasNext();){
      Connection con = iter.next();
      if(con.contains(argAg)){
        conAg.add(con.pairOf(argAg));
      }
    }
    return conAg;
  }
  
  int getConCount(Agent argAg){
    int conCount = 0;
    for (Iterator<Connection> iter = connections.iterator(); iter.hasNext();){
      Connection con = iter.next();
      if(con.contains(argAg)){
        conCount++;
      }
    }
    return conCount;
  }
  
  ArrayList<Agent> getTooClose(Agent argAg){
    ArrayList<Agent> closeAg = new ArrayList<Agent>();
    for (Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      if(argAg.getDistTo(ag.getX(), ag.getY()) < COMDIST && argAg != ag){
        closeAg.add(ag);
      }
    }
    return closeAg;
  }
  
  float getPackCenterX(){
    float resX = 0;
    int sz = agents.size();
    for (Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      resX += ag.getX() / sz;
    }
    return resX;
  }
  
  float getPackCenterY(){
    float resY = 0;
    int sz = agents.size();
    for (Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      resY += ag.getY() / sz;
    }
    return resY;
  }
  
  int getPackSpecies(){
    return agents.get(0).getSpecies();
  }
    
  
  //Renderers
  
  void render(){
    connections.forEach((con) -> {
      Agent ag1 = con.getFirst();
      Agent ag2 = con.getSecond();
      stroke(#12E5FF,150); 
      strokeWeight(1);     
      line(ag1.getX(), ag1.getY(), ag2.getX(), ag2.getY());
    });
    
  }
}
