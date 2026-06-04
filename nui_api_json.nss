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
//:: Carcerian NUI - JSON Utilities and Helpers
//:: nui_api_json.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        JSON construction and manipulation helpers used throughout the NUI
        system. Provides wrappers for boolean values, array construction,
        and common object patterns (like dialog records).

        This is a pure utility library with no game logic. It is safe to
        #include anywhere and can be used standalone.

    DEPENDENCIES
        None. This is foundational.

    USAGE
        #include "nui_api_json"
        json jArr = JsonArray3(JsonString("a"), JsonInt(1), JsonFloat(2.5));

    EXAMPLE (beginner)
        // Build a small array without looping.
        json j = JsonArray2(JsonString("label"), JsonInt(5));

    EXAMPLE (intermediate)
        // Count elements in an array.
        int n = GetJsonArraySize(jArray);

    EXAMPLE (advanced)
        // Parse and validate a JSON structure by type.
        int nType = JsonGetType(JsonObjectGet(jObj, "status"));
        if (nType == JSON_TYPE_INT) { <handle> }
*/
//::///////////////////////////////////////////////////////////////////////
//:: Author:  Carcerian
//:: Version: 1.0
//:: Created: June 1, 2026
//:: MODIFIED: June 5, 2026 - Production release
//::///////////////////////////////////////////////////////////////////////


/* ----------------------------------------------------------------------- */
/*  JSON TYPE CONSTANTS (from NWScript builtins)                           */
/* ----------------------------------------------------------------------- */

// JSON_TYPE_NULL, JSON_TYPE_OBJECT, JSON_TYPE_ARRAY are built-in
// These are just reminders of their values for reference.

// const int JSON_TYPE_NULL   = 0;
// const int JSON_TYPE_OBJECT = 1;
// const int JSON_TYPE_ARRAY  = 2;


/* ----------------------------------------------------------------------- */
/*  ARRAY HELPERS                                                           */
/*  Build short JSON arrays without loops.                                 */
/* ----------------------------------------------------------------------- */

// Return a one-element JSON array.
json JsonArray1(json j1);

// Return a two-element JSON array.
json JsonArray2(json j1, json j2);

// Return a three-element JSON array.
json JsonArray3(json j1, json j2, json j3);


/* ----------------------------------------------------------------------- */
/*  BOOLEAN WRAPPERS                                                        */
/*  JSON has no native boolean, so these stand in as 0/1 integers.        */
/* ----------------------------------------------------------------------- */

// Return JSON integer 1, used for logical TRUE.
json JsonTrue();

// Return JSON integer 0, used for logical FALSE.
json JsonFalse();


/* ----------------------------------------------------------------------- */
/*  ARRAY SIZE HELPER                                                       */
/*  NWScript provides no JsonArrayLength, so this walks until NULL.        */
/* ----------------------------------------------------------------------- */

// Return the element count of a JSON array. Returns 0 if not an array.
int GetJsonArraySize(json jArray);


/* ======================================================================= */
/*  IMPLEMENTATION                                                          */
/* ======================================================================= */

json JsonArray1(json j1)
{
    json jArr = JsonArray();
    return JsonArrayInsert(jArr, j1);
}

json JsonArray2(json j1, json j2)
{
    json jArr = JsonArray();
    jArr = JsonArrayInsert(jArr, j1);
    return JsonArrayInsert(jArr, j2);
}

json JsonArray3(json j1, json j2, json j3)
{
    json jArr = JsonArray();
    jArr = JsonArrayInsert(jArr, j1);
    jArr = JsonArrayInsert(jArr, j2);
    return JsonArrayInsert(jArr, j3);
}

json JsonTrue()
{
    return JsonInt(1);
}

json JsonFalse()
{
    return JsonInt(0);
}

int GetJsonArraySize(json jArray)
{
    if (JsonGetType(jArray) != JSON_TYPE_ARRAY) return 0;

    int nCount = 0;
    while (JsonGetType(JsonArrayGet(jArray, nCount)) != JSON_TYPE_NULL)
        nCount++;

    return nCount;
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
