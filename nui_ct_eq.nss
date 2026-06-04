//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - Custom Tailoring
//:: nui_ct_equip.nss
//::///////////////////////////////////////////////////////////////////////

/* ==================================================================== */
/*  PUBLIC NUI_* FUNCTION DECLARATIONS                                 */
/* ==================================================================== */


/*
    SYNOPSIS
        Equipment tailoring menu. The player recolors and restyles armor
        parts, cloaks, helmets, shields, and weapons across the standard
        material color channels. Selections are tracked per player so the
        menu can step between part, color, and item modes.

    DEPENDENCIES
        nui_framework (self-contained; defines its own tailoring constants)

    USAGE
        #include "nui_ct_equip"
        void main() { NUI_CtEquipOpen(GetItemActivator()); }

    EXAMPLE (beginner)
        // Open the tailoring menu.
        NUI_CtEquipOpen(oPC);

    EXAMPLE (intermediate)
        // Name color channel 5 (Metal 1).
        string s = GetTokenByPosition(CT_COLORS, "+", 4);

    EXAMPLE (advanced)
        // Read the part the player is editing.
        int nPart = GetLocalInt(oPC, VAR_CT_PART);
*/
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////

//::///////////////////////////////////////////////////////////////////////
//:: Author:  Carcerian
//:: Version: 1.0
//:: Created: May 31, 2026
//:: MODIFIED: June 5, 2026 - Production release
//::///////////////////////////////////////////////////////////////////////

#include "nui_api"

// Dialog type
const int NUI_DIALOG_CT_EQUIP = 60;

// Window ID
const string NUI_CT_WINDOW_ID = "nui_ct_equip";
const string NUI_CT_EVENT_SCRIPT = "nui_ct_equip_evt";

// Body part labels (19 parts: 0-18) - pipe-delimited
const string CT_PARTS = "Right Foot+Left Foot+Right Shin+Left Shin+Right Thigh+Left Thigh+Pelvis+Torso+Belt+Neck+Right Forearm+Left Forearm+Right Bicep+Left Bicep+Right Shoulder+Left Shoulder+Right Hand+Left Hand+Robe";

// Item type names - pipe-delimited
const string CT_ITEMS = "Cloak+Helmet+Shield+Weapon";

// Color type names - pipe-delimited
const string CT_COLORS = "Leather 1+Leather 2+Cloth 1+Cloth 2+Metal 1+Metal 2+Leather (Composite)+Cloth (Composite)+Metal (Composite)+Leather+Cloth+All Materials";

// Local variable names
const string VAR_CT_MODE = "NUI_CT_MODE";
const string VAR_CT_PART = "NUI_CT_PART";
const string VAR_CT_ITEM = "NUI_CT_ITEM";
const string VAR_CT_COLOR = "NUI_CT_COLOR";
const string VAR_CT_WEAP_PART = "NUI_CT_WEAP_PART";

// Modes
const int NUI_CT_MODE_MAIN = 1;
const int NUI_CT_MODE_PART = 2;
const int NUI_CT_MODE_COLOR = 3;
const int NUI_CT_MODE_ITEM = 4;
const int NUI_CT_MODE_WEAPON = 5;

