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
//:: Carcerian NUI - Module Load Event Handler
//:: nui_mod_load.nss
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Module OnLoad event script. Initializes the Carcerian NUI system
        for the module. Call this ONCE at module load. Handles persistence
        backend initialization and system startup.

    DEPENDENCIES
        nui_api.nss (system flags)
        nui_persist.nss (persistence backend)

    USAGE
        Assign this script to:
          Module Properties > Events > OnLoad (or equivalent)

    NOTES
        - This runs once when the module is loaded/saved
        - Initializes the persistence backend (campaign DB or MySQL)
        - Sets module-wide flags for debugging
        - Per-server implementations can add initialization here
*/
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////


#include "nui_api"
#include "nui_persist"

//::///////////////////////////////////////////////////////////////////////
//:: INITIALIZATION
//::///////////////////////////////////////////////////////////////////////

void InitializeNUISystem() {
    // Initialize persistence backend (campaign DB or MySQL)
    if (NUI_PERSIST) {
        NUI_PersistInit();
        WriteTimestampedLogEntry("NUI: Persistence backend initialized.");
    }

    // Mark module as NUI-ready (stored as local variable on module)
    SetLocalInt(GetModule(), "nui_initialized", 1);
    WriteTimestampedLogEntry("NUI: Module initialization complete.");
}

void InitializeDebugFlags() {
    // Set up debug output redirection (optional)
    if (NUI_DEBUG) {
        WriteTimestampedLogEntry("NUI: Debug mode ENABLED (NUI_DEBUG = 1)");
        WriteTimestampedLogEntry("NUI: Diagnostic output will appear in server log.");

        // Per-system debug flags
        if (NUI_DEBUG_BODY) WriteTimestampedLogEntry("NUI: Body adjustment debug enabled");
        if (NUI_DEBUG_CRAFT) WriteTimestampedLogEntry("NUI: Crafting debug enabled");
        if (NUI_DEBUG_CT) WriteTimestampedLogEntry("NUI: Custom tailoring debug enabled");
        if (NUI_DEBUG_EMOTE) WriteTimestampedLogEntry("NUI: Emotes debug enabled");
        if (NUI_DEBUG_PLC) WriteTimestampedLogEntry("NUI: Placeable manager debug enabled");
        if (NUI_DEBUG_PVP) WriteTimestampedLogEntry("NUI: PvP options debug enabled");
        if (NUI_DEBUG_VFX) WriteTimestampedLogEntry("NUI: Visual accessories debug enabled");
        if (NUI_DEBUG_REST) WriteTimestampedLogEntry("NUI: Rest menu debug enabled");
        if (NUI_DEBUG_PERSIST) WriteTimestampedLogEntry("NUI: Persistence debug enabled");
    }
}

void InitializeSystemFlags() {
    // Log which systems are enabled
    WriteTimestampedLogEntry("NUI: System availability:");

    if (NUI_BODY) WriteTimestampedLogEntry("   Body Adjustment");
    else WriteTimestampedLogEntry("   Body Adjustment (disabled)");

    if (NUI_CRAFT) WriteTimestampedLogEntry("   Crafting");
    else WriteTimestampedLogEntry("   Crafting (disabled)");

    if (NUI_CT) WriteTimestampedLogEntry("   Custom Tailoring");
    else WriteTimestampedLogEntry("   Custom Tailoring (disabled)");

    if (NUI_EMOTE) WriteTimestampedLogEntry("   Emotes");
    else WriteTimestampedLogEntry("   Emotes (disabled)");

    if (NUI_PLC) WriteTimestampedLogEntry("   Placeable Manager");
    else WriteTimestampedLogEntry("   Placeable Manager (disabled)");

    if (NUI_PVP) WriteTimestampedLogEntry("   PvP Options");
    else WriteTimestampedLogEntry("   PvP Options (disabled)");

    if (NUI_VFX) WriteTimestampedLogEntry("   Visual Accessories");
    else WriteTimestampedLogEntry("   Visual Accessories (disabled)");

    if (NUI_REST) WriteTimestampedLogEntry("   Dynamic Rest Menu");
    else WriteTimestampedLogEntry("   Dynamic Rest Menu (disabled)");
}

//::///////////////////////////////////////////////////////////////////////
//:: MAIN ENTRY POINT
//::///////////////////////////////////////////////////////////////////////

void main() {
    WriteTimestampedLogEntry("=================================================");
    WriteTimestampedLogEntry("NUI: Carcerian NUI System v1.0 initializing...");
    WriteTimestampedLogEntry("=================================================");

    // Initialize NUI system
    InitializeNUISystem();

    // Log debug configuration
    InitializeDebugFlags();

    // Log enabled systems
    InitializeSystemFlags();

    WriteTimestampedLogEntry("=================================================");
    WriteTimestampedLogEntry("NUI: Initialization complete. Ready for players.");
    WriteTimestampedLogEntry("=================================================");

    // ADD YOUR CUSTOM MODULE LOAD CODE BELOW THIS LINE
    // =================================================

    // Example: Initialize custom variables, set module defaults, etc.
    // SetModuleInt("your_custom_var", 1);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF MODULE LOAD SCRIPT
//::///////////////////////////////////////////////////////////////////////
