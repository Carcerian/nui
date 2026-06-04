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
//:: Carcerian NUI - Example Usage
//:: nui_example.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 3, 2026
//:: MODIFIED: Example usage patterns for NUI popup system
//::///////////////////////////////////////////////////////////////////////
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Copy-paste ready examples for common NUI popup usage patterns.
        NOT meant to be included in any script.
        Reference only - understand how to use NUI functions.

    USAGE
        1. Read these examples
        2. Copy pattern that fits your need
        3. Adapt to your script context
        4. Test in game

    EXAMPLES INCLUDED
        1. Sign usage (from OnUsed event)
        2. Message popup (from script)
        3. Error/Success/Warning/Info popups
        4. Dialog with custom content
        5. Multiple popups
*/
//::///////////////////////////////////////////////////////////////////////

#include "nui_api"

/* ----------------------------------------------------------------------- */
/*  EXAMPLE 1: SIGN DISPLAY (Place in sign placeable OnUsed event)         */
/* ----------------------------------------------------------------------- */
/*
    Setup:
    1. Create a placeable object (sign, bulletin board, etc)
    2. Set object Name = "Title of Sign"
    3. Set object Description = "Content to display"
    4. Set object Portrait = portrait image ResRef (optional)
    5. Attach this script to OnUsed event

    Result:
    - Window opens showing portrait + description
    - Close button at bottom
    - AOE created at sign location
    - Window closes when player leaves AOE or clicks Close
*/

void example_sign_main()
{
    object oPC = GetLastUsedBy();

    // Call NUI_PopupSign - no parameters except PC
    // Sign uses OBJECT_SELF for all data
    NUI_PopupSign(oPC);

    // That's it! Window handles everything.
}

/* ----------------------------------------------------------------------- */
/*  EXAMPLE 2: SIMPLE MESSAGE POPUP (Call from any script)                 */
/* ----------------------------------------------------------------------- */
/*
    Usage:
    - Quick message to player
    - Player clicks OK to close
    - Window appears at Y=200 (center screen)
*/

void example_message_main()
{
    object oPC = GetFirstPC();
    string sMessage = "This is a message popup.\nYou can have multiple lines.\nClick OK to close.";

    // Simple call with just title and message
    // Uses default position and size
    NUI_PopupMessage(oPC, "Message Title", sMessage);
}

/* ----------------------------------------------------------------------- */
/*  EXAMPLE 3: ERROR POPUP (Call from any script)                          */
/* ----------------------------------------------------------------------- */
/*
    Usage:
    - Display error to player
    - Red styling (visual indication of error)
    - Player clicks OK to dismiss
*/

void example_error_main()
{
    object oPC = GetFirstPC();

    // Error message - simple call
    NUI_PopupError(oPC, "Error", "Something went wrong!");
}

/* ----------------------------------------------------------------------- */
/*  EXAMPLE 4: SUCCESS POPUP (Call from any script)                        */
/* ----------------------------------------------------------------------- */
/*
    Usage:
    - Confirm successful action
    - Green styling
    - Player clicks OK
*/

void example_success_main()
{
    object oPC = GetFirstPC();

    // Success message
    NUI_PopupSuccess(oPC, "Success", "Action completed successfully!");
}

/* ----------------------------------------------------------------------- */
/*  EXAMPLE 5: WARNING POPUP (Call from any script)                        */
/* ----------------------------------------------------------------------- */
/*
    Usage:
    - Warn player of consequence
    - Yellow styling
    - Player clicks OK to acknowledge
*/

void example_warning_main()
{
    object oPC = GetFirstPC();

    // Warning message
    NUI_PopupWarning(oPC, "Warning", "This action cannot be undone!");
}

/* ----------------------------------------------------------------------- */
/*  EXAMPLE 6: INFO POPUP (Call from any script)                           */
/* ----------------------------------------------------------------------- */
/*
    Usage:
    - Display information
    - Blue styling
    - Player clicks OK to close
*/

void example_info_main()
{
    object oPC = GetFirstPC();

    // Info message
    NUI_PopupInfo(oPC, "Information", "System status: All operational");
}

