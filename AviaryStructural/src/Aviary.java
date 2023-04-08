import java.awt.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Random;

public class Aviary {

    Color rivalryCl = new Color(207, 0, 255);
    ResourceGroup resGroup;
    PropertyGrid<Integer> propertyGrid;
    ArrayList<Agent> agents;
    ArrayList<Pack> packs;


    //--------------------------------------
    //-----------  Constructors  -----------
    //--------------------------------------

    Aviary () {
        this.resGroup = Builder.buildResourceGroup();
        this.propertyGrid = new PropertyGrid<>(App.DEFX, App.DEFY, 2, 2);
        this.propertyGrid.fillPropertyAreas(App.PROPERTY_AREA_VALUES, App.PROPERTY_AREA_COLORS);
        this.agents = Builder.buildAgentArray();
        packs = new ArrayList<>();
    }

    //--------------------------------------
    //--------------------------------------

    //---------------------------------
    //-----------  Getters  -----------
    //---------------------------------


    public Color getRivalryCl() {
        return rivalryCl;
    }

    public ResourceGroup getResGroup() {
        return resGroup;
    }

    public PropertyGrid<Integer> getPropertyGrid() {
        return propertyGrid;
    }

    public ArrayList<Agent> getAgents() {
        return agents;
    }

    public ArrayList<Pack> getPacks() {
        return packs;
    }

    //---------------------------------

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


    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Setters  -----------
    //---------------------------------

