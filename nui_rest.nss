//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - Dynamic Rest Menu
//:: nui_rest.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Implements the dynamic rest menu described in nui_rest_api. The menu
        gathers the rest-time actions players use most on a persistent world.

        Because the window is shown with NuiCreate and never clears the
        action queue, opening it does NOT interrupt a pose, walk, or emote.
        Only an explicit choice queues an action.

        Actions:
            Rest             - standard rest, if currently allowed.
            Make Camp        - place a campfire and sit by it.
            Meditate         - looping meditate pose (no mechanical rest).
            Save Character   - export the character to the vault.
            Edit Description - open a multi-line description editor.
            Quick Emotes     - hand off to the emote system if present.
            Toggle Rest      - allow or block resting for this character.
            Cancel           - close the menu.

    DEPENDENCIES
        nui_rest_api (and through it nui_api, nui_framework)

    USAGE
        From a rest hook, widget, or command:
            #include "nui_rest_api"
            void main() { NUI_RestMenuOpen(GetLastPCRested()); }

    EXAMPLE (beginner)
        // Open the menu instead of resting immediately. In your module's
        // OnPlayerRest event, cancel the default rest and call:
        NUI_RestMenuOpen(GetLastPCRested());

    EXAMPLE (intermediate)
        // Open the standalone description editor on its own.
        NUI_RestDescOpen(oPC);
*/
//::///////////////////////////////////////////////////////////////////////
//:: Author:  Carcerian
//:: Version: 1.0
//:: Created: June 1, 2026
//:: MODIFIED: June 5, 2026 - Production release
//::///////////////////////////////////////////////////////////////////////

#include "nui_rest_api"


// Open the rest menu for oPC. Non-interrupting: does not clear actions.
void NUI_RestMenuOpen(object oPC);

// Open the description editor window for oPC.
void NUI_RestDescOpen(object oPC);


void NUI_RestMenuOpen(object oPC)
{
    if (!GetIsPC(oPC)) return;
    if (!RestSystemEnabled())
    {
        NUI_PopupMessage(oPC, "Rest", "This system is currently disabled.");
        return;
    }

    json jTitle = NuiLabel(JsonString("Rest Menu"),
                           NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jTitle = NuiHeight(jTitle, 24.0);

    // Reflect the current rest state in the help line.
    string sState = "Resting is allowed.";
    if (!RestIsAllowed(oPC)) sState = "Resting is blocked here.";
    json jHelp = NuiText(JsonString(sState +
                 " Choosing an option will not interrupt your current pose."));
    jHelp = NuiHeight(jHelp, 40.0);

    // One button per action.
    json jKids = JsonArray();
    jKids = JsonArrayInsert(jKids, JsonArray1(jTitle));
    jKids = JsonArrayInsert(jKids, jHelp);

    int i = 0;
    while (i <= REST_ACT_CANCEL)
    {
        json jBtn = NuiButton(JsonString(
                        GetTokenByPosition(REST_ACTIONS, "+", i)));
        jBtn = NuiId(jBtn, "rest_act_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 28.0);
        jKids = JsonArrayInsert(jKids, jBtn);
        i++;
    }

    json jContent = JsonArray(jKids);

    NUI_SetDialogType(oPC, NUI_DIALOG_REST);
    int nToken = NUI_DialogCreate(oPC, "Rest", jContent,
                                  "", NUI_BTN_CLOSE, NUI_PLACE_CENTER,
                                  "", "nui_rest_evt", 0, 320.0, 420.0);
    NUI_SetDialogToken(oPC, nToken);
}

void NUI_RestDescOpen(object oPC)
{
    if (!GetIsPC(oPC)) return;

    json jLbl = NuiLabel(JsonString("Edit your character description:"),
                         NUI_HALIGN_LEFT, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jLbl = NuiHeight(jLbl, 22.0);

    json jEdit = NuiId(NuiTextEdit(JsonString(GetDescription(oPC)), JsonBool(TRUE)),
                       "rest_desc_text");
    jEdit = NuiHeight(jEdit, 180.0);

    json jSave = NuiId(NuiButton(JsonString("Save Description")),
                       "rest_desc_save");
    jSave = NuiHeight(jSave, 28.0);

    json jContent = JsonArray3(jLbl, jEdit, jSave);

    NUI_SetDialogType(oPC, NUI_DIALOG_REST);
    int nToken = NUI_DialogCreate(oPC, "Description", jContent,
                                  "", NUI_BTN_CLOSE, NUI_PLACE_CENTER,
                                  "", "nui_rest_evt", 0, 380.0, 300.0);
    NUI_SetDialogToken(oPC, nToken);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
