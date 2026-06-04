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
//:: Carcerian NUI System - Complete Reference Manual
//:: nui_doc.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 2, 2026
//:: MODIFIED: June 3, 2026 - Complete reference manual with examples
//::///////////////////////////////////////////////////////////////////////
//::///////////////////////////////////////////////////////////////////////
/*

    CARCERIAN NUI SYSTEM v1.0 - COMPLETE REFERENCE MANUAL
    
    QUICK START
    ===========
    1. Include nui_api.nss in your script
    2. Call any NUI_Popup* function with player, title, and handler
    3. Dialog shows to player immediately
    
    EXAMPLE:
        #include "nui_api"
        
        void main()
        {
            object oPC = GetPCSpeaker();
            NUI_PopupMessage(oPC, "Welcome", "Hello!", "my_handler");
        }
    
    CONSTANTS
    =========
    const int NUI_ERROR = -1;
        Standard error return code for NUI functions
        Use for checking function return values
        
        Example:
            int nResult = NUI_Kill(oPC, nToken);
            if (nResult == NUI_ERROR) {
                SendMessageToPC(oPC, "Error closing window");
            }
    
    TABLE OF CONTENTS
    =================
    SECTION 1: Core API Builder Functions
    SECTION 2: All 63 Functions (A-Z)
    SECTION 3: Basic Examples
    SECTION 4: Advanced Examples
    SECTION 5: Addon Modules Reference
    SECTION 6: Best Practices

*/
//::///////////////////////////////////////////////////////////////////////

// =========================================================================
// SECTION 1: CORE API BUILDER FUNCTIONS
// =========================================================================

