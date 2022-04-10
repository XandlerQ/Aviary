
class Connection{
  public int ag1;
  public int ag2;
  
  Connection(int argAg1, int argAg2){
    ag1 = argAg1;
    ag2 = argAg2;
  }
  
  boolean contains(int argId){
    return ag1 == argId || ag2 == argId;
  }
  
  int getFirst(){
    return ag1;
  }
  
  int getSecond(){
    return ag2;
  }
  
  
}

class Pack{
  
  ArrayList<Agent> pack;
  
  int packSize;
  float connectDist;
  
  ArrayList<Connection> connections;
  
  //Constructors
  
  Pack(){
    pack = new ArrayList<Agent>();
    packSize = 0;
    connectDist = 50;
    connections = new ArrayList<Connection>();
  }
  
  //Methods
  
  void addAgent(Agent argAg){
    pack.forEach((ag) -> {
      int at = 0;
      if(!ag.isTopCon()
         && !argAg.isTopCon()){
        connections.add(new Connection(packSize, at));
        ag.addCon();
        argAg.addCon();
      }
    });
    pack.add(argAg);
    packSize++;
  }
  
  void removeAgent(Agent argAg){
    int idx = pack.indexOf(argAg);
    for (Iterator<Connection> iter = connections.iterator(); iter.hasNext();){
      Connection pr = iter.next();
      if(pr.contains(idx))
        iter.remove();
    }
    pack.remove(idx);
  }
  
  boolean contains(Agent argAg){
    return pack.contains(argAg);
  }
    
  
  //Renderers
  
  void render(){
    connections.forEach((con) -> {
      int idx1 = con.getFirst();
      int idx2 = con.getSecond();
      stroke(#12E5FF,150); 
      strokeWeight(1);     
      line(pack.get(idx1).getX(), pack.get(idx1).getY(), pack.get(idx2).getX(), pack.get(idx2).getY());
    });
    
  }
}
