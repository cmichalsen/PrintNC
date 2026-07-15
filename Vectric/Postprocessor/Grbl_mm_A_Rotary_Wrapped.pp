+================================================
+                                                
+ Grbl - Vectric machine output configuration file   
+                                                
+================================================
+                                                
+ History                                        
+                                                  
+ Who      When       What                         
+ ======== ========== ===========================
+ EdwardP  28/11/2014 Written from GCode_mm.pp
+                     Added arc move support  
+ EdwardP  11/02/2015 Commented out arcs as these
+                     slow GRBL performance appear 
+                     interpolated anyway
+ EdwardP  18/06/2015 Explicitly set absolute mode (G90)
+ Mark     24/11/2015 Updated for interim 0.9 spec.
+                     Renaming to be machine specific.
+                     Removing M30 from Footer.
+ EdwardP  01/02/2018 Updated according to 1.1 spec
+                     Changed to 1.3 precision
+                     Spindle off (M5) in footer
+                     Added VTransfer Direct Output
+ EdwardP  07/12/2018 Added grbl laser 1.1 support. 
+                     - Power variable (0-1000 range)
+                     - Power on change only
+                     - [P] added to feedrate records
+                     - New laser record types:
+                       o JET_TOOL_ON
+                       o JET_TOOL_OFF 
+                       o JET_TOOL_POWER
+ MohamedM 13/12/2018 Move M3 and [S] from the header
+                     to a new SPINDLE_ON section which
+                     is not output in laser toolpaths
+                     or when the spindle speed is invalid (negative).
+ EdwardP 20/12/2018  Re-enabled arcs in response to 
+                     customer feedback ZD105327
+ CharlieP 02/06/2020 Added independent plunge record. This prevents
+                     early spindle speed command overburning
+                     during the plunge move in laser toolpaths.
+ MohamedM 17/06/2020 Add feedrate variable to plunge record.
+ GrzegorzK 13/07/2020 Added X Y missing from the plunge record.
+ ======== ========== ===========================

+================================================
+                                                
+ Grbl - Vectric machine output configuration file 
+ Modified for Y-to-A Rotary Wrapping           
+                                                
+================================================

POST_NAME = "Grbl Rotary Y2A (mm) (*.gcode)"
 
FILE_EXTENSION = "gcode"
 
UNITS = "MM"

DIRECT_OUTPUT = "VTransfer"

+------------------------------------------------
+ Rotary Wrapping Engine Setup Settings
+------------------------------------------------
ROTARY_WRAP_Y = A
INVERSE_TIME_MODE = "YES"
 
+------------------------------------------------
+    Line terminating characters                 
+------------------------------------------------
 
LINE_ENDING = "[13][10]"
 
+------------------------------------------------
+    Block numbering                             
+------------------------------------------------
 
LINE_NUMBER_START     = 0
LINE_NUMBER_INCREMENT = 10
LINE_NUMBER_MAXIMUM = 999999
 
+================================================
+                                                
+    Formatting for variables                     
+                                                
+================================================
 
VAR LINE_NUMBER = [N|A|N|1.0]
VAR POWER = [P|C|S|1.0|10.0]
VAR SPINDLE_SPEED = [S|A|S|1.0]
VAR FEED_RATE = [F|C|F|1.1]
VAR X_POSITION = [X|C|X|1.3]
VAR Y_POSITION = [Y|C|A|1.3]
VAR Z_POSITION = [Z|C|Z|1.3]
VAR X_HOME_POSITION = [XH|A|X|1.3]
VAR Y_HOME_POSITION = [YH|A|A|1.3]
VAR Z_HOME_POSITION = [ZH|A|Z|1.3]
 
+================================================
+                                                
+    Block definitions for toolpath output       
+                                                
+================================================
 
+---------------------------------------------------
+   Commands output at the start of the file
+---------------------------------------------------
 
begin HEADER
 
"T1"
"G17"
"G21"
"G90"
"G94"
"G0[ZH]"
"G0[XH][YH]"
 
+---------------------------------------------------
+   Command output after the header to switch spindle on
+---------------------------------------------------
 
begin SPINDLE_ON

"[S]M3"

+---------------------------------------------------
+   Commands output for rapid moves 
+---------------------------------------------------
 
begin RAPID_MOVE
 
"G0[X][Y][Z]"

+---------------------------------------------------
+   Commands output for the plunge move
+---------------------------------------------------

begin PLUNGE_MOVE

"G1[X][Y][Z][F]"

+---------------------------------------------------
+   Commands output for the first feed rate move
+---------------------------------------------------
 
begin FIRST_FEED_MOVE
 
"G1[X][Y][Z][P][F]"
 
+---------------------------------------------------
+   Commands output for feed rate moves
+---------------------------------------------------
 
begin FEED_MOVE
 
"G1[X][Y][Z][P]"
 
+---------------------------------------------------
+   Commands output when the jet is turned on
+---------------------------------------------------

begin JET_TOOL_ON

"M4[P]"

+---------------------------------------------------
+   Commands output when the jet is turned off
+---------------------------------------------------

begin JET_TOOL_OFF

"M5"

+---------------------------------------------------
+   Commands output when the jet power is changed
+---------------------------------------------------

begin JET_TOOL_POWER
"[P]"

+---------------------------------------------------
+   Commands output at the end of the file
+---------------------------------------------------
 
begin FOOTER

"M5"
"G0[ZH]"
"G0[XH][YH]"
"M2"