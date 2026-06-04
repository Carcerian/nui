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
        Constants and helpers for the emote and interaction system,
        including phenotype ids, interaction modes, and a simple consent
        scale used to gate paired interactions.

    DEPENDENCIES
        nui_api (which in turn includes nui_framework)

    USAGE
        #include "nui_em_api"
        if (!EmoteSystemEnabled()) return;

    EXAMPLE (beginner)
        // Default everyone to the solo interaction mode.
        SetLocalInt(oPC, NUI_VAR_EMOTE_MODE, EMOTE_MODE_SOLO);

    EXAMPLE (intermediate)
        // Require mutual consent before a paired emote proceeds.
        if (GetLocalInt(oTarget, NUI_VAR_EMOTE_CONSENT) < CONSENT_ACCEPT) return;
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
/*  PHENOTYPES                                                              */
/* ----------------------------------------------------------------------- */

const int PHENO_NORMAL      = 0;
const int PHENO_LARGE       = 2;
const int PHENO_CUSTOM_9    = 9;
const int PHENO_CUSTOM_19   = 19;
const int PHENO_CUSTOM_75   = 75;
const int PHENO_CUSTOM_100  = 100;
const int PHENO_CUSTOM_101  = 101;

/* ----------------------------------------------------------------------- */
/*  INTERACTION MODES                                                       */
/* ----------------------------------------------------------------------- */

const int EMOTE_MODE_SOLO = 1;   // Single character.
const int EMOTE_MODE_MF   = 2;   // Paired, variant A.
const int EMOTE_MODE_FF   = 3;   // Paired, variant B.

/* ----------------------------------------------------------------------- */
/*  CONSENT SCALE                                                           */
/* ----------------------------------------------------------------------- */

const int CONSENT_NONE    = 0;
const int CONSENT_PENDING = 1;
const int CONSENT_ACCEPT  = 2;
const int CONSENT_DECLINE = 3;
const int CONSENT_BLOCK   = 4;

/* ----------------------------------------------------------------------- */
/*  LOCAL-VARIABLE KEYS                                                     */
/* ----------------------------------------------------------------------- */

const string NUI_VAR_EMOTE_MODE    = "NUI_EMOTE_MODE";
const string VAR_EMOTE_PHENO   = "NUI_EMOTE_PHENO";
const string NUI_VAR_EMOTE_CONSENT = "NUI_EMOTE_CONSENT";
const string VAR_EMOTE_PARTNER = "NUI_EMOTE_PARTNER";

/* ----------------------------------------------------------------------- */
/*  SERVICES                                                                */
/* ----------------------------------------------------------------------- */

// Return TRUE if the emote system is enabled at compile time.
int EmoteSystemEnabled();

// Emit an emote debug line (gated by NUI_DEBUG and NUI_DEBUG_EMOTE).
void EmoteDebug(object oPC, string sMessage, int nLevel);


int EmoteSystemEnabled()
{
    return NUI_EMOTE;
}

void EmoteDebug(object oPC, string sMessage, int nLevel)
{
    NUI_DebugEmote(oPC, sMessage, nLevel);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
