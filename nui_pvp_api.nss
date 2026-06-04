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
        Constants and helpers for the PvP options panel. The panel presents
        three side-by-side player lists grouped by relationship to the
        viewer, with global PvP setting controls below them:

            ALLY / PARTY   - the viewer's party (the viewer is listed first),
                             then friendly players.
            NEUTRAL        - players with no standing either way.
            HOSTILE        - players flagged hostile to the viewer.

        Intended for DM and admin use.

    DEPENDENCIES
        nui_api (which in turn includes nui_framework)

    USAGE
        #include "nui_pvp_api"
        if (!PvPSystemEnabled()) return;

    EXAMPLE (beginner)
        // Name the middle list column.
        string s = GetTokenByPosition(PVP_LIST_NAMES, "+", PVP_LIST_NEUTRAL);

    EXAMPLE (intermediate)
        // Apply the Roleplay preset id to the viewer's session.
        SetLocalInt(oPC, NUI_VAR_PVP_PRESET, PVP_PRESET_ROLEPLAY);

    EXAMPLE (advanced)
        // Categorize a player for placement in one of the three columns.
        int nList;
        if (GetIsFriend(oOther, oViewer))      nList = PVP_LIST_ALLY;
        else if (GetIsEnemy(oOther, oViewer))  nList = PVP_LIST_HOSTILE;
        else                                   nList = PVP_LIST_NEUTRAL;
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
/*  PLAYER LIST COLUMNS                                                     */
/* ----------------------------------------------------------------------- */

const int PVP_LIST_ALLY    = 0;   // Party (viewer first), then friendly.
const int PVP_LIST_NEUTRAL = 1;   // No standing.
const int PVP_LIST_HOSTILE = 2;   // Hostile to the viewer.

// Column headers, indexed by PVP_LIST_*.
const string PVP_LIST_NAMES = "Ally / Party+Neutral+Hostile";

/* ----------------------------------------------------------------------- */
/*  SETTING PRESETS                                                         */
/* ----------------------------------------------------------------------- */

const int PVP_PRESET_ROLEPLAY    = 1;
const int PVP_PRESET_PROGRESSION = 2;
const int PVP_PRESET_COMBAT      = 3;
const int PVP_PRESET_CUSTOM      = 4;

// Preset labels, indexed (preset id - 1).
const string PVP_PRESETS = "Roleplay+Progression+Combat+Custom";

/* ----------------------------------------------------------------------- */
/*  LOCAL-VARIABLE KEYS                                                     */
/* ----------------------------------------------------------------------- */

const string NUI_NUI_VAR_PVP_PRESET   = "NUI_PVP_PRESET";
const string NUI_VAR_PVP_SELECTED = "NUI_PVP_SELECTED";   // CDKey of focused row.
const string NUI_VAR_PVP_MODE     = "NUI_PVP_MODE";

/* ----------------------------------------------------------------------- */
/*  SERVICES                                                                */
/* ----------------------------------------------------------------------- */

// Return TRUE if the PvP options panel is enabled at compile time.
int PvPSystemEnabled();

// Emit a PvP debug line (gated by NUI_DEBUG and NUI_DEBUG_PVP).
void PvPDebug(object oPC, string sMessage, int nLevel);


int PvPSystemEnabled()
{
    return NUI_PVP;
}

void PvPDebug(object oPC, string sMessage, int nLevel)
{
    NUI_DebugPvP(oPC, sMessage, nLevel);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
