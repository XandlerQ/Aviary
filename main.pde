import java.util.*;

//  Aviary settings
int DEFX = 600;
int DEFY = 600;

int QUADX = 100;
int QUADY = 100;

int INITAGENTAMOUNT = 10;
boolean SYSSPAWN = true;

int RESTYPE = 2; //0 -- regular, 1 -- linear, 2 -- bilinear, 3 -- random
float BASERES = 0.3;
float RESREPSPEED = 0.002;

//  Agent settings
float BASESPEED = 1.4;
float SPEEDRANDOMNESS = 0.4;
float SPEEDAGECOEFF = 1.0;

float BASEMAXAGE = 3600;
float AGEPERSTEP = 0.5;

float SUFFENERGY = 10;
float MAXENERGY = 20;
float NRGPERSTEP = 0.03;

int VALENCE1 = 3;
int VALENCE2 = 4;

float RESEATENPERSTEP = 0.06;
float RESEATENPERSTEPAGECOEFF = 0;

//  Reproduction settings 
float REPRODUCTLOW = 1440;
float REPRODUCTHIGH = 3000;
float REPRODUCTPROB = 0.001;
float REPRODUCTCOST = 0.60;

//  Fight settings
float NRGPERFIGHT = 0.1;
int NRGFIGHTSCHEME = 1; //0 -- both lose energy, 1 -- energy gets stolen
boolean IFFIGHTENERGYDEPONCONS = true;
int COEFSCHEME = 0; //0 -- energy depends on amount of cons in the whole pack, 1 -- energy depends on the amount of cons for this particular agent
float NRGSTEALCOEFF = 1.0; //energy steal coefficiency

int FIGHTSCHEME = 1; //0 -- everyone diff species, 1 -- two lones don't fight (PACKFIGHTPEAK has to be defined), 2 -- lones never fight (PACKFIGHTPEAK has to be defined)
int PACKFIGHTPEAK = 20;  //Pack size to be hostile

//  Pack energy balancing settings
int NRGBALANCINGTYPE = 2; //0 -- no balancing, 1 -- gradual balancing, 2 -- immediate balancing

int BALANCINGCTRPEAK = 5;

float NRGBALANCESPEED = 0.002;

//  Pack energy depletion settings
boolean NRGFORCONDEPLETING = false;
float NRGFORCONPERSTEP = 0.005;

//  Action counter
int ACTCTRPEAK = 15;

// Distances settings
float SCRHEARDIST = 100;
float PACKDIST = 80;
float CONNECTDIST = 40;
float COMDIST = 20;
float PACKCOMDIST = 80;
float FIGHTDIST = 40;

//Graph conter
int INFOREPCTRPEAK = 60;



boolean pause = false;

//AviaryRivalry(int argInitAgentAmnt, int argQuadX, int argQuadY, float argRes)
AviaryRivalry AV = new AviaryRivalry(INITAGENTAMOUNT);


void setup(){
   size(1000, 802); 
   background(0);
   ellipseMode(CENTER);
 }  
 
 
void draw(){
  if(!pause){
    AV.run();
    fill(#5555ff); 
    textSize(10);
    text(int(frameRate),5,10);
  }
}

void keyPressed(){
  switch(key){
    case 'r':
    case 'R':
      AV = new AviaryRivalry(INITAGENTAMOUNT);
      break;
    case 'p':
    case 'P':
      if(pause)
        pause = false;
      else
        pause = true;
      break;
  }
}
