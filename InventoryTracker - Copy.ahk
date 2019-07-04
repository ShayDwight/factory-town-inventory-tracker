;#Include JSON.ahk
SetWorkingDir %A_ScriptDir%
ItemIDs := {1:"Wood",2:"Planks",3:"Stone",4:"Stone Brick",5:"Iron Ore",6:"Iron Plate",7:"Gold Ore",8:"Gold Ingot",9:"Coal",10:"Reinforced Plank",11:"Mana Brick",12:"OmniStone",13:"Metal Conveyor Belt",14:"Cloth Conveyor Belt",15:"Magic Conveyor Belt",16:"Rail Tile",17:"Magic Rail Tile",18:"Steam Pipe",19:"Mana Pipe",20:"OmniPipe",21:"Wheat",22:"Sugar",23:"Apple",24:"Berries",27:"Carrot",28:"Cotton",29:"Tomato",30:"Pear",31:"Potato",32:"Herb",33:"Water",34:"Magma",35:"Flour",36:"Bread",37:"Jam",38:"Fruit Juice",39:"Milk",40:"Butter",41:"Cheese",42:"Cake",43:"Berry Cake",44:"Apple Pie",45:"Fish Stew",46:"Meat Stew",47:"Veggie Stew",48:"Sandwich",49:"Fertilizer",50:"Animal Feed",51:"Leather",52:"Beef",53:"Cooked Beef",54:"Egg",55:"Cooked Chicken",56:"Raw Chicken",57:"Fish",58:"Cooked Fish",59:"Wood Wheel",60:"Iron Wheel",61:"Gear",62:"Nails",63:"Wood Axe",64:"Pickaxe",65:"Wool",66:"Cloth",67:"Shirt",68:"Cloak",69:"Magic Cloak",70:"Shoe",71:"Warm Coat",72:"Magic Robe",73:"Crown",74:"Fire Ring",75:"Water Ring",76:"Necklace",77:"Polished Stone",78:"Ward",79:"Bandage",80:"Poultice",81:"Ointment",82:"Medical Wrap",83:"Protein Shake",84:"Fish Oil",85:"Remedy",86:"Health Potion",87:"Antidote",88:"Elixer",89:"Paper",90:"Book",91:"Enchanted Book",92:"Strength Spellbook",93:"Stamina Spellbook",94:"Cure Spellbook",95:"Protection Spellbook",96:"Mana Shard",97:"Fire Stone",99:"Air Stone",101:"Water Stone",103:"Earth Stone",105:"Fire Ether",106:"Water Ether",107:"Earth Ether",108:"Air Ether",109:"Mana Crystal",110:"Fire Crystal",111:"Water Crystal",112:"Earth Crystal",113:"Air Crystal",114:"Depleted Mana",115:"Depleted Fire",116:"Depleted Water",117:"Depleted Earth",118:"Depleted Air"}
F5::
startTime := 
endTime :=
if (A_ScriptDir == A_Desktop)
{
	MsgBox,51,, This Program creates a configuration file to keep track of its location on your screen, as well as a comma-separated values (.csv) file to keep track of trends.`n`nIf you are running this from your desktop, it is suggested you move this program to a folder in your User Folder, or a secondary folder on your Desktop, and create a shortcut for it on your Desktop`n`nIf you would like me to create a folder on your Desktop for you, press Yes.`n`nIf you don't mind configuration files on your Desktop, press No.`n`nIf you would like to move the program yourself, press Cancel.
	ifmsgbox Yes
	{
		FileCreateDir, %A_Desktop%\Factory Town Inventory Tracker\
		FileMove, %A_Desktop%\InventoryTracker.ahk, %A_Desktop%\Factory Town Inventory Tracker\
		FileCreateShortcut, %A_Desktop%\Factory Town Inventory Tracker\InventoryTracker.ahk, %A_Desktop%\InventoryTracker.lnk
		Run %A_Desktop%\Factory Town Inventory Tracker\InventoryTracker.ahk
		ExitApp
	}
	ifMsgBox No
	{
		Goto, Main
	}
	IfMsgBox Cancel
	{
		ExitApp
	}
	
}


