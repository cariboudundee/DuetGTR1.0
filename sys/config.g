;; Configuration file for SKR v1.4T 
;; executed by the firmware on start-up

; =====================================================================================================================
; General preferences
; =====================================================================================================================
G90                                                       ; send absolute coordinates...
M83                                                       ; ...but relative extruder moves
M550 P"duet3"                                             ; set printer name
M404 N1.75 D0.4                                           ; define filament and nozzle diameters for volumetric extrusion

; =====================================================================================================================
; Drives
; =====================================================================================================================
; The D3 setting enables Stealth Chop (when running e.g. TMC2209 drivers). The V setting configures the speed at which
; the switch between Stealth Chop and Spread Cycle occurs.
;
;     V30  = 250.0 mm/sec
;     V40  = 187.5 mm/sec
;     V60  = 125.0 mm/sec
;     V68  = 110.3 mm/sec
;     V600 =   3.1 mm/sec
;
; This can be checked via M569 P0 (or P1, P2, P3, P4) 
; =====================================================================================================================
; Chopper Timing: The Marlin default chopper timing for 24V is defined as { 4, 2, 1 }. This is represented below as
; T4 Y1:2 parameters.
; =====================================================================================================================
M569 P0 S0                                                ; physical drive 0 goes forwards using default driver timings
M569 P1 S0                                                ; physical drive 1 goes forwards using default driver timings
M569 P2 S1                                                ; physical drive 2 goes forwards using default driver timings
M569 P3 S0  		     				                  ; physical drive 3 goes forwards using default driver timings
M569 P4 S1                                                ; physical drive 4 goes forwards using default driver timings
M584 X0 Y1 Z2:4 E3                                        ; set drive mapping
M350 X16 Y16 Z16 E16 I1                                   ; configure microstepping with interpolation
M92 X80.121 Y80.121 Z399.78 E416.54                       ; set steps per mm
M566 X1000 Y1000 Z50 E3000 P1                             ; set maximum instantaneous speed changes (mm/min)
M203 X15000 Y15000 Z2800 E2400                            ; set maximum speeds (mm/min)
M201 X1100 Y1100 Z100 E5000                               ; set accelerations (mm/s^2)
M204 P600 T1000						                      ; Set accelerations (mm/s^2) for print and travel moves
M906 X1600 Y1600 Z1600 E800 I50                           ; set motor currents (mA) and motor idle factor in per cent
M84 S30                                                   ; Set idle timeout

; =====================================================================================================================
; Axis Limits
; =====================================================================================================================
;
; M671 defines the position of the lead screws for the Z axis, required to do proper alignment of the Z motors.
; =====================================================================================================================
M671 X-28:333 Y147.5:147.5 S3.0                           ; leadscrews at left (connected to Z) and right (connected to E1) of X axis
M208 X0:305 Y0:305 Z0:380                                 ; set axis limits

; =====================================================================================================================
; Endstops
; ========
M574 X1 S1 P"xstop"                                       ; X min active high endstop switch
M574 Y1 S1 P"ystop"                                       ; Y min active high endstop switch
M574 Z1 S2                                                ; configure Zstop as IR height sensor
 
; =====================================================================================================================
; Resume Button
; =====================================================================================================================
M950 J0 C"e0stop"
M950 J1 C"e1stop"
M581 T2 P0 S1 R0                                          ; Runs trigger2.g file when pressed - Resets Load Macros
M581 T6 P0 S1 R1                                          ; Runs trigger6.g file when pressed during print - Resumes print after resetting load macros
M581 T3 P1 S1 R1                                          ; Runs trigger3.g file when pressed during print - Runs before Trigger 7 to get temp back up during print
M581 T7 P1 S1 R0                                          ; Runs trigger7.g file when pressed - First step of Unload process
 
; =====================================================================================================================
; Filament Sensor
; ===============
M591 D0 P1 C"e2stop" S1                                   ; filament monitor connected to e2stop

; =====================================================================================================================
; Z-Probe (IR height detector)
; =====================================================================================================================
M558 P1 C"e1temp" H5 A2 S0.5 F300 T6000                   ; disable Z probe but set dive height, probe speed and travel speed
G31 P500 X-32 Y5 Z0.77  			       		          ; Probe Offset (0.77)

