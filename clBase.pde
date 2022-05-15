
color STDBASECOLOR = #3483FF;


class Base{
  
  float x, y;                                                                        //Position
  int resourceTypeAmount;                                                                     //Amount of resource types
  int[] res;                                                                         //Array for stored resources by type
  color cl = #3483FF;                                                                //Base color
  float size = 40;                                                                   //Base size px
  
  //Constructors
  
  Base(){
    Random r = new Random();                                                         //Randomizer
    x = DEFX/5 + (3 * DEFX / 5) * r.nextFloat();                                     //
    y = DEFY/5 + (3 * DEFY / 5) * r.nextFloat();                                     //Random position
    
    resourceTypeAmount = 1;                                                                   //Single resource type by default
    res = new int[resourceTypeAmount];                                                        //Make stored resources by type array
    
    for(int i = 0; i < resourceTypeAmount; i++)
      res[i] = 0;
  }
  
  //Getters
  
  //Setters
  
  void setPos(float argX, float argY){
    x = argX;
    y = argY;
  }
  
  //Methods
  
  void addRes(int argResTp, int argResAmnt){                                         //Adds resource to storage
    res[argResTp] += argResAmnt;
  }
  
  //Renderers
  
  void render()                                                                      //Renders base
  {
    noStroke();
    fill(cl);
    circle(x, y, size);
  }
  
}
