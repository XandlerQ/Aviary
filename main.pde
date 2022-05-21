import java.util.*;
import controlP5.*;

//  Aviary settings
int DEFX = 600;
int DEFY = 600;

int QUADX = 150;
int QUADY = 150;

int INITAGENTAMOUNT = 200;
boolean SYSSPAWN = true;

int RESTYPE = 0; //0 -- regular, 1 -- linear, 2 -- bilinear, 3 -- random
float BASERES = 0.85;
float RESREPSPEED = 0.01416666;

//  Agent settings
float BASESPEED = 1.6;
float SPEEDRANDOMNESS = 0.8;
float SPEEDAGECOEFF = 1.0;

float BASEMAXAGE = 3600;
float AGEPERSTEP = 1;

float SUFFENERGY = 25;
float MAXENERGY = 50;
float NRGPERSTEP = 0.20;

int VALENCE1 = 4;
int VALENCE2 = 0;

float RESEATENPERSTEP = 1.0;
float RESEATENPERSTEPAGECOEFF = 0;

//  Reproduction settings 
float REPRODUCTLOW = 1440;
float REPRODUCTHIGH = 3000;
float REPRODUCTPROB = 0.001;
float REPRODUCTCOST = 5.0;

//  Fight settings
float NRGPERFIGHT = 1.0;
int NRGFIGHTSCHEME = 0; //0 -- both lose energy, 1 -- energy gets stolen
boolean IFFIGHTENERGYDEPONCONS = true;
int COEFSCHEME = 1; //0 -- energy depends on amount of cons in the whole pack, 1 -- energy depends on the amount of cons for this particular agent
float NRGSTEALCOEFF = 0.5; //energy steal coefficiency

int FIGHTSCHEME = 0; //0 -- everyone diff species, 1 -- two lones don't fight (PACKFIGHTPEAK has to be defined), 2 -- lones never fight (PACKFIGHTPEAK has to be defined)
int PACKFIGHTPEAK = 3;  //Pack size to be hostile

//  Pack energy balancing settings
int NRGBALANCINGTYPE = 2; //0 -- no balancing, 1 -- gradual balancing, 2 -- immediate balancing

int BALANCINGCTRPEAK = 5;

float NRGBALANCESPEED = 0.002;

//  Pack energy depletion settings
boolean NRGFORCONDEPLETING = true;
float NRGFORCONPERSTEP = 0.05;

//  Action counter
int ACTCTRPEAK = 15;

// Distances settings
float SCRHEARDIST = 100;
float PACKDIST = 80;
float CONNECTDIST = 40;
float COMDIST = 20;
float PACKCOMDIST = 80;
float FIGHTDIST = 40;

//Graph counter
int INFOREPCTRPEAK = 60;



boolean pause = false;

//AviaryRivalry(int argInitAgentAmnt, int argQuadX, int argQuadY, float argRes)
AviaryRivalry AV = new AviaryRivalry(INITAGENTAMOUNT);


void setup(){
   size(1200, 1000); 
   background(#FFFFFF);
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

int getQuadX(float x){
    int quadX = 0;
    float h = DEFX / QUADX;
    quadX = (int)((x - (x % h)) / h);
    if(quadX < QUADX)
      return quadX;
    else
      return QUADX - 1;
  }
  
int getQuadY(float y){
  int quadY = 0;
  float h = DEFY / QUADY;
  quadY = (int)((y - (y % h)) / h);
  if(quadY < QUADY)
    return quadY;
  else
    return QUADY - 1;
}
  
void mouseClicked(){
  AV.getNet().lowerRes(getQuadX(mouseX), getQuadY(mouseY), RESEATENPERSTEP);
  strokeWeight(0);
  fill(#FFE06C, 85);
  circle(mouseX, mouseY, 30);
  fill(#FFE239, 110);
  circle(mouseX, mouseY, 15);
  fill(#FFD139, 160);
  circle(mouseX, mouseY, 7);
  fill(#FFAF00, 250);
  circle(mouseX, mouseY, 3);
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
