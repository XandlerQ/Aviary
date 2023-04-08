import java.awt.*;
import java.util.concurrent.atomic.AtomicInteger;
public class ResourceNode extends Resource {

    Color STD_RESNODE_COLOR = new Color(255, 170, 0);
    double STD_RESNODE_SIZE = 20;
    static AtomicInteger resIdGen = new AtomicInteger(0);
    private final int id;
    private Dot coordinates;
    private double size;
    private Color cl;

    //--------------------------------------
    //-----------  Constructors  -----------
    //---------------------------------------

    ResourceNode() {
        super();
        this.id = resIdGen.incrementAndGet();
        this.coordinates = null;
        this.size = 0;
        this.cl = STD_RESNODE_COLOR;
    }

    ResourceNode(double maxRes, double fraction, double resRepSpeed, int repCtrPeak,
                 double x, double y) {
        super(maxRes, fraction, resRepSpeed, repCtrPeak);
        this.id = resIdGen.incrementAndGet();
        this.coordinates = new Dot(x, y);
        this.size = STD_RESNODE_SIZE * super.res / super.maxRes;
        this.cl = STD_RESNODE_COLOR;
    }

    ResourceNode(double maxRes, double fraction, double resRepSpeed, int repCtrPeak,
                 Dot coordinates) {
        this(maxRes, fraction, resRepSpeed, repCtrPeak, coordinates.getX(), coordinates.getY());
    }

    //---------------------------------------
    //---------------------------------------

    //---------------------------------
    //-----------  Getters  -----------
    //---------------------------------

    int getId() {
        return this.id;
    }

    double getX() {
        return this.coordinates.getX();
    }

    double getY() {
        return this.coordinates.getY();
    }

    Dot getCoordinates() {
        return this.coordinates;
    }

    double getSize() {
        return this.size;
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Setters  -----------
    //---------------------------------

    void setCoordinates(double x, double y) {
        this.coordinates.setXY(x, y);
    }

    void setColor(Color cl) {
        this.cl = cl;
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Methods  -----------
    //---------------------------------

    void recalculateSize() {
        this.size = STD_RESNODE_SIZE * this.res / this.maxRes;
    }

    @Override
    public boolean equals(Object obj){
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        ResourceNode arg = (ResourceNode) obj;
        return this.id == arg.getId();
    }

    //---------------------------------
    //---------------------------------

    //-----------------------------------
    //-----------  Renderers  -----------
    //-----------------------------------


    void render(){
        recalculateSize();
        App.processingRef.noStroke();
        App.processingRef.fill(cl.getRGB(), 255);
        App.processingRef.circle(App.ORIGINX + (float)this.coordinates.getX(), App.ORIGINY + (float)this.coordinates.getY(), 2);
        App.processingRef.fill(cl.getRGB(), 150);
        App.processingRef.circle(App.ORIGINX + (float)this.coordinates.getX(), App.ORIGINY + (float)this.coordinates.getY(), (float)size);
    }

    //-----------------------------------
    //-----------------------------------
}
