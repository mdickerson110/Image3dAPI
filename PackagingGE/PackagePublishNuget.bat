@echo off
set AUTOPKG_FILE=%1
set VERSION_NUMBER=%2
set NUGET_REPO=%3

:: Change NuGet packaging version and project URL
python.exe ..\PackagingGE\SetAutopkgVersion.py %AUTOPKG_FILE% %VERSION_NUMBER% https://github.com/MedicalUltrasound/Image3dAPI/tree/%VERSION_NUMBER% 
IF %ERRORLEVEL% NEQ 0 exit /B 1

:: Package artifacts
powershell -NonInteractive -NoProfile -ExecutionPolicy ByPass Write-NuGetPackage %AUTOPKG_FILE%
IF %ERRORLEVEL% NEQ 0 exit /B 1

:: Publish artifact
if NOT DEFINED NUGET_REPO exit /B 0
:: Use timeout not dividable by 60 as work-around for https://nuget.codeplex.com/workitem/3917
%LOCALAPPDATA%\NuGet\NuGet.exe push *.nupkg -Source %NUGET_REPO% -Timeout 1201
IF %ERRORLEVEL% NEQ 0 exit /B 1
