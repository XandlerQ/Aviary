// External method file

float directionAddition(float dir1, float dir2){
  float resDir = 0;
  float x1, y1, x2, y2;
  x1 = cos(dir1);
  y1 = sin(dir1);
  x2 = cos(dir2);
  y2 = sin(dir2);
  
  float xres, yres;
  
  xres = x1 + x2;
  yres = y1 + y2;
  
  float module = sqrt((xres * xres) + (yres * yres));
  
  if (module == 0){
    Random r = new Random();
    resDir = (float)(2 * Math.PI * r.nextFloat());
  }
  else{
    xres /= module;
    yres /= module;
    resDir = acos(xres);
    if(yres < 0)
      resDir = 2 * (float)Math.PI - resDir;
  }
  return resDir;
}

float directionAddition(ArrayList<Float> dirs){
  float resDir = 0;
  if(dirs.size() == 1){
    resDir = dirs.get(0);
  }
  ArrayList<Float> xi = new ArrayList<Float>(dirs.size());
  ArrayList<Float> yi = new ArrayList<Float>(dirs.size());
  
  dirs.forEach((dir) -> {
    xi.add(cos(dir));
    yi.add(sin(dir));
  });
  
  float xres = 0, yres = 0;
  
  for (int i = 0; i < xi.size(); i++){
    xres += xi.get(i);
    yres += yi.get(i);
  }
  
  float module = sqrt((xres * xres) + (yres * yres));
  
  if (module == 0){
    Random r = new Random();
    resDir = (float)(2 * Math.PI * r.nextFloat());
  }
  else{
    xres /= module;
    yres /= module;
    resDir = acos(xres);
    if(yres < 0)
      resDir = 2 * (float)Math.PI - resDir;
  }
  return resDir;
}
