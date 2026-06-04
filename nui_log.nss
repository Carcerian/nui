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
//:: Carcerian NUI - Logging System
//:: nui_log.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Minimal logging system using NWN:EE's built-in
        WriteTimestampedLogEntry() function. Single unified
        logging with debug levels and subsystem wrappers.

    DEPENDENCIES
        None

    USAGE
        #include "nui_log"
        
        // Core logger
        NUI_Log(oPC, "Message", 3);
        
        // Subsystem loggers
        NUI_DebugBody(oPC, "Message", 3);
        NUI_DebugCraft(oPC, "Message", 3);

    LOG LEVELS
        1 = Debug (verbose)
        2 = Debug (component)
        3 = Info (important)

*/
//::///////////////////////////////////////////////////////////////////////

/* ======================================================================= */
/*  CODE SECTION                                                           */
/* ======================================================================= */

/* ----------------------------------------------------------------------- */
/*  PUBLIC FUNCTION DECLARATIONS                                           */
/* ----------------------------------------------------------------------- */

void NUI_Log(object oPC, string sMessage, int nLevel);
void NUI_DebugBody(object oPC, string sMessage, int nLevel);
void NUI_DebugCraft(object oPC, string sMessage, int nLevel);
void NUI_DebugCt(object oPC, string sMessage, int nLevel);
void NUI_DebugEmote(object oPC, string sMessage, int nLevel);
void NUI_DebugPlc(object oPC, string sMessage, int nLevel);
void NUI_DebugPvP(object oPC, string sMessage, int nLevel);
void NUI_DebugRest(object oPC, string sMessage, int nLevel);

/* ----------------------------------------------------------------------- */
/*  IMPLEMENTATIONS                                                        */
/* ----------------------------------------------------------------------- */

void NUI_Log(object oPC, string sMessage, int nLevel)
{
    if (!GetIsPC(oPC)) return;
    WriteTimestampedLogEntry("[NUI L" + IntToString(nLevel) + "] " + GetName(oPC) + ": " + sMessage);
}

void NUI_DebugBody(object oPC, string sMessage, int nLevel)
{
    NUI_Log(oPC, "[BODY] " + sMessage, nLevel);
}

void NUI_DebugCraft(object oPC, string sMessage, int nLevel)
{
    NUI_Log(oPC, "[CRAFT] " + sMessage, nLevel);
}

void NUI_DebugCt(object oPC, string sMessage, int nLevel)
{
    NUI_Log(oPC, "[CT] " + sMessage, nLevel);
}

void NUI_DebugEmote(object oPC, string sMessage, int nLevel)
{
    NUI_Log(oPC, "[EMOTE] " + sMessage, nLevel);
}

void NUI_DebugPlc(object oPC, string sMessage, int nLevel)
{
    NUI_Log(oPC, "[PLC] " + sMessage, nLevel);
}

void NUI_DebugPvP(object oPC, string sMessage, int nLevel)
{
    NUI_Log(oPC, "[PVP] " + sMessage, nLevel);
}

void NUI_DebugRest(object oPC, string sMessage, int nLevel)
{
    NUI_Log(oPC, "[REST] " + sMessage, nLevel);
}

/* ======================================================================= */
/* END OF FILE                                                             */
/* ======================================================================= */
