import java.util.Random;
import java.util.*;


int DEFX = 1000;
int DEFY = 1000;

int QUADX = 11;
int QUADY = 11;

int INITAGENTAMOUNT = 20;

float MAXAGE = 100;
float AGEPERSTEP = 0.05;
float SUFFENERGY = 10;
float ENERGYPERSTEP = 0.05;
float RESEATENPERSTEP = 0.08;
int VALENCE = 3;
float SCRHEARDIST = 80;
int ACTCTRPEAK = 30;
float COMDIST = 25;
float MAXRES = 10;
float RESREPSPEED = 0.025;


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
