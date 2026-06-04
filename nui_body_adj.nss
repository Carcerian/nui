//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - Body Adjustment
//:: nui_body_adjust.nss
//::///////////////////////////////////////////////////////////////////////

/* ==================================================================== */
/*  PUBLIC NUI_* FUNCTION DECLARATIONS                                 */
/* ==================================================================== */


/*
    SYNOPSIS
        Lets a player fine-tune the position and scale of body parts. The
        head, wings, tail, and whole self each support X / Y / Z offset, and
        every part except the head also supports a uniform scale. Changes
        are stored on the player, the self-scale is applied with a visual
        transform, and a five-level undo history is kept.

        Two windows:
            NUI_BodyAdjustOpen     - pick a part.
            NUI_BodyPartAdjustOpen - edit one part's offsets and scale.

    DEPENDENCIES
        nui_body_api (and through it nui_api, nui_framework)

    USAGE
        #include "nui_body_api"
        void main() { NUI_BodyAdjustOpen(GetItemActivator()); }

    EXAMPLE (beginner)
        // Open the part picker.
        NUI_BodyAdjustOpen(oPC);

    EXAMPLE (intermediate)
        // Jump straight to adjusting the self scale.
        NUI_BodyPartAdjustOpen(oPC, BODY_PART_SELF);

    EXAMPLE (advanced)
        // Apply a known transform directly, bypassing the UI.
        NUI_BodyPartApply(oPC, BODY_PART_WINGS, 0.0, 0.0, 0.1, 1.25);
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

#include "nui_body_api"


/* ----------------------------------------------------------------------- */
/*  MODULE STORAGE KEYS                                                     */
/*  Per-part transform values and undo bookkeeping live on the player.     */
/* ----------------------------------------------------------------------- */

const string VAR_HEAD_X  = "NUI_BODY_HEAD_X";
const string VAR_HEAD_Y  = "NUI_BODY_HEAD_Y";
const string VAR_HEAD_Z  = "NUI_BODY_HEAD_Z";

const string VAR_WING_X  = "NUI_BODY_WING_X";
const string VAR_WING_Y  = "NUI_BODY_WING_Y";
const string VAR_WING_Z  = "NUI_BODY_WING_Z";
const string VAR_WING_S  = "NUI_BODY_WING_S";

const string VAR_TAIL_X  = "NUI_BODY_TAIL_X";
const string VAR_TAIL_Y  = "NUI_BODY_TAIL_Y";
const string VAR_TAIL_Z  = "NUI_BODY_TAIL_Z";
const string VAR_TAIL_S  = "NUI_BODY_TAIL_S";

const string VAR_SELF_X  = "NUI_BODY_SELF_X";
const string VAR_SELF_Y  = "NUI_BODY_SELF_Y";
const string VAR_SELF_Z  = "NUI_BODY_SELF_Z";
const string VAR_SELF_S  = "NUI_BODY_SELF_S";

const string VAR_ORIG_X  = "NUI_BODY_ORIG_X";
const string VAR_ORIG_Y  = "NUI_BODY_ORIG_Y";
const string VAR_ORIG_Z  = "NUI_BODY_ORIG_Z";
const string VAR_ORIG_S  = "NUI_BODY_ORIG_S";

/* ----------------------------------------------------------------------- */
/*  FORWARD DECLARATIONS                                                    */
/* ----------------------------------------------------------------------- */

// Format a float to nDecimals places.
string FormatFloat(float fValue, int nDecimals);

// Clamp a parsed float to a range, with a default for empty input.
float SafeStringToFloat(string sValue, float fDefault, float fMin, float fMax);

// Tell other players in the area about an appearance change.
void BroadcastAppearanceChange(object oPC, string sMessage);

// Read one stored transform value for a part. sValueType is one of
// "offset_x", "offset_y", "offset_z", "scale".
float NUI_GetBodyPartValue(object oPC, int nPart, string sValueType);

// Apply a complete transform to a part.
void NUI_BodyPartApply(object oPC, int nPart, float fOffX, float fOffY,
                       float fOffZ, float fScale);

