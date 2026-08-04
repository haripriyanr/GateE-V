@echo off
REM GatE-V FPGA - Windows Build Script
REM Usage: build.bat [bd|synth|sim|sim-gui|questa|questa-gui|gatev|clean] [NUM_TILES]  

set TARGET=%1
if "%TARGET%"=="" set TARGET=bd

set NUM_TILES=%2
if "%NUM_TILES%"=="" set NUM_TILES=4

set PRJ_DIR=..\GatE-V
set PRJ_SRC_DIR=..\GatE-V\src
set SCRIPTS=scripts

if "%TARGET%"=="clean" (
    rmdir /S /Q .Xil 2>nul
    del /Q *.jou *.log *.backup* *.str *.vcd *.fst *.pb *.dir *.wlf wlft* work transcript 2>nul
    rmdir /S /Q "%PRJ_DIR%" 2>nul
    echo Cleaned.
    goto :EOF
)

REM Prepare directory and copy files
mkdir "%PRJ_SRC_DIR%" 2>nul
xcopy /E /I /Y rtl "%PRJ_SRC_DIR%\rtl" >nul
xcopy /E /I /Y constraints "%PRJ_SRC_DIR%\constraints" >nul 2>nul
xcopy /E /I /Y board_files "%PRJ_SRC_DIR%\board_files" >nul 2>nul

if "%TARGET%"=="bd" (
    vivado -mode batch -source "%SCRIPTS%\vivado_create_bd.tcl" -tclargs "%PRJ_DIR%" "%PRJ_SRC_DIR%"
) else if "%TARGET%"=="synth" (
    vivado -mode batch -source "%SCRIPTS%\vivado_create_bd.tcl" -tclargs "%PRJ_DIR%" "%PRJ_SRC_DIR%"
    vivado -mode batch -source "%SCRIPTS%\vivado_synth.tcl" -tclargs "%PRJ_DIR%"
) else if "%TARGET%"=="gatev" (
    vivado -mode batch -source "%SCRIPTS%\vivado_create_bd.tcl" -tclargs "%PRJ_DIR%" "%PRJ_SRC_DIR%"
    vivado -mode batch -source "%SCRIPTS%\vivado_synth.tcl" -tclargs "%PRJ_DIR%"
    vivado -mode batch -source "%SCRIPTS%\vivado_sim.tcl" -tclargs "%PRJ_DIR%" "%PRJ_SRC_DIR%" %NUM_TILES%
) else if "%TARGET%"=="sim" (
    vivado -mode batch -source "%SCRIPTS%\vivado_sim.tcl" -tclargs "%PRJ_DIR%" "%PRJ_SRC_DIR%" %NUM_TILES%
) else if "%TARGET%"=="sim-gui" (
    vivado -source "%SCRIPTS%\vivado_sim.tcl" -tclargs "%PRJ_DIR%" "%PRJ_SRC_DIR%" %NUM_TILES%
) else if "%TARGET%"=="questa" (
    vsim -c -do "do sim/run.do"
) else if "%TARGET%"=="questa-gui" (
    vsim -do "do sim/run.do"
) else (
    echo Unknown target: %TARGET%
    echo Available targets: gatev, bd, synth, sim, sim-gui, questa, questa-gui, clean
)
