import java.awt.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.concurrent.atomic.AtomicInteger;

public class Pack {

    static AtomicInteger packIdGen = new AtomicInteger(0);

    private final int id;
    private ArrayList<Agent> agents;
    private ArrayList<Connection> connections;
    private int species;
    private int balancingCtr;

    //--------------------------------------
    //-----------  Constructors  -----------
    //---------------------------------------

    Pack() {
        this.id = packIdGen.incrementAndGet();
        this.agents = new ArrayList<>();
        this.connections = new ArrayList<>();
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

    public int getId() { return id; }

    ArrayList<Agent> getAgents() { return this.agents; }

    int getAgentCount() { return this.agents.size(); }

    int getConnectionCount() { return this.connections.size(); }

    int getPackSpecies() { return this.species; }

    boolean contains(Agent argAg){ return agents.contains(argAg); }

    boolean empty(){ return agents.size() < 2 || connections.size() == 0; }

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

    void resetBalancingCtr(){ this.balancingCtr = 0; }

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
            if(!ag.topCon()
                    && !argAg.topCon()
                    && argAg.getDistTo(ag.getX(), ag.getY()) <= App.CONNECTDIST + 10){
                everConnected = true;
                Connection newCon = new Connection(argAg, ag);
                if(!connections.contains(newCon))
                    connections.add(newCon);
                //println("added connection, total connection amount for this pack: ", connections.size());
                argAg.addCon();
                ag.addCon();
                if(argAg.topCon())
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
        ArrayList<Agent> agToConnect = new ArrayList<>();
        for (Iterator<Connection> iterator = this.connections.iterator(); iterator.hasNext();){
            Connection con = iterator.next();
            if(con.contains(argAg)){
                //println("found a connection to delete");
                agToConnect.add(con.pairOf(argAg));
                con.pairOf(argAg).removeCon();
                iterator.remove();
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
                if(!ag1.topCon()
                        && !ag2.topCon()
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

        double deal = resToDistr/agCount;

        for(Iterator<Agent> iter = this.agents.iterator(); iter.hasNext();){
            Agent ag = iter.next();
            double eaten = Math.min(ag.getHunger(), deal);
            ag.eat(eaten);
            resToDistr -= eaten;
        }

        if(resToDistr == 0) return;
        else {
            for(Iterator<Agent> iter = this.agents.iterator(); iter.hasNext();) {
                Agent ag = iter.next();
                if (ag.getHunger() != 0) {
                    if (ag.getHunger() < resToDistr) {
                        ag.eat(ag.getHunger());
                        resToDistr -= ag.getHunger();
                    }
                    else {
                        ag.eat(resToDistr);
                        break;
                    }
                }
            }
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
            hunger += ag.getHunger();
        }

        return hunger / agCount;
    }

    void energyDepletion(){
        for (Iterator<Connection> iter = this.connections.iterator(); iter.hasNext();){
            Connection con = iter.next();
            Agent ag1 = con.getFirst();
            Agent ag2 = con.getSecond();
            ag1.addToEnergy(-App.NRGFORCONPERSTEP);
            ag2.addToEnergy(-App.NRGFORCONPERSTEP);
        }
    }

    @Override
    public boolean equals(Object obj){
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        Pack arg = (Pack) obj;
        return this.id == arg.id;
    }


    //---------------------------------
    //---------------------------------


    //-----------------------------------
    //-----------  Renderers  -----------
    //-----------------------------------

    void render(){
        App.processingRef.stroke(Color.RED.getRGB(),50);
        App.processingRef.fill(Color.WHITE.getRGB(),50);
        App.processingRef.circle(App.ORIGINX + (float)this.agents.get(0).getX(), App.ORIGINY + (float)this.agents.get(0).getY(), 10);
        connections.forEach((con) -> {
            Agent ag1 = con.getFirst();
            Agent ag2 = con.getSecond();
            if(getPackSpecies() == 0){
                App.processingRef.stroke(Color.RED.getRGB(),100);
                App.processingRef.fill(Color.RED.getRGB(),100);
            }
            else{
                App.processingRef.stroke(Color.GREEN.getRGB(),100);
                App.processingRef.fill(Color.GREEN.getRGB(),100);
            }
            App.processingRef.strokeWeight(1);
            App.processingRef.line((float)(App.ORIGINX + ag1.getX()), (float)(App.ORIGINY + ag1.getY()), (float)(App.ORIGINX + ag2.getX()), (float)(App.ORIGINY + ag2.getY()));
        });

    }

    //-----------------------------------
    //-----------------------------------
}