/*

    NUI WIDGET BUILDERS
    ===================
    
    These functions create individual NUI elements. Combine them with
    layout functions (NuiRow, NuiCol) to build complex interfaces.
    
    --- LAYOUT FUNCTIONS ---
    
    NuiWindow(jRoot, jTitle, jGeometry, jResizable, jCollapsed, 
              jClosable, jTransparent, jBorder)
        Creates the main window container for all NUI popups.
        
        Example:
            json jWindow = NuiWindow(
                NuiRow(JsonArray1(NuiLabel(JsonString("Content")))),
                JsonString("Window Title"),
                NuiRect(-1.0, -1.0, 400.0, 250.0),
                JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE),
                JsonBool(FALSE), JsonBool(TRUE)
            );
    
    NuiRow(jElementArray)
        Arranges elements horizontally with automatic spacing.
        
        Example:
            json jRow = NuiRow(JsonArray2(
                NuiButton(JsonString("OK")),
                NuiButton(JsonString("Cancel"))
            ));
    
    NuiCol(jElementArray)
        Arranges elements vertically with automatic spacing.
        
        Example:
            json jCol = NuiCol(JsonArray3(
                NuiLabel(JsonString("Name:")),
                NuiTextEdit(JsonString(""), NuiBind("name"), 50, FALSE, TRUE),
                NuiButton(JsonString("Submit"))
            ));
    
    NuiGroup(jChild, bBorder, nScroll)
        Groups content with optional border and scrolling.
        
        Example:
            json jGroup = NuiGroup(
                NuiCol(JsonArray1(NuiLabel(JsonString("Grouped content")))),
                TRUE, NUI_SCROLLBARS_Y
            );
    
    --- DISPLAY WIDGETS ---
    
    NuiLabel(jText, jHAlign, jVAlign)
        Static text display with alignment options.
        
        Example:
            json jLabel = NuiLabel(
                JsonString("Character Level:"),
                JsonInt(NUI_HALIGN_LEFT),
                JsonInt(NUI_VALIGN_TOP)
            );
    
    NuiText(jContent, bBorder, nScroll)
        Scrollable text area for long content.
        
        Example:
            json jText = NuiText(
                JsonString("Long story..."),
                TRUE, NUI_SCROLLBARS_Y
            );
    
    NuiImage(jResRef, jAspect, jHAlign, jVAlign)
        Display image from resource file.
        
        Example:
            json jImage = NuiImage(
                JsonString("portrait_resref"),
                JsonFloat(1.0), JsonInt(0), JsonInt(0)
            );
    
    --- INPUT WIDGETS ---
    
    NuiButton(jLabel)
        Clickable button control.
        
        Example:
            json jButton = NuiButton(JsonString("Click Me"));
    
    NuiTextEdit(jPlaceholder, jBind, nMaxLen, bMultiline, bWordWrap)
        Single or multi-line text input.
        
        Example:
            json jInput = NuiTextEdit(
                JsonString("Enter text..."),
                NuiBind("user_input"),
                100, FALSE, TRUE
            );
    
    NuiCheck(jLabel, jValue)
        Checkbox control.
        
        Example:
            json jCheck = NuiCheck(
                JsonString("Enable feature"),
                NuiBind("feature_enabled")
            );
    
    NuiSlider(jValue, jMin, jMax, jStep)
        Integer value slider (0-100, 1-50, etc).
        
        Example:
            json jSlider = NuiSlider(
                JsonInt(50), JsonInt(0), JsonInt(100), JsonInt(1)
            );
    
    NuiSliderFloat(jValue, jMin, jMax, jStep)
        Floating-point slider (0.5, 1.5, 2.5, etc).
        
        Example:
            json jSlider = NuiSliderFloat(
                JsonFloat(5.5), JsonFloat(0.0), JsonFloat(10.0),
                JsonFloat(0.1)
            );
    
    NuiColorPicker(jColor)
        RGB color selection control.
        
        Example:
            json jPicker = NuiColorPicker(
                NuiColor(255, 128, 0, 255)
            );
    
    NuiCombo(jElements, jSelected)
        Dropdown selection list.
        
        Example:
            json jCombo = NuiCombo(
                JsonArray3(JsonString("Option 1"), JsonString("Option 2"),
                          JsonString("Option 3")),
                JsonInt(0)
            );
    
    NuiProgress(jValue)
        Progress bar display (0.0-1.0).
        
        Example:
            json jProgress = NuiProgress(JsonFloat(0.75));
    
    --- GEOMETRY & STYLING ---
    
    NuiRect(x, y, width, height)
        Define window position and size.
        -1.0 = centered on that axis
        
        Example:
            json jGeom = NuiRect(-1.0, -1.0, 500.0, 300.0);
    
    NuiColor(red, green, blue, alpha)
        Create RGB color (0-255 each).
        
        Example:
            json jColor = NuiColor(255, 128, 0, 255);
    
    NuiBind(sBindId)
        Create data binding for dynamic values.
        
        Example:
            json jBind = NuiBind("player_name");
    
    NuiWidth(jElement, fWidth)
        Set element width.
        
        Example:
            json jWidened = NuiWidth(jElement, 300.0);
    
    NuiHeight(jElement, fHeight)
        Set element height.
        
        Example:
            json jTall = NuiHeight(jElement, 150.0);
    
    NuiMargin(jElement, fLeft, fTop, fRight, fBottom)
        Set element margins.
        
        Example:
            json jMargin = NuiMargin(jElement, 10.0, 5.0, 10.0, 5.0);
    
    NuiPadding(jElement, fLeft, fTop, fRight, fBottom)
        Set element padding.
        
        Example:
            json jPad = NuiPadding(jElement, 10.0, 10.0, 10.0, 10.0);
    
    --- WINDOW MANAGEMENT ---
    
    NuiCreate(oPC, jWindow, sScript)
        Create and display window to player.
        Returns dialog token (>0 = success).
        
        Example:
            int nToken = NuiCreate(oPC, jWindow, "event_handler");
            if (nToken > 0) { // Window created
                SetLocalInt(oPC, "DIALOG_TOKEN", nToken);
            }
    
    NUI_Kill(oPC, nToken)
        Close and destroy a displayed NUI window.
        Pass the token returned from NuiCreate or any NUI_PopupXXX function.
        
        Example:
            int nToken = NUI_PopupMessage(oPC, "Title", "Message", "handler");
            // ... later ...
            NUI_Kill(oPC, nToken);  // Close the popup
    
    NUI_PopupZap(oPC)
        Close ALL open NUI windows for a player at once.
        Scans tokens 1-1000 and destroys any active windows.
        Useful for cleanup or emergency UI reset.
        
        Example:
            int nClosed = NUI_PopupZap(oPC);
            SendMessageToPC(oPC, "Closed " + IntToString(nClosed) + 
                " windows.");
    
    NuiSetBind(oPC, nToken, sBindId, jValue)
        Update binding value on displayed window (live updates).
        
        Example:
            NuiSetBind(oPC, nToken, "player_name",
                JsonString("New Name"));

*/

