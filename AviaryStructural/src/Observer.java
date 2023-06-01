/*
this.pop1Gr = new TimeGraph(600, 400, 500);
        this.pop1Gr.setOrigin(App.ORIGINX + App.DEFX, 5);
        this.pop1Gr.setPlainCl(new Color(0, 0, 0));
        this.pop1Gr.setBorderCl(new Color(100, 100, 100));
        this.pop1Gr.setDotCl(Color.RED);
        this.pop1Gr.setLineCl(Color.RED);
        this.pop1Gr.setLevelLineCl(Color.YELLOW);
        this.pop1Gr.setValueTextCl(Color.WHITE);
        this.pop1Gr.setTextSize(8);






        int getSp1PackCount(){
        int pckCount = 0;
        for(Iterator<Pack> iter = packs.iterator(); iter.hasNext();){
            Pack pck = iter.next();
            if(pck.getPackSpecies() == 0)
                pckCount++;
        }

        return pckCount;
    }

    int getSp2PackCount(){
        int pckCount = 0;
        for(Iterator<Pack> iter = packs.iterator(); iter.hasNext();){
            Pack pck = iter.next();
            if(pck.getPackSpecies() == 1)
                pckCount++;
        }

        return pckCount;
    }
 */

import java.awt.*;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;

public class Observer {

    Aviary aviaryReference;
    ArrayList<TimeGraph> timeGraphs;
    int timeGraphCtr;
    int timeGraphCtrPeak;
    int reportRowCtr;

    //Data

    double aviaryData[][];
    int reportCtr;
    int reportCtrPeak;
    ArrayList<String> reportDataHeaders;

    String dataReportFileName;
    String parameterReportFileName;
    String startTimeStamp;
    File reportFile;
    FileWriter fw;
    BufferedWriter bw;
    PrintWriter pw;

    //--------------------------------------
    //-----------  Constructors  -----------
    //--------------------------------------

    Observer() {
        this.aviaryReference = null;
        this.timeGraphs = null;
        this.timeGraphCtr = 0;
        this.timeGraphCtrPeak = App.GRAPHDATACTRPEAK - 1;
        this.reportRowCtr = 0;
        this.aviaryData = null;
        this.reportCtr = 0;
        this.reportCtrPeak = App.REPORTCTRPEAK - 1;
        this.reportDataHeaders = null;
        this.dataReportFileName = null;
        this.parameterReportFileName = null;
        this.startTimeStamp = null;
        this.reportFile = null;
        this.fw = null;
        this.bw = null;
        this.pw = null;
    }

    Observer(Aviary aviaryReference) {
        this();
        this.aviaryReference = aviaryReference;
        this.timeGraphs = new ArrayList<>();
    }

    Observer(Aviary aviaryReference, int areaCount, int valuesPerArea) {
        this(aviaryReference);
    }

    //--------------------------------------
    //--------------------------------------

    //---------------------------------
    //-----------  Getters  -----------
    //---------------------------------

    public Aviary getAviaryReference() {
        return aviaryReference;
    }

