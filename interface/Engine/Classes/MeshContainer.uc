//=============================================================
// MeshContainer : Actor?? ?????? ???????? ??????
// flagoftiger 20070221
//=============================================================

class  MeshContainer extends Object
	native;

struct MeshComponentArrayPtr { var int Ptr; };


var private Actor							Owner;
var private MeshComponent					FirstMeshComponent;				// MeshComponent ???????? ?????? ??????
var private native MeshComponentArrayPtr	MeshComponentArray[68];			// ?????? ?????? ???? ST_MAX+2 ST_mAX?? ?????? ??????????????.
var private native MeshComponentArrayPtr	MeshComponentBufferArray[68];	// ?????? ?????????????? ????????????.

var private bool							bLoaded;

//by elsacred 
var sphere	BoundingVolume;					
var box		BoundingBox;