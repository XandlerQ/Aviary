import java.awt.*;
import java.util.ArrayList;
import java.util.Iterator;

public class ResourceGrid {

    Color STD_RES_COLOR = new Color(255, 170, 0);

    private double defX;
    private double defY;
    private int grCtX;
    private int grCtY;
    private ArrayList<Resource> resources;
    private int resCount;

    //--------------------------------------
    //-----------  Constructors  -----------
    //---------------------------------------

    ResourceGrid() {
        this.defX = 0;
        this.defY = 0;
        this.grCtX = 0;
        this.grCtY = 0;
        this.resources = null;
    }

    ResourceGrid(double defX, double defY, int grCtX, int grCtY) {
        this.defX = defX;
        this.defY = defY;
        this.grCtX = grCtX;
        this.grCtY = grCtY;
        this.resCount = grCtX * grCtY;
        this.resources = new ArrayList<>(this.resCount);
    }

    //---------------------------------------
    //---------------------------------------

    //---------------------------------
    //-----------  Getters  -----------
    //---------------------------------

    public double getDefX() {
        return defX;
    }

    public double getDefY() {
        return defY;
    }

    public int getGrCtX() {
        return grCtX;
    }

    public int getGrCtY() {
        return grCtY;
    }

    public int getResCount() {
        return resCount;
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Setters  -----------
    //---------------------------------

    void setMaxRes(double maxRes){
        this.resources.forEach((res) -> {res.setMaxRes(maxRes);});
    }

    void setResRepSpeed(double resRepSpeed){
        this.resources.forEach((res) -> {res.setResRepSpeed(resRepSpeed);});
    }

    void setRepCtrPeak(int repCtrPeak){
        this.resources.forEach((res) -> {res.setRepCtrPeak(repCtrPeak);});
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Methods  -----------
    //---------------------------------

    void fillResources(double maxRes, double fraction, double resRepSpeed, int repCtrPeak) {
        for(int i = 0; i < this.grCtX; i++) {
            for (int j = 0; j < this.grCtY; j++) {
                this.resources.add(
                        new Resource(
                                maxRes,
                                fraction,
                                resRepSpeed,
                                repCtrPeak
                        )
                );
            }
        }
    }

    void replenish(){
        this.resources.forEach((res) -> {res.replenish();});
    }

    //---------------------------------
    //---------------------------------

    //-----------------------------------
    //-----------  Renderers  -----------
    //-----------------------------------

    void render() {
        int index = 0;
        for (Iterator<Resource> iterator = this.resources.iterator(); iterator.hasNext();) {
            Resource res = iterator.next();
            float alpha = (float)(res.getRes() / res.getMaxRes());
            App.processingRef.stroke(STD_RES_COLOR.getRGB(), 255 * alpha / 4);
            App.processingRef.fill(STD_RES_COLOR.getRGB(), 255 * alpha / 4);
            double sideX = this.defX / this.grCtX;
            double sideY = this.defY / this.grCtY;
            int j = index % this.grCtY;
            int i = (index - j) / this.grCtY;

            double originX = i * sideX + App.ORIGINX;
            double originY = j * sideY + App.ORIGINY;

            App.processingRef.rect((float)originX, (float)originY, (float)sideX, (float)sideY);
            index++;
        }
    }

    //-----------------------------------
    //-----------------------------------
}
