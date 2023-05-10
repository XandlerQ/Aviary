import processing.core.PApplet;

public class Dot {
    private double x;
    private double y;

    Dot() {
        this.x = 0;
        this.y = 0;
    }

    Dot(double x, double y) {
        this.x = x;
        this.y = y;
    }

    Dot(Dot other) {
        this.x = other.x;
        this.y = other.y;
    }

    public double getX() { return this.x; }
    public double getY() { return this.y; }

    public void setX(double x) { this.x = x; }
    public void setY(double y) { this.y = y; }
    public void setXY(double x, double y) { setX(x); setY(y); }
    public void setXY(Dot other) { setX(other.getX()); setY(other.getY()); }

    public static double distanceBetween(Dot dot1, Dot dot2) {
        return Math.sqrt(
                (dot1.getX() - dot2.getX()) * (dot1.getX() - dot2.getX())
                        + (dot1.getY() - dot2.getY()) * (dot1.getY() - dot2.getY())
        );
    }


    @Override
    public boolean equals(Object obj){
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        Dot arg = (Dot) obj;
        return (arg.getX() == this.x && arg.getY() == this.y);
    }
}
