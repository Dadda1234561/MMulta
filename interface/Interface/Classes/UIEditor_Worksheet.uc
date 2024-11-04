class UIEditor_Worksheet extends UICommonAPI;

//"Del" Key
function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
{
	if( nKey == IK_Delete )
	{
		DeleteWindow();
	}
	else if( nKey == IK_Escape )
	{
		ClearAllTracker();
	}
}

//ReleaseTracker
function ClearAllTracker()
{
	ClearTracker();
}

//Delete Control
function DeleteWindow()
{
	DeleteAttachedWindow();
}

function OnDropWnd( WindowHandle hTarget, WindowHandle hDropWnd, int x, int y )
{
	local UIEditor_ControlManager Script;

	local WindowHandle ContainerHandle;
	local WindowHandle ParentHandle;
	
	if( hTarget == None || hDropWnd == None )
		return;

	ContainerHandle = hTarget;
		
	//Find Container
	if( !ContainerHandle.IsControlContainer() )
	{
		ParentHandle = ContainerHandle.GetParentWindowHandle();
		while( ParentHandle != None )
		{
			if( ParentHandle.IsControlContainer() )
				break;
			ParentHandle = ParentHandle.GetParentWindowHandle();
		}
		ContainerHandle = ParentHandle;
	}
	if( ContainerHandle==None )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Can't Move Control to " $ hTarget.GetWindowName() $ ".", string(Self) );
		return;
	}
	
	//Change Parent
	if( hDropWnd.ChangeParentWindow( ContainerHandle ) )
	{
		//Refresh Control List
		Script = UIEditor_ControlManager( GetScript( "UIEditor_ControlManager" ) );
		if( Script!=None )
			Script.RefreshControlList();	
	}	
}

function OnDropItemWithHandle(WindowHandle hTarget, ItemInfo Info, int X, int Y)
{
	local UIEditor_ControlManager script;
	local WindowHandle TargetWndHandle;

	script = UIEditor_ControlManager(GetScript("UIEditor_ControlManager"));
	if ( script == None )
	{
		return;
	}
	if ( script.selectWnd != None )
	{
		TargetWndHandle = script.selectWnd;
	}
	else
	{
		TargetWndHandle = hTarget;
	}
	script.AddControl(TargetWndHandle,X,Y);
}

defaultproperties
{
}
