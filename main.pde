import java.util.*;


int DEFX = 1000;
int DEFY = 1000;

int QUADX = 100;
int QUADY = 100;

float QUADDIM = DEFX / QUADX;

int INITAGENTAMOUNT = 100;

float MAXAGE = 3600;
float REPRODUCTLOW = 1440;
float REPRODUCTHIGH = 3000;
float REPRODUCTPROB = 0.001;
float REPRODUCTCOST = 0.32;


float AGEPERSTEP = 0.5;
float SUFFENERGY = 10;
float MAXENERGY = 20;
float ENERGYPERSTEP = 0.03;
float RESEATENPERSTEP = 0.08;
float ENERGYPERFIGHT = 0.1;

int VALENCE = 3;
float ENERGYBALANCESPEED = 0.005;

int ACTCTRPEAK = 30;

float SCRHEARDIST = 150;
float CONNECTDIST = 60;
float COMDIST = 20;
float PACKCOMDIST = 35;
float FIGHTDIST = 40;

float MAXRES = 0.4;
float RESREPSPEED = 0.002;



boolean pause = false;

//AviaryRivalry(int argInitAgentAmnt, int argQuadX, int argQuadY, float argRes)
AviaryRivalry AV = new AviaryRivalry(INITAGENTAMOUNT);


void setup(){
   size(1000, 1000); 
   background(0);
   ellipseMode(CENTER);
 }  
 
 
void draw(){
  if(!pause){
    AV.run();
    fill(#5555ff); text(int(frameRate),5,10);
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
