color STDRESOURCECOLOR = #FFAA00;


class Resource{
  
  int type;                                                              //Type index
  float x, y;                                                            //Position
  int res;                                                               //Amount of resource held
  color cl = #FFAA00;                                                    //Color
  
  //Constructors
  
  Resource(){
    Random r = new Random();                                             //Randomizer
    x = DEFX/5 + (3 * DEFX / 5) * r.nextFloat();                         //
    y = DEFY/5 + (3 * DEFY / 5) * r.nextFloat();                         //Random position
    
    type = 0;                                                            //Type 0 by default
    
    res = 60;                                                            //Initial resource stored by default
    
  }
  
  //Getters
  
  //Setters
  
  //Methods
  
  boolean lowerRes(){                                                    //Lower stored resource amount
    return ((res--) == 0);
  }
  
  //Renderers
    
  void render(){                                                         //Renders resource
    noStroke();
    fill(cl);
    circle(x, y, res/2);
  }
  
}
