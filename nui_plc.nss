//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - Placeable Manager
//:: nui_plc.nss
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
        Build tool for managing persistent placeables. An authorized builder
        locks onto a nearby placeable and then moves, rotates, scales,
        restyles, plot-flags, or deletes it. Plot flagging and out-of-range
        access are limited to DMs.

        Entry windows:
            NUI_PlcManagerOpen  - the action hub.
            NUI_PlcMoveOpen     - edit X / Y / Z position.
            NUI_PlcRotateOpen   - edit facing.
            NUI_PlcScaleOpen    - edit uniform scale.
            NUI_PlcPlotOpen     - toggle plot protection (DM only).
            NUI_PlcDeleteOpen   - confirm deletion with a gold refund.

    DEPENDENCIES
        nui_plc_api (and through it nui_api, nui_framework)

    USAGE
        #include "nui_plc_api"
        void main() { NUI_PlcManagerOpen(GetItemActivator()); }

    EXAMPLE (beginner)
        // Open the manager hub.
        NUI_PlcManagerOpen(oPC);

    EXAMPLE (intermediate)
        // Lock the nearest managed placeable to a clicked point, then move.
        NUI_PlcLockTarget(oPC, vClick);
        NUI_PlcMoveOpen(oPC);

    EXAMPLE (advanced)
        // Pull a JSON list of nearby managed placeables for a custom picker.
        json jNearby = NUI_PlcGetNearbyList(oPC, 10);
*/
//::///////////////////////////////////////////////////////////////////////
//:: Author:  Carcerian
//:: Version: 1.0
//:: Created: May 31, 2026
//:: MODIFIED: June 5, 2026 - Production release
//::///////////////////////////////////////////////////////////////////////

#include "nui_plc_api"


/* ----------------------------------------------------------------------- */
/*  MODULE CONSTANTS                                                        */
/* ----------------------------------------------------------------------- */

// Marker local that flags a placeable as managed by this system.
const string PLC_MANAGED_TAG = "CPPS_UUID";

// Pending-edit storage written by the open windows, read by the component
// apply scripts (nui_plc_move / _rotate / _scale).
const string VAR_PLC_MOVE_X = "NUI_PLC_MOVE_X";
const string VAR_PLC_MOVE_Y = "NUI_PLC_MOVE_Y";
const string VAR_PLC_MOVE_Z = "NUI_PLC_MOVE_Z";


/* ----------------------------------------------------------------------- */
/*  FORWARD DECLARATIONS                                                    */
/* ----------------------------------------------------------------------- */

// Open the manager action hub.
void NUI_PlcManagerOpen(object oPC);

// Lock onto the nearest managed placeable near a clicked position.
void NUI_PlcLockTarget(object oPC, vector vClickPos);

// Open the move window for the locked placeable.
void NUI_PlcMoveOpen(object oPC);

// Open the rotate window for the locked placeable.
void NUI_PlcRotateOpen(object oPC);

// Open the scale window for the locked placeable.
void NUI_PlcScaleOpen(object oPC);

// Open the plot-flag toggle window (DM only).
void NUI_PlcPlotOpen(object oPC);

// Open the delete-confirmation window.
void NUI_PlcDeleteOpen(object oPC);

// Return a JSON array of nearby managed placeable names (max nMax).
json NUI_PlcGetNearbyList(object oPC, int nMax = 20);


/* ======================================================================= */
/*  IMPLEMENTATION                                                          */
/* ======================================================================= */