/* ----------------------------------------------------------------------- */
/*  EXAMPLE 7: CUSTOM DIALOG (Advanced - custom layout)                    */
/* ----------------------------------------------------------------------- */
/*
    Usage:
    - Build custom window from scratch
    - Define exact layout with NuiCol, NuiRow, etc
    - More control, more code
*/

void example_dialog_main()
{
    object oPC = GetFirstPC();
    string sTitle = "Custom Dialog";

    // Build custom content
    json jContent = NuiCol(JsonArray2(
        NuiLabel(JsonString("Custom content here"),
                 JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE)),
        NuiRow(JsonArray3(
            NuiSpacer(),
            NuiButton(JsonString("OK")),
            NuiSpacer()
        ))
    ));

    // Create dialog
    int nToken = NUI_DialogCreate(oPC, sTitle, jContent, 1, "",
                                 "nui_handler", NUI_PROP_CLOSABLE,
                                 312.5f, 156.25f, FALSE);

    // Window now open
}

/* ----------------------------------------------------------------------- */
/*  EXAMPLE 8: DIALOG WITH CUSTOM POSITION (Advanced)                      */
/* ----------------------------------------------------------------------- */
/*
    Usage:
    - Position window at specific location on screen
    - X: -1.0 = center, positive = offset from left
    - Y: positive value = offset from top
*/

void example_dialog_position_main()
{
    object oPC = GetFirstPC();

    // Create and position popup
    NUI_PopupMessage(oPC, "Title", "Message"); // Height
}

/* ----------------------------------------------------------------------- */
/*  EXAMPLE 9: MULTIPLE POPUPS IN SEQUENCE (Advanced)                      */
/* ----------------------------------------------------------------------- */
/*
    Usage:
    - Show multiple windows to player
    - Each popup can be interacted with independently
    - Tokens tracked for cleanup
*/

void example_multiple_popups_main()
{
    object oPC = GetFirstPC();
    int nToken1;
    int nToken2;

    // First popup
    nToken1 = NUI_PopupMessage(oPC, "First", "First message");

    // Second popup at different position
    nToken2 = NUI_PopupMessage(oPC, "Second", "Second message");

    // Both windows now open
    // Player can interact with both
}

/* ----------------------------------------------------------------------- */
/*  EXAMPLE 10: WINDOW PROPERTIES (Advanced - customize window appearance) */
/* ----------------------------------------------------------------------- */
/*
    Usage:
    - Control window appearance with nProps flags
    - Combine flags with bitwise OR
    - Available: RESIZABLE, COLLAPSIBLE, CLOSABLE, BORDER, TRANSPARENT
*/

void example_window_properties_main()
{
    object oPC = GetFirstPC();

    // Create window with custom properties
    json jContent = NuiLabel(JsonString("Resizable window"),
                            JsonInt(NUI_HALIGN_CENTER),
                            JsonInt(NUI_VALIGN_MIDDLE));

    // Use predefined property combinations
    int nProps = NUI_PROP_RESIZABLE + NUI_PROP_CLOSABLE;

    int nToken = NUI_DialogCreate(oPC, "Custom Window", jContent, 0, "",
                                 "nui_handler", nProps, 312.5f, 156.25f, FALSE);
}

void main()
{

}

/* ----------------------------------------------------------------------- */
/*  KEY POINTS                                                              */
/* ----------------------------------------------------------------------- */
/*
    1. NUI_PopupSign(oPC)
       - Must be called from sign OnUsed event
       - Uses OBJECT_SELF for title/content/portrait
       - Simple one-liner

    2. NUI_PopupMessage(oPC, sTitle, sMessage, ...)
       - Can be called from any script
       - Flexible positioning with X, Y, Width, Height parameters
       - OK button closes automatically

    3. NUI_PopupError/Success/Warning/Info
       - Color-coded shortcuts for common message types
       - Simple one-liner usage

    4. NUI_DialogCreate(...)
       - Advanced: build custom windows
       - Full control over layout and properties
       - More code required

    5. Window Closing
       - Message OK button: auto-closes
       - Sign Close button: manual click
       - X button: always available
       - Dialog OK button: depends on handler

    6. AOE Behavior
       - NUI_PopupSign: AOE at sign location
       - Other popups: no AOE by default
       - Can add AOE with bAOE=TRUE in NUI_DialogCreate
*/

