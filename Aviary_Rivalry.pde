import java.util.*;
import controlP5.*;
import java.text.SimpleDateFormat;
import java.io.FileWriter;
import java.io.BufferedWriter;
//  Aviary settings

int ORIGINX = 3;
int ORIGINY = 3;

int DEFX = 1000;
int DEFY = 1000;

int QUADX = 5;
int QUADY = 5;

int INITAGENTAMOUNT1 = 2;
int INITAGENTAMOUNT2 = 20;

boolean SYSSPAWN = true;

float BASERES = 50;
float RESREPSPEED = BASERES/360;
int RESPERQUAD = 3;
int REPCTRPEAK = 240;

//  Agent settings
float BASESPEED1 = 1.6;
float BASESPEED2 = 1.6;
float SPEEDRANDOMNESS1 = BASESPEED1/2;
float SPEEDRANDOMNESS2 = BASESPEED2/2;
float SPEEDAGECOEFF = 1.0;

float BASEMAXAGE = 3600;
float AGEPERSTEP = 0;

float SUFFENERGY = 25;
float MAXENERGY = 50;
float NRGPERSTEP1 = 0.02;//BASESPEED1/8;
float NRGPERSTEP2 = 0;//BASESPEED2/8;

int VALENCE1 = 3;
int VALENCE2 = 0;

float RESECOLLECTEDPERSTEP = 1.0;

//  Reproduction settings 
float REPRODUCTLOW = 1440;
float REPRODUCTHIGH = 3000;
float REPRODUCTPROB1 = 0.001;
float REPRODUCTPROB2 = 0.002;
float REPRODUCTCOST = 5.0;

//  Fight settings
float NRGPERFIGHT = 1.0;

//  Pack energy depletion settings
float NRGFORCONPERSTEP = 0.05;

//  Action counter
int ACTCTRPEAK = 15;

// Distances settings
float SCRHEARDIST = 200;
float PACKDIST = 80;
float CONNECTDIST = 40;
float COMDIST = 20;
float PACKCOMDIST = 80;
float FIGHTDIST = 40;
float VISUALDIST = 50;

//Graph counter
int INFOREPCTRPEAK = 60;

AviaryRivalry AV = null;
Reporter REP = new Reporter(null);

boolean pause = false;
boolean firstRun = true;

boolean Fixed = true;

int screenshotNum = 1;
int scrShCounter = 0;

boolean autoRun = false;
boolean report = true;

//AviaryRivalry(int argInitAgentAmnt, int argQuadX, int argQuadY, float argRes)


ControlP5 cp5;


