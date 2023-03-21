/*class Reporter{
  
  AviaryRivalry AV;
  
  String fileName = "D:/screens/Study/CourseWork NumMeth/aviaryRivalryDiscreteGit/AviaryReports.txt";
  
  Date runStartTimeStamp;
  
  int repCtr = 0;
  
  boolean makeScrShot = false;
  boolean reported = false;
  
  Reporter(AviaryRivalry argAV){
    AV = argAV;
  }
  
  void initialReport() throws IOException{
    String reportStr =
      "======================================================\n" +
      "======================= Report =======================\n" +
      "======================================================\n\n" +
      formTimeStampReportString() +
      formParameterReportString();
      
    File file = new File(fileName);
      
    if (!file.exists()) {
      file.createNewFile();
    }
    
    try {
      FileWriter fw = new FileWriter(file,true);///true = append
      BufferedWriter bw = new BufferedWriter(fw);
      PrintWriter pw = new PrintWriter(bw);
      pw.write(reportStr);
     
      pw.close();
      bw.close();
      fw.close();
    } 
    catch (IOException e) {
      println("CUM");
    }
  }
  
  void setAviary(AviaryRivalry argAV){
    AV = argAV;
    resetReported();
  }
  
  void resetReported(){
    reported = false;
  }
  
  void setRunStartTimeStamp(){
    runStartTimeStamp = new Date();
  }
  
  String formTimeStampReportString(){
    SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Date runFinishTimeStamp = new Date();
    String reportStr = 
    "_____ Time stamps __________\n\n" +
    "Start time stamp: " + sdfDate.format(runStartTimeStamp) + "\n" +
    "Finish time stamp: " + sdfDate.format(runFinishTimeStamp) + "\n\n";
    
    return reportStr;
  }
  
  String formParameterReportString(){
    String reportStr = 
    "_____ Parameter Values _____\n\n" +
    
    "++++ Aviary Sizes ++++:\n" + 
    "DEFX = " + DEFX + "\n" +
    "DEFY = " + DEFY + "\n\n" +
    
    "+ Resourse Parameters +:\n" + 
    "QUADX = " + QUADX + "\n" +
    "QUADY = " + QUADY + "\n" +
    "BASERES = " + BASERES + "\n" +
    "RESREPSPEED = " + RESREPSPEED + "\n" +
    "RESPERQUAD = " + RESPERQUAD + "\n" +
    "REPCTRPEAK = " + REPCTRPEAK + "\n\n" +
    
    "++ Agent Parameters ++:\n" +
    "Initial Agent Spawn:\n" +
    "INITAGENTAMOUNT1 = " + INITAGENTAMOUNT1 + "\n" +
    "INITAGENTAMOUNT2 = " + INITAGENTAMOUNT2 + "\n" +
    "SYSSPAWN = " + SYSSPAWN + "\n\n" +
    
    "Speed:\n" +
    "BASESPEED1 = " + BASESPEED1 + "\n" +
    "BASESPEED2 = " + BASESPEED2 + "\n" +
    "SPEEDRANDOMNESS1 = " + SPEEDRANDOMNESS1  + "\n" +
    "SPEEDRANDOMNESS2 = " + SPEEDRANDOMNESS2 + "\n" +
    "SPEEDAGECOEFF = " + SPEEDAGECOEFF + "\n\n" +
    
    "Age:\n" +
    "BASEMAXAGE = " + BASEMAXAGE + "\n" +
    "AGEPERSTEP = " + AGEPERSTEP + "\n\n" +
    
    "Energy:\n" +
    "SUFFENERGY = " + SUFFENERGY + "\n" +
    "MAXENERGY = " + MAXENERGY + "\n" +
    "NRGPERSTEP1 = " + NRGPERSTEP1 + "\n" +
    "NRGPERSTEP2 = " + NRGPERSTEP2 + "\n\n" +
    
    "Valences:\n" +
    "VALENCE1 = " + VALENCE1 + "\n" +
    "VALENCE2 = " + VALENCE2 + "\n\n" +
    
    "Resorce Collection:\n" +
    "RESECOLLECTEDPERSTEP = " + RESECOLLECTEDPERSTEP + "\n\n" +
    
    "Reproduction:\n" +
    "REPRODUCTLOW = " + REPRODUCTLOW + "\n" +
    "REPRODUCTHIGH = " + REPRODUCTHIGH + "\n" +
    "REPRODUCTPROB1 = " + REPRODUCTPROB1 + "\n" +
    "REPRODUCTPROB2 = " + REPRODUCTPROB2 + "\n" +
    "REPRODUCTCOST = " + REPRODUCTCOST + "\n\n" +
    
    "Fights:\n" +
    "NRGPERFIGHT = " + NRGPERFIGHT + "\n\n" +
    
    "Packs:\n" +
    "NRGFORCONPERSTEP = " + NRGFORCONPERSTEP + "\n\n"; 
    
    return reportStr;
  }
  
  String formFinalDataReportString(){
    int pop1 = AV.getPopSp1Ctr();
    int pop2 = AV.getPopSp2Ctr();
    String reportStr = 
    "_____ Final Data _____\n\n" +
    "Populations:\n" +
    "Population 1: " + pop1 + "\n" +
    "Population 2: " + pop2 + "\n";
    if(pop1 == 0){
      reportStr += "Population 2 is victorious\n";
    }
    else{
      reportStr += "Population 1 is victorious\n";
    }
    
    reportStr +=
    "Packs:\n" + 
    "Pack count 1: " + AV.getSp1PackCount() + "\n" +
    "Pack count 2: " + AV.getSp2PackCount() + "\n";
    
    return reportStr;
  }
  
  void report() throws IOException{
    if(!reported){
      String reportStr =
      "---->   Run number " + repCtr + "   <----\n" +
      formFinalDataReportString() + "\n\n";
      
      File file = new File(fileName);
      
      if (!file.exists()) {
        file.createNewFile();
      }
      
      try {
        FileWriter fw = new FileWriter(file,true);///true = append
        BufferedWriter bw = new BufferedWriter(fw);
        PrintWriter pw = new PrintWriter(bw);

        pw.write(reportStr);
        
        pw.close();
        bw.close();
        fw.close();
      } 
      catch (IOException e) {
        println("CUM");
      } 
      reported = true;
      repCtr++;
    }
  }
}
*/
