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
        Constants and helpers for the persistent visual accessory system.

        A player keeps a saved list of "visual accessories". Each accessory
        is a named visual effect anchored to one orientation point on the
        character. Accessories persist across sessions and can be toggled on
        or off, renamed, or deleted individually.

        Orientation is deliberately limited to two points:
            HEAD  - effects that sit at or above the head.
            CHEST - effects centered on the torso.

        Per accessory the player controls:
            on / off   - whether the effect is currently shown.
            name       - a short label for the accessory.
            delete     - remove the accessory from the list.
        A list box selects which saved accessory is being edited.

    DEPENDENCIES
        nui_api (which in turn includes nui_framework)

    USAGE
        #include "nui_vfx_api"
        if (!VfxSystemEnabled()) return;

    EXAMPLE (beginner)
        // Name an orientation point.
        string sPoint = GetTokenByPosition(VFX_POINTS, "+", VFX_POINT_CHEST);

    EXAMPLE (intermediate)
        // Look up the row id for the third effect in the catalog.
        int nRow = StringToInt(GetTokenByPosition(VFX_EFFECT_ROWS, "+", 2));

    EXAMPLE (advanced)
        // Accessory record layout (stored as a JSON object per accessory):
        //   { "name": "Halo", "row": 142, "point": 0, "on": 1 }
        // The full list is a JSON array of these, persisted by the module.
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
#include "nui_log"

const int VFX_POINT_HEAD  = 0;
const int VFX_POINT_CHEST = 1;

// Point labels, indexed by VFX_POINT_*.
const string VFX_POINTS = "Head+Chest";

/* ----------------------------------------------------------------------- */
/*  EFFECT CATALOG                                                          */
/*  Parallel pipe-delimited tables: a display label, an internal key, and  */
/*  a CEP2 visualeffects.2da row. Row numbers are placeholders; replace     */
/*  them with the real rows from your installed hak.                        */
/* ----------------------------------------------------------------------- */

const string VFX_EFFECT_LABELS = "Fire (Small)+Fire (Medium)+Ice+Lightning+Magic (Blue)+Magic (Purple)+Holy Light+Shadow+Heal (Green)+Sparkles+Smoke+Flame Aura+Electric Arc+Portal+Shimmer";
const string VFX_EFFECT_KEYS   = "fire_s+fire_m+ice+lightning+magic_blue+magic_purple+holy+shadow+heal+sparkles+smoke+flame_aura+elec_arc+portal+shimmer";
const string VFX_EFFECT_ROWS   = "0+0+0+0+0+0+0+0+0+0+0+0+0+0+0";

/* ----------------------------------------------------------------------- */
/*  ACCESSORY RECORD FIELD KEYS                                            */
/* ----------------------------------------------------------------------- */

const string VFX_FIELD_NAME  = "name";
const string VFX_FIELD_ROW   = "row";
const string VFX_FIELD_POINT = "point";
const string VFX_FIELD_ON    = "on";

/* ----------------------------------------------------------------------- */
/*  LOCAL-VARIABLE KEYS                                                     */
/* ----------------------------------------------------------------------- */

const string VAR_VFX_LIST     = "NUI_VFX_LIST";      // JSON array of records.
const string VAR_VFX_SELECTED = "NUI_VFX_SELECTED";  // Index being edited.

/* ----------------------------------------------------------------------- */
/*  SERVICES                                                                */
/* ----------------------------------------------------------------------- */

// Return TRUE if the visual accessory system is enabled at compile time.
int VfxSystemEnabled();

// Emit a VFX debug line (gated by NUI_DEBUG and NUI_DEBUG_VFX).
void VfxDebug(object oPC, string sMessage, int nLevel);


int VfxSystemEnabled()
{
    return NUI_VFX;
}

void VfxDebug(object oPC, string sMessage, int nLevel)
{
    NUI_Log(oPC, "[VFX] " + sMessage, nLevel);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
