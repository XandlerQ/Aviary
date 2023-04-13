import java.awt.*;
import java.util.ArrayList;
import java.util.Iterator;

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

    void setIntersection(Dot dot) {
        if (this.propertyAreas.size() != 4) return;

        this.propertyAreas.get(0).setSideX(dot.getX());
        this.propertyAreas.get(0).setSideY(dot.getY());

        this.propertyAreas.get(1).setOriginY(dot.getY());
        this.propertyAreas.get(1).setSideX(dot.getX());
        this.propertyAreas.get(1).setSideY(this.defY - dot.getY());

        this.propertyAreas.get(2).setOriginX(dot.getX());
        this.propertyAreas.get(2).setSideX(this.defX - dot.getX());
        this.propertyAreas.get(2).setSideY(dot.getY());

        this.propertyAreas.get(3).setOriginX(dot.getX());
        this.propertyAreas.get(3).setOriginY(dot.getY());
        this.propertyAreas.get(3).setSideX(this.defX - dot.getX());
        this.propertyAreas.get(3).setSideY(this.defY - dot.getY());
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

    PropertyArea<Property> getPropertyArea(int propertyAreaIndex) {
        return this.propertyAreas.get(propertyAreaIndex);
    }

    int getPropertyAreaIndex(double x, double y) {
        if(x < 0) x = 0;
        if(y < 0) y = 0;

        if(x > this.defX) x = this.defX;
        if(y > this.defY) y = this.defY;

        int index = 0;

        for(Iterator<PropertyArea<Property>> iterator = this.propertyAreas.iterator(); iterator.hasNext();) {
            PropertyArea<Property> propertyArea = iterator.next();
            if(propertyArea.inArea(x, y)) break;
            else index++;
        }
        if(index >= 4) return 0;
        return index;
    }

    int getPropertyAreaIndex(Dot coordinates) {
        return getPropertyAreaIndex(coordinates.getX(), coordinates.getY());
    }

    PropertyArea<Property> getPropertyArea(double x, double y) {
        return this.propertyAreas.get(getPropertyAreaIndex(x, y));
    }

    PropertyArea<Property> getPropertyArea(Dot coordinates) {
        return this.propertyAreas.get(getPropertyAreaIndex(coordinates));
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