void NUI_PlcManagerOpen(object oPC)
{
    if (!GetIsPC(oPC) && !GetIsDM(oPC)) return;
    if (!PlcSystemEnabled())
    {
        NUI_PopupMessage(oPC, "Placeable Manager",
                         "This system is currently disabled.");
        return;
    }

    // One button per action, drawn from the PLC_ACTIONS table.
    json jActionBtns = JsonArray();
    int  i = 0;
    while (i < 8)
    {
        json jBtn = NuiButton(JsonString(
                        GetTokenByPosition(PLC_ACTIONS, "+", i)));
        jBtn = NuiId(jBtn, "action_" + IntToString(i));
        jBtn = NuiHeight(jBtn, 24.0);
        jActionBtns = JsonArrayInsert(jActionBtns, jBtn);
        i++;
    }

    json jLabel = NuiLabel(JsonString("Placeable Manager"),
                           NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jLabel = NuiHeight(jLabel, 24.0);

    json jInfo = NuiText(JsonString(
        "Lock a nearby managed placeable, then choose an action."));
    jInfo = NuiHeight(jInfo, 50.0);

    json jGroup = NuiGroup(JsonArray(jActionBtns), TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiHeight(jGroup, 250.0);

    json jContent = JsonArray3(
        JsonArray1(jLabel), jInfo, jGroup);

    NUI_SetDialogType(oPC, NUI_DIALOG_PLACEABLE);
    int nToken = NUI_DialogCreate(oPC, "Placeable Manager", jContent,
                                  "", NUI_BTN_CLOSE, NUI_PLACE_BELOW,
                                  "", "nui_plc_evt", 0, 450.0, 400.0);
    NUI_SetDialogToken(oPC, nToken);
    SetLocalInt(oPC, VAR_PLC_MODE, NUI_PLC_MODE_LOCK);
}

void NUI_PlcLockTarget(object oPC, vector vClickPos)
{
    if (!GetIsPC(oPC) && !GetIsDM(oPC)) return;

    location lClickLoc = Location(GetArea(oPC), vClickPos, GetFacing(oPC));
    int bIsAdmin = (GetIsDM(oPC) || GetIsDMPossessed(oPC));
    int      nNth      = 1;
    object   oNearest  = OBJECT_INVALID;

    while (nNth <= 10)
    {
        object oPl = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE,
                                                lClickLoc, nNth);
        if (!GetIsObjectValid(oPl)) break;
        if (!bIsAdmin && GetDistanceBetween(oPC, oPl) > PLC_RANGE_LIMIT)
            break;

        if (GetLocalString(oPl, PLC_MANAGED_TAG) != "")
        {
            if (bIsAdmin || !GetPlotFlag(oPl))
            {
                oNearest = oPl;
                break;
            }
        }
        nNth++;
    }

    if (GetIsObjectValid(oNearest))
    {
        SetLocalObject(oPC, VAR_PLC_TARGET, oNearest);
        SendMessageToPC(oPC, "Locked onto: " + GetName(oNearest));
        PlcDebug(oPC, "locked " + GetName(oNearest), 2);
    }
    else
    {
        SendMessageToPC(oPC, "No managed placeable found in range.");
    }
}

void NUI_PlcMoveOpen(object oPC)
{
    object oTarget = GetLocalObject(oPC, VAR_PLC_TARGET);
    if (!GetIsObjectValid(oTarget))
    {
        NUI_PopupMessage(oPC, "Move", "No placeable is locked.");
        return;
    }

    vector vPos = GetPosition(oTarget);

    json jLabelX = NuiLabel(JsonString("X:"), JsonInt(NUI_HALIGN_LEFT),
                            JsonInt(NUI_VALIGN_MIDDLE));
    jLabelX = NuiWidth(jLabelX, 30.0);
    json jInputX = NuiId(NuiTextEdit(JsonString(FloatToString(vPos.x, 0, 2)),
                         FALSE), "plc_x");
    jInputX = NuiHeight(jInputX, 24.0);

    json jLabelY = NuiLabel(JsonString("Y:"), JsonInt(NUI_HALIGN_LEFT),
                            JsonInt(NUI_VALIGN_MIDDLE));
    jLabelY = NuiWidth(jLabelY, 30.0);
    json jInputY = NuiId(NuiTextEdit(JsonString(FloatToString(vPos.y, 0, 2)),
                         FALSE), "plc_y");
    jInputY = NuiHeight(jInputY, 24.0);

    json jLabelZ = NuiLabel(JsonString("Z:"), JsonInt(NUI_HALIGN_LEFT),
                            JsonInt(NUI_VALIGN_MIDDLE));
    jLabelZ = NuiWidth(jLabelZ, 30.0);
    json jInputZ = NuiId(NuiTextEdit(JsonString(FloatToString(vPos.z, 0, 2)),
                         FALSE), "plc_z");
    jInputZ = NuiHeight(jInputZ, 24.0);

    json jContent = JsonArray3(
        JsonArray2(jLabelX, jInputX),
        JsonArray2(jLabelY, jInputY),
        JsonArray2(jLabelZ, jInputZ));

    NUI_SetDialogType(oPC, NUI_DIALOG_PLACEABLE);
    int nToken = NUI_DialogCreate(oPC, "Move Placeable", jContent,
                                  NUI_BTN_OK + "", NUI_BTN_CANCEL,
                                  NUI_PLACE_BELOW, "", "nui_plc_move",
                                  0, 350.0, 180.0);
    NUI_SetDialogToken(oPC, nToken);
    SetLocalInt(oPC, VAR_PLC_MODE, NUI_PLC_MODE_MOVE);
}

void NUI_PlcRotateOpen(object oPC)
{
    object oTarget = GetLocalObject(oPC, VAR_PLC_TARGET);
    if (!GetIsObjectValid(oTarget))
    {
        NUI_PopupMessage(oPC, "Rotate", "No placeable is locked.");
        return;
    }

    float fFacing = GetFacing(oTarget);

    json jLabel = NuiLabel(JsonString("Rotation (0 - 360):"),
                           NUI_HALIGN_LEFT, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jLabel = NuiHeight(jLabel, 20.0);

    json jInput = NuiId(NuiTextEdit(JsonString(FloatToString(fFacing, 0, 1)),
                        FALSE), "plc_rot");
    jInput = NuiHeight(jInput, 24.0);

    json jSlider = NuiSliderFloat(fFacing, 0.0, 360.0, 5);
    jSlider = NuiId(jSlider, "plc_rot_slider");
    jSlider = NuiHeight(jSlider, 24.0);

    json jContent = JsonArray3(jLabel, jInput, jSlider);

    NUI_SetDialogType(oPC, NUI_DIALOG_PLACEABLE);
    int nToken = NUI_DialogCreate(oPC, "Rotate Placeable", jContent,
                                  NUI_BTN_OK + "", NUI_BTN_CANCEL,
                                  NUI_PLACE_BELOW, "", "nui_plc_rotate",
                                  0, 350.0, 160.0);
    NUI_SetDialogToken(oPC, nToken);
    SetLocalInt(oPC, VAR_PLC_MODE, NUI_PLC_MODE_ROTATE);
}

void NUI_PlcScaleOpen(object oPC)
{
    object oTarget = GetLocalObject(oPC, VAR_PLC_TARGET);
    if (!GetIsObjectValid(oTarget))
    {
        NUI_PopupMessage(oPC, "Scale", "No placeable is locked.");
        return;
    }

    float fScale = GetLocalFloat(oTarget, "SCALE");
    if (fScale <= 0.0) fScale = 1.0;

    json jLabel = NuiLabel(JsonString("Scale (0.2 - 4.0):"),
                           NUI_HALIGN_LEFT, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jLabel = NuiHeight(jLabel, 20.0);

    json jInput = NuiId(NuiTextEdit(JsonString(FloatToString(fScale, 0, 2)),
                        FALSE), "plc_scale");
    jInput = NuiHeight(jInput, 24.0);

    json jSlider = NuiSliderFloat(fScale, 0.2, 4.0, 1);
    jSlider = NuiId(jSlider, "plc_scale_slider");
    jSlider = NuiHeight(jSlider, 24.0);

    json jContent = JsonArray3(jLabel, jInput, jSlider);

    NUI_SetDialogType(oPC, NUI_DIALOG_PLACEABLE);
    int nToken = NUI_DialogCreate(oPC, "Scale Placeable", jContent,
                                  NUI_BTN_OK + "", NUI_BTN_CANCEL,
                                  NUI_PLACE_BELOW, "", "nui_plc_scale",
                                  0, 350.0, 160.0);
    NUI_SetDialogToken(oPC, nToken);
    SetLocalInt(oPC, VAR_PLC_MODE, NUI_PLC_MODE_SCALE);
}

void NUI_PlcPlotOpen(object oPC)
{
    if (!GetIsDM(oPC) && !GetIsDMPossessed(oPC))
    {
        NUI_PopupMessage(oPC, "Plot Flag", "This action is DM only.");
        return;
    }

    object oTarget = GetLocalObject(oPC, VAR_PLC_TARGET);
    if (!GetIsObjectValid(oTarget))
    {
        NUI_PopupMessage(oPC, "Plot Flag", "No placeable is locked.");
        return;
    }

    string sState = "DISABLED";
    if (GetPlotFlag(oTarget)) sState = "ENABLED";

    json jLabel = NuiLabel(JsonString("Plot Protection: " + sState),
                           NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jLabel = NuiHeight(jLabel, 40.0);

    json jContent = JsonArray1(jLabel);

    NUI_SetDialogType(oPC, NUI_DIALOG_PLACEABLE);
    int nToken = NUI_DialogCreate(oPC, "Plot Flag", jContent,
                                  NUI_BTN_OK + "", NUI_BTN_CANCEL,
                                  NUI_PLACE_SIDES, "", "nui_plc_plot",
                                  0, 350.0, 130.0);
    NUI_SetDialogToken(oPC, nToken);
    SetLocalInt(oPC, VAR_PLC_MODE, NUI_PLC_MODE_PLOT);
}

void NUI_PlcDeleteOpen(object oPC)
{
    object oTarget = GetLocalObject(oPC, VAR_PLC_TARGET);
    if (!GetIsObjectValid(oTarget))
    {
        NUI_PopupMessage(oPC, "Delete", "No placeable is locked.");
        return;
    }

    string sName  = GetName(oTarget);
    int    nValue = GetLocalInt(oTarget, "GOLD_VALUE");

    json jLabel = NuiLabel(JsonString("Delete " + sName +
                           "  (refund " + IntToString(nValue) + " gp)"),
                           NUI_HALIGN_CENTER, JsonInt(JsonInt(NUI_VALIGN_MIDDLE)));
    jLabel = NuiHeight(jLabel, 60.0);

    json jContent = JsonArray1(jLabel);

    NUI_SetDialogType(oPC, NUI_DIALOG_PLACEABLE);
    int nToken = NUI_DialogCreate(oPC, "Delete Placeable", jContent,
                                  NUI_BTN_OK + "", NUI_BTN_CANCEL,
                                  NUI_PLACE_SIDES, "", "nui_plc_delete",
                                  0, 350.0, 150.0);
    NUI_SetDialogToken(oPC, nToken);
    SetLocalInt(oPC, VAR_PLC_MODE, NUI_PLC_MODE_DELETE);
}

json NUI_PlcGetNearbyList(object oPC, int nMax = 20)
{
    json   jList = JsonArray();
    int    nNth  = 1;
    object oPl   = GetFirstObjectInShape(SHAPE_SPHERE, PLC_RANGE_LIMIT,
                                         GetLocation(oPC), FALSE);

    while (GetIsObjectValid(oPl) && nNth <= nMax)
    {
        if (GetObjectType(oPl) == OBJECT_TYPE_PLACEABLE &&
            GetLocalString(oPl, PLC_MANAGED_TAG) != "")
        {
            jList = JsonArrayInsert(jList, JsonString(
                        GetName(oPl) + " [" + IntToString(nNth) + "]"));
            nNth++;
        }
        oPl = GetNextObjectInShape(SHAPE_SPHERE, PLC_RANGE_LIMIT,
                                   GetLocation(oPC), FALSE);
    }

    return jList;
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