void setup(){
   size(1300, 1300); 
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
   /*
   Group resGroup = cp5.addGroup("GrResSettings")
                       //.setLabel("Настройки ресурса")
                       .setBackgroundColor(color(#003D7C, 100))
                       .setBackgroundHeight(60)
                       .setPosition(ORIGINX, ORIGINY + DEFY + 20)
                       .setWidth(380)
                       ;
   
   cp5.addSlider("SlResDensity")
      //.setLabel("Пл-ть ресурса")
      .setPosition(10,5)
      .setSize(bSSX,bSSY)
      .setRange(0,3)
      .setValue(1.6)
      .moveTo(resGroup);
   
   
   cp5.addSlider("SlResType")
      //.setLabel("Распределение ресурса")
      .setPosition(10, 5 + bGap)
      .setSize(bSSX,bSSY)
      .setRange(0,3)
      .setNumberOfTickMarks(4)
      .setValue(0)
      .setDecimalPrecision(0)
      .setSliderMode(Slider.FLEXIBLE)
      .moveTo(resGroup);
      
   
   Group distGroup = cp5.addGroup("GrDistSettings")
                //.setLabel("Настройки расстояний")
                .setBackgroundColor(color(#003D7C, 100))
                .setBackgroundHeight(110)
                .setPosition(ORIGINX, ORIGINY + DEFY + 100)
                .setWidth(380)
                ;
   
   cp5.addSlider("SlScreamDist")
      //.setLabel("Радиус слышимости")
      .setPosition(10,5)
      .setSize(sSSX,sSSY)
      .setRange(0,200)
      .setValue(100)
      .moveTo(distGroup);
   
   cp5.addSlider("SlMaxPackDist")
      //.setLabel("Макс. расст. в стае")
      .setPosition(10,5 + sGap)
      .setSize(sSSX,sSSY)
      .setRange(0,200)
      .setValue(80)
      .moveTo(distGroup);
   
   cp5.addSlider("SlConDist")
      //.setLabel("Расст. объед. в стаи")
      .setPosition(10,5 + 2 * sGap)
      .setSize(sSSX,sSSY)
      .setRange(0,200)
      .setValue(40)
      .moveTo(distGroup);
   
   cp5.addSlider("SlComfDist")
      //.setLabel("Комф. расст. в стае")
      .setPosition(10,5 + 3 * sGap)
      .setSize(sSSX,sSSY)
      .setRange(0,200)
      .setValue(20)
      .moveTo(distGroup);
   
   cp5.addSlider("SlPackComfDist")
      //.setLabel("Комф. расст. между стаями")
      .setPosition(10,5 + 4 * sGap)
      .setSize(sSSX,sSSY)
      .setRange(0,200)
      .setValue(80)
      .moveTo(distGroup);
      
   cp5.addSlider("SlFightDist")
      //.setLabel("Радиус конкуренции")
      .setPosition(10,5 + 5 * sGap)
      .setSize(sSSX,sSSY)
      .setRange(0,200)
      .setValue(40)
      .moveTo(distGroup);
      
      
   cp5.addBang("BgResetDist")
      //.setLabel("Сбросить")
      .setPosition(345, 45)
      .setSize(20,20)
      .moveTo(distGroup);
   
   
   
   Group agentGroup = cp5.addGroup("GrAgentSettings")
                       //.setLabel("Настройки агентов")
                       .setBackgroundColor(color(#003D7C, 100))
                       .setBackgroundHeight(190)
                       .setPosition(ORIGINX + 390, ORIGINY + DEFY + 20)
                       .setWidth(380)
                       ;
   
   cp5.addSlider("SlRedValence")
      //.setLabel("Вал-ть кр. агентов")
      .setPosition(10, 5)
      .setSize(bSSX2,bSSY)
      .setRange(0,5)
      .setValue(2)
      .setNumberOfTickMarks(6)
      .setDecimalPrecision(0)
      .setSliderMode(Slider.FLEXIBLE)
      .moveTo(agentGroup);
   
   cp5.addSlider("SlGreenValence")
      //.setLabel("Вал-ть зел. агентов")
      .setPosition(10, 5 + bGap)
      .setSize(bSSX2,bSSY)
      .setRange(0,5)
      .setValue(2)
      .setNumberOfTickMarks(6)
      .setDecimalPrecision(0)
      .setSliderMode(Slider.FLEXIBLE)
      .moveTo(agentGroup);
      
   cp5.addSlider("SlBaseSpeedRed")
      //.setLabel("Баз. скорость кр. агентов")
      .setPosition(10, 5 + 2 * bGap)
      .setSize(bSSX2,bSSY)
      .setRange(0,3)
      .setValue(1.6)
      .moveTo(agentGroup);
      
   cp5.addSlider("SlBaseSpeedGreen")
      //.setLabel("Баз. скорость зел. агентов")
      .setPosition(10, 5 + 3 * bGap)
      .setSize(bSSX2,bSSY)
      .setRange(0,3)
      .setValue(1.6)
      .moveTo(agentGroup);
      
   cp5.addSlider("SlInitAgentAmountRed")
      //.setLabel("Нач. кол-во кр. агентов")
      .setPosition(10, 5 + 4 * bGap)
      .setSize(bSSX2,bSSY)
      .setNumberOfTickMarks(51)
      .setRange(0,500)
      .setValue(100)
      .setDecimalPrecision(0)
      .moveTo(agentGroup);
      
   cp5.addSlider("SlInitAgentAmountGreen")
      //.setLabel("Нач. кол-во зел. агентов")
      .setPosition(10, 5 + 5 * bGap)
      .setSize(bSSX2,bSSY)
      .setNumberOfTickMarks(51)
      .setRange(0,500)
      .setValue(100)
      .setDecimalPrecision(0)
      .moveTo(agentGroup);
      
   cp5.addSlider("SlReproductionRateRed")
      //.setLabel("Ур. рождаемости кр. агентов")
      .setPosition(10, 5 + 6 * bGap)
      .setSize(bSSX2,bSSY)
      .setRange(0,100)
      .setNumberOfTickMarks(51)
      .setValue(10)
      .moveTo(agentGroup);
      
   cp5.addSlider("SlReproductionRateGreen")
      //.setLabel("Ур. рождаемости зел. агентов")
      .setPosition(10, 5 + 7 * bGap)
      .setSize(bSSX2,bSSY)
      .setRange(0,100)
      .setNumberOfTickMarks(51)
      .setValue(10)
      .moveTo(agentGroup);
   
      
   
      
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
   
      
   Group genGroup = cp5.addGroup("GrGeneralSettings")
                       //.setLabel("Общие настройки")
                       .setBackgroundColor(color(#003D7C, 100))
                       .setBackgroundHeight(190)
                       .setPosition(ORIGINX + 780, ORIGINY + DEFY + 20)
                       .setWidth(340)
                       ;
                       
   
   cp5.addSlider("SlFightEnergy")
      //.setLabel("Энергия на конкуренцию")
      .setPosition(10,5)
      .setSize(sSSX,sSSY)
      .setRange(0,5)
      .setValue(1)
      .moveTo(genGroup);
      
   
      
   cp5.addSlider("SlEnergyStealCoef")
      //.setLabel("Доля переходящей энергии")
      .setPosition(10, 5 + 2 * bGap)
      .setSize(sSSX,sSSY)
      .setRange(0,2)
      .setValue(0.5)
      .moveTo(genGroup)
      .hide();
      
   cp5.addSlider("SlEnergyStolen")
      //.setLabel("Шаблон конкуренции")
      .setPosition(10,5 + bGap)
      .setSize(sSSX,sSSY)
      .setRange(0,1)
      .setValue(0)
      .setNumberOfTickMarks(2)
      .setDecimalPrecision(0)
      .setSliderMode(Slider.FLEXIBLE)
      .moveTo(genGroup);
   
      
   cp5.addSlider("SlConFightScheme")
      //.setLabel("Тип зав-ти от соединений")
      .setPosition(10,5 + 3 * bGap)
      .setSize(sSSX,sSSY)
      .setRange(0,2)
      .setValue(1)
      .setNumberOfTickMarks(3)
      .setDecimalPrecision(0)
      .setSliderMode(Slider.FLEXIBLE)
      .moveTo(genGroup);
   
   
      
   cp5.addSlider("SlPackHostilitySize")
      //.setLabel("Мин. размер агресивной стаи")
      .setPosition(10,5 + 5 * bGap)
      .setSize(sSSX,sSSY)
      .setRange(2,15)
      .setValue(3)
      .setNumberOfTickMarks(16)
      .setDecimalPrecision(0)
      .setSliderMode(Slider.FLEXIBLE)
      .moveTo(genGroup)
      .hide();
      
   cp5.addSlider("SlFightScheme")
      //.setLabel("Модификация шабл. конкуренции")
      .setPosition(10,5 + 4 * bGap)
      .setSize(sSSX,sSSY)
      .setRange(0,2)
      .setValue(0)
      .setNumberOfTickMarks(3)
      .setDecimalPrecision(0)
      .setSliderMode(Slider.FLEXIBLE)
      .moveTo(genGroup);
      
   cp5.addSlider("SlEnergyBalancingSpeed")
      //.setLabel("Скорость баланса энергии")
      .setPosition(10,5 + 7 * bGap)
      .setSize(sSSX,sSSY)
      .setRange(0,0.05)
      .setValue(0.002)
      .setDecimalPrecision(4)
      .moveTo(genGroup)
      .hide();
      
   cp5.addSlider("SlEnergyBalancingType")
      //.setLabel("Тип баланса энергии")
      .setPosition(10,5 + 6 * bGap)
      .setSize(sSSX,sSSY)
      .setRange(0,2)
      .setValue(2)
      .setNumberOfTickMarks(3)
      .setDecimalPrecision(0)
      .setSliderMode(Slider.FLEXIBLE)
      .moveTo(genGroup);
   */
   
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
      
   
   PFont font = createFont("PressStart2P-Regular.ttf", 5);
   textFont(font);
   
   
}