FoldersGui:
ManySteamID := []
ListSteamIDs =
Loop, Files, C:\Program Files (x86)\Steam\userdata\*, D
{
	if (A_LoopFileName == 0) 
	{
	}
	else 
	{
		ManySteamID.Push(A_LoopFileName)
	}
}
FoldersFound := ManySteamID.Length()
for i in ManySteamID
	MSID .= ManySteamID[i] . "`n"


if (FoldersFound > 1)
{
	Gui, Folders:Add, Text,,This app detected more than one Steam User Account on this computer.`n`nPlease select the current User Account where you have Factory Town installed.`n`nYou can use the following links to help find your SteamID3.
	
	for i in ManySteamID
	{
		ListSteamIDs .= ManySteamID[i] "|"
		IDFinderURL := ManySteamID[i]
		Gui, Folders:Add, Link,, <a href="https://steamidfinder.com/lookup/U`%3A1`%3A%IDFinderURL%">https://steamidfinder.com/%IDFinderURL%</a>
	}
	
	
	Gui, Folders:Add, Text,,Select your correct SteamID3 from the list below.
	Gui, Folders:Add, ListBox, vSteamIDFolder, %ListSteamIDs%
	Gui, Folders:Add, Button, gFoldersSubmit, OK
	Gui, Folders:Show,, List of Steam IDs
	return
} 
else 
{
	SteamIDFolder := ManySteamID[1]
}


FoldersSubmit:
Gui, Folders:Submit


if !(SteamIDFolder) 
{
	MsgBox,4,, No User Account was selected. Please try again.
	Gui, Folders:Destroy
	Goto FoldersGui
}


FactoryTownSaveFolder := "C:\Program Files (x86)\Steam\userdata\" . SteamIDFolder . "\860890\remote"
SavFiles := []

Gui, SF:Default
Gui, SF:Add, ListView, -multi r10, File Name|Date Modified

Loop, %FactoryTownSaveFolder%\*.sav
{
	FormatTime, FileTimeFormat, %A_LoopFileTimeModified%, M/d/yyyy h:mm tt	
	LV_Add("", A_LoopFileName, FileTimeFormat)
}
LV_ModifyCol()
LV_ModifyCol(2, "SortDesc")

Gui, SF:Add, Text,, Please select your active Save File:
;Gui, SF:Add, ListBox, r10 w500 vSelectedFile, %SavFilesList%
Gui, SF:Add, Button, gSelectFileOK, OK
Gui, SF:Show
return

SelectFileOK:
LV_GetText(SaveFile, LV_GetNext())
Gui, SF:Submit
;msgbox % SaveFile


Main:
targetID = "targetID"
pInventory = "playerInventory"
InventoryIDs := []
playerInventoryTotal := []
startTime := A_TickCount

selectedFile := FactoryTownSaveFolder . "\" . SaveFile

;msgbox % "Selected File is: " selectedFile

Loop, read, %selectedFile%
{
	LineRead := StrReplace(A_LoopReadLine, "{""pos""", "`n{""pos""", repCount)
	Loop, Parse, LineRead, `n
	{		
		LineReadPercent := Round((A_Index/repCount)*100)
		if instr(A_LoopField, targetID)
		{
			if (SubStr(A_loopField,0,1) == ",") 
			{
				barn := SubStr(A_LoopField, 1, -1)
			}
			barnobj := JSON.load(barn)
			barnobjtargetID := barnobj.b.targetID
			barnobjtype := barnobj.b.type
			barnID := barnobjtype . barnobjtargetID
			barnobjNum1 := barnobj.b.inventory[1].f . "-1"
			barnobjNum2 := barnobj.b.inventory[2].f . "-2"
			barnobjNum3 := barnobj.b.inventory[3].f . "-3"
			barnobjNum4 := barnobj.b.inventory[4].f . "-4"
			barnobjQua1 := barnobj.b.inventory[1].c 
			barnobjQua2 := barnobj.b.inventory[2].c
			barnobjQua3 := barnobj.b.inventory[3].c
			barnobjQua4 := barnobj.b.inventory[4].c
			
			%barnID% := {(barnobjNum1): (barnobjQua1), (barnobjNum2): (barnobjQua2), (barnobjNum3): (barnobjQua3), (barnobjNum4): (barnobjQua4)}
			
			InventoryIDs.Push(barnID)
		}
		if instr(A_LoopField, pInventory)
		{
			FoundPos := RegExMatch(A_LoopField, """playerInventory"":\[\[.*]]\,""r", varforsavedstring)
			vartrimmed := SubStr(varforsavedstring, 1, -3)
			varwithbrackets := "{" . vartrimmed . "}"
			pInvobj := JSON.load()
			Loop, Parse, varwithbrackets, ]\,[
			{
			LineReadpI := StrReplace(A_LoopField, "`,[", "")
			LineReadpI := StrReplace(LineReadpI, "{""playerInventory"":[[", "")
			LineReadpI := StrReplace(LineReadpI, "}", "")
			LineReadpI := StrReplace(LineReadpI, "`,", ":")
			LineReadpI_Array := StrSplit(LineReadpI, ":")
			
			LRpIA1 := LineReadpI_Array[1]
			LRpIA2 := LineReadpI_Array[2]
			playerInventoryTotal[LRpIA1] := LRpIA2
			
			
			}
		}
	}
}
for i, v in playerInventoryTotal
	pITmsgbox .= i "=" v "`n"