// Open the main equipment tailoring panel
void NUI_CtEquipOpen(object oPC)
{
    if (!GetIsPC(oPC)) return;

    json jButtons = JsonArray();
    
    string sCategories = "Body Parts+Colors+Items+Weapons+Mirror/Reset+Gender+Copy Design";
    
    int i = 0;
    while (i < 7)
    {
        string sCategory = GetTokenByPosition(sCategories, "+", i);
        json jBtn = NuiButton(JsonString(sCategory));
        jBtn = NuiId(jBtn, "category_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 28.0);
        jButtons = JsonArrayInsert(jButtons, jBtn);
        i = i + 1;
    }

    json jTitle = NuiLabel(JsonString("Equipment Tailoring"),
                           NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jTitle = NuiHeight(jTitle, 24.0);

    json jInfo = NuiText(JsonString("Customize your equipment appearance.\nSelect a category to begin."));
    jInfo = NuiHeight(jInfo, 60.0);

    json jGroup = NuiGroup(JsonArray(jButtons), TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiHeight(jGroup, 250.0);

    json jContent = JsonArray3(
        JsonArray1(jTitle),
        jInfo,
        jGroup
    );

    int nToken = NUI_DialogCreate(oPC, "Equipment Tailor", jContent,
                                  "", NUI_BTN_CANCEL, NUI_PLACE_BELOW,
                                  "", "nui_ct_equip_evt", 0, 450.0, 420.0);

    SetLocalInt(oPC, "NUI_DIALOG_TYPE", NUI_DIALOG_CT_EQUIP);
    SetLocalInt(oPC, VAR_CT_MODE, NUI_CT_MODE_MAIN);
}

// Open body part selector
void NUI_CtPartSelectorOpen(object oPC)
{
    if (!GetIsPC(oPC)) return;

    json jPartBtns = JsonArray();
    int i = 0;
    
    while (i < 19)
    {
        string sPart = GetTokenByPosition(CT_PARTS, "+", i);
        json jBtn = NuiButton(JsonString(sPart));
        jBtn = NuiId(jBtn, "part_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 24.0);
        jPartBtns = JsonArrayInsert(jPartBtns, jBtn);
        i = i + 1;
    }

    json jGroup = NuiGroup(jPartBtns, TRUE, NUI_SCROLLBARS_BOTH);
    jGroup = NuiHeight(jGroup, 350.0);

    json jContent = JsonArray1(jGroup);

    int nToken = NUI_DialogCreate(oPC, "Select Body Part", jContent,
                                  "", NUI_BTN_CANCEL, NUI_PLACE_BELOW,
                                  "", "nui_ct_equip_evt", 0, 400.0, 450.0);

    SetLocalInt(oPC, VAR_CT_MODE, NUI_CT_MODE_PART);
}

// Open part adjustment dialog
void NUI_CtPartAdjustOpen(object oPC, int nPart)
{
    if (!GetIsPC(oPC)) return;

    json jLabel = NuiLabel(JsonString("Adjust: " + GetTokenByPosition(CT_PARTS, "+", nPart)),
                           NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jLabel = NuiHeight(jLabel, 24.0);

    json jBtns = JsonArray();
    
    string sControls = "< Previous Model+Next Model >+Mirror+Strip";
    
    int i = 0;
    while (i < 4)
    {
        string sControl = GetTokenByPosition(sControls, "+", i);
        json jBtn = NuiButton(JsonString(sControl));
        jBtn = NuiId(jBtn, "part_control_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 28.0);
        jBtns = JsonArrayInsert(jBtns, jBtn);
        i = i + 1;
    }

    json jGroup = NuiGroup(jBtns, TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiHeight(jGroup, 150.0);

    json jContent = JsonArray2(jLabel, jGroup);

    int nToken = NUI_DialogCreate(oPC, "Part Controls", jContent,
                                  "Back|Cancel", NUI_BTN_BACK + NUI_BTN_CANCEL, NUI_PLACE_SIDES,
                                  "", "nui_ct_equip_evt", 0, 380.0, 250.0);

    SetLocalInt(oPC, VAR_CT_PART, nPart);
    SetLocalInt(oPC, VAR_CT_MODE, NUI_CT_MODE_PART);
}

// Open color selector
void NUI_CtColorSelectorOpen(object oPC)
{
    if (!GetIsPC(oPC)) return;

    json jColorBtns = JsonArray();
    int i = 0;
    
    while (i < 11)
    {
        json jBtn = NuiButton(JsonString(GetTokenByPosition(CT_COLORS, "+", i)));
        jBtn = NuiId(jBtn, "color_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 24.0);
        jColorBtns = JsonArrayInsert(jColorBtns, jBtn);
        i = i + 1;
    }

    json jGroup = NuiGroup(jColorBtns, TRUE, NUI_SCROLLBARS_BOTH);
    jGroup = NuiHeight(jGroup, 350.0);

    json jContent = JsonArray1(jGroup);

    int nToken = NUI_DialogCreate(oPC, "Select Color Type", jContent,
                                  "", NUI_BTN_CANCEL, NUI_PLACE_BELOW,
                                  "", "nui_ct_equip_evt", 0, 400.0, 450.0);

    SetLocalInt(oPC, VAR_CT_MODE, NUI_CT_MODE_COLOR);
}

// Open color adjustment dialog
void NUI_CtColorAdjustOpen(object oPC, int nColor)
{
    if (!GetIsPC(oPC)) return;

    string sColor = GetTokenByPosition(CT_COLORS, "+", nColor);
    json jLabel = NuiLabel(JsonString("Color: " + sColor),
                           NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jLabel = NuiHeight(jLabel, 24.0);

    json jBtns = JsonArray();
    
    string sControls = "< Previous+Next >";
    int i = 0;
    while (i < 2)
    {
        string sControl = GetTokenByPosition(sControls, "+", i);
        json jBtn = NuiButton(JsonString(sControl));
        jBtn = NuiId(jBtn, "color_control_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 28.0);
        jBtns = JsonArrayInsert(jBtns, jBtn);
        i = i + 1;
    }

    json jGroup = NuiGroup(jBtns, TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiHeight(jGroup, 80.0);

    json jContent = JsonArray2(jLabel, jGroup);

    int nToken = NUI_DialogCreate(oPC, "Color Controls", jContent,
                                  "Back|Cancel", NUI_BTN_BACK + NUI_BTN_CANCEL, NUI_PLACE_SIDES,
                                  "", "nui_ct_equip_evt", 0, 380.0, 200.0);

    SetLocalInt(oPC, VAR_CT_COLOR, nColor);
    SetLocalInt(oPC, VAR_CT_MODE, NUI_CT_MODE_COLOR);
}

// Open item selector
void NUI_CtItemSelectorOpen(object oPC)
{
    if (!GetIsPC(oPC)) return;

    json jItemBtns = JsonArray();
    int i = 0;
    
    while (i < 4)
    {
        json jBtn = NuiButton(JsonString(GetTokenByPosition(CT_ITEMS, "+", i)));
        jBtn = NuiId(jBtn, "item_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 28.0);
        jItemBtns = JsonArrayInsert(jItemBtns, jBtn);
        i = i + 1;
    }

    json jGroup = NuiGroup(jItemBtns, TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiHeight(jGroup, 150.0);

    json jContent = JsonArray1(jGroup);

    int nToken = NUI_DialogCreate(oPC, "Select Item Type", jContent,
                                  "", NUI_BTN_CANCEL, NUI_PLACE_BELOW,
                                  "", "nui_ct_equip_evt", 0, 350.0, 250.0);

    SetLocalInt(oPC, VAR_CT_MODE, NUI_CT_MODE_ITEM);
}

// Open item adjustment dialog
void NUI_CtItemAdjustOpen(object oPC, int nItem)
{
    if (!GetIsPC(oPC)) return;

    string sItem = GetTokenByPosition(CT_ITEMS, "+", nItem);
    json jLabel = NuiLabel(JsonString("Adjust: " + sItem),
                           NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jLabel = NuiHeight(jLabel, 24.0);

    json jBtns = JsonArray();
    
    string sControls = "< Previous Style+Next Style >+Equip+Unequip";
    int i = 0;
    while (i < 4)
    {
        json jBtn = NuiButton(JsonString(GetTokenByPosition(sControls, "+", i)));
        jBtn = NuiId(jBtn, "item_control_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 28.0);
        jBtns = JsonArrayInsert(jBtns, jBtn);
        i = i + 1;
    }

    json jGroup = NuiGroup(jBtns, TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiHeight(jGroup, 150.0);

    json jContent = JsonArray2(jLabel, jGroup);

    int nToken = NUI_DialogCreate(oPC, "Item Controls", jContent,
                                  "Back|Cancel", NUI_BTN_BACK + NUI_BTN_CANCEL, NUI_PLACE_SIDES,
                                  "", "nui_ct_equip_evt", 0, 380.0, 250.0);

    SetLocalInt(oPC, VAR_CT_ITEM, nItem);
    SetLocalInt(oPC, VAR_CT_MODE, NUI_CT_MODE_ITEM);
}

// Open weapon part selector
void NUI_CtWeaponPartSelectorOpen(object oPC)
{
    if (!GetIsPC(oPC)) return;

    json jBtns = JsonArray();
    
    string sParts = "Top Part+Middle Part+Bottom Part";
    int i = 0;
    while (i < 3)
    {
        json jBtn = NuiButton(JsonString(GetTokenByPosition(sParts, "+", i)));
        jBtn = NuiId(jBtn, "weap_part_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 28.0);
        jBtns = JsonArrayInsert(jBtns, jBtn);
        i = i + 1;
    }

    json jGroup = NuiGroup(jBtns, TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiHeight(jGroup, 120.0);

    json jContent = JsonArray1(jGroup);

    int nToken = NUI_DialogCreate(oPC, "Select Weapon Part", jContent,
                                  "", NUI_BTN_CANCEL, NUI_PLACE_BELOW,
                                  "", "nui_ct_equip_evt", 0, 350.0, 220.0);

    SetLocalInt(oPC, VAR_CT_MODE, NUI_CT_MODE_WEAPON);
}

// Open weapon part adjustment
void NUI_CtWeaponPartAdjustOpen(object oPC, int nWeapPart)
{
    if (!GetIsPC(oPC)) return;

    string sPartLabel = "Part " + IntToString(nWeapPart);
    if (nWeapPart == 0) sPartLabel = "Top";
    else if (nWeapPart == 1) sPartLabel = "Middle";
    else if (nWeapPart == 2) sPartLabel = "Bottom";

    json jLabel = NuiLabel(JsonString("Weapon: " + sPartLabel),
                           NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jLabel = NuiHeight(jLabel, 24.0);

    json jBtns = JsonArray();
    
    string sControls = "< Previous+Next >+Right Hand+Left Hand";
    int i = 0;
    while (i < 4)
    {
        json jBtn = NuiButton(JsonString(GetTokenByPosition(sControls, "+", i)));
        jBtn = NuiId(jBtn, "weap_control_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 28.0);
        jBtns = JsonArrayInsert(jBtns, jBtn);
        i = i + 1;
    }

    json jGroup = NuiGroup(jBtns, TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiHeight(jGroup, 150.0);

    json jContent = JsonArray2(jLabel, jGroup);

    int nToken = NUI_DialogCreate(oPC, "Weapon Part Controls", jContent,
                                  "Back|Cancel", NUI_BTN_BACK + NUI_BTN_CANCEL, NUI_PLACE_SIDES,
                                  "", "nui_ct_equip_evt", 0, 380.0, 250.0);

    SetLocalInt(oPC, VAR_CT_WEAP_PART, nWeapPart);
    SetLocalInt(oPC, VAR_CT_MODE, NUI_CT_MODE_WEAPON);
}

// Open utility menu
void NUI_CtUtilityMenuOpen(object oPC)
{
    if (!GetIsPC(oPC)) return;

    json jBtns = JsonArray();
    
    string sUtils = "Mirror All (L/R)+Reset All+Swap Gender+Copy PC to NPC+Copy NPC to PC"; // split as: "Mirror All (L/R)", "Reset All", "Swap Gender", "Copy PC to NPC", "Copy NPC to PC" };
    int i = 0;
    while (i < 5)
    {
        json jBtn = NuiButton(JsonString(GetTokenByPosition(sUtils, "+", i)));
        jBtn = NuiId(jBtn, "util_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 28.0);
        jBtns = JsonArrayInsert(jBtns, jBtn);
        i = i + 1;
    }

    json jGroup = NuiGroup(jBtns, TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiHeight(jGroup, 180.0);

    json jContent = JsonArray1(jGroup);

    int nToken = NUI_DialogCreate(oPC, "Utility Functions", jContent,
                                  "", NUI_BTN_CANCEL, NUI_PLACE_BELOW,
                                  "", "nui_ct_equip_evt", 0, 380.0, 280.0);
}

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// END OF FILE
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
