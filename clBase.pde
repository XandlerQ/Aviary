color STDBASECOLOR = #3483FF;


class Base{
  
  float x, y;                                                                        //Position
  int resTpAmnt;                                                                     //Amount of resource types
  int[] res;                                                                         //Array for stored resources by type
  color cl = #3483FF;                                                                //Base color
  float size = 30;                                                                   //Base size px
  
  //Constructors
  
  Base(){
    Random r = new Random();                                                         //Randomizer
    x = DEFX/5 + (3 * DEFX / 5) * r.nextFloat();                                     //
    y = DEFY/5 + (3 * DEFY / 5) * r.nextFloat();                                     //Random position
    
    resTpAmnt = 1;                                                                   //Single resource type by default
    res = new int[resTpAmnt];                                                        //Make stored resources by type array
    
  }
  
  //Getters
  
  //Setters
  
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
