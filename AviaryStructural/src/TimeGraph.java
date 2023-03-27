import java.awt.*;
import java.util.ArrayList;
import java.util.Iterator;

public class TimeGraph {
    public static enum Mode {
        SCROLLING, STATIONARY
    }

    private int originX;
    private int originY;

    private int dimX;
    private int dimY;

    private int capacity;

    private boolean filled;

    private Mode mode;

    private ArrayList<Dot> dots;

    private double maxY;
    private double minY;

    //Colors

    Color plainCl;
    Color borderCl;
    Color dotCl;
    Color lineCl;
    Color levelLineCl;
    Color valueTextCl;


    //--------------------------------------
    //-----------  Constructors  -----------
    //---------------------------------------

    TimeGraph() {
        this.originX = 0;
        this.originY = 0;
        this.dimX = 200;
        this.dimY = 100;
        this.capacity = 0;
        this.mode = Mode.SCROLLING;
        this.dots = new ArrayList<Dot>();
        this.maxY = 0;
        this.minY = 0;
    }

    TimeGraph(int capacity) {
        this();
        this.capacity = capacity;
    }

    TimeGraph(int dimX, int dimY, int capacity) {
        this(capacity);
        this.dimX = dimX;
        this.dimY = dimY;
    }

    TimeGraph(int dimX, int dimY, int capacity, Mode mode) {
        this(dimX, dimY, capacity);
        this.mode = mode;
    }

    //---------------------------------------
    //---------------------------------------

    //---------------------------------
    //-----------  Getters  -----------
    //---------------------------------

    int getDimX() { return this.dimX; }
    int getDimY() { return this.dimY; }

    int getCapacity() { return this.capacity; }

    boolean filled() { return this.filled; }

    ArrayList<Dot> getDots() { return this.dots; }

    double getValue(int index) {
        if(index < 0 || index >= this.dots.size()) {
            return 0;
        }

        return this.dots.get(index).getY();
    }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Setters  -----------
    //---------------------------------

    void setOriginX(int originX) { this.originX = originX; }
    void setOriginY(int originY) { this.originY = originY; }

    void setOrigin(int originX, int originY) {
        this.originX = originX;
        this.originY = originY;
    }

    void setDimX(int dimX) { this.dimX = dimX; }
    void setDimY(int dimY) { this.dimY = dimY; }

    void setCapacity(int capacity) { this.capacity = capacity; }

    void setMode(int Mode) { this.mode = mode; }

    //---------------------------------
    //---------------------------------

    //---------------------------------
    //-----------  Methods  -----------
    //---------------------------------

    void addValue(double val) {

        Dot newDot = new Dot(App.processingRef.millis() / 1000, val);

        if(filled) {
            if(mode == Mode.STATIONARY) return;
            else if(mode == Mode.SCROLLING) removeFirstDot();
        }

        this.dots.add(newDot);

        if(this.dots.size() == capacity) filled = true;

        if(this.maxY < val) this.maxY = val;
        if(this.minY > val) this.minY = val;
    }

    void removeFirstDot() {
        Dot firstDot = this.dots.get(0);
        double firstY = firstDot.getY();
        this.dots.remove(0);
        if(firstY == this.minY) updateMinY();
        if(firstY == this.maxY) updateMaxY();
    }

    void updateMinY() {
        double newMinY = this.maxY;

        for (Iterator<Dot> iter = this.dots.iterator(); iter.hasNext();){
            Dot dot = iter.next();
            double y = dot.getY();
            if(y < newMinY) newMinY = y;
        }

        this.minY = newMinY;
    }

    void updateMaxY() {
        double newMaxY = this.minY;

        for (Iterator<Dot> iter = this.dots.iterator(); iter.hasNext();){
            Dot dot = iter.next();
            double y = dot.getY();
            if(y > newMaxY) newMaxY = y;
        }

        this.maxY = newMaxY;
    }

    Dot calcAbsCoordinates(int index) {
        Dot dot = this.dots.get(index);
        double absoluteX = this.originX + this.dimX * (dot.getX() / this.dots.get(this.dots.size() - 1).getX());
        double absoluteY = this.originY + this.dimY * (1 - 0.8 * dot.getY() / (this.maxY - this.minY));
        return new Dot(absoluteX, absoluteY);
    }



    //---------------------------------
    //---------------------------------

    //-----------------------------------
    //-----------  Renderers  -----------
    //-----------------------------------

  /*
  color plainCl;
  color borderCl;
  color dotCl;
  color lineCl;
  color levelLineCl;
  color valueTextCl;
  */

    void renderPlain() {
        App.processingRef.strokeWeight(1);
        App.processingRef.stroke(this.borderCl.getRGB());
        App.processingRef.fill(this.plainCl.getRGB());
        App.processingRef.rect(this.originX, this.originY, this.dimX, this.dimY);
    }

    void renderDotsLine() {
        int maxX = App.processingRef.millis();

        Dot absoluteCoordinates;
        Dot previousAbsoluteCoordinates = null;

        for(int dotIdx = 0; dotIdx < this.dots.size(); dotIdx++) {
            Dot dot = this.dots.get(dotIdx);
            absoluteCoordinates = calcAbsCoordinates(dotIdx);

            App.processingRef.strokeWeight(1);
            App.processingRef.stroke(this.dotCl.getRGB());
            App.processingRef.fill(this.dotCl.getRGB());
            App.processingRef.circle((float)absoluteCoordinates.getX(), (float)absoluteCoordinates.getY(), 2);

            if(dotIdx != 0) {
                App.processingRef.strokeWeight(1);
                App.processingRef.stroke(this.lineCl.getRGB());

                App.processingRef.line((float)previousAbsoluteCoordinates.getX(), (float)previousAbsoluteCoordinates.getY(),
                        (float)absoluteCoordinates.getX(), (float)absoluteCoordinates.getY());
            }

            previousAbsoluteCoordinates.setXY(absoluteCoordinates);
        }
    }

    void renderLevelLine() {
        Dot lastDot = this.dots.get(this.dots.size() - 1);
        Dot lastAbsoluteCoordinates = calcAbsCoordinates(this.dots.size() - 1);

        App.processingRef.strokeWeight(1);
        App.processingRef.stroke(this.levelLineCl.getRGB(), 130);

        App.processingRef.line(this.originX, (float)lastAbsoluteCoordinates.getY(),
                (float)lastAbsoluteCoordinates.getX(), (float)lastAbsoluteCoordinates.getY());
    }

    void renderLastDotValue() {
        Dot lastAbsoluteCoordinates = calcAbsCoordinates(this.dots.size() - 1);

        App.processingRef.fill(valueTextCl.getRGB());
        App.processingRef.textSize(8);
        App.processingRef.text((int)(lastAbsoluteCoordinates.getX()), (float)(this.originX + 5), (float)(lastAbsoluteCoordinates.getY() - 7));
    }

    void renderAxisScale() {
        App.processingRef.fill(valueTextCl.getRGB());
        App.processingRef.textSize(8);
        App.processingRef.text(App.processingRef.millis()/1000, this.originX + this.dimX - 30, this.originY + this.dimY - 4);
        App.processingRef.text((int)(this.maxY * 1.25), this.originX + 5, this.originY + 10);
    }

    void render() {
        renderPlain();
        renderDotsLine();
        renderLevelLine();
        renderLastDotValue();
        renderAxisScale();
    }

    //-----------------------------------
    //-----------------------------------
}
