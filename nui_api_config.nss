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
//:: Carcerian NUI - Core API Configuration
//:: nui_api_config.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 3, 2026
//:: MODIFIED: Central configuration for all NUI systems
//::///////////////////////////////////////////////////////////////////////
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Centralized configuration file for the Carcerian NUI System.
        Contains all core constants, error codes, and system parameters.
        Include this file first in all NUI modules.

        All configuration in one place for easy maintenance and consistency
        across the entire NUI framework.

*/
//::///////////////////////////////////////////////////////////////////////

/* ----------------------------------------------------------------------- */
/*  ERROR CODES                                                             */
/* ----------------------------------------------------------------------- */

const int NUI_ERROR = FALSE;               // Standard error return code
const int NUI_SUCCESS = TRUE;              // Standard success return code

/* ----------------------------------------------------------------------- */
/*  WINDOW MANAGEMENT CONSTANTS                                             */
/* ----------------------------------------------------------------------- */

const int NUI_TOKEN_MIN = 1;            // Minimum valid token
const int NUI_TOKEN_MAX = 10;           // Maximum token to check

const int NUI_WINDOW_MIN_WIDTH = 200;   // Minimum window width
const int NUI_WINDOW_MIN_HEIGHT = 100;  // Minimum window height
const int NUI_WINDOW_MAX_WIDTH = 1024;  // Maximum window width
const int NUI_WINDOW_MAX_HEIGHT = 768;  // Maximum window height

/* ----------------------------------------------------------------------- */
/*  DEFAULT WINDOW SIZES                                                    */
/* ----------------------------------------------------------------------- */

const float  NUI_WIDTH_SMALL = 300.0f;        // Small popup
const float NUI_WIDTH_MEDIUM = 500.0f;       // Medium popup
const float NUI_WIDTH_LARGE = 700.0f;        // Large popup

const float NUI_HEIGHT_SMALL = 150.0f;       // Small height
const float NUI_HEIGHT_MEDIUM = 250.0f;      // Medium height
const float NUI_HEIGHT_LARGE = 400.0f;       // Large height

/* ----------------------------------------------------------------------- */
/*  AOE SYSTEM CONSTANTS                                                    */
/* ----------------------------------------------------------------------- */

const int    NUI_AOE_DURATION = 99999;         // AOE duration in seconds
const float  NUI_AOE_RADIUS = 10.0;            // AOE radius in meters
const string NUI_AOE_VFX = "vfx_com_hit_holy"; // AOE visual effect

/* ----------------------------------------------------------------------- */
/*  LAYOUT & DISPLAY CONSTANTS                                              */
/* ----------------------------------------------------------------------- */

// Alignment and scrolling are defined in nw_inc_nui:
// NUI_HALIGN_LEFT, NUI_HALIGN_CENTER, NUI_HALIGN_RIGHT
// NUI_VALIGN_TOP, NUI_VALIGN_MIDDLE, NUI_VALIGN_BOTTOM
// NUI_SCROLLBARS_NONE, NUI_SCROLLBARS_Y, NUI_SCROLLBARS_AUTO
// NUI_DIRECTION_HORIZONTAL, NUI_DIRECTION_VERTICAL

/* ----------------------------------------------------------------------- */
/*  COLOR SUPPORT (RESERVED FOR FUTURE USE)                                */
/* ----------------------------------------------------------------------- */
/*  NWN:EE NUI does not currently support color customization through       */
/*  JsonRgba or color binding in the standard NUI builder functions.        */
/*  Color support is reserved for future implementation.                    */
/*  Current workaround: Use NW_INC_NUI's internal color functions if needed */
/* ----------------------------------------------------------------------- */

/* ----------------------------------------------------------------------- */
/*  LOCAL VARIABLE KEYS (Standard naming)                                   */
/* ----------------------------------------------------------------------- */

// Window/Dialog tracking
const string NUI_VAR_DIALOG_TOKEN = "nui_dialog_token";
const string NUI_VAR_DIALOG_PC = "nui_dialog_pc";
const string NUI_VAR_DIALOG_HANDLER = "nui_dialog_handler";
const string NUI_VAR_DIALOG_ACTIVE = "nui_dialog_active";

