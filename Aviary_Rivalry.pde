import java.util.*;
import controlP5.*;

//  Aviary settings

int ORIGINX = 3;
int ORIGINY = 3;

int DEFX = 600;
int DEFY = 600;

int QUADX = 150;
int QUADY = 150;

int INITAGENTAMOUNT1 = 100;
int INITAGENTAMOUNT2 = 100;

boolean SYSSPAWN = true;

int RESTYPE = 0; //0 -- regular, 1 -- linear, 2 -- bilinear, 3 -- random
float BASERES = 1.6;
float RESREPSPEED = BASERES/60;

//  Agent settings
float BASESPEED1 = 1.6;
float BASESPEED2 = 1.6;
float SPEEDRANDOMNESS1 = BASESPEED1/2;
float SPEEDRANDOMNESS2 = BASESPEED2/2;
float SPEEDAGECOEFF = 1.0;

float BASEMAXAGE = 3600;
float AGEPERSTEP = 1;

float SUFFENERGY = 25;
float MAXENERGY = 50;
float NRGPERSTEP1 = BASESPEED1/8;
float NRGPERSTEP2 = BASESPEED2/8;

int VALENCE1 = 2;
int VALENCE2 = 2;

float RESEATENPERSTEP = 1.0;
float RESEATENPERSTEPAGECOEFF = 0;

//  Reproduction settings 
float REPRODUCTLOW = 1440;
float REPRODUCTHIGH = 3000;
float REPRODUCTPROB1 = 0.001;
float REPRODUCTPROB2 = 0.001;
float REPRODUCTCOST = 5.0;

//  Fight settings
float NRGPERFIGHT = 1.0;
int NRGFIGHTSCHEME = 0; //0 -- both lose energy, 1 -- energy gets stolen
int COEFSCHEME = 1; //0 -- no dependence, 1 -- energy depends on the amount of cons for this particular agent, 2 energy depends on amount of cons in the whole pack
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

AviaryRivalry AV = null;

boolean pause = false;
boolean firstRun = true;

boolean Fixed = true;

//AviaryRivalry(int argInitAgentAmnt, int argQuadX, int argQuadY, float argRes)


ControlP5 cp5;


