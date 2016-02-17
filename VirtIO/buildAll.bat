@echo off
:
: Set global parameters: 
:

: Use Windows 7 DDK
if "%DDKVER%"=="" set DDKVER=7600.16385.1

: By default DDK is installed under C:\WINDDK, but it can be installed in different location
if "%DDKISNTALLROOT%"=="" set DDKISNTALLROOT=C:\WINDDK\
set BUILDROOT=%DDKISNTALLROOT%%DDKVER%
set X64ENV=x64
if "%DDKVER%"=="6000" set X64ENV=amd64

if not "%1"=="" goto parameters_here
echo no parameters specified, rebuild all
call clean.bat
for %%A in (WXp WNet WLH Win7 Win8 Win10) do for %%B in (32 64) do call :%%A_%%B

goto :eof
:parameters_here

:nextparam
if "%1"=="" goto :eof
goto %1
:continue
shift
goto nextparam

:WLH_32
set DDKBUILDENV=
setlocal
pushd %BUILDROOT%
call %BUILDROOT%\bin\setenv.bat %BUILDROOT% fre WLH
popd
build -cZg
endlocal
goto continue

:WLH_64
set DDKBUILDENV=
setlocal
pushd %BUILDROOT%
call %BUILDROOT%\bin\setenv.bat %BUILDROOT% %X64ENV% fre WLH
popd
build -cZg
endlocal
goto continue

:WNet_32
set DDKBUILDENV=
setlocal
pushd %BUILDROOT%
call %BUILDROOT%\bin\setenv.bat %BUILDROOT% fre WNET
popd
build -cZg
endlocal
goto continue

:WNet_64
set DDKBUILDENV=
setlocal
pushd %BUILDROOT%
call %BUILDROOT%\bin\setenv.bat %BUILDROOT% %X64ENV% fre WNET
popd
build -cZg
endlocal
goto continue

:WXp_32
set DDKBUILDENV=
setlocal
pushd %BUILDROOT%
call %BUILDROOT%\bin\setenv.bat %BUILDROOT% fre WXP
popd
build -cZg
endlocal
goto continue

:WXp_64
goto continue

:Win7_32
call :BuildVS2015 "Win7 Release|x86" buildfre_win7_x86.log
goto continue

:Win7_64
set DDKBUILDENV=
setlocal
pushd %BUILDROOT%
call %BUILDROOT%\bin\setenv.bat %BUILDROOT% %X64ENV% fre WIN7
popd
build -cZg
endlocal
goto continue


:Vista
set DDKBUILDENV=
setlocal
pushd %BUILDROOT%
call %BUILDROOT%\bin\setenv.bat %BUILDROOT% fre WIN7
popd
build -cZg
endlocal
goto continue

:Vista64
set DDKBUILDENV=
setlocal
pushd %BUILDROOT%
call %BUILDROOT%\bin\setenv.bat %BUILDROOT% %X64ENV% fre Wlh
popd
build -cZg
endlocal
goto continue

:Win2003
set DDKBUILDENV=
setlocal
pushd %BUILDROOT%
call %BUILDROOT%\bin\setenv.bat %BUILDROOT% fre WNET
popd
build -cZg
endlocal
goto continue

:Win200364
set DDKBUILDENV=
setlocal
pushd %BUILDROOT%
call %BUILDROOT%\bin\setenv.bat %BUILDROOT% %X64ENV% fre WNET
popd
build -cZg
endlocal
goto continue

:XP
set DDKBUILDENV=
setlocal
pushd %BUILDROOT%
call %BUILDROOT%\bin\setenv.bat %BUILDROOT% fre WXP
popd
build -cZg
endlocal
goto continue

:Win8
call :BuildWin8 "Win8 Release|Win32" buildfre_win8_x86.log
goto continue

:Win8_64
call :BuildWin8 "Win8 Release|x64" buildfre_win8_amd64.log
goto continue

:BuildWin8
call ..\tools\callVisualStudio.bat 12 VirtioLib-win8.vcxproj /Rebuild "%~1" /Out %2
goto :eof
