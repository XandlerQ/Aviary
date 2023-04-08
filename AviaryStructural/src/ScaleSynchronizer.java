import java.util.ArrayList;
import java.util.Iterator;

public class ScaleSynchronizer {
    ArrayList<TimeGraph> syncedGraphs;

    ScaleSynchronizer() {
        this.syncedGraphs = new ArrayList<>();
    }

    void addGraph(TimeGraph timeGraph) {
        this.syncedGraphs.add(timeGraph);
    }

    void syncScale() {
        double maxY = 0;
        double minY = Double.MAX_VALUE;

        for(Iterator<TimeGraph> iter = syncedGraphs.iterator(); iter.hasNext();) {
            TimeGraph timeGraph = iter.next();
            double graphMinY = timeGraph.getMinY();
            double graphMaxY = timeGraph.getMaxY();
            if(maxY < graphMaxY) {
                maxY = graphMaxY;
            }
            if(minY > graphMinY) {
                minY = graphMinY;
            }
        }

        for(Iterator<TimeGraph> iter = syncedGraphs.iterator(); iter.hasNext();) {
            TimeGraph timeGraph = iter.next();
            timeGraph.setMaxY(maxY);
            timeGraph.setMinY(minY);
        }
    }
}