void SlResDensity(float bsRes){
  BASERES = bsRes;
  RESREPSPEED = BASERES/60;
  if(AV != null){
    AV.updateMaxRes();
    AV.updateResRepSpeed();
  }
}

void SlRedValence(float valR){
  VALENCE1 = (int)valR;
  if(AV != null){
    AV.updateValences();
  }
}



void SlGreenValence(float valR){
  VALENCE2 = (int)valR;
  if(AV != null){
    AV.updateValences();
  }
}

void SlInitAgentAmountRed(float valR){
  INITAGENTAMOUNT1 = (int)valR;
}

void SlInitAgentAmountGreen(float valR){
  INITAGENTAMOUNT2 = (int)valR;
}


void SlBaseSpeedRed (float valR){
  BASESPEED1 = valR;
  SPEEDRANDOMNESS1 = BASESPEED1/2;
  NRGPERSTEP1 = BASESPEED1/8;
}

void SlBaseSpeedGreen (float valR){
  BASESPEED2 = valR;
  SPEEDRANDOMNESS2 = BASESPEED2/2;
  NRGPERSTEP2 = BASESPEED2/8;
}


void SlReproductionRateRed(float valR){
  REPRODUCTPROB1 = valR / 10000;
}

void SlReproductionRateGreen(float valR){
  REPRODUCTPROB2 = valR / 10000;
}





