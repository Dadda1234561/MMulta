class UserDefinableMaterial extends Material
	native;

//#ifdef SEPERATE_MESHDATA
var() Texture BackGroundTexture;
var() Texture OnlyTestTexture;
var	transient Combiner OnlyTestFinalCombiner;	

//#endif


