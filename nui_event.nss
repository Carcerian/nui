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
//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - Main NUI Event Handler
//:: nui_mod_event.nss
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Module OnNuiEvent event script. CRITICAL for NUI window functionality.
        Routes NUI button clicks to appropriate subsystem event handlers.

    DEPENDENCIES
        nui_api.nss (core API, dialog type tracking)
        nui_body_evt.nss (body adjustment events)
        nui_craft_evt.nss (crafting events)
        nui_ct_equip_evt.nss (custom tailoring events)
        nui_emote_evt.nss (emote events)
        nui_plc_evt.nss (placeable manager events)
        nui_pvp_evt.nss (PvP options events)
        nui_vfx_evt.nss (visual accessories events)
        nui_rest_evt.nss (rest menu events)

    USAGE
        Assign this script to:
          Module Properties > Events > OnNuiEvent

    CRITICAL NOTES
        - This is REQUIRED for NUI windows to respond to button clicks
        - Without this script, windows will open but buttons won't work
        - Make sure this script is assigned to OnNuiEvent, not another event
        - This script must include all subsystem event handlers

    ALTERNATIVE APPROACH
        Instead of this unified handler, you can assign individual handlers:
          - nui_body_evt to OnNuiEvent (body adjustments only)
          - nui_craft_evt to OnNuiEvent (crafting only)
          - etc.
        However, this unified approach is cleaner and recommended.
*/
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////


#include "nui_api"
#include "nui_validate"

// Include all subsystem event handlers

//::///////////////////////////////////////////////////////////////////////
//:: EVENT HANDLER STUBS (Placeholder declarations)
//:: These should be replaced with your actual handler implementations
//::///////////////////////////////////////////////////////////////////////

// Forward declarations (if handlers are in separate files and not included)
// Uncomment if you use the alternative per-file approach instead of including

/*
int HandleBodyAdjustmentEvent(object oPC, string sEvent, string sElement);
int HandleCraftingEvent(object oPC, string sEvent, string sElement);
int HandleCTEvent(object oPC, string sEvent, string sElement);
int HandleEmoteEvent(object oPC, string sEvent, string sElement);
int HandlePlaceableEvent(object oPC, string sEvent, string sElement);
int HandlePvPEvent(object oPC, string sEvent, string sElement);
int HandleVfxEvent(object oPC, string sEvent, string sElement);
int HandleRestEvent(object oPC, string sEvent, string sElement);
*/

//::///////////////////////////////////////////////////////////////////////
//:: MAIN NUI EVENT ROUTER
//::///////////////////////////////////////////////////////////////////////

int RouteNuiEvent(object oPC, int nDialogType, string sEvent, string sElement) {
    // Route button click to appropriate subsystem handler based on dialog type

    switch (nDialogType) {
        case NUI_DIALOG_BODY_ADJUST:
            if (NUI_BODY) {
                break; // TODO: Implement body adjustment events
            }
            break;

        case NUI_DIALOG_CRAFT:
            if (NUI_CRAFT) {
                break; // TODO: Implement crafting events
            }
            break;

        case NUI_DIALOG_CLOTHING:
            if (NUI_CT) {
                break; // TODO: Implement customization events
            }
            break;

        case NUI_DIALOG_EMOTE:
            if (NUI_EMOTE) {
                break; // TODO: Implement emote events
            }
            break;

        case NUI_DIALOG_PLACEABLE:
            if (NUI_PLC) {
                break; // TODO: Implement placeable events
            }
            break;

        case NUI_DIALOG_PVP_OPTIONS:
            if (NUI_PVP) {
                break; // TODO: Implement PvP events
            }
            break;

        case NUI_DIALOG_VFX_CHAIN:
            if (NUI_VFX) {
                break; // TODO: Implement VFX events
            }
            break;

        case NUI_DIALOG_REST:
            if (NUI_REST) {
                break; // TODO: Implement rest events
            }
            break;

        default:
            // Unknown dialog type - fall through
            break;
    }

    return 0;  // Event not handled
}

//::///////////////////////////////////////////////////////////////////////
//:: MAIN ENTRY POINT
//::///////////////////////////////////////////////////////////////////////