// AOE tracking
const string NUI_VAR_AOE_OBJECT = "nui_aoe_object";
const string NUI_VAR_AOE_TOKEN = "nui_aoe_token";
const string NUI_VAR_AOE_DURATION = "nui_aoe_duration";

// Popup state
const string NUI_VAR_POPUP_RESULT = "nui_popup_result";
const string NUI_VAR_POPUP_TEXT = "nui_popup_text";
const string NUI_VAR_POPUP_INT = "nui_popup_int";
const string NUI_VAR_POPUP_FLOAT = "nui_popup_float";

/* ----------------------------------------------------------------------- */
/*  SYSTEM FLAGS                                                             */
/* ----------------------------------------------------------------------- */

const int NUI_FLAG_DEBUG = 0;           // Debug logging enabled
const int NUI_FLAG_STRICT = 0;          // Strict error checking
const int NUI_FLAG_AUTO_CLEANUP = 1;    // Auto cleanup windows

/* ----------------------------------------------------------------------- */
/*  WINDOW PROPERTY FLAGS (for NUI_DialogCreate nProps bitmask)             */
/* ----------------------------------------------------------------------- */

const int NUI_PROP_NONE = 0;            // All flags FALSE
const int NUI_PROP_RESIZABLE = 1;       // Bit 0: Window can be resized
const int NUI_PROP_COLLAPSIBLE = 2;     // Bit 1: Window can be minimized
const int NUI_PROP_CLOSABLE = 4;        // Bit 2: Window has close (X) button
const int NUI_PROP_BORDER = 8;          // Bit 3: Window has visible border
const int NUI_PROP_TRANSPARENT = 16;    // Bit 4: Transparent background
const int NUI_PROP_ALL = 31;            // All flags TRUE (1 | 2 | 4 | 8 | 16)

/* ----------------------------------------------------------------------- */
/*  AOE WINDOW BEHAVIOR FLAGS                                              */
/* ----------------------------------------------------------------------- */

const int NUI_AOE_CLOSE = TRUE;                          // Close window on AOE exit

const int NUI_TIMEOUT_SHORT = 30;       // 30 seconds
const int NUI_TIMEOUT_MEDIUM = 300;     // 5 minutes
const int NUI_TIMEOUT_LONG = 900;       // 15 minutes

/* ----------------------------------------------------------------------- */
/*  MAGIC NUMBERS (Geometry & Positioning)                                  */
/* ----------------------------------------------------------------------- */

const float NUI_CENTER_X = -1.0;        // Center window X
const float NUI_CENTER_Y = -1.0;        // Center window Y
const float NUI_SPACING_NORMAL = 5.0;   // Normal spacing
const float NUI_SPACING_TIGHT = 2.0;    // Tight spacing
const float NUI_SPACING_LOOSE = 10.0;   // Loose spacing

/* ----------------------------------------------------------------------- */
/*  GAME CONSTANTS (from NWN:EE, referenced here)                           */
/* ----------------------------------------------------------------------- */

// Class constants (from NWN:EE)
// CLASS_TYPE_BARBARIAN, CLASS_TYPE_BARD, CLASS_TYPE_CLERIC, CLASS_TYPE_DRUID,
// CLASS_TYPE_FIGHTER, CLASS_TYPE_MONK, CLASS_TYPE_PALADIN, CLASS_TYPE_RANGER,
// CLASS_TYPE_ROGUE, CLASS_TYPE_SORCERER, CLASS_TYPE_WIZARD

// Race constants (from NWN:EE)
// RACIAL_TYPE_DWARF, RACIAL_TYPE_ELF, RACIAL_TYPE_GNOME, RACIAL_TYPE_HALFELF,
// RACIAL_TYPE_HALFLING, RACIAL_TYPE_HALFORC, RACIAL_TYPE_HUMAN

// Ability constants (from NWN:EE)
// ABILITY_STRENGTH, ABILITY_DEXTERITY, ABILITY_CONSTITUTION,
// ABILITY_INTELLIGENCE, ABILITY_WISDOM, ABILITY_CHARISMA

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
