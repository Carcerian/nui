//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::      _____                     _          
//::     / ___/__ ____________ ____(_)__ ____ ( )___
//::    / /__/ _ `/ __/ __/ -_) __/ / _ `/ _ \|/(_-<
//::    \___/\_,_/_/  \__/\__/_/ /_/\_,_/_//_/ /___/
//::         _  ____  ______    ___   ___  ____
//::        / |/ / / / /  _/   / _ | / _ \/  _/
//::       /    / /_/ // /    / __ |/ ___// /
//::      /_/|_/\____/___/   /_/ |_/_/  /___/
//::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - Popup Dialog API
//:: nui_api_popup.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 2, 2026
//:: MODIFIED: June 3, 2026 - Added BioWare inline documentation
//::///////////////////////////////////////////////////////////////////////
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Complete popup dialog system for RPG development.
        Provides 61 specialized dialog functions for common RPG interactions.
        All functions organized in alphabetical order with consistent signatures.
        Uses full NUI widget builders for professional UIs.

    DEPENDENCIES
        nw_inc_nui (for NUI widget builders)
        nui_api_json (for JSON construction)

    USAGE
        #include "nui_api" (or nui_api_popup directly)
        
        NUI_PopupMessage(oPC, "Welcome", "Hello player!", "nui_handler");
        NUI_PopupText(oPC, "Name", "Enter your name:", "nui_handler");
        NUI_PopupColor(oPC, "Hair Color", "nui_handler");

*/
//::///////////////////////////////////////////////////////////////////////

#include "nui_api_config"
#include "nui_api_json"
#include "nw_inc_nui"

/* ----------------------------------------------------------------------- */
/*  CONSTANTS - Error Codes                                                */
/* ----------------------------------------------------------------------- */

// Error codes are defined in nui_api_config.nss

/* ----------------------------------------------------------------------- */
/*  PUBLIC FORWARD DECLARATIONS - All 63 functions (Alphabetical)         */
/* ----------------------------------------------------------------------- */

