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
        Constants and helpers for the custom tailoring / equipment system,
        which lets a player recolor and restyle armor parts, cloaks,
        helmets, shields, and weapons.

    DEPENDENCIES
        nui_api (which in turn includes nui_framework)

    USAGE
        #include "nui_ct_api"
        if (!CtSystemEnabled()) return;

    EXAMPLE (beginner)
        // Get the name of armor part 8 (Torso).
        string sPart = GetTokenByPosition(CT_PARTS, "+", 7);

    EXAMPLE (intermediate)
        // Switch the menu into color mode and remember it.
        SetLocalInt(oPC, NUI_VAR_CT_MODE, NUI_CT_MODE_COLOR);
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

/* ----------------------------------------------------------------------- */
/*  MENU MODES                                                              */
/* ----------------------------------------------------------------------- */

const int NUI_CT_MODE_MAIN   = 1;
const int NUI_CT_MODE_PART   = 2;
const int NUI_CT_MODE_COLOR  = 3;
const int NUI_CT_MODE_ITEM   = 4;
const int NUI_CT_MODE_WEAPON = 5;

/* ----------------------------------------------------------------------- */
/*  DATA TABLES (pipe-delimited)                                           */
/* ----------------------------------------------------------------------- */

// 19 armor part slots.
const string CT_PARTS = "Right Foot+Left Foot+Right Shin+Left Shin+Right Thigh+Left Thigh+Pelvis+Torso+Belt+Neck+Right Forearm+Left Forearm+Right Bicep+Left Bicep+Right Shoulder+Left Shoulder+Right Hand+Left Hand+Robe";

// 4 equippable item categories.
const string CT_ITEMS = "Cloak+Helmet+Shield+Weapon";

// 11 color channels.
const string CT_COLORS = "Leather 1+Leather 2+Cloth 1+Cloth 2+Metal 1+Metal 2+Leather (Composite)+Cloth (Composite)+Metal (Composite)+Leather+Cloth+All Materials";

/* ----------------------------------------------------------------------- */
/*  LOCAL-VARIABLE KEYS                                                     */
/* ----------------------------------------------------------------------- */

const string NUI_NUI_VAR_CT_MODE      = "NUI_CT_MODE";
const string NUI_VAR_CT_PART      = "NUI_CT_PART";
const string NUI_VAR_CT_ITEM      = "NUI_CT_ITEM";
const string NUI_VAR_CT_COLOR     = "NUI_CT_COLOR";
const string NUI_VAR_CT_WEAP_PART = "NUI_CT_WEAP_PART";

// Specific color storage variables
const string NUI_VAR_ARMOR_COLOR  = "NUI_CT_ARMOR_COLOR";
const string NUI_VAR_WEAPON_COLOR = "NUI_CT_WEAPON_COLOR";

/* ----------------------------------------------------------------------- */
/*  SERVICES                                                                */
/* ----------------------------------------------------------------------- */

// Return TRUE if the tailoring system is enabled at compile time.
int CtSystemEnabled();

// Emit a tailoring debug line (gated by NUI_DEBUG and NUI_DEBUG_CT).
void CtDebug(object oPC, string sMessage, int nLevel);


int CtSystemEnabled()
{
    return NUI_CT;
}

void CtDebug(object oPC, string sMessage, int nLevel)
{
    NUI_DebugCt(oPC, sMessage, nLevel);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
