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
//:: Carcerian NUI - Client Enter Event Handler
//:: nui_mod_enter.nss
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Client OnEnter event script. Called when a player logs in/enters
        the module. Loads all persistent NUI settings from database.

    DEPENDENCIES
        nui_api.nss (system flags, debug routing)
        nui_persist.nss (persistence API)
        nui_body_api.nss (body adjustment)
        nui_ct_api.nss (custom tailoring)
        nui_vfx_api.nss (visual accessories)
        nui_rest_api.nss (rest options)
        nui_pvp_api.nss (PvP options)

    USAGE
        Assign this script to:
          Module Properties > Events > OnClientEnter

    NOTES
        - This runs when a player logs in
        - Loads all persistent settings from database
        - Re-applies visual changes (body, colors, effects)
        - Per-server implementations can add custom load logic here
*/
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////


#include "nui_api"
#include "nui_persist"
#include "nui_body_api"
#include "nui_ct_api"
#include "nui_vfx_api"
#include "nui_rest_api"
#include "nui_pvp_api"

//::///////////////////////////////////////////////////////////////////////
//:: BODY ADJUSTMENT LOADING
//::///////////////////////////////////////////////////////////////////////

void LoadBodyAdjustments(object oPC) {
    if (!NUI_BODY || !NUI_PERSIST) return;

    // Load head adjustments
    float fHeadX = NUI_PersistLoadFloat(oPC, "body_head_x", 0.0);
    float fHeadY = NUI_PersistLoadFloat(oPC, "body_head_y", 0.0);
    float fHeadZ = NUI_PersistLoadFloat(oPC, "body_head_z", 0.0);
    float fHeadScale = NUI_PersistLoadFloat(oPC, "body_head_scale", 1.0);

    // Load wings adjustments
    float fWingsX = NUI_PersistLoadFloat(oPC, "body_wings_x", 0.0);
    float fWingsY = NUI_PersistLoadFloat(oPC, "body_wings_y", 0.0);
    float fWingsZ = NUI_PersistLoadFloat(oPC, "body_wings_z", 0.0);
    float fWingsScale = NUI_PersistLoadFloat(oPC, "body_wings_scale", 1.0);

    // Load tail adjustments
    float fTailX = NUI_PersistLoadFloat(oPC, "body_tail_x", 0.0);
    float fTailY = NUI_PersistLoadFloat(oPC, "body_tail_y", 0.0);
    float fTailZ = NUI_PersistLoadFloat(oPC, "body_tail_z", 0.0);
    float fTailScale = NUI_PersistLoadFloat(oPC, "body_tail_scale", 1.0);

    // Load self adjustments
    float fSelfX = NUI_PersistLoadFloat(oPC, "body_self_x", 0.0);
    float fSelfY = NUI_PersistLoadFloat(oPC, "body_self_y", 0.0);
    float fSelfZ = NUI_PersistLoadFloat(oPC, "body_self_z", 0.0);
    float fSelfScale = NUI_PersistLoadFloat(oPC, "body_self_scale", 1.0);

    // Store in local variables using NUI_ prefixed constants from nui_body_api
    SetLocalFloat(oPC, NUI_VAR_HEAD_X, fHeadX);
    SetLocalFloat(oPC, NUI_VAR_HEAD_Y, fHeadY);
    SetLocalFloat(oPC, NUI_VAR_HEAD_Z, fHeadZ);
    SetLocalFloat(oPC, NUI_VAR_HEAD_SCALE, fHeadScale);

    SetLocalFloat(oPC, NUI_VAR_WINGS_X, fWingsX);
    SetLocalFloat(oPC, NUI_VAR_WINGS_Y, fWingsY);
    SetLocalFloat(oPC, NUI_VAR_WINGS_Z, fWingsZ);
    SetLocalFloat(oPC, NUI_VAR_WINGS_SCALE, fWingsScale);

    SetLocalFloat(oPC, NUI_VAR_TAIL_X, fTailX);
    SetLocalFloat(oPC, NUI_VAR_TAIL_Y, fTailY);
    SetLocalFloat(oPC, NUI_VAR_TAIL_Z, fTailZ);
    SetLocalFloat(oPC, NUI_VAR_TAIL_SCALE, fTailScale);

    SetLocalFloat(oPC, NUI_VAR_SELF_X, fSelfX);
    SetLocalFloat(oPC, NUI_VAR_SELF_Y, fSelfY);
    SetLocalFloat(oPC, NUI_VAR_SELF_Z, fSelfZ);
    SetLocalFloat(oPC, NUI_VAR_SELF_SCALE, fSelfScale);
}

