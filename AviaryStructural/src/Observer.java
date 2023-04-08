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
    int getTimeGraphCtrPeak;

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
        this.getTimeGraphCtrPeak = App.INFOREPCTRPEAK - 1;
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
        this.timeGraphCtr = this.getTimeGraphCtrPeak;
    }

    void fillTimeGraphs() {
        int graphDimX = 500;
        int graphDimY = 400;
        int graphCapacity = 500;

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



    }

    void addGraphData() {
        if(this.timeGraphCtr > 0) {
            this.timeGraphCtr--;
        }
        else {
            this.timeGraphs.get(0).addValue(aviaryReference.getPopulation());
            int areaPopulation[] = aviaryReference.getPoplationInAreas();
            this.timeGraphs.get(1).addValue(areaPopulation[0]);
            this.timeGraphs.get(2).addValue(areaPopulation[1]);
            this.timeGraphs.get(3).addValue(areaPopulation[2]);
            this.timeGraphs.get(4).addValue(areaPopulation[3]);

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