    public int getReportRowCtr() {
        return reportRowCtr;
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Setters  -----------
    //---------------------------------

    public void setAviaryReference(Aviary aviaryReference) {
        this.aviaryReference = aviaryReference;
    }

    public void setReportDataHeaders(ArrayList<String> reportDataHeaders) {
        this.reportDataHeaders = reportDataHeaders;
    }

    public void setDataReportFileName(String dataReportFileName) {
        this.dataReportFileName = dataReportFileName;
    }

    public void setParameterReportFileName(String parameterReportFileName) {
        this.parameterReportFileName = parameterReportFileName;
    }
    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Methods  -----------
    //---------------------------------

    void resetTimeGraphCtr() {
        this.timeGraphCtr = this.timeGraphCtrPeak;
    }

    void resetReportCtr() { this.reportCtr = this.reportCtrPeak; }

    void fillTimeGraphs() {
        int graphDimX = 495;
        int graphDimY = 200;
        int graphCapacity = 5;

        TimeGraph populationGraph = new TimeGraph(graphDimX, graphDimY, graphCapacity);
        populationGraph.setTitle("Population");
        populationGraph.setOrigin(App.ORIGINX + App.DEFX, 5);
        populationGraph.setPlainCl(new Color(255, 255, 255));
        populationGraph.setBorderCl(new Color(100, 100, 100));
        populationGraph.setDotCl(Color.RED);
        populationGraph.setLineCl(Color.RED);
        populationGraph.setLevelLineCl(Color.RED);
        populationGraph.setValueTextCl(Color.BLACK);
        populationGraph.setTitleTextCl(Color.BLACK);
        populationGraph.setScaleTextCl(Color.BLACK);
        populationGraph.setTextSize(8);
        populationGraph.setInteger(true);

        this.timeGraphs.add(populationGraph);


        ScaleSynchronizer populationScaleSynchronizer = new ScaleSynchronizer();

        TimeGraph populationArea0Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        populationArea0Graph.setTitle("Area population");
        populationArea0Graph.setOrigin(App.ORIGINX + App.DEFX, graphDimY + 5);
        populationArea0Graph.setPlainCl(new Color(0, 0, 0, 0));
        populationArea0Graph.setBorderCl(new Color(100, 100, 100));
        populationArea0Graph.setDotCl(App.PROPERTY_AREA_COLORS[0]);
        populationArea0Graph.setLineCl(App.PROPERTY_AREA_COLORS[0]);
        populationArea0Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[0]);
        populationArea0Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[0]);
        populationArea0Graph.setScaleTextCl(Color.WHITE);
        populationArea0Graph.setTitleTextCl(Color.WHITE);
        populationArea0Graph.setTextSize(8);
        populationArea0Graph.setInteger(true);
        populationArea0Graph.setScaleSynchronizer(populationScaleSynchronizer);


