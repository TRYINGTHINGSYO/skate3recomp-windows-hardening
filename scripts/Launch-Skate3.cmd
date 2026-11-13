@echo off
setlocal
cd /d "%~dp0"
if not exist "%~dp0skate3.exe" (
  echo Place this launcher beside skate3.exe and its matching runtime DLL.
  pause
  exit /b 1
)
if not exist "%~dp0game\default.xex" (
  echo Supply your legally obtained extracted game in the game folder first.
  pause
  exit /b 1
)
if not exist "%~dp0game\default.xexp" (
  echo Stage the verified Title Update 3 patches before launching.
  pause
  exit /b 1
)
if not exist "%~dp0game\data\webkit\EAWebkit.xexp" (
  echo The Title Update 3 EAWebkit patch is missing.
  pause
  exit /b 1
)
set "SKATE3_PROFILE=%~dp0profile"
if not "%~1"=="" set "SKATE3_PROFILE=%~1"
start "" "%~dp0skate3.exe" --game_data_root="%~dp0game" --user_data_root="%SKATE3_PROFILE%" --gpu_backend=d3d12 --fullscreen=false --skate3_native_render_scene=false --skate3_native_render=false --native_render_suppress_emulated_draws=false --readback_resolve=full --readback_memexport=true --skate3_intro_movie_skip=false --skate3_guest_fps_cap=60 --skate3_guest_fps_cap_auto=false --headless=true --headless_keyboard_text=SkateTeam
