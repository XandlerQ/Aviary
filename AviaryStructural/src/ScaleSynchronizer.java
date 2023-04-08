import java.util.ArrayList;

public class ScaleSynchronizer {
    ArrayList<TimeGraph> syncedGraphs;

    ScaleSynchronizer() {
        this.syncedGraphs = new ArrayList<>();
    }

    void addGraph(TimeGraph timeGraph) {
        this.syncedGraphs.add(timeGraph);
    }

    void syncScale() {

    }
}
