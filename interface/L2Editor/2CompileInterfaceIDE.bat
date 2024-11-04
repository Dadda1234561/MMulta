@echo off
setlocal
SET "PROCESS_NAME=l2.exe"
SET "SYSTEM_FOLDER=D:\GameClients\418\system"

cd /d "E:\Multiproff388Scripts\interface\L2Editor"

del Interface_old.u
del NWindow.u

ren Interface.u Interface_old.u

ucc make -NoBind
if %ERRORLEVEL% NEQ 0 (
    echo Failed to compile Interface.u.
    goto :eof
)
echo Terminating %PROCESS_NAME%...
taskkill /f /im %PROCESS_NAME%

if "%ERRORLEVEL%"=="0" (
    echo %PROCESS_NAME% terminated successfully.
) else (
    echo Failed to terminate %PROCESS_NAME%.
)
COPY /Y "Interface.u" "%SYSTEM_FOLDER%"
START "" "%SYSTEM_FOLDER%\L2.exe" -IP=127.0.0.1
endlocal