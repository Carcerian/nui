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
        Constants and helpers for the crafting system: recipe categories,
        output quality tiers, and the per-player crafting state keys.

    DEPENDENCIES
        nui_api (which in turn includes nui_framework)

    USAGE
        #include "nui_cf_api"
        if (!CraftSystemEnabled()) return;

    EXAMPLE (beginner)
        // Name a category by id.
        string s = GetTokenByPosition(CRAFT_NAMES, "+", CRAFT_CAT_ARMOR - 1);

    EXAMPLE (intermediate)
        // Gate a high tier result behind a skill check elsewhere, then store:
        SetLocalInt(oPC, NUI_VAR_CRAFT_CATEGORY, CRAFT_CAT_POTION);
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
/*  RECIPE CATEGORIES                                                       */
/* ----------------------------------------------------------------------- */

const int CRAFT_CAT_WEAPON      = 1;
const int CRAFT_CAT_ARMOR       = 2;
const int CRAFT_CAT_ACCESSORY   = 3;
const int CRAFT_CAT_POTION      = 4;
const int CRAFT_CAT_SCROLL      = 5;
const int CRAFT_CAT_JEWELRY     = 6;
const int CRAFT_CAT_OTHER       = 7;
const int CRAFT_CAT_MAX         = 7;

// Display names, indexed (category id - 1).
const string CRAFT_NAMES = "Weapons+Armor+Accessories+Potions+Scrolls+Jewelry+Other";

/* ----------------------------------------------------------------------- */
/*  QUALITY TIERS                                                           */
/* ----------------------------------------------------------------------- */

const int CRAFT_QUALITY_POOR        = 1;
const int CRAFT_QUALITY_NORMAL      = 2;
const int CRAFT_QUALITY_EXCELLENT   = 3;
const int CRAFT_QUALITY_MASTERCRAFT = 4;

/* ----------------------------------------------------------------------- */
/*  LOCAL-VARIABLE KEYS                                                     */
/* ----------------------------------------------------------------------- */

const string NUI_VAR_CRAFT_CATEGORY    = "NUI_CRAFT_CATEGORY";
const string VAR_CRAFT_IS_CRAFTING = "NUI_CRAFT_IS_CRAFTING";
const string VAR_CRAFT_RECIPE      = "NUI_CRAFT_RECIPE";

/* ----------------------------------------------------------------------- */
/*  SERVICES                                                                */
/* ----------------------------------------------------------------------- */

// Return TRUE if the crafting system is enabled at compile time.
int CraftSystemEnabled();

// Emit a crafting debug line (gated by NUI_DEBUG and NUI_DEBUG_CRAFT).
void CraftDebug(object oPC, string sMessage, int nLevel);


int CraftSystemEnabled()
{
    return NUI_CRAFT;
}

void CraftDebug(object oPC, string sMessage, int nLevel)
{
    NUI_DebugCraft(oPC, sMessage, nLevel);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
