import java.util.ArrayList;
import java.util.Random;

public class Builder {

    public static ArrayList<Agent> buildAgentArray() {
        ArrayList<Agent> agents = new ArrayList<>(App.INITAGENTAMOUNT1 + App.INITAGENTAMOUNT2);

        Random r = new Random();
        if (!App.REGIONSPECIFIC) {
            for (int i = 0; i < App.INITAGENTAMOUNT1; i++) {
                agents.add(buildAgent(0, 0, 0, App.DEFX, App.DEFY));
            }

            for (int i = 0; i < App.INITAGENTAMOUNT2; i++) {
                agents.add(buildAgent(1, 0, 0, App.DEFX, App.DEFY));
            }
        }
        else {
            int agentsPerRegion1 = App.INITAGENTAMOUNT1 / 4;
            int agentsPerRegion2 = App.INITAGENTAMOUNT2 / 4;
            for (int i = 0; i < agentsPerRegion1; i++) {
                agents.add(buildAgent(0, 0, 0, App.DEFX / 2, App.DEFY / 2));
            }
            for (int i = 0; i < agentsPerRegion1; i++) {
                agents.add(buildAgent(0, 0, App.DEFY / 2, App.DEFX / 2, App.DEFY / 2));
            }
            for (int i = 0; i < agentsPerRegion1; i++) {
                agents.add(buildAgent(0, App.DEFX / 2, 0, App.DEFX / 2, App.DEFY / 2));
            }
            for (int i = 0; i < agentsPerRegion1; i++) {
                agents.add(buildAgent(0, App.DEFX / 2, App.DEFY / 2, App.DEFX / 2, App.DEFY / 2));
            }
        }

        return agents;
    }

    public static Agent buildAgent(int species, double originX, double originY, double sideX, double sideY) {
        Random r = new Random();

        Agent ag = new Agent();
        ag.setSpecies(species);
        if (species == 1) {
            if (App.SYSSPAWN) ag.setCoordinates(originX + sideX / 20 + (9 * sideX / 20) * r.nextDouble(),
                    originY + sideY / 20 + (9 * sideY / 10) * r.nextFloat()
            );
            else ag.setCoordinates(originX + sideX / 20 + (9 * sideX / 10) * r.nextDouble(),
                    originY + sideY / 20 + (9 * sideY / 10) * r.nextFloat()
            );
        } else {
            if (App.SYSSPAWN) ag.setCoordinates(originX + 19 * sideX / 20 - (9 * sideX / 20) * r.nextDouble(),
                    originY + sideY / 20 + (9 * sideY / 10) * r.nextFloat()
            );
            else ag.setCoordinates(originX + sideX / 20 + (9 * sideX / 10) * r.nextDouble(),
                    originY + sideY / 20 + (9 * sideY / 10) * r.nextFloat()
            );
        }

        ag.setDirection(2 * Math.PI * r.nextDouble());
        if (species == 0) ag.setBaseSpeed(App.BASESPEED1);
        else ag.setBaseSpeed(App.BASESPEED2);

        ag.setAge(2 * App.BASEMAXAGE * r.nextDouble() / 3);
        ag.setMaxAge(4 * App.BASEMAXAGE / 5 + 2 * App.BASEMAXAGE * r.nextDouble() / 5);
        ag.setAgeIncr(App.AGEPERSTEP);

        ag.setMaxEnergy(App.MAXENERGY);
        ag.setEnergy(App.SUFFENERGY + App.SUFFENERGY / 1.2);
        ag.setSuffEnergy(App.SUFFENERGY);

        if (species == 0) ag.setEnergyDecr(App.NRGPERSTEP1);
        else ag.setEnergyDecr(App.NRGPERSTEP2);

        if (species == 0) ag.setValence(App.VALENCE1);
        else ag.setValence(App.VALENCE2);

        ag.setActCtrPeak(App.ACTCTRPEAK);

        return ag;
    }

    public static ResourceGroup buildResourceGroup() {
        ResourceGroup resGroup = new ResourceGroup(App.DEFX, App.DEFY, App.QUADX, App.QUADY, App.RESPERQUAD);
        resGroup.fillResNodes(App.BASERES, 0.5, App.RESREPSPEED, App.RESREPCTRPEAK);

        return resGroup;
    }

    public static ResourceGrid buildResourceGrid() {
        ResourceGrid resGrid = new ResourceGrid(App.DEFX, App.DEFY, App.PLAINX, App.PLAINY);
        resGrid.fillResources(App.BASERES, 0.5, App.RESREPSPEED, App.RESREPCTRPEAK);

        return resGrid;
    }

}
