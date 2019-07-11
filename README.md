Place .sav files in "C:\Program Files (x86)\Steam\userdata\" . (SteamIDFolder) . "\860890\remote"
  
You need AutoHotKey installed to run the AHK file. 

You should only need to download either the AHK file (if you have AHK pre-installed) or the EXE file. If you don't have Factory Town installed on your computer, you will also need to download some sample .sav files provided and place them where instructed.

Once you start the AHK or EXE, a green H icon will appear in your Notification Area, but nothing will happen until you hit F5 on your keyboard. 

F5 starts the script once loaded. F6 will stop the current script and RE-load it. 

This script/addon is no-where near complete. The next steps I need to complete are to add an auto-refresh to automatically pull/poll data from your save file to update the numbers on the main GUI as you play. 

The default AutoSave Interval is 10 minutes, but can go as low as 3 minutes, and as high as 60 minutes.

Updates to come:

  * Automatically updating Totals GUI
  * Adding pretty icons and whatnot
  * Adding a way to track trends over time
    * Clicking a single item will pull up a simple graph showing trends
  * A menu bar to select certain options


Special Notes: 

*Inventory Tracker - Copy.ahk* has a different style of displaying items. Instead of displaying every single item on one GUI window, it instead uses AHK's ListView to display them in a scrollable list. There's no EXE with this one, because this is experimental. It was suggested to me that I give the option to choose between full GUI list (old-style) or ListView. I may do it. The search bar at the top of the ListView version is non-functional right now. I plan on making it work Live Search-style. As you type in, only the relevant lines are displayed in the ListView. This version of the script also moved the checking of the sav file into its own Function, so it can be called at any time in the rest of the script. 
