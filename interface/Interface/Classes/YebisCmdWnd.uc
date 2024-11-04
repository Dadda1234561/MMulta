class YebisCmdWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var ComboBoxHandle hdrComboBox;
var ComboBoxHandle shaComboBox;
var SliderCtrlHandle mgSliderCtrl;
var SliderCtrlHandle adtSliderCtrl;
var SliderCtrlHandle coef1SliderCtrl;
var SliderCtrlHandle coef2SliderCtrl;
var SliderCtrlHandle expSliderCtrl;
var SliderCtrlHandle mFactorSliderCtrl;
var SliderCtrlHandle lumSliderCtrl;
var SliderCtrlHandle thrSliderCtrl;
var SliderCtrlHandle quaSliderCtrl;
var SliderCtrlHandle bluSliderCtrl;
var SliderCtrlHandle remSliderCtrl;
var SliderCtrlHandle hueSliderCtrl;
var SliderCtrlHandle satSliderCtrl;
var SliderCtrlHandle conSliderCtrl;
var SliderCtrlHandle briSliderCtrl;
var SliderCtrlHandle temSliderCtrl;
var SliderCtrlHandle whiSliderCtrl;
var SliderCtrlHandle sepSliderCtrl;
var SliderCtrlHandle gamSliderCtrl;
var SliderCtrlHandle apeSliderCtrl;
var SliderCtrlHandle dofqSliderCtrl;
var SliderCtrlHandle focSliderCtrl;
var SliderCtrlHandle shSliderCtrl;
var SliderCtrlHandle smpSliderCtrl;
var SliderCtrlHandle rdsSliderCtrl;
var SliderCtrlHandle sclSliderCtrl;
var TextBoxHandle mFactorValueBox;
var TextBoxHandle mgValueBox;
var TextBoxHandle adtValueBox;
var TextBoxHandle coef1ValueBox;
var TextBoxHandle coef2ValueBox;
var TextBoxHandle expValueBox;
var TextBoxHandle lumValueBox;
var TextBoxHandle thrValueBox;
var TextBoxHandle quaValueBox;
var TextBoxHandle bluValueBox;
var TextBoxHandle remValueBox;
var TextBoxHandle hueValueBox;
var TextBoxHandle satValueBox;
var TextBoxHandle conValueBox;
var TextBoxHandle briValueBox;
var TextBoxHandle temValueBox;
var TextBoxHandle whiValueBox;
var TextBoxHandle sepValueBox;
var TextBoxHandle gamValueBox;
var TextBoxHandle apeValueBox;
var TextBoxHandle dofqValueBox;
var TextBoxHandle focValueBox;
var TextBoxHandle shValueBox;
var TextBoxHandle smpValueBox;
var TextBoxHandle rdsValueBox;
var TextBoxHandle sclValueBox;
var CheckBoxHandle yebisCheckBox;
var CheckBoxHandle tonemapCheckBox;
var CheckBoxHandle dofCheckBox;
var CheckBoxHandle showRangeCheckBox;
var CheckBoxHandle anaCheckBox;
var CheckBoxHandle aaCheckBox;
var CheckBoxHandle aoCheckBox;
var EditBoxHandle dofWidthEditBox;
var EditBoxHandle dofLvlEditBox;
var EditBoxHandle dofEdgeEditBox;
var EditBoxHandle dofShapeEditBox;
var EditBoxHandle lvCombiEditBox;
var EditBoxHandle blurWidthEditBox;
var EditBoxHandle blurScaleEditBox;
var EditBoxHandle bladesEditBox;
var EditBoxHandle apeCircularEditBox;

event OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("YebisCmdWnd");
	Me.SetWindowTitle("Yebis Parameters");
	yebisCheckBox = GetCheckBoxHandle(m_WindowName $ ".yebisCheckBox");
	tonemapCheckBox = GetCheckBoxHandle(m_WindowName $ ".tonemapCheckBox");
	dofCheckBox = GetCheckBoxHandle(m_WindowName $ ".dofCheckBox");
	showRangeCheckBox = GetCheckBoxHandle(m_WindowName $ ".showRangeCheckBox");
	anaCheckBox = GetCheckBoxHandle(m_WindowName $ ".anaCheckBox");
	aaCheckBox = GetCheckBoxHandle(m_WindowName $ ".aaCheckBox");
	aoCheckBox = GetCheckBoxHandle(m_WindowName $ ".aoCheckBox");
	hdrComboBox = GetComboBoxHandle(m_WindowName $ ".hdrComboBox");
	hdrComboBox.AddString("Disable");
	hdrComboBox.AddString("True HDR");
	hdrComboBox.AddString("Sim HDR");
	hdrComboBox.AddString("Sim HDR Glare");
	hdrComboBox.AddString("Quasi HDR");
	hdrComboBox.AddString("Quasi HDR Glare");
	hdrComboBox.SetSelectedNum(3);
	shaComboBox = GetComboBoxHandle(m_WindowName $ ".shaComboBox");
	shaComboBox.AddString("Disable");
	shaComboBox.AddString("Bloom");
	shaComboBox.AddString("Lensflare");
	shaComboBox.AddString("Standard");
	shaComboBox.AddString("Cheap Lens");
	shaComboBox.AddString("After Image");
	shaComboBox.AddString("Cross Screen");
	shaComboBox.AddString("Cross Screen 2");
	shaComboBox.AddString("Snow Cross");
	shaComboBox.AddString("Snow Cross 2");
	shaComboBox.AddString("Sunny Cross");
	shaComboBox.AddString("Sunny Cross 2");
	shaComboBox.AddString("Horizontal Streak");
	shaComboBox.AddString("Vertical Streak");
	shaComboBox.SetSelectedNum(8);
	mFactorSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".mFactorSliderCtrl");
	mFactorValueBox = GetTextBoxHandle(m_WindowName $ ".mFactorValueBox");
	mgSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".mgSliderCtrl");
	mgValueBox = GetTextBoxHandle(m_WindowName $ ".mgValueBox");
	adtSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".adtSliderCtrl");
	adtValueBox = GetTextBoxHandle(m_WindowName $ ".adtValueBox");
	coef1SliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".coef1SliderCtrl");
	coef1ValueBox = GetTextBoxHandle(m_WindowName $ ".coef1ValueBox");
	coef2SliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".coef2SliderCtrl");
	coef2ValueBox = GetTextBoxHandle(m_WindowName $ ".coef2ValueBox");
	expSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".expSliderCtrl");
	expValueBox = GetTextBoxHandle(m_WindowName $ ".expValueBox");
	lumSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".lumSliderCtrl");
	lumValueBox = GetTextBoxHandle(m_WindowName $ ".lumValueBox");
	thrSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".thrSliderCtrl");
	thrValueBox = GetTextBoxHandle(m_WindowName $ ".thrValueBox");
	quaSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".quaSliderCtrl");
	quaValueBox = GetTextBoxHandle(m_WindowName $ ".quaValueBox");
	bluSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".bluSliderCtrl");
	bluValueBox = GetTextBoxHandle(m_WindowName $ ".bluValueBox");
	remSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".remSliderCtrl");
	remValueBox = GetTextBoxHandle(m_WindowName $ ".remValueBox");
	apeSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".apeSliderCtrl");
	apeValueBox = GetTextBoxHandle(m_WindowName $ ".apeValueBox");
	dofqSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".dofqSliderCtrl");
	dofqValueBox = GetTextBoxHandle(m_WindowName $ ".dofqValueBox");
	focSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".focSliderCtrl");
	focValueBox = GetTextBoxHandle(m_WindowName $ ".focValueBox");
	shSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".shSliderCtrl");
	shValueBox = GetTextBoxHandle(m_WindowName $ ".shValueBox");
	hueSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".hueSliderCtrl");
	hueValueBox = GetTextBoxHandle(m_WindowName $ ".hueValueBox");
	satSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".satSliderCtrl");
	satValueBox = GetTextBoxHandle(m_WindowName $ ".satValueBox");
	briSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".briSliderCtrl");
	briValueBox = GetTextBoxHandle(m_WindowName $ ".briValueBox");
	conSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".conSliderCtrl");
	conValueBox = GetTextBoxHandle(m_WindowName $ ".conValueBox");
	gamSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".gamSliderCtrl");
	gamValueBox = GetTextBoxHandle(m_WindowName $ ".gamValueBox");
	temSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".temSliderCtrl");
	temValueBox = GetTextBoxHandle(m_WindowName $ ".temValueBox");
	whiSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".whiSliderCtrl");
	whiValueBox = GetTextBoxHandle(m_WindowName $ ".whiValueBox");
	sepSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".sepSliderCtrl");
	sepValueBox = GetTextBoxHandle(m_WindowName $ ".sepValueBox");
	smpSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".smpSliderCtrl");
	smpValueBox = GetTextBoxHandle(m_WindowName $ ".smpValueBox");
	rdsSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".rdsSliderCtrl");
	rdsValueBox = GetTextBoxHandle(m_WindowName $ ".rdsValueBox");
	sclSliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".sclSliderCtrl");
	sclValueBox = GetTextBoxHandle(m_WindowName $ ".sclValueBox");
	dofWidthEditBox = GetEditBoxHandle(m_WindowName $ ".dofWidthEditBox");
	dofLvlEditBox = GetEditBoxHandle(m_WindowName $ ".dofLvlEditBox");
	dofEdgeEditBox = GetEditBoxHandle(m_WindowName $ ".dofEdgeEditBox");
	dofShapeEditBox = GetEditBoxHandle(m_WindowName $ ".dofShapeEditBox");
	lvCombiEditBox = GetEditBoxHandle(m_WindowName $ ".lvCombiEditBox");
	blurWidthEditBox = GetEditBoxHandle(m_WindowName $ ".blurWidthEditBox");
	blurScaleEditBox = GetEditBoxHandle(m_WindowName $ ".blurScaleEditBox");
	bladesEditBox = GetEditBoxHandle(m_WindowName $ ".bladesEditBox");
	apeCircularEditBox = GetEditBoxHandle(m_WindowName $ ".apeCircularEditBox");
}

event OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local float fvalue;
	local int ivalue;

	switch(strID)
	{
		// End:0x8B
		case "mFactorSliderCtrl":
			fvalue = float(mFactorSliderCtrl.GetCurrentTick()) + 1.0f;
			ExecuteCommand("///yebis fMappingFactor=" $ string(fvalue - 1.0f));
			mFactorValueBox.SetText(string(fvalue - 1.0f));
			// End:0xB37
			break;
		// End:0xF9
		case "mgSliderCtrl":
			fvalue = float(mgSliderCtrl.GetCurrentTick()) / 100.0f;
			ExecuteCommand("///yebis fMiddleGray=" $ string(fvalue));
			mgValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x173
		case "adtSliderCtrl":
			fvalue = float(adtSliderCtrl.GetCurrentTick()) / 100.0f;
			ExecuteCommand("///yebis fAdaptationSensitivity=" $ string(fvalue));
			adtValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x1E3
		case "coef1SliderCtrl":
			fvalue = float(coef1SliderCtrl.GetCurrentTick()) / 100.0f;
			ExecuteCommand("///yebis bToneCoef1=" $ string(fvalue));
			coef1ValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x25A
		case "coef2SliderCtrl":
			fvalue = (float(coef2SliderCtrl.GetCurrentTick()) / 100.0f) - 0.50f;
			ExecuteCommand("///yebis bToneCoef2=" $ string(fvalue));
			coef2ValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x2E8
		case "expSliderCtrl":
			fvalue = float(expSliderCtrl.GetCurrentTick()) / 100.0f;
			ExecuteCommand("///yebis exp=" $ string(fvalue));
			// End:0x2CF
			if(fvalue == 0.0f)
			{
				expValueBox.SetText("Auto");				
			}
			else
			{
				expValueBox.SetText(string(fvalue));
			}
			// End:0xB37
			break;
		// End:0x34F
		case "lumSliderCtrl":
			fvalue = float(lumSliderCtrl.GetCurrentTick()) / 10.0f;
			ExecuteCommand("///yebis lum=" $ string(fvalue));
			lumValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x3B6
		case "thrSliderCtrl":
			fvalue = float(thrSliderCtrl.GetCurrentTick()) / 100.0f;
			ExecuteCommand("///yebis thr=" $ string(fvalue));
			thrValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x418
		case "quaSliderCtrl":
			ivalue = int(float(quaSliderCtrl.GetCurrentTick()));
			ExecuteCommand("///yebis qua=" $ string(ivalue));
			quaValueBox.SetText(string(ivalue));
			// End:0xB37
			break;
		// End:0x47F
		case "bluSliderCtrl":
			fvalue = float(bluSliderCtrl.GetCurrentTick()) / 10.0f;
			ExecuteCommand("///yebis blu=" $ string(fvalue));
			bluValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x4E1
		case "remSliderCtrl":
			fvalue = float(remSliderCtrl.GetCurrentTick());
			ExecuteCommand("///yebis rem=" $ string(fvalue));
			remValueBox.SetText(string(int(fvalue)));
			// End:0xB37
			break;
		// End:0x554
		case "apeSliderCtrl":
			fvalue = float(apeSliderCtrl.GetCurrentTick()) / float(10);
			ExecuteCommand("///yebis fApertureFnumber=" $ string(fvalue));
			apeValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x5C4
		case "dofqSliderCtrl":
			ivalue = dofqSliderCtrl.GetCurrentTick();
			ExecuteCommand("///yebis nDepthOfFieldQuality=" $ string(ivalue));
			dofqValueBox.SetText(string(ivalue));
			// End:0xB37
			break;
		// End:0x64D
		case "focSliderCtrl":
			fvalue = float(focSliderCtrl.GetCurrentTick());
			ExecuteCommand("///yebis foc=" $ string(fvalue));
			// End:0x632
			if(fvalue == 0.0f)
			{
				focValueBox.SetText("Auto");				
			}
			else
			{
				focValueBox.SetText(string(int(fvalue)));
			}
			// End:0xB37
			break;
		// End:0x6C2
		case "shSliderCtrl":
			fvalue = float(shSliderCtrl.GetCurrentTick()) / 10.0f;
			ExecuteCommand("///yebis fImageSensorHeight=" $ string(fvalue));
			shValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x72B
		case "hueSliderCtrl":
			fvalue = float(hueSliderCtrl.GetCurrentTick()) - 179.0f;
			ExecuteCommand("///yebis hue=" $ string(fvalue));
			hueValueBox.SetText(string(int(fvalue)));
			// End:0xB37
			break;
		// End:0x792
		case "satSliderCtrl":
			fvalue = float(satSliderCtrl.GetCurrentTick()) / 100.0f;
			ExecuteCommand("///yebis sat=" $ string(fvalue));
			satValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x7F9
		case "briSliderCtrl":
			fvalue = float(briSliderCtrl.GetCurrentTick()) / 100.0f;
			ExecuteCommand("///yebis bri=" $ string(fvalue));
			briValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x860
		case "conSliderCtrl":
			fvalue = float(conSliderCtrl.GetCurrentTick()) / 100.0f;
			ExecuteCommand("///yebis con=" $ string(fvalue));
			conValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x8C7
		case "gamSliderCtrl":
			fvalue = float(gamSliderCtrl.GetCurrentTick()) / 100.0f;
			ExecuteCommand("///yebis gam=" $ string(fvalue));
			gamValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0x930
		case "temSliderCtrl":
			fvalue = float(temSliderCtrl.GetCurrentTick()) * 10.0f;
			ExecuteCommand("///yebis tem=" $ string(fvalue));
			temValueBox.SetText(string(int(fvalue)));
			// End:0xB37
			break;
		// End:0x999
		case "whiSliderCtrl":
			fvalue = float(whiSliderCtrl.GetCurrentTick()) * 10.0f;
			ExecuteCommand("///yebis whi=" $ string(fvalue));
			whiValueBox.SetText(string(int(fvalue)));
			// End:0xB37
			break;
		// End:0xA00
		case "sepSliderCtrl":
			fvalue = float(sepSliderCtrl.GetCurrentTick()) / 100.0f;
			ExecuteCommand("///yebis sep=" $ string(fvalue));
			sepValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
		// End:0xA62
		case "smpSliderCtrl":
			ivalue = smpSliderCtrl.GetCurrentTick() + 1;
			ExecuteCommand("///yebis sSmp=" $ string(ivalue));
			smpValueBox.SetText(string(ivalue));
			// End:0xB37
			break;
		// End:0xAC5
		case "rdsSliderCtrl":
			ivalue = rdsSliderCtrl.GetCurrentTick() + 10;
			ExecuteCommand("///yebis sRds=" $ string(ivalue));
			rdsValueBox.SetText(string(ivalue));
			// End:0xB37
			break;
		// End:0xB34
		case "sclSliderCtrl":
			fvalue = (float(sclSliderCtrl.GetCurrentTick()) / 10.0f) + 0.10f;
			ExecuteCommand("///yebis sScl=" $ string(fvalue));
			sclValueBox.SetText(string(fvalue));
			// End:0xB37
			break;
	}
}

