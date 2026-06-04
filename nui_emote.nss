//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - Emote System
//:: nui_emote.nss
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
        Emote menu for solo and paired character animations, with optional
        phenotype switching. Paired emotes request consent from the target
        before they play, and a per-player consent preference is remembered.

    DEPENDENCIES
        nui_framework (self-contained; defines its own emote constants)

    USAGE
        #include "nui_emote"
        void main() { NUI_EmoteOpen(GetItemActivator()); }

    EXAMPLE (beginner)
        // Open the emote menu.
        NUI_EmoteOpen(oPC);

    EXAMPLE (intermediate)
        // Switch the player into solo mode.
        SetLocalInt(oPC, VAR_EMOTE_MODE, EMOTE_MODE_SOLO);

    EXAMPLE (advanced)
        // Perform a specific paired emote directly.
        NUI_PerformEmote(oPC, oTarget, PHENO_NINJAWEASELMAN_NORMAL, 3);
*/
//::///////////////////////////////////////////////////////////////////////
//:: Author:  Carcerian
//:: Version: 1.0
//:: Created: May 31, 2026
//:: MODIFIED: June 5, 2026 - Production release
//::///////////////////////////////////////////////////////////////////////

#include "nui_api"

// Forward declarations
void NUI_PerformEmote(object oPC, object oTarget, int nPheno, int nEmoteIndex);

// Phenotype constants (from sex_inc_main)
const int PHENO_NINJAWEASELMAN_NORMAL = 9;
const int PHENO_NINJAWEASELMAN_REVERSE = 19;
const int PHENO_FAILEDBARD_MF = 75;

// Custom phenotype ranges
const int PHENO_CUSTOM_1 = 100;
const int PHENO_CUSTOM_2 = 101;

// Emote mode flags
const int EMOTE_MODE_SOLO = 1;
const int EMOTE_MODE_PAIRED_MF = 2;
const int EMOTE_MODE_PAIRED_FF = 3;

// Consent codes
const int CONSENT_UNSET = 0;
const int CONSENT_YES = 1;
const int CONSENT_NO = 2;
const int CONSENT_ALWAYS = 3;
const int CONSENT_NEVER = 4;

// Local variable names
const string VAR_EMOTE_MODE = "SEX_EMOTE_MODE";
const string VAR_EMOTE_PHENO = "SEX_EMOTE_PHENO";
const string VAR_EMOTE_INDEX = "SEX_EMOTE_INDEX";
const string VAR_EMOTE_TARGET = "SEX_EMOTE_TARGET";
const string VAR_CONSENT_PREFIX = "SEX_CONSENT_";

// Returns emote list for phenotype
string GetPhenoEmoteList(int nPheno)
{
    switch (nPheno)
    {
        case PHENO_NINJAWEASELMAN_NORMAL:
            return "Cowgirl - Female+Cowgirl - Male+Doggystyle - Female+Doggystyle - Male+" +
                   "Missionary - Female+Missionary - Male+Reverse Cowgirl - Female+Reverse Cowgirl - Male+" +
                   "Standing Doggystyle - Female+Standing Doggystyle - Male";

        case PHENO_FAILEDBARD_MF:
            return "Face to Face (Carried) - Female+Face to Face (Carried) - Male+" +
                   "Face to Face (Single Leg) - Female+Face to Face (Single Leg) - Male+" +
                   "Missionary 2 - Female+Missionary 2 - Male+" +
                   "Doggystyle 2 (Rough) - Female+Doggystyle 2 (Rough) - Male+" +
                   "Doggystyle 2 (Fast) - Female+Doggystyle 2 (Fast) - Male+" +
                   "Deepthroat (Standing) - Female+Deepthroat (Standing) - Male+" +
                   "Deepthroat (Laying) - Female+Deepthroat (Laying) - Male+" +
                   "Standing 69 - Female+Standing 69 - Male+" +
                   "Boobjob (Standing) - Female+Boobjob (Standing) - Male+" +
                   "Boobjob (Laying) - Female+Boobjob (Laying) - Male";

        case PHENO_CUSTOM_1: 
            return "Custom 1 - Solo+Custom 1 - Paired";
        case PHENO_CUSTOM_2: 
            return "Custom 2 - Solo+Custom 2 - Paired";

        default:
            return "No emotes available for this phenotype";
    }
}

int GetPhenoAnimationIndex(int nPheno, int nEmoteIndex)
{
    return nEmoteIndex + 3;
}

