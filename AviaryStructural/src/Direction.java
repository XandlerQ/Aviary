import processing.core.PApplet;

import java.util.ArrayList;
import java.util.Random;

public class Direction {
    static double directionAddition(double dir1, double dir2){
        double resDir = -1;
        double x1, y1, x2, y2;
        x1 = Math.cos(dir1);
        y1 = Math.sin(dir1);
        x2 = Math.cos(dir2);
        y2 = Math.sin(dir2);

        double xres, yres;

        xres = x1 + x2;
        yres = y1 + y2;

        double module = Math.sqrt((xres * xres) + (yres * yres));

        if (module == 0){
            Random r = new Random();
            resDir = (2 * Math.PI * r.nextDouble());
        }
        else{
            xres /= module;
            yres /= module;
            resDir = Math.acos(xres);
            if(yres < 0)
                resDir = 2 * Math.PI - resDir;
        }
        return resDir;
    }

    static double directionAddition(ArrayList<Double> dirs){
        double resDir = -1;

        if(dirs.size() == 0)
            return resDir;

        if(dirs.size() == 1){
            resDir = dirs.get(0);
            return resDir;
        }

        ArrayList<Double> xi = new ArrayList<>(dirs.size());
        ArrayList<Double> yi = new ArrayList<>(dirs.size());

        dirs.forEach((dir) -> {
            xi.add(Math.cos(dir));
            yi.add(Math.sin(dir));
        });

        double xres = 0, yres = 0;

        for (int i = 0; i < xi.size(); i++){
            xres += xi.get(i);
            yres += yi.get(i);
        }

        double module = Math.sqrt((xres * xres) + (yres * yres));

        if (module == 0){
            Random r = new Random();
            resDir = (2 * Math.PI * r.nextDouble());
        }
        else{
            xres /= module;
            yres /= module;
            resDir = Math.acos(xres);
            if(yres < 0)
                resDir = 2 * Math.PI - resDir;
        }
        return resDir;
    }

    static double normalizeDirection(double argDir){
        double dir = argDir;
        while(dir < 0){
            dir += 2 * Math.PI;
        }
        while(dir >= 2 * Math.PI){
            dir -= 2 * Math.PI;
        }
        return dir;
    }

    static double directionFromTo(Dot from, Dot to) {
        double distance = Dot.distanceBetween(from, to);

        if(distance == 0) {
            return -1;
        }

        double direction = Math.acos((to.getX() - from.getX()) / distance);
        if(to.getY() > from.getY()) return direction;
        else return 2 * Math.PI - direction;
    }
}