// =========================================================================
// SECTION 2: ALL 61 POPUP FUNCTIONS (A-Z)
// =========================================================================

/*

    All popup functions follow a consistent pattern:
    
    Signature: int NUI_PopupFunctionName(
        object oPC,           // Player character
        string sTitle,        // Window title
        [additional parameters as needed],
        string sScript        // Event handler script
    )
    
    Returns: int dialog token (>0 = success, 0 = failure)
    
    --- CORE POPUPS (3 functions) ---
    
    NUI_PopupMessage(oPC, sTitle, sMessage, sScript)
        Simple message display. Foundation for many other popups.
    
    NUI_PopupConfirm(oPC, sTitle, sMessage, sScript)
        OK/Cancel confirmation dialog.
    
    NUI_PopupYesNo(oPC, sTitle, sMessage, sScript)
        Yes/No question dialog.
    
    --- WINDOW MANAGEMENT (2 functions) ---
    
    NUI_Kill(oPC, nToken)
        Close and destroy an open NUI window by token.
        Pass the token returned from NuiCreate or NUI_PopupXXX.
        Returns 0 on success, -1 on invalid token.
    
    NUI_PopupZap(oPC)
        Close all open NUI windows for a player at once.
        Useful for cleanup, state reset, or emergency shutdown.
        Returns number of windows closed (0 if none were open).
    
    --- CHARACTER INFORMATION (6 functions) ---
    
    NUI_PopupClass(oPC, sTitle, sScript)
        Display character class and level.
    
    NUI_PopupPC(oPC, sTitle, sScript)
        Full character sheet with name, level, class, race, XP.
    
    NUI_PopupRace(oPC, sTitle, sScript)
        Display character race and subrace.
    
    NUI_PopupStats(oPC, sTitle, sScript)
        Six ability scores (STR, DEX, CON, INT, WIS, CHA).
    
    NUI_PopupStatus(oPC, sTitle, sScript)
        Health, level, and experience display.
    
    NUI_PopupSkills(oPC, sTitle, sScript)
        Character skills and proficiencies.
    
    --- INVENTORY & ITEMS (6 functions) ---
    
    NUI_PopupInventory(oPC, sTitle, sScript)
        Character inventory management.
    
    NUI_PopupPack(oPC, sTitle, sScript)
        Backpack and carried equipment.
    
    NUI_PopupChest(oPC, sTitle, sScript)
        Treasure chest or container contents.
    
    NUI_PopupLoot(oPC, sTitle, sScript)
        Loot container with take all option.
    
    NUI_PopupCasket(oPC, sTitle, sScript)
        Storage/burial container contents.
    
    NUI_PopupBank(oPC, sTitle, sScript)
        Banking and currency management.
    
    --- INPUT CONTROLS (7 functions) ---
    
    NUI_PopupText(oPC, sTitle, sLabel, sScript)
        Text input with label.
    
    NUI_PopupInt(oPC, sTitle, sLabel, nMin, nMax, nDefault, sScript)
        Integer slider input.
    
    NUI_PopupFloat(oPC, sTitle, sLabel, fMin, fMax, fDefault, sScript)
        Float slider input.
    
    NUI_PopupSlider(oPC, sTitle, sLabel, fMin, fMax, fDefault, sScript)
        Float slider (alternative to PopupFloat).
    
    NUI_PopupRange(oPC, sTitle, sLabel, fMin, fMax, fDefault, sScript)
        Range/distance slider.
    
    NUI_PopupColor(oPC, sTitle, sScript)
        RGB color picker.
    
    NUI_PopupInput(oPC, sTitle, sPrompt, sScript)
        Generic text input (calls PopupText).
    
    --- GAME SYSTEMS (12 functions) ---
    
    NUI_PopupCombat(oPC, sTitle, sScript)
        Combat mode and attack options.
    
    NUI_PopupBuild(oPC, sTitle, sScript)
        Building and construction system.
    
    NUI_PopupEncounter(oPC, sTitle, sScript)
        Encounter difficulty and startup.
    
    NUI_PopupEmote(oPC, sTitle, sScript)
        Emote and animation selection.
    
    NUI_PopupFX(oPC, sTitle, sScript)
        Visual effects selector.
    
    NUI_PopupHome(oPC, sTitle, sScript)
        Home location and teleport system.
    
    NUI_PopupJournal(oPC, sTitle, sScript)
        Journal and quest log display.
    
    NUI_PopupMap(oPC, sTitle, sScript)
        Area map and navigation system.
    
    NUI_PopupMove(oPC, sTitle, sScript)
        Movement and quick travel.
    
    NUI_PopupMusic(oPC, sTitle, sScript)
        Music player and track selection.
    
    NUI_PopupQuest(oPC, sTitle, sScript)
        Quest management interface.
    
    NUI_PopupSky(oPC, sTitle, sScript)
        Weather and sky control system.
    
    --- ADVANCED FEATURES (27 functions) ---
    
    NUI_PopupAbout(oPC, sTitle, sScript)
        Server/module information display.
    
    NUI_PopupAdmin(oPC, sTitle, sScript)
        Admin and DM tools interface.
    
    NUI_PopupAlignment(oPC, sTitle, sScript)
        Character alignment display.
    
    NUI_PopupBiography(oPC, sTitle, sScript)
        Character biography editor (multi-line).
    
    NUI_PopupBook(oPC, sTitle, sText, sScript)
        Book/document reader with scrolling.
    
    NUI_PopupChoice(oPC, sTitle, sQuestion, sScript)
        Yes/No choice dialog (calls PopupYesNo).
    
    NUI_PopupConfig(oPC, sTitle, sScript)
        Game configuration and settings.
    
    NUI_PopupCustom(oPC, sTitle, sContent, sScript)
        Generic custom popup (calls PopupMessage).
    
    NUI_PopupDM(oPC, sTitle, sScript)
        Dungeon Master tools (DM only).
    
    NUI_PopupError(oPC, sTitle, sMessage, sScript)
        Error message with [ERROR] prefix.
    
    NUI_PopupFlags(oPC, sTitle, sScript)
        Boolean flag manager interface.
    
    NUI_PopupHelp(oPC, sTitle, sScript)
        Help and instructions display.
    
    NUI_PopupInfo(oPC, sTitle, sMessage, sScript)
        Information message with [INFO] prefix.
    
    NUI_PopupLights(oPC, sTitle, sScript)
        Lighting and brightness control.
    
    NUI_PopupLock(oPC, sTitle, sScript)
        Lock/unlock mechanism interface.
    
    NUI_PopupPerks(oPC, sTitle, sScript)
        Character perks and abilities.
    
    NUI_PopupPortrait(oPC, sTitle, sScript)
        Portrait selector interface.
    
    NUI_PopupQuests(oPC, sTitle, sScript)
        Quest list display (generic list).
    
    NUI_PopupRitual(oPC, sTitle, sScript)
        Ritual casting system.
    
    NUI_PopupSound(oPC, sTitle, sScript)
        Sound effects selector.
    
    NUI_PopupSoundset(oPC, sTitle, sScript)
        Voice and soundset selector.
    
    NUI_PopupSpawn(oPC, sTitle, sScript)
        NPC/Monster spawning (DM only).
    
    NUI_PopupSpells(oPC, sTitle, sScript)
        Spells and powers display.
    
    NUI_PopupSuccess(oPC, sTitle, sMessage, sScript)
        Success message with [SUCCESS] prefix.
    
    NUI_PopupTile(oPC, sTitle, sScript)
        Tile and object editor.
    
    NUI_PopupTrap(oPC, sTitle, sScript)
        Trap arm/disarm interface.
    
    NUI_PopupTransform(oPC, sTitle, sScript)
        Transformation and polymorph system.
    
    NUI_PopupValidation(oPC, sTitle, sMessage, sScript)
        Validation confirmation (calls PopupConfirm).
    
    NUI_PopupWarning(oPC, sTitle, sMessage, sScript)
        Warning message with [WARNING] prefix.

*/

