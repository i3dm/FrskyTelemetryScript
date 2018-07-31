--
-- An FRSKY S.Port <passthrough protocol> based Telemetry script for the Horus X10 and X12 radios
--
-- Copyright (C) 2018. Alessandro Apostoli
-- https://github.com/yaapu
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY, without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, see <http://www.gnu.org/licenses>.
--
-- Passthrough protocol reference:
--   https://cdn.rawgit.com/ArduPilot/ardupilot_wiki/33cd0c2c/images/FrSky_Passthrough_protocol.xlsx
--
-- Borrowed some code from the LI-xx BATTCHECK v3.30 script
--  http://frskytaranis.forumactif.org/t2800-lua-download-un-testeur-de-batterie-sur-la-radio

---------------------
-- script version 
---------------------
#define VERSION "Yaapu Telemetry Script 1.6.2_b1"

-- 480x272 LCD_WxLCD_H
#define WIDGET
--#define WIDGETDEBUG
--#define SPLASH
--#define MEMDEBUG
-- fix for issue OpenTX 2.2.1 on X10/X10S - https://github.com/opentx/opentx/issues/5764
#define X10_OPENTX_221
---------------------
-- features
---------------------
--#define HUD_ALGO1
#define HUD_ALGO2
#define HUD_BIG
--#define BATTPERC_BY_VOLTAGE
--#define COMPASS_ROSE
---------------------
-- dev features
---------------------
--#define LOGTELEMETRY
--#define DEBUG
--#define DEBUGEVT
--#define TESTMODE
--#define BATT2TEST
--#define FLVSS2TEST
#ifdef TESTMODE
#define CELLCOUNT 4
#endif
--#define DEMO
--#define DEV

-- calc and show background function rate
--#define BGRATE
-- calc and show run function rate
--#define FGRATE

-- calc and show hud refresh rate
-- default for beta
--#define HUDRATE

--#define HUDTIMER

-- calc and show telemetry process rate
-- default for beta
--#define BGTELERATE

-- calc and show actual incoming telemetry rate
--#define TELERATE

--

#define VFAS_ID 0x0210
#define VFAS_SUBID 0
#define VFAS_INSTANCE 2
#define VFAS_PRECISION 2
#define VFAS_NAME "VFAS"

#define CURR_ID 0x0200
#define CURR_SUBID 0
#define CURR_INSTANCE 3
#define CURR_PRECISION 1
#define CURR_NAME "CURR"

#define VSpd_ID 0x0110
#define VSpd_SUBID 0
#define VSpd_INSTANCE 1
#define VSpd_PRECISION 1
#define VSpd_NAME "VSpd"

#define GSpd_ID 0x0830
#define GSpd_SUBID 0
#define GSpd_INSTANCE 4
#define GSpd_PRECISION 0
#define GSpd_NAME "GSpd"

#define Alt_ID 0x0100
#define Alt_SUBID 0
#define Alt_INSTANCE 1
#define Alt_PRECISION 1
#define Alt_NAME "Alt"

#define GAlt_ID 0x0820
#define GAlt_SUBID 0
#define GAlt_INSTANCE 4
#define GAlt_PRECISION 0
#define GAlt_NAME "GAlt"

#define Hdg_ID 0x0840
#define Hdg_SUBID 0
#define Hdg_INSTANCE 4
#define Hdg_PRECISION 0
#define Hdg_NAME "Hdg"

#define Tmp1_ID 0x0400
#define Tmp1_SUBID 0
#define Tmp1_INSTANCE 0
#define Tmp1_PRECISION 0
#define Tmp1_NAME "Tmp1"

#define Tmp2_ID 0x0410
#define Tmp2_SUBID 0
#define Tmp2_INSTANCE 0
#define Tmp2_PRECISION 0
#define Tmp2_NAME "Tmp2"

#define Fuel_ID 0x0600
#define Fuel_SUBID 0
#define Fuel_INSTANCE 0
#define Fuel_PRECISION 0
#define Fuel_NAME "Fuel"

#define IMUTmp_ID 0x0400
#define IMUTmp_SUBID 0
#define IMUTmp_INSTANCE 10
#define IMUTmp_PRECISION 0
#define IMUTmp_NAME "IMUt"

#ifdef DEBUG
--[[
	MAV_TYPE_GENERIC=0,               /* Generic micro air vehicle. | */
	MAV_TYPE_FIXED_WING=1,            /* Fixed wing aircraft. | */
	MAV_TYPE_QUADROTOR=2,             /* Quadrotor | */
	MAV_TYPE_COAXIAL=3,               /* Coaxial helicopter | */
	MAV_TYPE_HELICOPTER=4,            /* Normal helicopter with tail rotor. | */
	MAV_TYPE_ANTENNA_TRACKER=5,       /* Ground installation | */
	MAV_TYPE_GCS=6,                   /* Operator control unit / ground control station | */
	MAV_TYPE_AIRSHIP=7,               /* Airship, controlled | */
	MAV_TYPE_FREE_BALLOON=8,          /* Free balloon, uncontrolled | */
	MAV_TYPE_ROCKET=9,                /* Rocket | */
	MAV_TYPE_GROUND_ROVER=10,         /* Ground rover | */
	MAV_TYPE_SURFACE_BOAT=11,         /* Surface vessel, boat, ship | */
	MAV_TYPE_SUBMARINE=12,            /* Submarine | */
  MAV_TYPE_HEXAROTOR=13,            /* Hexarotor | */
	MAV_TYPE_OCTOROTOR=14,            /* Octorotor | */
	MAV_TYPE_TRICOPTER=15,            /* Tricopter | */
	MAV_TYPE_FLAPPING_WING=16,        /* Flapping wing | */
	MAV_TYPE_KITE=17,                 /* Kite | */
	MAV_TYPE_ONBOARD_CONTROLLER=18,   /* Onboard companion controller | */
	MAV_TYPE_VTOL_DUOROTOR=19,        /* Two-rotor VTOL using control surfaces in vertical operation in addition. Tailsitter. | */
	MAV_TYPE_VTOL_QUADROTOR=20,       /* Quad-rotor VTOL using a V-shaped quad config in vertical operation. Tailsitter. | */
	MAV_TYPE_VTOL_TILTROTOR=21,       /* Tiltrotor VTOL | */
	MAV_TYPE_VTOL_RESERVED2=22,       /* VTOL reserved 2 | */
	MAV_TYPE_VTOL_RESERVED3=23,       /* VTOL reserved 3 | */
	MAV_TYPE_VTOL_RESERVED4=24,       /* VTOL reserved 4 | */
	MAV_TYPE_VTOL_RESERVED5=25,       /* VTOL reserved 5 | */
	MAV_TYPE_GIMBAL=26,               /* Onboard gimbal | */
	MAV_TYPE_ADSB=27,                 /* Onboard ADSB peripheral | */
	MAV_TYPE_PARAFOIL=28,             /* Steerable, nonrigid airfoil | */
	MAV_TYPE_DODECAROTOR=29,          /* Dodecarotor | */
]]--
#endif --DEBUG

local frameNames = {}
-- copter
frameNames[0]   = "GEN"
frameNames[2]   = "QUAD"
frameNames[3]   = "COAX"
frameNames[4]   = "HELI"
frameNames[13]  = "HEX"
frameNames[14]  = "OCTO"
frameNames[15]  = "TRI"
frameNames[29]  = "DODE"

-- plane
frameNames[1]   = "WING"
frameNames[16]  = "FLAP"
frameNames[19]  = "VTOL2"
frameNames[20]  = "VTOL4"
frameNames[21]  = "VTOLT"
frameNames[22]  = "VTOL"
frameNames[23]  = "VTOL"
frameNames[24]  = "VTOL"
frameNames[25]  = "VTOL"
frameNames[28]  = "FOIL"

-- rover
frameNames[10]  = "ROV"
-- boat
frameNames[11]  = "BOAT"

local frameTypes = {}
-- copter
frameTypes[0]   = "c"
frameTypes[2]   = "c"
frameTypes[3]   = "c"
frameTypes[4]   = "c"
frameTypes[13]  = "c"
frameTypes[14]  = "c"
frameTypes[15]  = "c"
frameTypes[29]  = "c"

-- plane
frameTypes[1]   = "p"
frameTypes[16]  = "p"
frameTypes[19]  = "p"
frameTypes[20]  = "p"
frameTypes[21]  = "p"
frameTypes[22]  = "p"
frameTypes[23]  = "p"
frameTypes[24]  = "p"
frameTypes[25]  = "p"
frameTypes[28]  = "p"

-- rover
frameTypes[10]  = "r"
-- boat
frameTypes[11]  = "b"

#ifdef TESTMODE
-- undefined
frameTypes[5] = ""
frameTypes[6] = ""
frameTypes[7] = ""
frameTypes[8] = ""
frameTypes[9] = ""
frameTypes[12] = ""
frameTypes[17] = ""
frameTypes[18] = ""
frameTypes[26] = ""
frameTypes[27] = ""
frameTypes[30] = ""
#endif --TESTMODE
--
local flightModes = {}
flightModes["c"] = {}
flightModes["p"] = {}
flightModes["r"] = {}
-- copter flight modes
flightModes["c"][1]="Stabilize"
flightModes["c"][2]="Acro"
flightModes["c"][3]="AltHold"
flightModes["c"][4]="Auto"
flightModes["c"][5]="Guided"
flightModes["c"][6]="Loiter"
flightModes["c"][7]="RTL"
flightModes["c"][8]="Circle"
flightModes["c"][10]="Land"
flightModes["c"][12]="Drift"
flightModes["c"][14]="Sport"
flightModes["c"][15]="Flip"
flightModes["c"][16]="AutoTune"
flightModes["c"][17]="PosHold"
flightModes["c"][18]="Brake"
flightModes["c"][19]="Throw"
flightModes["c"][20]="AvoidADSB"
flightModes["c"][21]="GuidedNOGPS"
flightModes["c"][22]="SmartRTL"
flightModes["c"][23]="FlowHold"
flightModes["c"][24]="Follow"
#ifdef TESTMODE
flightModes["c"][0]=""
flightModes["c"][9]=""
flightModes["c"][11]=""
flightModes["c"][13]=""
#endif --TESTMODE
-- plane flight modes
flightModes["p"][1]="Manual"
flightModes["p"][2]="Circle"
flightModes["p"][3]="Stabilize"
flightModes["p"][4]="Training"
flightModes["p"][5]="Acro"
flightModes["p"][6]="FlyByWireA"
flightModes["p"][7]="FlyByWireB"
flightModes["p"][8]="Cruise"
flightModes["p"][9]="Autotune"
flightModes["p"][11]="Auto"
flightModes["p"][12]="RTL"
flightModes["p"][13]="Loiter"
flightModes["p"][15]="AvoidADSB"
flightModes["p"][16]="Guided"
flightModes["p"][17]="Initializing"
flightModes["p"][18]="QStabilize"
flightModes["p"][19]="QHover"
flightModes["p"][20]="QLoiter"
flightModes["p"][21]="Qland"
flightModes["p"][22]="QRTL"
#ifdef TESTMODE
flightModes["p"][0]=""
flightModes["p"][10]=""
flightModes["p"][14]=""
#endif --TESTMODE
-- rover flight modes
flightModes["r"][1]="Manual"
flightModes["r"][2]="Acro"
flightModes["r"][4]="Steering"
flightModes["r"][5]="Hold"
flightModes["r"][11]="Auto"
flightModes["r"][12]="RTL"
flightModes["r"][13]="SmartRTL"
flightModes["r"][16]="Guided"
flightModes["r"][17]="Initializing"
#ifdef TESTMODE
flightModes["r"][0]=""
flightModes["r"][6]=""
flightModes["r"][7]=""
flightModes["r"][8]=""
flightModes["r"][9]=""
flightModes["r"][10]=""
flightModes["r"][14]=""
flightModes["r"][15]=""
flightModes["r"][18]=""
flightModes["r"][19]=""
flightModes["r"][20]=""
flightModes["r"][21]=""
flightModes["r"][22]=""
#endif --TESTMODE
--
local soundFileBasePath = "/SOUNDS/yaapu0"
local gpsStatuses = {}

gpsStatuses[0]="NoGPS"
gpsStatuses[1]="NoLock"
gpsStatuses[2]="2D"
gpsStatuses[3]="3D"
gpsStatuses[4]="DGPS"
gpsStatuses[5]="RTK"
gpsStatuses[6]="RTK"

--[[
0	MAV_SEVERITY_EMERGENCY	System is unusable. This is a "panic" condition.
1	MAV_SEVERITY_ALERT	Action should be taken immediately. Indicates error in non-critical systems.
2	MAV_SEVERITY_CRITICAL	Action must be taken immediately. Indicates failure in a primary system.
3	MAV_SEVERITY_ERROR	Indicates an error in secondary/redundant systems.
4	MAV_SEVERITY_WARNING	Indicates about a possible future error if this is not resolved within a given timeframe. Example would be a low battery warning.
5	MAV_SEVERITY_NOTICE	An unusual event has occured, though not an error condition. This should be investigated for the root cause.
6	MAV_SEVERITY_INFO	Normal operational messages. Useful for logging. No action is required for these messages.
7	MAV_SEVERITY_DEBUG	Useful non-operational messages that can assist in debugging. These should not occur during normal operation.
--]]

local mavSeverity = {}
mavSeverity[0]="EMR"
mavSeverity[1]="ALR"
mavSeverity[2]="CRT"
mavSeverity[3]="ERR"
mavSeverity[4]="WRN"
mavSeverity[5]="NOT"
mavSeverity[6]="INF"
mavSeverity[7]="DBG"

#define CELLFULL 4.35
#define CELLEMPTY 3.0
--------------------------------
-- FLVSS 1
local cell1min = 0
local cell1sum = 0
-- FLVSS 2
local cell2min = 0
local cell2sum = 0
-- FC 1
local cell1sumFC = 0
-- used to calculate cellcount
local cell1maxFC = 0
-- FC 2
local cell2sumFC = 0
-- A2
local cellsumA2 = 0
-- used to calculate cellcount
local cellmaxA2 = 0

--------------------------------
-- STATUS
local flightMode = 0
local simpleMode = 0
local landComplete = 0
local statusArmed = 0
local battFailsafe = 0
local ekfFailsafe = 0
local imuTemp = 0
-- GPS
local numSats = 0
local gpsStatus = 0
local gpsHdopC = 100
local gpsAlt = 0
-- BATT
local cellcount = 0
local battsource = "na"
-- BATT 1
local batt1volt = 0
local batt1current = 0
local batt1mah = 0
local batt1sources = {
  a2 = false,
  vs = false,
  fc = false
}
-- BATT 2
local batt2volt = 0
local batt2current = 0
local batt2mah = 0
local batt2sources = {
  a2 = false,
  vs = false,
  fc = false
}
-- TELEMETRY
local noTelemetryData = 1
-- HOME
local homeDist = 0
local homeAlt = 0
local homeAngle = -1
-- MESSAGES
local msgBuffer = ""
local lastMsgValue = 0
local lastMsgTime = 0
-- VELANDYAW
local vSpeed = 0
local hSpeed = 0
local yaw = 0
-- SYNTH VSPEED SUPPORT
local vspd = 0
local synthVSpeedTime = 0
local prevHomeAlt = 0
-- ROLLPITCH
local roll = 0
local pitch = 0
local range = 0
-- PARAMS
local paramId,paramValue
local frameType = -1
local batt1Capacity = 0
local batt2Capacity = 0
-- FLIGHT TIME
local lastTimerStart = 0
local timerRunning = 0
local flightTime = 0
-- EVENTS
local lastStatusArmed = 0
local lastGpsStatus = 0
local lastFlightMode = 0
local lastSimpleMode = 0
-- battery levels
local batLevel = 99
local battLevel1 = false
local battLevel2 = false
--
local lastBattLevel = 13
--
local batLevels = {0,5,10,15,20,25,30,40,50,60,70,80,90}
-- dual battery
local showDualBattery = false
-- messages
local lastMessage
local lastMessageSeverity = 0
local lastMessageCount = 1
local messageCount = 0
local messages = {}
--
local bitmaps = {}
local blinktime = getTime()
local blinkon = false
-- GPS
local function getTelemetryId(name)
  local field = getFieldInfo(name)
  return field and field.id or -1
end
--
local gpsDataId = getTelemetryId("GPS")
--
#define MIN_BATT1_FC 1
#define MIN_BATT2_FC 2
#define MIN_CELL1_VS 3
#define MIN_CELL2_VS 4
#define MIN_BATT1_VS 5
#define MIN_BATT2_VS 6
#define MIN_BATT_A2 7
--
#define MAX_CURR 8
#define MAX_CURR1 9
#define MAX_CURR2 10
#define MAX_POWER 11
#define MINMAX_ALT 12
#define MAX_GPSALT 13
#define MAX_VSPEED 14
#define MAX_HSPEED 15
#define MAX_DIST 16
#define MAX_RANGE 17
--
local minmaxValues = {}
-- min
minmaxValues[1] = 0
minmaxValues[2] = 0
minmaxValues[3] = 0
minmaxValues[4] = 0
minmaxValues[5] = 0
minmaxValues[6] = 0
minmaxValues[7] = 0
-- max
minmaxValues[8] = 0
minmaxValues[9] = 0
minmaxValues[10] = 0
minmaxValues[11] = 0
minmaxValues[12] = 0
minmaxValues[13] = 0
minmaxValues[14] = 0
minmaxValues[15] = 0
minmaxValues[16] = 0
minmaxValues[17] = 0

local showMinMaxValues = false
--
#ifdef BATTPERC_BY_VOLTAGE
#define VOLTAGE_DROP 0.15
local battPercByVoltage = {{3, 0}, {3.093, 1}, {3.196, 2}, {3.301, 3}, {3.401, 4}, {3.477, 5}, {3.544, 6}, {3.601, 7}, {3.637, 8}, {3.664, 9}, {3.679, 10}, {3.683, 11}, {3.689, 12}, {3.692, 13}, {3.705, 14}, {3.71, 15}, {3.713, 16}, {3.715, 17}, {3.72, 18}, {3.731, 19}, {3.735, 20}, {3.744, 21}, {3.753, 22}, {3.756, 23}, {3.758, 24}, {3.762, 25}, {3.767, 26}, {3.774, 27}, {3.78, 28}, {3.783, 29}, {3.786, 30}, {3.789, 31}, {3.794, 32}, {3.797, 33}, {3.8, 34}, {3.802, 35}, {3.805, 36}, {3.808, 37}, {3.811, 38}, {3.815, 39}, {3.818, 40}, {3.822, 41}, {3.825, 42}, {3.829, 43}, {3.833, 44}, {3.836, 45}, {3.84, 46}, {3.843, 47}, {3.847, 48}, {3.85, 49}, {3.854, 50}, {3.857, 51}, {3.86, 52}, {3.863, 53}, {3.866, 54}, {3.87, 55}, {3.874, 56}, {3.879, 57}, {3.888, 58}, {3.893, 59}, {3.897, 60}, {3.902, 61}, {3.906, 62}, {3.911, 63}, {3.918, 64}, {3.923, 65}, {3.928, 66}, {3.939, 67}, {3.943, 68}, {3.949, 69}, {3.955, 70}, {3.961, 71}, {3.968, 72}, {3.974, 73}, {3.981, 74}, {3.987, 75}, {3.994, 76}, {4.001, 77}, {4.007, 78}, {4.014, 79}, {4.021, 80}, {4.029, 81}, {4.036, 82}, {4.044, 83}, {4.052, 84}, {4.062, 85}, {4.074, 86}, {4.085, 87}, {4.095, 88}, {4.105, 89}, {4.111, 90}, {4.116, 91}, {4.12, 92}, {4.125, 93}, {4.129, 94}, {4.135, 95}, {4.145, 96}, {4.176, 97}, {4.179, 98}, {4.193, 99}, {4.2, 100}, {4.35, 100}}
#endif --BATTPERC_BY_VOLTAGE