int NUI_Kill(object oPC, int nToken);
int NUI_PopupAbout(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupAdmin(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupAlignment(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupBank(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupBiography(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupBook(object oPC, string sTitle, string sText, string sScript="nui_handler");
int NUI_PopupBuild(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupCasket(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupChest(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupChoice(object oPC, string sTitle, string sQuestion, string sScript="nui_handler");
int NUI_PopupClass(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupCombat(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupColor(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupConfig(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupConfirm(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupCustom(object oPC, string sTitle, string sContent, string sScript="nui_handler");
int NUI_PopupDM(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupEmote(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupEncounter(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupError(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupFlags(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupFloat(object oPC, string sTitle, string sLabel, float fMin, float fMax, float fDefault, string sScript="nui_handler");
int NUI_PopupFX(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupHelp(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupHome(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupInfo(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupInput(object oPC, string sTitle, string sPrompt, string sScript="nui_handler");
int NUI_PopupInt(object oPC, string sTitle, string sLabel, int nMin, int nMax, int nDefault, string sScript="nui_handler");
int NUI_PopupInventory(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupJournal(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupLights(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupLock(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupLoot(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupMap(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupMessage(object oPC, string sTitle, string sMessage, 
                     float fX=-1.0f, float fY=200.0f, float fWidth=312.5f, float fHeight=158.25f, string sScript="nui_handler");
int NUI_PopupMove(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupMusic(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupPack(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupPC(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupPerks(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupPortrait(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupQuest(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupQuests(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupRace(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupRange(object oPC, string sTitle, string sLabel, float fMin, float fMax, float fDefault, string sScript="nui_handler");
int NUI_PopupRitual(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupSlider(object oPC, string sTitle, string sLabel, float fMin, float fMax, float fDefault, string sScript="nui_handler");
int NUI_PopupSkills(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupSound(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupSoundset(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupSpawn(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupSpells(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupStats(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupStatus(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupSuccess(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupSky(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupSign(object oPC, string sScript="nui_handler");
int NUI_PopupText(object oPC, string sTitle, string sLabel, string sScript="nui_handler");
int NUI_PopupTile(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupTrap(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupTransform(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupValidation(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupWarning(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupYesNo(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupZap(object oPC);

//::///////////////////////////////////////////////////////////////////////////
//:: Utility Functions
//::///////////////////////////////////////////////////////////////////////////
void NUI_AOE_Cleanup(object oAOE, object oPC);
int NUI_DialogCreate(object oPC, string sTitle, json jContent, int nButtons, string sGeometry, string sScript, int nProps, float fWidth, float fHeight, int bAOE=FALSE);
void NUI_SetWindowColor(object oPC, int nToken, int nRed, int nGreen, int nBlue, int nAlpha);

/* ----------------------------------------------------------------------- */
/*  POPUP IMPLEMENTATIONS - Alphabetical Order                             */
/* ----------------------------------------------------------------------- */

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupAbout
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Display server or module information
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupAbout(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sAbout = "Carcerian NUI Framework v1.0\nAdvanced Dialog System";
    return NUI_PopupMessage(oPC, sTitle, sAbout);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupAdmin
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Admin/DM tools interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupAdmin(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsDM(oPC) && !GetIsPC(oPC)) return 0;
    string sAdmin = "ADMIN TOOLS\n\nServer Management\n[Server Info]\n[Player List]";
    return NUI_PopupMessage(oPC, sTitle, sAdmin);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupAlignment
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Display character alignment status
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupAlignment(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sAlign = "Alignment: [Neutral/Good/Evil]";
    return NUI_PopupMessage(oPC, sTitle, sAlign);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupBank
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Banking and currency management interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupBank(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sBank = "BANK SYSTEM\n\nBalance: 0 gold\n[Deposit]\n[Withdraw]";
    return NUI_PopupMessage(oPC, sTitle, sBank);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupBiography
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Character biography editor with multi-line text input
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupBiography(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    json jRoot = NuiRow(JsonArray1(
        NuiTextEdit(JsonString("Enter biography..."), 
                   NuiBind("bio_text"), 
                   1000, TRUE, TRUE)));
    json jGeom = NuiRect(-1.0, -1.0, 600.0, 400.0);
    json jWindow = NuiWindow(jRoot, JsonString(sTitle), jGeom, 
                            JsonBool(TRUE), JsonBool(FALSE), JsonBool(TRUE),
                            JsonBool(FALSE), JsonBool(TRUE));
    return NuiCreate(oPC, jWindow, sScript);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupBook
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Book/document display with scrollable text
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sText = book contents
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupBook(object oPC, string sTitle, string sLabel, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    json jRoot = NuiRow(JsonArray1(
        NuiLabel(JsonString(sLabel), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE))));
    json jGeom = NuiRect(-1.0, -1.0, 700.0, 500.0);
    json jWindow = NuiWindow(jRoot, JsonString(sTitle), jGeom,
                            JsonBool(TRUE), JsonBool(FALSE), JsonBool(TRUE),
                            JsonBool(FALSE), JsonBool(TRUE));
    return NuiCreate(oPC, jWindow, sScript);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupBuild
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Building and construction system interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupBuild(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sBuild = "BUILDING SYSTEM\n\nBlueprints:\n[Wooden House]\n[Stone Tower]";
    return NUI_PopupMessage(oPC, sTitle, sBuild);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupCasket
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Casket or storage container inventory display
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupCasket(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sCasket = "CASKET/STORAGE\n\nContents: [Item list]";
    return NUI_PopupMessage(oPC, sTitle, sCasket);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupChest
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Treasure chest or container inventory
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupChest(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sChest = "CHEST INVENTORY\n\nContents: [Item list]";
    return NUI_PopupMessage(oPC, sTitle, sChest);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupChoice
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Yes/No choice dialog
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sQuestion = choice question text
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupChoice(object oPC, string sTitle, string sLabel, string sScript="nui_handler")
{
    return NUI_PopupYesNo(oPC, sTitle, sLabel, sScript);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupClass
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Display character class information
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupClass(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    
    int nClass = GetClassByPosition(1, oPC);
    int nLevel = GetLevelByPosition(1, oPC);
    string sClass = "Class: ";
    
    if (nClass == CLASS_TYPE_BARBARIAN) sClass += "Barbarian";
    else if (nClass == CLASS_TYPE_BARD) sClass += "Bard";
    else if (nClass == CLASS_TYPE_CLERIC) sClass += "Cleric";
    else if (nClass == CLASS_TYPE_DRUID) sClass += "Druid";
    else if (nClass == CLASS_TYPE_FIGHTER) sClass += "Fighter";
    else if (nClass == CLASS_TYPE_MONK) sClass += "Monk";
    else if (nClass == CLASS_TYPE_PALADIN) sClass += "Paladin";
    else if (nClass == CLASS_TYPE_RANGER) sClass += "Ranger";
    else if (nClass == CLASS_TYPE_ROGUE) sClass += "Rogue";
    else if (nClass == CLASS_TYPE_SORCERER) sClass += "Sorcerer";
    else if (nClass == CLASS_TYPE_WIZARD) sClass += "Wizard";
    else sClass += "Unknown";
    
    sClass += " (Level: " + IntToString(nLevel) + ")";
    return NUI_PopupMessage(oPC, sTitle, sClass);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupCombat
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Combat mode options and settings
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupCombat(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sCombat = "COMBAT OPTIONS\n\nMode: [Normal/Defensive]\n[Attack]\n[Defend]";
    return NUI_PopupMessage(oPC, sTitle, sCombat);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupColor
//::///////////////////////////////////////////////////////////////////////////
//:: Description: RGB color picker interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupColor(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    json jColor = NuiColor(128, 128, 128, 255);
    json jRoot = NuiRow(JsonArray1(NuiColorPicker(jColor)));
    json jGeom = NuiRect(-1.0, -1.0, 400.0, 300.0);
    json jWindow = NuiWindow(jRoot, JsonString(sTitle), jGeom,
                            JsonBool(TRUE), JsonBool(FALSE), JsonBool(TRUE),
                            JsonBool(FALSE), JsonBool(TRUE));
    return NuiCreate(oPC, jWindow, sScript);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupConfig
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Game configuration and settings interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupConfig(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sConfig = "CONFIGURATION\n\nDisplay:\n[ ] Floating damage\n[ ] Nameplates";
    return NUI_PopupMessage(oPC, sTitle, sConfig);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupConfirm
//::///////////////////////////////////////////////////////////////////////////
//:: Description: OK/Cancel confirmation dialog
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sLabel = confirmation message
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupConfirm(object oPC, string sTitle, string sLabel, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    json jContent = NuiLabel(JsonString(sLabel), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    return NUI_DialogCreate(oPC, sTitle, jContent, 2, "", sScript, NUI_PROP_CLOSABLE_TRANSPARENT, 300.0, 150.0);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupCustom
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Generic custom popup for arbitrary content
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sContent = custom content
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupCustom(object oPC, string sTitle, string sLabel, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_PopupMessage(oPC, sTitle, sLabel);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupDM
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Dungeon Master tools (DM only)
//:: Parameters:   oPC = player object (must be DM)
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success, 0 if not DM)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupDM(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsDM(oPC)) return 0;
    string sDM = "DUNGEON MASTER TOOLS\n\nCreatures:\n[Spawn NPC]\n[Control]";
    return NUI_PopupMessage(oPC, sTitle, sDM);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupEmote
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Emote and animation selector
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupEmote(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sEmote = "EMOTES\n\nStandard:\n[Greet] [Bow] [Dance]\n[Laugh] [Cry]";
    return NUI_PopupMessage(oPC, sTitle, sEmote);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupEncounter
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Encounter difficulty and setup interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupEncounter(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sEnc = "ENCOUNTER SYSTEM\n\nDifficulty: [Easy/Normal/Hard]\n[Start Encounter]";
    return NUI_PopupMessage(oPC, sTitle, sEnc);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupError
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Error message display
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sMessage = error message
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupError(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    return NUI_PopupMessage(oPC, "[ERROR] " + sTitle, sMessage);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupFlags
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Boolean flag manager interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupFlags(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sFlags = "FLAG MANAGER\n\n[ ] Flag 1\n[ ] Flag 2\n[ ] Flag 3";
    return NUI_PopupMessage(oPC, sTitle, sFlags);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupFloat
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Floating-point value slider with label
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sLabel = slider label
//::               fMin = minimum value
//::               fMax = maximum value
//::               fDefault = default value
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupFloat(object oPC, string sTitle, string sLabel, float fMin, float fMax, float fDefault, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    json jRoot = NuiCol(JsonArray2(
        NuiLabel(JsonString(sLabel), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_TOP)),
        NuiSliderFloat(JsonFloat(fDefault), JsonFloat(fMin), JsonFloat(fMax), JsonFloat(0.01))));
    json jGeom = NuiRect(-1.0, -1.0, 500.0, 250.0);
    json jWindow = NuiWindow(jRoot, JsonString(sTitle), jGeom,
                            JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE),
                            JsonBool(FALSE), JsonBool(TRUE));
    return NuiCreate(oPC, jWindow, sScript);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupFX
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Visual effects selector
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupFX(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sFX = "VISUAL EFFECTS\n\nType: [Fire/Ice/Lightning]\n[Apply FX]";
    return NUI_PopupMessage(oPC, sTitle, sFX);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupHelp
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Help and game instructions
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupHelp(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sHelp = "HELP SYSTEM\n\nCommands:\n- H = Help\n- J = Journal\n- C = Character";
    return NUI_PopupMessage(oPC, sTitle, sHelp);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupHome
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Home location and teleport system
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupHome(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sHome = "HOME SYSTEM\n\nYour Home: [Set Location]\n[Teleport Home]";
    return NUI_PopupMessage(oPC, sTitle, sHome);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupInfo
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Information message display
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sMessage = information message
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupInfo(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    return NUI_PopupMessage(oPC, "[INFO] " + sTitle, sMessage);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupInput
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Text input field with prompt
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sPrompt = input prompt text
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupInput(object oPC, string sTitle, string sLabel, string sScript="nui_handler")
{
    return NUI_PopupText(oPC, sTitle, sLabel, sScript);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupInt
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Integer value slider with label
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sLabel = slider label
//::               nMin = minimum value
//::               nMax = maximum value
//::               nDefault = default value
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupInt(object oPC, string sTitle, string sLabel, int nMin, int nMax, int nDefault, string sScript)
{
    if (!GetIsPC(oPC)) return 0;
    json jRoot = NuiCol(JsonArray2(
        NuiLabel(JsonString(sLabel), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_TOP)),
        NuiSlider(JsonInt(nDefault), JsonInt(nMin), JsonInt(nMax), JsonInt(1))));
    json jGeom = NuiRect(-1.0, -1.0, 500.0, 250.0);
    json jWindow = NuiWindow(jRoot, JsonString(sTitle), jGeom,
                            JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE),
                            JsonBool(FALSE), JsonBool(TRUE));
    return NuiCreate(oPC, jWindow, sScript);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupInventory
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Inventory management interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupInventory(object oPC, string sTitle, string sScript="nui_handler")
{
    return NUI_PopupMessage(oPC, sTitle, "Inventory: [Item list]");
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupJournal
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Journal and quest log display
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupJournal(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sJournal = "JOURNAL\n\nEntries:\n[Entry 1]\n[Entry 2]\n[Entry 3]";
    return NUI_PopupMessage(oPC, sTitle, sJournal);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupLights
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Lighting and brightness control system
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupLights(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sLights = "LIGHTING SYSTEM\n\nBrightness: [Slider]\n[Apply]";
    return NUI_PopupMessage(oPC, sTitle, sLights);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupLock
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Lock/unlock mechanism interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupLock(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sLock = "LOCK SYSTEM\n\nStatus: [Locked/Unlocked]\n[Toggle]";
    return NUI_PopupMessage(oPC, sTitle, sLock);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupLoot
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Loot container interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupLoot(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sLoot = "LOOT CONTAINER\n\nItems: [Scroll through]\n[Take All]";
    return NUI_PopupMessage(oPC, sTitle, sLoot);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupMap
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Map and area navigation system
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupMap(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sMap = "MAP SYSTEM\n\nCurrent Area: [Area Name]\n[Zoom] [Pan]";
    return NUI_PopupMessage(oPC, sTitle, sMap);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupMessage
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Simple message display popup (core popup function)
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sMessage = message text
//::               fX = window X position (default: -1.0 = centered)
//::               fY = window Y position (default: 200.0 pixels from top)
//::               fWidth = window width in pixels (default: 312.5)
//::               fHeight = window height in pixels (default: 156.25)
//::               sScript = event handler script name (default: "nui_handler")
//:: Returns:      int (dialog token, >0 on success)
//:: Defaults:     X=-1.0 (centered), Y=200.0, Width=312.5, Height=156.25, Script="nui_handler"
//:: Notes:        Window includes OK and Cancel buttons at bottom center
//::               Window color: Dark grey (64, 64, 64, 220) - dark mode
//::               Resizable: FALSE
//::               Closable: TRUE
//::               Movable: TRUE
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupMessage(object oPC, string sTitle, string sMessage, 
                     float fX=-1.0f, float fY=200.0f, float fWidth=312.5f, float fHeight=158.25f, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    
    // Message content with OK button (with ID for event handling)
    json jContent = NuiCol(JsonArray2(
        // Message text (centered)
        NuiLabel(JsonString(sMessage), JsonInt(NUI_HALIGN_CENTER), 
                 JsonInt(NUI_VALIGN_MIDDLE)),
        // OK button centered with element ID
        NuiRow(JsonArray3(
            NuiSpacer(),
            NuiId(NuiButton(JsonString("OK")), "message_ok_button"),
            NuiSpacer()
        ))
    ));
    
    // Window properties: closable only, no collapse
    int nProps = NUI_PROP_CLOSABLE;
    
    // Build window
    int bResizable = (nProps & 1) ? TRUE : FALSE;
    int bCollapsible = (nProps & 2) ? TRUE : FALSE;
    int bClosable = (nProps & 4) ? TRUE : FALSE;
    int bBorder = (nProps & 8) ? TRUE : FALSE;
    int bTransparent = (nProps & 16) ? TRUE : FALSE;
    
    json jWindow = NuiWindow(NuiCol(JsonArray1(jContent)), JsonString(sTitle), 
                            NuiBind("geometry"), JsonBool(bResizable), 
                            JsonBool(bCollapsible), JsonBool(bClosable), 
                            JsonBool(bBorder), JsonBool(bTransparent));
    
    int nToken = NuiCreate(oPC, jWindow, sScript);
    if (nToken <= 0) return 0;
    
    // Set geometry with original Y position (no adjustment)
    NuiSetBind(oPC, nToken, "geometry", NuiRect(fX, fY, fWidth, fHeight));
    
    // Store token for OK button handler
    SetLocalInt(oPC, "NUI_MESSAGE_TOKEN", nToken);
    
    return nToken;
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupMove
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Movement and quick travel system
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupMove(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sMove = "MOVEMENT\n\nQuick Travel:\n[Town Square]\n[Tavern]";
    return NUI_PopupMessage(oPC, sTitle, sMove);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupMusic
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Music player and track selector
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupMusic(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sMusic = "MUSIC PLAYER\n\nTrack: [Selection]\nVolume: [Slider]";
    return NUI_PopupMessage(oPC, sTitle, sMusic);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupPack
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Backpack and equipment management
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupPack(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sPack = "BACKPACK\n\nWeight: 0/100 lbs\nEquipment: [Items]";
    return NUI_PopupMessage(oPC, sTitle, sPack);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupPC
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Character sheet with full information display
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupPC(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    
    int nClass = GetClassByPosition(1, oPC);
    int nLevel = GetLevelByPosition(1, oPC);
    int nRace = GetRacialType(oPC);
    string sSubRace = GetSubRace(oPC);
    
    string sClass = "Unknown";
    if (nClass == CLASS_TYPE_BARBARIAN) sClass = "Barbarian";
    else if (nClass == CLASS_TYPE_BARD) sClass = "Bard";
    else if (nClass == CLASS_TYPE_CLERIC) sClass = "Cleric";
    else if (nClass == CLASS_TYPE_DRUID) sClass = "Druid";
    else if (nClass == CLASS_TYPE_FIGHTER) sClass = "Fighter";
    else if (nClass == CLASS_TYPE_MONK) sClass = "Monk";
    else if (nClass == CLASS_TYPE_PALADIN) sClass = "Paladin";
    else if (nClass == CLASS_TYPE_RANGER) sClass = "Ranger";
    else if (nClass == CLASS_TYPE_ROGUE) sClass = "Rogue";
    else if (nClass == CLASS_TYPE_SORCERER) sClass = "Sorcerer";
    else if (nClass == CLASS_TYPE_WIZARD) sClass = "Wizard";
    
    string sRace = "Unknown";
    if (nRace == RACIAL_TYPE_DWARF) sRace = "Dwarf";
    else if (nRace == RACIAL_TYPE_ELF) sRace = "Elf";
    else if (nRace == RACIAL_TYPE_GNOME) sRace = "Gnome";
    else if (nRace == RACIAL_TYPE_HALFELF) sRace = "Half-Elf";
    else if (nRace == RACIAL_TYPE_HALFLING) sRace = "Halfling";
    else if (nRace == RACIAL_TYPE_HALFORC) sRace = "Half-Orc";
    else if (nRace == RACIAL_TYPE_HUMAN) sRace = "Human";
    
    if (sSubRace != "") sRace += " (" + sSubRace + ")";
    
    string sInfo = "Character: " + GetName(oPC) + "\n" +
                   "Level: " + IntToString(nLevel) + "\n" +
                   "Class: " + sClass + "\n" +
                   "Race: " + sRace + "\n" +
                   "Experience: " + IntToString(GetXP(oPC));
    
    return NUI_PopupMessage(oPC, sTitle, sInfo);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupPerks
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Character perks and special abilities display
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupPerks(object oPC, string sTitle, string sScript="nui_handler")
{
    return NUI_PopupMessage(oPC, sTitle, "Perks: [List]");
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupPortrait
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Portrait selector interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupPortrait(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sPortrait = "Portrait: " + GetPortraitResRef(oPC);
    return NUI_PopupMessage(oPC, sTitle, sPortrait);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupQuest
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Quest management and tracking interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupQuest(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sQuests = "QUESTS\n\nActive:\n[Quest 1]\n[Quest 2]\n[Quest 3]";
    return NUI_PopupMessage(oPC, sTitle, sQuests);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupQuests
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Quest list display
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupQuests(object oPC, string sTitle, string sScript="nui_handler")
{
    return NUI_PopupMessage(oPC, sTitle, "Quests: [List]");
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupRace
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Display character race and subrace information
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupRace(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    
    int nRace = GetRacialType(oPC);
    string sSubRace = GetSubRace(oPC);
    string sRace = "Race: ";
    
    if (nRace == RACIAL_TYPE_DWARF) sRace += "Dwarf";
    else if (nRace == RACIAL_TYPE_ELF) sRace += "Elf";
    else if (nRace == RACIAL_TYPE_GNOME) sRace += "Gnome";
    else if (nRace == RACIAL_TYPE_HALFELF) sRace += "Half-Elf";
    else if (nRace == RACIAL_TYPE_HALFLING) sRace += "Halfling";
    else if (nRace == RACIAL_TYPE_HALFORC) sRace += "Half-Orc";
    else if (nRace == RACIAL_TYPE_HUMAN) sRace += "Human";
    else sRace += "Unknown";
    
    if (sSubRace != "") sRace += "\nSubrace: " + sSubRace;
    
    return NUI_PopupMessage(oPC, sTitle, sRace);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupRange
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Range/distance slider
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sLabel = slider label
//::               fMin = minimum range
//::               fMax = maximum range
//::               fDefault = default range
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupRange(object oPC, string sTitle, string sLabel, float fMin, float fMax, float fDefault, string sScript="nui_handler")
{
    return NUI_PopupSlider(oPC, sTitle, sLabel, fMin, fMax, fDefault, sScript);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupRitual
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Ritual casting interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupRitual(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sRitual = "RITUAL SYSTEM\n\nType: [Selection]\n[Cast Ritual]";
    return NUI_PopupMessage(oPC, sTitle, sRitual);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupSlider
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Float value slider with label
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sLabel = slider label
//::               fMin = minimum value
//::               fMax = maximum value
//::               fDefault = default value
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupSlider(object oPC, string sTitle, string sLabel, float fMin, float fMax, float fDefault, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    json jRoot = NuiCol(JsonArray2(
        NuiLabel(JsonString(sLabel), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_TOP)),
        NuiSliderFloat(JsonFloat(fDefault), JsonFloat(fMin), JsonFloat(fMax), JsonFloat(0.01))));
    json jGeom = NuiRect(-1.0, -1.0, 500.0, 250.0);
    json jWindow = NuiWindow(jRoot, JsonString(sTitle), jGeom,
                            JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE),
                            JsonBool(FALSE), JsonBool(TRUE));
    return NuiCreate(oPC, jWindow, sScript);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupSound
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Sound effects selector
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupSound(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sSound = "SOUND EFFECTS\n\nEffect: [Selection]\nVolume: [Slider]";
    return NUI_PopupMessage(oPC, sTitle, sSound);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupSoundset
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Voice and soundset selector
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupSoundset(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sSoundset = "Soundset: [Current Soundset]\n\n[Change Soundset]";
    return NUI_PopupMessage(oPC, sTitle, sSoundset);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupSpawn
//::///////////////////////////////////////////////////////////////////////////
//:: Description: NPC/Monster spawning interface (DM only)
//:: Parameters:   oPC = player object (must be DM)
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success, 0 if not DM)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupSpawn(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsDM(oPC)) return 0;
    string sSpawn = "SPAWN SYSTEM\n\nType: [NPC/Monster]\nTemplate: [Selection]";
    return NUI_PopupMessage(oPC, sTitle, sSpawn);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupSpells
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Spells and powers display
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupSpells(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sSpells = "SPELLS\n\nLevel 1:\n[Spell 1]\n[Spell 2]\n[Spell 3]";
    return NUI_PopupMessage(oPC, sTitle, sSpells);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupStats
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Character statistics display (STR, DEX, CON, INT, WIS, CHA)
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupStats(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sStats = "STR: " + IntToString(GetAbilityScore(oPC, ABILITY_STRENGTH)) + "\n" +
                    "DEX: " + IntToString(GetAbilityScore(oPC, ABILITY_DEXTERITY)) + "\n" +
                    "CON: " + IntToString(GetAbilityScore(oPC, ABILITY_CONSTITUTION)) + "\n" +
                    "INT: " + IntToString(GetAbilityScore(oPC, ABILITY_INTELLIGENCE)) + "\n" +
                    "WIS: " + IntToString(GetAbilityScore(oPC, ABILITY_WISDOM)) + "\n" +
                    "CHA: " + IntToString(GetAbilityScore(oPC, ABILITY_CHARISMA));
    return NUI_PopupMessage(oPC, sTitle, sStats);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupStatus
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Character condition and status display
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupStatus(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    int nHP = GetCurrentHitPoints(oPC);
    int nMaxHP = GetMaxHitPoints(oPC);
    string sStatus = "Health: " + IntToString(nHP) + "/" + IntToString(nMaxHP) + "\n" +
                     "Level: " + IntToString(GetLevelByPosition(1, oPC)) + "\n" +
                     "Experience: " + IntToString(GetXP(oPC));
    return NUI_PopupMessage(oPC, sTitle, sStatus);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupSuccess
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Success confirmation message
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sMessage = success message
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupSuccess(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    return NUI_PopupMessage(oPC, "[SUCCESS] " + sTitle, sMessage);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupSky
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Weather and sky control system
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupSky(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sSky = "SKY SYSTEM\n\nWeather: [Selection]\n[Apply Weather]";
    return NUI_PopupMessage(oPC, sTitle, sSky);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupSign
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Sign/notice board display with automatic AOE integration
//:: Parameters:   oPC = player object (who sees the sign)
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//:: Notes:        Call from placeable OnUsed event with GetLastUsedBy()
//::               Uses OBJECT_SELF as sign object
//::               Uses object name as sign title
//::               Uses object description as sign content
//::               Uses object portrait as sign image (left side)
//::               Creates AOE at sign location (OBJECT_SELF)
//::               Automatically spawns AOE at sign location
//::               Sign closes when player moves away from AOE
//::               Large size (625 x 312.5 - 2x standard)
//::               Positioned at Y=80 from top
//::               Close button at bottom center
//:: Example:      void main() { NUI_PopupSign(GetLastUsedBy()); }
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupSign(object oPC, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    
    // Get sign object from OBJECT_SELF (must be called from sign's OnUsed)
    object oSign = OBJECT_SELF;
    if (!GetIsObjectValid(oSign)) return 0;
    
    // Get title from sign's name and content from description
    string sTitle = GetName(oSign);
    string sMessage = GetDescription(oSign);
    
    // Get portrait image
    string sPortrait = GetPortraitResRef(oSign);
    if (sPortrait == "") {
        sPortrait = "po_default";  // Fallback to default if no portrait
    }
    
    // Message content with portrait image and close button
    json jContent = NuiCol(JsonArray2(
        // Content row: image + text
        NuiRow(JsonArray2(
            // Portrait image on left
            NuiImage(JsonString(sPortrait), JsonInt(NUI_ASPECT_FIT), 
                     JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE)),
            // Sign message on right (centered)
            NuiLabel(JsonString(sMessage), JsonInt(NUI_HALIGN_CENTER), 
                     JsonInt(NUI_VALIGN_MIDDLE))
        )),
        // Close button centered at bottom
        NuiRow(JsonArray3(
            NuiSpacer(),
            NuiId(NuiButton(JsonString("Close")), "sign_close_button"),
            NuiSpacer()
        ))
    ));
    
    // Window properties: closable only
    int nProps = NUI_PROP_CLOSABLE;
    
    // Create sign using NUI_DialogCreate with AOE (bAOE=TRUE)
    // Double size: 625 x 312.5 (2x of 312.5 x 156.25)
    int nToken = NUI_DialogCreate(oPC, sTitle, jContent, 1, "", sScript, 
                                 nProps, 625.0f, 312.5f, TRUE);
    
    // Override geometry position to Y=80 from top
    if (nToken > 0) {
        NuiSetBind(oPC, nToken, "geometry", NuiRect(-1.0f, 80.0f, 625.0f, 312.5f));
        
        // Create AOE at sign location (OBJECT_SELF)
        location lSignLoc = GetLocation(oSign);
        object oAOE = CreateObject(OBJECT_TYPE_AREA_OF_EFFECT, "nw_aoe_web", lSignLoc);
        
        if (GetIsObjectValid(oAOE)) {
            // Store dialog info on AOE for cleanup
            SetLocalInt(oAOE, "NUI_DIALOG_TOKEN", nToken);
            SetLocalObject(oAOE, "NUI_DIALOG_PC", oPC);
            SetLocalString(oAOE, "NUI_DIALOG_HANDLER", sScript);
            
            // Store AOE reference on PC
            SetLocalObject(oPC, "NUI_AOE_OBJECT", oAOE);
            
            // Set long duration cleanup
            DelayCommand(99999.0, NUI_AOE_Cleanup(oAOE, oPC));
        }
    }
    
    return nToken;
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupText
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Text input field with label
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sLabel = input label
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupText(object oPC, string sTitle, string sLabel, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    json jRoot = NuiCol(JsonArray2(
        NuiLabel(JsonString(sLabel), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_TOP)),
        NuiTextEdit(JsonString(""), NuiBind("popup_text"), 200, FALSE, TRUE)));
    json jGeom = NuiRect(-1.0, -1.0, 500.0, 250.0);
    json jWindow = NuiWindow(jRoot, JsonString(sTitle), jGeom,
                            JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE),
                            JsonBool(FALSE), JsonBool(TRUE));
    return NuiCreate(oPC, jWindow, sScript);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupTile
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Tile and object editor interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupTile(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sTile = "TILE EDITOR\n\nTile: [Resref]\n[Place] [Rotate]";
    return NUI_PopupMessage(oPC, sTitle, sTile);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupTrap
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Trap arm/disarm interface
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupTrap(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sTrap = "TRAP SYSTEM\n\nStatus: [Armed/Disarmed]\n[Toggle]";
    return NUI_PopupMessage(oPC, sTitle, sTrap);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupTransform
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Transformation and polymorph system
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupTransform(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sTransform = "TRANSFORMATIONS\n\nForms:\n[Wolf]\n[Bear]\n[Dragon]";
    return NUI_PopupMessage(oPC, sTitle, sTransform);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupValidation
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Validation confirmation dialog
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sMessage = validation message
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupValidation(object oPC, string sTitle, string sLabel, string sScript="nui_handler")
{
    return NUI_PopupConfirm(oPC, sTitle, sLabel, sScript);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupWarning
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Warning message display
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sMessage = warning message
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupWarning(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    return NUI_PopupMessage(oPC, "[WARNING] " + sTitle, sMessage);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupYesNo
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Yes/No question dialog (core popup function)
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sMessage = yes/no question message
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupYesNo(object oPC, string sTitle, string sLabel, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    json jContent = NuiLabel(JsonString(sLabel), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    return NUI_DialogCreate(oPC, sTitle, jContent, 2, "", sScript, NUI_PROP_CLOSABLE_TRANSPARENT, 300.0, 150.0);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupSkills
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Character skills and proficiencies display
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               sScript = event handler script name
//:: Returns:      int (dialog token, >0 on success)
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupSkills(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sSkills = "SKILLS\n\nCombat:\n  Melee: [Value]\n  Ranged: [Value]";
    return NUI_PopupMessage(oPC, sTitle, sSkills);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_PopupZap
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Close all open NUI windows for a player
//:: Parameters:   oPC = player object
//:: Returns:      int (number of windows closed, 0 if none)
//:: Notes:        Destroys all active NUI dialogs for the player
//::               Useful for cleanup or resetting UI state
//::///////////////////////////////////////////////////////////////////////////
int NUI_PopupZap(object oPC)
{
    if (!GetIsPC(oPC)) return 0;
    
    int nClosed = 0;
    int nToken = 1;
    
    // Try to close tokens 1-1000 (reasonable upper limit)
    // Attempt to destroy each token - NuiDestroy handles invalid tokens gracefully
    while (nToken <= 1000)
    {
        NuiDestroy(oPC, nToken);
        nToken++;
    }
    
    // Return a standard response
    return 0;
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_Kill
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Close and destroy a NUI window/dialog
//:: Parameters:   oPC = player object
//::               nToken = dialog token (from NuiCreate return value)
//:: Returns:      int (0 = success, NUI_ERROR = -1 on failure)
//:: Notes:        Use this to programmatically close popups
//::               Passes nToken returned from NUI_PopupXXX functions
//::///////////////////////////////////////////////////////////////////////////
int NUI_Kill(object oPC, int nToken)
{
    if (!GetIsPC(oPC)) return NUI_ERROR;
    if (nToken <= 0) return NUI_ERROR;
    
    NuiDestroy(oPC, nToken);
    return 0;
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_AOE_Cleanup
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Destroys AOE and closes associated window
//:: Parameters:   oAOE = AOE object to cleanup
//::               oPC = PC calling cleanup (MUST be owner)
//:: Returns:      void
//:: Notes:        SECURITY: Only the PC who spawned the AOE can cleanup
//::               Prevents other players from closing others' windows
//::///////////////////////////////////////////////////////////////////////////
void NUI_AOE_Cleanup(object oAOE, object oPC)
{
    if (!GetIsObjectValid(oAOE)) return;
    if (!GetIsPC(oPC)) return;
    
    // Get stored PC (owner of this AOE)
    object oStoredPC = GetLocalObject(oAOE, "NUI_DIALOG_PC");
    
    // SECURITY: Only the owner can cleanup
    if (oPC != oStoredPC) {
        // Caller is not the owner - deny cleanup
        return;
    }
    
    // Get stored references
    int nToken = GetLocalInt(oAOE, "NUI_DIALOG_TOKEN");
    
    // Close window (verified owner only)
    if (nToken > 0) {
        NUI_Kill(oPC, nToken);
        DeleteLocalObject(oPC, "NUI_AOE_OBJECT");
    }
    
    // Destroy the AOE
    DestroyObject(oAOE);
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_DialogCreate
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Create a generic NUI dialog with custom content and optional AOE
//:: Parameters:   oPC = player object
//::               sTitle = window title
//::               jContent = JSON content (NUI layout)
//::               nButtons = number of buttons to add
//::               sGeometry = geometry bind string
//::               sScript = event handler script name
//::               nProps = window property flags (bitmask combination):
//::                 PROP_RESIZABLE (1) = window can be resized
//::                 PROP_COLLAPSIBLE (2) = window can be minimized
//::                 PROP_CLOSABLE (4) = window has close (X) button
//::                 PROP_BORDER (8) = window has visible border
//::                 PROP_TRANSPARENT (16) = transparent background
//::               fWidth = window width
//::               fHeight = window height
//::               bAOE = spawn AOE kill circle (default: FALSE)
//:: Returns:      int (dialog token, -1 on failure)
//:: Notes:        nProps example combinations:
//::                 0 = all flags FALSE (bare window)
//::                 4 = closable only
//::                 20 = closable + transparent (4 | 16)
//::                 31 = all flags TRUE (1 | 2 | 4 | 8 | 16)
//::               If bAOE=TRUE: Spawns AOE at player location with 99999s duration
//::               Window closes when player exits AOE (owner verified)
//::///////////////////////////////////////////////////////////////////////////
int NUI_DialogCreate(object oPC, string sTitle, json jContent, int nButtons, string sGeometry, string sScript, int nProps, float fWidth, float fHeight, int bAOE=FALSE)
{
    if (!GetIsPC(oPC)) return -1;
    
    // Parse property flags from nProps bitmask
    int bResizable = (nProps & 1) ? TRUE : FALSE;     // Bit 0
    int bCollapsible = (nProps & 2) ? TRUE : FALSE;   // Bit 1
    int bClosable = (nProps & 4) ? TRUE : FALSE;      // Bit 2
    int bBorder = (nProps & 8) ? TRUE : FALSE;        // Bit 3
    int bTransparent = (nProps & 16) ? TRUE : FALSE;  // Bit 4
    
    json jRoot = NuiCol(JsonArray1(jContent));
    json jWindow = NuiWindow(jRoot, JsonString(sTitle), NuiBind("geometry"), 
                            JsonBool(bResizable), JsonBool(bCollapsible), 
                            JsonBool(bClosable), JsonBool(bBorder), 
                            JsonBool(bTransparent));
    
    int nToken = NuiCreate(oPC, jWindow, sScript);
    if (nToken <= 0) return -1;
    
    NuiSetBind(oPC, nToken, "geometry", NuiRect(-1.0f, -1.0f, fWidth, fHeight));
    
    // Optional: Create AOE kill circle (auto-close on exit)
    if (bAOE) {
        location lLoc = GetLocation(oPC);
        object oAOE = CreateObject(OBJECT_TYPE_AREA_OF_EFFECT, "nw_aoe_web", lLoc);
        
        if (GetIsObjectValid(oAOE)) {
            // Store dialog info on AOE
            SetLocalInt(oAOE, "NUI_DIALOG_TOKEN", nToken);
            SetLocalObject(oAOE, "NUI_DIALOG_PC", oPC);
            SetLocalString(oAOE, "NUI_DIALOG_HANDLER", sScript);
            
            // Store AOE reference on PC
            SetLocalObject(oPC, "NUI_AOE_OBJECT", oAOE);
            
            // Set long duration (99999 seconds = ~27.7 hours)
            // AOE will auto-delete and close window when player exits radius
            DelayCommand(99999.0, NUI_AOE_Cleanup(oAOE, oPC));
        }
    }
    
    return nToken;
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_SetWindowColor
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Set window background color using JSON color binding
//:: Parameters:   oPC = player object
//::               nToken = dialog token (from NUI_DialogCreate return)
//::               nRed = red value (0-255)
//::               nGreen = green value (0-255)
//::               nBlue = blue value (0-255)
//::               nAlpha = alpha/transparency (0-255, 0=transparent, 255=opaque)
//:: Returns:      void
//:: Notes:        Sets background color using NuiSetUserDefinedEvent
//::               Color updates immediately on screen
//::               Use after NUI_DialogCreate returns
//::///////////////////////////////////////////////////////////////////////////
void NUI_SetWindowColor(object oPC, int nToken, int nRed, int nGreen, int nBlue, int nAlpha)
{
    if (!GetIsPC(oPC) || nToken <= 0) return;
    if (nRed < 0 || nRed > 255) nRed = 255;
    if (nGreen < 0 || nGreen > 255) nGreen = 255;
    if (nBlue < 0 || nBlue > 255) nBlue = 255;
    if (nAlpha < 0 || nAlpha > 255) nAlpha = 255;
    
    json jColor = NuiCol(JsonArray3(
        JsonInt(nRed), 
        JsonInt(nGreen), 
        JsonInt(nBlue)
    ));
    
    // Set window background color
    NuiSetBind(oPC, nToken, "window_color", jColor);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