// Reset a part to the values captured when its editor was opened.
void NUI_BodyPartReset(object oPC, int nPart);

// Open the part-picker window.
void NUI_BodyAdjustOpen(object oPC);

// Open the editor window for one part.
void NUI_BodyPartAdjustOpen(object oPC, int nPart);


/* ======================================================================= */
/*  IMPLEMENTATION                                                          */
/* ======================================================================= */

string FormatFloat(float fValue, int nDecimals)
{
    return FloatToString(fValue, 0, nDecimals);
}

float SafeStringToFloat(string sValue, float fDefault, float fMin, float fMax)
{
    if (sValue == "") return fDefault;
    float fResult = StringToFloat(sValue);
    if (fResult < fMin) fResult = fMin;
    if (fResult > fMax) fResult = fMax;
    return fResult;
}

void BroadcastAppearanceChange(object oPC, string sMessage)
{
    if (!GetIsPC(oPC)) return;

    object oArea = GetArea(oPC);
    if (!GetIsObjectValid(oArea)) return;

    object oTarget = GetFirstObjectInArea(oArea);
    while (GetIsObjectValid(oTarget))
    {
        if (GetIsPC(oTarget) && oTarget != oPC)
            SendMessageToPC(oTarget, GetName(oPC) + " " + sMessage);
        oTarget = GetNextObjectInArea(oArea);
    }
}

float NUI_GetBodyPartValue(object oPC, int nPart, string sValueType)
{
    if (sValueType == "offset_x")
    {
        if (nPart == BODY_PART_HEAD)  return GetLocalFloat(oPC, VAR_HEAD_X);
        if (nPart == BODY_PART_WINGS) return GetLocalFloat(oPC, VAR_WING_X);
        if (nPart == BODY_PART_TAIL)  return GetLocalFloat(oPC, VAR_TAIL_X);
        if (nPart == BODY_PART_SELF)  return GetLocalFloat(oPC, VAR_SELF_X);
    }
    else if (sValueType == "offset_y")
    {
        if (nPart == BODY_PART_HEAD)  return GetLocalFloat(oPC, VAR_HEAD_Y);
        if (nPart == BODY_PART_WINGS) return GetLocalFloat(oPC, VAR_WING_Y);
        if (nPart == BODY_PART_TAIL)  return GetLocalFloat(oPC, VAR_TAIL_Y);
        if (nPart == BODY_PART_SELF)  return GetLocalFloat(oPC, VAR_SELF_Y);
    }
    else if (sValueType == "offset_z")
    {
        if (nPart == BODY_PART_HEAD)  return GetLocalFloat(oPC, VAR_HEAD_Z);
        if (nPart == BODY_PART_WINGS) return GetLocalFloat(oPC, VAR_WING_Z);
        if (nPart == BODY_PART_TAIL)  return GetLocalFloat(oPC, VAR_TAIL_Z);
        if (nPart == BODY_PART_SELF)  return GetLocalFloat(oPC, VAR_SELF_Z);
    }
    else if (sValueType == "scale")
    {
        if (nPart == BODY_PART_WINGS) return GetLocalFloat(oPC, VAR_WING_S);
        if (nPart == BODY_PART_TAIL)  return GetLocalFloat(oPC, VAR_TAIL_S);
        if (nPart == BODY_PART_SELF)  return GetLocalFloat(oPC, VAR_SELF_S);
    }
    return 0.0;
}