; =====================================================================================================================
; Mesh Compenstion
; =====================================================================================================================
M557 X10:272 Y10:295 P4                                   ; define mesh grid
M376 H10                                                  ; fade over 10mm

; =====================================================================================================================
; Heaters
; =====================================================================================================================
; Heatbed
M308 S0 P"bedtemp" Y"thermistor" T100000 B4092 A"Lit"     ; configure sensor 0 as thermistor on pin bedtemp
M950 H0 C"bed" T0                              		      ; create bed heater output on bed and map it to sensor 0
M307 H0 B0 S1.00                               		      ; disable bang-bang mode for the bed heater and set PWM limit
M140 H0                                        		      ; map heated bed to heater 0
M143 H0 S150                                   		      ; set temperature limit for heater 0 to 150°C
; Hotend
M308 S1 P"e0temp" Y"thermistor" T100000 B4092 A"Tête"     ; configure sensor 1 as thermistor on pin e0temp
M950 H1 C"e0heat" T1                           		      ; create nozzle heater output on e0heat and map it to sensor 1
M307 H1 B0 S1.00                               		      ; disable bang-bang mode for heater  and set PWM limit
M143 H1 S275                                   		      ; set temperature limit for heater 1 to 275°C

; =====================================================================================================================
; Heater model parameters
; =====================================================================================================================
M307 H0 A613.5 C1269.2 D7.2 S1.0 V0.0 B0                  ;PLA PID setting 60°c
M307 H1 A569.7 C196.0 D5.4 S1.0 V0.0 B0                   ;PLA PID setting 210°c                     

; =====================================================================================================================
; Fans
; =====================================================================================================================
; The wiring diagram mentioned uses FAN0 connector for the Part Cooling fan, and HE1 for Hotend Cooling. 
M950 F0 C"fan0" Q100                                      ; create fan 0 on pin fan0 and set its frequency
M106 P0 S0 H-1 C"Parts Cooling"                           ; set fan 0 value. Thermostatic control is turned off
M950 F1 C"fan1" T1 Q100                                   ; create extruder fan output (2.4) on e1heat and map it to sensor 1 (T1)
M106 P1 R1 H1 T45 C"Hotend Cooling"                       ; thermostatically 45C controlled fan from T1 sensor
M950 F2 C"fan2" Q100                                      ; create fan 0 on pin fan0 and set its frequency
M106 P2 S0 H-1 C"Motherboard Cooling"                     ; set fan 0 value. Thermostatic control is turned off

; =====================================================================================================================
; Tools
; =====================================================================================================================
M563 P0 S"BMG wind" D0 H1 F0                              ; define tool 0
G10 P0 X0 Y0 Z0                                           ; set tool 0 axis offsets
G10 P0 R0 S0                                              ; set initial tool 0 active and standby temperatures to 0C

; =====================================================================================================================
; Pressure Advance
; =====================================================================================================================
M572 D0 S0.12						

; =====================================================================================================================
; Retraction
; =====================================================================================================================
M207 S1.5 R0.0 F2100 T2100 Z0.4 

	; M207: Set retract length
	; Parameters
	; 	Snnn positive length to retract, in mm
	; 	Rnnn positive or negative additional length to un-retract, in mm, default zero
	; 	Fnnn retraction feedrate, in mm/min
	; 	Tnnn feedrate for un-retraction if different from retraction, mm/min (RepRapFirmware 1.16 and later only)
	; 	Znnn additional zlift/hop
	; Example: M207 S4.0 F2400 Z0.075

    ; FEEDRATE CONVERSIONS
	; 20mm/s = F1200
	; 35mm/s = F2100
	; 50mm/s = F3000
	; 70mm/s = F4200
	; 100mm/s = F6000
	; 120mm/s = F7200
	; 133mm/s = F8000

; =====================================================================================================================
; Custom settings
; =====================================================================================================================
M912 P0 S-20					                           ; CPU temperature calibration

; =====================================================================================================================
;; BTT TFT35 screen
; =====================================================================================================================
M575 P1 S0 B57600                                         ; enable support for BTT TFT35

; =====================================================================================================================
;; Miscellaneous
; =====================================================================================================================
M501                                                      ; load saved parameters from non-volatile memory
T0                                                        ; select first tool


