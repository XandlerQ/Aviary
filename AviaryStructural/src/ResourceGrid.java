import java.awt.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Random;

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
    public Resource getResourceAtIndex(int index) {
        if (index < 0 || index >= this.resources.size()) return null;
        return this.resources.get(index);
    }

    public Resource getResourceAtCell(int i, int j) {
        if (i < 0 || i >= this.grCtX ||
        j < 0 || j >= this.grCtY) {
            return null;
        }
        return this.resources.get(i * this.grCtY + j);
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

    double getGradientDirectionIntersection(Dot dot, Dot intersection) {
        double gradientDirection;

        double sideX = this.defX / this.grCtX;
        double sideY = this.defY / this.grCtY;

        double x = dot.getX();
        double y = dot.getY();

        int iDot = (int)(x / sideX);
        int jDot = (int)(y / sideY);

        int iIntersection = (int)(intersection.getX() / sideX);
        int jIntersection = (int)(intersection.getY() / sideY);

        int areaIndex;

        if (iDot <= iIntersection) {
            if (jDot <= jIntersection) areaIndex = 0;
            else areaIndex = 1;
        }
        else {
            if (jDot <= jIntersection) areaIndex = 2;
            else areaIndex = 3;
        }

        int iSpan = App.GRADIENTREFINEMENT;
        int jSpan = App.GRADIENTREFINEMENT;

        int iOrigin = 0,
                jOrigin = 0,
                iTarget = 0,
                jTarget = 0;

        switch (areaIndex) {
            case 0 -> {
                iOrigin = Math.max(0, iDot - iSpan);
                jOrigin = Math.max(0, jDot - jSpan);

                iTarget = Math.min(iDot + iSpan, iIntersection - 1);
                jTarget = Math.min(jDot + jSpan, jIntersection - 1);
            }
            case 1 -> {
                iOrigin = Math.max(0, iDot - iSpan);
                jOrigin = Math.max(jIntersection + 1, jDot - jSpan);

                iTarget = Math.min(iDot + iSpan, iIntersection - 1);
                jTarget = Math.min(jDot + jSpan, this.grCtY - 1);
            }
            case 2 -> {
                iOrigin = Math.max(iIntersection + 1, iDot - iSpan);
                jOrigin = Math.max(0, jDot - jSpan);

                iTarget = Math.min(iDot + iSpan, this.grCtX - 1);
                jTarget = Math.min(jDot + jSpan, jIntersection - 1);
            }
            case 3 -> {
                iOrigin = Math.max(iIntersection + 1, iDot - iSpan);
                jOrigin = Math.max(jIntersection + 1, jDot - jSpan);

                iTarget = Math.min(iDot + iSpan, this.grCtX - 1);
                jTarget = Math.min(jDot + jSpan, this.grCtY - 1);
            }
        }


        double resLeft = 0,
                resRight = 0,
                resTop = 0,
                resBottom = 0;

        for (int i = iOrigin; i < iDot; i++) {
            for (int j = jOrigin; j <= jTarget; j++) {
                resLeft += getResourceAtCell(i, j).getRes()
                        / ((double)Math.abs(i - iDot) / iSpan + (double)Math.abs(j - jDot) / jSpan + 1);
            }
        }

        for (int i = iDot + 1; i <= iTarget; i++) {
            for (int j = jOrigin; j <= jTarget; j++) {
                resRight += getResourceAtCell(i, j).getRes()
                        / ((double)Math.abs(i - iDot) / iSpan + (double)Math.abs(j - jDot) / jSpan + 1);
            }
        }

        for (int i = iOrigin; i <= iTarget; i++) {
            for (int j = jOrigin; j < jDot; j++) {
                resTop += getResourceAtCell(i, j).getRes()
                        / ((double)Math.abs(i - iDot) / iSpan + (double)Math.abs(j - jDot) / jSpan + 1);
            }
        }

        for (int i = iOrigin; i <= iTarget; i++) {
            for (int j = jDot + 1; j <= jTarget; j++) {
                resBottom += getResourceAtCell(i, j).getRes()
                        / ((double)Math.abs(i - iDot) / iSpan + (double)Math.abs(j - jDot) / jSpan + 1);
            }
        }

        double shiftX = resRight - resLeft;
        double shiftY = resBottom - resTop;

        if (Math.abs(shiftX) <= 2 * App.BASERES) shiftX = 0;
        if (Math.abs(shiftY) <= 2 * App.BASERES) shiftY = 0;

        if (shiftX == 0 && shiftY == 0) return -1;

        Dot gradientDot = new Dot(dot.getX() + shiftX, dot.getY() + shiftY);

        gradientDirection = Direction.directionFromTo(dot, gradientDot);

        return gradientDirection;
    }

    double getGradientDirection(Dot dot) {
        double gradientDirection;

        double sideX = this.defX / this.grCtX;
        double sideY = this.defY / this.grCtY;

        double x = dot.getX();
        double y = dot.getY();

        int iDot = (int)(x / sideX);
        int jDot = (int)(y / sideY);

        int iSpan = App.GRADIENTREFINEMENT;
        int jSpan = App.GRADIENTREFINEMENT;

        int iOrigin = Math.max(0, iDot - iSpan);
        int jOrigin = Math.max(0, jDot - jSpan);

        int iTarget = Math.min(this.grCtX - 1, iDot + iSpan);
        int jTarget = Math.min(this.grCtY - 1, jDot + jSpan);

        double resLeft = 0,
                resRight = 0,
                resTop = 0,
                resBottom = 0;

        for (int i = iOrigin; i < iDot; i++) {
            for (int j = jOrigin; j <= jTarget; j++) {
                resLeft += getResourceAtCell(i, j).getRes()
                        / ((double)Math.abs(i - iDot) / iSpan + (double)Math.abs(j - jDot) / jSpan + 1);
            }
        }

        for (int i = iDot + 1; i <= iTarget; i++) {
            for (int j = jOrigin; j <= jTarget; j++) {
                resRight += getResourceAtCell(i, j).getRes()
                        / ((double)Math.abs(i - iDot) / iSpan + (double)Math.abs(j - jDot) / jSpan + 1);
            }
        }

        for (int i = iOrigin; i <= iTarget; i++) {
            for (int j = jOrigin; j < jDot; j++) {
                resTop += getResourceAtCell(i, j).getRes()
                        / ((double)Math.abs(i - iDot) / iSpan + (double)Math.abs(j - jDot) / jSpan + 1);
            }
        }

        for (int i = iOrigin; i <= iTarget; i++) {
            for (int j = jDot + 1; j <= jTarget; j++) {
                resBottom += getResourceAtCell(i, j).getRes()
                        / ((double)Math.abs(i - iDot) / iSpan + (double)Math.abs(j - jDot) / jSpan + 1);
            }
        }

        double shiftX = resRight - resLeft;
        double shiftY = resBottom - resTop;

        if (Math.abs(shiftX) <= 2 * App.BASERES) shiftX = 0;
        if (Math.abs(shiftY) <= 2 * App.BASERES) shiftY = 0;

        if (shiftX == 0 && shiftY == 0) return -1;

        Dot gradientDot = new Dot(dot.getX() + shiftX, dot.getY() + shiftY);

        gradientDirection = Direction.directionFromTo(dot, gradientDot);

        return gradientDirection;
    }

    double[] getResourceInAreas(PropertyGrid propertyGrid) {
        double[] resourceInAres = new double[4];

        for (int i = 0; i < 4; i++) {
            resourceInAres[i] = 0;
        }

        double sideX = this.defX / this.grCtX;
        double sideY = this.defY / this.grCtY;
        int index = 0;
        for (Iterator<Resource> iterator = this.resources.iterator(); iterator.hasNext();) {
            Resource resource = iterator.next();
            float alpha = (float)(resource.getRes() / resource.getMaxRes());
            App.processingRef.stroke(STD_RES_COLOR.getRGB(), 0);
            App.processingRef.fill(STD_RES_COLOR.getRGB(), 255 * alpha / 4);

            int j = index % this.grCtY;
            int i = (index - j) / this.grCtY;

            double originX = i * sideX + App.ORIGINX;
            double originY = j * sideY + App.ORIGINY;

            double centerX = originX + sideX / 2;
            double centerY = originY + sideY / 2;

            resourceInAres[propertyGrid.getPropertyAreaIndex(centerX, centerY)] += resource.getRes();

            index++;
        }

        return resourceInAres;
    }

    double resourceWithdraw(Dot dot, double amount) {
        double sideX = this.defX / this.grCtX;
        double sideY = this.defY / this.grCtY;

        double x = dot.getX();
        double y = dot.getY();

        int iDot = (int)((x - x % sideX) / sideX);
        int jDot = (int)((y - y % sideY) / sideY);

        Resource resource = getResourceAtCell(iDot, jDot);
        return resource.lowerRes(amount);
    }

    //---------------------------------
    //---------------------------------

    //-----------------------------------
    //-----------  Renderers  -----------
    //-----------------------------------

    void render() {
        double sideX = this.defX / this.grCtX;
        double sideY = this.defY / this.grCtY;
        int index = 0;
        for (Iterator<Resource> iterator = this.resources.iterator(); iterator.hasNext();) {
            Resource res = iterator.next();
            float alpha = (float)(res.getRes() / res.getMaxRes());
            App.processingRef.stroke(STD_RES_COLOR.getRGB(), 0);
            App.processingRef.fill(STD_RES_COLOR.getRGB(), 255 * alpha / 4);

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