event OnCompleteEditBox(string strID)
{
	switch(strID)
	{
		// End:0x58
		case "dofWidthEditBox":
			ExecuteCommand("///yebis fDepthOfFieldWidthScale=" $ dofWidthEditBox.GetString());
			// End:0x2DA
			break;
		// End:0xAC
		case "dofLvlEditBox":
			ExecuteCommand("///yebis uiDepthOfFieldApertureLevels=" $ dofLvlEditBox.GetString());
			// End:0x2DA
			break;
		// End:0xFD
		case "dofEdgeEditBox":
			ExecuteCommand("///yebis eDepthOfFieldEdgeQuality=" $ dofEdgeEditBox.GetString());
			// End:0x2DA
			break;
		// End:0x145
		case "dofShapeEditBox":
			ExecuteCommand("///yebis eApertureShape=" $ dofShapeEditBox.GetString());
			// End:0x2DA
			break;
		// End:0x197
		case "lvCombiEditBox":
			ExecuteCommand("///yebis iApertureLevelCombination=" $ lvCombiEditBox.GetString());
			// End:0x2DA
			break;
		// End:0x1EB
		case "blurWidthEditBox":
			ExecuteCommand("///yebis uiApertureResultBlurWidth=" $ blurWidthEditBox.GetString());
			// End:0x2DA
			break;
		// End:0x23E
		case "blurScaleEditBox":
			ExecuteCommand("///yebis fApertureResultBlurScale=" $ blurScaleEditBox.GetString());
			// End:0x2DA
			break;
		// End:0x286
		case "bladesEditBox":
			ExecuteCommand("///yebis nDiaphragmBlades=" $ bladesEditBox.GetString());
			// End:0x2DA
			break;
		// End:0x2D7
		case "apeCircularEditBox":
			ExecuteCommand("///yebis fApertureCirculariry=" $ apeCircularEditBox.GetString());
			// End:0x2DA
			break;
	}
}