    public void setRivalryCl(Color rivalryCl) {
        this.rivalryCl = rivalryCl;
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Methods  -----------
    //---------------------------------

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

    //------Resource calculations------

    void agResourceLocking(Agent argAg){

        ResourceNode lockedRes = argAg.getLockedRes();

        if(lockedRes != null){
            if(lockedRes.empty() || argAg.getDistTo(lockedRes.getCoordinates()) > App.VISUALDIST){
                argAg.setLockedRes(null);
                argAg.setStationary(false);
            }
        }
        else{
            if(argAg.getConCount() == 0 && argAg.wellFed()){
                return;
            }
            ArrayList<ResourceNode> resources = resGroup.getVisibleResNodes(argAg.getX(), argAg.getY(), App.VISUALDIST);
            double minDist = argAg.getDistTo(resources.get(0).getCoordinates()) + 1;
            int minDistIdx = -1;
            int idx = 0;
            for(Iterator<ResourceNode> iter = resources.iterator(); iter.hasNext();){
                ResourceNode res = iter.next();
                if(!res.empty()){
                    double currDist = argAg.getDistTo(res.getCoordinates());
                    if(minDist > currDist){
                        minDist = currDist;
                        minDistIdx = idx;
                    }
                }
                idx++;
            }
            if(minDistIdx != -1){
                if(minDist <= App.VISUALDIST){
                    ResourceNode foundRes = resources.get(minDistIdx);
                    argAg.setLockedRes(foundRes);
                    return;
                }
            }
            argAg.setLockedRes(null);
        }
    }

    void agResCollection(Agent argAg){
        ResourceNode lockedRes = argAg.getLockedRes();
        if(lockedRes == null){
            argAg.setStationary(false);
            return;
        }
        double dist = argAg.getDistTo(lockedRes.getCoordinates());
        if(dist <= lockedRes.getSize() + 4){
            if(argAg.getConCount() == 0){
                double hunger = argAg.getHunger();
                if(hunger == 0){
                    argAg.setLockedRes(null);
                    argAg.setStationary(false);
                }
                else{
                    argAg.collect(lockedRes.lowerRes(App.RESECOLLECTEDPERSTEP));
                    argAg.setStationary(true);
                }
            }
            else{
                Pack pck = getPack(argAg);
                if(pck != null){
                    double packHunger = getPack(argAg).getMedHunger();
                    argAg.collect(lockedRes.lowerRes(Math.min(packHunger, App.RESECOLLECTEDPERSTEP)));
                    argAg.setStationary(true);
                }
            }
        }
        else{
            argAg.setStationary(false);
        }
    }

    //---Pack direction calculations---

    double getPackDirFar(Agent argAg){

        Pack argPack = getPack(argAg);

        if(argPack != null){
            ArrayList<Agent> conAg = argPack.getConnected(argAg);
            ArrayList<Double> dirs = new ArrayList<>(conAg.size());
            for(Iterator<Agent> iter = conAg.iterator(); iter.hasNext();) {
                Agent ag = iter.next();
                if(argAg.getDistTo(ag.getX(), ag.getY()) > App.PACKDIST)
                    dirs.add(argAg.dirToFace(ag.getX(), ag.getY()));
            }
            double resDir = Direction.directionAddition(dirs);
            return resDir;
        }
        else
            return -1;
    }

    double getPackDirClose(Agent argAg){

        Pack argPack = getPack(argAg);

        if(argPack != null){
            ArrayList<Agent> conAg = argPack.getConnected(argAg);
            ArrayList<Double> dirs = new ArrayList<>(conAg.size());
            for (Iterator<Agent> iter = conAg.iterator(); iter.hasNext();) {
                Agent ag = iter.next();
                if(argAg.getDistTo(ag.getX(), ag.getY()) < App.COMDIST)
                    dirs.add(argAg.dirToFace(ag.getX(), ag.getY()));
            }
            double resDir = Direction.directionAddition(dirs);
            if(resDir == -1){
                return -1;
            }
            resDir += Math.PI;
            resDir = Direction.normalizeDirection(resDir);
            return resDir;
        }
        else
            return -1;
    }

    Pack getSameSpeciesClosestUncomPack(Agent argAg){
        Pack packTooClose = null;
        double minDist = App.DEFX;
        Pack argPack = getPack(argAg);
        if(argPack == null)
            return null;

        for (Iterator<Pack> iter = packs.iterator(); iter.hasNext();){
            Pack pack = iter.next();
            if(!(argPack == pack) && pack.getPackSpecies() == argAg.getSpecies()){
                Dot packCoordinates = pack.getPackCenter();
                double distance = argAg.getDistTo(packCoordinates);
                if (minDist > distance && distance < App.PACKCOMDIST){
                    minDist = distance;
                    packTooClose = pack;
                }
            }
        }
        return packTooClose;
    }

    //-----Direction calculations-----

    double foodDirectionDecision(Agent argAg){

        if(argAg.getLockedRes() != null){
            return argAg.dirToFace(argAg.getLockedRes().getCoordinates());
        }
        else{
            return -1;
        }
    }

    void directionDecision(Agent argAg){    //Direction decision for a single agent, for lone agents only food decisioning, for pack agents depending on locked bolean variable value either only food, or only pack


        double packDirClose = getPackDirClose(argAg);
        double packDirFar = getPackDirFar(argAg);

        Pack argPack = getPack(argAg);

        if(argPack == null){
            agResourceLocking(argAg);
            double foodDir = foodDirectionDecision(argAg);
            if(foodDir != -1){
                argAg.setDirection(foodDir);
            }
        }
        else{
            if(packDirFar != -1) {
                argAg.setDirection(packDirFar);
                return;
            }
            agResourceLocking(argAg);
            double foodDir = foodDirectionDecision(argAg);
            if(foodDir != -1){
                argAg.setDirection(foodDir);
                return;
            }
            if(packDirClose != -1) {
                argAg.setDirection(packDirClose);
                return;
            }

            Pack packToClose = getSameSpeciesClosestUncomPack(argAg);

            if(packToClose != null) {
                argAg.setDirection(argAg.dirToFace(packToClose.getPackCenter()) + Math.PI);
            }
        }
    }

    //-------------Screams-------------

    void scream(Agent argAg){
        if(argAg.getConCount() == 0 && argAg.wellFed() && argAg.getLockedRes() == null && argAg.readyToAct()){
            loneAgentConnectionListen(argAg);
        }
        if(argAg.getConCount() == 0 && argAg.getLockedRes() != null){
            loneAgentResScream(argAg);
        }
        if(argAg.getConCount() != 0){
            packAgentResListen(argAg);
        }
    }

    void loneAgentConnectionListen(Agent argAg){

        if(argAg.getValence() == 0)
            return;

        for(Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
            Agent ag = iter.next();
            if(ag != argAg && ag.getSpecies() == argAg.getSpecies()){    //Different agent, same species
                double dist = argAg.getDistTo(ag.getX(), ag.getY());
                if(dist <= App.CONNECTDIST){
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
                else if(dist < App.SCRHEARDIST){
                    argAg.face(ag.getCoordinates());
                }
            }
        }
    }

    void loneAgentResScream(Agent argAg){
        for(Iterator<Agent> iter = agents.iterator(); iter.hasNext();){
            Agent ag = iter.next();
            double distance = argAg.getDistTo(ag.getX(), ag.getY());
            if(ag.getLockedRes() == null
                    && ag.getConCount() == 0
                    && ag.getSpecies() == argAg.getSpecies()
                    && distance < App.SCRHEARDIST){
                if(ag.getValence() == 0){
                    if(!ag.wellFed()){
                        ag.face(argAg.getCoordinates());
                    }
                }
                else{
                    ag.face(argAg.getCoordinates());
                }
            }
        }
    }

    void packAgentResListen(Agent argAg){
        Pack argPack = getPack(argAg);
        if(argPack == null)
            return;
        ArrayList<Agent> connAg = argPack.getConnected(argAg);
        connAg.forEach((ag) -> {
            if(ag.getLockedRes() != null){
                if(argAg.getLockedRes() == null){
                    if(argAg.getLastHeardAge() < ag.getAge()){
                        argAg.face(ag.getCoordinates());
                        argAg.setLastHeardAge(ag.getAge());
                    }
                }
                else{
                    if(argAg.getLockedRes() != ag.getLockedRes()){
                        if(argAg.getAge() < ag.getAge()){
                            if(argAg.getLastHeardAge() < ag.getAge()){
                                argAg.setLastHeardAge(ag.getAge());
                                argAg.setLockedRes(null);
                                argAg.face(ag.getCoordinates());
                            }
                        }
                    }
                }
            }
        });
    }

    //-------------Rivalry-------------

    void fight(Agent argAg1, Agent argAg2){

        double coef1 = argAg1.getConCount() + 1;
        double coef2 = argAg2.getConCount() + 1;

        ArrayList<Agent> connected1 = null;
        ArrayList<Agent> connected2 = null;

        if(coef1 != 1){
            connected1 = getPack(argAg1).getConnected(argAg1);
        }

        if(coef2 != 1){
            connected2 = getPack(argAg2).getConnected(argAg2);
        }

        argAg1.addToEnergy(-App.NRGPERFIGHT / coef1);
        argAg2.addToEnergy(-App.NRGPERFIGHT / coef2);

        if(connected1 != null){
            connected1.forEach((ag) -> {
                ag.addToEnergy(-App.NRGPERFIGHT / coef1);
                App.processingRef.stroke(rivalryCl.getRGB(),100);
                App.processingRef.strokeWeight(2);
                App.processingRef.circle((float)ag.getX(), (float)ag.getY(), 5);
            });
        }
        if(connected2 != null){
            connected2.forEach((ag) -> {
                ag.addToEnergy(-App.NRGPERFIGHT / coef2);
                App.processingRef.stroke(rivalryCl.getRGB(),100);
                App.processingRef.strokeWeight(2);
                App.processingRef.circle((float)ag.getX(), (float)ag.getY(), 5);
            });
        }

        App.processingRef.stroke(rivalryCl.getRGB(),100);
        App.processingRef.strokeWeight(2);
        App.processingRef.line((float)(App.ORIGINX + argAg1.getX()), (float)(App.ORIGINY + argAg1.getY()), (float)(App.ORIGINX + argAg2.getX()), (float)(App.ORIGINY + argAg2.getY()));
    }

    void fights(){
        for(Iterator<Agent> iter1 = agents.iterator(); iter1.hasNext();){
            Agent ag1 = iter1.next();
            for(Iterator<Agent> iter2 = agents.iterator(); iter2.hasNext();){
                Agent ag2 = iter2.next();
                if(ag1.getSpecies() != ag2.getSpecies() && ag1.getDistTo(ag2.getX(), ag2.getY()) <= App.FIGHTDIST){
                    fight(ag1, ag2);
                }
            }
        }
    }

    //----------Reproduction----------

    void reproduction(Agent argAg){
        Random r = new Random();
        boolean rep = false;
        double tech = r.nextDouble();

        if(argAg.getSpecies() == 0){
            if(tech <= App.REPRODUCTPROB1)
                rep = true;
        }
        else{
            if(tech <= App.REPRODUCTPROB2)
                rep = true;
        }

        if(rep){
            Agent child = Builder.buildAgent(argAg.getSpecies());
            child.setCoordinates(new Dot(argAg.getCoordinates()));
            child.setAge(0);
            child.updateSpeed();

            argAg.addToEnergy(-App.REPRODUCTCOST);
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

    //---------------Main---------------

    void tick(){                                                                        //Performes animation tick
        ArrayList<Agent> reproductList = new ArrayList<>();

        resGroup.replenishNodes();

        for (Iterator<Agent> iter = agents.iterator(); iter.hasNext();){

            Agent ag = iter.next();

            if(ag.dead()){
                removeAgentFromPacks(ag);
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


                if(ag.getEnergy() > App.REPRODUCTCOST + App.SUFFENERGY && ag.getAge() >= App.REPRODUCTLOW && ag.getAge() <= App.REPRODUCTHIGH){
                    reproductList.add(ag);
                }

                if(ag.getConCount() == 0){
                    ag.eatCollected();
                }
            }
        }

        reproductList.parallelStream().forEach((ag) -> {reproduction(ag);});

        packs.parallelStream().forEach((pack) -> {
            pack.collectedResDistribution();
            pack.energyDepletion();
        });

        fights();

        agents.forEach((ag) -> {
            ag.resetCollectedRes();
            ag.resetLastHeardAge();
        });

    }

    boolean run(){                                                       //Main method                                                                           //Perform animation tick
        render();
        tick();

        return false;
    }

    //---------------------------------
    //---------------------------------


    //-----------------------------------
    //-----------  Renderers  -----------
    //-----------------------------------

    void renderRes(){                                                                   //Renders resources
        resGroup.render();
    }

    void renderPropertyGrid() { this.propertyGrid.render(); }

    void renderPacks(){
        packs.forEach((pack) -> {pack.render();});
    }

    void renderAgent(){                                                                 //Renders agents
        agents.forEach((agent) -> agent.render());
    }

    void render(){                                                    //Renders aviary
        App.processingRef.background(0);
        renderPropertyGrid();
        renderRes();
        renderPacks();
        renderAgent();
    }

    //-----------------------------------
    //-----------------------------------


}