        TimeGraph populationArea1Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        populationArea1Graph.setTitle("");
        populationArea1Graph.setOrigin(App.ORIGINX + App.DEFX, graphDimY + 5);
        populationArea1Graph.setPlainCl(new Color(0, 0, 0, 0));
        populationArea1Graph.setBorderCl(new Color(100, 100, 100));
        populationArea1Graph.setDotCl(App.PROPERTY_AREA_COLORS[1]);
        populationArea1Graph.setLineCl(App.PROPERTY_AREA_COLORS[1]);
        populationArea1Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[1]);
        populationArea1Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[1]);
        populationArea1Graph.setTextSize(8);
        populationArea1Graph.setRenderScale(false);
        populationArea1Graph.setRenderTitle(false);
        populationArea1Graph.setInteger(true);
        populationArea1Graph.setScaleSynchronizer(populationScaleSynchronizer);

        TimeGraph populationArea2Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        populationArea2Graph.setTitle("");
        populationArea2Graph.setOrigin(App.ORIGINX + App.DEFX, graphDimY + 5);
        populationArea2Graph.setPlainCl(new Color(0, 0, 0, 0));
        populationArea2Graph.setBorderCl(new Color(100, 100, 100));
        populationArea2Graph.setDotCl(App.PROPERTY_AREA_COLORS[2]);
        populationArea2Graph.setLineCl(App.PROPERTY_AREA_COLORS[2]);
        populationArea2Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[2]);
        populationArea2Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[2]);
        populationArea2Graph.setTextSize(8);
        populationArea2Graph.setRenderScale(false);
        populationArea2Graph.setRenderTitle(false);
        populationArea2Graph.setInteger(true);
        populationArea2Graph.setScaleSynchronizer(populationScaleSynchronizer);

        TimeGraph populationArea3Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        populationArea3Graph.setTitle("");
        populationArea3Graph.setOrigin(App.ORIGINX + App.DEFX, graphDimY + 5);
        populationArea3Graph.setPlainCl(new Color(0, 0, 0, 0));
        populationArea3Graph.setBorderCl(new Color(100, 100, 100));
        populationArea3Graph.setDotCl(App.PROPERTY_AREA_COLORS[3]);
        populationArea3Graph.setLineCl(App.PROPERTY_AREA_COLORS[3]);
        populationArea3Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[3]);
        populationArea3Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[3]);
        populationArea3Graph.setTextSize(8);
        populationArea3Graph.setRenderScale(false);
        populationArea3Graph.setRenderTitle(false);
        populationArea3Graph.setInteger(true);
        populationArea3Graph.setScaleSynchronizer(populationScaleSynchronizer);

        populationScaleSynchronizer.addGraph(populationArea0Graph);
        populationScaleSynchronizer.addGraph(populationArea1Graph);
        populationScaleSynchronizer.addGraph(populationArea2Graph);
        populationScaleSynchronizer.addGraph(populationArea3Graph);

        this.timeGraphs.add(populationArea0Graph);
        this.timeGraphs.add(populationArea1Graph);
        this.timeGraphs.add(populationArea2Graph);
        this.timeGraphs.add(populationArea3Graph);

        ScaleSynchronizer energyDensityScaleSynchronizer = new ScaleSynchronizer();

        TimeGraph energyDensityArea0Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        energyDensityArea0Graph.setTitle("Area energy density");
        energyDensityArea0Graph.setOrigin(App.ORIGINX + App.DEFX, 2 * graphDimY + 5);
        energyDensityArea0Graph.setPlainCl(new Color(0, 0, 0, 0));
        energyDensityArea0Graph.setBorderCl(new Color(100, 100, 100));
        energyDensityArea0Graph.setDotCl(App.PROPERTY_AREA_COLORS[0]);
        energyDensityArea0Graph.setLineCl(App.PROPERTY_AREA_COLORS[0]);
        energyDensityArea0Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[0]);
        energyDensityArea0Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[0]);
        energyDensityArea0Graph.setScaleTextCl(Color.WHITE);
        energyDensityArea0Graph.setTitleTextCl(Color.WHITE);
        energyDensityArea0Graph.setTextSize(8);
        energyDensityArea0Graph.setScaleSynchronizer(energyDensityScaleSynchronizer);

        TimeGraph energyDensityArea1Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        energyDensityArea1Graph.setTitle("");
        energyDensityArea1Graph.setOrigin(App.ORIGINX + App.DEFX, 2 * graphDimY + 5);
        energyDensityArea1Graph.setPlainCl(new Color(0, 0, 0, 0));
        energyDensityArea1Graph.setBorderCl(new Color(100, 100, 100));
        energyDensityArea1Graph.setDotCl(App.PROPERTY_AREA_COLORS[1]);
        energyDensityArea1Graph.setLineCl(App.PROPERTY_AREA_COLORS[1]);
        energyDensityArea1Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[1]);
        energyDensityArea1Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[1]);
        energyDensityArea1Graph.setTextSize(8);
        energyDensityArea1Graph.setRenderScale(false);
        energyDensityArea1Graph.setRenderTitle(false);
        energyDensityArea1Graph.setScaleSynchronizer(energyDensityScaleSynchronizer);

        TimeGraph energyDensityArea2Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        energyDensityArea2Graph.setTitle("");
        energyDensityArea2Graph.setOrigin(App.ORIGINX + App.DEFX, 2 * graphDimY + 5);
        energyDensityArea2Graph.setPlainCl(new Color(0, 0, 0, 0));
        energyDensityArea2Graph.setBorderCl(new Color(100, 100, 100));
        energyDensityArea2Graph.setDotCl(App.PROPERTY_AREA_COLORS[2]);
        energyDensityArea2Graph.setLineCl(App.PROPERTY_AREA_COLORS[2]);
        energyDensityArea2Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[2]);
        energyDensityArea2Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[2]);
        energyDensityArea2Graph.setTextSize(8);
        energyDensityArea2Graph.setRenderScale(false);
        energyDensityArea2Graph.setRenderTitle(false);
        energyDensityArea2Graph.setScaleSynchronizer(energyDensityScaleSynchronizer);

        TimeGraph energyDensityArea3Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        energyDensityArea3Graph.setTitle("");
        energyDensityArea3Graph.setOrigin(App.ORIGINX + App.DEFX, 2 * graphDimY + 5);
        energyDensityArea3Graph.setPlainCl(new Color(0, 0, 0, 0));
        energyDensityArea3Graph.setBorderCl(new Color(100, 100, 100));
        energyDensityArea3Graph.setDotCl(App.PROPERTY_AREA_COLORS[3]);
        energyDensityArea3Graph.setLineCl(App.PROPERTY_AREA_COLORS[3]);
        energyDensityArea3Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[3]);
        energyDensityArea3Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[3]);
        energyDensityArea3Graph.setTextSize(8);
        energyDensityArea3Graph.setRenderScale(false);
        energyDensityArea3Graph.setRenderTitle(false);
        energyDensityArea3Graph.setScaleSynchronizer(energyDensityScaleSynchronizer);

        energyDensityScaleSynchronizer.addGraph(energyDensityArea0Graph);
        energyDensityScaleSynchronizer.addGraph(energyDensityArea1Graph);
        energyDensityScaleSynchronizer.addGraph(energyDensityArea2Graph);
        energyDensityScaleSynchronizer.addGraph(energyDensityArea3Graph);

        this.timeGraphs.add(energyDensityArea0Graph);
        this.timeGraphs.add(energyDensityArea1Graph);
        this.timeGraphs.add(energyDensityArea2Graph);
        this.timeGraphs.add(energyDensityArea3Graph);

        ScaleSynchronizer packScaleSynchronizer = new ScaleSynchronizer();

        TimeGraph packArea0Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        packArea0Graph.setTitle("Area pack count");
        packArea0Graph.setOrigin(App.ORIGINX + App.DEFX, 3 * graphDimY + 5);
        packArea0Graph.setPlainCl(new Color(0, 0, 0, 0));
        packArea0Graph.setBorderCl(new Color(100, 100, 100));
        packArea0Graph.setDotCl(App.PROPERTY_AREA_COLORS[0]);
        packArea0Graph.setLineCl(App.PROPERTY_AREA_COLORS[0]);
        packArea0Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[0]);
        packArea0Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[0]);
        packArea0Graph.setScaleTextCl(Color.WHITE);
        packArea0Graph.setTitleTextCl(Color.WHITE);
        packArea0Graph.setTextSize(8);
        packArea0Graph.setScaleSynchronizer(packScaleSynchronizer);

        TimeGraph packArea1Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        packArea1Graph.setTitle("");
        packArea1Graph.setOrigin(App.ORIGINX + App.DEFX, 3 * graphDimY + 5);
        packArea1Graph.setPlainCl(new Color(0, 0, 0, 0));
        packArea1Graph.setBorderCl(new Color(100, 100, 100));
        packArea1Graph.setDotCl(App.PROPERTY_AREA_COLORS[1]);
        packArea1Graph.setLineCl(App.PROPERTY_AREA_COLORS[1]);
        packArea1Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[1]);
        packArea1Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[1]);
        packArea1Graph.setTextSize(8);
        packArea1Graph.setRenderScale(false);
        packArea1Graph.setRenderTitle(false);
        packArea1Graph.setScaleSynchronizer(packScaleSynchronizer);

        TimeGraph packArea2Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        packArea2Graph.setTitle("");
        packArea2Graph.setOrigin(App.ORIGINX + App.DEFX, 3 * graphDimY + 5);
        packArea2Graph.setPlainCl(new Color(0, 0, 0, 0));
        packArea2Graph.setBorderCl(new Color(100, 100, 100));
        packArea2Graph.setDotCl(App.PROPERTY_AREA_COLORS[2]);
        packArea2Graph.setLineCl(App.PROPERTY_AREA_COLORS[2]);
        packArea2Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[2]);
        packArea2Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[2]);
        packArea2Graph.setTextSize(8);
        packArea2Graph.setRenderScale(false);
        packArea2Graph.setRenderTitle(false);
        packArea2Graph.setScaleSynchronizer(packScaleSynchronizer);

        packScaleSynchronizer.addGraph(packArea0Graph);
        packScaleSynchronizer.addGraph(packArea1Graph);
        packScaleSynchronizer.addGraph(packArea2Graph);

        this.timeGraphs.add(packArea0Graph);
        this.timeGraphs.add(packArea1Graph);
        this.timeGraphs.add(packArea2Graph);

        ScaleSynchronizer resourceScaleSynchronizer = new ScaleSynchronizer();

        TimeGraph resourceArea0Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        resourceArea0Graph.setTitle("Area resource");
        resourceArea0Graph.setOrigin(App.ORIGINX + App.DEFX, 4 * graphDimY + 5);
        resourceArea0Graph.setPlainCl(new Color(0, 0, 0, 0));
        resourceArea0Graph.setBorderCl(new Color(100, 100, 100));
        resourceArea0Graph.setDotCl(App.PROPERTY_AREA_COLORS[0]);
        resourceArea0Graph.setLineCl(App.PROPERTY_AREA_COLORS[0]);
        resourceArea0Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[0]);
        resourceArea0Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[0]);
        resourceArea0Graph.setScaleTextCl(Color.WHITE);
        resourceArea0Graph.setTitleTextCl(Color.WHITE);
        resourceArea0Graph.setTextSize(8);
        resourceArea0Graph.setScaleSynchronizer(resourceScaleSynchronizer);

        TimeGraph resourceArea1Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        resourceArea1Graph.setTitle("");
        resourceArea1Graph.setOrigin(App.ORIGINX + App.DEFX, 4 * graphDimY + 5);
        resourceArea1Graph.setPlainCl(new Color(0, 0, 0, 0));
        resourceArea1Graph.setBorderCl(new Color(100, 100, 100));
        resourceArea1Graph.setDotCl(App.PROPERTY_AREA_COLORS[1]);
        resourceArea1Graph.setLineCl(App.PROPERTY_AREA_COLORS[1]);
        resourceArea1Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[1]);
        resourceArea1Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[1]);
        resourceArea1Graph.setTextSize(8);
        resourceArea1Graph.setRenderScale(false);
        resourceArea1Graph.setRenderTitle(false);
        resourceArea1Graph.setScaleSynchronizer(resourceScaleSynchronizer);

        TimeGraph resourceArea2Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        resourceArea2Graph.setTitle("");
        resourceArea2Graph.setOrigin(App.ORIGINX + App.DEFX, 4 * graphDimY + 5);
        resourceArea2Graph.setPlainCl(new Color(0, 0, 0, 0));
        resourceArea2Graph.setBorderCl(new Color(100, 100, 100));
        resourceArea2Graph.setDotCl(App.PROPERTY_AREA_COLORS[2]);
        resourceArea2Graph.setLineCl(App.PROPERTY_AREA_COLORS[2]);
        resourceArea2Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[2]);
        resourceArea2Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[2]);
        resourceArea2Graph.setTextSize(8);
        resourceArea2Graph.setRenderScale(false);
        resourceArea2Graph.setRenderTitle(false);
        resourceArea2Graph.setScaleSynchronizer(resourceScaleSynchronizer);

        TimeGraph resourceArea3Graph = new TimeGraph(graphDimX * 2, graphDimY, graphCapacity);
        resourceArea3Graph.setTitle("");
        resourceArea3Graph.setOrigin(App.ORIGINX + App.DEFX, 4 * graphDimY + 5);
        resourceArea3Graph.setPlainCl(new Color(0, 0, 0, 0));
        resourceArea3Graph.setBorderCl(new Color(100, 100, 100));
        resourceArea3Graph.setDotCl(App.PROPERTY_AREA_COLORS[3]);
        resourceArea3Graph.setLineCl(App.PROPERTY_AREA_COLORS[3]);
        resourceArea3Graph.setLevelLineCl(App.PROPERTY_AREA_COLORS[3]);
        resourceArea3Graph.setValueTextCl(App.PROPERTY_AREA_COLORS[3]);
        resourceArea3Graph.setTextSize(8);
        resourceArea3Graph.setRenderScale(false);
        resourceArea3Graph.setRenderTitle(false);
        resourceArea3Graph.setScaleSynchronizer(resourceScaleSynchronizer);

        resourceScaleSynchronizer.addGraph(resourceArea0Graph);
        resourceScaleSynchronizer.addGraph(resourceArea1Graph);
        resourceScaleSynchronizer.addGraph(resourceArea2Graph);
        resourceScaleSynchronizer.addGraph(resourceArea3Graph);

        this.timeGraphs.add(resourceArea0Graph);
        this.timeGraphs.add(resourceArea1Graph);
        this.timeGraphs.add(resourceArea2Graph);
        this.timeGraphs.add(resourceArea3Graph);
    }

    void observeAviaryData() {
        this.aviaryData = aviaryReference.getDataInAreas();
    }

    void addGraphData() {
        if(this.timeGraphCtr > 0) {
            this.timeGraphCtr--;
        }
        else {
            observeAviaryData();

            this.timeGraphs.get(0).addValue(aviaryReference.getPopulation());
            this.timeGraphs.get(1).addValue(aviaryData[0][0]);
            this.timeGraphs.get(2).addValue(aviaryData[0][1]);
            this.timeGraphs.get(3).addValue(aviaryData[0][2]);
            this.timeGraphs.get(4).addValue(aviaryData[0][3]);

            if (aviaryData[0][0] != 0) this.timeGraphs.get(5).addValue(aviaryData[1][0] / aviaryData[0][0]);
            else this.timeGraphs.get(5).addValue(0);
            if (aviaryData[0][1] != 0) this.timeGraphs.get(6).addValue(aviaryData[1][1] / aviaryData[0][1]);
            else this.timeGraphs.get(6).addValue(0);
            if (aviaryData[0][2] != 0) this.timeGraphs.get(7).addValue(aviaryData[1][2] / aviaryData[0][2]);
            else this.timeGraphs.get(7).addValue(0);
            if (aviaryData[0][3] != 0) this.timeGraphs.get(8).addValue(aviaryData[1][3] / aviaryData[0][3]);
            else this.timeGraphs.get(8).addValue(0);

            this.timeGraphs.get(9).addValue(aviaryData[2][0]);
            this.timeGraphs.get(10).addValue(aviaryData[2][1]);
            this.timeGraphs.get(11).addValue(aviaryData[2][2]);

            this.timeGraphs.get(12).addValue(aviaryData[3][0]);
            this.timeGraphs.get(13).addValue(aviaryData[3][1]);
            this.timeGraphs.get(14).addValue(aviaryData[3][2]);
            this.timeGraphs.get(15).addValue(aviaryData[3][3]);

            resetTimeGraphCtr();
        }
    }

    String formTimeStampDataFileName(){
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy_MM_dd__HH_mm_ss");
        Date currentTimeStamp = new Date();
        String timeStampFileName = "report_" + sdfDate.format(currentTimeStamp);

        return timeStampFileName;
    }

    String formTimeStampParametersFileName(){
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy_MM_dd__HH_mm_ss");
        Date currentTimeStamp = new Date();
        String timeStamp = sdfDate.format(currentTimeStamp);
        String timeStampFileName = "parameters_" + timeStamp;
        this.startTimeStamp = timeStamp;

        return timeStampFileName;
    }

    String formParameterReportString(){
        String reportStr =
                "_____ Parameter Values _____\n\n" +

                        "++++ Aviary Sizes ++++:\n" +
                        "DEFX = " + App.DEFX + "\n" +
                        "DEFY = " + App.DEFY + "\n\n" +

                        "+ Resourse Parameters +:\n" +
                        "QUADX = " + App.QUADX + "\n" +
                        "QUADY = " + App.QUADY + "\n" +
                        "PLAINX = " + App.PLAINX + "\n" +
                        "PLAINY = " + App.PLAINY + "\n" +
                        "SHIFTINTERSECTIONMODE = " + App.SHIFTINTERSECTION + "\n" +
                        "LOCKEDAREAS = " + App.LOCKEDAREAS + "\n" +
                        "PAYMENT = " + App.PAYMENT + "\n" +
                        "PAYMENTRATIO = " + App.PAYMENTRATIO + "\n" +

                        "RESOURCETYPE = " + App.RESTYPE + "\n" +
                        "BASERES = " + App.BASERES + "\n" +
                        "RESREPSPEED = " + App.RESREPSPEED + "\n" +
                        "RESPERQUAD = " + App.RESPERQUAD + "\n" +
                        "RESREPCTRPEAK = " + App.RESREPCTRPEAK + "\n\n" +

                        "++ Agent Parameters ++:\n" +
                        "Initial Agent Spawn:\n" +
                        "INITAGENTAMOUNT1 = " + App.INITAGENTAMOUNT1 + "\n" +
                        "INITAGENTAMOUNT2 = " + App.INITAGENTAMOUNT2 + "\n" +
                        "SYSSPAWN = " + App.SYSSPAWN + "\n\n" +

                        "Speed:\n" +
                        "BASESPEED1 = " + App.BASESPEED1 + "\n" +
                        "BASESPEED2 = " + App.BASESPEED2 + "\n" +
                        "SPEEDAGECOEFF = " + App.SPEEDAGECOEFF + "\n\n" +

                        "Age:\n" +
                        "BASEMAXAGE = " + App.BASEMAXAGE + "\n" +
                        "AGEPERSTEP = " + App.AGEPERSTEP + "\n\n" +

                        "Energy:\n" +
                        "SUFFENERGY = " + App.SUFFENERGY + "\n" +
                        "MAXENERGY = " + App.MAXENERGY + "\n" +
                        "NRGPERSTEP1 = " + App.NRGPERSTEP1 + "\n" +
                        "NRGPERSTEP2 = " + App.NRGPERSTEP2 + "\n\n" +

                        "Valences:\n" +
                        "VALENCE1 = " + App.VALENCE1 + "\n" +
                        "VALENCE2 = " + App.VALENCE2 + "\n\n" +

                        "Resorce Collection:\n" +
                        "RESECOLLECTEDPERSTEP = " + App.RESECOLLECTEDPERSTEP + "\n\n" +

                        "Reproduction:\n" +
                        "REPRODUCTLOW = " + App.REPRODUCTLOW + "\n" +
                        "REPRODUCTHIGH = " + App.REPRODUCTHIGH + "\n" +
                        "REPRODUCTPROB1 = " + App.REPRODUCTPROB1 + "\n" +
                        "REPRODUCTPROB2 = " + App.REPRODUCTPROB2 + "\n" +
                        "REPRODUCTCOST = " + App.REPRODUCTCOST + "\n\n" +

                        "Fights:\n" +
                        "NRGPERFIGHT = " + App.NRGPERFIGHT + "\n\n" +

                        "Packs:\n" +
                        "NRGFORCONPERSTEP = " + App.NRGFORCONPERSTEP + "\n\n";

        return reportStr;
    }

    void parameterReport() {
        String parametersReportStr =
                "======================================================\n" +
                        "===================== Parameters =====================\n" +
                        "======================================================\n\n" +
                        formParameterReportString();

        File parameterReportFile = new File("reports\\" + this.parameterReportFileName + ".txt");

        if (!parameterReportFile.exists()) {
            try {
                parameterReportFile.createNewFile();
            }
            catch (IOException e) {
                System.out.println(e);
            }
        }

        try {
            this.fw = new FileWriter(parameterReportFile);
            this.bw = new BufferedWriter(this.fw);
            this.pw = new PrintWriter(this.bw);

            pw.write(parametersReportStr);

            this.pw.close();
            this.bw.close();
            this.fw.close();
        }
        catch (IOException e) {
            System.out.println(e);
        }
    }

    void writeDataHeaders() {
        this.reportFile = new File("reports\\" + this.dataReportFileName + ".csv");

        if (!this.reportFile.exists()) {
            try {
                this.reportFile.createNewFile();
            }
            catch (IOException e) {
                System.out.println(e);
            }
        }

        String dataHeadersString;
        StringBuilder stringBuilder = new StringBuilder();

        for (Iterator<String> iterator = this.reportDataHeaders.iterator(); iterator.hasNext();) {
            stringBuilder.append(iterator.next());
            if (iterator.hasNext()) stringBuilder.append(", ");
            else stringBuilder.append("\n");
        }

        dataHeadersString = stringBuilder.toString();

        try {
            this.fw = new FileWriter(this.reportFile, true);
            this.bw = new BufferedWriter(this.fw);
            this.pw = new PrintWriter(this.bw);

            pw.write(dataHeadersString);

            this.pw.close();
            this.bw.close();
            this.fw.close();
        }
        catch (IOException e) {
            System.out.println(e);
        }
    }

    void reportRow() {
        if(this.reportCtr > 0) {
            this.reportCtr--;
        }
        else {
            String reportString;
            StringBuilder stringBuilder = new StringBuilder();
            observeAviaryData();
            stringBuilder.append(aviaryReference.getPopulation()).append(", ");
            stringBuilder.append(aviaryData[0][0]).append(", ");
            stringBuilder.append(aviaryData[0][1]).append(", ");
            stringBuilder.append(aviaryData[0][2]).append(", ");
            stringBuilder.append(aviaryData[0][3]).append(", ");
            stringBuilder.append(aviaryData[1][0] / aviaryData[0][0]).append(", ");
            stringBuilder.append(aviaryData[1][1] / aviaryData[0][1]).append(", ");
            stringBuilder.append(aviaryData[1][2] / aviaryData[0][2]).append(", ");
            stringBuilder.append(aviaryData[1][3] / aviaryData[0][3]).append(", ");
            stringBuilder.append(aviaryData[2][0]).append(", ");
            stringBuilder.append(aviaryData[2][1]).append(", ");
            stringBuilder.append(aviaryData[2][2]).append(", ");
            stringBuilder.append(aviaryData[3][0]).append(", ");
            stringBuilder.append(aviaryData[3][1]).append(", ");
            stringBuilder.append(aviaryData[3][2]).append(", ");
            stringBuilder.append(aviaryData[3][3]).append("\n");

            reportString = stringBuilder.toString();

            try {
                this.fw = new FileWriter(this.reportFile, true);
                this.bw = new BufferedWriter(this.fw);
                this.pw = new PrintWriter(this.bw);

                pw.write(reportString);

                this.pw.close();
                this.bw.close();
                this.fw.close();
            }
            catch (IOException e) {
                System.out.println(e.toString());
            }

            resetReportCtr();
            this.reportRowCtr++;
        }
    }

    String formFinalReportString() {
        String finalReportString;
        StringBuilder stringBuilder = new StringBuilder();
        observeAviaryData();
        stringBuilder.append(startTimeStamp).append("  ");
        stringBuilder.append("Base resource ").append(App.BASERES).append("  ");
        stringBuilder.append("Resource replenishment speed multiplier ").append(App.RESREPSPEEDMULTIPLIER).append("\n");
        stringBuilder.append(aviaryData[0][0]).append(", ");
        stringBuilder.append(aviaryData[0][1]).append(", ");
        stringBuilder.append(aviaryData[0][2]).append(", ");
        stringBuilder.append(aviaryData[0][3]).append("\n\n\n");

        finalReportString = stringBuilder.toString();
        return finalReportString;
    }

    void finalReport() {
        observeAviaryData();
        String finalReportString = formFinalReportString();

        File finalReportFile = new File("reports\\" + "FinalReports.txt");

        if (!finalReportFile.exists()) {
            try {
                finalReportFile.createNewFile();
            }
            catch (IOException e) {
                System.out.println(e);
            }
        }


        try {
            this.fw = new FileWriter(finalReportFile, true);
            this.bw = new BufferedWriter(this.fw);
            this.pw = new PrintWriter(this.bw);

            pw.write(finalReportString);

            this.pw.close();
            this.bw.close();
            this.fw.close();
        }
        catch (IOException e) {
            System.out.println(e.toString());
        }
    }

    //---------------------------------
    //---------------------------------

    //-----------------------------------
    //-----------  Renderers  -----------
    //-----------------------------------

    void render() {
        this.timeGraphs.forEach((timeGraph) -> timeGraph.render());
    }

    //-----------------------------------
    //-----------------------------------


}
