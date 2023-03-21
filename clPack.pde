class Pack {
  
  private ArrayList<Agent> agents;
  private ArrayList<Connection> connections;
  private int species;
  private int balancingCtr;
  
  //--------------------------------------
  //-----------  Constructors  -----------
  //---------------------------------------
  
  Pack() {
    this.agents = new ArrayList<Agent>();
    this.connections = new ArrayList<Connection>();
    this.species = -1;
    this.balancingCtr = 0;
  }
  
  //---------------------------------------
  //---------------------------------------
  
  //---------------------------------
  //-----------  Getters  -----------
  //---------------------------------
  
  Agent getAgent(int id) {
    if(id >= 0 && id < this.agents.size())
      return this.agents.get(id);
    else
      return null;
  }
  
  ArrayList<Agent> getAgents() {
    return this.agents;
  }
  
  int getAgentCount() {
    return this.agents.size();
  }
  
  int getConnectionCount() {
    return this.connections.size();
  }
  
  int getPackSpecies() {
    return this.species;
  }
  
  boolean contains(Agent argAg){
    return agents.contains(argAg);
  }
  
  boolean empty(){
    return agents.size() < 2 || connections.size() == 0;
  }
  
  ArrayList<Agent> getConnected(Agent ag) {
    ArrayList<Agent> conAg = new ArrayList<Agent>();
    for (Iterator<Connection> iter = this.connections.iterator(); iter.hasNext();){
      Connection con = iter.next();
      if(con.contains(ag)){
        conAg.add(con.pairOf(ag));
      }
    }
    return conAg;
  }
  
  Dot getPackCenter() {
    float X = 0, Y = 0;
    int sz = this.agents.size();
    for (Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      X += ag.getY() / sz;
      Y += ag.getX() / sz;
    }
    return new Dot(X,Y);
  }
  
  
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Setters  -----------
  //---------------------------------
  
  void resetBalancingCtr(){
    this.balancingCtr = 0;
  }
  
  //---------------------------------
  //---------------------------------
  
  //---------------------------------
  //-----------  Methods  -----------
  //---------------------------------
  
  boolean addAgent(Agent argAg){
    
    boolean everConnected = false;
    
    if(this.agents.size() == 0){
      this.species = argAg.getSpecies();
      agents.add(argAg);
      everConnected = true;
      return everConnected;
    }
    
    if(this.agents.contains(argAg)){
      everConnected = true;
      return everConnected;
    }

    for (Iterator<Agent> iter = this.agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      if(!ag.isTopCon()
         && !argAg.isTopCon() 
         && argAg.getDistTo(ag.getX(), ag.getY()) <= CONNECTDIST + 10){
        everConnected = true;
        Connection newCon = new Connection(argAg, ag);
        if(!connections.contains(newCon))
          connections.add(newCon);
        //println("added connection, total connection amount for this pack: ", connections.size());
        argAg.addCon();
        ag.addCon();
        if(argAg.isTopCon())
          break;
      }
    }
    if(everConnected){
      this.agents.add(argAg);
    }
    return everConnected;
  }
  
  
  void removeAgent(Agent argAg){
    if(!this.agents.contains(argAg)){
      return;
    }
    
    int connectionsFound = 0;
    ArrayList<Agent> agToConnect = new ArrayList<Agent>();
    for (Iterator<Connection> iter = this.connections.iterator(); iter.hasNext();){
      Connection con = iter.next();
      if(con.contains(argAg)){
        //println("found a connection to delete");
        agToConnect.add(con.pairOf(argAg));
        con.pairOf(argAg).removeCon();
        iter.remove();
        connectionsFound++;
        if(connectionsFound == argAg.getConCount())
          break;
      }
    }
    this.agents.remove(argAg);
    argAg.resetConCount();
    if(agToConnect.size() >= 2){
      reconnect(agToConnect);
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
         && !this.connections.contains(newCon)){
          this.connections.add(newCon);
          ag1.addCon();
          ag2.addCon();
         }
      }
    }
    fixCutOff(agToConnect);
  }
  
  
  void fixCutOff(ArrayList<Agent> agToConnect){
    for (Iterator<Agent> iter = agToConnect.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      boolean isCutOff = true;
      for (Iterator<Connection> iterCon = this.connections.iterator(); iterCon.hasNext();){
        Connection con = iterCon.next();
        if(con.contains(ag)){
          isCutOff = false;
          break;
        }
      }
      if(isCutOff){
        agents.remove(ag);
      }
    }
  }
  
  
  void collectedResDistribution(){
    float resToDistr = 0;
    int agCount = agents.size();
    for(Iterator<Agent> iter = this.agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      resToDistr += ag.getCollectedRes();
    }
    
    for(Iterator<Agent> iter = this.agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      ag.eat(resToDistr/agCount);
    }
  }
  
  void resDistribution(float resToDistr){
    int agCount = this.agents.size();
    if(agCount != 0)
      this.agents.forEach((ag) -> {ag.eat(resToDistr/agCount);});
  }
  
  float getMedHunger(){
    float hunger = 0;
    int agCount = this.agents.size();
    for(Iterator<Agent> iter = this.agents.iterator(); iter.hasNext();){
      Agent ag = iter.next();
      hunger += ag.howHungry();
    }
    
    return hunger / agCount;
  }
  
  void energyDepletion(){
    for (Iterator<Connection> iter = this.connections.iterator(); iter.hasNext();){
      Connection con = iter.next();
      Agent ag1 = con.getFirst();
      Agent ag2 = con.getSecond();
      ag1.addToEnergy(-NRGFORCONPERSTEP);
      ag2.addToEnergy(-NRGFORCONPERSTEP);
    }
  }
  
  
  //---------------------------------
  //---------------------------------
    
  
  //-----------------------------------
  //-----------  Renderers  -----------
  //-----------------------------------
  
  void render(){
    connections.forEach((con) -> {
      Agent ag1 = con.getFirst();
      Agent ag2 = con.getSecond();
      if(getPackSpecies() == 0){
        stroke(#FF8181,100);
        fill(#FF8181,100);
      }
      else{
        stroke(#81FF94,100);
        fill(#81FF94,100);
      }
      strokeWeight(1);     
      line(ORIGINX + ag1.getX(), ORIGINY + ag1.getY(), ORIGINX + ag2.getX(), ORIGINY + ag2.getY());
    });
    
    circle(ORIGINX + getAgent(0).getX(), ORIGINY + getAgent(0).getY(), 10);
    
  }
  
  //-----------------------------------
  //-----------------------------------
}
