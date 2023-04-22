import java.util.ArrayList;
import java.util.Random;

public class Builder {

    public static ArrayList<Agent> buildAgentArray() {
        ArrayList<Agent> agents = new ArrayList<>(App.INITAGENTAMOUNT1 + App.INITAGENTAMOUNT2);

        Random r = new Random();

        for (int i = 0; i < App.INITAGENTAMOUNT1; i++) {
            agents.add(buildAgent(0));
        }

        for (int i = 0; i < App.INITAGENTAMOUNT2; i++) {
            agents.add(buildAgent(1));
        }

        return agents;
    }

    public static Agent buildAgent(int species) {
        Random r = new Random();

        Agent ag = new Agent();
        ag.setSpecies(species);
        if (species == 1) {
            if (App.SYSSPAWN) ag.setCoordinates(App.DEFX / 10 + (2 * App.DEFX / 5) * r.nextDouble(),
                    App.DEFY / 10 + (4 * App.DEFY / 5) * r.nextFloat()
            );
            else ag.setCoordinates(App.DEFX / 10 + (4 * App.DEFX / 5) * r.nextDouble(),
                    App.DEFY / 10 + (4 * App.DEFY / 5) * r.nextFloat()
            );
        }
        else {
            if (App.SYSSPAWN) ag.setCoordinates(9 * App.DEFX / 10 - (2 * App.DEFX / 5) * r.nextDouble(),
                    App.DEFY / 10 + (4 * App.DEFY / 5) * r.nextFloat()
            );
            else ag.setCoordinates(App.DEFX / 10 + (4 * App.DEFX / 5) * r.nextDouble(),
                    App.DEFY / 10 + (4 * App.DEFY / 5) * r.nextFloat()
            );
        }

        ag.setDirection(2 * Math.PI * r.nextDouble());
        if (species == 0) ag.setBaseSpeed(App.BASESPEED1);
        else ag.setBaseSpeed(App.BASESPEED2);

        ag.setAge(2 * App.BASEMAXAGE * r.nextDouble() / 3);
        ag.setMaxAge(4 * App.BASEMAXAGE / 5 + 2 * App.BASEMAXAGE * r.nextDouble() / 5);
        ag.setAgeIncr(App.AGEPERSTEP);

        ag.setMaxEnergy(App.MAXENERGY);
        ag.setEnergy(App.SUFFENERGY + App.SUFFENERGY * r.nextDouble());
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

}