event OnComboBoxItemSelected(string strID, int IndexID)
{
	switch(strID)
	{
		// End:0xD7
		case "hdrComboBox":
			switch(IndexID)
			{
				// End:0x3C
				case 0:
					ExecuteCommand("///yebis hdr=-1");
					// End:0xD4
					break;
				// End:0x59
				case 1:
					ExecuteCommand("///yebis hdr=0");
					// End:0xD4
					break;
				// End:0x77
				case 2:
					ExecuteCommand("///yebis hdr=1");
					// End:0xD4
					break;
				// End:0x95
				case 3:
					ExecuteCommand("///yebis hdr=2");
					// End:0xD4
					break;
				// End:0xB3
				case 4:
					ExecuteCommand("///yebis hdr=3");
					// End:0xD4
					break;
				// End:0xD1
				case 5:
					ExecuteCommand("///yebis hdr=4");
					// End:0xD4
					break;
				// End:0xFFFF
				default:
					break;
			}
			// End:0x29D
			break;
		// End:0x29A
		case "shaComboBox":
			switch(IndexID)
			{
				// End:0x10B
				case 0:
					ExecuteCommand("///yebis sha=0");
					// End:0x297
					break;
				// End:0x128
				case 1:
					ExecuteCommand("///yebis sha=1");
					// End:0x297
					break;
				// End:0x146
				case 2:
					ExecuteCommand("///yebis sha=2");
					// End:0x297
					break;
				// End:0x164
				case 3:
					ExecuteCommand("///yebis sha=3");
					// End:0x297
					break;
				// End:0x182
				case 4:
					ExecuteCommand("///yebis sha=4");
					// End:0x297
					break;
				// End:0x1A0
				case 5:
					ExecuteCommand("///yebis sha=5");
					// End:0x297
					break;
				// End:0x1BE
				case 6:
					ExecuteCommand("///yebis sha=6");
					// End:0x297
					break;
				// End:0x1DC
				case 7:
					ExecuteCommand("///yebis sha=7");
					// End:0x297
					break;
				// End:0x1FA
				case 8:
					ExecuteCommand("///yebis sha=8");
					// End:0x297
					break;
				// End:0x218
				case 9:
					ExecuteCommand("///yebis sha=9");
					// End:0x297
					break;
				// End:0x237
				case 10:
					ExecuteCommand("///yebis sha=10");
					// End:0x297
					break;
				// End:0x256
				case 11:
					ExecuteCommand("///yebis sha=11");
					// End:0x297
					break;
				// End:0x275
				case 12:
					ExecuteCommand("///yebis sha=12");
					// End:0x297
					break;
				// End:0x294
				case 13:
					ExecuteCommand("///yebis sha=13");
					// End:0x297
					break;
				// End:0xFFFF
				default:
					break;
			}
			// End:0x29D
			break;
	}
}

