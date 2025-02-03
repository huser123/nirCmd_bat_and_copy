@echo off

::--------------------------------------------------------------------------------
:: 1) A nircmd.exe helye
:: Ha a batch fájl mellé másoltad, írd simán: set NIRCMD=nircmd.exe
:: Külön könyvtárba telepítve (pl. "C:\Program Files\nircmd\nircmd.exe"):
:: set NIRCMD="C:\Program Files\nircmd\nircmd.exe"
set NIRCMD=nircmd.exe

:: 2) A fő könyvtár, ahová a screenshotok dátum szerinti mappákba kerülnek
set BASEFOLDER=Z:\screenshots
:: set BASEFOLDER=%USERPROFILE%\Documents\screenshots

:: 3) Ha nem létezik a BASEFOLDER, létrehozzuk
if not exist "%BASEFOLDER%" (
    mkdir "%BASEFOLDER%"
)

::--------------------------------------------------------------------------------
:: 4) Legeneráljuk a mai dátumot YYYY-MM-DD formában
:: (Feltételezzük, hogy a Windows regionális beállításai magyar formátumot adnak
:: pl. "2025. 02. 03." -> ez a FOR /F parancs lehet, hogy finomhangolást igényel,
:: ha más a formátum.)
for /f "tokens=1-4 delims=. " %%a in ("%date%") do (
    set YYYY=%%a
    set MM=%%b
    set DD=%%c
)

:: Ha pl. %date% = "2025. 02. 03." -> FOR ciklusban:
::   %%a=2025
::   %%b=02
::   %%c=03
::   %%d= (üres, a " " miatt)
:: Ez persze függ a Windows dátumformátumától.

set DATEMARK=%YYYY%-%MM%-%DD%

::--------------------------------------------------------------------------------
:: 5) Létrehozzuk a konkrét dátumos mappát (pl. Z:\screenshots\2025-02-03)
set DAYFOLDER=%BASEFOLDER%\%DATEMARK%
if not exist "%DAYFOLDER%" (
    mkdir "%DAYFOLDER%"
)

echo.
echo ------------------------------------------------------------------------------
echo Minden 3 masodpercben keszul egy screenshot ebbe a konyvtarba:
echo   %DAYFOLDER%
echo A leallitas modja: ablak bezarasa vagy Ctrl+C
echo ------------------------------------------------------------------------------

::--------------------------------------------------------------------------------
:: 6) Végtelen ciklus, 3 masodpercenként screenshot készítése
:LOOP

:: 6a) Legenerálunk egy "időbélyeg" részletet is (HHmmSS), hogy a fájlnevek egyediek legyenek
set HH=%time:~0,2%
set NN=%time:~3,2%
set SS=%time:~6,2%

:: Az éjféli 0 óra -> " 0" lehet, ezért lecseréljük a szóközt "0"-ra:
if "%HH:~0,1%"==" " set HH=0%HH:~1,1%

set TIMEMARK=%HH%%NN%%SS%

:: 6b) Screenshot készítése .jpg formátumban
:: A NirCmd a "savescreenshot" paranccsal a teljes Windows asztalt menti,
:: többmonitoros rendszer esetén "egyben" (nagyon széles) kép lesz.
set OUTFILE=%DAYFOLDER%\screenshot_%TIMEMARK%.jpg
%NIRCMD% savescreenshotfull "%OUTFILE%"

echo Keszult egy screenshot: %OUTFILE%

:: 6c) Várunk 3 másodpercet
timeout /t 3 >nul

goto LOOP
