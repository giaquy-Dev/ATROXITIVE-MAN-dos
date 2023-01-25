@shift /0
echo off 
cls
chcp 65001 >nul
color a
mode con lines=20 cols=44 >nul
:main
cls
title Atrexitive's Skid Radar!
setlocal ENABLEDELAYEDEXPANSION
set webclient=webclient
if exist "%temp%\%webclient%.vbs" del "%temp%\%webclient%.vbs" /f /q /s >nul
if exist "%temp%\response.txt" del "%temp%\response.txt" /f /q /s >nul
:top
echo.
echo            ╔═════════════════════╗
echo            ║ 1. View Your IP     ║
echo            ║ 2. IP LOOKUP        ║
echo            ╚═════════════════════╝
echo.
set /p bot=[Atrex]:  
if %bot% == 1 echo sUrl = "http://ipinfo.io/json" > %temp%\%webclient%.vbs & goto localip
if %bot% == 2 goto Lookup
goto top
:Lookup
cls
set ip=127.0.0.1
set /p ip=[IP]: 
echo sUrl = "http://ipinfo.io/%ip%/json" > %temp%\%webclient%.vbs
:localip
cls
echo set oHTTP = CreateObject("MSXML2.ServerXMLHTTP.6.0") >> %temp%\%webclient%.vbs
echo oHTTP.open "GET", sUrl,false >> %temp%\%webclient%.vbs
echo oHTTP.setRequestHeader "Content-Type", "application/x-www-form-urlencoded" >> %temp%\%webclient%.vbs
echo oHTTP.setRequestHeader "Content-Length", Len(sRequest) >> %temp%\%webclient%.vbs
echo oHTTP.send sRequest >> %temp%\%webclient%.vbs
echo HTTPGET = oHTTP.responseText >> %temp%\%webclient%.vbs
echo strDirectory = "%temp%\response.txt" >> %temp%\%webclient%.vbs
echo set objFSO = CreateObject("Scripting.FileSystemObject") >> %temp%\%webclient%.vbs
echo set objFile = objFSO.CreateTextFile(strDirectory) >> %temp%\%webclient%.vbs
echo objFile.Write(HTTPGET) >> %temp%\%webclient%.vbs
echo objFile.Close >> %temp%\%webclient%.vbs
echo Wscript.Quit >> %temp%\%webclient%.vbs
start %temp%\%webclient%.vbs
set /a requests=0
echo.
rem echo Waiting for API response. . .
echo  Looking up IP Address. . .
:checkresponseexists
set /a requests=%requests% + 1
if %requests% gtr 7 goto failed
IF EXIST "%temp%\response.txt" (
goto response_exist
) ELSE (
ping 127.0.0.1 -n 2 -w 1000 >nul
goto checkresponseexists
)
:failed
taskkill /f /im wscript.exe >nul
del "%temp%\%webclient%.vbs" /f /q /s >nul
echo.
echo Did not receive a response from the API.
echo.
pause
goto menu
:response_exist
cls
echo.
for /f "delims= 	" %%i in ('findstr /i "," %temp%\response.txt') do (
	set data=%%i
	set data=!data:,=!
	set data=!data:""=Not Listed!
	set data=!data:"=!
	set data=!data:ip:=IP:           !
	set data=!data:hostname:=Hostname:     !
	set data=!data:org:=ISP:	        !
	set data=!data:city:=City:	        !
	set data=!data:region:=State:	!
	set data=!data:country:=Country:      !
	set data=!data:postal:=Postal:	!
	set data=!data:loc:=Location:	!
	set data=!data:timezone:=Timezone:	!
	echo !data!
)
echo.
del "%temp%\%webclient%.vbs" /f /q /s >nul
del "%temp%\response.txt" /f /q /s >nul
pause
cls
goto top
if '%ip%'=='' goto top
goto iplookup
goto top
