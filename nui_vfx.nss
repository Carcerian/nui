//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - Visual Accessory Manager
//:: nui_vfx.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////
//::///////////////////////////////////////////////////////////////////////

/* ==================================================================== */
/*  PUBLIC NUI_* FUNCTION DECLARATIONS                                 */
/* ==================================================================== */


/*
    SYNOPSIS
        Implements the persistent visual accessory manager described in
        nui_vfx_api. A player keeps a saved list of named visual effects,
        each anchored to the head or chest, and can toggle, rename, add, or
        delete them. The list persists across sessions via the campaign
        database, keyed by the player's public CD key and character name.

        Main window layout:
            - A scrolling list box of saved accessories (name plus state).
            - A name entry field for the focused accessory.
            - An orientation choice (Head or Chest) and an effect choice.
            - Row of actions: Add, Toggle On/Off, Rename, Delete.

    DEPENDENCIES
        nui_vfx_api (and through it nui_api, nui_framework)

    USAGE
        From a widget, item, or command:
            #include "nui_vfx_api"
            void main() { NUI_VfxManagerOpen(GetItemActivator()); }

    EXAMPLE (beginner)
        // Open the manager for the player who used a feat or item.
        NUI_VfxManagerOpen(oPC);

    EXAMPLE (intermediate)
        // Re-apply every saved accessory after a login event.
        NUI_VfxApplyAll(oPC);

    EXAMPLE (advanced)
        // Programmatically append an accessory, then refresh.
        json jList = NUI_VfxLoadList(oPC);
        jList = NUI_VfxMakeRecord("Halo", 142, VFX_POINT_HEAD, TRUE);
        // (append jRecord to jList, then:)
        NUI_VfxSaveList(oPC, jList);
        NUI_VfxApplyAll(oPC);
*/
//::///////////////////////////////////////////////////////////////////////
//:: Author:  Carcerian
//:: Version: 1.0
//:: Created: May 31, 2026
//:: MODIFIED: June 5, 2026 - Production release
//::///////////////////////////////////////////////////////////////////////

#include "nui_vfx_api"


/* ----------------------------------------------------------------------- */
/*  FORWARD DECLARATIONS                                                    */
/* ----------------------------------------------------------------------- */

// Build a single accessory record object.
// - sName:  display label.
// - nRow:   visualeffects.2da row to play.
// - nPoint: VFX_POINT_HEAD or VFX_POINT_CHEST.
// - nOn:    TRUE if currently shown.
json NUI_VfxMakeRecord(string sName, int nRow, int nPoint, int nOn);

// Return the player's saved accessory list as a JSON array (never NULL).
json NUI_VfxLoadList(object oPC);

// Persist the player's accessory list.
void NUI_VfxSaveList(object oPC, json jList);

// Build the campaign-database key used to persist a player's list.
string NUI_VfxPersistKey(object oPC);

// Remove all NUI-applied visual effects this system owns from oPC, then
// re-apply only the accessories currently flagged on.
void NUI_VfxApplyAll(object oPC);

// Open the accessory manager window for oPC.
void NUI_VfxManagerOpen(object oPC);


/* ----------------------------------------------------------------------- */
/*  PERSISTENCE                                                             */
/* ----------------------------------------------------------------------- */

string NUI_VfxPersistKey(object oPC)
{
    return "VFXACC_" + GetPCPublicCDKey(oPC) + "_" + GetName(oPC);
}

json NUI_VfxLoadList(object oPC)
{
    string sData = GetCampaignString("Carcerian_VFX", NUI_VfxPersistKey(oPC));
    if (sData == "")
    {
        // Fall back to any in-session copy, else an empty array.
        sData = GetLocalString(oPC, VAR_VFX_LIST);
    }

    json jList = JsonParse(sData);
    if (JsonGetType(jList) != JSON_TYPE_ARRAY) jList = JsonArray();
    return jList;
}

void NUI_VfxSaveList(object oPC, json jList)
{
    string sData = JsonDump(jList);
    SetLocalString(oPC, VAR_VFX_LIST, sData);
    SetCampaignString("Carcerian_VFX", NUI_VfxPersistKey(oPC), sData);
    VfxDebug(oPC, "saved accessory list (" +
             IntToString(GetJsonArraySize(jList)) + " entries)", 2);
}


/* ----------------------------------------------------------------------- */
/*  RECORDS AND APPLICATION                                                 */
/* ----------------------------------------------------------------------- */

json NUI_VfxMakeRecord(string sName, int nRow, int nPoint, int nOn)
{
    json jRec = JsonObject();
    jRec = JsonObjectSet(jRec, VFX_FIELD_NAME,  JsonString(sName));
    jRec = JsonObjectSet(jRec, VFX_FIELD_ROW,   JsonInt(nRow));
    jRec = JsonObjectSet(jRec, VFX_FIELD_POINT, JsonInt(nPoint));
    jRec = JsonObjectSet(jRec, VFX_FIELD_ON,    JsonInt(nOn));
    return jRec;
}

