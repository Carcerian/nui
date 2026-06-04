//::///////////////////////////////////////////////////////////////////////
//:://                     CARCERIAN NUI SYSTEM
//:://                  Module NUI Event Router
//:://
//::  FILE: nui_mod_event.nss
//::  DESC: Routes NUI events to the Carcerian NUI handler
//::        Place this as your module's OnNUIEvent script
//::        Calls HandleNuiEvent from nui_api_handle
//::
//::  USAGE: Module Properties  Events  OnNUIEvent = "nui_mod_event"
//::
//::  VERSION: 1.0
//::  AUTHOR: Carcerian
//::  DATE: June 2, 2026
//::///////////////////////////////////////////////////////////////////////

#include "nui_api_handle"

/* ----------------------------------------------------------------------- */
/*  MODULE NUI EVENT HANDLER                                               */
/* ----------------------------------------------------------------------- */

void main()
{
    // Route all NUI events to the Carcerian handler
    HandleNuiEvent();
}

/* ======================================================================= */
/* END OF FILE                                                             */
/* ======================================================================= */
