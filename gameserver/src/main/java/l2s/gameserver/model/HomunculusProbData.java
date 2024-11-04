package l2s.gameserver.model;

public class HomunculusProbData {
    private int index;
    private int nProbPerMillion;

    public HomunculusProbData(int index, int nProbPerMillion) {
        this.index = index;
        this.nProbPerMillion = nProbPerMillion;
    }

    public int getIndex() {
        return index;
    }

    public int getProbPerMillion() {
        return nProbPerMillion;
    }
}
