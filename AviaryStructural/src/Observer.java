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
import java.util.ArrayList;

public class Observer {

    Aviary aviaryReference;
    ArrayList<TimeGraph> timeGraphs;
    int timeGraphCtr;
    int timeGraphCtrPeak;

    //Data

    int population;

    int areaCount;
    int valuesPerArea;
    double[][] areaDataValues;

//    int populationArea0;
//    int populationArea1;
//    int populationArea2;
//    int populationArea3;
//    double resourceArea0;
//    double resourceArea1;
//    double resourceArea2;
//    double resourceArea3;
//    double energyArea0;
//    double energyArea1;
//    double energyArea2;
//    double energyArea3;
//    double energyDensityArea0;
//    double energyDensityArea1;
//    double energyDensityArea2;
//    double energyDensityArea3;

    //--------------------------------------
    //-----------  Constructors  -----------
    //--------------------------------------

    Observer() {
        this.aviaryReference = null;
        this.timeGraphs = null;
        this.timeGraphCtr = 0;
        this.timeGraphCtrPeak = App.INFOREPCTRPEAK - 1;
        this.areaCount = 0;
        this.valuesPerArea = 0;
        this.areaDataValues = null;
    }

    Observer(Aviary aviaryReference) {
        this();
        this.aviaryReference = aviaryReference;
        this.timeGraphs = new ArrayList<>();
    }

    Observer(Aviary aviaryReference, int areaCount, int valuesPerArea) {
        this(aviaryReference);
        this.areaCount = areaCount;
        this.valuesPerArea = valuesPerArea;
        this.areaDataValues = new double[areaCount][valuesPerArea];
    }

    //--------------------------------------
    //--------------------------------------

    //---------------------------------
    //-----------  Getters  -----------
    //---------------------------------

    public Aviary getAviaryReference() {
        return aviaryReference;
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Setters  -----------
    //---------------------------------

    public void setAviaryReference(Aviary aviaryReference) {
        this.aviaryReference = aviaryReference;
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Methods  -----------
    //---------------------------------

    void resetTimeGraphCtr() {
        this.timeGraphCtr = this.timeGraphCtrPeak;
    }

    void fillTimeGraphs() {
        int graphDimX = 495;
        int graphDimY = 300;
        int graphCapacity = 198;

        TimeGraph populationGraph = new TimeGraph(graphDimX, graphDimY, graphCapacity);
        populationGraph.setTitle("Population");
        populationGraph.setOrigin(App.ORIGINX + App.DEFX, 5);
        populationGraph.setPlainCl(new Color(0, 0, 0, 0));
        populationGraph.setBorderCl(new Color(100, 100, 100));
        populationGraph.setDotCl(Color.RED);
        populationGraph.setLineCl(Color.RED);
        populationGraph.setLevelLineCl(Color.YELLOW);
        populationGraph.setValueTextCl(Color.WHITE);
        populationGraph.setTitleTextCl(Color.WHITE);
        populationGraph.setScaleTextCl(Color.WHITE);
        populationGraph.setTextSize(8);

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
    }

    void addGraphData() {
        if(this.timeGraphCtr > 0) {
            this.timeGraphCtr--;
        }
        else {
            this.timeGraphs.get(0).addValue(aviaryReference.getPopulation());
            double areaData[][] = aviaryReference.getDataInAreas();
            this.timeGraphs.get(1).addValue(areaData[0][0]);
            this.timeGraphs.get(2).addValue(areaData[0][1]);
            this.timeGraphs.get(3).addValue(areaData[0][2]);
            this.timeGraphs.get(4).addValue(areaData[0][3]);

            this.timeGraphs.get(5).addValue(areaData[1][0] / areaData[0][0]);
            this.timeGraphs.get(6).addValue(areaData[1][1] / areaData[0][1]);
            this.timeGraphs.get(7).addValue(areaData[1][2] / areaData[0][2]);
            this.timeGraphs.get(8).addValue(areaData[1][3] / areaData[0][3]);

            this.timeGraphs.get(9).addValue(areaData[2][0]);
            this.timeGraphs.get(10).addValue(areaData[2][1]);
            this.timeGraphs.get(11).addValue(areaData[2][2]);

            resetTimeGraphCtr();
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