#ifdef LOGTELEMETRY
local logfile
local logfilename
#endif --LOGTELEMETRY
--
#ifdef TESTMODE
-- TEST MODE
local thrOut = 0
#endif --TESTMODE

#ifdef HUD_BIG
#define HUD_WIDTH 92
#define HUD_X (LCD_W-92)/2
#define HUD_Y_MID 79
#else
#define HUD_WIDTH 70
#define HUD_X (LCD_W-70)/2
#define HUD_Y_MID 80
#endif

#define YAW_WIDTH 120
#define YAW_X (LCD_W-120)/2
#define YAW_Y 140

#define LEFTPANE_X 68
#define RIGHTPANE_X 68

#define TOPBAR_Y 0
#define TOPBAR_HEIGHT 20
#define TOPBAR_WIDTH LCD_W

#define BOTTOMBAR_Y LCD_H - 20
#define BOTTOMBAR_HEIGHT 20
#define BOTTOMBAR_WIDTH LCD_W

#define BOX1_X 0
#define BOX1_Y 38
#define BOX1_WIDTH 66  
#define BOX1_HEIGHT 8

#define BOX2_X 61
#define BOX2_Y 46
#define BOX2_WIDTH 17  
#define BOX2_HEIGHT 12

#define BATTCELL_X 33
#define BATTCELL_Y 13
#define BATTCELL_XV 171
#define BATTCELL_YV 23
#define BATTCELL_YS 60
#define BATTCELL_FLAGS XXLSIZE+PREC2

#define BATTVOLT_X 100
#define BATTVOLT_Y 164
#define BATTVOLT_XV 95
#define BATTVOLT_YV 159
#define BATTVOLT_FLAGS DBLSIZE+PREC1+RIGHT
#define BATTVOLT_FLAGSV SMLSIZE

#define BATTCURR_X 192
#define BATTCURR_Y 164
#define BATTCURR_XA 186
#define BATTCURR_YA 159
#define BATTCURR_FLAGS DBLSIZE+PREC1+RIGHT
#define BATTCURR_FLAGSA SMLSIZE

#define BATTPERC_X 90
#define BATTPERC_Y 108
#define BATTPERC_YPERC 120
#define BATTPERC_FLAGS MIDSIZE
#define BATTPERC_FLAGSPERC SMLSIZE

#define BATTGAUGE_X 29
#define BATTGAUGE_Y 109
#define BATTGAUGE_WIDTH 160
#define BATTGAUGE_HEIGHT 23
#define BATTGAUGE_STEPS 10

#define BATTMAH_X 185
#define BATTMAH_Y 136
#define BATTMAH_FLAGS MIDSIZE

#define BATTINFO_B1B2_X 67
#define BATTINFO_B1_X 75
#define BATTINFO_B2_X 50
#define BATTINFO_Y 85

#define FLIGHTMODE_X 2
#define FLIGHTMODE_Y 218
#define FLIGHTMODE_FLAGS MIDSIZE

#define HOMEANGLE_X 60
#define HOMEANGLE_Y 27
#define HOMEANGLE_XLABEL 3
#define HOMEANGLE_YLABEL 27
#define HOMEANGLE_FLAGS SMLSIZE

#define GPS_X 2
#define GPS_Y 22
#define GPS_BORDER 0

#define ALTASL_X 82
#define ALTASL_Y 112
#define ALTASL_XLABEL 10
#define ALTASL_YLABEL 95

#define HSPEED_X 84
#define HSPEED_Y 170
#define HSPEED_XLABEL 85
#define HSPEED_YLABEL 152
#define HSPEED_XDIM 61
#define HSPEED_YDIM 49
#define HSPEED_FLAGS MIDSIZE
#define HSPEED_ARROW_WIDTH 10

#define BATTPOWER_X 165
#define BATTPOWER_Y 152
#define BATTPOWER_YW 170
#define BATTPOWER_FLAGS SMLSIZE
#define BATTPOWER_FLAGSW MIDSIZE

#define HOMEDIST_X 165
#define HOMEDIST_Y 112
#define HOMEDIST_XLABEL 91
#define HOMEDIST_YLABEL 95
#define HOMEDIST_FLAGS MIDSIZE
#define HOMEDIST_ARROW_WIDTH 8

#define HOMEDIR_X (LCD_W/2)
#define HOMEDIR_Y 202
#define HOMEDIR_R 17

#define FLIGHTTIME_X 330
#define FLIGHTTIME_Y 202
#define FLIGHTTIME_FLAGS DBLSIZE

#define RSSI_X 265
#define RSSI_Y 0
#define RSSI_FLAGS 0 

#define TXVOLTAGE_X 330
#define TXVOLTAGE_Y 0
#define TXVOLTAGE_FLAGS 0

#define VSPEED_X 180
#define VSPEED_Y LCD_H-60
#define VSPEED_FLAGS MIDSIZE
#define VSPEED_XLABEL 170
#define VSPEED_YLABEL LCD_H-37
#define VSPEED_FLAGSLABEL SMLSIZE

#define ALT_X 265
#define ALT_Y LCD_H-60
#define ALT_FLAGS MIDSIZE
#define ALT_XLABEL 265
#define ALT_YLABEL LCD_H-37
#define ALT_FLAGSLABEL SMLSIZE
-- model and opentx version
local ver, radio, maj, minor, rev = getVersion()
-----------------------------
-- clears the loaded table 
-- and recovers memory
-----------------------------
local function clearTable(t)
  if type(t)=="table" then
    for i,v in pairs(t) do
      if type(v) == "table" then
        clearTable(v)
      end
      t[i] = nil
    end
  end
  collectgarbage()
  sharedVars.maxmem=0
end  
--------------------------------------------------------------------------------
-- CONFIGURATION MENU
--------------------------------------------------------------------------------
local conf = {
  language = "en",
  defaultBattSource = nil, -- auto
  battAlertLevel1 = 0,
  battAlertLevel2 = 0,
  battCapOverride1 = 0,
  battCapOverride2 = 0,
  disableAllSounds = false,
  disableMsgBeep = false,
  disableMsgBlink = false,
  timerAlert = 0,
  minAltitudeAlert = 0,
  maxAltitudeAlert = 0,
  maxDistanceAlert = 0,
  cellCount = 0,
  disableCurrentSensor = false,
  rangeMax=0,
  enableSynthVSpeed=false,
  horSpeedMultiplier=1
}
--------------------------------------------------------------------------------
-- MENU VALUE,COMBO
--------------------------------------------------------------------------------
#define TYPEVALUE 0
#define TYPECOMBO 1
#define MENU_Y 25
#define MENU_PAGESIZE 11
#define MENU_WRAPOFFSET 7
#define MENU_ITEM_X 300

#define L1 1
#define V1 2
#define V2 3
#define B1 4
#define B2 5
#define S1 6
#define S2 7
#define S3 8
#define VS 9
#define T1 10
#define A1 11
#define A2 12
#define D1 13
#define T2 14
#define CC 15
#define RM 16
#define SVS 17
#define HS 18
#define CS 19
  
local menu  = {
  selectedItem = 1,
  editSelected = false,
  offset = 0
}

#define SENSOR_LABEL 1
#define SENSOR_NAME 2
#define SENSOR_PREC 3
#define SENSOR_UNIT 4
#define SENSOR_TYPE 5
#define SENSOR_MULT 6

-- max 4 extra sensors
local customSensors = {
    -- {label,name,prec:0,1,2,unit,stype:I,E,1}
}

local menuItems = {
  -- label, type, alias, currval, min, max, label, flags, increment 
  {"voice language:", TYPECOMBO, "L1", 1, { "english", "italian", "french", "german" } , {"en","it","fr","de"} },
  {"batt alert level 1:", TYPEVALUE, "V1", 375, 320,420,"V", PREC2 ,5 },
  {"batt alert level 2:", TYPEVALUE, "V2", 350, 320,420,"V", PREC2 ,5 },
  {"batt[1] capacity override:", TYPEVALUE, "B1", 0, 0,5000,"Ah",PREC2 ,10 },
  {"batt[2] capacity override:", TYPEVALUE, "B2", 0, 0,5000,"Ah",PREC2 ,10 },
  {"disable all sounds:", TYPECOMBO, "S1", 1, { "no", "yes" }, { false, true } },
  {"disable msg beep:", TYPECOMBO, "S2", 1, { "no", "yes" }, { false, true } },
  {"disable msg blink:", TYPECOMBO, "S3", 1, { "no", "yes" }, { false, true } },
  {"default voltage source:", TYPECOMBO, "VS", 1, { "auto", "FLVSS", "A2", "fc" }, { nil, "vs", "a2", "fc" } },
  {"timer alert every:", TYPEVALUE, "T1", 0, 0,600,"min",PREC1,5 },
  {"min altitude alert:", TYPEVALUE, "A1", 0, 0,500,"m",PREC1,5 },
  {"max altitude alert:", TYPEVALUE, "A2", 0, 0,10000,"m",0,1 },
  {"max distance alert:", TYPEVALUE, "D1", 0, 0,100000,"m",0,10 },
  {"repeat alerts every:", TYPEVALUE, "T2", 10, 10,600,"sec",0,5 },
  {"cell count override:", TYPEVALUE, "CC", 0, 0,12,"cells",0,1 },
  {"rangefinder max:", TYPEVALUE, "RM", 0, 0,10000," cm",0,10 },
  {"enable synthetic vspeed:", TYPECOMBO, "SVS", 1, { "no", "yes" }, { false, true } },
  {"air/groundspeed unit:", TYPECOMBO, "HS", 1, { "m/s", "km/h" }, { 1, 3.6 } },
#ifdef BATTPERC_BY_VOLTAGE  
  {"current sensor unavailable:", TYPECOMBO, "CS", 1, { "no", "yes" }, { false, true } }
#endif --BATTPERC_BY_VOLTAGE
}

local function getConfigFilename()
  local info = model.getInfo()
  return "/SCRIPTS/YAAPU/CFG/" .. string.lower(string.gsub(info.name, "[%c%p%s%z]", "")..".cfg")
end

local function getBitmap(name)
  if bitmaps[name] == nil then
    bitmaps[name] = Bitmap.open("/SCRIPTS/YAAPU/IMAGES/"..name..".png")
  end
  return bitmaps[name]
end

local function drawBlinkBitmap(bitmap,x,y)
  if blinkon == true then
      lcd.drawBitmap(getBitmap(bitmap),x,y)
  end
end

local function applyConfigValues()
  conf.language = menuItems[L1][6][menuItems[L1][4]]
  conf.battAlertLevel1 = menuItems[V1][4]
  conf.battAlertLevel2 = menuItems[V2][4]
  conf.battCapOverride1 = menuItems[B1][4]*0.1
  conf.battCapOverride2 = menuItems[B2][4]*0.1
  conf.disableAllSounds = menuItems[S1][6][menuItems[S1][4]]
  conf.disableMsgBeep = menuItems[S2][6][menuItems[S2][4]]
  conf.disableMsgBlink = menuItems[S3][6][menuItems[S3][4]]  
  conf.defaultBattSource = menuItems[VS][6][menuItems[VS][4]]
  conf.timerAlert = math.floor(menuItems[T1][4]*0.1*60)
  conf.minAltitudeAlert = menuItems[A1][4]*0.1
  conf.maxAltitudeAlert = menuItems[A2][4]
  conf.maxDistanceAlert = menuItems[D1][4]
  conf.cellCount = menuItems[CC][4]
  conf.rangeMax = menuItems[RM][4]
  conf.enableSynthVSpeed = menuItems[SVS][6][menuItems[SVS][4]]
  conf.horSpeedMultiplier = menuItems[HS][6][menuItems[HS][4]]
  #ifdef BATTPERC_BY_VOLTAGE
  conf.disableCurrentSensor = menuItems[CS][6][menuItems[CS][4]]
  #endif --BATTPERC_BY_VOLTAGE
  --
  if conf.defaultBattSource ~= nil then
    battsource = conf.defaultBattSource
  end
end

local function loadConfig()
  local cfg = io.open(getConfigFilename(),"r")
  if cfg == nil then
    return
  end
  local str = io.read(cfg,200)
  if string.len(str) > 0 then
    for i=1,#menuItems
    do
		local value = string.match(str, menuItems[i][3]..":(%d+)")
		if value ~= nil then
		  menuItems[i][4] = tonumber(value)
		end
    end
  end
  if cfg 	~= nil then
    io.close(cfg)
  end
  applyConfigValues()
end

local function saveConfig()
  local cfg = assert(io.open(getConfigFilename(),"w"))
  if cfg == nil then
    return
  end
  for i=1,#menuItems
  do
    io.write(cfg,menuItems[i][3],":",menuItems[i][4])
    if i < #menuItems then
      io.write(cfg,",")
    end
  end
  if cfg 	~= nil then
    io.close(cfg)
  end
  applyConfigValues()
end

