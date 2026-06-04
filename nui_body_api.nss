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
        Constants, limits, and helpers for the body adjustment system, which
        lets a player nudge the position and scale of body parts (head,
        wings, tail, and the whole self).

    DEPENDENCIES
        nui_api (which in turn includes nui_framework)

    USAGE
        #include "nui_body_api"
        if (!BodySystemEnabled()) return;

    EXAMPLE (beginner)
        // Read the configured scale ceiling.
        float fMax = BODY_SCALE_MAX;

    EXAMPLE (intermediate)
        // Resolve a part id to its display name.
        string sPart = GetTokenByPosition(BODY_PARTS, "+", BODY_PART_WINGS);
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
/*  PART IDENTIFIERS                                                        */
/* ----------------------------------------------------------------------- */

const int BODY_PART_HEAD  = 1;
const int BODY_PART_WINGS = 2;
const int BODY_PART_TAIL  = 3;
const int BODY_PART_SELF  = 4;

// Display names, indexed (part id - 1).
const string BODY_PARTS = "Head+Wings+Tail+Self";

/* ----------------------------------------------------------------------- */
/*  ADJUSTMENT LIMITS                                                       */
/* ----------------------------------------------------------------------- */

const float BODY_OFFSET_MIN  = -2.0;
const float BODY_OFFSET_MAX  =  2.0;
const float BODY_OFFSET_STEP =  0.1;

const float BODY_SCALE_MIN   =  0.1;
const float BODY_SCALE_MAX   =  3.0;
const float BODY_SCALE_STEP  =  0.05;

const int   BODY_UNDO_DEPTH  =  5;

/* ----------------------------------------------------------------------- */
/*  LOCAL-VARIABLE KEYS                                                     */
/* ----------------------------------------------------------------------- */

const string VAR_BODY_PART       = "NUI_BODY_PART";
const string VAR_BODY_UNDO_INDEX = "NUI_BODY_UNDO_IDX";

// Head adjustment variables (NUI_ prefix for core API consistency)
const string NUI_VAR_HEAD_X      = "NUI_BODY_HEAD_X";
const string NUI_VAR_HEAD_Y      = "NUI_BODY_HEAD_Y";
const string NUI_VAR_HEAD_Z      = "NUI_BODY_HEAD_Z";
const string NUI_VAR_HEAD_SCALE  = "NUI_BODY_HEAD_SCALE";

// Wings adjustment variables
const string NUI_VAR_WINGS_X     = "NUI_BODY_WINGS_X";
const string NUI_VAR_WINGS_Y     = "NUI_BODY_WINGS_Y";
const string NUI_VAR_WINGS_Z     = "NUI_BODY_WINGS_Z";
const string NUI_VAR_WINGS_SCALE = "NUI_BODY_WINGS_SCALE";

// Tail adjustment variables
const string NUI_VAR_TAIL_X      = "NUI_BODY_TAIL_X";
const string NUI_VAR_TAIL_Y      = "NUI_BODY_TAIL_Y";
const string NUI_VAR_TAIL_Z      = "NUI_BODY_TAIL_Z";
const string NUI_VAR_TAIL_SCALE  = "NUI_BODY_TAIL_SCALE";

// Self adjustment variables
const string NUI_VAR_SELF_X      = "NUI_BODY_SELF_X";
const string NUI_VAR_SELF_Y      = "NUI_BODY_SELF_Y";
const string NUI_VAR_SELF_Z      = "NUI_BODY_SELF_Z";
const string NUI_VAR_SELF_SCALE  = "NUI_BODY_SELF_SCALE";

/* ----------------------------------------------------------------------- */
/*  SERVICES                                                                */
/* ----------------------------------------------------------------------- */

// Return TRUE if the body system is enabled at compile time.
int BodySystemEnabled();

// Emit a body-system debug line (gated by NUI_DEBUG and NUI_DEBUG_BODY).
void BodyDebug(object oPC, string sMessage, int nLevel);


int BodySystemEnabled()
{
    return NUI_BODY;
}

void BodyDebug(object oPC, string sMessage, int nLevel)
{
    NUI_DebugBody(oPC, sMessage, nLevel);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
