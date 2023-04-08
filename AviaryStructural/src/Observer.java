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
        TimeGraph pop1Gr = new TimeGraph(500, 400, 500);
        pop1Gr.setTitle("Population");
        pop1Gr.setOrigin(App.ORIGINX + App.DEFX, 5);
        pop1Gr.setPlainCl(new Color(0, 0, 0));
        pop1Gr.setBorderCl(new Color(100, 100, 100));
        pop1Gr.setDotCl(Color.RED);
        pop1Gr.setLineCl(Color.RED);
        pop1Gr.setLevelLineCl(Color.YELLOW);
        pop1Gr.setValueTextCl(Color.WHITE);
        pop1Gr.setTextSize(8);

        this.timeGraphs.add(pop1Gr);
    }

    void addGraphData() {
        if(this.timeGraphCtr > 0) {
            this.timeGraphCtr--;
        }
        else {
            this.timeGraphs.get(0).addValue(aviaryReference.getPopulation());
            this.timeGraphCtr = this.getTimeGraphCtrPeak;
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