event OnClickCheckBox(string strID)
{
	switch(strID)
	{
		// End:0x58
		case "yebisCheckBox":
			// End:0x41
			if(yebisCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis on");				
			}
			else
			{
				ExecuteCommand("///yebis off");
			}
			// End:0x26B
			break;
		// End:0xC0
		case "tonemapCheckBox":
			// End:0x9F
			if(tonemapCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis bToneMapCvs=1");				
			}
			else
			{
				ExecuteCommand("///yebis bToneMapCvs=0");
			}
			// End:0x26B
			break;
		// End:0x114
		case "dofCheckBox":
			// End:0xFB
			if(dofCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis dof=1");				
			}
			else
			{
				ExecuteCommand("///yebis dof=0");
			}
			// End:0x26B
			break;
		// End:0x16E
		case "showRangeCheckBox":
			// End:0x155
			if(showRangeCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis bok=1");				
			}
			else
			{
				ExecuteCommand("///yebis bok=0");
			}
			// End:0x26B
			break;
		// End:0x1C2
		case "anaCheckBox":
			// End:0x1A9
			if(anaCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis ana=1");				
			}
			else
			{
				ExecuteCommand("///yebis ana=0");
			}
			// End:0x26B
			break;
		// End:0x213
		case "aaCheckBox":
			// End:0x1FB
			if(aaCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis aa=1");				
			}
			else
			{
				ExecuteCommand("///yebis aa=0");
			}
			// End:0x26B
			break;
		// End:0x268
		case "aoCheckBox":
			// End:0x24E
			if(aoCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis ssao=1");				
			}
			else
			{
				ExecuteCommand("///yebis ssao=0");
			}
			// End:0x26B
			break;
	}
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

event OnShow()
{
	expSliderCtrl.SetCurrentTick(50);
	mFactorSliderCtrl.SetCurrentTick(22);
	mgSliderCtrl.SetCurrentTick(18);
	adtSliderCtrl.SetCurrentTick(30);
	tonemapCheckBox.SetCheck(false);
	ExecuteCommand("///yebis bToneMapCvs=0");
	coef1SliderCtrl.SetCurrentTick(95);
	coef2SliderCtrl.SetCurrentTick(30);
	lumSliderCtrl.SetCurrentTick(6);
	thrSliderCtrl.SetCurrentTick(40);
	quaSliderCtrl.SetCurrentTick(5);
	bluSliderCtrl.SetCurrentTick(75);
	remSliderCtrl.SetCurrentTick(32);
	shaComboBox.SetSelectedNum(6);
	ExecuteCommand("///yebis sha=6");
	showRangeCheckBox.SetCheck(false);
	focSliderCtrl.SetCurrentTick(0);
	apeSliderCtrl.SetCurrentTick(24);
	dofqSliderCtrl.SetCurrentTick(11);
	shSliderCtrl.SetCurrentTick(80);
	hueSliderCtrl.SetCurrentTick(179);
	satSliderCtrl.SetCurrentTick(95);
	briSliderCtrl.SetCurrentTick(100);
	conSliderCtrl.SetCurrentTick(100);
	gamSliderCtrl.SetCurrentTick(150);
	temSliderCtrl.SetCurrentTick(650);
	whiSliderCtrl.SetCurrentTick(650);
	sepSliderCtrl.SetCurrentTick(0);
	aoCheckBox.SetCheck(true);
	ExecuteCommand("///yebis ssao=1");
	smpSliderCtrl.SetCurrentTick(31);
	rdsSliderCtrl.SetCurrentTick(70);
	sclSliderCtrl.SetCurrentTick(14);
}

defaultproperties
{
     m_WindowName="YebisCmdWnd"
}
