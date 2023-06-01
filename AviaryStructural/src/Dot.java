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
    public Dot vectorTo (Dot dot) {
        return new Dot(dot.getX() - this.x, dot.getY() - this.y);
    }

    public Dot addToThis (Dot dot) {
        this.x = this.x + dot.getX();
        this.y = this.y + dot.getY();
        return this;
    }

    public Dot add (Dot dot) {
        return new Dot(this.x + dot.getX(), this.y + dot.getY());
    }

    public Dot normalizeThis () {
        double length = Math.sqrt(this.x * this.x + this.y * this.y);
        if(length != 0) {
            this.x /= length;
            this.y /= length;
        }
        return this;
    }

    public Dot normalize() {
        double length = Math.sqrt(this.x * this.x + this.y * this.y);
        if (length != 0) return new Dot(this.x / length, this.y / length);
        return new Dot();
    }

    public Dot multiplyThis (double value) {
        this.x *= value;
        this.y += value;
        return this;
    }

    public Dot multiply (double value) {
        return new Dot(this.x * value, this.y * value);
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
