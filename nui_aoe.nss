//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::      _____                     _
//::     / ___/__ ____________ ____(_)__ ____ ( )___
//::    / /__/ _ `/ __/ __/ -_) __/ / _ `/ _ \|/(_-<
//::    \___/\_,_/_/  \__/\__/_/ /_/\_,_/_//_/ /___/
//::         _  ____  ______    ___   ___  ____
//::        / |/ / / / /  _/   / _ | / _ \/  _/
//::       /    / /_/ // /    / __ |/ ___// /
//::      /_/|_/\____/___/   /_/ |_/_/  /___/
//::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - AOE Window System
//:: nui_aoe.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 3, 2026
//:: MODIFIED: AOE + Window integration system
//::///////////////////////////////////////////////////////////////////////
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        AOE-based window system that ties NUI popups to area effects.
        When AOE expires or player exits, window closes automatically.
        Perfect for location-based interactions (shrines, merchants, etc).

        Behavior:
        - NUI window spawns with AOE at object location
        - Window closes when player exits AOE
        - AOE deletes when window closes
        - 5 minute default duration

    DEPENDENCIES
        nui_api.nss (for popup functions)
        nui_aoe.nss (this file)

    USAGE
        #include "nui_api"
        #include "nui_aoe"

        void main()
        {
            object oPC = GetPCSpeaker();
            object oArea = GetArea(oPC);
            location lLoc = GetLocation(oPC);

            NUI_AOE_CreatePopup(oPC, lLoc,
                "Window Title",
                "message_content",
                "event_handler");
        }

*/
//::///////////////////////////////////////////////////////////////////////

#include "nui_api"

/* ----------------------------------------------------------------------- */
/*  LOCAL VARIABLE STORAGE KEYS                                            */
/* ----------------------------------------------------------------------- */

// AOE Configuration constants are defined in nui_api_config.nss:
// NUI_AOE_DURATION, NUI_AOE_RADIUS, NUI_AOE_VFX

// On AOE object:
//   "NUI_DIALOG_TOKEN" = int (dialog token from NuiCreate)
//   "NUI_DIALOG_PC" = object (player using popup)
//   "NUI_DIALOG_HANDLER" = string (event handler script)

// On PC object:
//   "NUI_AOE_OBJECT" = object (AOE assigned to player)

/* ----------------------------------------------------------------------- */
/*  PUBLIC FORWARD DECLARATIONS                                             */
/* ----------------------------------------------------------------------- */

int NUI_AOE_CreatePopup(object oPC, location lLoc, string sTitle,
                        string sContent, string sScript);
int NUI_AOE_CreateMessage(object oPC, location lLoc, string sTitle,
                          string sMessage, string sScript);
void NUI_AOE_OnExit(object oAOE, object oPC);

