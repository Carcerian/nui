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
//:: Carcerian NUI - Core API
//:: nui_api.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Master control and element-builder library for the Carcerian NUI
        system. Provides core API functions, window creation, and widget
        helpers. All public functions are declared first, then implemented
        after all declarations to ensure proper compilation order.

    DEPENDENCIES
        nui_api_json (JSON helpers)
        nw_inc_nui (NWN:EE NUI library)

    USAGE
        #include "nui_api"

        // Widget builders
        json jBtn = NuiButton(JsonString("Click me"));
        jBtn = NuiId(jBtn, "my_button");
        jBtn = NuiWidth(jBtn, 150.0);

        // Window creation
        int nToken = NuiCreate(oPC, jWindow, "window_id");

    EXAMPLE
        json jRoot = JsonArray();
        json jBtn = NuiId(NuiButton(JsonString("Test")), "btn_test");
        jRoot = JsonArrayInsert(jRoot, jBtn);
        jRoot = NuiCol(jRoot);
        json jWnd = NuiWindow(jRoot, JsonString("Test"), NuiBind("geo"), ...);
        int nToken = NuiCreate(oPC, jWnd, "test_window");

*/
//::///////////////////////////////////////////////////////////////////////

/* ======================================================================= */
/*  CODE SECTION                                                           */
/* ======================================================================= */

/* ----------------------------------------------------------------------- */
/*  INCLUDES                                                               */
/* ----------------------------------------------------------------------- */

#include "nui_api_json"
#include "nw_inc_nui"
#include "nui_log"
#include "nui_api_popup"

/* ----------------------------------------------------------------------- */
/*  CONSTANTS - SYSTEM FLAGS                                               */
/* ----------------------------------------------------------------------- */

const int NUI_BODY  = 1;
const int NUI_CRAFT = 1;
const int NUI_CT    = 1;
const int NUI_EMOTE = 1;
const int NUI_PLC   = 1;
const int NUI_PVP   = 1;
const int NUI_VFX   = 1;
const int NUI_REST  = 1;
const int NUI_PERSIST = 1;

const string NUI_HANDLER = "nui_handler";

// Dialog type constants for event routing
const int NUI_DIALOG_BODY_ADJUST = 1;
const int NUI_DIALOG_CRAFT = 2;
const int NUI_DIALOG_CLOTHING = 3;
const int NUI_DIALOG_EMOTE = 4;
const int NUI_DIALOG_PLACEABLE = 5;
const int NUI_DIALOG_PVP_OPTIONS = 6;
const int NUI_DIALOG_REST = 7;
const int NUI_DIALOG_VFX_CHAIN = 8;

// Debug flags
const int NUI_DEBUG = 0;
const int NUI_DEBUG_BODY = 0;
const int NUI_DEBUG_CRAFT = 0;
const int NUI_DEBUG_CT = 0;
const int NUI_DEBUG_EMOTE = 0;
const int NUI_DEBUG_PLC = 0;
const int NUI_DEBUG_PVP = 0;
const int NUI_DEBUG_VFX = 0;
const int NUI_DEBUG_REST = 0;
const int NUI_DEBUG_PERSIST = 0;

/* ----------------------------------------------------------------------- */
/*  DATA STRUCTURES                                                         */
/* ----------------------------------------------------------------------- */

/// @struct NUIEventData
/// @brief Standardized event data passed to NUI event handlers
/// @note Adopted from tinygiant98 NUI system for consistency
struct NUIEventData {
    object oPC;           ///< Player character triggering the event
    int    nToken;        ///< NUI window token
    string sFormID;       ///< Form/window ID (from NuiGetWindowId)
    string sEvent;        ///< Event type: "mouseup", "click", "watch", "close", "open"
    string sControlID;    ///< Control/element ID (from NuiGetEventElement)
    int    nIndex;        ///< Array index if control is in listbox/array (-1 if N/A)
    json   jPayload;      ///< Event-specific payload data
};

/* ----------------------------------------------------------------------- */
/*  ALL PUBLIC FUNCTION DECLARATIONS                                       */
/*  (These are ALL declared here, BEFORE any implementations)              */
/* ----------------------------------------------------------------------- */

// Event helpers
/// @brief Extract all NUI event data into a standardized struct
/// @returns struct NUIEventData populated from current NUI event
/// @note Call only from within a NUI event handler (EVENT_SCRIPT_MODULE_ON_NUI_EVENT)
struct NUIEventData NUI_GetEventData();

// Event handler
int HandleNuiEvent();

// Utility functions
int NUI_DialogCreate(object oPC, string sTitle, json jContent, int nButtons, string sGeometry, string sScript, int nProps, float fWidth, float fHeight, int bAOE=FALSE);



string GetTokenByPosition(string sString, int nPosition, string sDelim)
{
    int nStart = 0;
    int nEnd = -1;
    int nCurrent = 0;
    
    while (nCurrent < nPosition)
    {
        nStart = nEnd + 1;
        nEnd = FindSubString(GetSubString(sString, nStart, GetStringLength(sString) - nStart), sDelim);
        if (nEnd >= 0) nEnd = nEnd + nStart;
        nCurrent++;
    }
    
    if (nEnd == -1)
        return GetStringRight(sString, GetStringLength(sString) - nStart);
    
    return GetSubString(sString, nStart, nEnd - nStart);
}

/* ----------------------------------------------------------------------- */
/*  EVENT HANDLER IMPLEMENTATIONS                                          */
/* ----------------------------------------------------------------------- */

struct NUIEventData NUI_GetEventData()
{
    struct NUIEventData ed;
    ed.oPC       = NuiGetEventPlayer();
    ed.nToken    = NuiGetEventWindow();
    ed.sFormID   = NuiGetWindowId(ed.oPC, ed.nToken);
    ed.sEvent    = NuiGetEventType();
    ed.sControlID = NuiGetEventElement();
    ed.nIndex    = NuiGetEventArrayIndex();
    ed.jPayload  = NuiGetEventPayload();
    return ed;
}

/* ======================================================================= */
/* END OF FILE                                                             */
/* ======================================================================= */
