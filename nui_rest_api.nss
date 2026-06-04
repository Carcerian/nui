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
        Constants and helpers for the dynamic rest menu, a persistent-world
        style hub the player opens in place of, or alongside, the default
        rest behavior. It collects the options players reach for most often
        on a PW: resting, making camp, meditating, saving, quick emotes,
        editing their description, and toggling whether rest is allowed.

        DESIGN NOTE - NON-INTERRUPTING
        The menu is shown with NuiCreate, which simply displays a window. It
        never calls ClearAllActions and never queues an action on the PC, so
        opening the menu does NOT interrupt a running animation, walk, or
        emote. Only the player's explicit choice (for example, pressing
        Rest) queues an action. This lets a player pose or emote and open
        the menu at the same time without breaking the pose.

    DEPENDENCIES
        nui_api (which in turn includes nui_framework)

    USAGE
        #include "nui_rest_api"
        if (!RestSystemEnabled()) return;

    EXAMPLE (beginner)
        // Name the first menu action.
        string s = GetTokenByPosition(REST_ACTIONS, "+", REST_ACT_REST);

    EXAMPLE (intermediate)
        // Block resting in a no-rest area but still allow the menu.
        SetLocalInt(oPC, NUI_VAR_REST_ALLOWED, FALSE);

    EXAMPLE (advanced)
        // Add a server-specific action: append it to REST_ACTIONS, give it
        // the next REST_ACT_* id, and handle that id in nui_rest_evt.
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
//:: Created: June 1, 2026
//:: MODIFIED: June 5, 2026 - Production release
//::///////////////////////////////////////////////////////////////////////

#include "nui_api"
#include "nui_validate"

/* ----------------------------------------------------------------------- */
/*  MENU ACTIONS                                                            */
/*  Ids index into REST_ACTIONS. Keep the two lists in sync.               */
/* ----------------------------------------------------------------------- */

const int REST_ACT_REST     = 0;   // Standard rest (recover HP / spells).
const int REST_ACT_CAMP     = 1;   // Make camp (place a campfire, group).
const int REST_ACT_MEDITATE = 2;   // Meditate pose, no mechanical rest.
const int REST_ACT_SAVE     = 3;   // Save character.
const int REST_ACT_DESC     = 4;   // Edit short / long description.
const int REST_ACT_EMOTE    = 5;   // Open quick emotes.
const int REST_ACT_TOGGLE   = 6;   // Toggle whether rest is allowed.
const int REST_ACT_CANCEL   = 7;   // Close the menu.

const string REST_ACTIONS = "Rest+Make Camp+Meditate+Save Character+Edit Description+Quick Emotes+Toggle Rest+Cancel";

/* ----------------------------------------------------------------------- */
/*  LOCAL-VARIABLE KEYS                                                     */
/* ----------------------------------------------------------------------- */

const string NUI_NUI_VAR_REST_ALLOWED  = "NUI_REST_ALLOWED";   // 1 allow, 0 block.
const string NUI_VAR_REST_CAMPING  = "NUI_REST_CAMPING";   // 1 while camped.
const string NUI_VAR_REST_MODE     = "NUI_REST_MODE";      // Current rest mode.
const string NUI_VAR_REST_DURATION = "NUI_REST_DURATION";  // Rest duration in minutes.

/* ----------------------------------------------------------------------- */
/*  SERVICES                                                                */
/* ----------------------------------------------------------------------- */

// Return TRUE if the rest menu is enabled at compile time.
int RestSystemEnabled();

// Return TRUE if resting is currently allowed for oPC. Defaults to allowed
// when the variable has never been set.
int RestIsAllowed(object oPC);

// Emit a rest-menu debug line (gated by NUI_DEBUG and NUI_DEBUG_REST).
void RestDebug(object oPC, string sMessage, int nLevel);


int RestSystemEnabled()
{
    return NUI_REST;
}

int RestIsAllowed(object oPC)
{
    // Treat "never set" (default 0 from GetLocalInt) as allowed by storing
    // an explicit blocked flag instead. A separate "set" marker keeps the
    // default permissive.
    if (!GetLocalInt(oPC, NUI_NUI_VAR_REST_ALLOWED + "_SET")) return TRUE;
    return GetLocalInt(oPC, NUI_NUI_VAR_REST_ALLOWED);
}

void RestDebug(object oPC, string sMessage, int nLevel)
{
    NUI_DebugRest(oPC, sMessage, nLevel);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
