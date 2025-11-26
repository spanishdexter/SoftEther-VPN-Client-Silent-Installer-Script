# SoftEther-VPN-Client-Silent-Installer-Script
A set of scripts that allow you to install SoftEther VPN Client on a Windows endpoint silently.

These batch files will allow an admin to install SoftEther VPN Clients on Windows endpoints silently utilizing the official Windows setup packages from https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.

This could allow an admin to use their favorite RMM or endpoint management software to install SoftEther VPN remotely without user interaction.

# Instructions
1. Download the files in the latest zip package release and extract the files to a folder location on your RMM server or a staging computer.
2. Go over to the SoftEther VPN Stable repo https://github.com/SoftEtherVPN/SoftEtherVPN_Stable and download the latest Windows client version, the file is usually named in this format: softether-vpnclient-v4.41-9787-rtm-2023.03.14-windows-x86_x64-intel.exe.
3. Copy it into the same folder where you extracted the scripts to, and rename it as vpnsetup.exe.
4. You can now take this set of files and distribute to your endpoints as the installer with your favorite RMM or endpoint management software (for example Microsoft SCCM/ConfigMgr).
5. Install.bat will perform the install process, and when SoftEther VPN Client is installed using this tool, uninstall.bat will be copied to C:\Program Files\SoftEther VPN Client installation folder on the endpoint, and the uninstall shortcuts in the start menu and in the Windows Control Panel's Add/Remove Programs utility will point to this batch file instead of vpnsetup.exe as a normal SoftEther ether install would do.
6. Uninstall.bat if executed will perform a silent uninstall of SoftEther leaving behind the config files in the C:\Program Files\SoftEther VPN Client folder.

Enjoy,
SpanishDexter

