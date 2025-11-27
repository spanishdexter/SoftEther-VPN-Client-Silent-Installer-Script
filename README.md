# SoftEther-VPN-Client-Silent-Installer-Script
A set of scripts that allow you to install SoftEther VPN Client on a Windows endpoint silently.

These batch files will allow an admin to install SoftEther VPN Clients on Windows endpoints silently utilizing the official Windows setup packages from https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.

This could allow an admin to use their favorite RMM or endpoint management software to install SoftEther VPN remotely without user interaction.

# Instructions
1. Download the files in the latest zip package release and extract the files to a folder location on your RMM server or a staging computer.
2. Go over to the SoftEther VPN Stable repo https://github.com/SoftEtherVPN/SoftEtherVPN_Stable and download the latest Windows client version, the file is usually named in this format: softether-vpnclient-v4.41-9787-rtm-2023.03.14-windows-x86_x64-intel.exe.
3. Copy it into the same folder where you extracted the scripts to, and rename it as vpnsetup.exe.
4. You can now take this set of files and distribute to your endpoints as the installer with your favorite RMM or endpoint management software (for example Microsoft SCCM/ConfigMgr).
5. Install.bat will perform the install process, and when SoftEther VPN Client is installed using this tool, uninstall.bat will be copied to C:\Program Files\SoftEther VPN Client installation folder on the endpoint, and the uninstall shortcuts in the start menu and in the Windows Control Panel's Add/Remove Programs utility will point to this batch file instead of vpnsetup.exe as a normal SoftEther install would do.
6. Uninstall.bat if executed will perform a silent uninstall of SoftEther leaving behind the config files in the C:\Program Files\SoftEther VPN Client folder.

Enjoy,
SpanishDexter

# How does it work?

 - Install.bat will execute the extractsetup.ps1 PowerShell script.
 - Extractsetup.ps1 launches the official SoftEther installer, vpnsetup.exe in the same folder as it. When vpnsetup.exe is running, it is sitting idle at the begining of the official install wizard. 
 - While the official installer is idle at the wizard, it also copies the files that it will install to a temporary folder in %temp%, with a folder name starting with VPN_ and 4 hexidecimal numbers. The extractsetup.ps1 script takes advantage of this, and while vpnsetup.exe is open, it copies the needed files to C:\Program Files\SoftEther VPN Client. A sleep command gives some time for files to copy before the script needs to proceed.
 - The script will then copy the official start menu and desktop shortcuts from the shortcutdata folder to their proper locations in C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client. And it will copy a desktop shortcut to vpncmgr_x64.exe on the all users desktopm, like the official installer does (C:\Users\Public\Desktop).
 - The script will then copy uninstall.bat to C:\Program Files\SoftEther VPN Client, register itself as an installed program in the Windows registry and replace the uninstall pointer in Add and Remove Programs from vpnsetup.exe with uninstall.bat. The copied uninstall shortcut in the start menu points here as well.
 - The script terminates the vpnsetup.exe process now that it is no longer needed, and clears out the VPN_XXXX folders in %temp%.
 - The script then runs the official binary, vpnclient_x64.exe with the /install switch, this installs SoftEther VPN Client as a service.