void main() {
    // Get event information
    int nToken = NuiGetEventWindow();
    string sEvent = NuiGetEventType();
    string sElement = NuiGetEventElement();

    // Debug: Log all NUI events (if debugging)
    if (NUI_DEBUG) {
        WriteTimestampedLogEntry("NUI Event: Token=" + IntToString(nToken) +
                                 " Event=" + sEvent + " Element=" + sElement);
    }

    // Get the player associated with this window
    // Note: You may need to store player references differently depending on
    // how your system tracks which player owns which window
    object oPC = GetLocalObject(GetModule(), "nui_window_" + IntToString(nToken));

    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC)) {
        // Try alternative method: Get speaking player (if called from conversation)
        oPC = GetPCSpeaker();
    }

    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC)) {
        // Still no valid PC - can't process event
        if (NUI_DEBUG) {
            WriteTimestampedLogEntry("NUI Error: Cannot identify player for window token " +
                                     IntToString(nToken));
        }
        return;
    }

    // Get the dialog type for this player
    int nDialogType = NUI_GetDialogType(oPC);

    if (nDialogType == 0) {
        if (NUI_DEBUG) {
            WriteTimestampedLogEntry("NUI Error: No dialog type set for " + GetName(oPC));
        }
        return;
    }

    // Route the event to appropriate subsystem handler
    int bHandled = RouteNuiEvent(oPC, nDialogType, sEvent, sElement);

    if (NUI_DEBUG && !bHandled) {
        WriteTimestampedLogEntry("NUI Warning: Event not handled for dialog type " +
                                 IntToString(nDialogType));
    }
}

//::///////////////////////////////////////////////////////////////////////
//:: IMPLEMENTATION NOTES
//::///////////////////////////////////////////////////////////////////////

/*

IMPORTANT: Window Token Management
===================================

For this script to work correctly, you must track which player owns which
NUI window. There are several ways to do this:

METHOD 1: Store on Module (Recommended for simple setups)
    When opening a window:
        int nToken = NUI_DialogCreate(...);
        SetLocalObject(GetModule(), "nui_window_" + IntToString(nToken), oPC);

    This script will retrieve it:
        object oPC = GetLocalObject(GetModule(), "nui_window_" + IntToString(nToken));

METHOD 2: Store on Player
    When opening a window:
        int nToken = NUI_DialogCreate(...);
        SetLocalInt(oPC, "nui_current_window", nToken);

    In this script, you'd retrieve it from the player instead (requires knowing
    which player to look up, which is the main challenge).

METHOD 3: Store on PC with reverse lookup
    When opening a window:
        int nToken = NUI_DialogCreate(...);
        SetLocalObject(GetModule(), "nui_window_" + IntToString(nToken), oPC);
        SetLocalInt(oPC, "nui_dialog_type", NUI_DIALOG_BODY_ADJUST);  // Track type too

    When in event handler:
        object oPC = GetLocalObject(GetModule(), "nui_window_" + IntToString(nToken));
        int nType = GetLocalInt(oPC, "nui_dialog_type");

IMPORTANT: Update Dialog Type
==============================

Each subsystem control module (nui_body_adjust.nss, nui_craft.nss, etc.)
calls NUI_SetDialogType(oPC, <dialog_type>) when opening its window.
This allows this script to know which handler to route the event to.

Example in nui_body_adjust.nss:
    void NUI_BodyAdjustOpen(object oPC) {
        int nToken = NUI_DialogCreate(oPC, "Body Adjustment", jContent, ...);
        NUI_SetDialogType(oPC, NUI_DIALOG_BODY_ADJUST);
        // Store token for reverse lookup
        SetLocalObject(GetModule(), "nui_window_" + IntToString(nToken), oPC);
    }

IMPORTANT: Handle Function Naming
==================================

Each subsystem event handler must follow this pattern:
    int HandleXxxEvent(object oPC, string sEvent, string sElement) {
        // Handle the event
        // Return 1 if handled, 0 if not
    }

Available handlers (from included files):
    - HandleBodyAdjustmentEvent (from nui_body_evt.nss)
    - HandleCraftingEvent (from nui_craft_evt.nss)
    - HandleCTEvent (from nui_ct_equip_evt.nss)
    - HandleEmoteEvent (from nui_emote_evt.nss)
    - HandlePlaceableEvent (from nui_plc_evt.nss)
    - HandlePvPEvent (from nui_pvp_evt.nss)
    - HandleVfxEvent (from nui_vfx_evt.nss)
    - HandleRestEvent (from nui_rest_evt.nss)

*/

//::///////////////////////////////////////////////////////////////////////
//:: END OF NUI EVENT HANDLER
//::///////////////////////////////////////////////////////////////////////
