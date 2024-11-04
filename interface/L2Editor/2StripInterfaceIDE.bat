@echo off
setlocal

UCC editor.stripsource Interface.u --nobind
if %ERRORLEVEL% NEQ 0 (
    echo Step 1. Failed to strip Interface.u.
    goto :eof
)
ucc editor.stripsourcecommandlet Interface.u --nobind
if %ERRORLEVEL% NEQ 0 (
    echo Step 2. Failed to compile Interface.u.
    goto :eof
)
endlocal