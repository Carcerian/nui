# Carcerian NUI System v1.0

A comprehensive Natural User Interface (NUI) popup and dialog system for Neverwinter Nights: Enhanced Edition (NWN:EE).

## Overview

The Carcerian NUI System provides a complete framework for creating professional player-facing UI windows, popups, signs, and dialogs in NWN:EE. Built entirely in NWScript with strict architectural standards and comprehensive documentation.

**Current Status:** v1.0 - Production Ready  
**Language:** NWScript (100% NWN:EE compatible)  
**Files:** 41 NSS modules  
**Functions:** 65+ popup/dialog functions  
**Lines of Code:** ~8,500+ (core API)

## Features

### Core Popups
- **NUI_PopupMessage** - Simple messages with OK button
- **NUI_PopupSign** - Large sign displays with portrait images (XML layout)
- **NUI_PopupError/Success/Warning/Info** - Color-coded message types
- **NUI_PopupDialog** - Custom dialogs with flexible layouts
- **NUI_PopupYesNo/Choice** - User choice prompts

### System Components

**Architecture**
- `nui_api.nss` - Main API entry point
- `nui_api_popup.nss` - All 65+ popup functions
- `nui_api_handle.nss` - Event handler routing
- `nui_api_config.nss` - Configuration constants
- `nui_api_json.nss` - JSON utility functions
- `nui_aoe.nss` - AOE integration for window lifecycle

**Subsystems**
- `nui_body_api.nss` / `nui_body_adj.nss` - Body appearance customization
- `nui_cf_api.nss` - Crafting system
- `nui_ct_api.nss` / `nui_ct_eq.nss` - Customization/equipment
- `nui_em_api.nss` / `nui_emote.nss` - Emote system
- `nui_plc_api.nss` / `nui_plc.nss` - Placeable integration
- `nui_pvp_api.nss` / `nui_pvp.nss` - PvP system
- `nui_rest_api.nss` / `nui_rest.nss` - Rest/healing
- `nui_vfx_api.nss` / `nui_vfx.nss` - Visual effects
- `nui_shop.nss` / `nui_shop_evt.nss` - Commerce
- `nui_talk.nss` / `nui_talk_evt.nss` - NPC dialogue

**Utilities & Support**
- `nui_handler.nss` - Main event dispatcher
- `nui_log.nss` - Logging system
- `nui_persist.nss` / `nui_safe_per.nss` / `nui_tailor_per.nss` - Persistence
- `nui_data.nss` - Data management
- `nui_validate.nss` - Input validation
- `nui_doc.nss` - Documentation
- `nui_enter.nss` / `nui_leave.nss` / `nui_load.nss` - Lifecycle
- `nui_mod_event.nss` / `nui_event.nss` - Module events

### Advanced Features

**Window Properties (nProps)**
- Resizable windows
- Collapsible windows
- Closable windows (X button)
- Border styling
- Transparent backgrounds
- Predefined flag combinations

**AOE Integration**
- Windows tied to Area of Effect objects
- Auto-close when player leaves AOE radius
- Sign placement at object location
- Configurable AOE radius

**XML Layout Support**
- Professional portrait display (XML format)
- Complex layouts with row/column structure
- Dynamic image aspect ratios
- Centered content positioning

**Portrait Images**
- Display object portraits in signs
- Fallback to default portrait if not set
- Proper XML image element formatting
- Aspect ratio fitting

## Installation

1. **Copy all NSS files** to your NWN:EE module scripts directory
2. **Compile with NWN:EE toolset** (all files compile without errors)
3. **Add event hooks to module:**
   - Module OnNUI Event → `nui_mod_event`
   - Area OnEnter → `nui_enter`
   - Area OnExit → `nui_leave`
   - Module Load → `nui_load`

4. **Attach to placeables:**
   - OnUsed event → `nui_example` (shows how to use NUI_PopupSign)

## Usage

### Simple Message
```nscript
#include "nui_api"

void main()
{
    object oPC = GetFirstPC();
    NUI_PopupMessage(oPC, "Title", "Message text");
}
```

### Sign Display
```nscript
#include "nui_api"

void main()
{
    object oPC = GetLastUsedBy();
    // Attach to sign placeable OnUsed event
    // Sign uses OBJECT_SELF for:
    //   - Name (window title)
    //   - Description (window content)
    //   - Portrait (portrait image)
    NUI_PopupSign(oPC);
}
```

### Error/Success/Info/Warning
```nscript
NUI_PopupError(oPC, "Error Title", "Error message");
NUI_PopupSuccess(oPC, "Success", "Action completed");
NUI_PopupInfo(oPC, "Info", "Informational message");
NUI_PopupWarning(oPC, "Warning", "Warning message");
```

### Custom Dialog
```nscript
json jContent = NuiLabel(JsonString("Custom content"),
                        JsonInt(NUI_HALIGN_CENTER), 
                        JsonInt(NUI_VALIGN_MIDDLE));

int nToken = NUI_DialogCreate(oPC, "Title", jContent, 1, "",
                             "nui_handler", NUI_PROP_CLOSABLE,
                             312.5f, 156.25f, FALSE);
```

## Architecture Standards

### File Structure (7-layer model)
1. BioWare-style ASCII header with Carcerian art
2. Title/Author/Synopsis block
3. Local variable storage keys
4. Forward declarations (ALL functions)
5. Implementations
6. EOF marker

### Naming Conventions
- Functions: `NUI_PascalCase()`
- Constants: `NUI_CONSTANT_NAME`
- Local variables: `nToken`, `sMessage`, `oPC`
- Max filename: 16 chars (including .nss)

### Code Standards
- No preprocessor directives (#define)
- No non-ASCII characters
- No #include cycles
- Strict forward declarations
- JSON-based configuration
- Built-in `nw_inc_nui` widget system only

### Type System
- All NuiImage calls use XML layout format
- All window functions return int (token)
- All popups use sScript="nui_handler" default
- All geometry uses NuiRect(-1.0f, Y, W, H)

## Window Properties (nProps Flags)

```nscript
const int NUI_PROP_RESIZABLE = 1;       // User can resize
const int NUI_PROP_COLLAPSIBLE = 2;     // User can minimize
const int NUI_PROP_CLOSABLE = 4;        // X button present
const int NUI_PROP_BORDER = 8;          // Visible border
const int NUI_PROP_TRANSPARENT = 16;    // Transparent BG

// Predefined combinations:
const int NUI_PROP_NONE = 0;
const int NUI_PROP_CLOSABLE_ONLY = 4;
const int NUI_PROP_CLOSABLE_TRANSPARENT = 20;
const int NUI_PROP_ALL = 31;
```

## Configuration

**nui_api_config.nss** contains:
- Window property flags
- Default dimensions
- Color definitions
- Error codes
- AOE settings
- Logging levels

**To customize:**
1. Edit `nui_api_config.nss`
2. Recompile all files
3. No other changes needed

## Event Handling

All NUI events route through `nui_handler.nss`:
- Button clicks
- Window close events
- AOE exit events
- Custom element events

Handler automatically:
- Identifies event source
- Routes to appropriate function
- Manages window cleanup
- Logs errors

## Persistence

Three persistence tiers available:
- `nui_persist.nss` - Standard persistence
- `nui_safe_per.nss` - Safety checks
- `nui_tailor_per.nss` - Tailor integration

Data stored via SetLocal* functions on player objects.

## Documentation

**Included Files:**
- `nui_example.nss` - 10 copy-paste usage examples
- `NUI_ARCHITECTURE_GUIDE.txt` - Deep dive into NUI internals
- Comments in every function
- Clear parameter documentation

## Examples

See `nui_example.nss` for:
1. Sign display from placeable OnUsed
2. Simple message popup
3. Error/Success/Warning/Info popups
4. Custom dialog creation
5. Window positioning
6. Multiple concurrent popups
7. Window property customization

## Performance

- Lightweight popup system (~50 KB compiled)
- No memory leaks (proper cleanup)
- Fast event routing (hash-based)
- Efficient JSON parsing
- AOE-based lifecycle management

## Compatibility

- **NWN:EE** - Fully tested and compatible
- **NWScript** - Standard NWScript only
- **Toolset** - Compatible with NWN:EE toolset
- **Macros** - Works with macro system
- **Custom UIs** - Integrates with existing systems

## Known Limitations

- Portrait display requires XML layout (not direct NuiImage)
- AOE cleanup on 99999 second timer (27.7 hours)
- Single event handler per window type
- Window positions relative to screen (not world)

## Troubleshooting

**Window doesn't appear:**
- Check module OnNUI event hook to `nui_mod_event`
- Verify player is PC (GetIsPC check)
- Check token > 0 on NUI_DialogCreate return

**Portrait not displaying:**
- Verify GetPortraitResRef returns valid resref
- Check XML layout is properly formatted
- Ensure image path is correct

**AOE not working:**
- Verify AOE created at sign location
- Check cleanup timer (99999 seconds)
- Confirm player is in AOE radius

**Button clicks not registering:**
- Check element ID is set (NuiId wrapper)
- Verify button is in jContent structure
- Confirm event handler is attached

## Performance Tips

1. Use NUI_PopupMessage for simple cases
2. Pool window tokens if creating many windows
3. Clean up windows when done (NuiDestroy)
4. Use AOE for location-based windows
5. Keep JSON structures simple

## Future Enhancements

Potential additions:
- Drag-and-drop support
- Custom color binding
- Grid/table layouts
- Progress bars
- Slider controls
- Text input fields
- Dropdown menus

## License & Attribution

**Carcerian NUI System v1.0**  
Created by: Carcerian  
For: Neverwinter Nights: Enhanced Edition  
Last Modified: June 3, 2026

Built with strict architectural standards and comprehensive documentation. Ready for production use.

## Support & Reference

- **Compiler Source:** https://github.com/nwneetools/nwnsc
- **NWN:EE Documentation:** https://neverwintervault.org
- **NUI Widget System:** Built on `nw_inc_nui`

## Contributing

This is a reference implementation. Modifications welcome but maintain:
- 7-layer file structure
- Strict forward declarations
- ASCII header format
- VERSION locked at 1.0 (use MODIFIED field)
- No non-ASCII comments

---

**Status:** ✓ v1.0 Production Ready  
**Compilation:** ✓ All files pass NWN:EE compiler  
**Testing:** ✓ In-game tested  
**Documentation:** ✓ Complete
