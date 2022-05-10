class Point{
  
  float x;
  float y;
  
  Point(float argX, float argY){
    x = argX;
    y = argY;
  }
  
  //Getters
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  //Setters
  
  void setX(float argX){
    x = argX;
  }
  
  void setY(float argY){
    y = argY;
  }
  
  void setCoords(float argX, float argY){
    x = argX;
    y = argY;
  }
  
  @Override
  public boolean equals(Object obj){
    if (this == obj)
      return true;
    if (obj == null)
      return false;
    Point arg = (Point) obj;
    return (arg.getX() == x && arg.getY() == y);
  }
  
}

class Graph{
  
  int type = 0;
  
  int origX;
  int origY;
  
  int dimX;
  int dimY;
  
  int xAmnt;
  
  color graphBordColor = #FFFFFF;
  color graphColor = #FFFFFF;
  color graphLineColor = #00A8FF;
  color graphTextColor = #00A8FF;
  
  ArrayList<Point> arrPt;
  
  Graph(){
    type = 0;
    arrPt = new ArrayList<Point>();
    origX = 0;
    origY = 0;
    dimX = 400;
    dimY = 200;
    xAmnt = 200;
  }
  
  Graph(int orX, int orY){
    this();
    origX = orX;
    origY = orY;
  }
  
  //Getters
  
  int getOrX(){
    return origX;
  }
  
  int getOrY(){
    return origY;
  }
  
  int getDimX(){
    return dimX;
  }
  
  int getDimY(){
    return dimY;
  }
  
  //Setters
  
  void setType(int argTp){
    type = argTp;
  }
  
  void setOrigin(int orX, int orY){
    origX = orX;
    origY = orY;
  }
  
  void setSize(int dX, int dY){
    dimX = dX;
    dimY = dY;
  }
  
  void setXAmnt(int argXAmnt){
    xAmnt = argXAmnt;
  }
  
  
  void setgraphBordColor(color argCl){
    graphBordColor = argCl;
  }
  
  void setgraphColor(color argCl){
    graphColor = argCl;
  }
  
  void setgraphLineColor(color argCl){
    graphLineColor = argCl;
  }
  
  void setgraphTextColor(color argCl){
    graphTextColor = argCl;
  }
  
  //Methods
  
  void addPoint(Point argPt){
    
    if(arrPt.size() != 0){
      if(argPt.getX() == arrPt.get(arrPt.size() - 1).getX() && argPt.getY() == arrPt.get(arrPt.size() - 1).getY()){
        println("returned");
        return;
      }
    }
    
    if(arrPt.size() <= xAmnt){
      arrPt.add(argPt);
    }
    else{
      arrPt.remove(0);
      arrPt.add(argPt);
    }
  }
  
  void addPoint(float argX, float argY){
    Point newPt = new Point(argX, argY);
    addPoint(newPt);
  }
  
  void addTimePoint(float argY){
    Point newPt = new Point(millis()/1000, argY);
    addPoint(newPt);
  }
  
  //Rendrers
  
  /*
  color graphBordColor;
  color graphColor;
  color graphLineColor;
  color graphTextColor;
  */
  
  
  void render(){

    float maxY = 0;
    for (Iterator<Point> iter = arrPt.iterator(); iter.hasNext();){
      Point pt = iter.next();
      if(pt.getY() > maxY){
        maxY = pt.getY();
      }
    }
        
    if (maxY == 0)
      maxY = 1;
    
    strokeWeight(1);
    stroke(graphBordColor);
    fill(0);
    rect(origX, origY, dimX, dimY);
    
    if(arrPt.size() == 0)
      return;
    
    if(type == 1){
      
      fill(graphColor);
      stroke(graphColor);
      int step = 0;
      
      if(arrPt.size() != 1) 
        step = dimX / (arrPt.size() - 1);


      int curShift = 0;
      
      for (int i = 0; i < arrPt.size(); i++){
        float X = origX + curShift;
        float Y = origY + dimY * (1 - arrPt.get(i).getY() * 0.8 / maxY);
        
        if(i == 0){
          circle(X, Y, 2);
        }
        else{        
          float Xprev = origX + curShift - step;
          float Yprev = origY + dimY * (1 - arrPt.get(i - 1).getY() * 0.8 / maxY);
          
          circle(X, Y, 2);
          line(Xprev, Yprev, X, Y);
        }
        if(i == arrPt.size() - 1){
          stroke(graphLineColor, 100);
          line(X, Y, origX, Y);
          fill(graphTextColor);
          textSize(11);
          text(int(arrPt.get(i).getY()), origX + 5, Y - 7);
        }
        curShift += step;
      }
      
      text(int(millis()/1000), origX + dimX - 20, origY + dimY - 7);
      text(int(maxY * 1.25), origX + 5, origY + 10);
    }
    else{
      
      stroke(graphColor, 80);
      fill(graphColor, 50);
      
      float maxX = 0;
      for (Iterator<Point> iter = arrPt.iterator(); iter.hasNext();){
        Point pt = iter.next();
        if(pt.getX() > maxX){
          maxX = pt.getX();
        }
      }
      
      if (maxX== 0)
      maxX = 1;
      
      for (int i = 0; i < arrPt.size(); i++){
        float X = origX + dimX * arrPt.get(i).getX() * 0.8 / maxX;
        float Y = origY + dimY * (1 - arrPt.get(i).getY() * 0.8 / maxY);
        if(i == 0){
          circle(X, Y, 2);
        }
        else{
          float Xprev = origX + dimX * arrPt.get(i - 1).getX() * 0.8 /maxX;
          float Yprev = origY + dimY * (1 - arrPt.get(i - 1).getY() * 0.8 / maxY);
          circle(X, Y, 2);
          line(Xprev, Yprev, X, Y);
        }
        if(i == arrPt.size() - 1){
          stroke(graphLineColor, 100);
          line(X, Y, origX, Y);
          line(X, Y, X, origY + dimY);
          fill(graphTextColor);
          textSize(11);
          text(int(arrPt.get(i).getY()), origX + 5, Y - 7);
          text(int(arrPt.get(i).getX()), X + 3, origY + dimY - 7);
        }
      }
      
      text(int(maxX * 1.25), origX + dimX - 20, origY + dimY - 7);
      text(int(maxY * 1.25), origX + 5, origY + 10);
      
    }
  }
  
}