void NUI_BodyPartApply(object oPC, int nPart, float fOffX, float fOffY,
                       float fOffZ, float fScale)
{
    // Validate PC object
    if (!GetIsPC(oPC)) return;
    if (oPC == OBJECT_INVALID) return;

    // Validate offset values are within range
    if ((fOffX < BODY_OFFSET_MIN || fOffX > BODY_OFFSET_MAX) ||
        (fOffY < BODY_OFFSET_MIN || fOffY > BODY_OFFSET_MAX) ||
        (fOffZ < BODY_OFFSET_MIN || fOffZ > BODY_OFFSET_MAX))
    {
        SendMessageToPC(oPC, "Offset values are out of range.");
        return;
    }

    // Validate scale value is within range (except for HEAD which has no scale)
    if (nPart != BODY_PART_HEAD &&
        (fScale < BODY_SCALE_MIN || fScale > BODY_SCALE_MAX))
    {
        SendMessageToPC(oPC, "Scale value is out of range.");
        return;
    }

    // Validate body part is valid [0-4]
    if (nPart < 0 || nPart > 4)
    {
        SendMessageToPC(oPC, "Invalid body part selected.");
        return;
    }

    // Apply the new values.
    float fOldX = NUI_GetBodyPartValue(oPC, nPart, "offset_x");
    float fOldY = NUI_GetBodyPartValue(oPC, nPart, "offset_y");
    float fOldZ = NUI_GetBodyPartValue(oPC, nPart, "offset_z");
    float fOldS = NUI_GetBodyPartValue(oPC, nPart, "scale");

    if (nPart == BODY_PART_HEAD)
    {
        SetLocalFloat(oPC, VAR_HEAD_X, fOffX);
        SetLocalFloat(oPC, VAR_HEAD_Y, fOffY);
        SetLocalFloat(oPC, VAR_HEAD_Z, fOffZ);
        SendMessageToPC(oPC, "Head position adjusted.");
        BroadcastAppearanceChange(oPC, "adjusted their head position.");
    }
    else if (nPart == BODY_PART_WINGS)
    {
        SetLocalFloat(oPC, VAR_WING_X, fOffX);
        SetLocalFloat(oPC, VAR_WING_Y, fOffY);
        SetLocalFloat(oPC, VAR_WING_Z, fOffZ);
        SetLocalFloat(oPC, VAR_WING_S, fScale);
        SendMessageToPC(oPC, "Wings adjusted to " +
                        FormatFloat(fScale, 2) + "x.");
        BroadcastAppearanceChange(oPC, "adjusted their wings.");
    }
    else if (nPart == BODY_PART_TAIL)
    {
        SetLocalFloat(oPC, VAR_TAIL_X, fOffX);
        SetLocalFloat(oPC, VAR_TAIL_Y, fOffY);
        SetLocalFloat(oPC, VAR_TAIL_Z, fOffZ);
        SetLocalFloat(oPC, VAR_TAIL_S, fScale);
        SendMessageToPC(oPC, "Tail adjusted to " +
                        FormatFloat(fScale, 2) + "x.");
        BroadcastAppearanceChange(oPC, "adjusted their tail.");
    }
    else if (nPart == BODY_PART_SELF)
    {
        SetLocalFloat(oPC, VAR_SELF_X, fOffX);
        SetLocalFloat(oPC, VAR_SELF_Y, fOffY);
        SetLocalFloat(oPC, VAR_SELF_Z, fOffZ);
        SetLocalFloat(oPC, VAR_SELF_S, fScale);
        SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fScale);
        SendMessageToPC(oPC, "Character scale set to " +
                        FormatFloat(fScale, 2) + "x.");
        BroadcastAppearanceChange(oPC, "changed their size.");
    }
}


void NUI_BodyPartReset(object oPC, int nPart)
{
    if (!GetIsPC(oPC)) return;

    float fOffX  = GetLocalFloat(oPC, VAR_ORIG_X);
    float fOffY  = GetLocalFloat(oPC, VAR_ORIG_Y);
    float fOffZ  = GetLocalFloat(oPC, VAR_ORIG_Z);
    float fScale = GetLocalFloat(oPC, VAR_ORIG_S);

    NUI_BodyPartApply(oPC, nPart, fOffX, fOffY, fOffZ, fScale);
    SendMessageToPC(oPC, "Reset to opening values.");
}