//::///////////////////////////////////////////////////////////////////////
//:: CUSTOM TAILORING LOADING
//::///////////////////////////////////////////////////////////////////////

void LoadTailoringColors(object oPC) {
    if (!NUI_CT || !NUI_PERSIST) return;

    // Load armor color
    string sArmorColor = NUI_PersistLoad(oPC, "ct_armor_color", "default");
    SetLocalString(oPC, NUI_VAR_ARMOR_COLOR, sArmorColor);

    // Load weapon color
    string sWeaponColor = NUI_PersistLoad(oPC, "ct_weapon_color", "default");
    SetLocalString(oPC, NUI_VAR_WEAPON_COLOR, sWeaponColor);
}

//::///////////////////////////////////////////////////////////////////////
//:: VISUAL ACCESSORIES LOADING
//::///////////////////////////////////////////////////////////////////////

void LoadVisualAccessories(object oPC) {
    if (!NUI_VFX || !NUI_PERSIST) return;

    // Per-server implementation: load VFX selections
    // TODO: Implement custom VFX loading logic here
}

//::///////////////////////////////////////////////////////////////////////
//:: REST OPTIONS LOADING
//::///////////////////////////////////////////////////////////////////////

void LoadRestOptions(object oPC) {
    if (!NUI_REST || !NUI_PERSIST) return;

    // Load rest mode
    int nRestMode = NUI_PersistLoadInt(oPC, "rest_mode", 0);
    SetLocalInt(oPC, NUI_VAR_REST_MODE, nRestMode);

    // Load rest duration
    int nRestDuration = NUI_PersistLoadInt(oPC, "rest_duration", 60);
    SetLocalInt(oPC, NUI_VAR_REST_DURATION, nRestDuration);
}

//::///////////////////////////////////////////////////////////////////////
//:: PVP OPTIONS LOADING
//::///////////////////////////////////////////////////////////////////////

void LoadPvPOptions(object oPC) {
    if (!NUI_PVP || !NUI_PERSIST) return;

    // Load PvP preset
    int nPvPPreset = NUI_PersistLoadInt(oPC, "pvp_preset", 1);
    SetLocalInt(oPC, NUI_VAR_PVP_MODE, nPvPPreset);
}

//::///////////////////////////////////////////////////////////////////////
//:: EMOTE OPTIONS LOADING
//::///////////////////////////////////////////////////////////////////////

void LoadEmoteOptions(object oPC) {
    // Per-server implementation: load emote preferences
    // TODO: Implement custom emote loading logic here
}

//::///////////////////////////////////////////////////////////////////////
//:: MAIN ENTRY POINT
//::///////////////////////////////////////////////////////////////////////

void main() {
    object oPC = OBJECT_SELF;

    if (!GetIsPC(oPC)) return;

    // Load all system preferences from database
    LoadBodyAdjustments(oPC);
    LoadTailoringColors(oPC);
    LoadVisualAccessories(oPC);
    LoadRestOptions(oPC);
    LoadPvPOptions(oPC);
    LoadEmoteOptions(oPC);

    // Per-server custom load logic can be added here
    // TODO: Add custom initialization code below
}

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:: END OF FILE
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