// =========================================================================
// SECTION 3: BASIC EXAMPLES
// =========================================================================

/*

    EXAMPLE 1: Simple Welcome Message
    ==================================
    
    Display a message when player enters area.
    
    void OnPlayerEnter()
    {
        object oPC = GetEnteringObject();
        if (!GetIsPC(oPC)) return;
        
        string sMessage = "Welcome to the server!";
        NUI_PopupMessage(oPC, "Welcome", sMessage, "welcome_handler");
    }
    
    Result: Popup shows "Welcome" title with message text.


    EXAMPLE 2: Ask Player Yes/No Question
    ======================================
    
    Ask player to confirm an action.
    
    void AskPlayerConfirmation(object oPC)
    {
        string sQuestion = "Do you want to accept this quest?";
        NUI_PopupYesNo(oPC, "Quest Confirmation", sQuestion,
            "quest_handler");
    }
    
    Result: Popup with Yes/No buttons. Handler determines which was clicked.


    EXAMPLE 3: Display Character Stats
    ===================================
    
    Show player's six ability scores.
    
    void ShowStats(object oPC)
    {
        NUI_PopupStats(oPC, "Character Stats", "stats_handler");
    }
    
    Result: Popup displays STR, DEX, CON, INT, WIS, CHA automatically.


    EXAMPLE 4: Get Text Input from Player
    ======================================
    
    Ask player for text input (name, description, etc).
    
    void AskPlayerName(object oPC)
    {
        NUI_PopupText(oPC, "Character Name",
            "Enter your character's name:", "name_handler");
    }
    
    Result: Popup with text field. Player enters text.


    EXAMPLE 5: Simple Color Picker
    ===============================
    
    Let player choose a color (hair, armor, etc).
    
    void SelectHairColor(object oPC)
    {
        NUI_PopupColor(oPC, "Choose Hair Color", "color_handler");
    }
    
    Result: Popup with RGB color picker interface.


    EXAMPLE 5B: Close Window Programmatically
    ==========================================
    
    Open a popup and close it from code after some action.
    
    void ShowTemporaryMessage(object oPC, string sMessage)
    {
        int nToken = NUI_PopupMessage(oPC, "Notification", sMessage,
            "temp_handler");
        
        if (nToken > 0) {
            // Store token for later
            SetLocalInt(oPC, "TEMP_MESSAGE_TOKEN", nToken);
            
            // Close after 10 seconds
            DelayCommand(10.0, CloseTempMessage(oPC, nToken));
        }
    }
    
    void CloseTempMessage(object oPC, int nToken)
    {
        NUI_Kill(oPC, nToken);
    }
    
    Result: Popup displays for 10 seconds then automatically closes.

*/