void NUI_EmotePickerOpen(object oPC)
{
    if (!GetIsPC(oPC)) return;

    json jBtns = JsonArray();
    
    json jBtn1 = NuiButton(JsonString("Solo Emotes"));
    jBtn1 = NuiId(jBtn1, "emote_solo");
    jBtn1 = NuiHeight(jBtn1, 28.0);
    jBtns = JsonArrayInsert(jBtns, jBtn1);
    
    json jBtn2 = NuiButton(JsonString("Paired M/F"));
    jBtn2 = NuiId(jBtn2, "emote_paired_mf");
    jBtn2 = NuiHeight(jBtn2, 28.0);
    jBtns = JsonArrayInsert(jBtns, jBtn2);
    
    json jBtn3 = NuiButton(JsonString("Paired F/F"));
    jBtn3 = NuiId(jBtn3, "emote_paired_ff");
    jBtn3 = NuiHeight(jBtn3, 28.0);
    jBtns = JsonArrayInsert(jBtns, jBtn3);

    json jTitle = NuiLabel(JsonString("Emote System"),
                           NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jTitle = NuiHeight(jTitle, 24.0);

    json jInfo = NuiText(JsonString("Select an emote type to perform."));
    jInfo = NuiHeight(jInfo, 40.0);

    json jGroup = NuiGroup(jBtns, TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiHeight(jGroup, 130.0);

    json jContent = JsonArray3(
        JsonArray1(jTitle),
        jInfo,
        jGroup
    );

    int nToken = NUI_DialogCreate(oPC, "Emote System", jContent,
                                  "", NUI_BTN_CANCEL, NUI_PLACE_BELOW,
                                  "", "nui_emote_evt", 0, 400.0, 280.0);

    SetLocalInt(oPC, "NUI_DIALOG_TYPE", NUI_DIALOG_EMOTE);
}

void NUI_EmoteSelectorOpen(object oPC, int nPheno, int nMode)
{
    if (!GetIsPC(oPC)) return;

    string sEmoteList = GetPhenoEmoteList(nPheno);
    json jEmotes = JsonArray();
    
    int i = 0;
    int nStart = 0;
    string sToken;
    int nPos = FindSubString(sEmoteList, "+");
    
    while (nPos >= 0 || nStart < GetStringLength(sEmoteList))
    {
        if (nPos >= 0)
            sToken = GetSubString(sEmoteList, nStart, nPos - nStart);
        else
            sToken = GetSubString(sEmoteList, nStart, GetStringLength(sEmoteList) - nStart);
        
        if (sToken != "")
        {
            jEmotes = JsonArrayInsert(jEmotes, JsonString(sToken));
            i++;
        }
        
        if (nPos < 0) break;
        nStart = nPos + 1;
        nPos = FindSubString(GetSubString(sEmoteList, nStart, GetStringLength(sEmoteList)), "+");
        if (nPos >= 0) nPos += nStart;
    }

    json jEmoteBtns = JsonArray();
    int j = 0;
    while (j < i)
    {
        json jEmote = JsonArrayGet(jEmotes, j);
        if (JsonGetType(jEmote) != JSON_TYPE_STRING) break;

        json jBtn = NuiButton(jEmote);
        jBtn = NuiId(jBtn, "emote_" + IntToString(j));
        jBtn = NuiHeight(jBtn, 24.0);
        jEmoteBtns = JsonArrayInsert(jEmoteBtns, jBtn);
        j++;
    }

    json jGroup = NuiGroup(JsonArray(jEmoteBtns), TRUE, NUI_SCROLLBARS_BOTH);
    jGroup = NuiHeight(jGroup, 300.0);

    json jContent = JsonArray1(jGroup);

    string sTitle = "Select Emote";
    if (nMode == EMOTE_MODE_PAIRED_MF) sTitle = "Select Emote (M/F Paired)";
    else if (nMode == EMOTE_MODE_PAIRED_FF) sTitle = "Select Emote (F/F Paired)";

    int nToken = NUI_DialogCreate(oPC, sTitle, jContent,
                                  NUI_BTN_OK + "", NUI_BTN_CANCEL, NUI_PLACE_BELOW,
                                  "", "nui_emote_evt", 0, 400.0, 400.0);

    SetLocalInt(oPC, VAR_EMOTE_MODE, nMode);
    SetLocalInt(oPC, VAR_EMOTE_PHENO, nPheno);
}

void NUI_EmoteTargetOpen(object oPC, int nPheno, int nMode, int nEmoteIndex)
{
    if (!GetIsPC(oPC)) return;

    object oTarget = GetFirstFactionMember(oPC, FALSE);
    json jTargets = JsonArray();
    int nCount = 0;

    while (GetIsObjectValid(oTarget) && nCount < 50)
    {
        if (GetIsPC(oTarget) && oTarget != oPC)
        {
            json jBtn = NuiButton(JsonString(GetName(oTarget)));
            jBtn = NuiId(jBtn, "target_" + IntToString(nCount));
            jBtn = NuiHeight(jBtn, 24.0);
            jTargets = JsonArrayInsert(jTargets, jBtn);
        }
        oTarget = GetNextFactionMember(oPC, FALSE);
        nCount++;
    }

    json jGroup = NuiGroup(JsonArray(jTargets), TRUE, NUI_SCROLLBARS_BOTH);
    jGroup = NuiHeight(jGroup, 300.0);

    json jContent = JsonArray1(jGroup);

    int nToken = NUI_DialogCreate(oPC, "Select Partner", jContent,
                                  "", NUI_BTN_CANCEL, NUI_PLACE_BELOW,
                                  "", "nui_emote_evt", 0, 400.0, 350.0);

    SetLocalInt(oPC, VAR_EMOTE_MODE, nMode);
    SetLocalInt(oPC, VAR_EMOTE_PHENO, nPheno);
    SetLocalInt(oPC, VAR_EMOTE_INDEX, nEmoteIndex);
}

void NUI_EmoteConsentRequest(object oPC, object oTarget, int nPheno, int nEmoteIndex)
{
    if (!GetIsPC(oTarget)) return;

    string sOPCResRef = GetPCPlayerName(oPC);
    int nConsentLevel = GetLocalInt(oTarget, VAR_CONSENT_PREFIX + sOPCResRef);

    if (nConsentLevel == CONSENT_ALWAYS)
    {
        NUI_PerformEmote(oPC, oTarget, nPheno, nEmoteIndex);
        return;
    }
    else if (nConsentLevel == CONSENT_NEVER)
    {
        SendMessageToPC(oPC, GetName(oTarget) + " has declined all intimate contact with you.");
        return;
    }

    json jLabel = NuiLabel(
        JsonString(GetName(oPC) + " is requesting intimate contact. Accept?"),
        NUI_HALIGN_LEFT, JsonInt(NUI_VALIGN_TOP));

    json jContent = JsonArray1(jLabel);

    int nToken = NUI_DialogCreate(oTarget, "Consent Request", jContent,
                                  NUI_BTN_OK + NUI_BTN_CANCEL, "Yes|No", NUI_PLACE_SIDES,
                                  "nui_emote_cons", "nui_emote_evt", 0, 400.0, 150.0);

    SetLocalObject(oTarget, "SEX_CONSENT_REQUESTER", oPC);
    SetLocalInt(oTarget, VAR_EMOTE_PHENO, nPheno);
    SetLocalInt(oTarget, VAR_EMOTE_INDEX, nEmoteIndex);
}

void NUI_PerformEmote(object oPC, object oTarget, int nPheno, int nEmoteIndex)
{
    if (oTarget == oPC)
    {
        SetLocalInt(oPC, "SEX_PHENOTYPE", nPheno);
        SetLocalInt(oPC, "SEX_POSITION", nEmoteIndex);
        ExecuteScript("nui_emote_solo", oPC);
    }
    else if (GetIsPC(oTarget))
    {
        SetLocalObject(oTarget, "SEX_SUITOR", oPC);
        SetLocalObject(oPC, "SEX_SUITOR", oTarget);
        SetLocalInt(oPC, "SEX_PHENOTYPE", nPheno);
        SetLocalInt(oPC, "SEX_POSITION", nEmoteIndex);
        ExecuteScript("sex_consent_yes", oTarget);
    }
}

void SetPlayerConsent(object oTarget, object oPlayer, int nConsentLevel)
{
    if (!GetIsPC(oTarget) || !GetIsPC(oPlayer)) return;

    string sPlayerResRef = GetPCPlayerName(oPlayer);
    
    if (nConsentLevel == CONSENT_UNSET)
        DeleteLocalInt(oTarget, VAR_CONSENT_PREFIX + sPlayerResRef);
    else
        SetLocalInt(oTarget, VAR_CONSENT_PREFIX + sPlayerResRef, nConsentLevel);
}

int GetPlayerConsent(object oTarget, object oPlayer)
{
    if (!GetIsPC(oTarget) || !GetIsPC(oPlayer)) return CONSENT_UNSET;
    
    string sPlayerResRef = GetPCPlayerName(oPlayer);
    return GetLocalInt(oTarget, VAR_CONSENT_PREFIX + sPlayerResRef);
}

int GetPhenoForPC(object oPC)
{
    int nPheno = GetLocalInt(oPC, VAR_EMOTE_PHENO);
    if (nPheno == 0) nPheno = PHENO_NINJAWEASELMAN_NORMAL;
    return nPheno;
}

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// END OF FILE
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
