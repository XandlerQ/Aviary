import processing.core.*;


public class App extends PApplet {

    public static PApplet processingRef;

    public void settings(){
        size(1000, 1000);

    }

    public void setup() {
        processingRef = this;
    }

    public void draw(){
        background(0);
        ellipse(mouseX, mouseY, 20, 20);
    }

    public static void main(String... args){
        PApplet.main("Application");
    }

    // Config variables

    public static int ORIGINX = 3;
    public static int ORIGINY = 3;

    public static int DEFX = 1000;
    public static int DEFY = 1000;

    public static double WALLTHICKNESS = 1;

    public static int QUADX = 5;
    public static int QUADY = 5;

    public static int INITAGENTAMOUNT1 = 100;
    public static int INITAGENTAMOUNT2 = 100;

    public static boolean SYSSPAWN = true;

    public static double BASERES = 190;
    public static double RESREPSPEED = BASERES/360;
    public static int RESPERQUAD = 3;
    public static int REPCTRPEAK = 240;

    //  Agent settings
    public static double BASESPEED1 = 1.6;
    public static double BASESPEED2 = 1.6;
    public static double SPEEDRANDOMNESS1 = BASESPEED1/2;
    public static double SPEEDRANDOMNESS2 = BASESPEED2/2;
    public static double SPEEDAGECOEFF = 1.0;

    public static double BASEMAXAGE = 3600;
    public static double AGEPERSTEP = 1;

    public static double SUFFENERGY = 25;
    public static double MAXENERGY = 50;
    public static double NRGPERSTEP1 = 0.05;//BASESPEED1/8;
    public static double NRGPERSTEP2 = 0.05;//BASESPEED2/8;

    public static int VALENCE1 = 0;
    public static int VALENCE2 = 0;

    public static double RESECOLLECTEDPERSTEP = 1.0;

    //  Reproduction settings
    public static double REPRODUCTLOW = 1440;
    public static double REPRODUCTHIGH = 3000;
    public static double REPRODUCTPROB1 = 0.0015;
    public static double REPRODUCTPROB2 = 0.0015;
    public static double REPRODUCTCOST = 5.0;

    //  Fight settings
    public static double NRGPERFIGHT = 1.0;

    //  Pack energy depletion settings
    public static double NRGFORCONPERSTEP = 0.03;

    //  Action counter
    public static int ACTCTRPEAK = 15;

    // Distances settings
    public static double SCRHEARDIST = 200;
    public static double PACKDIST = 80;
    public static double CONNECTDIST = 40;
    public static double COMDIST = 20;
    public static double PACKCOMDIST = 80;
    public static double FIGHTDIST = 40;
    public static double VISUALDIST = 65;

    //Graph counter
    public static int INFOREPCTRPEAK = 60;
}