// =========================================================================
// SECTION 4: ADVANCED EXAMPLES
// =========================================================================

/*

    EXAMPLE 6: Custom Multi-Control Dialog
    =======================================
    
    Build a complex popup with multiple inputs.
    
    int ShowCharacterEditor(object oPC)
    {
        // Create name label and input
        json jNameLabel = NuiLabel(JsonString("Name:"),
            JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_TOP));
        json jNameInput = NuiTextEdit(JsonString(""),
            NuiBind("char_name"), 50, FALSE, TRUE);
        json jNameRow = NuiRow(JsonArray2(jNameLabel, jNameInput));
        
        // Create level slider
        json jLevelLabel = NuiLabel(JsonString("Level:"),
            JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_TOP));
        json jLevelSlider = NuiSlider(JsonInt(1), JsonInt(1),
            JsonInt(20), JsonInt(1));
        json jLevelRow = NuiRow(JsonArray2(jLevelLabel, jLevelSlider));
        
        // Create buttons
        json jOKBtn = NuiButton(JsonString("Save"));
        json jCancelBtn = NuiButton(JsonString("Cancel"));
        json jButtonRow = NuiRow(JsonArray2(jOKBtn, jCancelBtn));
        
        // Stack all vertically
        json jContent = NuiCol(JsonArray3(jNameRow, jLevelRow, jButtonRow));
        
        // Create window
        json jGeom = NuiRect(-1.0, -1.0, 400.0, 250.0);
        json jWindow = NuiWindow(jContent, JsonString("Character Editor"),
            jGeom, JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE),
            JsonBool(FALSE), JsonBool(TRUE));
        
        // Display and return token
        return NuiCreate(oPC, jWindow, "editor_handler");
    }
    
    Usage:
        int nToken = ShowCharacterEditor(oPC);
        if (nToken > 0) {
            SetLocalInt(oPC, "EDITOR_TOKEN", nToken);
        }


    EXAMPLE 7: Dynamic Content Updates
    ===================================
    
    Create a window and update its content in real-time.
    
    void ShowLiveStats(object oPC)
    {
        int nToken = NUI_PopupStats(oPC, "Live Stats", "handler");
        
        // Store token for later
        SetLocalInt(oPC, "STATS_TOKEN", nToken);
        
        // Later, update a binding value
        if (nToken > 0) {
            // Simulate stat change
            int nNewHP = GetCurrentHitPoints(oPC);
            // Note: In real implementation, would use NuiSetBind
            // NuiSetBind(oPC, nToken, "health", JsonInt(nNewHP));
        }
    }


    EXAMPLE 8: Conditional Popup Based on Level
    =============================================
    
    Show different popups based on player progression.
    
    void ShowContextualHelp(object oPC)
    {
        int nLevel = GetLevelByPosition(1, oPC);
        
        if (nLevel < 5) {
            // New player
            NUI_PopupHelp(oPC, "Beginner Help",
                "help_handler");
        }
        else if (nLevel < 15) {
            // Mid-level
            NUI_PopupQuests(oPC, "Available Quests",
                "quest_handler");
        }
        else {
            // High level
            NUI_PopupSpells(oPC, "Spells",
                "spell_handler");
        }
    }


    EXAMPLE 9: Information Display Sequence
    =======================================
    
    Show multiple popups in succession.
    
    void ShowGameIntroduction(object oPC)
    {
        // First popup
        int nToken1 = NUI_PopupAbout(oPC, "Server Info",
            "intro_handler");
        
        if (nToken1 > 0) {
            // Store current step
            SetLocalInt(oPC, "INTRO_STEP", 1);
            SetLocalInt(oPC, "INTRO_TOKEN", nToken1);
        }
    }
    
    // In event handler, detect close and show next popup
    void OnIntroPopupClose(object oPC)
    {
        int nStep = GetLocalInt(oPC, "INTRO_STEP");
        
        if (nStep == 1) {
            // Show second popup
            NUI_PopupHelp(oPC, "Game Help", "intro_handler");
            SetLocalInt(oPC, "INTRO_STEP", 2);
        }
        else if (nStep == 2) {
            // Introduction complete
            SendMessageToPC(oPC, "Introduction complete!");
        }
    }


    EXAMPLE 10: Slider-Based Selection System
    ==========================================
    
    Use sliders for numeric selection (difficulty, price, etc).
    
    void SelectGameDifficulty(object oPC)
    {
        // Create difficulty slider (1-5)
        int nToken = NUI_PopupInt(oPC, "Select Difficulty",
            "Choose game difficulty:", 1, 5, 3, "difficulty_handler");
        
        if (nToken > 0) {
            SetLocalInt(oPC, "DIFFICULTY_TOKEN", nToken);
        }
    }
    
    // In event handler
    void OnDifficultySelected(object oPC)
    {
        // Retrieve the selected value from dialog bindings
        // Handler would read from dialog token to get selected value
        SendMessageToPC(oPC, "Difficulty selected!");
    }


    EXAMPLE 11: Emergency UI Reset with NUI_PopupZap
    =================================================
    
    Close all open popups for a player at once.
    
    void ResetPlayerUI(object oPC)
    {
        int nClosed = NUI_PopupZap(oPC);
        SendMessageToPC(oPC, "UI reset: closed " + IntToString(nClosed)
            + " windows.");
    }
    
    Usage in event handlers:
        ResetPlayerUI(oPC);
        // All NUI windows automatically destroyed


    EXAMPLE 12: Conditional Window Closure
    =======================================
    
    Close specific window when conditions change.
    
    void OnPlayerLevelUp(object oPC)
    {
        // Show level up notification
        int nToken = NUI_PopupSuccess(oPC, "Level Up!",
            "Congratulations on reaching a new level!", "levelup_handler");
        
        if (nToken > 0) {
            // Auto-close after 5 seconds
            DelayCommand(5.0, NUI_Kill(oPC, nToken));
        }
    }
    
    // Or close immediately if combat starts
    void OnCombatStart(object oPC)
    {
        int nToken = GetLocalInt(oPC, "ACTIVE_POPUP_TOKEN");
        if (nToken > 0) {
            NUI_Kill(oPC, nToken);  // Close active popup
        }
    }

*/

