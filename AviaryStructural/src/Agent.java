import processing.core.PApplet;

import java.awt.*;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

public class Agent {

    static Color speciesColors[] = {
            new Color(255, 0,0),
            new Color(45, 255, 0),
            new Color(252, 223, 3),
            new Color(3, 252, 240)
    };


    static AtomicInteger agentIdGen = new AtomicInteger(0);
    private final int id;
    private int species;

    private Dot coordinates;
    private double direction;
    private double baseSpeed;
    private double speed;

    private double age;
    private double maxAge;
    private double ageIncr;

    private double energy;
    private double maxEnergy;
    private double suffEnergy;
    private double energyDecr;

    private ResourceNode lockedRes;
    private double collectedRes;
    private double seenRes;

    private int valence;
    private PropertyArea propertyArea;
    private int conCount;
    private double lastHeardAge;

    private int actCtr;
    private int actCtrPeak;

    private boolean stationary;


    //--------------------------------------
    //-----------  Constructors  -----------
    //--------------------------------------

    Agent() {
        this.id = agentIdGen.incrementAndGet();
        this.species = 0;

        this.coordinates = new Dot();
        this.direction = 0;
        this.baseSpeed = 1;
        this.speed = 0;

        this.age = 0;
        this.maxAge = 1;
        this.ageIncr = 0;

        this.energy = 1;
        this.maxEnergy = 1;
        this.suffEnergy = 1;
        this.energyDecr = 0;

        this.lockedRes = null;
        this.collectedRes = 0;
        this.seenRes = 0;

        this.valence = 0;
        this.propertyArea = null;
        this.conCount = 0;
        this.lastHeardAge = -1;


        this.actCtr = 0;
        this.actCtrPeak = 0;

        this.stationary = false;
    }

    //---------------------------------------
    //---------------------------------------

    //---------------------------------
    //-----------  Getters  -----------
    //---------------------------------



    int getId() { return this.id; }
    int getSpecies() { return this.species; }

    double getX() { return this.coordinates.getX(); }
    double getY() { return this.coordinates.getY(); }
    Dot getCoordinates() { return this.coordinates; }
    double getDirection() { return this.direction; }
    double getBaseSpeed() { return this.baseSpeed; }
    double getSpeed() { return this.speed; }

    double getAge() { return this.age; }
    double getMaxAge() { return this.maxAge; }
    double getAgeIncr() { return this.ageIncr; }

    double getEnergy() { return this.energy; }
    double getMaxEnergy() { return this.maxEnergy; }
    double getSuffEnergy() { return this.suffEnergy; }
    double getEnergyDecr() { return this.energyDecr; }

    double getHunger() { return this.maxEnergy - this.energy; }
    boolean wellFed() { return this.energy >= this.suffEnergy; }
    boolean wellFedLone() { return this.energy >= this.maxEnergy * 0.8; }

    ResourceNode getLockedRes() { return this.lockedRes; }
    double getCollectedRes() { return this.collectedRes; }

    public double getSeenRes() {
        return seenRes;
    }

    int getValence() { return this.valence; }

    public PropertyArea getPropertyArea() {
        return propertyArea;
    }

    int getConCount() { return this.conCount; }
    double getLastHeardAge() { return this.lastHeardAge; }
    boolean topCon() { return this.conCount >= this.valence; }

    int getActCounter() { return this.actCtr; }
    int getActCounterPeak() { return this.actCtrPeak; }

    boolean readyToAct() { return this.actCtr == 0; }

    boolean stationary() { return this.stationary; }

    boolean dead() { return this.energy <= 0 || this.age > this.maxAge; }



    //---------------------------------

    double getDistTo(double x, double y) { return Dot.distanceBetween(this.coordinates, new Dot(x, y)); }
    double getDistTo(Dot dot) { return getDistTo(dot.getX(), dot.getY()); }

    double getEnergyOver() { return this.energy - this.maxEnergy; }


    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Setters  -----------
    //---------------------------------