/*
// "nui_example.nss"

   #include "nw_inc_nui"

// This is our window id, it's used to differentiate between NUI Windows
const string NUIEXAMPLE_WINDOW_ID = "nui_example";

// This creates our new window.  You can call this from anywhere.
// Examples would be: Module (item) OnActivateItem, Placeable OnUsed, Module OnPlayerChat, etc.
void NUIExample_NewWindow(object oPlayer);


// This will refresh data on window.
// This depends on application, but should be called anytime you think the state has changed.
void NUIExample_Update(object oPlayer, int nToken = -1);

// This handles events.
// This should be called from OnNuiEvent
// https://nwnlexicon.com/index.php?title=OnNuiEvent

 Example:
	#include "nui_example"
	void main()
	{
		object oPlayer = NuiGetEventPlayer();
		int nToken	   = NuiGetEventWindow();
		string sEvent  = NuiGetEventType();
		string sElement   = NuiGetEventElement();
		int nIndex	   = NuiGetEventArrayIndex();
		string sWindowId  = NuiGetWindowId(oPlayer, nToken);

		if (sWindowId == NUIEXAMPLE_WINDOW_ID)
		{
			NUIExample_Events();
			return;
		}
	}

void NUIExample_Events();


// Helper function for debugging.
// Log it however you want.
void LogMessage(string sMessage)
{
	// WriteTimestampedLogEntry(sMessage);
	SendMessageToPC(GetFirstPC(), sMessage);
}

void NUIExample_Events()
{
	// Get all our inputs.
	object oPlayer	 = NuiGetEventPlayer();
	int nToken		 = NuiGetEventWindow();
	string sEvent	 = NuiGetEventType();
	string sElement	 = NuiGetEventElement();
	int nIndex		 = NuiGetEventArrayIndex();
	string sWindowId = NuiGetWindowId(oPlayer, nToken);

	// Not our window!
	if (sWindowId != NUIEXAMPLE_WINDOW_ID)
	{
		LogMessage("NUIExample_Events called for wrong window, expecting: " + NUIEXAMPLE_WINDOW_ID + " but got: " + sWindowId);
		return;
	}

	// If events aren't working, log what is going on.
	// If you don't see a bunch of stuff, then likly it's not being called from OnNuiEvent correctly.
	// LogMessage("NUIExample: sElement: " + sElement + " sEvent: " + sEvent);

	// Here is all our events, we need to sort out what to do, depending on Event and Element.

	switch (HashString(sEvent))
	{
		case ("blur"):
		{
		}
		break;
		case ("click"):
		{
		}
		break;
		case ("close"):
		{
		}
		break;
		case ("focus"):
		{
		}
		break;
		case ("mousedown"):
		{
		}
		break;
		case ("mousescroll"):
		{
		}
		break;
		case ("mouseup"):
		{
			// Yikes, switch inside a switch.
			// But this filters Event mouseup by Element with these Ids (in this case, buttons mostly)
			// Ie, when a user is done clicking a button, process what to do for that button type.
			switch (HashString(sElement))
			{
				case ("buttonUpdate"):
				{
					// They want to call an update.
					NUIExample_Update(oPlayer, nToken);
					return;
				}
				break;
				case ("buttonCancel"):
				{
					// They want to close a window.
					NuiDestroy(oPlayer, nToken);
					return;
				}
				break;
			}
		}
		break;
		case ("open"):
		{
		}
		break;
		case ("range"):
		{
		}
		break;
		case ("watch"):
		{
		}
		break;
		default:
		{
			LogMessage("NUIExample: Unknown event occured: " + sEvent + " Element: " + sElement);
		}
		break;
	}
}


void NUIExample_Update(object oPlayer, int nToken = -1)
{
	// If caller doesn't have our token, be nice and look it up for them.
	if (nToken == -1)
	{
		nToken = NuiFindWindow(oPlayer, NUIEXAMPLE_WINDOW_ID);
	}

	// Window isn't open, so let's not spend time processing updates.
	if (nToken == 0)
	{
		return;
	}


	// This is our only update for now.
	// For Nui Id "labelMain" it will update it's value with a random number between 1 and 100.
	NuiSetBind(oPlayer, nToken, "labelMain", JsonString(IntToString(Random(100) + 1)));
}

void NUIExample_NewWindow(object oPlayer)
{
	// This checks if window is already open.  If so, we want to close it and create a new one.
	// You CAN have multiple windows of same time, but most use cases if you just want one instance?
	int nToken = NuiFindWindow(oPlayer, NUIEXAMPLE_WINDOW_ID);
	if (nToken != 0)
	{
		NuiDestroy(oPlayer, nToken);
	}


	/////////////////////////////////////////
	// Build the main root pane here
	/////////////////////////////////////////

	// This is going to be our entire window that is passed into NuiWindow.
	json jRoot = JsonArray();


	json jRow;
	// Build the first row
	{
		// Create an array to hold our first row.
		jRow = JsonArray();

		// Create a label, notice it uses bind "labelMain", instead of static value.
		json jLabelMain = NuiLabel(NuiBind("labelMain"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));


		// Add our label to the row
		jRow = JsonArrayInsert(jRow, jLabelMain);

		// Apply a Layout too it (you can't have widgets hanging about, outside of layout groups)
		jRow = NuiRow(jRow);

		// Finally we add our finalize row to our main root window.
		jRoot = JsonArrayInsert(jRoot, jRow);
	}

	// Build the second row
	{
		// Same as before, start with a fresh array to hold our row data.
		jRow = JsonArray();

		// Make two buttons.
		// Notice they have NuiId!  If you want to capture events on widgets they MUST have an ID
		json jButtonUpdate = NuiId(NuiButton(JsonString("Update")), "buttonUpdate");
		json jButtonCancel = NuiId(NuiButton(JsonString("cancel")), "buttonCancel");


		// Same as first row, but we goign to add a spacer, then both buttons.
		jRow = JsonArrayInsert(jRow, NuiSpacer());
		jRow = JsonArrayInsert(jRow, jButtonUpdate);
		jRow = JsonArrayInsert(jRow, jButtonCancel);


		// again, wrap all the widgets up in a nice group layout.
		jRow = NuiRow(jRow);
		// then add to main root
		jRoot = JsonArrayInsert(jRoot, jRow);
	}


	///////////////////////////////////////////
	// Build final group
	///////////////////////////////////////////

	// Again, needs a group layout, his is just one big column for window (with 2 rows inside it)
	jRoot = NuiCol(jRoot);

	/////////////////////////////////////////
	// Create new window here
	/////////////////////////////////////////

	// Creates new window and gets token.
	json jNuiWindow = NuiWindow(jRoot, NuiBind("windowtitle"), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"), JsonBool(TRUE));
	nToken			= NuiCreate(oPlayer, jNuiWindow, NUIEXAMPLE_WINDOW_ID);

	// Good example of how to use bings. "windowtitle" is just a place holder.  We want to update it here.
	NuiSetBind(oPlayer, nToken, "windowtitle", JsonString("NUI Example"));

	// x, y, width, height.
	// -1.0f, -1.0f, means to "center" the new NUI Window.  Otherwise you can manually place it were you wish.
	NuiSetBind(oPlayer, nToken, "geometry", NuiRect(-1.0f, -1.0f, 512.0f, 512.0f));

	NuiSetBind(oPlayer, nToken, "collapsed", JsonBool(FALSE));
	NuiSetBind(oPlayer, nToken, "resizable", JsonBool(TRUE));
	NuiSetBind(oPlayer, nToken, "closable", JsonBool(TRUE));
	NuiSetBind(oPlayer, nToken, "transparent", JsonBool(FALSE));
	NuiSetBind(oPlayer, nToken, "border", JsonBool(TRUE));

	// Refesh the data after window is made.
	NUIExample_Update(oPlayer);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
