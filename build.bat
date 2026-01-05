@echo off

title Building BO2-Reimagined

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\patch_mp.ff" ^
--load "%OAT_GAME%\zone\all\common_patch_mp.ff" ^
--load "%OAT_GAME%\zone\all\common_mp.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\dependencies" ^
--output-folder "%CD%\zone_source\dependencies" ^
camo_materials!mp

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\zm_prison_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_prison.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\dependencies" ^
--output-folder "%CD%\zone_source\dependencies" ^
camo_materials!zmb_dlc2

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\zm_tomb_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_tomb.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\dependencies" ^
--output-folder "%CD%\zone_source\dependencies" ^
camo_materials!zmb_dlc4

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%CD%\zone_source\dependencies\camo_materials!zmb_dlc4.ff" ^
--load "%CD%\zone_source\dependencies\camo_materials!zmb_dlc2.ff" ^
--load "%CD%\zone_source\dependencies\camo_materials!mp.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\dependencies" ^
--output-folder "%CD%\zone_source\dependencies" ^
camo_materials

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%CD%\zone_source\dependencies\camo_materials.ff" ^
--load "%CD%\zone\all\weapons!metalstorm_mms_sp.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
weapons!metalstorm_mms_sp

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%CD%\zone_source\dependencies\camo_materials.ff" ^
--load "%CD%\zone\all\weapons!exptitus6_sp.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
weapons!exptitus6_sp

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\patch.ff" ^
--load "%OAT_GAME%\zone\all\common.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
common

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\code_post_gfx.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
code_post_gfx

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\frontend_patch.ff" ^
--load "%OAT_GAME%\zone\all\frontend.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
frontend

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\so_cmp_afghanistan.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
afghanistan

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%CD%\zone_source\dependencies\camo_materials.ff" ^
--load "%OAT_GAME%\zone\all\patch_mp.ff" ^
--load "%OAT_GAME%\zone\all\common_patch_mp.ff" ^
--load "%OAT_GAME%\zone\all\common_mp.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
common_mp

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\code_post_gfx_mp.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
code_post_gfx_mp

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\english\en_code_post_gfx_mp.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
en_code_post_gfx_mp

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%CD%\zone_source\dependencies\camo_materials.ff" ^
--load "%OAT_GAME%\zone\all\patch_zm.ff" ^
--load "%OAT_GAME%\zone\all\common_zm.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
common_zm

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\patch_ui_zm.ff" ^
--load "%OAT_GAME%\zone\all\ui_zm.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
ui_zm

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%CD%\zone_source\dependencies\camo_materials.ff" ^
--load "%OAT_GAME%\zone\all\zm_transit_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_transit.ff" ^
--load "%OAT_GAME%\zone\all\so_zclassic_zm_transit.ff" ^
--load "%OAT_GAME%\zone\all\so_zsurvival_zm_transit.ff" ^
--load "%OAT_GAME%\zone\all\so_zencounter_zm_transit.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
zm_transit

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%CD%\zone_source\dependencies\camo_materials.ff" ^
--load "%OAT_GAME%\zone\all\zm_nuked_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_nuked.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
zm_nuked

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%CD%\zone_source\dependencies\camo_materials.ff" ^
--load "%OAT_GAME%\zone\all\zm_highrise_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_highrise.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
zm_highrise

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%CD%\zone_source\dependencies\camo_materials.ff" ^
--load "%OAT_GAME%\zone\all\zm_prison_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_prison.ff" ^
--load "%OAT_GAME%\zone\all\so_zencounter_zm_prison.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
zm_prison

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%CD%\zone_source\dependencies\camo_materials.ff" ^
--load "%OAT_GAME%\zone\all\zm_buried_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_buried.ff" ^
--load "%OAT_GAME%\zone\all\so_zencounter_zm_buried.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
zm_buried

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%CD%\zone_source\dependencies\camo_materials.ff" ^
--load "%OAT_GAME%\zone\all\zm_tomb_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_tomb.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source\includes" ^
--output-folder "%CD%\zone_source\includes" ^
zm_tomb

if %ERRORLEVEL% neq 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%CD%\zone_source\dependencies\camo_materials.ff" ^
--load "%CD%\zone_source\includes\weapons!metalstorm_mms_sp.ff" ^
--load "%CD%\zone_source\includes\weapons!exptitus6_sp.ff" ^
--load "%CD%\zone_source\includes\common.ff" ^
--load "%CD%\zone_source\includes\code_post_gfx.ff" ^
--load "%CD%\zone_source\includes\frontend.ff" ^
--load "%CD%\zone_source\includes\afghanistan.ff" ^
--load "%CD%\zone_source\includes\common_mp.ff" ^
--load "%CD%\zone_source\includes\code_post_gfx_mp.ff" ^
--load "%CD%\zone_source\includes\en_code_post_gfx_mp.ff" ^
--load "%CD%\zone_source\includes\common_zm.ff" ^
--load "%CD%\zone_source\includes\ui_zm.ff" ^
--load "%CD%\zone_source\includes\zm_transit.ff" ^
--load "%CD%\zone_source\includes\zm_nuked.ff" ^
--load "%CD%\zone_source\includes\zm_highrise.ff" ^
--load "%CD%\zone_source\includes\zm_prison.ff" ^
--load "%CD%\zone_source\includes\zm_buried.ff" ^
--load "%CD%\zone_source\includes\zm_tomb.ff" ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%CD%" ^
--add-source-search-path "%CD%\zone_source;%CD%\zone_source\dependencies;%CD%\zone_source\includes" ^
--output-folder "%CD%" ^
mod

if %ERRORLEVEL% neq 0 pause

del /s %CD%\zone_source\*.ff 1>nul

pwsh -Command "Compress-Archive -Force -Path attachmentunique,images,maps,scripts,ui,ui_mp,weapons -DestinationPath mod.iwd"

if %ERRORLEVEL% neq 0 pause

for %%f in (ff,iwd,sabs,sabl,json) do xcopy /i /y *.%%f ..\zm_reimagined

del *.iwd