    void setSpecies(int species) { this.species = species; }

    void setCoordinates(Dot coordinates) { this.coordinates = coordinates; }
    void setCoordinates(double x, double y) { this.coordinates.setXY(x, y); }
    void setDirection(double direction) {
        this.direction = direction;
        normalizeDirection();
    }

    void setBaseSpeed(double baseSpeed) { this.baseSpeed = baseSpeed; }

    public void setAge(double age) { this.age = age; }
    public void setMaxAge(double maxAge) { this.maxAge = maxAge; }
    void setAgeIncr(double ageIncr) { this.ageIncr = ageIncr; }

    void setEnergy(double energy) {
        this.energy = energy;
        normalizeEnergy();
    }

    void setMaxEnergy(double maxEnergy) { this.maxEnergy = maxEnergy; }
    void setSuffEnergy(double suffEnergy) { this.suffEnergy = suffEnergy; }
    void setEnergyDecr(double energyDecr) { this.energyDecr = energyDecr; }

    void setLockedRes(ResourceNode resNode) { this.lockedRes = resNode; }
    void setCollectedRes(double collectedRes) { this.collectedRes = collectedRes; }

    public void setSeenRes(double seenRes) {
        this.seenRes = seenRes;
    }

    void collect(double res) { this.collectedRes += res; }
    void resetCollectedRes() { this.collectedRes = 0; }
    void resetSeenRes() { this.seenRes = 0; }

    void setValence(int valence) { this.valence = valence; }

    public void setPropertyArea(PropertyArea propertyArea) {
        this.propertyArea = propertyArea;
    }

    void setLastHeardAge(double age) { this.lastHeardAge = age; }
    void resetLastHeardAge() { this.lastHeardAge = -1; }
    void resetConCount() { this.conCount = 0; }


    void setActCtrPeak(int actCtrPeak) { this.actCtrPeak = actCtrPeak; }
    void getReadyToAct() { this.actCtr = 0; }
    void resetActCtr() { this.actCtr = this.actCtrPeak; }

