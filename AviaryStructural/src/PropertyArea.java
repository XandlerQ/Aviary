import java.awt.*;

public class PropertyArea<Property> {
    public static enum PropertyType {
        VALENCE
    }

    private double originX;
    private double originY;
    private double sideX;
    private double sideY;
    private PropertyType propertyType;
    private Property property;

    private Color color;

    //--------------------------------------
    //-----------  Constructors  -----------
    //---------------------------------------

    PropertyArea() {
        this.originX = 0;
        this.originY = 0;
        this.sideX = 0;
        this.sideY = 0;
        this.propertyType = PropertyType.VALENCE;
        this.color = null;
    }

    PropertyArea(double originX, double originY, double sideX, double sideY) {
        this.originX = originX;
        this.originY = originY;
        this.sideX = sideX;
        this.sideY = sideY;
        this.propertyType = PropertyType.VALENCE;
        this.color = null;
    }

    //---------------------------------------
    //---------------------------------------

    //---------------------------------
    //-----------  Getters  -----------
    //---------------------------------

    public double getOriginX() {
        return originX;
    }

    public double getOriginY() {
        return originY;
    }

    public double getSideX() {
        return sideX;
    }

    public double getSideY() {
        return sideY;
    }

    public PropertyType getPropertyType() {
        return propertyType;
    }

    public Property getProperty() {
        return property;
    }

    public Color getColor() {
        return color;
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Setters  -----------
    //---------------------------------

    public void setOriginX(double originX) {
        this.originX = originX;
    }

    public void setOriginY(double originY) {
        this.originY = originY;
    }

    public void setSideX(double sideX) {
        this.sideX = sideX;
    }

    public void setSideY(double sideY) {
        this.sideY = sideY;
    }

    public void setPropertyType(PropertyType propertyType) {
        this.propertyType = propertyType;
    }

    public void setProperty(Property property) {
        this.property = property;
    }

    public void setColor(Color color) {
        this.color = color;
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Methods  -----------
    //---------------------------------

    boolean inArea(double x, double y) {
        return x >= this.originX && x <= this.originX + this.sideX &&
                y >= this.originY && y <= this.originY + this.sideY;
    }

    boolean inArea(Dot coordinates) {
        return this.inArea(coordinates.getX(), coordinates.getY());
    }

    boolean inArea(Agent agent) {
        return inArea(agent.getCoordinates());
    }

    //---------------------------------
    //---------------------------------

    //-----------------------------------
    //-----------  Renderers  -----------
    //-----------------------------------

    void render() {
        App.processingRef.fill(color.getRGB(), 25);
        App.processingRef.stroke(color.getRGB(), 50);
        App.processingRef.strokeWeight(2);
        App.processingRef.rect((float)(App.ORIGINX + this.originX), (float)(App.ORIGINY + this.originY), (float)(this.sideX), (float)(this.sideY));
    }

    //-----------------------------------
    //-----------------------------------


}
