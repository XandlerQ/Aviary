import java.awt.*;
import java.util.ArrayList;

public class PropertyGrid<Property> {

    private double defX;
    private double defY;
    private int grCtX;
    private int grCtY;

    private double sideX;
    private double sideY;

    ArrayList<PropertyArea<Property>> propertyAreas;

    //--------------------------------------
    //-----------  Constructors  -----------
    //--------------------------------------


    PropertyGrid() {
        this.defX = 0;
        this.defY = 0;
        this.grCtX = 0;
        this.grCtY = 0;
        this.sideX = 0;
        this.sideY = 0;
        this.propertyAreas = null;
    }

    PropertyGrid(double defX, double defY, int grCtX, int grCtY) {
        this.defX = defX;
        this.defY = defY;
        this.grCtX = grCtX;
        this.grCtY = grCtY;
        this.sideX = defX / grCtX;
        this.sideY = defY / grCtY;
        this.propertyAreas = new ArrayList<>(grCtX * grCtY);
    }

    //--------------------------------------
    //--------------------------------------

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

    public ArrayList<PropertyArea<Property>> getPropertyAreas() {
        return propertyAreas;
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Setters  -----------
    //---------------------------------

    public void setDefX(double defX) {
        this.defX = defX;
        recalculateSideX();
    }

    public void setDefY(double defY) {
        this.defY = defY;
        recalculateSideY();
    }

    public void setGrCtX(int grCtX) {
        this.grCtX = grCtX;
        recalculateSideX();
    }

    public void setGrCtY(int grCtY) {
        this.grCtY = grCtY;
        recalculateSideY();
    }

    //---------------------------------

    void recalculateSideX() {
        this.sideX = this.defX / this.grCtX;
    }

    void recalculateSideY() {
        this.sideY = this.defY / this.grCtY;
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Methods  -----------
    //---------------------------------

    void fillPropertyAreas(Property[] propertyAreasValues, Color[] propertyAreasColors) {
        for (int i = 0; i < this.grCtX; i++) {
            for (int j = 0; j < this.grCtY; j++) {
                PropertyArea<Property> propertyArea = new PropertyArea<>(i * this.sideX, j * this.sideY, this.sideX, this.sideY);
                propertyArea.setProperty(propertyAreasValues[i * this.grCtY + j]);
                propertyArea.setColor(propertyAreasColors[i * this.grCtY + j]);
                this.propertyAreas.add(propertyArea);
            }
        }
    }

    PropertyArea<Property> getPropertyArea(double x, double y) {
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

        return this.propertyAreas.get(posQuadX * this.grCtY + posQuadY);
    }

    PropertyArea<Property> getPropertyArea(Dot coordinates) {
        return getPropertyArea(coordinates.getX(), coordinates.getY());
    }

    Property getProperty(double x, double y) {
        return getPropertyArea(x, y).getProperty();
    }

    Property getProperty(Dot coordinates) {
        return getProperty(coordinates.getX(), coordinates.getY());
    }

    //---------------------------------
    //---------------------------------

    //-----------------------------------
    //-----------  Renderers  -----------
    //-----------------------------------

    void render() {
        this.propertyAreas.forEach((area) -> {
            area.render();
        });
    }

    //-----------------------------------
    //-----------------------------------

}