void NUI_BodyAdjustOpen(object oPC)
{
    if (!GetIsPC(oPC)) return;
    if (!BodySystemEnabled())
    {
        NUI_PopupMessage(oPC, "Body Adjustment",
                         "This system is currently disabled.");
        return;
    }

    // One button per part, names drawn from the BODY_PARTS table.
    json jBtns = JsonArray();
    int  i     = 1;
    while (i <= 4)
    {
        json jBtn = NuiButton(JsonString(
                        GetTokenByPosition(BODY_PARTS, "+", i - 1)));
        jBtn = NuiId(jBtn, "part_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 28.0);
        jBtns = JsonArrayInsert(jBtns, jBtn);
        i++;
    }

    json jTitle = NuiLabel(JsonString("Body Customization"),
                           JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jTitle = NuiHeight(jTitle, 24.0);

    json jInfo = NuiLabel(JsonString(
        "Select a body part to adjust its position and scale."),
        JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_TOP));
    jInfo = NuiHeight(jInfo, 40.0);

    json jGroup = NuiGroup(JsonArray1(jBtns), TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiHeight(jGroup, 150.0);

    json jContent = JsonArray3(
        JsonArray1(jTitle), jInfo, jGroup);

    NUI_SetDialogType(oPC, NUI_DIALOG_BODY_ADJUST);
    int nToken = NUI_DialogCreate(oPC, "Body Adjustment", jContent,
                                  "", NUI_BTN_CLOSE, NUI_PLACE_BELOW,
                                  "", "nui_body_evt", 0, 400.0, 300.0);
    NUI_SetDialogToken(oPC, nToken);
}

void NUI_BodyPartAdjustOpen(object oPC, int nPart)
{
    if (!GetIsPC(oPC)) return;

    string sTitle = "Adjust " +
                    GetTokenByPosition(BODY_PARTS, "+", nPart - 1);

    int bHasScale = TRUE;
    if (nPart == BODY_PART_HEAD) bHasScale = FALSE;

    float fOffX  = NUI_GetBodyPartValue(oPC, nPart, "offset_x");
    float fOffY  = NUI_GetBodyPartValue(oPC, nPart, "offset_y");
    float fOffZ  = NUI_GetBodyPartValue(oPC, nPart, "offset_z");
    float fScale = NUI_GetBodyPartValue(oPC, nPart, "scale");
    if (fScale <= 0.0) fScale = 1.0;

    // Remember opening values so Reset can restore them.
    SetLocalFloat(oPC, VAR_ORIG_X, fOffX);
    SetLocalFloat(oPC, VAR_ORIG_Y, fOffY);
    SetLocalFloat(oPC, VAR_ORIG_Z, fOffZ);
    SetLocalFloat(oPC, VAR_ORIG_S, fScale);

    json jControls = JsonArray();

    // --- X offset row. ---
    json jLabelX = NuiLabel(JsonString("X Offset:"), JsonInt(NUI_HALIGN_LEFT),
                            JsonInt(NUI_VALIGN_MIDDLE));
    jLabelX = NuiWidth(jLabelX, 70.0);
    json jInputX = NuiText(JsonString(FormatFloat(fOffX, 2)));
    jInputX = NuiId(jInputX, "body_x");
    jInputX = NuiHeight(jInputX, 24.0);
    jInputX = NuiWidth(jInputX, 80.0);
    json jSliderX = NuiSliderFloat(JsonFloat(fOffX), JsonFloat(BODY_OFFSET_MIN), JsonFloat(BODY_OFFSET_MAX), JsonInt(1));
    jSliderX = NuiHeight(jSliderX, 20.0);
    jControls = JsonArrayInsert(jControls,
                    JsonArray3(jLabelX, jInputX, jSliderX));

    // --- Y offset row. ---
    json jLabelY = NuiLabel(JsonString("Y Offset:"), JsonInt(NUI_HALIGN_LEFT),
                            JsonInt(NUI_VALIGN_MIDDLE));
    jLabelY = NuiWidth(jLabelY, 70.0);
    json jInputY = NuiText(JsonString(FormatFloat(fOffY, 2)));
    jInputY = NuiId(jInputY, "body_y");
    jInputY = NuiHeight(jInputY, 24.0);
    jInputY = NuiWidth(jInputY, 80.0);
    json jSliderY = NuiSliderFloat(JsonFloat(fOffY), JsonFloat(BODY_OFFSET_MIN), JsonFloat(BODY_OFFSET_MAX), JsonInt(1));
    jSliderY = NuiHeight(jSliderY, 20.0);
    jControls = JsonArrayInsert(jControls,
                    JsonArray3(jLabelY, jInputY, jSliderY));

    // --- Z offset row. ---
    json jLabelZ = NuiLabel(JsonString("Z Offset:"), JsonInt(NUI_HALIGN_LEFT),
                            JsonInt(NUI_VALIGN_MIDDLE));
    jLabelZ = NuiWidth(jLabelZ, 70.0);
    json jInputZ = NuiText(JsonString(FormatFloat(fOffZ, 2)));
    jInputZ = NuiId(jInputZ, "body_z");
    jInputZ = NuiHeight(jInputZ, 24.0);
    jInputZ = NuiWidth(jInputZ, 80.0);
    json jSliderZ = NuiSliderFloat(JsonFloat(fOffZ), JsonFloat(BODY_OFFSET_MIN), JsonFloat(BODY_OFFSET_MAX), JsonInt(1));
    jSliderZ = NuiHeight(jSliderZ, 20.0);
    jControls = JsonArrayInsert(jControls,
                    JsonArray3(jLabelZ, jInputZ, jSliderZ));

    // --- Optional scale row. ---
    if (bHasScale)
    {
        json jLabelS = NuiLabel(JsonString("Scale:"), JsonInt(NUI_HALIGN_LEFT),
                                JsonInt(NUI_VALIGN_MIDDLE));
        jLabelS = NuiWidth(jLabelS, 70.0);
        json jInputS = NuiText(JsonString(FormatFloat(fScale, 2)));
        jInputS = NuiId(jInputS, "body_s");
        jInputS = NuiHeight(jInputS, 24.0);
        jInputS = NuiWidth(jInputS, 80.0);
        json jSliderS = NuiSliderFloat(JsonFloat(fScale), JsonFloat(BODY_SCALE_MIN),
                                       JsonFloat(BODY_SCALE_MAX), JsonInt(1));
        jSliderS = NuiHeight(jSliderS, 20.0);
        jControls = JsonArrayInsert(jControls,
                        JsonArray3(jLabelS, jInputS, jSliderS));
    }

    // --- Reset / Apply buttons. ---
    json jBtnReset = NuiId(NuiButton(JsonString("Reset")),
                           "body_reset_" + IntToString(nPart));
    jBtnReset = NuiHeight(jBtnReset, 24.0);
    jBtnReset = NuiWidth(jBtnReset, 90.0);

    json jBtnApply = NuiId(NuiButton(JsonString("Apply")),
                           "body_apply_" + IntToString(nPart));
    jBtnApply = NuiHeight(jBtnApply, 24.0);
    jBtnApply = NuiWidth(jBtnApply, 90.0);

    jControls = JsonArrayInsert(jControls,
                    JsonArray2(jBtnReset, jBtnApply));

    json jGroup = NuiGroup(jControls, TRUE, NUI_SCROLLBARS_NONE);
    float fGroupH = 220.0;
    if (bHasScale) fGroupH = 280.0;
    jGroup = NuiHeight(jGroup, fGroupH);

    json jContent = JsonArray1(jGroup);

    float fWinH = 340.0;
    if (bHasScale) fWinH = 400.0;

    NUI_SetDialogType(oPC, NUI_DIALOG_BODY_ADJUST);
    int nToken = NUI_DialogCreate(oPC, sTitle, jContent,
                                  "", NUI_BTN_CLOSE, NUI_PLACE_BELOW,
                                  "", "nui_body_evt", 0, 420.0, fWinH);
    NUI_SetDialogToken(oPC, nToken);
    SetLocalInt(oPC, VAR_BODY_PART, nPart);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
