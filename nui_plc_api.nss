//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::      _____                     _          _        
//::     / ___/__ ____________ ____(_)__ ____ ( )___    
//::    / /__/ _ `/ __/ __/ -_) __/ / _ `/ _ \|/(_-<    
//::    \___/\_,_/_/  \__/\__/_/ /_/\_,_/_//_/ /___/    
//::         _  ____  ______    ___   ___  ____         
//::        / |/ / / / /  _/   / _ | / _ \/  _/         
//::       /    / /_/ // /    / __ |/ ___// /           
//::      /_/|_/\____/___/   /_/ |_/_/  /___/           
//::                                                     
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/*
    SYNOPSIS
        Constants and helpers for the placeable manager, which lets an
        authorized builder lock onto a placeable and move, rotate, scale,
        restyle, plot-flag, or remove it.

    DEPENDENCIES
        nui_api (which in turn includes nui_framework)

    USAGE
        #include "nui_plc_api"
        if (!PlcSystemEnabled()) return;

    EXAMPLE (beginner)
        // Read the maximum interaction range.
        float fRange = PLC_RANGE_LIMIT;

    EXAMPLE (intermediate)
        // Put the manager into rotate mode.
        SetLocalInt(oPC, NUI_VAR_PLC_MODE, NUI_PLC_MODE_ROTATE);
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
#include "nui_validate"

/* ----------------------------------------------------------------------- */
/*  MANAGER MODES                                                           */
/* ----------------------------------------------------------------------- */

const int NUI_PLC_MODE_LOCK   = 1;
const int NUI_PLC_MODE_MOVE   = 2;
const int NUI_PLC_MODE_ROTATE = 3;
const int NUI_PLC_MODE_SCALE  = 4;
const int NUI_PLC_MODE_MATS   = 5;
const int NUI_PLC_MODE_DELETE = 6;
const int NUI_PLC_MODE_PLOT   = 7;
const int NUI_PLC_MODE_BATCH  = 8;

// Action labels, indexed (mode - 1).
const string PLC_ACTIONS = "Lock Target+Move+Rotate+Scale+Materials+Delete+Plot Flag+Batch Ops";

/* ----------------------------------------------------------------------- */
/*  LIMITS                                                                  */
/* ----------------------------------------------------------------------- */

const float PLC_RANGE_LIMIT = 30.0;   // Max distance to a managed placeable.

/* ----------------------------------------------------------------------- */
/*  LOCAL-VARIABLE KEYS                                                     */
/* ----------------------------------------------------------------------- */

const string NUI_VAR_PLC_MODE   = "NUI_PLC_MODE";
const string VAR_PLC_TARGET = "NUI_PLC_TARGET";

/* ----------------------------------------------------------------------- */
/*  SERVICES                                                                */
/* ----------------------------------------------------------------------- */

// Return TRUE if the placeable manager is enabled at compile time.
int PlcSystemEnabled();

// Emit a placeable debug line (gated by NUI_DEBUG and NUI_DEBUG_PLC).
void PlcDebug(object oPC, string sMessage, int nLevel);


int PlcSystemEnabled()
{
    return NUI_PLC;
}

void PlcDebug(object oPC, string sMessage, int nLevel)
{
    NUI_DebugPlc(oPC, sMessage, nLevel);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