#ifndef WIDGET
local function drawConfigMenuBars()
  local itemIdx = string.format("%d/%d",menu.selectedItem,#menuItems)
  lcd.drawFilledRectangle(0,TOPBAR_Y, LCD_W, 20, TITLE_BGCOLOR)
  lcd.drawRectangle(0, TOPBAR_Y, LCD_W, 20, TITLE_BGCOLOR)
  lcd.drawText(2,0,VERSION,MENU_TITLE_COLOR)
  lcd.drawFilledRectangle(0,BOTTOMBAR_Y, LCD_W, 20, TITLE_BGCOLOR)
  lcd.drawRectangle(0, BOTTOMBAR_Y, LCD_W, 20, TITLE_BGCOLOR)
  lcd.drawText(2,BOTTOMBAR_Y+1,getConfigFilename(),MENU_TITLE_COLOR)
  lcd.drawText(BOTTOMBAR_WIDTH,BOTTOMBAR_Y+1,itemIdx,MENU_TITLE_COLOR+RIGHT)
end

local function incMenuItem(idx)
  if menuItems[idx][2] == TYPEVALUE then
    menuItems[idx][4] = menuItems[idx][4] + menuItems[idx][9]
    if menuItems[idx][4] > menuItems[idx][6] then
      menuItems[idx][4] = menuItems[idx][6]
    end
  else
    menuItems[idx][4] = menuItems[idx][4] + 1
    if menuItems[idx][4] > #menuItems[idx][5] then
      menuItems[idx][4] = 1
    end
  end
end

local function decMenuItem(idx)
  if menuItems[idx][2] == TYPEVALUE then
    menuItems[idx][4] = menuItems[idx][4] - menuItems[idx][9]
    if menuItems[idx][4] < menuItems[idx][5] then
      menuItems[idx][4] = menuItems[idx][5]
    end
  else
    menuItems[idx][4] = menuItems[idx][4] - 1
    if menuItems[idx][4] < 1 then
      menuItems[idx][4] = #menuItems[idx][5]
    end
  end
end

local function drawItem(idx,flags)
  if menuItems[idx][2] == TYPEVALUE then
    if menuItems[idx][4] == 0 then
      lcd.drawText(MENU_ITEM_X,MENU_Y + (idx-menu.offset-1)*20, "---",flags)
    else
      lcd.drawNumber(MENU_ITEM_X,MENU_Y + (idx-menu.offset-1)*20, menuItems[idx][4],flags+menuItems[idx][8])
      lcd.drawText(MENU_ITEM_X + 50,MENU_Y + (idx-menu.offset-1)*20, menuItems[idx][7],flags)
    end
  else
    lcd.drawText(MENU_ITEM_X,MENU_Y + (idx-menu.offset-1)*20, menuItems[idx][5][menuItems[idx][4]],flags)
  end
end

local function drawConfigMenu(event)
  drawConfigMenuBars()
  if event == EVT_ENTER_BREAK then
	menu.editSelected = not menu.editSelected
  elseif menu.editSelected and (event == EVT_PLUS_BREAK or event == EVT_ROT_LEFT or event == EVT_PLUS_REPT) then
    incMenuItem(menu.selectedItem)
  elseif menu.editSelected and (event == EVT_MINUS_BREAK or event == EVT_ROT_RIGHT or event == EVT_MINUS_REPT) then
    decMenuItem(menu.selectedItem)
  elseif not menu.editSelected and (event == EVT_PLUS_BREAK or event == EVT_ROT_LEFT) then
    menu.selectedItem = (menu.selectedItem - 1)
    if menu.offset >=  menu.selectedItem then
      menu.offset = menu.offset - 1
    end
  elseif not menu.editSelected and (event == EVT_MINUS_BREAK or event == EVT_ROT_RIGHT) then
    menu.selectedItem = (menu.selectedItem + 1)
    if menu.selectedItem - MENU_PAGESIZE > menu.offset then
      menu.offset = menu.offset + 1
    end
  end
  --wrap
  if menu.selectedItem > #menuItems then
    menu.selectedItem = 1 
    menu.offset = 0
  elseif menu.selectedItem  < 1 then
    menu.selectedItem = #menuItems
    menu.offset = MENU_WRAPOFFSET
  end
  --
  for m=1+menu.offset,math.min(#menuItems,MENU_PAGESIZE+menu.offset) do
    lcd.drawText(2,MENU_Y + (m-menu.offset-1)*20, menuItems[m][1],0+0)
    if m == menu.selectedItem then
      if menu.editSelected then
        drawItem(m,INVERS+BLINK)
      else
        drawItem(m,INVERS)
      end
    else
      drawItem(m,0)
    end
  end
end
#endif --WIDGET
--
local function playSound(soundFile)
  if conf.disableAllSounds then
    return
  end
  playFile(soundFileBasePath .."/"..conf.language.."/".. soundFile..".wav")
end

----------------------------------------------
-- sound file has same name as flightmode all lowercase with .wav extension
----------------------------------------------
local function playSoundByFrameTypeAndFlightMode(frameType,flightMode)
  if conf.disableAllSounds then
    return
  end
  if frameType ~= -1 then
    if flightModes[frameTypes[frameType]][flightMode] ~= nil then
      playFile(soundFileBasePath.."/"..conf.language.."/".. string.lower(flightModes[frameTypes[frameType]][flightMode])..".wav")
    end
  end
end

local function drawHArrow(x,y,width,left,right)
  lcd.drawLine(x, y, x + width,y, SOLID, 0)
  if left == true then
    lcd.drawLine(x + 1,y  - 1,x + 2,y  - 2, SOLID, 0)
    lcd.drawLine(x + 1,y  + 1,x + 2,y  + 2, SOLID, 0)
  end
  if right == true then
    lcd.drawLine(x + width - 1,y  - 1,x + width - 2,y  - 2, SOLID, 0)
    lcd.drawLine(x + width - 1,y  + 1,x + width - 2,y  + 2, SOLID, 0)
  end
end

local function drawVArrow(x,y,h,top,bottom)
  if top == true then
    drawBlinkBitmap("uparrow",x,y)
  else
    drawBlinkBitmap("downarrow",x,y)
  end
end

local function drawHomeIcon(x,y)
  lcd.drawBitmap(getBitmap("minihomeorange"),x,y)
end

#ifdef X10_OPENTX_221
local function drawLine(x1,y1,x2,y2,flags1,flags2)
    -- if lines are hor or ver do not fix
--if string.find(radio, "x10") and rev < 2 and x1 ~= x2 and y1 ~= y2 then
    if string.find(radio, "x10") and rev < 2 then
      lcd.drawLine(LCD_W-x1,LCD_H-y1,LCD_W-x2,LCD_H-y2,flags1,flags2)
    else
      lcd.drawLine(x1,y1,x2,y2,flags1,flags2)
    end
end
#endif --X10_OPENTX_221

local function drawCroppedLine(ox,oy,angle,len,style,minX,maxX,minY,maxY,color)
  --
  local xx = math.cos(math.rad(angle)) * len * 0.5
  local yy = math.sin(math.rad(angle)) * len * 0.5
  --
  local x1 = ox - xx
  local x2 = ox + xx
  local y1 = oy - yy
  local y2 = oy + yy
  --
  -- crop right
  if (x1 >= maxX and x2 >= maxX) then
    return
  end

  if (x1 >= maxX) then
    y1 = y1 - math.tan(math.rad(angle)) * (maxX - x1)
    x1 = maxX - 1
  end

  if (x2 >= maxX) then
    y2 = y2 + math.tan(math.rad(angle)) * (maxX - x2)
    x2 = maxX - 1
  end
  -- crop left
  if (x1 <= minX and x2 <= minX) then
    return
  end

  if (x1 <= minX) then
    y1 = y1 - math.tan(math.rad(angle)) * (x1 - minX)
    x1 = minX + 1
  end

  if (x2 <= minX) then
    y2 = y2 + math.tan(math.rad(angle)) * (x2 - minX)
    x2 = minX + 1
  end
  --
  -- crop right
  if (y1 >= maxY and y2 >= maxY) then
    return
  end

  if (y1 >= maxY) then
    x1 = x1 - (y1 - maxY)/math.tan(math.rad(angle))
    y1 = maxY - 1
  end

  if (y2 >= maxY) then
    x2 = x2 -  (y2 - maxY)/math.tan(math.rad(angle))
    y2 = maxY - 1
  end
  -- crop left
  if (y1 <= minY and y2 <= minY) then
    return
  end

  if (y1 <= minY) then
    x1 = x1 + (minY - y1)/math.tan(math.rad(angle))
    y1 = minY + 1
  end

  if (y2 <= minY) then
    x2 = x2 + (minY - y2)/math.tan(math.rad(angle))
    y2 = minY + 1
  end
#ifdef X10_OPENTX_221
  drawLine(x1,y1,x2,y2, style,color)
#else
  lcd.drawLine(x1,y1,x2,y2, style,color)
#endif
end

#ifdef DEV
local function draw8(x0,y0,x,y)
  lcd.drawPoint(x0 + x, y0 + y);
  lcd.drawPoint(x0 + y, y0 + x);
  lcd.drawPoint(x0 - y, y0 + x);
  lcd.drawPoint(x0 - x, y0 + y);
  lcd.drawPoint(x0 - x, y0 - y);
  lcd.drawPoint(x0 - y, y0 - x);
  lcd.drawPoint(x0 + y, y0 - x);
  lcd.drawPoint(x0 + x, y0 - y);
end

local function drawCircle10(x0,y0)
  draw8(x0,y0,5,1)
  draw8(x0,y0,5,2)
  draw8(x0,y0,4,3)
  draw8(x0,y0,4,4)
  lcd.drawPoint(x0 + 5,y0)
  lcd.drawPoint(x0 - 5,y0)
  lcd.drawPoint(x0,y0 + 5)
  lcd.drawPoint(x0,y0 - 5)
end

local function drawCircle(x0,y0,radius,delta)
  local x = radius-1
  local y = 0
  local dx = delta
  local dy = delta
  local err = dx - bit32.lshift(radius,1)
  while (x >= y) do
    lcd.drawPoint(x0 + x, y0 + y);
    lcd.drawPoint(x0 + y, y0 + x);
    lcd.drawPoint(x0 - y, y0 + x);
    lcd.drawPoint(x0 - x, y0 + y);
    lcd.drawPoint(x0 - x, y0 - y);
    lcd.drawPoint(x0 - y, y0 - x);
    lcd.drawPoint(x0 + y, y0 - x);
    lcd.drawPoint(x0 + x, y0 - y);
    if err <= 0 then
      y=y+1
      err = err + dy
      dy = dy + 2
    end
    if err > 0 then

      x=x-1
      dx = dx + 2
      err = err + dx - bit32.lshift(radius,1)
    end
  end
end

local function drawHomePad(x0,y0)
  drawCircle(x0 + 5,y0,5,2)
  lcd.drawText(x0 + 5 - 2,y0 - 3,"H")
end
#endif --DEV

local function drawNumberWithTwoDims(x,y,xDim,yTop,yBottom,number,topDim,bottomDim,flags,topFlags,bottomFlags)
  --PREC2 forces a math.floor() whereas a math.round() is required, math.round(f) = math.floor(f+0.5)
  lcd.drawNumber(x, y, number + 0.5, flags)
  local lx = xDim
  lcd.drawText(lx, yTop, topDim, topFlags)
  lcd.drawText(lx, yBottom, bottomDim, bottomFlags)
end

local function drawNumberWithDim(x,y,xDim,yDim,number,dim,flags,dimFlags)
  lcd.drawNumber(x, y, number,flags)
  lcd.drawText(xDim, yDim, dim, dimFlags)
end

#ifdef LOGTELEMETRY
local function getLogFilename(date)
  local info = model.getInfo()
  local modelName = string.lower(string.gsub(info.name, "[%c%p%s%z]", ""))
  return string.format("%s-%04d%02d%02d_%02d%02d%02d.plog",modelName,date.year,date.mon,date.day,date.hour,date.min,date.sec)
end
local function logTelemetryToFile(lc1,lc2,lc3,lc4)
  -- flight time
  local fmins = math.floor(flightTime / 60)
  local fsecs = flightTime % 60
  -- local date tiime from radio
  io.write(logfile,string.format("%d;%02d:%02d;%#01x;%#01x;%#02x;%#04x",getTime(),fmins,fsecs, lc1, lc2, lc3, lc4),"\r\n")
end
#endif --LOGTELEMETRY
--
#define MAX_MESSAGES 17
--
local function formatMessage(severity,msg)
  if lastMessageCount > 1 then
    return string.format("%02d:%s (x%d) %s", messageCount, mavSeverity[severity], lastMessageCount, msg)
  else
    return string.format("%02d:%s %s", messageCount, mavSeverity[severity], msg)
  end
end

local function pushMessage(severity, msg)
  if  conf.disableMsgBeep == false and conf.disableAllSounds == false then
    if ( severity < 5) then
      playSound("../err")
    else
      playSound("../inf")
    end
  end
  -- check if wrapping is needed
  if #messages == MAX_MESSAGES and msg ~= lastMessage then
    for i=1,MAX_MESSAGES-1 do
      messages[i]=messages[i+1]
    end
    -- trunc at 9
    messages[MAX_MESSAGES] = nil
  end
  -- is it a duplicate?
  if msg == lastMessage then
    lastMessageCount = lastMessageCount + 1
    messages[#messages] = formatMessage(severity,msg)
  else  
    lastMessageCount = 1
    messageCount = messageCount + 1
    messages[#messages+1] = formatMessage(severity,msg)
  end
  lastMessage = msg
  lastMessageSeverity = severity
#ifdef COLLECTGARBAGE  
  collectgarbage()
#endif
end

local function getSensorsConfigFilename()
  local info = model.getInfo()
  return "/SCRIPTS/YAAPU/CFG/" .. string.lower(string.gsub(info.name, "[%c%p%s%z]", "")..".sensors")
end

local function loadSensors()
  local cfg = io.open(getSensorsConfigFilename(),"r")
  if cfg == nil then
    return
  end
  local str = io.read(cfg,200)
  if string.len(str) > 0 then
    for i=1,4
    do
      local label, name, prec, unit, stype, mult = string.match(str, "S"..i..":(%w+),([A-Za-z0-9]+),(%d+),([A-Za-z0-9//%%]+),(%a+),(%d+)")
      if label ~= nil and name ~= nil and prec ~= nil and unit ~= nil and stype ~= nil then
        customSensors[i] = { label, name, prec, unit, stype, mult }
        pushMessage(7,"Custom sensor enabled: "..label)
      end
    end
  end
  --
  if cfg 	~= nil then
    io.close(cfg)
  end
end

local customSensorXY = {
  { HSPEED_XLABEL, ALTASL_YLABEL, ALTASL_X, ALTASL_Y},
  { HOMEDIST_X, HOMEDIST_YLABEL, HOMEDIST_X, HOMEDIST_Y},
  { HSPEED_XLABEL, HSPEED_YLABEL, HSPEED_X, HSPEED_Y},
  { BATTPOWER_X, BATTPOWER_Y, BATTPOWER_X, BATTPOWER_YW }
}

local function drawCustomSensors()
    local label,data,prec,mult
    for i=1,4
    do
      if customSensors[i] ~= nil then 
        label = string.format("%s(%s)",customSensors[i][SENSOR_LABEL],customSensors[i][SENSOR_UNIT])
        lcd.drawText(customSensorXY[i][1], customSensorXY[i][2],label, SMLSIZE+RIGHT)
        mult = tonumber(customSensors[i][SENSOR_PREC])
        mult =  mult == 0 and 1 or ( mult == 1 and 10 or 100 )
        prec =  mult == 1 and 0 or (mult == 10 and 32 or 48)
        lcd.drawNumber(customSensorXY[i][3], customSensorXY[i][4], getValue(customSensors[i][SENSOR_NAME])*mult*customSensors[i][SENSOR_MULT], MIDSIZE+RIGHT+prec)
      end
    end
end

--
local function startTimer()
  lastTimerStart = getTime()/100
  model.setTimer(2,{mode=1})
end

local function stopTimer()
  model.setTimer(2,{mode=0})
  lastTimerStart = 0
end

#ifdef TESTMODE
-----------------------------------------------------
-- TEST MODE
-----------------------------------------------------
local function symTimer()
  thrOut = getValue("thr")
  if (thrOut > 200 ) then
    landComplete = 1
  else
    landComplete = 0
  end
end

local function symGPS()
  thrOut = getValue("thr")
  if thrOut > 200 then
    numSats = 15
    gpsStatus = 4
    gpsHdopC = 6
    ekfFailsafe = 0
    battFailsafe = 0
    noTelemetryData = 0
    statusArmed = 1
  elseif thrOut < 200 and thrOut > 0  then
    numSats = 13
    gpsStatus = 5
    gpsHdopC = 1000
    ekfFailsafe = 1
    battFailsafe = 0
    noTelemetryData = 0
    statusArmed = 1
  elseif thrOut > -500  then
    numSats = 6
    gpsStatus = 1
    gpsHdopC = 120
    ekfFailsafe = 0
    battFailsafe = 1
    noTelemetryData = 0
    statusArmed = 0
  else
    numSats = 0
    gpsStatus = 0
    gpsHdopC = 100
    ekfFailsafe = 0
    battFailsafe = 0
    noTelemetryData = 1
    statusArmed = 0
  end
end

local function symFrameType()
  local ch11 = getValue("ch11")
  if ch11 < -300 then
    frameType = 2
  elseif ch11 < 300 then
    frameType = 1
  else
    frameType = 10
  end
end

local function symBatt()
  thrOut = getValue("thr")
  if (thrOut > -500 ) then
#ifdef DEMO
    if battFailsafe == 1 then
      minmaxValues[MIN_BATT1_FC] = CELLCOUNT * 3.40 * 10
      minmaxValues[MIN_BATT2_FC] = CELLCOUNT * 3.43 * 10
      minmaxValues[MAX_CURR] = 341 + 335
      minmaxValues[MAX_CURR1] = 341
      minmaxValues[MAX_CURR2] = 335
      minmaxValues[MAX_POWER] = (CELLCOUNT * 3.43)*(34.1 + 33.5)
      -- battery voltage
      batt1current = 235
      batt1volt = CELLCOUNT * 3.43 * 10
      batt1Capacity = 5200
      batt1mah = 4400
#ifdef BATT2TEST
      batt2current = 238
      batt2volt = CELLCOUNT  * 3.44 * 10
      batt2Capacity = 5200
      batt2mah = 4500
#endif --BATT2TEST
    else
      minmaxValues[MIN_BATT1_FC] = CELLCOUNT * 3.75 * 10
      minmaxValues[MIN_BATT2_FC] = CELLCOUNT * 3.77 * 10
      minmaxValues[MAX_CURR] = 341+335
      minmaxValues[MAX_CURR1] = 341
      minmaxValues[MAX_CURR2] = 335
      minmaxValues[MAX_POWER] = (CELLCOUNT * 3.89)*(34.1+33.5)
      -- battery voltage
      batt1current = 235
      batt1volt = CELLCOUNT * 3.87 * 10
      batt1Capacity = 5200
      batt1mah = 2800
#ifdef BATT2TEST
      batt2current = 238
      batt2volt = CELLCOUNT * 3.89 * 10
      batt2Capacity = 5200
      batt2mah = 2700
#endif --BATT2TEST
    end
#else --DEMO
    -- battery voltage
    batt1current = 100 +  ((thrOut)*0.01 * 30)
    batt1volt = CELLCOUNT * (32 + 10*math.abs(thrOut)*0.001)
    batt1Capacity = 5200
    batt1mah = math.abs(1000*(thrOut/200))
#ifdef BATT2TEST
    batt2current = 100 +  ((thrOut)*0.01 * 30)
    batt2volt = CELLCOUNT * (32 + 10*math.abs(thrOut)*0.001)
    batt2Capacity = 5200
    batt2mah = math.abs(1000*(thrOut/200))
#endif --BATT2TEST
#endif --DEMO
  -- flightmode
#ifdef DEMO
    flightMode = 1
    minmaxValues[MAX_GPSALT] = 270*0.1
    minmaxValues[MAX_DIST] = 130
    gpsAlt = 200
    homeDist = 95
#else --DEMO
    flightMode = math.floor(20 * math.abs(thrOut)*0.001)
    gpsAlt = math.floor(10 * math.abs(thrOut)*0.1)
    homeDist = math.floor(10 * math.abs(thrOut)*0.1)
#endif --DEMO
  else
    batt1mah = 0
  end
end

-- simulates attitude by using channel 1 for roll, channel 2 for pitch and channel 4 for yaw
local function symAttitude()
#ifdef DEMO
  roll = 14
  pitch = -0.8
  yaw = 33
#else --DEMO
  local rollCh = 0
  local pitchCh = 0
  local yawCh = 0
  -- roll [-1024,1024] ==> [-180,180]
  rollCh = getValue("ch1") * 0.5 -- 0.175
  -- pitch [1024,-1024] ==> [-90,90]
  pitchCh = getValue("ch2") * 0.0878 * 5
  -- yaw [-1024,1024] ==> [0,360]
  yawCh = getValue("ch10")
  if ( yawCh >= 0) then
    yawCh = yawCh * 0.175
  else
    yawCh = 360 + (yawCh * 0.175)
  end
  roll = rollCh/3
  pitch = pitchCh/2
  yaw = yawCh
#endif --DEMO
end

local function symHome()
  local yawCh = 0
  local S2Ch = 0
  -- home angle in deg [0-360]
  S2Ch = getValue("ch12")
  yawCh = getValue("ch4")
#ifdef DEMO
  minmaxValues[MINMAX_ALT] = 45
  minmaxValues[MAX_VSPEED] = 4
  minmaxValues[MAX_HSPEED] = 77
  homeAlt = 24
  vSpeed = 24
  hSpeed = 34
#else --DEMO
  homeAlt = yawCh * 0.1
  range = 10 * yawCh * 0.1
  vSpeed = yawCh * 0.1 * -1
  hSpeed = vSpeed
#endif --DEMO  
  if ( yawCh >= 0) then
    yawCh = yawCh * 0.175
  else
    yawCh = 360 + (yawCh * 0.175)
  end
  yaw = yawCh
  if ( S2Ch >= 0) then
    S2Ch = S2Ch * 0.175
  else
    S2Ch = 360 + (S2Ch * 0.175)
  end
  if (thrOut > 0 ) then
    homeAngle = S2Ch
  else
    homeAngle = -1
  end
end

local function symMode()
  symGPS()
  symAttitude()
  symTimer()
  symHome()
  symBatt()
  symFrameType()
end
#endif --TESTMODE

-----------------------------------------------------------------
-- TELEMETRY
-----------------------------------------------------------------
#ifdef TELERATE
local telecounter = 0
local telerate = 0
local telestart = 0
#endif --TELERATE
#ifdef LOGTELEMETRY
local lastAttiLogTime = 0
#endif --LOGTELEMETRY
--
local function processTelemetry()
  local SENSOR_ID,FRAME_ID,DATA_ID,VALUE = sportTelemetryPop()
  if ( FRAME_ID == 0x10) then
#ifdef LOGTELEMETRY
    -- log all pitch and roll at ma
    if lastAttiLogTime == 0 then
      logTelemetryToFile(SENSOR_ID,FRAME_ID,DATA_ID,VALUE)
      lastAttiLogTime = getTime()
    elseif DATA_ID == 0x5006 and getTime() - lastAttiLogTime > 100 then -- 1000ms
      logTelemetryToFile(SENSOR_ID,FRAME_ID,DATA_ID,VALUE)
      lastAttiLogTime = getTime()
    else
      logTelemetryToFile(SENSOR_ID,FRAME_ID,DATA_ID,VALUE)
    end
#endif --LOGTELEMETRY
#ifdef TELERATE
    ------------------------
    -- CALC ACTUAL TELE RATE
    ------------------------
    local now = getTime()/100
    if telecounter == 0 then
      telestart = now
    else
      telerate = telecounter / (now - telestart)
    end
    --
    telecounter=telecounter+1
#endif --TELERATE
    noTelemetryData = 0
    if ( DATA_ID == 0x5006) then -- ROLLPITCH
      -- roll [0,1800] ==> [-180,180]
      roll = (bit32.extract(VALUE,0,11) - 900) * 0.2
      -- pitch [0,900] ==> [-90,90]
      pitch = (bit32.extract(VALUE,11,10) - 450) * 0.2
      -- #define ATTIANDRNG_RNGFND_OFFSET    21
      -- number encoded on 11 bits: 10 bits for digits + 1 for 10^power
      range = bit32.extract(VALUE,22,10) * (10^bit32.extract(VALUE,21,1)) -- cm
    elseif ( DATA_ID == 0x5005) then -- VELANDYAW
      vSpeed = bit32.extract(VALUE,1,7) * (10^bit32.extract(VALUE,0,1))
      if (bit32.extract(VALUE,8,1) == 1) then
        vSpeed = -vSpeed
      end
      hSpeed = bit32.extract(VALUE,10,7) * (10^bit32.extract(VALUE,9,1))
      yaw = bit32.extract(VALUE,17,11) * 0.2
    elseif ( DATA_ID == 0x5001) then -- AP STATUS
      flightMode = bit32.extract(VALUE,0,5)
      simpleMode = bit32.extract(VALUE,5,2)
      landComplete = bit32.extract(VALUE,7,1)
      statusArmed = bit32.extract(VALUE,8,1)
      battFailsafe = bit32.extract(VALUE,9,1)
      ekfFailsafe = bit32.extract(VALUE,10,2)
      -- IMU temperature: offset -19, 0 means temp =< 19°, 63 means temp => 82°
      imuTemp = math.floor((100 * bit32.extract(VALUE,26,6)/64) + 0.5) - 19 -- C° Note. math.round = math.floor( n + 0.5)
    elseif ( DATA_ID == 0x5002) then -- GPS STATUS
      numSats = bit32.extract(VALUE,0,4)
      -- offset  4: NO_GPS = 0, NO_FIX = 1, GPS_OK_FIX_2D = 2, GPS_OK_FIX_3D or GPS_OK_FIX_3D_DGPS or GPS_OK_FIX_3D_RTK_FLOAT or GPS_OK_FIX_3D_RTK_FIXED = 3
      -- offset 14: 0: no advanced fix, 1: GPS_OK_FIX_3D_DGPS, 2: GPS_OK_FIX_3D_RTK_FLOAT, 3: GPS_OK_FIX_3D_RTK_FIXED
      gpsStatus = bit32.extract(VALUE,4,2) + bit32.extract(VALUE,14,2)
      gpsHdopC = bit32.extract(VALUE,7,7) * (10^bit32.extract(VALUE,6,1)) -- dm
      gpsAlt = bit32.extract(VALUE,24,7) * (10^bit32.extract(VALUE,22,2)) -- dm
      if (bit32.extract(VALUE,31,1) == 1) then
        gpsAlt = gpsAlt * -1
      end
    elseif ( DATA_ID == 0x5003) then -- BATT
      batt1volt = bit32.extract(VALUE,0,9)
      batt1current = bit32.extract(VALUE,10,7) * (10^bit32.extract(VALUE,9,1))
      batt1mah = bit32.extract(VALUE,17,15)
#ifdef BATT2TEST
      batt2volt = bit32.extract(VALUE,0,9)
      batt2current = bit32.extract(VALUE,10,7) * (10^bit32.extract(VALUE,9,1))
      batt2mah = bit32.extract(VALUE,17,15)
#endif --BATT2TEST
    elseif ( DATA_ID == 0x5008) then -- BATT2
      batt2volt = bit32.extract(VALUE,0,9)
      batt2current = bit32.extract(VALUE,10,7) * (10^bit32.extract(VALUE,9,1))
      batt2mah = bit32.extract(VALUE,17,15)
    elseif ( DATA_ID == 0x5004) then -- HOME
      homeDist = bit32.extract(VALUE,2,10) * (10^bit32.extract(VALUE,0,2))
      homeAlt = bit32.extract(VALUE,14,10) * (10^bit32.extract(VALUE,12,2)) * 0.1
      if (bit32.extract(VALUE,24,1) == 1) then
        homeAlt = homeAlt * -1
      end
      homeAngle = bit32.extract(VALUE, 25,  7) * 3
    elseif ( DATA_ID == 0x5000) then -- MESSAGES
      if (VALUE ~= lastMsgValue) then
        lastMsgValue = VALUE
        local c1 = bit32.extract(VALUE,0,7)
        local c2 = bit32.extract(VALUE,8,7)
        local c3 = bit32.extract(VALUE,16,7)
        local c4 = bit32.extract(VALUE,24,7)
        --
        local msgEnd = false
        --
        if (c4 ~= 0) then
          msgBuffer = msgBuffer .. string.char(c4)
        else
          msgEnd = true;
        end
        if (c3 ~= 0 and not msgEnd) then
          msgBuffer = msgBuffer .. string.char(c3)
        else
          msgEnd = true;
        end
        if (c2 ~= 0 and not msgEnd) then
          msgBuffer = msgBuffer .. string.char(c2)
        else
          msgEnd = true;
        end
        if (c1 ~= 0 and not msgEnd) then
          msgBuffer = msgBuffer .. string.char(c1)
        else
          msgEnd = true;
        end
        --_msg_chunk.chunk |= (_statustext_queue[0]->severity & 0x4)<<21;
        --_msg_chunk.chunk |= (_statustext_queue[0]->severity & 0x2)<<14;
        --_msg_chunk.chunk |= (_statustext_queue[0]->severity & 0x1)<<7;
        if (msgEnd) then
          local severity = (bit32.extract(VALUE,7,1) * 1) + (bit32.extract(VALUE,15,1) * 2) + (bit32.extract(VALUE,23,1) * 4)
          pushMessage( severity, msgBuffer)
          msgBuffer = ""
        end
      end
    elseif ( DATA_ID == 0x5007) then -- PARAMS
      paramId = bit32.extract(VALUE,24,4)
      paramValue = bit32.extract(VALUE,0,24)
      if paramId == 1 then
        frameType = paramValue
      elseif paramId == 4 then
        batt1Capacity = paramValue
#ifdef BATT2TEST
        batt2Capacity = paramValue
#endif --BATT2TEST
      elseif paramId == 5 then
        batt2Capacity = paramValue
      end
    end
  end
end

#ifdef TESTMODE
local function telemetryEnabled()
  return true
end
#else --TESTMODE
local function telemetryEnabled()
  if getRSSI() == 0 then
    noTelemetryData = 1
  end
  return noTelemetryData == 0
end
#endif --TESTMODE

local function getMaxValue(value,idx)
  minmaxValues[idx] = math.max(value,minmaxValues[idx])
  return showMinMaxValues == true and minmaxValues[idx] or value
end

local function calcMinValue(value,min)
  return min == 0 and value or math.min(value,min)
end

-- returns the actual minimun only if both are > 0
local function getNonZeroMin(v1,v2)
  return v1 == 0 and v2 or ( v2 == 0 and v1 or math.min(v1,v2))
end

#ifdef BATTPERC_BY_VOLTAGE
function getBattPercByCell(cellVoltage)
  result = 0
  if cellVoltage > CELLFULL or cellVoltage < CELLEMPTY then
    if  cellVoltage > CELLFULL then                                            
      result = 100
    end
    if  cellVoltage < CELLEMPTY then
      result = 0
    end
  else
    for i, v in ipairs( battPercByVoltage ) do                                  
      if v[ 1 ] >= cellVoltage then
        result =  v[ 2 ]
        break
      end
    end --for
  end --if
 return result
end
#endif --BATTPERC_BY_VOLTAGE


local function calcCellCount()
  -- cellcount override from menu
  if conf.cellCount ~= nil and conf.cellCount > 0 then
    return conf.cellCount
  end
  -- cellcount is cached only for FLVSS
  if batt1sources.vs == true and cellcount > 1 then
    return cellcount
  end
  -- round in excess and return
  -- Note: cellcount is not cached because max voltage can rise during initialization)
  return math.floor( (( math.max(cell1maxFC,cellmaxA2)*0.1 ) / CELLFULL) + 1)
end

local function calcBattery()
  ------------
  -- FLVSS 1
  ------------
  local cellResult = getValue("Cels")
  if type(cellResult) == "table" then
    cell1min = CELLFULL
    cell1sum = 0
    -- cellcount is global and shared
    cellcount = #cellResult
    for i, v in pairs(cellResult) do
      cell1sum = cell1sum + v
      if cell1min > v then
        cell1min = v
      end
    end
    -- if connected after scritp started
    if batt1sources.vs == false then
      battsource = "na"
    end
    if battsource == "na" then
      battsource = "vs"
    end
    batt1sources.vs = true
  else
    batt1sources.vs = false
    cell1min = 0
    cell1sum = 0
  end
  ------------
  -- FLVSS 2
  ------------
#ifdef FLVSS2TEST
  cellResult = getValue("Cels")
#else --FLVSS2TEST
  cellResult = getValue("Cel2")
#endif --FLVSS2TEST
  if type(cellResult) == "table" then
    cell2min = CELLFULL
    cell2sum = 0
    -- cellcount is global and shared
    cellcount = #cellResult
    for i, v in pairs(cellResult) do
      cell2sum = cell2sum + v
      if cell2min > v then
        cell2min = v
      end
    end
    -- if connected after scritp started
    if batt2sources.vs == false then
      battsource = "na"
    end
    if battsource == "na" then
      battsource = "vs"
    end
    batt2sources.vs = true
  else
    batt2sources.vs = false
    cell2min = 0
    cell2sum = 0
  end
  --------------------------------
  -- flight controller battery 1
  --------------------------------
  if batt1volt > 0 then
    cell1sumFC = batt1volt*0.1
    cell1maxFC = math.max(batt1volt,cell1maxFC)
    if battsource == "na" then
      battsource = "fc"
    end
    batt1sources.fc = true
  else
    batt1sources.fc = false
    cell1sumFC = 0
  end
  --------------------------------
  -- flight controller battery 2
  --------------------------------
  if batt2volt > 0 then
    cell2sumFC = batt2volt*0.1
    if battsource == "na" then
      battsource = "fc"
    end
    batt2sources.fc = true
  else
    batt2sources.fc = false
    cell2sumFC = 0
  end
  ----------------------------------
  -- A2 analog voltage only 1 supported
  ----------------------------------
  local battA2 = getValue("A2")
  --
  if battA2 > 0 then
    cellsumA2 = battA2
    cellmaxA2 = math.max(battA2*10,cellmaxA2)
    -- don't force a2, only way to display it
    -- is by user selection from menu
    --[[
    if battsource == "na" then
      battsource = "a2"
    end
    --]]
    batt1sources.a2 = true
  else
    batt1sources.a2 = false
    cellsumA2 = 0
  end
  -- batt fc
  minmaxValues[MIN_BATT1_FC] = calcMinValue(cell1sumFC,minmaxValues[MIN_BATT1_FC])
  minmaxValues[MIN_BATT2_FC] = calcMinValue(cell2sumFC,minmaxValues[MIN_BATT2_FC])
  -- cell flvss
  minmaxValues[MIN_CELL1_VS] = calcMinValue(cell1min,minmaxValues[MIN_CELL1_VS])
  minmaxValues[MIN_CELL2_VS] = calcMinValue(cell2min,minmaxValues[MIN_CELL2_VS])
  -- batt flvss
  minmaxValues[MIN_BATT1_VS] = calcMinValue(cell1sum,minmaxValues[MIN_BATT1_VS])
  minmaxValues[MIN_BATT2_VS] = calcMinValue(cell2sum,minmaxValues[MIN_BATT2_VS])
  -- batt A2
  minmaxValues[MIN_BATT_A2] = calcMinValue(cellsumA2,minmaxValues[MIN_BATT_A2])
end

local function checkLandingStatus()
  if ( timerRunning == 0 and landComplete == 1 and lastTimerStart == 0) then
    startTimer()
  end
  if (timerRunning == 1 and landComplete == 0 and lastTimerStart ~= 0) then
    stopTimer()
    playSound("landing")
  end
  timerRunning = landComplete
end

local function calcFlightTime()
  -- update local variable with timer 3 value
  flightTime = model.getTimer(2).value
end

local function getBatt1Capacity()
  return conf.battCapOverride1 > 0 and conf.battCapOverride1*100 or batt1Capacity
end

local function getBatt2Capacity()
  return conf.battCapOverride2 > 0 and conf.battCapOverride2*100 or batt2Capacity
end

-- gets the voltage based on source and min value, battId = [1|2]
local function getMinVoltageBySource(source,cell,cellFC,cellA2,battId,count)
  -- offset 0 for cell voltage, 2 for pack voltage
  local offset = 0
  --
  if cell > CELLFULL*2 or cellFC > CELLFULL*2 or cellA2 > CELLFULL*2 then
    offset = 2
  end
  --
  if source == "vs" then
    return showMinMaxValues == true and minmaxValues[2+offset+battId] or cell
  elseif source == "fc" then
      -- FC only tracks batt1 and batt2 no cell voltage tracking
      local minmax = (offset == 2 and minmaxValues[battId] or minmaxValues[battId]/count)
      return showMinMaxValues == true and minmax or cellFC
  elseif source == "a2" then
      -- A2 does not depend on battery id
      local minmax = (offset == 2 and minmaxValues[MIN_BATT_A2] or minmaxValues[MIN_BATT_A2]/count)
      return showMinMaxValues == true and minmax or cellA2
  end
  --
  return 0
end


#define ALARMS_MIN_ALT 1
#define ALARMS_MAX_ALT 2
#define ALARMS_MAX_DIST 3
#define ALARMS_EKF 4
#define ALARMS_BATT 5
#define ALARMS_TIMER 6
#define ALARMS_BATT2 7

#define ALARM_TYPE_MIN 0
#define ALARM_TYPE_MAX 1
#define ALARM_TYPE_TIMER 2
#define ALARM_TYPE_BATT 3
--[[
  min alarms need to be armed, i.e since values start at 0 in order to avoid
  immediate triggering upon start, the value must first reach the treshold
  only then will it trigger the alarm
]]--
local alarms = {
  --{ triggered, time, armed, type(0=min,1=max,2=timer,3=batt),  last_trigger}  
    { false, 0 , false, ALARM_TYPE_MIN, 0},
    { false, 0 , true, ALARM_TYPE_MAX, 0 },
    { false, 0 , true, ALARM_TYPE_MAX, 0 },
    { false, 0 , true, ALARM_TYPE_MAX, 0 },
    { false, 0 , true, ALARM_TYPE_MAX, 0 },
    { false, 0 , true, ALARM_TYPE_TIMER, 0 },
    { false, 0 , false, ALARM_TYPE_BATT, 0 }
}


local sensors = {
  {Fuel_ID, Fuel_SUBID, Fuel_INSTANCE,0, 13 , Fuel_PRECISION , Fuel_NAME },
  {VFAS_ID, VFAS_SUBID, VFAS_INSTANCE,0, 1 , VFAS_PRECISION , VFAS_NAME},
  {CURR_ID, CURR_SUBID, CURR_INSTANCE,0, 2 , CURR_PRECISION , CURR_NAME},
  {VSpd_ID, VSpd_SUBID, VSpd_INSTANCE,0, 5 , VSpd_PRECISION , VSpd_NAME},
  {GSpd_ID, GSpd_SUBID, GSpd_INSTANCE,0, 4 , GSpd_PRECISION , GSpd_NAME},
  {Alt_ID, Alt_SUBID, Alt_INSTANCE,0, 9 , Alt_PRECISION , Alt_NAME},
  {GAlt_ID, GAlt_SUBID, GAlt_INSTANCE,0, 9 , GAlt_PRECISION , GAlt_NAME},
  {Hdg_ID, Hdg_SUBID, Hdg_INSTANCE,0, 20 , Hdg_PRECISION , Hdg_NAME},
  {Tmp1_ID, Tmp1_SUBID, Tmp1_INSTANCE,0, 11 , Tmp1_PRECISION , Tmp1_NAME},
  {Tmp2_ID, Tmp2_SUBID, Tmp2_INSTANCE,0, 11 , Tmp2_PRECISION , Tmp2_NAME},
  {IMUTmp_ID, IMUTmp_SUBID, IMUTmp_INSTANCE,0, 11 , IMUTmp_PRECISION , IMUTmp_NAME}
}

local function setSensorValues()
  if (not telemetryEnabled()) then
    return
  end
  local battmah = batt1mah
  local battcapacity = getBatt1Capacity()
  if batt2mah > 0 then
    battcapacity =  getBatt1Capacity() + getBatt2Capacity()
    battmah = batt1mah + batt2mah
  end
  local perc = 0
  if (battcapacity > 0) then
    perc = (1 - (battmah/battcapacity))*100
    if perc > 99 then
      perc = 99
    end  
  end
  --
  sensors[1][4] = perc;
  sensors[2][4] = getNonZeroMin(batt1volt,batt2volt)*10;
  sensors[3][4] = batt1current+batt2current;
  sensors[4][4] = vSpeed;
  sensors[5][4] = hSpeed*0.1;
  sensors[6][4] = homeAlt*10;
  sensors[7][4] = math.floor(gpsAlt*0.1);
  sensors[8][4] = math.floor(yaw);
  sensors[9][4] = flightMode;
  sensors[10][4] = numSats*10+gpsStatus;
  sensors[11][4] = imuTemp;
  --
  for s=1,#sensors
  do
    local skip = false
    -- check if sensor
    for i=1,4
    do
      -- if a sensor created by the script has a user defined override then do not expose it to OpenTX
      if customSensors[i] ~= nil and customSensors[i][2] == sensors[s][7] and customSensors[i][5] == "E" then 
        -- sensor is external ==> disable the internal one
        skip = true
      end
    end
    if skip == false then
      setTelemetryValue(sensors[s][1], sensors[s][2], sensors[s][3], sensors[s][4], sensors[s][5] , sensors[s][6] , sensors[s][7])
    end
  end
end
--------------------
-- Single long function much more memory efficient than many little functions
---------------------
local function drawBatteryPane(x,battVolt,cellVolt,current,battmah,battcapacity)
  local perc = 0
  #ifdef BATTPERC_BY_VOLTAGE
  if conf.disableCurrentSensor == true then
    perc = getBattPercByCell((0.01*celm)+VOLTAGE_DROP)
  else
  #endif --BATTPERC_BY_VOLTAGE
  if (battcapacity > 0) then
    perc = (1 - (battmah/battcapacity))*100
    if perc > 99 then
      perc = 99
    end
  end
  #ifdef BATTPERC_BY_VOLTAGE
  end --conf.disableCurrentSensor
  #endif --BATTPERC_BY_VOLTAGE
  --  battery min cell
  local flags = 0
  --
  if showMinMaxValues == false then
    if battLevel2 == true then
      lcd.drawBitmap(getBitmap("cell_red"),x+BATTCELL_X - 4,BATTCELL_Y + 8)
      lcd.setColor(CUSTOM_COLOR,lcd.RGB(255, 255, 255)) -- white
      flags = CUSTOM_COLOR
    elseif abattLevel1 == true then
      lcd.drawBitmap(getBitmap("cell_orange"),x+BATTCELL_X - 4,BATTCELL_Y + 8)
      lcd.setColor(CUSTOM_COLOR,lcd.RGB(0, 0, 0)) -- black
      flags = CUSTOM_COLOR
    end
  end
  drawNumberWithTwoDims(x+BATTCELL_X, BATTCELL_Y,x+BATTCELL_XV, BATTCELL_YV, BATTCELL_YS,cellVolt,"V",battsource,BATTCELL_FLAGS+flags,flags,flags)
  -- battery voltage
  drawNumberWithDim(x+BATTVOLT_X,BATTVOLT_Y,x+BATTVOLT_XV, BATTVOLT_YV, battVolt,"V",BATTVOLT_FLAGS,BATTVOLT_FLAGSV)
  -- battery current
  drawNumberWithDim(x+BATTCURR_X,BATTCURR_Y,x+BATTCURR_XA,BATTCURR_YA,current,"A",BATTCURR_FLAGS,BATTCURR_FLAGSA)
  -- display capacity bar %
  if perc > 50 then
    lcd.setColor(CUSTOM_COLOR,lcd.RGB(0, 255, 0))
  elseif perc <= 50 and perc > 25 then
      lcd.setColor(CUSTOM_COLOR,lcd.RGB(255, 204, 0)) -- yellow
  else
    lcd.setColor(CUSTOM_COLOR,lcd.RGB(255,0, 0))
  end
  lcd.drawBitmap(getBitmap("gauge_bg"),x+BATTGAUGE_X-2,BATTGAUGE_Y-2)
  lcd.drawGauge(x+BATTGAUGE_X, BATTGAUGE_Y,BATTGAUGE_WIDTH,BATTGAUGE_HEIGHT,perc,100,CUSTOM_COLOR)
  -- battery percentage
  lcd.setColor(CUSTOM_COLOR,lcd.RGB(0, 0, 0)) -- black
  local strperc = string.format("%02d%%",perc)
  lcd.drawText(x+BATTPERC_X, BATTPERC_Y, strperc, BATTPERC_FLAGS+CUSTOM_COLOR)
  -- battery mah
  local strmah = string.format("%.02f/%.01f",battmah/1000,battcapacity/1000)
  lcd.drawText(x+BATTMAH_X, BATTMAH_Y+6, "Ah", RIGHT)
  lcd.drawText(x+BATTMAH_X - 22, BATTMAH_Y, strmah, BATTMAH_FLAGS+RIGHT)
  if showMinMaxValues == true then
    drawVArrow(x+BATTCELL_X+140, BATTCELL_Y + 27,6,false,true)
    drawVArrow(x+BATTVOLT_X-2,BATTVOLT_Y + 10, 5,false,true)
    drawVArrow(x+BATTCURR_X-5,BATTCURR_Y + 10,5,true,false)
  end
end

local function drawNoTelemetryData()
  -- no telemetry data
  if (not telemetryEnabled()) then
#ifdef SPLASH
    lcd.drawBitmap(getBitmap("notelemetry"),(LCD_W-404)/2,(LCD_H-164)/2 + 10) --404x164
    lcd.setColor(CUSTOM_COLOR,lcd.RGB(255,255,255))
    lcd.drawText(130, 208, VERSION, SMLSIZE+CUSTOM_COLOR)
#else --SPLASH
    lcd.drawFilledRectangle(75,90, 330, 100, TITLE_BGCOLOR)
    lcd.drawText(140, 120, "no telemetry data", MIDSIZE+INVERS)
    lcd.drawText(130, 160, VERSION, SMLSIZE+INVERS)
#endif -- SPLAH
  end
end

local function drawFlightMode()
  -- flight mode
  if frameTypes[frameType] ~= nil then
    local strMode = flightModes[frameTypes[frameType]][flightMode]
    if strMode ~= nil then
      if ( simpleMode > 0 ) then
        local strSimpleMode = simpleMode == 1 and "(S)" or "(SS)"
        strMode = string.format("%s%s",strMode,strSimpleMode)
      end
      lcd.drawText(FLIGHTMODE_X + 2, FLIGHTMODE_Y, strMode, FLIGHTMODE_FLAGS)
    end
  end
  lcd.drawLine(FLIGHTMODE_X + 2,FLIGHTMODE_Y, FLIGHTMODE_X + 150,FLIGHTMODE_Y, SOLID,0)
  lcd.drawText(FLIGHTMODE_X + 2,FLIGHTMODE_Y - 16,"Flight Mode",SMLSIZE)
end

local function drawTopBar()
  -- black bar
  lcd.drawFilledRectangle(0,0, LCD_W, 20, TITLE_BGCOLOR)
  -- frametype and model name
  local info = model.getInfo()
  local fn = frameNames[frameType]
  local strmodel = info.name
  if fn ~= nil then
    strmodel = fn..": "..info.name
  end
  lcd.drawText(2, RSSI_Y, strmodel, MENU_TITLE_COLOR)
#ifdef DEBUG  
  -- usage %
  local usage = getUsage()
  lcd.drawNumber(200, RSSI_Y, usage, MENU_TITLE_COLOR)
#endif --DEBUG  
  -- flight time
  local time = getDateTime()
  local strtime = string.format("%02d:%02d:%02d",time.hour,time.min,time.sec)
  lcd.drawText(LCD_W, RSSI_Y+4, strtime, SMLSIZE+RIGHT+MENU_TITLE_COLOR)
  -- RSSI
  lcd.drawText(RSSI_X, RSSI_Y, "RS:", RSSI_FLAGS+MENU_TITLE_COLOR)
#ifdef DEMO
  lcd.drawText(RSSI_X + 30,RSSI_Y, 87, RSSI_FLAGS+MENU_TITLE_COLOR)  
#else --DEMO
  lcd.drawText(RSSI_X + 30,RSSI_Y, getRSSI(), RSSI_FLAGS+MENU_TITLE_COLOR)  
#endif --DEMO
  -- tx voltage
  local vtx = string.format("Tx:%.1fv",getValue(getFieldInfo("tx-voltage").id))
  lcd.drawText(TXVOLTAGE_X,TXVOLTAGE_Y, vtx, TXVOLTAGE_FLAGS+MENU_TITLE_COLOR)
end

local function drawFlightTime()
  -- flight time
  lcd.drawText(FLIGHTTIME_X, FLIGHTTIME_Y, "Flight Time", SMLSIZE)
  lcd.drawLine(FLIGHTTIME_X,FLIGHTTIME_Y + 16, FLIGHTTIME_X + 140,FLIGHTTIME_Y + 16, SOLID,0)
  lcd.drawTimer(FLIGHTTIME_X, FLIGHTTIME_Y + 16, model.getTimer(2).value, FLIGHTTIME_FLAGS)
end

local function drawScreenTitle(title,page, pages)
  lcd.drawFilledRectangle(0, 0, LCD_W, 30, TITLE_BGCOLOR)
  lcd.drawText(1, 5, title, MENU_TITLE_COLOR)
  lcd.drawText(LCD_W-40, 5, page.."/"..pages, MENU_TITLE_COLOR)
end

local function drawBottomBar()
  -- black bar
  lcd.drawFilledRectangle(0,BOTTOMBAR_Y, LCD_W, 20, TITLE_BGCOLOR)
  -- message text
  local now = getTime()
  local msg = messages[#messages]
  if (now - lastMsgTime ) > 150 or conf.disableMsgBlink then
    lcd.drawText(2, BOTTOMBAR_Y + 1, msg,MENU_TITLE_COLOR)
  else
    lcd.drawText(2, BOTTOMBAR_Y + 1, msg,INVERS+BLINK+MENU_TITLE_COLOR)
  end
end

local function drawAllMessages()
  for i=1,#messages do
    lcd.drawText(1,16*(i-1), messages[i],SMLSIZE)
  end
end

local function drawGPSStatus()
  -- gps status
  local strStatus = gpsStatuses[gpsStatus]
  local flags = BLINK
  local mult = 1
  local gpsData = nil
  local hdop = gpsHdopC
  if gpsStatus  > 2 then
    if homeAngle ~= -1 then
      flags = PREC1
    end
    if hdop > 999 then
      hdop = 999
      flags = 0
      mult=0.1
    elseif hdop > 99 then
      flags = 0
      mult=0.1
    end
    lcd.drawText(GPS_X -1,GPS_Y - 3, strStatus, SMLSIZE)
    lcd.drawText(GPS_X -1,GPS_Y + 16 - 3, "fix", 0)
    if numSats == 15 then
      lcd.drawNumber(GPS_X + 80, GPS_Y + 4 , numSats, DBLSIZE+RIGHT)
      lcd.drawText(GPS_X + 89, GPS_Y + 19, "+", RIGHT)
    else
      lcd.drawNumber(GPS_X + 87, GPS_Y + 4 , numSats, DBLSIZE+RIGHT)
    end
    --
    lcd.drawText(GPS_X + 94, GPS_Y-3, "hd", SMLSIZE)
    lcd.drawNumber(GPS_X + 166, GPS_Y + 4, hdop*mult , DBLSIZE+flags+RIGHT)
    --
    lcd.drawLine(GPS_X + 91,GPS_Y ,GPS_X+91,GPS_Y + 36,SOLID,0)
    --
    gpsData = getValue("GPS")
    --
    if type(gpsData) == "table" and gpsData.lat ~= nil and gpsData.lon ~= nil then
      lcd.drawText(2 ,GPS_Y + 38,math.floor(gpsData.lat * 100000) / 100000,SMLSIZE)
      lcd.drawText(165 ,GPS_Y + 38,math.floor(gpsData.lon * 100000) / 100000,SMLSIZE+RIGHT)
    end
    lcd.drawLine(GPS_X ,GPS_Y + 37,GPS_X+160,GPS_Y + 37,SOLID,0)
    lcd.drawLine(GPS_X ,GPS_Y + 54,GPS_X+160,GPS_Y + 54,SOLID,0)
  elseif gpsStatus == 0 then
    drawBlinkBitmap("nogpsicon",4,24)
  else
    drawBlinkBitmap("nolockicon",4,24)
  end  
end

local function drawLeftPane(battcurrent,cellsumFC)
  if conf.rangeMax > 0 then
    flags = 0
    local rng = range
    if rng > conf.rangeMax then
      flags = BLINK+INVERS
    end
    rng = getMaxValue(rng,MAX_RANGE)
    if showMinMaxValues == true then
      flags = 0
    end
    lcd.drawText(ALTASL_XLABEL, ALTASL_YLABEL, "Range(m)", SMLSIZE)
    lcd.drawText(ALTASL_X, ALTASL_Y, string.format("%.1f",rng*0.01), MIDSIZE+flags+RIGHT)
  else
    flags = BLINK
    -- always display gps altitude even without 3d lock
    local alt = gpsAlt/10
    if gpsStatus  > 2 then
      flags = 0
      -- update max only with 3d or better lock
      alt = getMaxValue(alt,MAX_GPSALT)
    end
    if showMinMaxValues == true then
      flags = 0
    end
    lcd.drawText(ALTASL_XLABEL, ALTASL_YLABEL, "AltAsl(m)", SMLSIZE)
    local stralt = string.format("%d",alt)
    lcd.drawText(ALTASL_X, ALTASL_Y, stralt, MIDSIZE+flags+RIGHT)
  end
  -- home distance
  drawHomeIcon(HOMEDIST_XLABEL,HOMEDIST_YLABEL,7)
  lcd.drawText(HOMEDIST_X, HOMEDIST_YLABEL, "Dist(m)", SMLSIZE+RIGHT)
  flags = 0
  if homeAngle == -1 then
    flags = BLINK
  end
  local dist = getMaxValue(homeDist,MAX_DIST)
  if showMinMaxValues == true then
    flags = 0
  end
  local strdist = string.format("%d",dist)
  lcd.drawText(HOMEDIST_X, HOMEDIST_Y, strdist, HOMEDIST_FLAGS+flags+RIGHT)
  -- hspeed
  local speed = getMaxValue(hSpeed,MAX_HSPEED)
  lcd.drawText(HSPEED_XLABEL, HSPEED_YLABEL, "Spd("..menuItems[HS][5][menuItems[HS][4]]..")", SMLSIZE+RIGHT)
  lcd.drawNumber(HSPEED_X,HSPEED_Y,speed * conf.horSpeedMultiplier,HSPEED_FLAGS+RIGHT+PREC1)
  -- power
  local power = cellsumFC*battcurrent*0.1
  power = getMaxValue(power,MAX_POWER)
  lcd.drawText(BATTPOWER_X, BATTPOWER_Y, "Power(W)", BATTPOWER_FLAGS+RIGHT)
  lcd.drawNumber(BATTPOWER_X,BATTPOWER_YW,power,BATTPOWER_FLAGSW+RIGHT)
  if showMinMaxValues == true then
    drawVArrow(ALTASL_X-81, ALTASL_Y,6,true,false)
    drawVArrow(HOMEDIST_X-78, HOMEDIST_Y ,6,true,false)
    drawVArrow(HSPEED_XDIM-60,HSPEED_Y,6,true,false)
    drawVArrow(BATTPOWER_X-78, BATTPOWER_YW, 5,true,false)
  end
end

local function drawFailsafe()
  if ekfFailsafe > 0 then
    drawBlinkBitmap("ekffailsafe",LCD_W/2 - 90,180)
  end
  if battFailsafe > 0 then
    drawBlinkBitmap("battfailsafe",LCD_W/2 - 90,180)
  end
end

local function drawArmStatus()
  -- armstatus
  if ekfFailsafe == 0 and battFailsafe == 0 and timerRunning == 0 then
    if (statusArmed == 1) then
      lcd.drawBitmap(getBitmap("armed"),LCD_W/2 - 90,180)
    else
      drawBlinkBitmap("disarmed",LCD_W/2 - 90,180)
    end
  end
end

-- vertical distance between roll horiz segments
#define R2 10

#define YAWICON_Y 3
#define YAWTEXT_Y 16
#define YAW_STEPWIDTH 28

local yawRibbonPoints = {}
--
yawRibbonPoints[0]={"N",2}
yawRibbonPoints[1]={"NE",-5}
yawRibbonPoints[2]={"E",2}
yawRibbonPoints[3]={"SE",-5}
yawRibbonPoints[4]={"S",2}
yawRibbonPoints[5]={"SW",-5}
yawRibbonPoints[6]={"W",2}
yawRibbonPoints[7]={"NW",-5}

-- optimized yaw ribbon drawing
local function drawCompassRibbon()
  -- ribbon centered +/- 90 on yaw
  local centerYaw = (yaw+270)%360
  -- this is the first point left to be drawn on the compass ribbon
  local nextPoint = math.floor(centerYaw/45) * 45
  -- distance in degrees between leftmost ribbon point and first 45° multiple normalized to YAW_WIDTH/8
  local yawMinX = (LCD_W - YAW_WIDTH)/2
  local yawMaxX = (LCD_W + YAW_WIDTH)/2
  -- x coord of first ribbon letter
  local nextPointX = yawMinX + (nextPoint - centerYaw)/45 * YAW_STEPWIDTH
  local yawY = YAW_Y
  --
  local i = (nextPoint / 45) % 8
  for idx=1,6
  do
      if nextPointX >= yawMinX - 3 and nextPointX < yawMaxX then
        lcd.drawText(nextPointX+yawRibbonPoints[i][2],yawY,yawRibbonPoints[i][1],SMLSIZE)
      end
      i = (i + 1) % 8
      nextPointX = nextPointX + YAW_STEPWIDTH
  end
  -- home icon
  local leftYaw = (yaw + 180)%360
  local rightYaw = yaw%360
  local centerHome = (homeAngle+270)%360
  --
  local homeIconX = yawMinX
  local homeIconY = yawY + 25
  if rightYaw >= leftYaw then
    if centerHome > leftYaw and centerHome < rightYaw then
      drawHomeIcon(yawMinX + ((centerHome - leftYaw)/180)*YAW_WIDTH - 5,homeIconY)
    end
  else
    if centerHome < rightYaw then
      drawHomeIcon(yawMinX + (((360-leftYaw) + centerHome)/180)*YAW_WIDTH - 5,homeIconY)
    elseif centerHome >= leftYaw then
      drawHomeIcon(yawMinX + ((centerHome-leftYaw)/180)*YAW_WIDTH - 5,homeIconY)
    end
  end
  -- when abs(home angle) > 90 draw home icon close to left/right border
  local angle = homeAngle - yaw
  local cos = math.cos(math.rad(angle - 90))    
  local sin = math.sin(math.rad(angle - 90))    
  if cos > 0 and sin > 0 then
    drawHomeIcon(yawMaxX - 5, homeIconY)
  elseif cos < 0 and sin > 0 then
    drawHomeIcon(yawMinX - 5, homeIconY)
  end
  --
  lcd.drawLine(yawMinX, yawY + YAWTEXT_Y, yawMaxX, yawY + YAWTEXT_Y, SOLID, 0)
  local xx = 0
  if ( yaw < 10) then
    xx = 0
  elseif (yaw < 100) then
    xx = -8
  else
    xx = -14
  end
  lcd.drawNumber(LCD_W/2 + xx - 6, yawY, yaw, MIDSIZE+INVERS)
end


#ifdef COMPASS_ROSE
#define COMPASS_CHARSIZE 10
#define COMPASS_RADIUS 30
#define COMPASS_LINE 5

local compassPoints = {}

compassPoints[0] = "N"
compassPoints[1] = nil
compassPoints[2] = "E"
compassPoints[3] = nil
compassPoints[4] = "S"
compassPoints[5] = nil
compassPoints[6] = "W"
compassPoints[7] = nil

local function drawCompassRose()
  local hw = math.floor(YAW_WIDTH/2)
  local yawRounded = roundTo(yaw,1)
  local homeRounded = roundTo(homeAngle,1)
  local minY = TOPBAR_Y + TOPBAR_HEIGHT - 1
  local Hdy = math.sin(math.rad(270+homeRounded-yawRounded))*COMPASS_RADIUS
  local Hdx = math.cos(math.rad(270+homeRounded-yawRounded))*COMPASS_RADIUS
  for ang=0,7
  do
    local Rdy = math.sin(math.rad(45*ang+270-yawRounded))*COMPASS_RADIUS
    local Rdx = math.cos(math.rad(45*ang+270-yawRounded))*COMPASS_RADIUS
    local Ldy = math.sin(math.rad(45*ang+270-yawRounded))*(COMPASS_RADIUS-COMPASS_LINE)
    local Ldx = math.cos(math.rad(45*ang+270-yawRounded))*(COMPASS_RADIUS-COMPASS_LINE)
    if compassPoints[ang] == nil then
      lcd.drawLine(HOMEDIR_X+Ldx,HOMEDIR_Y+Ldy,HOMEDIR_X+Rdx,HOMEDIR_Y+Rdy,SOLID,2)
    else
      lcd.drawText(HOMEDIR_X+Rdx-(COMPASS_CHARSIZE/2),HOMEDIR_Y+Rdy-(COMPASS_CHARSIZE/2),compassPoints[ang],0)
    end
  end
  drawHomeIcon(HOMEDIR_X+Hdx-(COMPASS_CHARSIZE/2),HOMEDIR_Y+Hdy-(COMPASS_CHARSIZE/2))
  --
  local xx = 0
  if ( yaw < 10) then
    xx = 1
  elseif (yaw < 100) then
    xx = -8
  else
    xx = -12
  end
  lcd.drawNumber(HOMEDIR_X + xx - 5, HOMEDIR_Y - COMPASS_RADIUS - 24, yaw, INVERS)
end
#endif

#define LEFTWIDTH   38
#define RIGHTWIDTH  38

#ifdef HUDTIMER
local hudDrawTime = 0
local hudDrawCounter = 0
#endif

local function fillTriangle(ox, oy, x1, x2, roll, angle,color)
  local step = 2
  --
  local y1 = (oy - ox*angle) + x1*angle
  local y2 = (oy - ox*angle) + x2*angle
  --
  local steps = math.abs(y2-y1) / step
  --
  if (0 < roll and roll <= 90) then
    for s=0,steps
    do
      yy = y1 + s*step
      xx = (yy - (oy - ox*angle))/angle
      lcd.drawRectangle(x1,yy,xx - x1,step,color)
    end
  elseif (90 < roll and roll <= 180) then
    for s=0,steps
    do
      yy = y2 + s*step
      xx = (yy - (oy - ox*angle))/angle
      lcd.drawRectangle(x1,yy,xx - x1,step,color)
    end
  elseif (-90 < roll and roll < 0) then
    for s=0,steps
    do
      yy = y2 + s*step
      xx = (yy - (oy - ox*angle))/angle
      lcd.drawRectangle(xx,yy,x2-xx+1,step,color)
    end
  elseif (-180 < roll and roll <= -90) then
    for s=0,steps
    do
      yy = y1 + s*step
      xx = (yy - (oy - ox*angle))/angle
      lcd.drawRectangle(xx,yy,x2-xx+1,step,color)
    end
  end
end

-------------------------------------------
#define VARIO_X 172
#define VARIO_Y 19

local function drawHud(myWidget)
#ifdef HUDTIMER
  local hudStart = getTime()
#endif

  local r = -roll
  local cx,cy,dx,dy,ccx,ccy,cccx,cccy
  local yPos = TOPBAR_Y + TOPBAR_HEIGHT + 8
  -----------------------
  -- artificial horizon
  -----------------------
  -- no roll ==> segments are vertical, offsets are multiples of R2
  if ( roll == 0) then
    dx=0
    dy=pitch
    cx=0
    cy=R2
    ccx=0
    ccy=2*R2
    cccx=0
    cccy=3*R2
  else
    -- center line offsets
    dx = math.cos(math.rad(90 - r)) * -pitch
    dy = math.sin(math.rad(90 - r)) * pitch
    -- 1st line offsets
    cx = math.cos(math.rad(90 - r)) * R2
    cy = math.sin(math.rad(90 - r)) * R2
    -- 2nd line offsets
    ccx = math.cos(math.rad(90 - r)) * 2 * R2
    ccy = math.sin(math.rad(90 - r)) * 2 * R2
    -- 3rd line offsets
    cccx = math.cos(math.rad(90 - r)) * 3 * R2
    cccy = math.sin(math.rad(90 - r)) * 3 * R2
  end
  local rollX = math.floor(HUD_X + HUD_WIDTH/2)
  -----------------------
  -- dark color for "ground"
  -----------------------
#ifdef HUD_BIG
  -- 90x70
  local minY = 44
  local maxY = 114
#else
  -- 70x70
  local minY = 43
  local maxY = 113
#endif --HUD_BIG
  local minX = HUD_X + 1
  local maxX = HUD_X + HUD_WIDTH
  --
  local ox = HUD_X + HUD_WIDTH/2 + dx
  --
  local oy = HUD_Y_MID + dy
  local yy = 0
  
  --lcd.setColor(CUSTOM_COLOR,lcd.RGB(179, 204, 255))
#ifdef HUD_BIG
  lcd.setColor(CUSTOM_COLOR,lcd.RGB(0x7a, 0x9c, 0xff))
#else
  lcd.setColor(CUSTOM_COLOR,lcd.RGB(51, 102, 255))
#endif
  
  lcd.drawFilledRectangle(minX,minY,HUD_WIDTH,maxY - minY,CUSTOM_COLOR)
  -- angle of the line passing on point(ox,oy)
  local angle = math.tan(math.rad(-roll))
  -- for each pixel of the hud base/top draw vertical black 
  -- lines from hud border to horizon line
  -- horizon line moves with pitch/roll
  --lcd.setColor(CUSTOM_COLOR,lcd.RGB(77, 153, 0))
  lcd.setColor(CUSTOM_COLOR,lcd.RGB(102, 51, 0))
  --
  #ifdef HUD_ALGO1
  local step = 2
  local steps = (maxX - minX)/step
  local xx = 0
  local xxR = 0
  for s=0,steps
  do
    xx = minX + s*step
    xxR = xx + step
    if roll > 90 or roll < -90 then
      yy = (oy - ox*angle) + math.floor(xx*angle)
      if yy > minY + 1 and yy < maxY then
        lcd.drawFilledRectangle(xx,minY,step,yy-minY,CUSTOM_COLOR)
      elseif yy >= maxY then
        lcd.drawFilledRectangle(xx,minY,step,maxY-minY,CUSTOM_COLOR)
      end
    else
      yy = (oy - ox*angle) + math.floor(xx*angle)
      if yy <= minY then
        lcd.drawFilledRectangle(xx,minY,step,maxY-minY,CUSTOM_COLOR)
      elseif yy < maxY then
        lcd.drawFilledRectangle(xx,yy,step,maxY-yy,CUSTOM_COLOR)
      end
    end
  end
  #endif --HUD_ALGO1
  #ifdef HUD_ALGO2
  --
  local minxY = (oy - ox * angle) + minX * angle;
  local maxxY = (oy - ox * angle) + maxX * angle;
  local maxyX = (maxY - (oy - ox * angle)) / angle;
  local minyX = (minY - (oy - ox * angle)) / angle;
  --        
  if ( 0 <= -roll and -roll <= 90 ) then
      if (minxY > minY and maxxY < maxY) then
        -- 5
        lcd.drawFilledRectangle(minX, maxxY, maxX - minX, maxY - maxxY,CUSTOM_COLOR)
        fillTriangle(ox, oy, math.max(minX, minyX), math.min(maxX, maxyX), -roll, angle, CUSTOM_COLOR)
      elseif (minxY < minY and maxxY < maxY and maxxY > minY) then
        -- 6
        lcd.drawFilledRectangle(minX, minY, minyX - minX, maxxY - minY,CUSTOM_COLOR);
        lcd.drawFilledRectangle(minX, maxxY, maxX - minX, maxY - maxxY,CUSTOM_COLOR);
        fillTriangle(ox, oy, math.max(minX, minyX), math.min(maxX, maxyX), -roll, angle, CUSTOM_COLOR)
      elseif (minxY < minY and maxxY > maxY) then
        -- 7
        lcd.drawFilledRectangle(minX, minY, minyX - minX, maxY - minY,CUSTOM_COLOR);
        fillTriangle(ox, oy, math.max(minX, minyX), math.min(maxX, maxyX), -roll, angle, CUSTOM_COLOR)
      elseif (minxY < maxY and minxY > minY) then
        -- 8
        fillTriangle(ox, oy, math.max(minX, minyX), math.min(maxX, maxyX), -roll, angle, CUSTOM_COLOR)
      elseif (minxY < minY and maxxY < minY) then
        -- off screen
        lcd.drawFilledRectangle(minX, minY, maxX - minX, maxY - minY,CUSTOM_COLOR);
      end
  elseif (90 < -roll and -roll <= 180) then
      if (minxY < maxY and maxxY > minY) then
        -- 9
        lcd.drawFilledRectangle(minX, minY, maxX - minX, maxxY - minY,CUSTOM_COLOR);
        fillTriangle(ox, oy, math.max(minX, maxyX), math.min(maxX, minyX), -roll, angle,CUSTOM_COLOR);
      elseif (minxY > maxY and maxxY > minY and maxxY < maxY) then
        -- 10
        lcd.drawFilledRectangle(minX, minY, maxX - minX, maxxY - minY,CUSTOM_COLOR);
        lcd.drawFilledRectangle(minX, maxxY, maxyX - minX, maxY - maxxY,CUSTOM_COLOR);
        fillTriangle(ox, oy, math.max(minX, maxyX), math.min(maxX, minyX), -roll, angle,CUSTOM_COLOR);
      elseif (minxY > maxY and maxyX < maxX) then
        -- 11
        lcd.drawFilledRectangle(minX, minY, maxyX - minX, maxY - minY,CUSTOM_COLOR);
        fillTriangle(ox, oy, math.max(minX, maxyX), math.min(maxX, minyX), -roll, angle,CUSTOM_COLOR);
      elseif (minxY < maxY and minxY > minY) then
        -- 12
        fillTriangle(ox, oy, math.max(minX, maxyX), math.min(maxX, minyX), -roll, angle,CUSTOM_COLOR);
      elseif (minxY > maxY and maxxY > maxY) then
        -- off screen
        lcd.drawFilledRectangle(minX, minY, maxX - minX, maxY - minY,CUSTOM_COLOR);
      end
      -- 9,10,11,12
  elseif (-90 < -roll and -roll < 0) then
      if (minxY < maxY and maxxY > minY) then
        -- 1
        lcd.drawFilledRectangle(minX, minxY, maxX - minX, maxY - minxY,CUSTOM_COLOR);
        fillTriangle(ox, oy, math.max(minX, maxyX), math.min(maxX, minyX), -roll, angle,CUSTOM_COLOR);
      elseif (minxY < maxY and maxxY < minY and minxY > minY) then
        -- 2
        lcd.drawFilledRectangle(minX, minxY, maxX - minX, maxY - minxY,CUSTOM_COLOR);
        lcd.drawFilledRectangle(minyX, minY, maxX - minyX, minxY - minY,CUSTOM_COLOR);
        fillTriangle(ox, oy, math.max(minX, maxyX), math.min(maxX, minyX), -roll, angle,CUSTOM_COLOR);
      elseif (minxY > maxY and maxxY < minY) then
        -- 3
        lcd.drawFilledRectangle(minyX, minY, maxX - minyX, maxY - minY,CUSTOM_COLOR);
        fillTriangle(ox, oy, math.max(minX, maxyX), math.min(maxX, minyX), -roll, angle,CUSTOM_COLOR);
      elseif (minxY > minY and maxxY < maxY) then
        -- 4
        fillTriangle(ox, oy, math.max(minX, maxyX), math.min(maxX, minyX), -roll, angle,CUSTOM_COLOR);
      elseif (minxY < minY and maxxY < minY) then
        -- off screen
        lcd.drawFilledRectangle(minX, minY, maxX - minX, maxY - minY,CUSTOM_COLOR);
      end
  elseif (-180 <= -roll and -roll <= -90) then
      if (minxY > minY and maxxY < maxY) then
        -- 13
        lcd.drawFilledRectangle(minX, minY, maxX - minX, minxY - minY,CUSTOM_COLOR);
        fillTriangle(ox, oy, math.max(minX, minyX), math.min(maxX, maxyX), -roll, angle,CUSTOM_COLOR);
      elseif (maxxY > maxY and minxY > minY and minxY < maxY) then
        -- 14
        lcd.drawFilledRectangle(minX, minY, maxX - minX, minxY - minY,CUSTOM_COLOR);
        lcd.drawFilledRectangle(maxyX, minxY, maxX - maxyX, maxY - minxY,CUSTOM_COLOR);
        fillTriangle(ox, oy, math.max(minX, minyX), math.min(maxX, maxyX), -roll, angle,CUSTOM_COLOR);
      elseif (minxY < minY and maxyX < maxX) then
        -- 15
        lcd.drawFilledRectangle(maxyX, minY, maxX - maxyX, maxY - minY,CUSTOM_COLOR);
        fillTriangle(ox, oy, math.max(minX, minyX), math.min(maxX, maxyX), -roll, angle,CUSTOM_COLOR);
      elseif (minxY < minY and maxxY > minY) then
        -- 16
        fillTriangle(ox, oy, math.max(minX, minyX), math.min(maxX, maxyX), -roll, angle,CUSTOM_COLOR);
      elseif (minxY > maxY and maxxY > minY) then
        -- off screen
        lcd.drawFilledRectangle(minX, minY, maxX - minX, maxY - minY,CUSTOM_COLOR);
      end
  end
  #endif --HUD_ALGO2
  -- parallel lines above and below horizon
  lcd.setColor(CUSTOM_COLOR,lcd.RGB(255, 255, 255))
  --
  drawCroppedLine(rollX + dx - cccx,dy + HUD_Y_MID + cccy,r,40,DOTTED,HUD_X,HUD_X + HUD_WIDTH,minY,maxY,CUSTOM_COLOR)
  drawCroppedLine(rollX + dx - ccx,dy + HUD_Y_MID + ccy,r,20,DOTTED,HUD_X,HUD_X + HUD_WIDTH,minY,maxY,CUSTOM_COLOR)
  drawCroppedLine(rollX + dx - cx,dy + HUD_Y_MID + cy,r,40,DOTTED,HUD_X,HUD_X + HUD_WIDTH,minY,maxY,CUSTOM_COLOR)
  drawCroppedLine(rollX + dx + cx,dy + HUD_Y_MID - cy,r,40,DOTTED,HUD_X,HUD_X + HUD_WIDTH,minY,maxY,CUSTOM_COLOR)
  drawCroppedLine(rollX + dx + ccx,dy + HUD_Y_MID - ccy,r,20,DOTTED,HUD_X,HUD_X + HUD_WIDTH,minY,maxY,CUSTOM_COLOR)
  drawCroppedLine(rollX + dx + cccx,dy + HUD_Y_MID - cccy,r,40,DOTTED,HUD_X,HUD_X + HUD_WIDTH,minY,maxY,CUSTOM_COLOR)
  -------------------------------------
  -- hud bitmap
  -------------------------------------
#ifdef HUD_BIG
  lcd.drawBitmap(getBitmap("hud_90x70a"),(LCD_W-106)/2,34) --106x90
#else
  lcd.drawBitmap(getBitmap("hud_70x70d"),(LCD_W-86)/2,32) --86x92
#endif --HUD_BIG
  ------------------------------------
  -- synthetic vSpeed based on 
  -- home altitude when EKF is disabled
  -- updated at 1Hz (i.e every 1000ms)
  -------------------------------------
  if conf.enableSynthVSpeed == true then
    if (synthVSpeedTime == 0) then
      -- first time do nothing
      synthVSpeedTime = getTime()
      prevHomeAlt = homeAlt -- dm
    elseif (getTime() - synthVSpeedTime > 100) then
      -- calc vspeed
      vspd = 1000*(homeAlt-prevHomeAlt)/(getTime()-synthVSpeedTime) -- m/s
      -- update counters
      synthVSpeedTime = getTime()
      prevHomeAlt = homeAlt -- m
    end
  else
    vspd = vSpeed
  end

  -------------------------------------
  -- vario bitmap
  -------------------------------------
  local varioMax = math.log(5)
  local varioSpeed = math.log(1 + math.min(math.abs(0.05*vspd),4))
  local varioH = 0
#ifdef HUD_BIG
  if vspd > 0 then
    varioY = math.min(79 - varioSpeed/varioMax*55,125)
  else
    varioY = 78
  end
  lcd.setColor(CUSTOM_COLOR,lcd.RGB(255, 0xce, 0))
  lcd.drawFilledRectangle(VARIO_X+2, varioY, 7, varioSpeed/varioMax*55, CUSTOM_COLOR, 0)  
  lcd.drawBitmap(getBitmap("variogauge_big"),VARIO_X,VARIO_Y)
  if vSpeed > 0 then
    lcd.drawBitmap(getBitmap("varioline"),VARIO_X-3,varioY)
  else
    lcd.drawBitmap(getBitmap("varioline"),VARIO_X-3,77 + varioSpeed/varioMax*55)
  end
#else
  if vspd > 0 then
    varioY = math.min(79 - varioSpeed/varioMax*44,125)
  else
    varioY = 78
  end
  lcd.setColor(CUSTOM_COLOR,lcd.RGB(255, 0xce, 0))
  lcd.drawFilledRectangle(VARIO_X+2, varioY, 8, varioSpeed/varioMax*44, CUSTOM_COLOR, 0)  
  lcd.drawBitmap(getBitmap("variogauge"),VARIO_X + 2,VARIO_Y + 5)
  if vspd > 0 then
    lcd.drawBitmap(getBitmap("varioline"),VARIO_X-1,varioY)
  else
    lcd.drawBitmap(getBitmap("varioline"),VARIO_X-1,78 + varioSpeed/varioMax*44)
  end
#endif --HUD_BIG
  -------------------------------------
  -- left and right indicators on HUD
  -------------------------------------
  lcd.setColor(CUSTOM_COLOR,lcd.RGB(255, 255, 255))
  -- altitude
  local alt = getMaxValue(homeAlt,MINMAX_ALT)
  --
  lcd.drawText(ALT_XLABEL,ALT_YLABEL,"alt(m)",ALT_FLAGSLABEL)
  if alt > 0 then
    if alt < 10 then -- 2 digits with decimal
      lcd.drawNumber(ALT_X,ALT_Y,alt * 10,ALT_FLAGS+PREC1)
    else -- 3 digits
      lcd.drawNumber(ALT_X,ALT_Y,alt,ALT_FLAGS)
    end
  else
    if alt > -10 then -- 1 digit with sign
      lcd.drawNumber(ALT_X,ALT_Y,alt * 10,ALT_FLAGS+PREC1)
    else -- 3 digits with sign
      lcd.drawNumber(ALT_X,ALT_Y,alt,ALT_FLAGS)
    end
  end
  -- vertical speed
  lcd.drawText(VSPEED_XLABEL,VSPEED_YLABEL,"vspd(m/s)",VSPEED_FLAGSLABEL)
  if (vspd > 999) then
    lcd.drawNumber(VSPEED_X,VSPEED_Y,vspd*0.1,VSPEED_FLAGS+PREC1)
  elseif (vspd < -99) then
    lcd.drawNumber(VSPEED_X,VSPEED_Y,vspd * 0.1,VSPEED_FLAGS+PREC1)
  else
    lcd.drawNumber(VSPEED_X,VSPEED_Y,vspd,VSPEED_FLAGS+PREC1)
  end
#ifdef HUDTIMER
  hudDrawTime = hudDrawTime + (getTime() - hudStart)
  hudDrawCounter = hudDrawCounter + 1
#endif
  -- min/max arrows
  if showMinMaxValues == true then
    drawVArrow(ALT_X - 13, ALT_Y + 2,6,true,false)
  end
end

local function drawHomeDirection()
  local angle = math.floor(homeAngle - yaw)
  local x1 = HOMEDIR_X + HOMEDIR_R * math.cos(math.rad(angle - 90))
  local y1 = HOMEDIR_Y + HOMEDIR_R * math.sin(math.rad(angle - 90))
  local x2 = HOMEDIR_X + HOMEDIR_R * math.cos(math.rad(angle - 90 + 150))
  local y2 = HOMEDIR_Y + HOMEDIR_R * math.sin(math.rad(angle - 90 + 150))
  local x3 = HOMEDIR_X + HOMEDIR_R * math.cos(math.rad(angle - 90 - 150))
  local y3 = HOMEDIR_Y + HOMEDIR_R * math.sin(math.rad(angle - 90 - 150))
  local x4 = HOMEDIR_X + HOMEDIR_R * 0.5 * math.cos(math.rad(angle - 270))
  local y4 = HOMEDIR_Y + HOMEDIR_R * 0.5 *math.sin(math.rad(angle - 270))
  --
#ifdef X10_OPENTX_221
  drawLine(x1,y1,x2,y2,SOLID,1)
  drawLine(x1,y1,x3,y3,SOLID,1)
  drawLine(x2,y2,x4,y4,SOLID,1)
  drawLine(x3,y3,x4,y4,SOLID,1)
#else
  lcd.drawLine(x1,y1,x2,y2,SOLID,1)
  lcd.drawLine(x1,y1,x3,y3,SOLID,1)
  lcd.drawLine(x2,y2,x4,y4,SOLID,1)
  lcd.drawLine(x3,y3,x4,y4,SOLID,1)
#endif
end

---------------------------------
-- This function checks alarm condition and as long as the condition persists it plays
-- a warning sound.
---------------------------------
local function checkAlarm(level,value,idx,sign,sound,delay)
  -- once landed reset all alarms except battery alerts
  if timerRunning == 0 then
    if alarms[idx][4] == ALARM_TYPE_MIN then
      alarms[idx] = { false, 0, false, ALARM_TYPE_MIN, 0} 
    elseif alarms[idx][4] == ALARM_TYPE_MAX then
      alarms[idx] = { false, 0, true, ALARM_TYPE_MAX, 0}
    elseif  alarms[idx][4] == ALARM_TYPE_TIMER then
      alarms[idx] = { false, 0, true, ALARM_TYPE_TIMER, 0}
    elseif  alarms[idx][4] == ALARM_TYPE_BATT then
      alarms[idx] = { false, 0 , false, ALARM_TYPE_BATT, 0}
    end
  end
  -- for minimum type alarms, arm the alarm only after value has reached level  
  if alarms[idx][3] == false and timerRunning == 1 and level > 0 and -1 * sign*value > -1 * sign*level then
    alarms[idx][3] = true
  end
  -- for timer alarms trigger when flighttime is a multiple of delay
  if alarms[idx][3] == true and timerRunning == 1 and alarms[idx][4] == ALARM_TYPE_TIMER then
    if flightTime > 0 and math.floor(flightTime) %  delay == 0 then
      if alarms[idx][1] == false then 
        alarms[idx][1] = true
        playSound(sound)
         -- flightime is a multiple of 1 minute
        if (flightTime % 60 == 0 ) then
          -- minutes
          playNumber(flightTime / 60,25) -- 25=minutes,26=seconds
        else
          -- minutes
          if (flightTime > 60) then playNumber(flightTime / 60,25) end
          -- seconds
          playNumber(flightTime % 60,26)
        end
      end
    else
        alarms[idx][1] = false
    end
  elseif alarms[idx][3] == true and timerRunning == 1 and level > 0 and sign*value > sign*level then
    -- if alarm is armed and value is "outside" level fire once but only every 5 secs max
    if alarms[idx][2] == 0 then
      alarms[idx][1] = true
      alarms[idx][2] = flightTime
      if (flightTime - alarms[idx][5]) > 5 then
        playSound(sound)
        alarms[idx][5] = flightTime
      end
    end
    -- ...and then fire every conf secs after the first shot
    if math.floor(flightTime - alarms[idx][2]) %  delay == 0 then
      if alarms[idx][1] == false then 
        alarms[idx][1] = true
        playSound(sound)
      end
    else
        alarms[idx][1] = false
    end
  elseif alarms[idx][3] == true then
    alarms[idx][2] = 0
  end
end

local function checkEvents()
  -- silence alarms when showing min/max values
  if showMinMaxValues == false then
    -- vocal fence alarms
    checkAlarm(conf.minAltitudeAlert,homeAlt,ALARMS_MIN_ALT,-1,"minalt",menuItems[T2][4])
    checkAlarm(conf.maxAltitudeAlert,homeAlt,ALARMS_MAX_ALT,1,"maxalt",menuItems[T2][4])  
    checkAlarm(conf.maxDistanceAlert,homeDist,ALARMS_MAX_DIST,1,"maxdist",menuItems[T2][4])  
    checkAlarm(1,2*ekfFailsafe,ALARMS_EKF,1,"ekf",menuItems[T2][4])  
    checkAlarm(1,2*battFailsafe,ALARMS_BATT,1,"lowbat",menuItems[T2][4])  
    checkAlarm(conf.timerAlert,flightTime,ALARMS_TIMER,1,"timealert",conf.timerAlert)
  end
  -- default is use battery 1
  local capacity = getBatt1Capacity()
  local mah = batt1mah
  -- only if dual battery has been detected use battery 2
  if batt2sources.fc or batt2sources.vs then
      capacity = capacity + getBatt2Capacity()
      mah = mah  + batt2mah
  end
  --
  if (capacity > 0) then
    batLevel = (1 - (mah/capacity))*100
  else
    batLevel = 99
  end

  for l=1,13 do
    -- trigger alarm as as soon as it falls below level + 1 (i.e 91%,81%,71%,...)
    if batLevel <= batLevels[l] + 1 and l < lastBattLevel then
      lastBattLevel = l
      playSound("bat"..batLevels[l])
      break
    end
  end
  
  if statusArmed == 1 and lastStatusArmed == 0 then
    lastStatusArmed = statusArmed
    playSound("armed")
  elseif statusArmed == 0 and lastStatusArmed == 1 then
    lastStatusArmed = statusArmed
    playSound("disarmed")
  end

  if gpsStatus > 2 and lastGpsStatus <= 2 then
    lastGpsStatus = gpsStatus
    playSound("gpsfix")
  elseif gpsStatus <= 2 and lastGpsStatus > 2 then
    lastGpsStatus = gpsStatus
    playSound("gpsnofix")
  end

  if frameType ~= -1 and flightMode ~= lastFlightMode then
    lastFlightMode = flightMode
    playSoundByFrameTypeAndFlightMode(frameType,flightMode)
  end
  
  if simpleMode ~= lastSimpleMode then
    if simpleMode == 0 then
      playSound( lastSimpleMode == 1 and "simpleoff" or "ssimpleoff" )
    else
      playSound( simpleMode == 1 and "simpleon" or "ssimpleon" )
    end
    lastSimpleMode = simpleMode
  end
end

local function checkCellVoltage(battsource,cellmin,cellminFC,cellminA2)
  local celm = 0
  if battsource == "vs" then
    celm = cellmin*100
  elseif battsource == "fc" then
    celm = cellminFC*100
  elseif battsource == "a2" then
    celm = cellminA2*100
  end
  -- trigger batt1 and batt2
  if celm > conf.battAlertLevel2 and celm < conf.battAlertLevel1 and battLevel1 == false then
    battLevel1 = true
    playSound("batalert1")
  end
  if celm > 320 and celm < conf.battAlertLevel2 then
    battLevel2 = true
  end
  -- ignore batt alarm if current voltage outside "lipo" proper range
  -- this helps when cycling battery sources and one or more sources has 0 voltage
  if celm > 320 then
    checkAlarm(conf.battAlertLevel2,celm,ALARMS_BATT2,-1,"batalert2",menuItems[T2][4])
  end
end

local function cycleBatteryInfo()
  if showDualBattery == false and (batt2sources.fc or batt2sources.vs) then
    showDualBattery = true
    return
  end
  if battsource == "vs" then
    battsource = "fc"
  elseif battsource == "fc" then
    battsource = "a2"
  elseif battsource == "a2" then
    battsource = "vs"
  end
end
--------------------------------------------------------------------------------
-- MAIN LOOP
--------------------------------------------------------------------------------
--
local bgclock = 0
#ifdef BGRATE
local counter = 0
local bgrate = 0
local bgstart = 0
#endif --BGRATE
#ifdef FGRATE
local fgcounter = 0
local fgrate = 0
local fgstart = 0
#endif --FGRATE
#ifndef WIDGET
#ifdef HUDRATE
local hudcounter = 0
local hudrate = 0
local hudstart = 0
#endif --HUDRATE
#endif --WIDGET
#ifdef BGTELERATE
local bgtelecounter = 0
local bgtelerate = 0
local bgtelestart = 0
#endif --BGTELERATE
#ifdef MEMDEBUG
local maxmem = 0
#endif

-------------------------------
-- running at 20Hz (every 50ms)
-------------------------------
local bgprocessing = false
local bglockcounter = 0
--
local function backgroundTasks(telemetryLoops)
if bgprocessing == true then
  bglockcounter = bglockcounter + 1
  return 0
end
bgprocessing = true
#ifdef BGRATE
  ------------------------
  -- CALC BG LOOP RATE
  ------------------------
  -- skip first iteration
  local now = getTime()/100
  if counter == 0 then
    bgstart = now
  else
    bgrate = counter / (now - bgstart)
  end
  --
  counter=counter+1
#endif --BGRATE
  -- FAST: this runs at 60Hz (every 16ms)
  for i=1,telemetryLoops
  do
    processTelemetry()
#ifdef BGTELERATE
    ------------------------
    -- CALC BG TELE PROCESSING RATE
    ------------------------
    -- skip first iteration
    local now = getTime()/100
    if bgtelecounter == 0 then
      bgtelestart = now
    else
      bgtelerate = bgtelecounter / (now - bgtelestart)
    end
    --
    bgtelecounter=bgtelecounter+1
#endif --BGTELERATE
  end
  -- NORMAL: this runs at 20Hz (every 50ms)
  setTelemetryValue(VSpd_ID, VSpd_SUBID, VSpd_INSTANCE, vSpeed, 5 , VSpd_PRECISION , VSpd_NAME)
  -- SLOW: this runs at 4Hz (every 250ms)
  if (bgclock % 4 == 0) then
    setSensorValues()
    collectgarbage()
  end
  -- SLOWER: this runs at 2Hz (every 500ms)
  if (bgclock % 8 == 0) then
    calcBattery()
    calcFlightTime()
    checkEvents()
    checkLandingStatus()
    checkCellVoltage(battsource,getNonZeroMin(cell1min,cell2min),getNonZeroMin(cell1sumFC/calcCellCount(),cell2sumFC/calcCellCount()),cellsumA2/calcCellCount())
    -- aggregate value
    minmaxValues[MAX_CURR] = math.max(batt1current+batt2current,minmaxValues[MAX_CURR])
    -- indipendent values
    minmaxValues[MAX_CURR1] = math.max(batt1current,minmaxValues[MAX_CURR1])
    minmaxValues[MAX_CURR2] = math.max(batt2current,minmaxValues[MAX_CURR2])
    bgclock = 0
  end
  bgclock = bgclock+1
  -- blinking support
  if (getTime() - blinktime) > 65 then
    blinkon = not blinkon
    blinktime = getTime()
  end
  bgprocessing = false
  return 0
end

local showSensorPage = false
local showMessages = false
#ifndef WIDGET
local showConfigMenu = false

local function background()
  backgroundTasks(5)
end
--------------------------
-- RUN
--------------------------
-- EVT_EXIT_BREAK = RTN
#define EVT_ENTER_LONG 2050
#define EVT_ENTER_BREAK 514

#define EVT_MDL_FIRST 1539
#define EVT_MDL_LONG 2051
#define EVT_MDL_BREAK 515

#define EVT_SYS_FIRST 1542
#define EVT_SYS_LONG 2054
#define EVT_SYS_BREAK 518

#define EVT_PAGEUP_FIRST 1536
#define EVT_PAGEUP_LONG 2048
#define EVT_PAGEUP_BREAK 512

#define EVT_PAGEDN_FIRST 1537
#define EVT_PAGEDN_LONG 2049
#define EVT_PAGEDN_BREAK 513

#define EVT_TELE_FIRST 1541
#define EVT_TELE_LONG 2053


local function run(event)
#ifdef DEBUGEVT
  if (event ~= 0) then
    pushMessage(7,string.format("Event: %d",event))
  end
#endif
  background()
  lcd.clear()
#ifdef FGRATE
  ------------------------
  -- CALC FG LOOP RATE
  ------------------------
  -- skip first iteration
  local now = getTime()/100
  if fgcounter == 0 then
    fgstart = now
  else
    fgrate = fgcounter / (now - fgstart)
  end
  --
  fgcounter=fgcounter+1
#endif --FGRATE
  ---------------------
  -- SHOW MESSAGES
  ---------------------
  if showConfigMenu == false and (event == EVT_PLUS_BREAK or event == EVT_ROT_RIGHT) then
    showMessages = true
    -- stop event processing chain
    event = 0
  end
  ---------------------
  -- SHOW CONFIG MENU
  ---------------------
  if showMessages == false and (event == EVT_TELE_LONG or event == EVT_MDL_LONG ) then
    showConfigMenu = true
    -- stop event processing chain
    event = 0
  end
  ---------------------
  -- SHOW SENSORS PAGE
  ---------------------
  --
  if showSensorPage == false and showConfigMenu == false and showMessages == false and (event == EVT_PAGEDN_FIRST or event == EVT_PAGEUP_FIRST) then
    showSensorPage = true
    -- stop event processing chain
    event = 0
  end
  
  if showMessages then
    ---------------------
    -- MESSAGES
    ---------------------
    if event == EVT_EXIT_BREAK or event == EVT_MINUS_BREAK or event == EVT_ROT_LEFT then
      showMessages = false
    end
    drawAllMessages()
  elseif showConfigMenu then
    ---------------------
    -- CONFIG MENU
    ---------------------
    drawConfigMenu(event)
    --
    if event == EVT_EXIT_BREAK then
      menu.editSelected = false
      showConfigMenu = false
      saveConfig()
    end
  else
    ---------------------
    -- MAIN VIEW
    ---------------------
    if event == EVT_SYS_BREAK then
      showMinMaxValues = not showMinMaxValues
      -- stop event processing chain
      event = 0
    end
    if showDualBattery == true and event == EVT_EXIT_BREAK then
      showDualBattery = false
      -- stop event processing chain
      event = 0
    end
    if showSensorPage == true and event == EVT_EXIT_BREAK or event == EVT_PAGEDN_FIRST or event == EVT_PAGEUP_FIRST then
        showSensorPage = false
      -- stop event processing chain
      event = 0
    end
    if event == EVT_ROT_BREAK then
      cycleBatteryInfo()
      -- stop event processing chain
      event = 0
    end
#ifdef TESTMODE
      symMode()
#endif --TESTMODE
#ifdef HUDRATE
    ------------------------
    -- CALC HUD REFRESH RATE
    ------------------------
    -- skip first iteration
    local hudnow = getTime()/100
    if hudcounter == 0 then
      hudstart = hudnow
    else
      hudrate = hudcounter / (hudnow - hudstart)
    end
    --
    hudcounter=hudcounter+1
#endif --HUDRATE
    drawHomeDirection()
    drawHud()
    drawCompassRibbon()
    --
    -- Note: these can be calculated. not necessary to track them as min/max 
    -- cell1minFC = cell1sumFC/calcCellCount()
    -- cell2minFC = cell2sumFC/calcCellCount()
    -- cell1minA2 = cell1sumA2/calcCellCount()
    -- 
    local count = calcCellCount()
    local cel1m = getMinVoltageBySource(battsource,cell1min,cell1sumFC/count,cellsumA2/count,1,count)*100
    local cel2m = getMinVoltageBySource(battsource,cell2min,cell2sumFC/count,cellsumA2/count,2,count)*100
    local batt1 = getMinVoltageBySource(battsource,cell1sum,cell1sumFC,cellsumA2,1,count)*10
    local batt2 = getMinVoltageBySource(battsource,cell2sum,cell2sumFC,cellsumA2,2,count)*10
    local curr  = getMaxValue(batt1current+batt2current,MAX_CURR)
    local curr1 = getMaxValue(batt1current,MAX_CURR1)
    local curr2 = getMaxValue(batt2current,MAX_CURR2)
    local mah1 = batt1mah
    local mah2 = batt2mah
    local cap1 = getBatt1Capacity()
    local cap2 = getBatt2Capacity()
    --
    -- with dual battery default is to show aggregate view
    if batt2sources.fc or batt2sources.vs then
      if showDualBattery == false then
        -- dual battery: aggregate view
        lcd.drawText(285+BATTINFO_B1B2_X,BATTINFO_Y,"BATTERY: 1+2",SMLSIZE+INVERS)
        drawBatteryPane(285,getNonZeroMin(batt1,batt2),getNonZeroMin(cel1m,cel2m),curr,mah1+mah2,cap1+cap2)
      else
        -- dual battery: do I have also dual current monitor?
        if curr1 > 0 and curr2 == 0 then
          -- special case: assume 1 power brick is monitoring batt1+batt2 in parallel
          curr1 = curr1/2
          curr2 = curr1
          --
          mah1 = mah1/2
          mah2 = mah1
          --
          cap1 = cap1/2
          cap2 = cap1
        end
        -- dual battery:battery 1 right pane
        lcd.drawText(285+BATTINFO_B1_X,BATTINFO_Y,"BATTERY: 1",SMLSIZE+INVERS)
        drawBatteryPane(285,batt1,cel1m,curr1,mah1,cap1)
        -- dual battery:battery 2 left pane
        lcd.drawText(BATTINFO_B2_X,BATTINFO_Y,"BATTERY: 2",SMLSIZE+INVERS)
        drawBatteryPane(-24,batt2,cel2m,curr2,mah2,cap2)
      end
    else
      -- battery 1 right pane in single battery mode
      lcd.drawText(285+BATTINFO_B1_X,BATTINFO_Y,"BATTERY: 1",SMLSIZE+INVERS)
      drawBatteryPane(285,batt1,cel1m,curr1,mah1,cap1)
    end
    -- left pane info when not in dual battery mode
    if showDualBattery == false then
      -- power is always based on flight controller values
      drawGPSStatus()
      if showSensorPage then
        drawCustomSensors()
      else
        drawLeftPane(curr1+curr2,getNonZeroMin(cell1sumFC,cell2sumFC))
      end
    end
    drawFlightMode()
    drawTopBar()
    drawBottomBar()
    drawFlightTime()
    drawFailsafe()
    drawArmStatus()
#ifdef DEBUG    
    lcd.drawNumber(0,40,cell1maxFC,SMLSIZE+PREC1)
    lcd.drawNumber(25,40,calcCellCount(),SMLSIZE)
#endif --DEBUG
#ifdef BGRATE    
    local bgrateTxt = string.format("BG:%.01fHz",bgrate)
    lcd.drawText(0,30,bgrateTxt,SMLSIZE+INVERS)
#endif --BGRATE
#ifdef FGRATE    
    local fgrateTxt = string.format("FG:%.01fHz",fgrate)
    lcd.drawText(0,50,fgrateTxt,SMLSIZE+INVERS)
#endif --FGRATE
#ifdef HUDTIMER    
    local hudtimerTxt = string.format("%.01fms",10*hudDrawTime/hudDrawCounter)
    lcd.drawText(95,1,hudtimerTxt,SMLSIZE+INVERS)
#endif --HUDTIMER
#ifdef TELERATE    
    lcd.drawNumber(0,110,telerate,SMLSIZE+INVERS)
#endif --TELERATE
    if showDualBattery == false and showSensorPage == false then
#ifdef HUDRATE    
      local hudrateTxt = string.format("H:%.01fHz",hudrate)
      lcd.drawText(2,76,hudrateTxt,SMLSIZE)
#endif --HUDRATE
#ifdef BGTELERATE    
      local bgtelerateTxt = string.format("B:%.01fHz",bgtelerate)
      lcd.drawText(160,76,bgtelerateTxt,SMLSIZE+RIGHT)
#endif --BGTELERATE
    end
    drawNoTelemetryData()
  end
  return 0
end
#endif --WIDGET

local function init()
  -- initialize flight timer
  model.setTimer(2,{mode=0})
#ifdef TESTMODE
  model.setTimer(2,{value=5000})
#else
  model.setTimer(2,{value=0})
#endif
  loadConfig()
#ifdef TESTMODE
#ifdef DEMO
  pushMessage(6,"APM:Copter V3.5.4 (284349c3) QUAD")
  pushMessage(6,"Calibrating barometer")
  pushMessage(6,"Initialising APM")
  pushMessage(6,"Barometer calibration complete")
  pushMessage(6,"EKF2 IMU0 initial yaw alignment complete")
  pushMessage(6,"EKF2 IMU1 initial yaw alignment complete")
  pushMessage(6,"GPS 1: detected as u-blox at 115200 baud")
  pushMessage(6,"EKF2 IMU0 tilt alignment complete")
  pushMessage(6,"EKF2 IMU1 tilt alignment complete")
  pushMessage(6,"u-blox 1 HW: 00080000 SW: 2.01 (75331)")
  pushMessage(4,"Bad AHRS")
#else -- add some more messages to force memory allocation :-)
  pushMessage(6,"APM:Copter V3.5.4 (284349c3) QUAD")
  pushMessage(6,"Calibrating barometer")
  pushMessage(6,"Initialising APM")
  pushMessage(6,"Barometer calibration complete")
  pushMessage(6,"EKF2 IMU0 initial yaw alignment complete")
  pushMessage(6,"EKF2 IMU1 initial yaw alignment complete")
  pushMessage(6,"GPS 1: detected as u-blox at 115200 baud")
  pushMessage(6,"EKF2 IMU0 tilt alignment complete")
  pushMessage(6,"EKF2 IMU1 tilt alignment complete")
  pushMessage(4,"Bad AHRS")
  #endif --DEMO
#endif --TESTMODE
#ifdef LOGTELEMETRY
  logfilename = getLogFilename(getDateTime())
  logfile = io.open(logfilename,"a")
  pushMessage(7,logfilename)
#endif --LOGTELEMETRY
  playSound("yaapu")
#ifndef WIDGET
  loadSensors()
#endif --WIDGET
  pushMessage(7,VERSION)
end

--------------------------------------------------------------------------------
-- SCRIPT END
--------------------------------------------------------------------------------
#ifdef WIDGET
-- 4 pages
-- page 1 single battery view
-- page 2 message history
-- page 3 min max
-- page 4 dual battery view
local options = {
  { "page", VALUE, 1, 1, 4},
}

local widgetPages = { 
  {active=false, bgtasks=false, fgtasks=false},
  {active=false, bgtasks=false, fgtasks=false},
  {active=false, bgtasks=false, fgtasks=false},
  {active=false, bgtasks=false, fgtasks=false}
}
---------------------
-- script version 
---------------------
local sharedVars = {
  counter1 = 0,
  counter2 = 0,
  maxmem = 0
}
  
-- shared init flag
local initDone = 0
-- This function is runned once at the creation of the widget
local function create(zone, options)
  -- this vars are widget scoped, each instance has its own set
  local vars = {
    #ifdef HUDRATE
    hudcounter = 0,
    hudrate = 0,
    hudstart = 0,
    #endif --HUDRATE
  }
  -- all local vars are shared between widget instances
  -- init() needs to be called only once!
  if initDone == 0 then
    init()
    initDone = 1
  end
  -- register current page as active
  widgetPages[options.page].active = true
  --
  return { zone=zone, options=options, vars=vars }
end

-- This function allow updates when you change widgets settings
local function update(myWidget, options)
  myWidget.options = options
  -- register current page as active
  widgetPages[options.page].active = true
  -- reload menu settings
  loadConfig()
end
local function fullScreenRequired(myWidget)
  lcd.setColor(CUSTOM_COLOR,lcd.RGB(255, 0, 0))
  lcd.drawText(myWidget.zone.x,myWidget.zone.y,"Yaapu requires",SMLSIZE+CUSTOM_COLOR)
  lcd.drawText(myWidget.zone.x,myWidget.zone.y+16,"full screen",SMLSIZE+CUSTOM_COLOR)
  --[[
  if myWidget.zone.h > 100 then
    local strsize = string.format("%d x %d",myWidget.zone.w,myWidget.zone.h)
    lcd.drawText(myWidget.zone.x,myWidget.zone.y+32,strsize,SMLSIZE+CUSTOM_COLOR)
  end
  --]]
end
-- This size is for top bar widgets
local function zoneTiny(myWidget)
  fullScreenRequired(myWidget)
end
--- Size is 160x30 1/8th
local function zoneSmall(myWidget)
  fullScreenRequired(myWidget)
end
--- Size is 180x70 1/4th
local function zoneMedium(myWidget)
  fullScreenRequired(myWidget)
end
--- Size is 190x150
local function zoneLarge(myWidget)
  fullScreenRequired(myWidget)
end
--- Size is 390x170
local function zoneXLarge(myWidget)
  fullScreenRequired(myWidget)
end
--- Size is 480x272
local function zoneFullScreen(myWidget)
#ifdef FGRATE
  ------------------------
  -- CALC FG LOOP RATE
  ------------------------
  -- skip first iteration
  local now = getTime()/100
  if fgcounter == 0 then
    fgstart = now
  else
    fgrate = fgcounter / (now - fgstart)
  end
  --
  fgcounter=fgcounter+1
#endif --FGRATE
#ifdef TESTMODE
  symMode()
#endif --TESTMODE
  --------------------------
  -- Widget Page 2 is message history
  --------------------------
  if myWidget.options.page == 2 then
    drawAllMessages()
  else
#ifdef HUDRATE
    ------------------------
    -- CALC HUD REFRESH RATE
    ------------------------
    -- skip first iteration
    local hudnow = getTime()/100
    if myWidget.vars.hudcounter == 0 then
      myWidget.vars.hudstart = hudnow
    else
      myWidget.vars.hudrate = myWidget.vars.hudcounter / (hudnow - myWidget.vars.hudstart)
    end
    --
    myWidget.vars.hudcounter=myWidget.vars.hudcounter+1
#endif --HUDRATE
    drawHomeDirection()
    drawHud(myWidget)
    drawCompassRibbon()
    --
    -- Note: these can be calculated. not necessary to track them as min/max 
    -- cell1minFC = cell1sumFC/calcCellCount()
    -- cell2minFC = cell2sumFC/calcCellCount()
    -- cell1minA2 = cell1sumA2/calcCellCount()
    -- 
    local count = calcCellCount()
    local cel1m = getMinVoltageBySource(battsource,cell1min,cell1sumFC/count,cellsumA2/count,1,count)*100
    local cel2m = getMinVoltageBySource(battsource,cell2min,cell2sumFC/count,cellsumA2/count,2,count)*100
    local batt1 = getMinVoltageBySource(battsource,cell1sum,cell1sumFC,cellsumA2,1,count)*10
    local batt2 = getMinVoltageBySource(battsource,cell2sum,cell2sumFC,cellsumA2,2,count)*10
    local curr  = getMaxValue(batt1current+batt2current,MAX_CURR)
    local curr1 = getMaxValue(batt1current,MAX_CURR1)
    local curr2 = getMaxValue(batt2current,MAX_CURR2)
    local mah1 = batt1mah
    local mah2 = batt2mah
    local cap1 = getBatt1Capacity()
    local cap2 = getBatt2Capacity()
    --
    -- with dual battery default is to show aggregate view
    if batt2sources.fc or batt2sources.vs then
      if showDualBattery == false then
        -- dual battery: aggregate view
        lcd.drawText(285+67,85,"BATTERY: 1+2",SMLSIZE+INVERS)
        drawBatteryPane(285,getNonZeroMin(batt1,batt2),getNonZeroMin(cel1m,cel2m),curr,mah1+mah2,cap1+cap2)
      else
        -- dual battery: do I have also dual current monitor?
        if curr1 > 0 and curr2 == 0 then
          -- special case: assume 1 power brick is monitoring batt1+batt2 in parallel
          curr1 = curr1/2
          curr2 = curr1
          --
          mah1 = mah1/2
          mah2 = mah1
          --
          cap1 = cap1/2
          cap2 = cap1
        end
        -- dual battery:battery 1 right pane
        lcd.drawText(285+75,85,"BATTERY: 1",SMLSIZE+INVERS)
        drawBatteryPane(285,batt1,cel1m,curr1,mah1,cap1)
        -- dual battery:battery 2 left pane
        lcd.drawText(50,85,"BATTERY: 2",SMLSIZE+INVERS)
        drawBatteryPane(-24,batt2,cel2m,curr2,mah2,cap2)
      end
    else
      -- battery 1 right pane in single battery mode
      lcd.drawText(285+75,85,"BATTERY: 1",SMLSIZE+INVERS)
      drawBatteryPane(285,batt1,cel1m,curr1,mah1,cap1)
    end
    -- left pane info when not in dual battery mode
    if showDualBattery == false then
      -- power is always based on flight controller values
      drawGPSStatus()
      if showSensorPage then
        drawCustomSensors()
      else
        drawLeftPane(curr1+curr2,getNonZeroMin(cell1sumFC,cell2sumFC))
      end
    end
    drawFlightMode()
    drawTopBar()
    drawBottomBar()
    drawFlightTime()
    drawFailsafe()
    drawArmStatus()
#ifdef DEBUG    
    lcd.drawNumber(0,40,cell1maxFC,SMLSIZE+PREC1)
    lcd.drawNumber(25,40,calcCellCount(),SMLSIZE)
#endif --DEBUG
#ifdef BGRATE    
    local bgrateTxt = string.format("BG:%.01fHz",bgrate)
    lcd.drawText(0,30,bgrateTxt,SMLSIZE+INVERS)
#endif --BGRATE
#ifdef FGRATE    
    local fgrateTxt = string.format("FG:%.01fHz",fgrate)
    lcd.drawText(0,50,fgrateTxt,SMLSIZE+INVERS)
#endif --FGRATE
#ifdef HUDTIMER    
    local hudtimerTxt = string.format("%.01fms",10*hudDrawTime/hudDrawCounter)
    lcd.drawText(95,1,hudtimerTxt,SMLSIZE+INVERS)
#endif --HUDTIMER
#ifdef TELERATE    
    lcd.drawNumber(0,110,telerate,SMLSIZE+INVERS)
#endif --TELERATE
    if showDualBattery == false and showSensorPage == false then
#ifdef HUDRATE    
      local hudrateTxt = string.format("H:%.01fHz",myWidget.vars.hudrate)
      lcd.drawText(2,76,hudrateTxt,SMLSIZE)
#endif --HUDRATE
#ifdef BGTELERATE    
      local bgtelerateTxt = string.format("B:%.01fHz",bgtelerate)
      lcd.drawText(160,76,bgtelerateTxt,SMLSIZE+RIGHT)
#endif --BGTELERATE
    end
  end  
  drawNoTelemetryData()
#ifdef MEMDEBUG
  maxmem = math.max(maxmem,collectgarbage("count")*1024)
  -- test with absolute coordinates
  lcd.drawNumber(LCD_W,LCD_H-16,maxmem,SMLSIZE+MENU_TITLE_COLOR+RIGHT)
#endif
#ifdef WIDGETDEBUG
  local strpages = ""
  local p = ""
  -- for each registered page
  for i=1,4 do
      p=i
      if widgetPages[i].fgtasks == true then
        p="F"
      end
      if widgetPages[i].bgtasks == true then
        p="B"
      end
    if widgetPages[i].active == true then
      if i == myWidget.options.page then
        -- this is the current widget
        strpages = strpages.."["..p.."]"
      else
        strpages = strpages..p
      end
    end
  end
  lcd.drawText(LCD_W,LCD_H-66,strpages,SMLSIZE+RIGHT)
#ifdef BGTELERATE    
  local bgtelerateTxt = string.format("B:%.01fHz",bgtelerate)
  lcd.drawText(LCD_W,LCD_H-50,bgtelerateTxt,SMLSIZE+RIGHT)
#endif --BGTELERATE
  lcd.drawNumber(LCD_W,LCD_H-36,bglockcounter,SMLSIZE+RIGHT)
#endif --WIDGETDEBUG  
end

local currentPage = 0
-- called when widget instance page changes
local function onChangePage(myWidget)
#ifdef WIDGETDEBUG
  playTone(300,200,0,PLAY_BACKGROUND)
#endif --WIDGETDEBUG  
#ifdef BGTELERATE
  bgtelecounter = 0
#endif --BGTELERATE
  -- reset HUD counters
  myWidget.vars.hudcounter = 0
  -- refresh config on page change so it's possible to use menu in one time mode
  loadConfig()
  collectgarbage()
end

-- Called when script is hidden @20Hz
local function background(myWidget)
  -- when page 3 goes to background hide minmax values
  if myWidget.options.page == 3 then
    showMinMaxValues = false
    return
  end
  -- when page 4 goes to background hide dual battery view
  if myWidget.options.page == 4 then
    showDualBattery = false
    return
  end
  -- when page 1 goes to background run bg tasks only if page 2 is not registered
  if myWidget.options.page == 1 and widgetPages[2].active == false then
#ifdef WIDGETDEBUG
    -- reset flags
    for i=1,4 do
      widgetPages[i].fgtasks=false
      widgetPages[i].bgtasks=false
    end
    -- set bg active page
    widgetPages[1].bgtasks=true
#endif --WIDGETDEBUG      
    -- run bg tasks
    backgroundTasks(6)
    return
  end
  -- when page 2 goes to background always run bg tasks
  if myWidget.options.page == 2 then
#ifdef WIDGETDEBUG
    -- reset flags
    for i=1,4 do
      widgetPages[i].fgtasks=false
      widgetPages[i].bgtasks=false
    end
    -- set bg active page
    widgetPages[2].bgtasks=true
#endif --WIDGETDEBUG      
    -- run bg tasks
    backgroundTasks(6)
  end
end

-- Called when script is visible
function refresh(myWidget)
  -- check if current widget page changed
  if currentPage ~= myWidget.options.page then
    currentPage = myWidget.options.page
    onChangePage(myWidget)
  end
  -- when page 1 goes to foreground run bg tasks only if page 2 is not registered
  if myWidget.options.page == 1 and widgetPages[2].active == false then
#ifdef WIDGETDEBUG
    -- reset flags
    for i=1,4 do
      widgetPages[i].fgtasks=false
      widgetPages[i].bgtasks=false
    end
    -- set fg active page
    widgetPages[1].fgtasks=true
#endif --WIDGETDEBUG      
    -- run bg tasks
    backgroundTasks(6)
  end
  -- if widget page 2 is declared then always run bg tasks when in foreground
  if myWidget.options.page == 2 then
#ifdef WIDGETDEBUG
    -- reset flags
    for i=1,4 do
      widgetPages[i].fgtasks=false
      widgetPages[i].bgtasks=false
    end
    -- set fg active page
    widgetPages[2].fgtasks=true
#endif --WIDGETDEBUG      
    -- run bg tasks
    backgroundTasks(4)
  end
   -- when page 3 goes to foreground show minmax values
  if myWidget.options.page == 3 then
    showMinMaxValues = true
  end
  -- when page 4 goes to foreground show dual battery view
  if myWidget.options.page == 4 then
    showDualBattery = true
  end
  --
  if myWidget.zone.w  > 450 and myWidget.zone.h > 250 then zoneFullScreen(myWidget) 
  elseif myWidget.zone.w  > 380 and myWidget.zone.h > 165 then zoneXLarge(myWidget)
  elseif myWidget.zone.w  > 180 and myWidget.zone.h > 145  then zoneLarge(myWidget)
  elseif myWidget.zone.w  > 170 and myWidget.zone.h > 65 then zoneMedium(myWidget)
  elseif myWidget.zone.w  > 150 and myWidget.zone.h > 28 then zoneSmall(myWidget)
  elseif myWidget.zone.w  > 65 and myWidget.zone.h > 35 then zoneTiny(myWidget)
  end
end

return { name="Yaapu", options=options, create=create, update=update, background=background, refresh=refresh } 
#else --WIDGET
return {run=run, init=init}
#endif  --WIDGET