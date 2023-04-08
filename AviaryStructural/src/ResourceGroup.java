import java.awt.*;
import java.util.ArrayList;
import java.util.Random;

public class ResourceGroup {

    Color STD_RES_GR_NET_COLOR = new Color(255, 170, 0);

    private double defX;  //Group dimension along X axis
    private double defY;  //Group dimension along Y axis
    private int grCtX;  //Amount of areas along X axis
    private int grCtY;  //Amount of areas along Y axis
    private double sideX;  //Area dimension along X axis
    private double sideY;  //Area dimension along Y axis

    private int density;  //Amount of resource nodes in area
    private ArrayList<ResourceNode> resNodes;  //Resource nodes
    private int resCount;

    //--------------------------------------
    //-----------  Constructors  -----------
    //---------------------------------------

    ResourceGroup() {
        this.defX = 0;
        this.defY = 0;
        this.grCtX = 0;
        this.grCtY = 0;
        this.sideX = 0;
        this.sideY = 0;

        this.density = 0;
        this.resNodes = null;
        this.resCount = 0;
    }

    ResourceGroup(double defX, double defY, int grCtX, int grCtY, int density) {
        this.defX = defX;
        this.defY = defY;
        this.grCtX = grCtX;
        this.grCtY = grCtY;
        this.sideX = defX / grCtX;
        this.sideY = defY / grCtY;

        this.density = density;
        this.resCount = grCtX * grCtY * density;

        this.resNodes = new ArrayList<ResourceNode> (this.resCount);
        //ResourceNode(double maxRes, double fraction, double resRepSpeed, int repCtrPeak,
        //           Dot coordinates) {
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

    public double getSideX() {
        return sideX;
    }

    public double getSideY() {
        return sideY;
    }

    public ArrayList<ResourceNode> getResNodes() {
        return resNodes;
    }

    public int getDensity() {
        return density;
    }

    public int getResCount() {
        return resCount;
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Setters  -----------
    //---------------------------------


    void setNodesMaxRes(double maxRes){
        this.resNodes.forEach((node) -> {node.setMaxRes(maxRes);});
    }

    void setNodesResRepSpeed(double resRepSpeed){
        this.resNodes.forEach((node) -> {node.setResRepSpeed(resRepSpeed);});
    }

    void setNodesRepCtrPeak(int repCtrPeak){
        this.resNodes.forEach((node) -> {node.setRepCtrPeak(repCtrPeak);});
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Methods  -----------
    //---------------------------------

    Dot getRndCoordInArea(double origX, double origY, double sideX, double sideY) {
        Random r = new Random();
        Dot coordinates = new Dot();
        coordinates.setX(origX + sideX/20 + (18 * sideX / 20) * r.nextDouble());
        coordinates.setY(origY + sideY/20 + (18 * sideY / 20) * r.nextDouble());
        return coordinates;
    }

    void fillResNodes(double maxRes, double fraction, double resRepSpeed, int repCtrPeak) {
        for(int i = 0; i < grCtX; i++){
            for(int j = 0; j < grCtY; j++){
                for (int k = 0; k < density; k++){
                    this.resNodes.add(
                            new ResourceNode(
                                    maxRes,
                                    fraction,
                                    resRepSpeed,
                                    repCtrPeak,
                                    getRndCoordInArea(i * sideX, j * sideY, sideX, sideY)
                            )
                    );
                }
            }
        }
    }

    void replenishNodes(){
        this.resNodes.forEach((node) -> {node.replenish();});
    }

    ArrayList<ResourceNode> getVisibleResNodes(double x, double y, double radius){

        if(x < 0) x = 0;
        if(y < 0) y = 0;

        if(x > this.defX) x = this.defX;
        if(y > this.defY) y = this.defY;

        int posQuadX = 0;
        posQuadX = (int)((x - (x % this.sideX)) / this.sideX);
        if(posQuadX >= this.grCtX) posQuadX = this.grCtX - 1;
        int posQuadY = 0;
        posQuadY = (int)((y - (y % this.sideY)) / this.sideY);
        if(posQuadY >= this.grCtY) posQuadY = this.grCtY - 1;

        int moreL = 0;
        int moreR = 0;
        int moreT = 0;
        int moreB = 0;

        double radiusOverlapL = posQuadX * this.sideX - (x - radius);
        double radiusOverlapR = (x + radius) - (posQuadX + 1) * this.sideX;
        double radiusOverlapT = posQuadY * this.sideY - (y - radius);
        double radiusOverlapB = (y + radius) - (posQuadY + 1) * this.sideY;

        int quadLeftL = posQuadX;
        int quadLeftR = this.grCtX - (posQuadX + 1);
        int quadLeftT = posQuadY;
        int quadLeftB = this.grCtY - (posQuadY + 1);

        if(radiusOverlapL > 0){
            moreL = (int)((radiusOverlapL - radiusOverlapL % this.sideX) / this.sideX) + 1;
            if(moreL > quadLeftL){
                moreL = quadLeftL;
            }
        }
        if(radiusOverlapR > 0){
            moreR = (int)((radiusOverlapR - radiusOverlapR % this.sideX) / this.sideX) + 1;
            if(moreR > quadLeftR){
                moreR = quadLeftR;
            }
        }
        if(radiusOverlapT > 0){
            moreT = (int)((radiusOverlapT - radiusOverlapT % this.sideY) / this.sideY) + 1;
            if(moreT > quadLeftT){
                moreT = quadLeftT;
            }
        }
        if(radiusOverlapB > 0){
            moreB = (int)((radiusOverlapB - radiusOverlapB % this.sideY) / this.sideY) + 1;
            if(moreB > quadLeftB){
                moreB = quadLeftB;
            }
        }

        ArrayList<ResourceNode> visibleResNodes = new ArrayList<>();

        for(int i = posQuadX - moreL; i <= posQuadX + moreR; i++){
            for(int j = posQuadY - moreT; j <= posQuadY + moreB; j++){
                for(int k = 0; k < this.density; k++){
                    visibleResNodes.add(this.resNodes.get(i * this.grCtY * this.density + j * this.density + k));
                }
            }
        }

        return visibleResNodes;
    }

    //---------------------------------
    //---------------------------------

    //-----------------------------------
    //-----------  Renderers  -----------
    //-----------------------------------

    void render()
    {
        this.resNodes.forEach((node) -> {node.render();});
        App.processingRef.stroke(STD_RES_GR_NET_COLOR.getRGB(), 100);
        App.processingRef.strokeWeight(2);
        for(int i = 0; i < this.grCtX + 1; i++){
            App.processingRef.line(App.ORIGINX + (float)(i * this.sideX), App.ORIGINY,
                    App.ORIGINX + (float)(i * this.sideX), App.ORIGINY + (float)(this.defY));
        }
        for(int j = 0; j < this.grCtY + 1; j++){
            App.processingRef.line(App.ORIGINX, App.ORIGINY + (float)(j * this.sideY),
                    App.ORIGINX + (float)(this.defX), App.ORIGINY + (float)(j * this.sideY));
        }
    }

    //-----------------------------------
    //-----------------------------------



}
