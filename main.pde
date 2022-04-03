import java.util.Random;
import java.util.ArrayList;


int DEFX = 1080;
int DEFY = 1080;

boolean pause = false;


Aviary AV = new Aviary(1, 3, 300);


void setup(){
   size(1080, 1080); 
   background(0);
   ellipseMode(CENTER);
 }  
 
 
void draw(){
  if(!pause){
    AV.run(DEFX, DEFY);
    fill(#5555ff); text(int(frameRate),5,10);
  }
}

void mouseClicked(){
  AV.moveBase(0, mouseX, mouseY);
}

void keyPressed(){
  switch(key){
    case 'r':
    case 'R':
      AV = new Aviary(1, 3, 300);
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