void setup(){
   size(1200, 950); 
   background(0);
   ellipseMode(CENTER);
   
   int bSSX = 250;
   int bSSX2 = 250;
   int bSSY = 15;
   
   int sSSX = 200;
   int sSSY = 15;
   
   cp5 = new ControlP5(this);
   
   Group resGroup = cp5.addGroup("Resource_settings")
                       .setBackgroundColor(color(#003D7C, 100))
                       .setBackgroundHeight(80)
                       .setPosition(ORIGINX, ORIGINY + DEFY + 20)
                       .setWidth(380)
                       ;
   
   cp5.addSlider("Resource")
      .setPosition(10,5)
      .setSize(bSSX,bSSY)
      .setRange(0,3)
      .setValue(1.6)
      .moveTo(resGroup);
   
   
   cp5.addSlider("Resource_type")
      .setPosition(10, 45)
      .setSize(bSSX,bSSY)
      .setRange(0,3)
      .setNumberOfTickMarks(4)
      .setValue(0)
      .setDecimalPrecision(0)
      .setSliderMode(Slider.FLEXIBLE)
      .moveTo(resGroup);
      
   
   Group distGroup = cp5.addGroup("Distances_settings")
                .setBackgroundColor(color(#003D7C, 100))
                .setBackgroundHeight(180)
                .setPosition(ORIGINX, ORIGINY + DEFY + 120)
                .setWidth(380)
                ;
   
   cp5.addSlider("Scream_distance")
      .setPosition(10,5)
      .setSize(sSSX,sSSY)
      .setRange(0,200)
      .setValue(100)
      .moveTo(distGroup);
   
   cp5.addSlider("Max_pack_distance")
      .setPosition(10,35)
      .setSize(sSSX,sSSY)
      .setRange(0,200)
      .setValue(80)
      .moveTo(distGroup);
   
   cp5.addSlider("Connection_distance")
      .setPosition(10,65)
      .setSize(sSSX,sSSY)
      .setRange(0,200)
      .setValue(40)
      .moveTo(distGroup);
   
   cp5.addSlider("Comfortable_distance")
      .setPosition(10,95)
      .setSize(sSSX,sSSY)
      .setRange(0,200)
      .setValue(20)
      .moveTo(distGroup);
   
   cp5.addSlider("Pack_comfortable_distance")
      .setPosition(10,125)
      .setSize(sSSX,sSSY)
      .setRange(0,200)
      .setValue(80)
      .moveTo(distGroup);
      
   cp5.addSlider("Fight_distance")
      .setPosition(10,155)
      .setSize(sSSX,sSSY)
      .setRange(0,200)
      .setValue(40)
      .moveTo(distGroup);
      
      
   cp5.addBang("Reset")
      .setPosition(345,65)
      .setSize(20,20)
      .moveTo(distGroup);
   
   
   
   Group agentGroup = cp5.addGroup("Agent_settings")
                       .setBackgroundColor(color(#003D7C, 100))
                       .setBackgroundHeight(320)
                       .setPosition(ORIGINX + 390, ORIGINY + DEFY + 20)
                       .setWidth(380)
                       ;
   
   cp5.addSlider("Red_Valence")
      .setPosition(10, 5)
      .setSize(bSSX2,bSSY)
      .setRange(0,5)
      .setValue(2)
      .setNumberOfTickMarks(6)
      .setDecimalPrecision(0)
      .setSliderMode(Slider.FLEXIBLE)
      .moveTo(agentGroup);
   
   cp5.addSlider("Green_Valence")
      .setPosition(10, 45)
      .setSize(bSSX2,bSSY)
      .setRange(0,5)
      .setValue(2)
      .setNumberOfTickMarks(6)
      .setDecimalPrecision(0)
      .setSliderMode(Slider.FLEXIBLE)
      .moveTo(agentGroup);
      
   cp5.addSlider("Base_speed_1")
      .setPosition(10, 85)
      .setSize(bSSX2,bSSY)
      .setRange(0,3)
      .setValue(1.6)
      .moveTo(agentGroup);
      
   cp5.addSlider("Base_speed_2")
      .setPosition(10, 125)
      .setSize(bSSX2,bSSY)
      .setRange(0,3)
      .setValue(1.6)
      .moveTo(agentGroup);
      
   cp5.addSlider("Initial_agent_amount_1")
      .setPosition(10, 165)
      .setSize(bSSX2,bSSY)
      .setNumberOfTickMarks(51)
      .setRange(0,500)
      .setValue(100)
      .setDecimalPrecision(0)
      .moveTo(agentGroup);
      
   cp5.addSlider("Initial_agent_amount_2")
      .setPosition(10, 205)
      .setSize(bSSX2,bSSY)
      .setNumberOfTickMarks(51)
      .setRange(0,500)
      .setValue(100)
      .setDecimalPrecision(0)
      .moveTo(agentGroup);
      
   cp5.addSlider("Reproduction_rate_1")
      .setPosition(10, 245)
      .setSize(bSSX2,bSSY)
      .setRange(0,100)
      .setNumberOfTickMarks(51)
      .setValue(10)
      .moveTo(agentGroup);
      
   cp5.addSlider("Reproduction_rate_2")
      .setPosition(10, 285)
      .setSize(bSSX2,bSSY)
      .setRange(0,100)
      .setNumberOfTickMarks(51)
      .setValue(10)
      .moveTo(agentGroup);
   
      
   cp5.addBang("Start")
      .setPosition(1200 - 65, ORIGINY + DEFY + 20)
      .setSize(45, 30);
   
   cp5.addBang("Pause")
      .setPosition(1200 - 65, ORIGINY + DEFY + 70)
      .setSize(45, 30);
      
   /*
   float NRGPERFIGHT = 1.0;
int NRGFIGHTSCHEME = 0; //0 -- both lose energy, 1 -- energy gets stolen
int COEFSCHEME = 1; //0 -- energy depends on amount of cons in the whole pack, 1 -- energy depends on the amount of cons for this particular agent
float NRGSTEALCOEFF = 0.5; //energy steal coefficiency

int FIGHTSCHEME = 0; //0 -- everyone diff species, 1 -- two lones don't fight (PACKFIGHTPEAK has to be defined), 2 -- lones never fight (PACKFIGHTPEAK has to be defined)
int PACKFIGHTPEAK = 3;  //Pack size to be hostile

//  Pack energy balancing settings
int NRGBALANCINGTYPE = 2; //0 -- no balancing, 1 -- gradual balancing, 2 -- immediate balancing

float NRGBALANCESPEED = 0.002;
   */
      
   Group genGroup = cp5.addGroup("General_settings")
                       .setBackgroundColor(color(#003D7C, 100))
                       .setBackgroundHeight(320)
                       .setPosition(ORIGINX + 780, ORIGINY + DEFY + 20)
                       .setWidth(340)
                       ;
                       
   
   cp5.addSlider("Fight_energy")
      .setPosition(10,5)
      .setSize(sSSX,sSSY)
      .setRange(0,5)
      .setValue(1)
      .moveTo(genGroup);
      
   
      
   cp5.addSlider("Energy_steal_coefficient")
      .setPosition(10,85)
      .setSize(sSSX,sSSY)
      .setRange(0,2)
      .setValue(0.5)
      .moveTo(genGroup)
      .hide();
      
   cp5.addSlider("Energy_stolen")
      .setPosition(10,45)
      .setSize(sSSX,sSSY)
      .setRange(0,1)
      .setValue(0)
      .setNumberOfTickMarks(2)
      .setDecimalPrecision(0)
      .moveTo(genGroup);
   
      
   cp5.addSlider("Connection_fight_scheme")
      .setPosition(10,125)
      .setSize(sSSX,sSSY)
      .setRange(0,2)
      .setValue(1)
      .setNumberOfTickMarks(3)
      .setDecimalPrecision(0)
      .moveTo(genGroup);
   
   
      
   cp5.addSlider("Pack_hostility_size")
      .setPosition(10,205)
      .setSize(sSSX,sSSY)
      .setRange(0,15)
      .setValue(3)
      .setNumberOfTickMarks(16)
      .setDecimalPrecision(0)
      .moveTo(genGroup)
      .hide();
      
   cp5.addSlider("Fight_scheme")
      .setPosition(10,165)
      .setSize(sSSX,sSSY)
      .setRange(0,2)
      .setValue(0)
      .setNumberOfTickMarks(3)
      .setDecimalPrecision(0)
      .moveTo(genGroup);
      
   cp5.addSlider("Energy_balancing_speed")
      .setPosition(10,285)
      .setSize(sSSX,sSSY)
      .setRange(0,0.05)
      .setValue(0.002)
      .setDecimalPrecision(4)
      .moveTo(genGroup)
      .hide();
      
   cp5.addSlider("Energy_balancing_type")
      .setPosition(10,245)
      .setSize(sSSX,sSSY)
      .setRange(0,2)
      .setValue(2)
      .setNumberOfTickMarks(3)
      .setDecimalPrecision(0)
      .moveTo(genGroup);
   
   
   
      
   
   PFont font = createFont("PressStart2P-Regular.ttf", 5);
   textFont(font);
   
   
}

void Resource(float bsRes){
  BASERES = bsRes;
  RESREPSPEED = BASERES/60;
  if(AV != null){
    AV.getNet().updateMaxRes();
    AV.getNet().updateResRepSpeed();
  }
}

void Resource_type(float valR){
  RESTYPE = (int)valR;
  if(AV != null){
    AV.getNet().updateMaxRes();
  }
}

void Red_Valence(float valR){
  VALENCE1 = (int)valR;
  if(AV != null){
    AV.updateValences();
  }
}



void Green_Valence(float valR){
  VALENCE2 = (int)valR;
  if(AV != null){
    AV.updateValences();
  }
}

void Initial_agent_amount_1(float valR){
  INITAGENTAMOUNT1 = (int)valR;
}


void Base_speed_1 (float valR){
  BASESPEED1 = valR;
  SPEEDRANDOMNESS1 = BASESPEED1/2;
  NRGPERSTEP1 = BASESPEED1/8;
}

void Base_speed_2 (float valR){
  BASESPEED2 = valR;
  SPEEDRANDOMNESS2 = BASESPEED2/2;
  NRGPERSTEP2 = BASESPEED2/8;
}


void Reproduction_rate_1(float valR){
  REPRODUCTPROB1 = valR / 10000;
}

void Reproduction_rate_2(float valR){
  REPRODUCTPROB2 = valR / 10000;
}



void Initial_agent_amount_2(float valR){
  INITAGENTAMOUNT2 = (int)valR;
}

void Scream_distance(float valR){
  SCRHEARDIST = valR;
}

void Max_pack_distance(float valR){
  PACKDIST = valR;
}

void Connection_distance(float valR){
  CONNECTDIST = valR;
}

void Comfortable_distance(float valR){
  COMDIST = valR;
}

void Pack_comfortable_distance(float valR){
  PACKCOMDIST = valR;
}

void Fight_distance(float valR){
  FIGHTDIST = valR;
}

void Fight_energy(float valR){
  NRGPERFIGHT = valR;
}

void Energy_stolen(float valR){
  NRGFIGHTSCHEME = (int)valR;
  if((int)valR == 0){
    cp5.getGroup("General_settings").getController("Energy_steal_coefficient").hide();
  }
  else{
    cp5.getGroup("General_settings").getController("Energy_steal_coefficient").show();
  }
}

void Energy_steal_coefficient(float valR){
  NRGSTEALCOEFF = valR;
}

void Connection_fight_scheme(float valR){
  COEFSCHEME = (int)valR;
}



void Fight_scheme(float valR){
  FIGHTSCHEME = (int)valR;
  if((int)valR == 0){
    cp5.getGroup("General_settings").getController("Pack_hostility_size").hide();
  }
  else{
    cp5.getGroup("General_settings").getController("Pack_hostility_size").show();
  }
}

void Pack_hostility_size(float valR){
  PACKFIGHTPEAK = (int)valR;
}

void Energy_balancing_type(float valR){
  NRGBALANCINGTYPE = (int)valR;
  if((int)valR == 1){
    cp5.getGroup("General_settings").getController("Energy_balancing_speed").show();
  }
  else{
    cp5.getGroup("General_settings").getController("Energy_balancing_speed").hide();
  }
}

void Energy_balancing_speed(float valR){
  NRGBALANCESPEED = valR;
}

void Reset(){
  SCRHEARDIST = 100;
  PACKDIST = 80;
  CONNECTDIST = 40;
  COMDIST = 20;
  PACKCOMDIST = 80;
  FIGHTDIST = 40;
  cp5.getController("Scream_distance").setValue(100);
  cp5.getController("Max_pack_distance").setValue(80);
  cp5.getController("Connection_distance").setValue(40);
  cp5.getController("Comfortable_distance").setValue(20);
  cp5.getController("Pack_comfortable_distance").setValue(80);
  cp5.getController("Fight_distance").setValue(40);
}



void Start(){
  firstRun = false;
  background(0);
  AV = new AviaryRivalry();
  if(pause){
    fill(0, 100);
    stroke(0, 0);
    rect(ORIGINX, ORIGINY, DEFX, DEFY);
    fill(#ffffff); 
    textSize(20);
    text("PAUSE", DEFX/2 - 40, DEFY/2);
  }
}


void Pause(){
  if(pause)
    pause = false;
  else {
    if(!firstRun){
      fill(0, 100);
      stroke(0, 0);
      rect(ORIGINX, ORIGINY, DEFX, DEFY);
      fill(#ffffff); 
      textSize(20);
      text("PAUSE", DEFX/2 - 40, DEFY/2);
      pause = true;
    }
  }
}
 
 
void draw(){
  
  pushMatrix();
  
  if(!pause){
    if(AV != null)
      AV.run();
  }
  
  popMatrix();
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

void keyPressed(){
  switch(key){
    case 'r':
    case 'R':
      firstRun = false;
      background(0);
      AV = new AviaryRivalry();
      if(pause){
        fill(0, 100);
        stroke(0, 0);
        rect(ORIGINX, ORIGINY, DEFX, DEFY);
        fill(#ffffff); 
        textSize(20);
        text("PAUSE", DEFX/2 - 40, DEFY/2);
      }
      break;
    case ' ':
      if(pause)
        pause = false;
      else {
        if(!firstRun){
          fill(0, 100);
          stroke(0, 0);
          rect(ORIGINX, ORIGINY, DEFX, DEFY);
          fill(#ffffff); 
          textSize(20);
          text("PAUSE", DEFX/2 - 40, DEFY/2);
          pause = true;
        }
        else{
          firstRun = false;
          background(0);
          AV = new AviaryRivalry();
          pause = false;
        }
      }
    break;
  }
}
