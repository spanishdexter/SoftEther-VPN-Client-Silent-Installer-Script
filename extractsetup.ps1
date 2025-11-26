#SoftEther VPN Client Silent Install scripts.
#by SpanishDexter
#https://github.com/spanishdexter/SoftEther-VPN-Client-Silent-Installer-Script
#https://www.jdsoft.rocks/
#Version 1.0.0.0

#get script path
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

#stop softether service
Stop-Service -Name "SEVPNCLIENT" -Force

#shortcutdata path
$shortcutdata = "$scriptPath\shortcutdata"

#get install date
$InstallDate = Get-Date -Format "yyyy/MM/dd"

#get file version information from vpnsetup.exe
$fileversionraw = (Get-Item "$scriptPath\vpnsetup.exe").VersionInfo.FileVersion
$fileversionraw = $fileversionraw.Replace(" ", "")
$fileversionraw = $fileversionraw.Replace(",", ".")
$fileversion = $fileversionraw.Replace("0.", "")

#set error exit flag to default value of 1 - which mean errors until proven otherwise where it will be turned into 0 if all clear
$errorflag = 1

#start the softether installer process to get the files
Start-Process "$scriptPath\vpnsetup.exe"

#wait 10 seconds for files to copy to $env:TEMP\VPN_XXXX
Start-Sleep -Seconds 10

#get reference list for files needed for setup in catalog-------------------------------------

#get list of files needed for installer
$catalog = ("hamcore.se2", "installer.cache", "lang.config", "vpnclient.exe", "vpnclient_x64.exe", "vpncmd.exe", "vpncmd_x64.exe", "vpncmgr.exe", "vpncmgr_x64.exe", "vpninstall.exe", "vpnsetup.exe", "vpnsetup_x64.exe", "vpnweb.cab", "install_src.dat")

#-------------------------------------------------------------------------------------------------

#Get files from vpnsetup.exe while open----------------------------------------------------------------

#get temp folders where vpnsetup.exe extracted files in two folders starting with VPN_ and then a 4 digit hex value (example VPN_84FD) - put lastest 2 into $setupfolderlist
$setupfolderlist = Get-ChildItem -Path "$env:TEMP" -Directory -Recurse | Where-Object { $_.Name -match "VPN_" } | Sort-Object LastWriteTime -Descending | Select-Object -First 2

#get just folder names
$setupfoldernames = $setupfolderlist.Name

# Iterate through the folder list until vpnsetup.exe is found
foreach ($folder in $setupfoldernames) {

    #create the foldername to check
    $foldertocheck = "$env:TEMP\$folder"

    #check if vpnsetup.exe exists in current directory listing
    $fileresults = Get-ChildItem -Path $foldertocheck | Where-Object { $_.Name -match "vpnsetup.exe" }
    
    #if $fileresults has a hit for vpnsetup.exe being found and the $filefound value is not null
    if ($fileresults -ne $null) {

    #get the proper folder name
    $vpndirectory = $fileresults.Directory.Name
    
    #get valid folder into $validfoldername
    $validfolder = "$env:TEMP\$vpndirectory"

    #set error flag to 0
    $errorflag = 0

    }

}

#FILE COPY PROCESS -----------------------------------------------------------------

#create the softether program files folder if it does not exist
$folderPath = "C:\Program Files\SoftEther VPN Client"

if (-not (Test-Path -Path $folderPath -PathType Container)) {
    New-Item -Path $folderPath -ItemType Directory
}

# copy the files to "C:\Program Files\SoftEther VPN Client"
foreach ($file in $catalog) {

#target folder
$targetfolder = "$validfolder\$file"

#copy the current $file and overwrite any existing ones in C:\Program Files\SoftEther VPN Client
Copy-Item -Path $targetfolder -Destination "C:\Program Files\SoftEther VPN Client" -Force
    
}

#creat variable for uninstall tool location
$uninstallbatchfile = "$scriptPath\uninstall.bat"

#copy uninstall batch file
Copy-Item -Path $uninstallbatchfile -Destination "C:\Program Files\SoftEther VPN Client" -Force

#-----------------------------------------------------------------------------------


#CREATE ADDITONAL FOLDERS IF THEY DONT EXIST--------------------------------------------

#create the backup.vpn_client.config folder if it does not exist
$folderPath = "C:\Program Files\SoftEther VPN Client\backup.vpn_client.config"

if (-not (Test-Path -Path $folderPath -PathType Container)) {
    New-Item -Path $folderPath -ItemType Directory
}

#create the client_log folder if it does not exist
$folderPath = "C:\Program Files\SoftEther VPN Client\client_log"

if (-not (Test-Path -Path $folderPath -PathType Container)) {
    New-Item -Path $folderPath -ItemType Directory
}

#create the C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client folder if it does not exist
$folderPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client"

if (-not (Test-Path -Path $folderPath -PathType Container)) {
    New-Item -Path $folderPath -ItemType Directory
}