barntotalInventory := []
for i in InventoryIDs
{
	key =
	value = 
	enum := InventoryIDs[i]
	if InStr(enum, "barn")
	{
		for key, value in %enum%
		{
			keysplit_array := StrSplit(key, "-")
			ksa := keysplit_array[1]
			addingInventory := barntotalInventory[ksa]
			if !(addingInventory)
				addingInventory = 0
			value += addingInventory
			barntotalInventory[ksa] := value
			
		}
	}	
}
endTime := A_TickCount - startTime
endTime := Round((endtime/1000),2)
barnmsgbox = 
for i, v in barntotalInventory
	barnmsgbox .= i "=" v "`n"


; the default AutoSave Interval is 10 minutes, but can go as low as 3 minutes, and as high as 60 minutes


for i, v in ItemIDs
	ItemIDs%i% = %v%
for i, v in barntotalInventory
	countIDs%i% = %v%
	
Gui, FTIT:Default
Gui, FTIT:Add, Edit, vLSearchInput gListSearch,
Gui, FTIT:Add, Text, vSearchText
Gui, FTIT:Add, ListView, -multi r25, Item|Qty

RowCount = 0
RowContents := []
for i, v in ItemIDs
{    
	if !(barntotalInventory[i])
        barntotalInventory[i] := 0
	LV_Add("", v,  barntotalInventory[i])
	RowCount++
	RowContents[RowCount] := v
    csvWrite .= i "=" barntotalInventory[i] "`,"
}


LV_ModifyCol()


Gui, FTIT:Show,,Factory Town Inventory Tracker


return

ListSearch:
GuiControlGet, StrToSearch,,LSearchInput
GuiControl, Text, SearchText, %StrToSearch%
for i, v in RowContents
{
	LV_GetText(CheckText, i)
	;if (CheckText != StrToSearch)
		
}

return

f6::
reload
return


/**
 * Lib: JSON.ahk
 *     JSON lib for AutoHotkey.
 * Version:
 *     v2.1.3 [updated 04/18/2016 (MM/DD/YYYY)]
 * License:
 *     WTFPL [http://wtfpl.net/]
 * Requirements:
 *     Latest version of AutoHotkey (v1.1+ or v2.0-a+)
 * Installation:
 *     Use #Include JSON.ahk or copy into a function library folder and then
 *     use #Include <JSON>
 * Links:
 *     GitHub:     - https://github.com/cocobelgica/AutoHotkey-JSON
 *     Forum Topic - http://goo.gl/r0zI8t
 *     Email:      - cocobelgica <at> gmail <dot> com
 */
/**
 * Class: JSON
 *     The JSON object contains methods for parsing JSON and converting values
 *     to JSON. Callable - NO; Instantiable - YES; Subclassable - YES;
 *     Nestable(via #Include) - NO.
 * Methods:
 *     Load() - see relevant documentation before method definition header
 *     Dump() - see relevant documentation before method definition header
 */
class JSON
{
	/**
	 * Method: Load
	 *     Parses a JSON string into an AHK value
	 * Syntax:
	 *     value := JSON.Load( text [, reviver ] )
	 * Parameter(s):
	 *     value      [retval] - parsed value
	 *     text    [in, ByRef] - JSON formatted string
	 *     reviver   [in, opt] - function object, similar to JavaScript's
	 *                           JSON.parse() 'reviver' parameter
	 */
	class Load extends JSON.Functor
	{
		Call(self, ByRef text, reviver:="")
		{
			this.rev := IsObject(reviver) ? reviver : false
		; Object keys(and array indices) are temporarily stored in arrays so that
		; we can enumerate them in the order they appear in the document/text instead
		; of alphabetically. Skip if no reviver function is specified.
			this.keys := this.rev ? {} : false
			static quot := Chr(34), bashq := "\" . quot
			     , json_value := quot . "{[01234567890-tfn"
			     , json_value_or_array_closing := quot . "{[]01234567890-tfn"
			     , object_key_or_object_closing := quot . "}"
			key := ""
			is_key := false
			root := {}
			stack := [root]
			next := json_value
			pos := 0
			while ((ch := SubStr(text, ++pos, 1)) != "") {
				if InStr(" `t`r`n", ch)
					continue
				if !InStr(next, ch, 1)
					this.ParseError(next, text, pos)
				holder := stack[1]
				is_array := holder.IsArray
				if InStr(",:", ch) {
					next := (is_key := !is_array && ch == ",") ? quot : json_value
				} else if InStr("}]", ch) {
					ObjRemoveAt(stack, 1)
					next := stack[1]==root ? "" : stack[1].IsArray ? ",]" : ",}"
				} else {
					if InStr("{[", ch) {
					; Check if Array() is overridden and if its return value has
					; the 'IsArray' property. If so, Array() will be called normally,
					; otherwise, use a custom base object for arrays
						static json_array := Func("Array").IsBuiltIn || ![].IsArray ? {IsArray: true} : 0
					
					; sacrifice readability for minor(actually negligible) performance gain
						(ch == "{")
							? ( is_key := true
							  , value := {}
							  , next := object_key_or_object_closing )
						; ch == "["
							: ( value := json_array ? new json_array : []
							  , next := json_value_or_array_closing )
						
						ObjInsertAt(stack, 1, value)
						if (this.keys)
							this.keys[value] := []
					
					} else {
						if (ch == quot) {
							i := pos
							while (i := InStr(text, quot,, i+1)) {
								value := StrReplace(SubStr(text, pos+1, i-pos-1), "\\", "\u005c")
								static tail := A_AhkVersion<"2" ? 0 : -1
								if (SubStr(value, tail) != "\")
									break
							}
							if (!i)
								this.ParseError("'", text, pos)
							  value := StrReplace(value,  "\/",  "/")
							, value := StrReplace(value, bashq, quot)
							, value := StrReplace(value,  "\b", "`b")
							, value := StrReplace(value,  "\f", "`f")
							, value := StrReplace(value,  "\n", "`n")
							, value := StrReplace(value,  "\r", "`r")
							, value := StrReplace(value,  "\t", "`t")
							pos := i ; update pos
							
							i := 0
							while (i := InStr(value, "\",, i+1)) {
								if !(SubStr(value, i+1, 1) == "u")
									this.ParseError("\", text, pos - StrLen(SubStr(value, i+1)))
								uffff := Abs("0x" . SubStr(value, i+2, 4))
								if (A_IsUnicode || uffff < 0x100)
									value := SubStr(value, 1, i-1) . Chr(uffff) . SubStr(value, i+6)
							}
							if (is_key) {
								key := value, next := ":"
								continue
							}
						
						} else {
							value := SubStr(text, pos, i := RegExMatch(text, "[\]\},\s]|$",, pos)-pos)
							static number := "number", integer :="integer"
							if value is %number%
							{
								if value is %integer%
									value += 0
							}
							else if (value == "true" || value == "false")
								value := %value% + 0
							else if (value == "null")
								value := ""
							else
							; we can do more here to pinpoint the actual culprit
							; but that's just too much extra work.
								this.ParseError(next, text, pos, i)
							pos += i-1
						}
						next := holder==root ? "" : is_array ? ",]" : ",}"
					} ; If InStr("{[", ch) { ... } else
					is_array? key := ObjPush(holder, value) : holder[key] := value
					if (this.keys && this.keys.HasKey(holder))
						this.keys[holder].Push(key)
				}
			
			} ; while ( ... )
			return this.rev ? this.Walk(root, "") : root[""]
		}
		ParseError(expect, ByRef text, pos, len:=1)
		{
			static quot := Chr(34), qurly := quot . "}"
			
			line := StrSplit(SubStr(text, 1, pos), "`n", "`r").Length()
			col := pos - InStr(text, "`n",, -(StrLen(text)-pos+1))
			msg := Format("{1}`n`nLine:`t{2}`nCol:`t{3}`nChar:`t{4}"
			,     (expect == "")     ? "Extra data"
			    : (expect == "'")    ? "Unterminated string starting at"
			    : (expect == "\")    ? "Invalid \escape"
			    : (expect == ":")    ? "Expecting ':' delimiter"
			    : (expect == quot)   ? "Expecting object key enclosed in double quotes"
			    : (expect == qurly)  ? "Expecting object key enclosed in double quotes or object closing '}'"
			    : (expect == ",}")   ? "Expecting ',' delimiter or object closing '}'"
			    : (expect == ",]")   ? "Expecting ',' delimiter or array closing ']'"
			    : InStr(expect, "]") ? "Expecting JSON value or array closing ']'"
			    :                      "Expecting JSON value(string, number, true, false, null, object or array)"
			, line, col, pos)
			static offset := A_AhkVersion<"2" ? -3 : -4
			throw Exception(msg, offset, SubStr(text, pos, len))
		}
		Walk(holder, key)
		{
			value := holder[key]
			if IsObject(value) {
				for i, k in this.keys[value] {
					; check if ObjHasKey(value, k) ??
					v := this.Walk(value, k)
					if (v != JSON.Undefined)
						value[k] := v
					else
						ObjDelete(value, k)
				}
			}
			
			return this.rev.Call(holder, key, value)
		}
	}
	/**
	 * Method: Dump
	 *     Converts an AHK value into a JSON string
	 * Syntax:
	 *     str := JSON.Dump( value [, replacer, space ] )
	 * Parameter(s):
	 *     str        [retval] - JSON representation of an AHK value
	 *     value          [in] - any value(object, string, number)
	 *     replacer  [in, opt] - function object, similar to JavaScript's
	 *                           JSON.stringify() 'replacer' parameter
	 *     space     [in, opt] - similar to JavaScript's JSON.stringify()
	 *                           'space' parameter
	 */
	class Dump extends JSON.Functor
	{
		Call(self, value, replacer:="", space:="")
		{
			this.rep := IsObject(replacer) ? replacer : ""
			this.gap := ""
			if (space) {
				static integer := "integer"
				if space is %integer%
					Loop, % ((n := Abs(space))>10 ? 10 : n)
						this.gap .= " "
				else
					this.gap := SubStr(space, 1, 10)
				this.indent := "`n"
			}
			return this.Str({"": value}, "")
		}
		Str(holder, key)
		{
			value := holder[key]
			if (this.rep)
				value := this.rep.Call(holder, key, ObjHasKey(holder, key) ? value : JSON.Undefined)
			if IsObject(value) {
			; Check object type, skip serialization for other object types such as
			; ComObject, Func, BoundFunc, FileObject, RegExMatchObject, Property, etc.
				static type := A_AhkVersion<"2" ? "" : Func("Type")
				if (type ? type.Call(value) == "Object" : ObjGetCapacity(value) != "") {
					if (this.gap) {
						stepback := this.indent
						this.indent .= this.gap
					}
					is_array := value.IsArray
				; Array() is not overridden, rollback to old method of
				; identifying array-like objects. Due to the use of a for-loop
				; sparse arrays such as '[1,,3]' are detected as objects({}). 
					if (!is_array) {
						for i in value
							is_array := i == A_Index
						until !is_array
					}
					str := ""
					if (is_array) {
						Loop, % value.Length() {
							if (this.gap)
								str .= this.indent
							
							v := this.Str(value, A_Index)
							str .= (v != "") ? v . "," : "null,"
						}
					} else {
						colon := this.gap ? ": " : ":"
						for k in value {
							v := this.Str(value, k)
							if (v != "") {
								if (this.gap)
									str .= this.indent
								str .= this.Quote(k) . colon . v . ","
							}
						}
					}
					if (str != "") {
						str := RTrim(str, ",")
						if (this.gap)
							str .= stepback
					}
					if (this.gap)
						this.indent := stepback
					return is_array ? "[" . str . "]" : "{" . str . "}"
				}
			
			} else ; is_number ? value : "value"
				return ObjGetCapacity([value], 1)=="" ? value : this.Quote(value)
		}
		Quote(string)
		{
			static quot := Chr(34), bashq := "\" . quot
			if (string != "") {
				  string := StrReplace(string,  "\",  "\\")
				; , string := StrReplace(string,  "/",  "\/") ; optional in ECMAScript
				, string := StrReplace(string, quot, bashq)
				, string := StrReplace(string, "`b",  "\b")
				, string := StrReplace(string, "`f",  "\f")
				, string := StrReplace(string, "`n",  "\n")
				, string := StrReplace(string, "`r",  "\r")
				, string := StrReplace(string, "`t",  "\t")
				static rx_escapable := A_AhkVersion<"2" ? "O)[^\x20-\x7e]" : "[^\x20-\x7e]"
				while RegExMatch(string, rx_escapable, m)
					string := StrReplace(string, m.Value, Format("\u{1:04x}", Ord(m.Value)))
			}
			return quot . string . quot
		}
	}
	/**
	 * Property: Undefined
	 *     Proxy for 'undefined' type
	 * Syntax:
	 *     undefined := JSON.Undefined
	 * Remarks:
	 *     For use with reviver and replacer functions since AutoHotkey does not
	 *     have an 'undefined' type. Returning blank("") or 0 won't work since these
	 *     can't be distnguished from actual JSON values. This leaves us with objects.
	 *     Replacer() - the caller may return a non-serializable AHK objects such as
	 *     ComObject, Func, BoundFunc, FileObject, RegExMatchObject, and Property to
	 *     mimic the behavior of returning 'undefined' in JavaScript but for the sake
	 *     of code readability and convenience, it's better to do 'return JSON.Undefined'.
	 *     Internally, the property returns a ComObject with the variant type of VT_EMPTY.
	 */
	Undefined[]
	{
		get {
			static empty := {}, vt_empty := ComObject(0, &empty, 1)
			return vt_empty
		}
	}
	class Functor
	{
		__Call(method, ByRef arg, args*)
		{
		; When casting to Call(), use a new instance of the "function object"
		; so as to avoid directly storing the properties(used across sub-methods)
		; into the "function object" itself.
			if IsObject(method)
				return (new this).Call(method, arg, args*)
			else if (method == "")
				return (new this).Call(arg, args*)
		}
	}
}
;     (¯`·._ (¯`·._  <[Function]>  _.·´¯) _.·´¯)
;-- Retrieves all keys in particular secion of a standard format .ini file --
;         OutputVar := IniGetKeys(Filename, Section [, Delimiter])
IniGetKeys(InputFile, Section , Delimiter="")
{
	;msgbox, OutputVar=%OutputVar% `n InputFile=%InputFile% `n Section=%Section% `n Delimiter=%Delimiter%
	Loop, Read, %InputFile%
	{
		If SectionMatch=1
		{
			If A_LoopReadLine=
				Continue
			StringLeft, SectionCheck , A_LoopReadLine, 1
			If SectionCheck <> [
			{
				StringSplit, KeyArray, A_LoopReadLine , =
				If KEYSlist=
					KEYSlist=%KeyArray1%
				Else
					KEYSlist=%KEYSlist%%Delimiter%%KeyArray1%
			}
			Else
				SectionMatch=
		}
		If A_LoopReadLine=[%Section%]
			SectionMatch=1
	}
	return KEYSlist
}