    void setStationary(boolean stationary) { this.stationary = stationary; }
    void lock() { this.stationary = true; }
    void unlock() { this.stationary = false; }
    void turnAround() {
        this.direction += Math.PI;
        normalizeDirection();
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Methods  -----------
    //---------------------------------

    private void normalizeEnergy() {
        if(this.energy > maxEnergy) {
            this.energy = maxEnergy;
        }
        if(this.energy < 0) {
            this.energy = 0;
        }
    }

    void addToEnergy(double nrg) {
        this.energy += nrg;
        normalizeEnergy();
    }

    void eat(double res) {
        this.energy += res;
        normalizeEnergy();
    }

    void eatCollected() {
        eat(this.collectedRes);
        resetCollectedRes();
    }

    //---------------------------------

    boolean addCon() {
        if(topCon()) return false;
        this.conCount++;
        return true;
    }

    boolean removeCon() {
        if(this.conCount == 0) return false;
        this.conCount--;
        return true;
    }

    //---------------------------------

    void updateSpeed() {
        this.speed = this.baseSpeed
                - App.SPEEDAGECOEFF * (this.baseSpeed / 4)
                * (4 * (this.age - this.maxAge/2) * (this.age - this.maxAge/2) / (this.maxAge * this.maxAge));
    }

    //---------------------------------

    void normalizeDirection() {
        while(this.direction < 0) this.direction += 2 * Math.PI;
        while(this.direction >= 2 * Math.PI) this.direction -= 2 * Math.PI;
    }

    double dirToFace(double x, double y) {
        double distance = Dot.distanceBetween(this.coordinates, new Dot(x, y));

        if(distance == 0) {
            Random r = new Random();
            return 2 * Math.PI * r.nextDouble();
        }

        double direction = Math.acos((x - this.coordinates.getX()) / distance);
        if(y > this.coordinates.getY()) return direction;
        else return 2 * Math.PI - direction;
    }

    double dirToFace(Dot dot) { return dirToFace(dot.getX(), dot.getY()); }

    void face(double x, double y) { this.direction = dirToFace(x, y); }
    void face(Dot dot) { this.direction = dirToFace(dot); }
    void adjustDirectionTo(Dot dot) { this.direction = Direction.directionAddition(this.direction, dirToFace(dot)); }

    //---------------------------------

    void step() {

        this.age += this.ageIncr;
        updateSpeed();

        this.energy -= this.energyDecr * ((this.speed * this.speed) / (this.baseSpeed * this.baseSpeed));

        if(this.actCtr > 0) this.actCtr -= 1;
        else resetActCtr();

        if(stationary) return;

        Random r = new Random();

        this.direction += -0.16 + (0.32) * r.nextDouble();
        normalizeDirection();

        double newX = this.coordinates.getX() + this.speed * Math.cos(this.direction);
        double newY = this.coordinates.getY() + this.speed * Math.sin(this.direction);

        if(App.LOCKEDAREAS && this.propertyArea != null) {

            double prAreaOriginX = this.propertyArea.getOriginX();
            double prAreaOriginY = this.propertyArea.getOriginY();
            double prAreaSideX = this.propertyArea.getSideX();
            double prAreaSideY = this.propertyArea.getSideY();

            if (newX > prAreaOriginX + prAreaSideX - App.WALLTHICKNESS ||
                    newX < prAreaOriginX + App.WALLTHICKNESS ||
                    newY > prAreaOriginY + prAreaSideY - App.WALLTHICKNESS ||
                    newY < prAreaOriginY + App.WALLTHICKNESS) {
                direction = Direction.directionFromTo(this.coordinates, this.propertyArea.getAreaCenter());
                normalizeDirection();
                newX = this.coordinates.getX() + this.speed * Math.cos(this.direction);
                newY = this.coordinates.getY() + this.speed * Math.sin(this.direction);
            }
            if (newX > App.DEFX - App.WALLTHICKNESS ||
                    newX < App.WALLTHICKNESS ||
                    newY > App.DEFY - App.WALLTHICKNESS ||
                    newY < App.WALLTHICKNESS) {
                return;
            }
        }
        else {
            if (newX > App.DEFX - App.WALLTHICKNESS ||
                    newX < App.WALLTHICKNESS ||
                    newY > App.DEFY - App.WALLTHICKNESS ||
                    newY < App.WALLTHICKNESS) {
                direction = Direction.directionFromTo(this.coordinates, new Dot(App.DEFX / 2, App.DEFY / 2));
                normalizeDirection();
                newX = this.coordinates.getX() + this.speed * Math.cos(this.direction);
                newY = this.coordinates.getY() + this.speed * Math.sin(this.direction);
            }
        }

        this.setCoordinates(newX, newY);
    }

    //---------------------------------

    @Override
    public boolean equals(Object obj){
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        Agent arg = (Agent) obj;
        return this.id == arg.id;
    }

    //---------------------------------
    //---------------------------------

    //-----------------------------------
    //-----------  Renderers  -----------
    //-----------------------------------

    void render()
    {
        App.processingRef.stroke(speciesColors[this.species].getRGB());
        App.processingRef.strokeWeight(1);
        if (this.energy >= this.suffEnergy) App.processingRef.fill((new Color(255, 170, 0)).getRGB(), 150);
        else App.processingRef.fill(0);

        App.processingRef.circle((float)(App.ORIGINX + this.coordinates.getX()), (float)(App.ORIGINY + this.coordinates.getY()), 4);
        /*App.processingRef.line((float)(App.ORIGINX + this.coordinates.getX()), (float)(App.ORIGINY + this.coordinates.getY()),
                (float)(App.ORIGINX + this.coordinates.getX() + 6 * Math.cos(direction)), (float)(App.ORIGINY + this.coordinates.getY() + 6 * Math.sin(direction))
        );*/
    }

    //-----------------------------------
    //-----------------------------------
}
