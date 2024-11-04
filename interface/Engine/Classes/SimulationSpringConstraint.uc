class SimulationSpringConstraint extends Object
	native;

// difine ESC_MAX 8

var		int		Responsiveness[8];	
var		int		NeighbourIndex[8];	
var		float	DistAtRest[8];	



// Decompiled with UE Explorer.
defaultproperties
{
    NeighbourIndex[0]=-1
    NeighbourIndex[1]=-1
    NeighbourIndex[2]=-1
    NeighbourIndex[3]=-1
    NeighbourIndex[4]=-1
    NeighbourIndex[5]=-1
    NeighbourIndex[6]=-1
    NeighbourIndex[7]=-1
    DistAtRest[0]=9999999
    DistAtRest[1]=9999999
    DistAtRest[2]=9999999
    DistAtRest[3]=9999999
    DistAtRest[4]=9999999
    DistAtRest[5]=9999999
    DistAtRest[6]=9999999
    DistAtRest[7]=9999999
}