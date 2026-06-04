#include "nui_api"
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
//:: Carcerian NUI - Client Leave Event Handler
//:: nui_mod_leave.nss
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Client OnLeave event script. Called when a player logs out or
        leaves the module. Optional cleanup and logging.

    DEPENDENCIES
        (None - optional)

    USAGE
        Assign this script to:
          Module Properties > Events > OnClientLeave

    NOTES
        - This runs when a player logs out
        - Most NUI settings are saved when Apply buttons are clicked
        - This script is useful for logging and cleanup
        - Per-server implementations can add custom logout logic here
*/
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////


//::///////////////////////////////////////////////////////////////////////
//:: CLEANUP & LOGGING
//::///////////////////////////////////////////////////////////////////////

void main() {
    object oPC = GetExitingObject();

    if (!GetIsPC(oPC)) return;

    string sPlayerName = GetName(oPC);
    WriteTimestampedLogEntry("NUI: " + sPlayerName + " leaving module.");

    // Optional: Save any final state
    // Most NUI settings are saved when Apply buttons are clicked,
    // so additional saving here is usually not necessary.

    // Optional: Log player session information
    // You can use this to track playtime, achievements, etc.

    // Optional: Clean up temporary variables
    // Most local variables are automatically cleaned up when player leaves,
    // but you can explicitly delete any module-stored data here if desired.

    // ADD YOUR CUSTOM CLIENT LEAVE CODE BELOW THIS LINE
    // ================================================

    // Example: Save final statistics, log session, etc.
    // WriteTimestampedLogEntry("NUI: " + sPlayerName + " session ended. Time played: " +
    //                          IntToString(GetLocalInt(oPC, "time_played")) + " minutes.");
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF CLIENT LEAVE SCRIPT
//::///////////////////////////////////////////////////////////////////////
