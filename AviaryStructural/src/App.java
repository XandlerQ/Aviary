import processing.core.*;
import controlP5.*;

import java.awt.*;


public class App extends PApplet {

    public static PApplet processingRef;

    ControlP5 cp5;

    Aviary AV;

    boolean pause = false;
    boolean firstRun = true;
    boolean autoRun = false;

    int screenshotNum = 1;
    int scrShCounter = 0;

    public void settings(){
        size(1300, 1300);

    }

    public void setup() {
        processingRef = this;
        background(0);
        ellipseMode(CENTER);

        int bSSX = 250;
        int bSSX2 = 250;
        int bSSY = 10;
        int bGap = 23;

        int sSSX = 200;
        int sSSY = 8;
        int sGap = 18;



        cp5 = new ControlP5(this);

        cp5.addBang("BgStart")
                //.setLabel("Старт")
                .setPosition(1200 - 65, ORIGINY + DEFY + 20)
                .setSize(45, 30);

        cp5.addBang("BgPause")
                //.setLabel("Пауза")
                .setPosition(1200 - 65, ORIGINY + DEFY + 70)
                .setSize(45, 30);

        cp5.addBang("BgScreenshot")
                .setPosition(1200 - 65, ORIGINY + DEFY + 120)
                .setSize(45, 30);

        PFont font = createFont("PressStart2P-Regular.ttf", 8);
        textFont(font);
    }

    public void BgStart(){
        background(0);
        AV = new Aviary();

        firstRun = false;

        if(pause){
            fill(0, 100);
            stroke(0, 0);
            rect(ORIGINX, ORIGINY, DEFX, DEFY);
            fill(Color.WHITE.getRGB());
            textSize(20);
            text("PAUSE", DEFX/2 - 40, DEFY/2);
        }
    }


    public void BgPause(){
        if(pause)
            pause = false;
        else {
            if(!firstRun){
                fill(0, 80);
                stroke(0, 0);
                rect(ORIGINX, ORIGINY, DEFX, DEFY);
                fill(Color.WHITE.getRGB(), 100);
                rect(ORIGINX + 5, ORIGINY + 5, 12, 30);
                rect(ORIGINX + 25, ORIGINY + 5, 12, 30);
                pause = true;
            }
        }
    }


    public void BgScreenshot(){
        saveFrame("Screenshots/Aviary_Run-" + screenshotNum + ".png");
        screenshotNum++;
        scrShCounter = 120;
    }

    public void draw(){
        pushMatrix();

        boolean finished = false;

        if(!pause){
            if(AV != null){

                finished = AV.run();
                fill(Color.WHITE.getRGB()); text((int)(frameRate),5,10);
            }
        }

        if(finished){
            if(autoRun){
                BgStart();
            }
        }

        if(scrShCounter > 0){
            scrShCounter--;
            fill(Color.WHITE.getRGB(), 100);
            stroke(Color.WHITE.getRGB(), 255);
            rect(1200 - 47 + 5, ORIGINY + DEFY + 170, 2, 15);
            triangle(1200 - 50 + 5, ORIGINY + DEFY + 185, 1200 - 42 + 5, ORIGINY + DEFY + 185, 1200 - 46 + 5, ORIGINY + DEFY + 195);
            rect(1200 - 55 + 5, ORIGINY + DEFY + 195, 20, 2);
        }

        popMatrix();
    }

    public void keyPressed(){
        switch(key){
            case 'r':
            case 'R':
                firstRun = false;
                background(0);
                AV = new Aviary();
                if(pause){
                    fill(0, 80);
                    stroke(0, 0);
                    rect(ORIGINX, ORIGINY, DEFX, DEFY);
                    fill(Color.WHITE.getRGB(), 100);
                    rect(ORIGINX + 5, ORIGINY + 5, 12, 30);
                    rect(ORIGINX + 25, ORIGINY + 5, 12, 30);
                }
                break;
            case ' ':
                if(pause)
                    pause = false;
                else {
                    if(!firstRun){
                        fill(0, 80);
                        stroke(0, 0);
                        rect(ORIGINX, ORIGINY, DEFX, DEFY);
                        fill(Color.WHITE.getRGB(), 100);
                        rect(ORIGINX + 5, ORIGINY + 5, 12, 30);
                        rect(ORIGINX + 25, ORIGINY + 5, 12, 30);
                        pause = true;
                    }
                    else{
                        firstRun = false;
                        background(0);
                        AV = new Aviary();
                        pause = false;
                    }
                }
                break;
            case 's':
            case 'S':
                saveFrame("Screenshots/Aviary_Run-" + screenshotNum + ".png");
                screenshotNum++;
                scrShCounter = 120;
                break;
        }
    }

    public static void main(String... args){
        PApplet.main("App");
    }

    // Config variables

    public static int ORIGINX = 3;
    public static int ORIGINY = 3;

    public static int DEFX = 1000;
    public static int DEFY = 1000;

    public static double WALLTHICKNESS = 1;

    public static int QUADX = 5;
    public static int QUADY = 5;

    public static int INITAGENTAMOUNT1 = 250;
    public static int INITAGENTAMOUNT2 = 0;

    public static boolean SYSSPAWN = true;

    public static double BASERES = 190;
    public static double RESREPSPEED = BASERES/360;
    public static int RESPERQUAD = 3;
    public static int RESREPCTRPEAK = 240;

    //  Agent settings
    public static double BASESPEED1 = 1.6;
    public static double BASESPEED2 = 1.6;

    public static double BASEMAXAGE = 3600;
    public static double AGEPERSTEP = 0;

    public static double SUFFENERGY = 25;
    public static double MAXENERGY = 50;
    public static double NRGPERSTEP1 = 0.05;//BASESPEED1/8;
    public static double NRGPERSTEP2 = 0.05;//BASESPEED2/8;

    public static int VALENCE1 = 3;
    public static int VALENCE2 = 4;

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

