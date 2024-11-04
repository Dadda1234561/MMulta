//================================================================================
// CharacterCreateEditbox.
//================================================================================
class CharacterCreateEditbox extends UICommonAPI;

function OnRegisterEvent()
{
    RegisterEvent(EV_StateChanged);
}

function OnLoad()
{
    RegisterState("CharacterCreateEditbox", "CHARACTERCREATESTATE");

    if(isChinaVer())
    {
        GetEditBoxHandle("CharacterCreateEditbox.CharacterNameEditbox").SetFocusedBackTexture("L2UI_CT1.EmptyBtn", "L2UI_CT1.EmptyBtn", "L2UI_CT1.EmptyBtn");
        GetEditBoxHandle("CharacterCreateEditbox.CharacterNameEditbox").SetUnFocusedBackTexture("L2UI_CT1.EmptyBtn", "L2UI_CT1.EmptyBtn", "L2UI_CT1.EmptyBtn");
    }
    else
    {
        GetWindowHandle("CharacterCreateEditbox").HideWindow();
    }
}

function OnEvent(int Event_ID, string param)
{
    if(Event_ID == EV_StateChanged)
    {
        if(isChinaVer())
        {
            if(param == "CHARACTERCREATESTATE")
            {
                GetWindowHandle("CharacterCreateEditbox").ShowWindow();
            }
            else
            {
                GetWindowHandle("CharacterCreateEditbox").HideWindow();
            }
        }
    }
}

function OnShow()
{
    if(isChinaVer())
    {
        GetEditBoxHandle("CharacterCreateEditbox.CharacterNameEditbox").SetString("");
        setFocusTarget();
    }
    else
    {
        GetWindowHandle("CharacterCreateEditbox").HideWindow();
    }
}

function bool isChinaVer()
{
    local ELanguageType Language;

    Language = GetLanguage();
    return int(Language) == 4;
}

function setFocusTarget()
{
    if(isChinaVer())
    {
        if(!GetEditBoxHandle("CharacterCreateEditbox.CharacterNameEditbox").IsFocused())
        {
            GetEditBoxHandle("CharacterCreateEditbox.CharacterNameEditbox").SetFocus();
        }
    }
}

function string getCharacterNameTextFieldValue()
{
    return GetEditBoxHandle("CharacterCreateEditbox.CharacterNameEditbox").GetString();
}

defaultproperties
{
}
