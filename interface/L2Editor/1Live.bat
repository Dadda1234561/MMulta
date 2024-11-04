@echo off

del Interface.u
del NWindow.u

taskkill /F /IM l2.exe
ucc make -nobind

UCC editor.stripsource Interface.u --nobind
ucc editor.stripsourcecommandlet Interface.u --nobind

COPY "Interface.u" "D:\Games\MultImperia\system"
start D:\Games\MultImperia\system\L2.exe
pause