/* ----------------------------------------------------------------------- */
/*  IMPLEMENTATIONS                                                         */
/* ----------------------------------------------------------------------- */

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_AOE_CreatePopup
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Create NUI popup with AOE - closes when player exits
//:: Parameters:   oPC = player receiving popup
//::               lLoc = location to spawn AOE
//::               sTitle = window title
//::               sContent = popup content text
//::               sScript = event handler script
//:: Returns:      int (AOE object, NUI_ERROR on failure)
//::///////////////////////////////////////////////////////////////////////////
int NUI_AOE_CreatePopup(object oPC, location lLoc, string sTitle,
                        string sContent, string sScript)
{
    if (!GetIsPC(oPC)) return 0;

    // Create the popup window
    int nToken = NUI_PopupCustom(oPC, sTitle, sContent, sScript);
    if (nToken <= 0) return 0;

    // Create AOE at location
    object oAOE = CreateObject(OBJECT_TYPE_AREA_OF_EFFECT, "nw_aoe_web", lLoc);
    if (!GetIsObjectValid(oAOE)) {
        NuiDestroy(oPC, nToken);
        return 0;
    }

    // Store dialog info on AOE
    SetLocalInt(oAOE, "NUI_DIALOG_TOKEN", nToken);
    SetLocalObject(oAOE, "NUI_DIALOG_PC", oPC);
    SetLocalString(oAOE, "NUI_DIALOG_HANDLER", sScript);

    // Store AOE reference on PC
    SetLocalObject(oPC, "NUI_AOE_OBJECT", oAOE);

    // Set AOE duration
    DelayCommand(IntToFloat(NUI_AOE_DURATION), NUI_AOE_Cleanup(oAOE, oPC));

    return nToken;
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_AOE_CreateMessage
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Create simple message popup with AOE
//:: Parameters:   oPC = player receiving message
//::               lLoc = location to spawn AOE
//::               sTitle = window title
//::               sMessage = message text
//::               sScript = event handler script
//:: Returns:      int (dialog token, NUI_ERROR on failure)
//::///////////////////////////////////////////////////////////////////////////
int NUI_AOE_CreateMessage(object oPC, location lLoc, string sTitle,
                          string sMessage, string sScript)
{
    if (!GetIsPC(oPC)) return 0;

    // Create the message popup
    int nToken = NUI_PopupMessage(oPC, sTitle, sMessage, sScript);
    if (nToken <= 0) return 0;

    // Create AOE at location
    object oAOE = CreateObject(OBJECT_TYPE_AREA_OF_EFFECT, "nw_aoe_web", lLoc);
    if (!GetIsObjectValid(oAOE)) {
        NuiDestroy(oPC, nToken);
        return 0;
    }

    // Store dialog info on AOE
    SetLocalInt(oAOE, "NUI_DIALOG_TOKEN", nToken);
    SetLocalObject(oAOE, "NUI_DIALOG_PC", oPC);
    SetLocalString(oAOE, "NUI_DIALOG_HANDLER", sScript);

    // Store AOE reference on PC
    SetLocalObject(oPC, "NUI_AOE_OBJECT", oAOE);

    // Set AOE duration
    DelayCommand(IntToFloat(NUI_AOE_DURATION), NUI_AOE_Cleanup(oAOE, oPC));

    return nToken;
}

//::///////////////////////////////////////////////////////////////////////////
//:: NUI_AOE_OnExit
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Called when creature exits AOE (from AOE's OnExit event)
//:: Parameters:   oAOE = AOE object
//::               oPC = creature exiting AOE
//:: Returns:      void
//:: Notes:        Place in AOE OnExit script
//::               Only closes window if exiting PC is the owner
//::///////////////////////////////////////////////////////////////////////////
void NUI_AOE_OnExit(object oAOE, object oPC)
{
    if (!GetIsPC(oPC)) return;

    // Get stored dialog info
    int nToken = GetLocalInt(oAOE, "NUI_DIALOG_TOKEN");
    object oStoredPC = GetLocalObject(oAOE, "NUI_DIALOG_PC");

    // SECURITY: Only close if this is the PC who owns the window
    // Prevent other players from closing someone else's sign
    if (oPC != oStoredPC) return;

    if (nToken > 0) {
        // Close the window directly with NuiDestroy
        NuiDestroy(oPC, nToken);

        // Delete the AOE (pass oPC for security verification)
        NUI_AOE_Cleanup(oAOE, oPC);
    }
}

//::///////////////////////////////////////////////////////////////////////////
//:: main() - Currently unused
//::///////////////////////////////////////////////////////////////////////////
//:: Description: Entry point for AOE module
//:: Note:        AOE-based window closing requires manual cleanup
//::              Use NUI_AOE_OnExit() to close windows tied to AOE
//::///////////////////////////////////////////////////////////////////////////
void main()
{
    // This script can be called to manually clean up AOE windows
    // Currently, AOE window closing is handled via:
    // 1. Player clicking Close button manually
    // 2. Module cleanup when AOE expires (99999 second timer)
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