// =========================================================================
// SECTION 5: ADDON MODULES REFERENCE
// =========================================================================

/*

    The Carcerian NUI System includes specialized addon modules:
    
    BODY ADJUSTMENT SYSTEM (nui_body_api.nss)
        - Character appearance customization
        - Skin tone, hair color, features
        - Equipped item appearance preview
        - Integration with character creation
    
    CRAFTING SYSTEM (nui_cf_api.nss)
        - Item creation and crafting interface
        - Recipe selection and management
        - Material requirement display
        - Crafting process interface
    
    CUSTOMIZATION SYSTEM (nui_ct_api.nss)
        - Equipment tailoring and personalization
        - Item coloring and appearance modification
        - Custom equipment slots
        - Visual customization interface
    
    EMOTE SYSTEM (nui_em_api.nss)
        - Animation and emote selection
        - Custom emote triggering
        - Emote categories and organization
        - Animation preview interface
    
    PLACEABLE SYSTEM (nui_plc_api.nss)
        - Object placement and positioning
        - Property management interface
        - Decoration and building tools
        - Object interaction system
    
    PVP SYSTEM (nui_pvp_api.nss)
        - PvP mode toggling and management
        - Challenge and duel system
        - Combat rules and settings
        - Ranking and competition interface
    
    REST SYSTEM (nui_rest_api.nss)
        - Rest and sleep interface
        - Recovery and healing mechanics
        - Rest location selection
        - Rest management system
    
    VFX SYSTEM (nui_vfx_api.nss)
        - Visual effects selector and viewer
        - Effect customization options
        - Animation preview system
        - Effect combination tools
    
    PERSISTENCE SYSTEM (nui_persist.nss, nui_safe_per.nss, nui_tailor_per.nss)
        - Character data persistence
        - State saving and loading
        - Auto-save functionality
        - Safe data serialization
    
    All addon modules follow the core NUI architecture and are accessed
    through the main #include "nui_api" statement.

*/