void NUI_VfxApplyAll(object oPC)
{
    if (!GetIsPC(oPC)) return;

    // Clear previously applied visual effects owned by this system. We tag
    // nothing extra here; on a PW the login hook typically clears duplicate
    // visuals before re-applying. Re-applying the "on" set is the important
    // part for an in-session refresh.
    json jList = NUI_VfxLoadList(oPC);
    int  nSize = GetJsonArraySize(jList);
    int  i     = 0;

    while (i < nSize)
    {
        json jRec = JsonArrayGet(jList, i);
        int  nOn  = JsonGetInt(JsonObjectGet(jRec, VFX_FIELD_ON));
        int  nRow = JsonGetInt(JsonObjectGet(jRec, VFX_FIELD_ROW));

        if (nOn && nRow > 0)
        {
            effect eVfx = EffectVisualEffect(nRow);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVfx, oPC);
        }
        i++;
    }

    VfxDebug(oPC, "applied accessory list", 2);
}


/* ----------------------------------------------------------------------- */
/*  MANAGER WINDOW                                                          */
/* ----------------------------------------------------------------------- */

void NUI_VfxManagerOpen(object oPC)
{
    if (!GetIsPC(oPC)) return;
    if (!VfxSystemEnabled())
    {
        NUI_PopupMessage(oPC, "Visual Accessories",
                         "This system is currently disabled.");
        return;
    }

    json jList = NUI_VfxLoadList(oPC);
    int  nSize = GetJsonArraySize(jList);

    // --- Title and help. ---
    json jTitle = NuiLabel(JsonString("Visual Accessory Manager"),
                           NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jTitle = NuiHeight(jTitle, 24.0);

    json jHelp = NuiText(JsonString(
        "Saved visual accessories. Each is anchored to the head or chest " +
        "and can be toggled on or off, renamed, or removed."));
    jHelp = NuiHeight(jHelp, 44.0);

    // --- Accessory list box (one button per saved entry). ---
    json jRows = JsonArray();
    int  i     = 0;
    while (i < nSize)
    {
        json   jRec   = JsonArrayGet(jList, i);
        string sName  = JsonGetString(JsonObjectGet(jRec, VFX_FIELD_NAME));
        int    nOn    = JsonGetInt(JsonObjectGet(jRec, VFX_FIELD_ON));
        int    nPoint = JsonGetInt(JsonObjectGet(jRec, VFX_FIELD_POINT));

        string sState = "[off] ";
        if (nOn) sState = "[on]  ";
        string sWhere = GetTokenByPosition(VFX_POINTS, "+", nPoint);

        json jBtn = NuiButton(JsonString(sState + sName + "  (" + sWhere + ")"));
        jBtn = NuiId(jBtn, "vfx_sel_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 26.0);
        jRows = JsonArrayInsert(jRows, jBtn);
        i++;
    }
    if (nSize == 0)
    {
        json jEmpty = NuiLabel(JsonString("(no accessories yet)"),
                               NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
        jEmpty = NuiHeight(jEmpty, 26.0);
        jRows = JsonArrayInsert(jRows, jEmpty);
    }

    json jListBox = NuiGroup(JsonArray(jRows), TRUE, NUI_SCROLLBARS_Y);
    jListBox = NuiHeight(jListBox, 160.0);

    // --- Name entry for the focused accessory. ---
    json jNameLbl = NuiLabel(JsonString("Name:"), JsonInt(NUI_HALIGN_LEFT),
                             JsonInt(NUI_VALIGN_MIDDLE));
    jNameLbl = NuiWidth(jNameLbl, 60.0);
    json jNameEdit = NuiId(NuiTextEdit(JsonString(""), FALSE), "vfx_name");
    jNameEdit = NuiHeight(jNameEdit, 24.0);
    json jNameRow = JsonArray2(jNameLbl, jNameEdit);

    // --- Action buttons. ---
    json jAdd = NuiId(NuiButton(JsonString("Add New")), "vfx_add");
    jAdd = NuiHeight(jAdd, 28.0);
    json jToggle = NuiId(NuiButton(JsonString("Toggle On/Off")), "vfx_toggle");
    jToggle = NuiHeight(jToggle, 28.0);
    json jRename = NuiId(NuiButton(JsonString("Rename")), "vfx_rename");
    jRename = NuiHeight(jRename, 28.0);
    json jDelete = NuiId(NuiButton(JsonString("Delete")), "vfx_delete");
    jDelete = NuiHeight(jDelete, 28.0);

    json jActions = JsonArray2(jAdd, jToggle);
    json jActions2 = JsonArray2(jRename, jDelete);

    // --- Assemble. ---
    json jKids = JsonArray();
    jKids = JsonArrayInsert(jKids, JsonArray1(jTitle));
    jKids = JsonArrayInsert(jKids, jHelp);
    jKids = JsonArrayInsert(jKids, jListBox);
    jKids = JsonArrayInsert(jKids, jNameRow);
    jKids = JsonArrayInsert(jKids, jActions);
    jKids = JsonArrayInsert(jKids, jActions2);

    json jContent = JsonArray(jKids);

    NUI_SetDialogType(oPC, NUI_DIALOG_VFX_CHAIN);
    int nToken = NUI_DialogCreate(oPC, "Visual Accessories", jContent,
                                  "", NUI_BTN_CLOSE, NUI_PLACE_CENTER,
                                  "", "nui_vfx_evt", 0, 420.0, 400.0);
    NUI_SetDialogToken(oPC, nToken);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
