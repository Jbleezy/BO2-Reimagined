@echo off

set GAME_BASE=D:\Games\Steam\steamapps\common\Call of Duty Black Ops II
set OAT_BASE=C:\OpenAssetTools
set MOD_BASE=%cd%
"%OAT_BASE%\Linker.exe" ^
--load "%GAME_BASE%\zone\all\zm_tomb.ff" ^
--load "%GAME_BASE%\zone\all\zm_buried.ff" ^
--load "%GAME_BASE%\zone\all\zm_prison.ff" ^
--load "%GAME_BASE%\zone\all\common_mp.ff" ^
--load "%GAME_BASE%\zone\all\frontend.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%MOD_BASE%" ^
--source-search-path "%MOD_BASE%\zone_source" ^
--output-folder "%MOD_BASE%" mod

if %ERRORLEVEL% NEQ 0 pause