// =========================================================================
// SECTION 6: BEST PRACTICES
// =========================================================================

/*

    BEST PRACTICE 1: Always Check Dialog Token
    ===========================================
    
    int nToken = NUI_PopupMessage(oPC, "Title", "Message", "handler");
    if (nToken > 0) {
        // Successfully created - store for later reference
        SetLocalInt(oPC, "MY_DIALOG_TOKEN", nToken);
    }
    else {
        // Failed to create - handle error
        SendMessageToPC(oPC, "Could not open popup.");
    }


    BEST PRACTICE 2: Use Event Handlers for Responses
    ==================================================
    
    // In event handler script (specified in popup call):
    void HandleMyPopupEvent()
    {
        object oPC = OBJECT_SELF;
        
        // Determine which dialog this is
        int nToken = GetLocalInt(oPC, "MY_DIALOG_TOKEN");
        
        // Handle click events, text input, slider values, etc.
        // Use dialog event system to detect player interactions
    }


    BEST PRACTICE 3: Keep Popup Content Readable
    =============================================
    
    // Bad - cramped single popup
    NUI_PopupMessage(oPC, "Info",
        "This is a very long description that goes on and "
        "on and on with lots of information...", "handler");
    
    // Good - use scrollable popup
    NUI_PopupBook(oPC, "Info",
        "This is a very long description that goes on and "
        "on and on with lots of information...", "handler");


    BEST PRACTICE 4: Group Related Functions
    =========================================
    
    // Instead of showing 3 separate popups:
    // - Class info
    // - Race info
    // - Level info
    
    // Use one comprehensive popup that shows all:
    NUI_PopupPC(oPC, "Character", "handler");


    BEST PRACTICE 5: Provide Clear User Feedback
    =============================================
    
    // Confirm important actions
    NUI_PopupConfirm(oPC, "Confirm",
        "Are you sure? This cannot be undone.", "handler");
    
    // Use success/warning/error appropriately
    if (ActionSucceeded) {
        NUI_PopupSuccess(oPC, "Quest Complete", "Quest finished!",
            "handler");
    }
    else {
        NUI_PopupError(oPC, "Problem", "Invalid selection.", "handler");
    }


    BEST PRACTICE 6: Use Appropriate Popup Types
    =============================================
    
    Use popups for:
        - Confirmations and important decisions
        - Character creation and editing
        - Critical information display
        - Player choices and branches
    
    Don't use popups for:
        - Every server message (use floating text)
        - Constant status updates (use bindings or UI elements)
        - Combat feedback (use animations)
        - Spam notifications (use message logs)


    BEST PRACTICE 7: Plan Dialog Token Management
    ==============================================
    
    // Store tokens for multi-step dialogs
    SetLocalInt(oPC, "DIALOG_STEP_1_TOKEN", nToken);
    
    // Retrieve for updates
    int nToken = GetLocalInt(oPC, "DIALOG_STEP_1_TOKEN");
    if (nToken > 0) {
        NuiSetBind(oPC, nToken, "player_name",
            JsonString("Updated Name"));
    }


    BEST PRACTICE 8: Combine with Game Systems
    ===========================================
    
    // Example: Integrating popup with quest system
    void GiveQuestToPlayer(object oPC, string sQuestName)
    {
        // Show quest info popup
        NUI_PopupQuest(oPC, "New Quest", "quest_handler");
        
        // Store quest data for handler
        SetLocalString(oPC, "QUEST_NAME", sQuestName);
        SetLocalInt(oPC, "QUEST_ACTIVE", 1);
    }

*/

//::///////////////////////////////////////////////////////////////////////
//:: END OF DOCUMENTATION
//::///////////////////////////////////////////////////////////////////////