void SlScreamDist(float valR){
  SCRHEARDIST = valR;
}

void SlMaxPackDist(float valR){
  PACKDIST = valR;
}

void SlConDist(float valR){
  CONNECTDIST = valR;
}

void SlComfDist(float valR){
  COMDIST = valR;
}

void SlPackComfDist(float valR){
  PACKCOMDIST = valR;
}

void SlFightDist(float valR){
  FIGHTDIST = valR;
}

void SlFightEnergy(float valR){
  NRGPERFIGHT = valR;
}

void BgResetDist(){
  SCRHEARDIST = 100;
  PACKDIST = 80;
  CONNECTDIST = 40;
  COMDIST = 20;
  PACKCOMDIST = 80;
  FIGHTDIST = 40;
  cp5.getController("SlScreamDist").setValue(100);
  cp5.getController("SlMaxPackDist").setValue(80);
  cp5.getController("SlConDist").setValue(40);
  cp5.getController("SlComfDist").setValue(20);
  cp5.getController("SlPackComfDist").setValue(80);
  cp5.getController("SlFightDist").setValue(40);
}



void BgStart(){
  background(0);
  AV = new AviaryRivalry();
  REP.setAviary(AV);
  REP.setRunStartTimeStamp();
  
  if(firstRun){
    try{  
     REP.initialReport();
    }
    catch(IOException e){
     print("CUM");
    }
  }
  
  firstRun = false;
  
  if(pause){
    fill(0, 100);
    stroke(0, 0);
    rect(ORIGINX, ORIGINY, DEFX, DEFY);
    fill(#ffffff); 
    textSize(20);
    text("PAUSE", DEFX/2 - 40, DEFY/2);
  }
}


void BgPause(){
  if(pause)
    pause = false;
  else {
    if(!firstRun){
      fill(0, 80);
      stroke(0, 0);
      rect(ORIGINX, ORIGINY, DEFX, DEFY);
      fill(#ffffff, 100); 
      rect(ORIGINX + 5, ORIGINY + 5, 12, 30);
      rect(ORIGINX + 25, ORIGINY + 5, 12, 30);
      pause = true;
    }
  }
}


void BgScreenshot(){
  saveFrame("Screenshots/Aviary_Run-" + screenshotNum + ".png");
  screenshotNum++;
  scrShCounter = 120;
}
 
 /*
 .setPosition(1200 - 65, ORIGINY + DEFY + 120)
      .setSize(45, 30);*/
 
 
void draw(){
  background(0);
  pushMatrix();
  
  boolean finished = false;
  
  if(!pause){
    if(AV != null){
      finished = AV.run();
    }
  }
  
  if(finished){
    /*boolean autoRun = false;
boolean report = true;*/
    if(report){
      try {
        REP.report();
      }
      catch(Exception e){
        print(e.getMessage());
      }
    }
    if(autoRun){
      BgStart();
    }
  }
  
  if(scrShCounter > 0){
    scrShCounter--;
    fill(#ffffff, 100);
    stroke(#ffffff, 255);
    rect(1200 - 47 + 5, ORIGINY + DEFY + 170, 2, 15);
    triangle(1200 - 50 + 5, ORIGINY + DEFY + 185, 1200 - 42 + 5, ORIGINY + DEFY + 185, 1200 - 46 + 5, ORIGINY + DEFY + 195);
    rect(1200 - 55 + 5, ORIGINY + DEFY + 195, 20, 2);
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
        fill(0, 80);
        stroke(0, 0);
        rect(ORIGINX, ORIGINY, DEFX, DEFY);
        fill(#ffffff, 100); 
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
          fill(#ffffff, 100);  
          rect(ORIGINX + 5, ORIGINY + 5, 12, 30);
          rect(ORIGINX + 25, ORIGINY + 5, 12, 30);
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
    case 's':
    case 'S':
      saveFrame("Screenshots/Aviary_Run-" + screenshotNum + ".png");
      screenshotNum++;
      scrShCounter = 120;
    break;
  }
}
