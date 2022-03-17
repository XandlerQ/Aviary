import java.util.Random;
import java.util.ArrayList;


int DEFX = 1000;
int DEFY = 1000;


Aviary AV = new Aviary(1, 3, 1000);


void setup(){
   size(1920, 1080); 
   background(0);
   ellipseMode(CENTER);
 }  
 
 
void draw(){
  AV.run(DEFX, DEFY);
  fill(#5555ff); text(int(frameRate),5,10);
}
