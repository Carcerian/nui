//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - PvP Options Panel
//:: nui_pvp.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Implements the PvP options panel described in nui_pvp_api. The panel
        shows every player on the server sorted into three side-by-side
        columns by relationship to the viewer, with global PvP setting
        controls below.

            +-----------+-----------+-----------+
            +  Ally /   +  Neutral  +  Hostile  +
            +  Party    +           +           +
            +-----------+-----------+-----------+
            +  (you)    +  Player C +  Player E +
            +  Player A +  Player D +           +
            +  Player B +           +           +
            +-----------+-----------+-----------+
            +  Preset: [Roleplay][Progression]  +
            +          [Combat]  [Custom]        +
            +-----------+-----------+-----------+

        The viewer always appears first in the Ally / Party column.
        Intended for DM and admin use.

    DEPENDENCIES
        nui_pvp_api (and through it nui_api, nui_framework)

    USAGE
        #include "nui_pvp_api"
        void main() { NUI_PvPOpen(GetItemActivator()); }

    EXAMPLE (beginner)
        // Open the panel for a DM.
        NUI_PvPOpen(oDM);

    EXAMPLE (advanced)
        // Categorize one player relative to the viewer (used internally).
        int nCol = NUI_PvPClassify(oViewer, oOther);   // PVP_LIST_*
*/
//::///////////////////////////////////////////////////////////////////////
//:: Author:  Carcerian
//:: Version: 1.0
//:: Created: May 31, 2026
//:: MODIFIED: June 5, 2026 - Production release
//::///////////////////////////////////////////////////////////////////////

#include "nui_pvp_api"


// Return the column (PVP_LIST_*) that oOther belongs in, from oViewer's
// point of view. The viewer themselves is treated as Ally / Party.
int NUI_PvPClassify(object oViewer, object oOther);

// Build a scrolling column of player-name buttons for one relationship
// group. Each button id is "pvp_pick_" plus the player's object id, so the
// handler can focus that player.
json NUI_PvPColumn(object oViewer, int nColumn);

// Open the PvP options panel for oPC.
void NUI_PvPOpen(object oPC);


int NUI_PvPClassify(object oViewer, object oOther)
{
    if (oOther == oViewer)            return PVP_LIST_ALLY;
    if (GetFactionEqual(oOther, oViewer)) return PVP_LIST_ALLY;
    if (GetIsFriend(oOther, oViewer)) return PVP_LIST_ALLY;
    if (GetIsEnemy(oOther, oViewer))  return PVP_LIST_HOSTILE;
    return PVP_LIST_NEUTRAL;
}

json NUI_PvPColumn(object oViewer, int nColumn)
{
    json jRows = JsonArray();

    // Header for the column.
    json jHead = NuiLabel(JsonString(
                     GetTokenByPosition(PVP_LIST_NAMES, "+", nColumn)),
                     NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jHead = NuiHeight(jHead, 22.0);
    jRows = JsonArrayInsert(jRows, jHead);

    // The viewer sits at the very top of the Ally column.
    if (nColumn == PVP_LIST_ALLY)
    {
        json jSelf = NuiButton(JsonString(GetName(oViewer) + " (you)"));
        jSelf = NuiId(jSelf, "pvp_pick_" + ObjectToString(oViewer));
        jSelf = NuiHeight(jSelf, 24.0);
        jRows = JsonArrayInsert(jRows, jSelf);
    }

    // Walk all players and place those in this column.
    object oOther = GetFirstPC();
    while (GetIsObjectValid(oOther))
    {
        if (oOther != oViewer &&
            NUI_PvPClassify(oViewer, oOther) == nColumn)
        {
            json jBtn = NuiButton(JsonString(GetName(oOther)));
            jBtn = NuiId(jBtn, "pvp_pick_" + ObjectToString(oOther));
            jBtn = NuiHeight(jBtn, 24.0);
            jRows = JsonArrayInsert(jRows, jBtn);
        }
        oOther = GetNextPC();
    }

    json jCol = NuiGroup(JsonArray(jRows), TRUE, NUI_SCROLLBARS_Y);
    jCol = NuiWidth(jCol, 150.0);
    jCol = NuiHeight(jCol, 240.0);
    return jCol;
}

void NUI_PvPOpen(object oPC)
{
    if (!GetIsPC(oPC)) return;
    if (!PvPSystemEnabled())
    {
        NUI_PopupMessage(oPC, "PvP Options",
                         "This system is currently disabled.");
        return;
    }

    // --- Title. ---
    json jTitle = NuiLabel(JsonString("PvP Options"),
                           NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jTitle = NuiHeight(jTitle, 24.0);

    // --- Three side-by-side player columns. ---
    json jColumns = JsonArray3(
        NUI_PvPColumn(oPC, PVP_LIST_ALLY),
        NUI_PvPColumn(oPC, PVP_LIST_NEUTRAL),
        NUI_PvPColumn(oPC, PVP_LIST_HOSTILE));

    // --- Setting controls below the lists. ---
    json jSetLbl = NuiLabel(JsonString("Preset:"), JsonInt(NUI_HALIGN_LEFT),
                            JsonInt(NUI_VALIGN_MIDDLE));
    jSetLbl = NuiHeight(jSetLbl, 22.0);

    json jP1 = NuiId(NuiButton(JsonString(
                   GetTokenByPosition(PVP_PRESETS, "+", 0))), "pvp_preset_1");
    jP1 = NuiHeight(jP1, 28.0);
    json jP2 = NuiId(NuiButton(JsonString(
                   GetTokenByPosition(PVP_PRESETS, "+", 1))), "pvp_preset_2");
    jP2 = NuiHeight(jP2, 28.0);
    json jP3 = NuiId(NuiButton(JsonString(
                   GetTokenByPosition(PVP_PRESETS, "+", 2))), "pvp_preset_3");
    jP3 = NuiHeight(jP3, 28.0);
    json jP4 = NuiId(NuiButton(JsonString(
                   GetTokenByPosition(PVP_PRESETS, "+", 3))), "pvp_preset_4");
    jP4 = NuiHeight(jP4, 28.0);

    json jPresetRow1 = JsonArray2(jP1, jP2);
    json jPresetRow2 = JsonArray2(jP3, jP4);

    // --- Assemble. ---
    json jKids = JsonArray();
    jKids = JsonArrayInsert(jKids, JsonArray1(jTitle));
    jKids = JsonArrayInsert(jKids, jColumns);
    jKids = JsonArrayInsert(jKids, jSetLbl);
    jKids = JsonArrayInsert(jKids, jPresetRow1);
    jKids = JsonArrayInsert(jKids, jPresetRow2);

    json jContent = JsonArray(jKids);

    NUI_SetDialogType(oPC, NUI_DIALOG_PVP_OPTIONS);
    int nToken = NUI_DialogCreate(oPC, "PvP Options", jContent,
                                  "", NUI_BTN_CLOSE, NUI_PLACE_CENTER,
                                  "", "nui_pvp_evt", 0, 520.0, 400.0);
    NUI_SetDialogToken(oPC, nToken);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
