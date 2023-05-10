import java.awt.*;
public class Resource {


    protected double res;  //Resource currently stored
    protected double maxRes;  //Max resource amount
    protected double resRepSpeed;  //Resource replenishment speed
    protected int repCtr;  //Replenishment counter
    protected int repCtrPeak;  //Replenishment counter peak

    //--------------------------------------
    //-----------  Constructors  -----------
    //---------------------------------------

    Resource() {  //Default constructor
        this.res = 0;  //Empty by default
        this.maxRes = 0;  //Zero capacity
        this.resRepSpeed = 0;  //No replenishment speed
        this.repCtr = 0;  //Standard replenishment counter value
        this.repCtrPeak = 0;  //No replenishment counter peak
    }

    Resource(double maxRes, double fraction, double resRepSpeed, int repCtrPeak) {
        //maxRes - Resource capacity;
        //fraction - initial resource amount coefficiency, assumed to be in range [0; 1];
        //resRepSpeed - resource replenishment speed per tick;
        //repCtrPeak - peak value for replenishment counter, determines frequency of resource replenishment.
        this.res = maxRes * fraction;
        this.maxRes = maxRes;
        normalizeRes();  //Normalizes initial this.res value
        this.resRepSpeed = resRepSpeed;
        this.repCtr = 0;
        this.repCtrPeak = repCtrPeak;
        normalizeRepCtrPeak(); //Normalizes initial this.repCtrPeak value
    }

    //---------------------------------------
    //---------------------------------------

    //---------------------------------
    //-----------  Getters  -----------
    //---------------------------------

    double getRes() { return this.res; }

    public double getMaxRes() {
        return maxRes;
    }

    boolean empty() { return this.res <= 0; }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Setters  -----------
    //---------------------------------

    void setMaxRes(double maxRes) { this.maxRes = maxRes; }

    void setRepCtrPeak(int repCtrPeak) {
        this.repCtrPeak = repCtrPeak;
        normalizeRepCtrPeak();
    }

    void setResRepSpeed(double resRepSpeed) { this.resRepSpeed = resRepSpeed; }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Methods  -----------
    //---------------------------------

    void normalizeRes() {  //Normalizes current this.res value by projecting it to [0; maxRes]
        if (this.res > this.maxRes) {
            this.res = this.maxRes;
        }
        if (this.res < 0) {
            this.res = 0;
        }
    }

    void normalizeRepCtrPeak() { //Normalizes replenishment counter by assuring it is not lower then 0
        if(this.repCtrPeak < 0) {
            this.repCtrPeak = 0;
        }
    }


    double lowerRes(double amount){  //Lowers current this.res by amount
        if (amount > this.res){  //If amount is greater than currently stored resource amount
            double taken = this.res;  //Make new variable representing maximum possible resource withdraw
            this.res = 0;  //Set current resource stored to 0
            this.repCtr = this.repCtrPeak;  //As soon as resource is withdrawn, delay replenishment by this.repCtrPeak frames
            return taken;  //Return maximum possible resource withdraw
        }
        else {  //If amount is less than currently stored resource amount
            this.res -= amount;  //Lower resource currently stored by amount
            this.repCtr = this.repCtrPeak;  //As soon as resource is withdrawn, delay replenishment by this.repCtrPeak frames
            return amount;  //Return withdrawn amount
        }
    }

    void replenish(){  //Handles replenishment counter and replenishes stored resource
        if(this.repCtr != 0){  //If the replenishment counter is not 0
            this.repCtr--;  //Lower the replenishment counter
            return;
        }
        else{  //If the replenishment counter is 0
            if(this.res < this.maxRes)  //If resource currently stored is not at maximum
                this.res += this.resRepSpeed;  //Replenish resource currently stored
            if(this.res > this.maxRes)  //If resource currently stored is greater then maximum
                this.res = this.maxRes;  //Set resource currently stored as maximum
        }
    }

    //---------------------------------
    //---------------------------------
}