#create the Administrative Tools folder if it does not exist
$folderPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client\Administrative Tools"

if (-not (Test-Path -Path $folderPath -PathType Container)) {
    New-Item -Path $folderPath -ItemType Directory
}

#create the Configuration Tools folder if it does not exist
$folderPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client\Configuration Tools"

if (-not (Test-Path -Path $folderPath -PathType Container)) {
    New-Item -Path $folderPath -ItemType Directory
}

#create the Language Settings folder if it does not exist
$folderPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client\Language Settings"

if (-not (Test-Path -Path $folderPath -PathType Container)) {
    New-Item -Path $folderPath -ItemType Directory
}


#---------------------------------------------------------------------------------------

#COPY SHORTCUT FILES TO START MENU AND DESKTOP--------------------------------------

#shortcut files list
$scatalog = ("Manage Remote Computer's SoftEther VPN Client.lnk", "SoftEther VPN Client Manager.lnk", "SoftEther VPN Command Line Utility (vpncmd).lnk")

# copy the files to "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client"
foreach ($shortcutfile in $scatalog) {

#define the shortcut folder path
$targetshoutcutfolderpath = "$shortcutdata\$shortcutfile"

#copy the current $shortcutfile and overwrite any existing ones in C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client
Copy-Item -Path $targetshoutcutfolderpath -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client" -Force
    
}

#copy folders
#shortcut folders and their contents from fcatalog
$fcatalog = ("Administrative Tools", "Configuration Tools", "Language Settings")

# copy the folders to "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client"
foreach ($shortcutfolder in $fcatalog) {

#define shortcut folder for start menu
$targetstartmenupath = "$shortcutdata\$shortcutfolder"

#copy the current $folder and overwrite any existing ones in C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client
Copy-Item -Path $targetstartmenupath -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\SoftEther VPN Client" -Recurse -Force
    
}

#define desktop shortcut path
$targetdesktoppath = "$shortcutdata\SoftEther VPN Client Manager.lnk"

#copy shortcut to desktop - SoftEther VPN Client Manager.lnk to C:\Users\Public\Desktop
Copy-Item -Path $targetdesktoppath -Destination "C:\Users\Public\Desktop" -Force

#-----------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------

#-----FIND AND KILL VPNSETUP.EXE---------------------------------------------------------------

        Get-Process | Where-Object { $_.Path -eq "$validfolder\vpnsetup.exe" } | Stop-Process -Force

#----------------------------------------------------------------------------------------------

#CLEAN UP FILES -----------------------------------------------------------------

#clean up found temp folders

# Iterate through the folder list and delete each
foreach ($folder in $setupfoldernames) {

#delete the folder
Remove-Item -Path "$env:TEMP\$folder" -Recurse -Force

}


#--------------------------------------------------------------------------------

#Install SoftEther Service
Start-Process -FilePath "C:\Program Files\SoftEther VPN Client\vpnclient_x64.exe" -ArgumentList "/install"

#Wait 10 terminating vpnclient_x64.exe process
Start-Sleep -Seconds 10

#stop vpnclient_x64.exe process
Get-Process | Where-Object { $_.Path -eq "C:\Program Files\SoftEther VPN Client\vpnclient_x64.exe" } | Stop-Process -Force

#start softether service
Start-Service -Name "SEVPNCLIENT"



#--------------------------------------------------------------------------------------------------------

#REGISTER THE OFFICAL UNINSTALL TOOL IN CONTROL PANEL------------------------------------------------------------

#add SoftEther registry key
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient" -Force

#DisplayName
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient" -Name "DisplayName" -Value "SoftEther VPN Client" -PropertyType "String" -Force

#DisplayIcon
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient" -Name "DisplayIcon" -Value '"C:\Program Files\SoftEther VPN Client\vpnsetup.exe",6' -PropertyType "String" -Force

#DisplayVersion
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient" -Name "DisplayVersion" -Value $fileversion -PropertyType "String" -Force

#InstallDate
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient" -Name "InstallDate" -Value $InstallDate -PropertyType "String" -Force

#UninstallString
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient" -Name "UninstallString" -Value '"C:\Program Files\SoftEther VPN Client\uninstall.bat"' -PropertyType "String" -Force

#NoModify
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient" -Name "NoModify" -Value 1 -PropertyType "DWord" -Force

#NoRepair
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient" -Name "NoRepair" -Value 1 -PropertyType "DWord" -Force

#Publisher
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient" -Name "Publisher" -Value "SoftEther VPN Project" -PropertyType "String" -Force

#URLInfoAbout
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient" -Name "URLInfoAbout" -Value "http://selinks.org/" -PropertyType "String" -Force

#URLUpdateInfo
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient" -Name "URLUpdateInfo" -Value "http://selinks.org/" -PropertyType "String" -Force

#HelpLink
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\softether_sevpnclient" -Name "HelpLink" -Value "http://selinks.org/" -PropertyType "String" -Force
