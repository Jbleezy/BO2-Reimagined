@echo off

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\english\en_code_post_gfx_mp.ff" ^
--load "%OAT_GAME%\zone\all\common_patch_mp.ff" ^
--load "%OAT_GAME%\zone\all\common_mp.ff" ^
--load "%OAT_GAME%\zone\all\frontend_patch.ff" ^
--load "%OAT_GAME%\zone\all\frontend.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" common_mp

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\zm_transit_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_transit.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" zm_transit

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\zm_nuked_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_nuked.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" zm_nuked

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\zm_highrise_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_highrise.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" zm_highrise

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\zm_prison_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_prison.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" zm_prison

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\zm_buried_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_buried.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" zm_buried

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\zm_tomb_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_tomb.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" zm_tomb

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%cd%\zone_source\common_mp.ff" ^
--load "%cd%\zone_source\zm_transit.ff" ^
--load "%cd%\zone_source\zm_nuked.ff" ^
--load "%cd%\zone_source\zm_highrise.ff" ^
--load "%cd%\zone_source\zm_prison.ff" ^
--load "%cd%\zone_source\zm_buried.ff" ^
--load "%cd%\zone_source\zm_tomb.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%" mod

if %ERRORLEVEL% NEQ 0 pause

del %cd%\zone_source\*.ff