REM SoftEther VPN Client Silent Install scripts.
REM by SpanishDexter
REM https://github.com/spanishdexter/SoftEther-VPN-Client-Silent-Installer-Script
REM https://www.jdsoft.rocks/
REM Version 1.0.0.0

REM kill any open instances of vpnclient_x64.exe
taskkill /im vpnclient_x64.exe /f /t

REM stop Softehter VPN service
NET STOP SEVPNCLIENT

REM remove Softether VPN service
SC DELETE SEVPNCLIENT

REM timeout
TIMEOUT /T 3 /NOBREAK

REM delete softether start menu folder
RMDIR /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client"

REM delete softether desktop icon for all users
DEL /Q "C:\Users\Public\Desktop\SoftEther VPN Client Manager.lnk"

REM timeout
TIMEOUT /T 3 /NOBREAK

REM delete softether files and folders
DEL /Q "C:\Program Files\SoftEther VPN Client\hamcore.se2"
DEL /Q "C:\Program Files\SoftEther VPN Client\setuplog.dat"
DEL /Q "C:\Program Files\SoftEther VPN Client\installer.cache"
DEL /Q "C:\Program Files\SoftEther VPN Client\vpnclient.exe"
DEL /Q "C:\Program Files\SoftEther VPN Client\vpnclient_x64.exe"
DEL /Q "C:\Program Files\SoftEther VPN Client\vpncmd.exe"
DEL /Q "C:\Program Files\SoftEther VPN Client\vpncmd_x64.exe"
DEL /Q "C:\Program Files\SoftEther VPN Client\vpncmgr.exe"
DEL /Q "C:\Program Files\SoftEther VPN Client\vpncmgr_x64.exe"
DEL /Q "C:\Program Files\SoftEther VPN Client\vpninstall.exe"
DEL /Q "C:\Program Files\SoftEther VPN Client\vpnsetup.exe"
DEL /Q "C:\Program Files\SoftEther VPN Client\vpnsetup_x64.exe"
DEL /Q "C:\Program Files\SoftEther VPN Client\vpnweb.cab"

REM remove SoftEther Uninstall registry key
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient /f