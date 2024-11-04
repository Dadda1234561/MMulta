//=============================================================================
// MusicVolume:  
//=============================================================================
class MusicVolume extends Volume
	native
	nativereplication;

var(Music) int nMusicID;
var(Music) bool bForcePlayMusic;
var(Music) bool bLoopMusic;
var(Music) int nNightMusicID;
var(Music) float DayMusicInterval;
var(Music) float NightMusicInterval;
var(Music) bool bNightMusicRandomPlay;
var(Music) bool bDayMusicRandomPlay;
var(Music) array<int> ZoneMusicID;
var(Music) bool bZoneMusicRandomPlay;
var(Music) float ZoneMusicInterval;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}


// Decompiled with UE Explorer.
defaultproperties
{
    nMusicID=-1
    nNightMusicID=-1
    DayMusicInterval=30
    NightMusicInterval=30
    bNightMusicRandomPlay=true
    bDayMusicRandomPlay=true
    bZoneMusicRandomPlay=true
    ZoneMusicInterval=30
}