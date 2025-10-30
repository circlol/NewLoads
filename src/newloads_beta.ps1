#region Initialization
<# FOR USE OF PARAMETERS REMOVE OR COMMENT OUT THIS LINE AND THE ONE BELOW
[CmdletBinding(SupportsShouldProcess = $true)]
param (
	[Alias("NR")]
	[Switch]$NoRestart = $false,
	[Alias("ADW")]
	[Switch]$AdwCleaner = $false,
	[Alias("BL")]
	[Switch]$SkipBitlocker = $false,
	[Alias("BR")]
	[Switch]$SkipBranding = $false,
	[Alias("CL")]
	[Switch]$SkipCleanup = $false,
	[Alias("D")]
	[Switch]$SkipDebloat = $false,
	[Alias("P")]
	[Switch]$SkipPrograms = $false,
	[Alias("RP")]
	[Switch]$SkipRestorePoint = $false,
	[Alias("O")]
	[Switch]$SkipOptimization = $false,
	[Alias("U")]
	[Switch]$Undo = $false
)
REMOVE OR COMMENT OUT THIS LINE AS WELL #> 
#endregion
#region Beginning

<##############################################################################################################

#.NOTES
# Author         : Circlol
# GitHub         : https://github.com/Circlol/NewLoads
# Version        : 1.08.02

#	Changelog: 

# 1.08.02
 	- Implemented Skip param for each major section, listed below:
		-ADW  or  -AdwCleaner  			(default: skip)
		-BL   or  -SkipBitlocker		(default: run)
		-BR   or  -SkipBranding			(default: run)
		-CL   or  -SkipCleanup			(default: run)
		-D	  or  -SkipDebloat			(default: run)
		-P    or  -SkipPrograms			(default: run)
		-RP   or  -SkipRestorePoint		(default: run)
		-O    or  -SkipOptimization		(default: run)
		-NR   or  -NoRestart			(default: off)
		-U    or  -Undo					(default: off)
 	- Added undo param to functions:
		Optimize-General
		Optimize-Performance
		Optimize-Privacy
		Optimize-Security
		Optimize-Service
		Optimize-SSD
		Optimize-TaskScheduler
		Optimize-WindowsOptional
		Set-Branding
		Set-StartMenu
		Set-Taskbar
		Set-Wallpaper
		Start-Debloat
 	- Implemented ShouldProcess
 	- Enhanced colors
   	- Added Always Show Scroll Bars to Optimize-General #Section Win11 Tweaks
	- Started development on Get-MissingDriver
 		- Prompt user with missing driver
	- Added Start-Activation and Get-ActivationStatus - probably will not be enabled in release.
 		- Checks if system is licensed, can activate using MAS
 	- Temporarily disabled Get-LastCheckForUpdate
	- Changed wallpaper -> https://raw.githubusercontent.com/circlol/NewLoads/main/src/assets/wallpaper.jpg
	- Added Show-SkipQuestion function
	- Added a driver check to assure everything is in. Under function Get-MissingDriver
	- Added a search for timezone on local system matching specified zone.

# 1.08
	- Adjusted custom Write- functions to calculate current width and fill/center in terminal
   	- Split variables into categorized hashtables
 		-	Fixed Get-Status failed action
   	- Created Write-Center function
   	- Write-Title, Write-Break, Write-TitleCounter, Write-Section all center text based off current window width

##############################################################################################################>
Clear-Host
$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue
#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[Console]::Title = "New Loads"
[Console]::ForegroundColor = "White"
[Console]::BackgroundColor = 'Black'
$VerbosePreference = $False
$Params = @()
$NewLoads = [System.IO.DirectoryInfo]::new("$Env:temp\New Loads")
$NewLoadsExists = Test-Path $NewLoads -ErrorAction SilentlyContinue
if ($PSBoundParameters.Count -gt 0) { $PSBoundParameters.Keys | ForEach-Object { $Params += $_ } }
If (!$NewLoadsExists) { New-Item $NewLoads -ItemType Directory }
Clear-Host

#endregion
#region Variables
$Variables = @{
	"ProgramVersion"  			= "v1.08.02"
	"LastUpdate" 	   			= "03/12/2024"
	"NewLoadsURL"				= "run.newloads.ca"
	"Creator"					= "Mike Ivison"
	"TextColor"		  			= "Yellow"
	"BackgroundColor"  			= "Black"
	"AccentColor1"	   			= "Blue"
	"AccentColor2"	   			= "White"
	"AccentColor3"	   			= "Cyan"
	"LogoColor"	       			= "Yellow"
	
	"Time"			   			= Get-Date -UFormat %Y%m%d
	"MaxTime"		   			= 260101
	"MinTime"		   			= 240710
	"Counter"		  			= 1
	"MaxLength"	       			= 10
	"Win11"		       			= 22000
	"Win22H2"		   			= 22621
	"Win23H2"		   			= 22631
	"MinBuildNumber"   			= 19042
	"BuildNumber"	   			= [System.Environment]::OSVersion.Version.Build
	"OSVersion"	       			= (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
	"Connected"	      			= "Internet"
	
	# Local File Paths
	"StartBin"					= "$newloads\start2.bin"
	"StartBinDefault"  			= "$Env:SystemDrive\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"
	"StartBinCurrent"  			= [System.IO.DirectoryInfo]::new("$Env:LocalAppData\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState")
	"LayoutFile"	   			= [System.IO.DirectoryInfo]::new("$Env:LocalAppData\Microsoft\Windows\Shell\LayoutModification.xml")
	"CommonApps"	   			= [System.IO.DirectoryInfo]::new("$Env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs")
	"wpDest"		   			= [System.IO.DirectoryInfo]::new("$env:SystemRoot\Resources\Themes\mother.jpg")
	"ErrorLog"		   			= [System.IO.DirectoryInfo]::new("$Env:UserProfile\Desktop\New Loads Errors.txt")
	"Log"			   			= [System.IO.DirectoryInfo]::new("$Env:UserProfile\Desktop\New Loads.txt")
	"PathToOffice64"   			= [System.IO.DirectoryInfo]::new("$env:ProgramFiles\Microsoft Office 15")
	"PathToOffice86"   			= [System.IO.DirectoryInfo]::new("${env:ProgramFiles(x86)}\Microsoft Office")
	"adwDestination"   			= [System.IO.DirectoryInfo]::new("$NewLoads\adwcleaner.exe")
	"WallpaperPath"    			= [System.IO.DirectoryInfo]::new("$NewLoads\mother.jpg")
	"SaRA"			   			= [System.IO.DirectoryInfo]::new("$NewLoads\SaRA.zip")
	"Sexp"			  	 		= [System.IO.DirectoryInfo]::new("$NewLoads\SaRA")
	
	# - Shortcuts
	"Shortcuts"	       			= @(
								[System.IO.DirectoryInfo]::new("$Env:USERPROFILE\Desktop\Microsoft Edge.lnk")
								[System.IO.DirectoryInfo]::new("$Env:PUBLIC\Desktop\Microsoft Edge.lnk")
								[System.IO.DirectoryInfo]::new("$Env:PUBLIC\Desktop\Adobe Reader.lnk")
								[System.IO.DirectoryInfo]::new("$Env:PUBLIC\Desktop\Acrobat Reader DC.lnk")
								[System.IO.DirectoryInfo]::new("$Env:PUBLIC\Desktop\VLC Media Player.lnk")
								[System.IO.DirectoryInfo]::new("$Env:PUBLIC\Desktop\Zoom.lnk")
								)
	
	"MAS"			   			= "mas.newloads.ca"
	

	"StartBin2URL"     			= "https://github.com/circlol/NewLoads/raw/main/src/assets/start2.bin"
	
	"PackagesRemoved"  			= @()
	"Removed"		  			= 0
	"FailedPackages"   			= 0
	"PackagesNotFound" 			= 0
	"CreatedKeys"	   			= 0
	"FailedRegistryKeys" 		= 0
	"ModifiedRegistryKeys" 		= 0
	
	
	#Wallpaper
	"CurrentWallpaper" 			= (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper
	
	#Office Removal
	"OfficeCheck"	   			= $false
	"Office32"		   			= $false
	"Office64"		   			= $false
	"UsersFolder"	   			= "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
	"ThisPC"		   			= "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
	
	
	"TimeoutScreenBattery" 		= 5
	"TimeoutScreenPluggedIn" 	= 10
	"TimeoutStandByBattery" 	= 15
	"TimeoutStandByPluggedIn" 	= 30
	"TimeoutDiskBattery" 		= 15
	"TimeoutDiskPluggedIn" 		= 30
	"TimeoutHibernateBattery" 	= 15
	"TimeoutHibernatePluggedIn" = 30
	
	
	"EnableServicesOnSSD" = @("SysMain", "WSearch")
}
$Errors = @{
	"errorMessage1"   = "
        @|\@@                                                                                    `
        -  @@@@                    New Loads requires a minimum Windows 10 version of 20H2 (19042).`
       /7   @@@@                                                                                 `
      /    @@@@@@                             Please upgrade your OS before continuing.          `
      \-' @@@@@@@@`-_______________                                                              `
       -@@@@@@@@@             /    \                                                             `
  _______/    /_       ______/      |__________-                          /\_____/\              `
 /,__________/  `-.___/,_____________----------_)                Meow.    /  o   o  \            `
                                                                        ( ==  ^  == )             `
                                                                         )         (              `
                                                                        (           )             `
                                                                       ( (  )   (  ) )            `
                                                                      (__(__)___(__)__)          `n`n"
	"errorMessage2"   = "
        @|\@@                                                                                    `
        -  @@@@                             New Loads REQUIRES administrative privileges         `
       /7   @@@@                                                                                 `
      /    @@@@@@                             for core features to function correctly.           `
      \-' @@@@@@@@`-_______________                                                              `
       -@@@@@@@@@             /    \                                                             `
  _______/    /_       ______/      |__________-                          /\_____/\              `
 /,__________/  `-.___/,_____________----------_)                Meow.    /  o   o  \            `
                                                                        ( ==  ^  == )            `
                                                                         )         (             `
                                                                        (           )            `
                                                                       ( (  )   (  ) )           `
                                                                      (__(__)___(__)__)          `n`n"
	"errorMessage3"   = "
        @|\@@                                                                                    `
        -  @@@@                             $($CustomTextLine1) `
       /7   @@@@                                                                                 `
      /    @@@@@@                             $($CustomTextLine2) `
      \-' @@@@@@@@`-_______________                                                              `
       -@@@@@@@@@             /    \                                                             `
  _______/    /_       ______/      |__________-                          /\_____/\              `
 /,__________/  `-.___/,_____________----------_)                Meow.    /  o   o  \            `
                                                                        ( ==  ^  == )            `
                                                                         )         (             `
                                                                        (           )            `
                                                                       ( (  )   (  ) )           `
                                                                      (__(__)___(__)__)          `n`n"
}
$OptionalFeatures = @{
	$SleepSettings = @(
		"Monitor-Timeout-AC $Variables.TimeoutScreenPluggedIn",
		"Monitor-Timeout-DC $Variables.TimeoutScreenBattery",
		"Standby-Timeout-AC $Variables.TimeoutStandByPluggedIn",
		"Standby-Timeout-DC $Variables.TimeoutStandByBattery",
		"Disk-Timeout-AC $Variables.TimeoutDiskPluggedIn",
		"Disk-Timeout-DC $Variables.TimeoutDiskBattery",
		"Hibernate-Timeout-AC $Variables.TimeoutHibernatePluggedIn",
		"Hibernate-Timeout-DC $Variables.TimeoutHibernateBattery"
	)

	$SleepText = @(
		"Monitor Timeout to AC: $($Variables.TimeoutScreenPluggedIn)",
		"Monitor Timeout to DC: $($Variables.TimeoutScreenBattery)",
		"Standby Timeout to AC: $($Variables.TimeoutStandByPluggedIn)",
		"Standby Timeout to DC: $($Variables.TimeoutStandByBattery)",
		"Disk Timeout to AC: $($Variables.TimeoutDiskPluggedIn)",
		"Disk Timeout to DC: $($Variables.TimeoutDiskBattery)",
		"Hibernate Timeout to AC: $($Variables.TimeoutHibernatePluggedIn)",
		"Hibernate Timeout to DC: $($Variables.TimeoutHibernateBattery)"
	)
	# - Optional Features
	"ToDisable"													    = @(
		#"FaxServicesClientPackage"             # Windows Fax and Scan
		#"Printing-PrintToPDFServices-Features" # Microsoft Print to PDF
		"IIS-*" # Internet Information Services
		"Internet-Explorer-Optional-*" # Internet Explorer
		"LegacyComponents" # Legacy Components
		"MediaPlayback" # Media Features (Windows Media Player)
		"MicrosoftWindowsPowerShellV2" # PowerShell 2.0
		"MicrosoftWindowsPowershellV2Root" # PowerShell 2.0
		"Printing-XPSServices-Features" # Microsoft XPS Document Writer
		"WorkFolders-Client" # Work Folders Client
	)
	"ToEnable"													    = @(
		"NetFx3" # NET Framework 3.5
		"NetFx4-AdvSrvs" # NET Framework 4
		"NetFx4Extended-ASPNET45" # NET Framework 4.x + ASPNET 4.x
	)
}
$Registry = @{

	# Initialize all Path variables used to Registry Tweaks
	"TaskBarEndTask"							= "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings"
	"EdgeUI" 									= "HKCU:\Software\Policies\Microsoft\Windows\EdgeUI"
	"PathToLMCurrentVersion"					= "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
	"PathToLMOldDotNet"							= "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319"
	"PathToLMPoliciesToWifi"					= "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi"
	"PathToLMConsentStoreAD"					= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics"
	"PathToLMConsentStoreUAI"					= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation"
	"SecurityPath"								= "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BLOCK_CROSS_PROTOCOL_FILE_NAVIGATION"
	"RegLocationLM"								= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	"RegLocationCU"								= "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	"PathToLMConsentStoreUN"					= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener"
	"PathToLMDeviceMetaData"					= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata"
	"PathToLMEventKey"							= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey"
	"PathToLMDriverSearching"					= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching"
	#"PathToRegExplorerLocalMachine"			 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
	"PathToHide3DObjects"						= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	"PathToLMPoliciesTelemetry2"				= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	"PathToLMPoliciesExplorer"					= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	"PathToLMPoliciesSystem"					= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
	"PathToLMWindowsTroubleshoot"				= "HKLM:\SOFTWARE\Microsoft\WindowsMitigation"
	"PathToLMMultimediaSystemProfile"			= "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
	"PathToLMMultimediaSystemProfileOnGameTask" = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
	"PathToLMPoliciesEdge"						= "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
	"PathToLMPoliciesMRT"						= "HKLM:\SOFTWARE\Policies\Microsoft\MRT"
	"PathToLMPoliciesPsched"					= "HKLM:\SOFTWARE\Policies\Microsoft\Psched"
	"PathToLMPoliciesSQMClient"					= "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows"
	"PathToLMActivityHistory"					= "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	"PathToLMPoliciesAdvertisingInfo"			= "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	"PathToLMPoliciesAppCompact"				= "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"
	"PathToLMPoliciesCloudContent"				= "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	"PathToLMPoliciesTelemetry"					= "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	#"PathToLMPoliciesWindowsStore"				 = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
	"PathToUblockChrome"						= "HKLM:\SOFTWARE\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm"
	"PathToLMWowNodeOldDotNet"					= "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319"
	"PathToGraphicsDrives"						= "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
	"PathToLMAutoLogger"						= "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger"
	"PathToLMControl"							= "HKLM:\SYSTEM\CurrentControlSet\Control"
	"PathToLMLanmanServer"						= "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
	"PathToLFSVC"								= "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
	"PathToLMMemoryManagement"					= "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
	"PathToLMNdu"								= "HKLM:\SYSTEM\ControlSet001\Services\Ndu"
	
	#$PathToLMPoliciesWindowsUpdate 			 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
	"PathToCUAccessibility"						= "HKCU:\Control Panel\Accessibility"
	"PathToCUControlPanelDesktop"				= "HKCU:\Control Panel\Desktop"
	"PathToCUMouse"								= "HKCU:\Control Panel\Mouse"
	"PathToCUUP"								= "HKCU:\Control Panel\International\User Profile"
	"PathToCUGameBar"							= "HKCU:\SOFTWARE\Microsoft\GameBar"
	"PathToCUInputTIPC"							= "HKCU:\SOFTWARE\Microsoft\Input\TIPC"
	"PathToCUInputPersonalization"				= "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
	"PathToCUPersonalization"					= "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
	"PathToCUSiufRules"							= "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	"PathToCUOnlineSpeech"						= "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	"PathToVoiceActivation"						= "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps"
	"PathToRegCurrentVersion"					= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion"
	"PathToRegCurrentVersionFeeds"				= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds"
	"PathToRegAdvertising"						= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
	"PathToCUAppHost"							= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost"
	"PathToBackgroundAppAccess"					= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
	"PathToCUContentDeliveryManager"			= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	"PathToCUConsentStoreAD"					= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics"
	"PathToCUConsentStoreUAI"					= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation"
	"PathToCUDeviceAccessGlobal"				= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global"
	"PathToCUExplorer"							= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
	"PathToCUExplorerAdvanced"					= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	"PathToCUExplorerRibbon"					= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon"
	"PathToCUFeedsDSB"							= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds\DSB"
	"PathToRegCurrentVersionExplorerPolicy"		= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	"PathToPrivacy"								= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy"
	"PathToOEMInfo"								= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"
	"PathToCUSearch"							= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
	"PathToCUSearchSettings"					= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings"
	"PathToRegPersonalize"						= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
	"PathToCUUserProfileEngagemment"			= "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement"
	"PathToCUPoliciesCloudContent"				= "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	"PathToUsersControlPanelDesktop"			= "REGISTRY::HKEY_USERS\.DEFAULT\Control Panel\Desktop"
	
	"KeysToDelete" = @(
		# Remove Background Tasks
		"HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
		"HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
		"HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
		"HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
		"HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
		"HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
		# Windows File
		"HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
		# Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
		"HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
		"HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
		"HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
		"HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
		"HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
		# Scheduled Tasks to delete
		"HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
		# Windows Protocol Keys
		"HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
		"HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
		"HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
		"HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
		# Windows Share Target
		"HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
	)
	
	# - Content Delivery
	"ContentDeliveryManagerDisableOnZero"																									  = @(
		"SubscribedContent-310093Enabled" 		# "Show me the Windows Welcome Experience after updates and when I sign in highlight whats new and suggested"
		"RotatingLockScreenOverlayEnabled" 		# Rotation Lock
		"RotatingLockScreenEnabled" 			# Rotation Lock
		# Prevents Apps from re-installing
		"ContentDeliveryAllowed" 				# Disables Content Delivery
		"FeatureManagementEnabled"				#
		"OemPreInstalledAppsEnabled"	 		# OEM Advertising
		"PreInstalledAppsEnabled" 				# Preinstalled apps like Disney+, Adobe Express, ect.
		"PreInstalledAppsEverEnabled" 			# Preinstalled apps like Disney+, Adobe Express, ect.
		"RemediationRequired" 					#
		"SilentInstalledAppsEnabled" 			#
		"SoftLandingEnabled" 					#
		"SubscribedContent-314559Enabled" 		#
		"SubscribedContent-314563Enabled" 		# My People Suggested Apps
		"SubscribedContent-338387Enabled" 		# Facts, Tips and Tricks on Lock Screen
		"SubscribedContent-338388Enabled" 		# App Suggestions on Start
		"SubscribedContent-338389Enabled" 		# Tips, Tricks, and Suggestions Notifications
		"SubscribedContent-338393Enabled" 		# Suggested content in Settings
		'SubscribedContent-353694Enabled' 		# Suggested content in Settings
		'SubscribedContent-353696Enabled' 		# Suggested content in Settings
		"SubscribedContent-353698Enabled" 		# Timeline Suggestions
		"SubscribedContentEnabled" 				# Disables Subscribed content
		"SystemPaneSuggestionsEnabled" #
	)
	"ActivityHistoryDisableOnZero"																										      = @(
		"EnableActivityFeed"
		"PublishUserActivities"
		"UploadUserActivities"
	)
	
}
$ScheduledTasks = @{
	"ToEnable" = @(
		"\Microsoft\Windows\Defrag\ScheduledDefrag" 								# Defragments all internal storages connected to your computer
		"\Microsoft\Windows\Maintenance\WinSAT" 									# WinSAT detects incorrect system configurations, that causes performance loss, then sends it via telemetry | Reference (PT-BR): https://youtu.be/wN1I0IPgp6U?t=16
		"\Microsoft\Windows\RecoveryEnvironment\VerifyWinRE" 						# Verify the Recovery Environment integrity, it's the Diagnostic tools and Troubleshooting when your PC isn't healthy on BOOT, need this ON.
		"\Microsoft\Windows\Windows Error Reporting\QueueReporting" 				# Windows Error Reporting event, needed to improve compatibility with your hardware
	)
	"ToDisable" = @(
		"\Microsoft\Office\OfficeTelemetryAgentLogOn"
		"\Microsoft\Office\OfficeTelemetryAgentFallBack"
		"\Microsoft\Office\Office 15 Subscription Heartbeat"
		"\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
		"\Microsoft\Windows\Application Experience\ProgramDataUpdater"
		"\Microsoft\Windows\Application Experience\StartupAppTask"
		"\Microsoft\Windows\Autochk\Proxy"
		"\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" 	# Recommended state for VDI use
		"\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" # Recommended state for VDI use
		"\Microsoft\Windows\Customer Experience Improvement Program\Uploader"
		"\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 		# Recommended state for VDI use
		"\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
		"\Microsoft\Windows\Location\Notifications" 								# Recommended state for VDI use
		"\Microsoft\Windows\Location\WindowsActionDialog"			 				# Recommended state for VDI use
		"\Microsoft\Windows\Maps\MapsToastTask" 									# Recommended state for VDI use
		"\Microsoft\Windows\Maps\MapsUpdateTask" 									# Recommended state for VDI use
		"\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" 			# Recommended state for VDI use
		"\Microsoft\Windows\Retail Demo\CleanupOfflineContent" 						# Recommended state for VDI use
		"\Microsoft\Windows\Shell\FamilySafetyMonitor" 								# Recommended state for VDI use
		"\Microsoft\Windows\Shell\FamilySafetyRefreshTask" 							# Recommended state for VDI use
		"\Microsoft\Windows\Shell\FamilySafetyUpload"
		"\Microsoft\Windows\Windows Media Sharing\UpdateLibrary" 					# Recommended state for VDI use
	)
	
	
	
}
$Services = @{
	# Services which will be totally disabled
	"ToDisable" = @(
		"DiagTrack" 									# DEFAULT: Automatic | Connected User Experiences and Telemetry
		"diagnosticshub.standardcollector.service" 		# DEFAULT: Manual    | Microsoft (R) Diagnostics Hub Standard Collector Service
		"dmwappushservice" 								# DEFAULT: Manual    | Device Management Wireless Application Protocol (WAP)
		"BthAvctpSvc" 									# DEFAULT: Manual    | AVCTP Service - This is Audio Video Control Transport Protocol service
		"fhsvc" 										# DEFAULT: Manual    | Fax History Service
		"GraphicsPerfSvc" 								# DEFAULT: Manual    | Graphics performance monitor service
		"lfsvc" 										# DEFAULT: Manual    | Geolocation Service
		"MapsBroker" 									# DEFAULT: Automatic | Downloaded Maps Manager
		"PcaSvc" 										# DEFAULT: Automatic | Program Compatibility Assistant (PCA)
		"RemoteAccess" 									# DEFAULT: Disabled  | Routing and Remote Access
		"RemoteRegistry" 								# DEFAULT: Disabled  | Remote Registry
		"RetailDemo" 									# DEFAULT: Manual    | The Retail Demo Service controls device activity while the device is in retail demo mode.
		"SysMain" 										# DEFAULT: Automatic | SysMain / Superfetch (100% Disk usage on HDDs)
		# read https://helpdeskgeek.com/?url=https://helpdeskgeek.com/help-desk/delete-disable-windows-prefetch/text%3DShould/520You/520Kill/520Superfetch/520(Sysmain)%3F
		"TrkWks" 										# DEFAULT: Automatic | Distributed Link Tracking Client
		"WSearch" 										# DEFAULT: Automatic | Windows Search (100% Disk usage on HDDs)
		# - Services which cannot be disabled (and shouldn't)
		#"wscsvc"                                   	 # DEFAULT: Automatic | Windows Security Center Service
		#"WdNisSvc"                                		 # DEFAULT: Manual    | Windows Defender Network Inspection Service
		"NPSMSvc_df772"
		#"LanmanServer"
		
	)
	
	# Making the services to run only when needed as 'Manual' | Remove the # to set to Manual
	"ToManual" = @(
		"BITS" 							# DEFAULT: Manual    | Background Intelligent Transfer Service
		"BDESVC" 						# DEFAULT: Manual    | BItLocker Drive Encryption Service
		#"cbdhsvc_*"                     # DEFAULT: Manual    | Clipboard User Service
		"edgeupdate" 					# DEFAULT: Automatic | Microsoft Edge Update Service
		"edgeupdatem" 					# DEFAULT: Manual    | Microsoft Edge Update Service²
		"FontCache" 					# DEFAULT: Automatic | Windows Font Cache
		"iphlpsvc" 						# DEFAULT: Automatic | IP Helper Service (IPv6 (6to4, ISATAP, Port Proxy and Teredo) and IP-HTTPS)
		"lmhosts" 						# DEFAULT: Manual    | TCP/IP NetBIOS Helper
		"ndu" 							# DEFAULT: Automatic | Windows Network Data Usage Monitoring Driver (Shows network usage per-process on Task Manager)
		#"NetTcpPortSharing"             # DEFAULT: Disabled  | Net.Tcp Port Sharing Service
		"PhoneSvc"						# DEFAULT: Manual    | Phone Service (Manages the telephony state on the device)
		"SCardSvr" 						# DEFAULT: Manual    | Smart Card Service
		"SharedAccess" 					# DEFAULT: Manual    | Internet Connection Sharing (ICS)
		"stisvc" 						# DEFAULT: Automatic | Windows Image Acquisition (WIA) Service
		"WbioSrvc" 						# DEFAULT: Manual    | Windows Biometric Service (required for Fingerprint reader / Facial detection)
		"Wecsvc" 						# DEFAULT: Manual    | Windows Event Collector Service
		"WerSvc" 						# DEFAULT: Manual    | Windows Error Reporting Service
		"wisvc" 						# DEFAULT: Manual    | Windows Insider Program Service
		"WMPNetworkSvc" 				# DEFAULT: Manual    | Windows Media Player Network Sharing Service
		"WpnService" 					# DEFAULT: Automatic | Windows Push Notification Services (WNS)
		# - Diagnostic Services
		"DPS" 							# DEFAULT: Automatic | Diagnostic Policy Service
		"WdiServiceHost"				# DEFAULT: Manual    | Diagnostic Service Host
		"WdiSystemHost" 				# DEFAULT: Manual    | Diagnostic System Host
		# - Bluetooth services
		"BTAGService" 					# DEFAULT: Manual    | Bluetooth Audio Gateway Service
		"BthAvctpSvc" 					# DEFAULT: Manual    | AVCTP Service
		"bthserv" 						# DEFAULT: Manual    | Bluetooth Support Service
		"RtkBtManServ" 					# DEFAULT: Automatic | Realtek Bluetooth Device Manager Service
		# - Xbox services
		"XblAuthManager" 				# DEFAULT: Manual    | Xbox Live Auth Manager
		"XblGameSave" 					# DEFAULT: Manual    | Xbox Live Game Save
		"XboxGipSvc"					# DEFAULT: Manual    | Xbox Accessory Management Service
		"XboxNetApiSvc" 				# DEFAULT: Manual    | Xbox Live Networking Service
		# - NVIDIA services
		"NVDisplay.ContainerLocalSystem" # DEFAULT: Automatic | NVIDIA Display Container LS (NVIDIA Control Panel)
		"NvContainerLocalSystem" 		# DEFAULT: Automatic | NVIDIA LocalSystem Container (GeForce Experience / NVIDIA Telemetry)
		# - Printer services
		#"PrintNotify"                   # DEFAULT: Manual    | WARNING! REMOVING WILL TURN PRINTING LESS MANAGEABLE | Printer Extensions and Notifications
		#"Spooler"                       # DEFAULT: Automatic | WARNING! REMOVING WILL DISABLE PRINTING              | Print Spooler
		# - Wi-Fi services
		#"WlanSvc"                       # DEFAULT: Manual (No Wi-Fi devices) / Automatic (Wi-Fi devices) | WARNING! REMOVING WILL DISABLE WI-FI | WLAN AutoConfig
		# - 3rd Party Services
		"gupdate" 						# DEFAULT: Automatic | Google Update Service
		"gupdatem" 						# DEFAULT: Manual    | Google Update Service²
		"DisplayEnhancementService" 	# DEFAULT: Manual    | A service for managing display enhancement such as brightness control.
		"DispBrokerDesktopSvc" 			# DEFAULT: Automatic | Manages the connection and configuration of local and remote displays
	)
	
}
$Software = @{
	"AdwCleaner"            = "https://adwcleaner.malwarebytes.com/adwcleaner?channel=release"
	"SaRAURL"		   		= "https://github.com/circlol/NewLoads/raw/main/src/apps/SaRACmd_17_01_1903_000.zip"
	"chrome" = @{
		Name	          	= "Google Chrome"
		Path	  		  	= [System.IO.DirectoryInfo]::new("$Env:PROGRAMFILES\Google\Chrome\Application\chrome.exe")
		InstallerLocation 	= [System.IO.DirectoryInfo]::new("$NewLoads\googlechromestandaloneenterprise64.msi")
		Installed 		  	= Test-Path -Path "$Env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
		FileExists 		  	= Test-Path -Path "$NewLoads\googlechromestandaloneenterprise64.msi"
		ChromeLink        	= "https://clients2.google.com/service/update2/crx"
		DownloadURL 	  	= "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
		ArgumentList      	= "/passive"
	}
	"vlc" = @{
		Name	  			= "VLC Media Player"
		Path 			 	= [System.IO.DirectoryInfo]::new("$Env:ProgramFiles\VideoLAN\VLC\vlc.exe")
		InstallerLocation 	= [System.IO.DirectoryInfo]::new("$NewLoads\vlc-3.0.18-win64.exe")
		Installed 			= Test-Path -Path "$Env:ProgramFiles\VideoLAN\VLC\vlc.exe"
		FileExists 			= Test-Path -Path "$NewLoads\vlc-3.0.18-win64.exe"
		DownloadURL 		= "https://mirror.csclub.uwaterloo.ca/vlc/vlc/3.0.20/win64/vlc-3.0.20-win64.exe"
		ArgumentList 		= "/S /L=1033"
	}
	"zoom" = @{
		Name	  			= "Zoom"
		Path  				= [System.IO.DirectoryInfo]::new("$Env:ProgramFiles\Zoom\bin\Zoom.exe")
		InstallerLocation	= [System.IO.DirectoryInfo]::new("$NewLoads\ZoomInstallerFull.msi")
		Installed 			= Test-Path -Path "$Env:ProgramFiles\Zoom\bin\Zoom.exe"
		FileExists 			= Test-Path -Path "$NewLoads\ZoomInstallerFull.msi"
		DownloadURL 		= "https://zoom.us/client/5.16.2.22807/ZoomInstallerFull.msi?archType=x64"
		ArgumentList 		= "/quiet"
	}
	"acrobat" = @{
		Name	  			= "Adobe Acrobat Reader"
		Path 				= [System.IO.DirectoryInfo]::new("${Env:Programfiles(x86)}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe")
		InstallerLocation 	= [System.IO.DirectoryInfo]::new("$NewLoads\AcroRdrDCx642200120085_MUI.exe")
		Installed 			= Test-Path -Path "${Env:Programfiles(x86)}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
		FileExists 			= Test-Path -Path "$NewLoads\AcroRdrDCx642200120085_MUI.exe"
		DownloadURL 		= "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2200120169/AcroRdrDC2200120169_en_US.exe"
		ArgumentList 		= "/sPB"
	}
	"HEVC" = @{
		Name	  			= "HEVC/H.265 Codec"
		InstallerLocation 	= [System.IO.DirectoryInfo]::new("$NewLoads\Microsoft.HEVCVideoExtensions_2.0.61933.0_neutral_~_8wekyb3d8bbwe.AppxBundle")
		Installed 			= Get-AppxPackage -Name "Microsoft.HEVCVideoExtension"
		FileExists 			= Test-Path -Path "$NewLoads\Microsoft.HEVCVideoExtensions_2.0.61933.0_neutral_~_8wekyb3d8bbwe.AppxBundle"
		DownloadURL 		= "https://github.com/circlol/NewLoads/raw/main/src/apps/Microsoft.HEVCVideoExtensions_2.0.61933.0_neutral_~_8wekyb3d8bbwe.AppxBundle"
	}
	"OutlookForWindows" = @{
		Name	  			= "Outlook for Windows"
		InstallerLocation 	= [System.IO.DirectoryInfo]::new("$NewLoads\Microsoft.OutlookForWindows_1.2023.920.0_x64__8wekyb3d8bbwe.Msix")
		Installed		  	= Get-AppxPackage -Name "Microsoft.OutlookForWindows"
		FileExists	      	= Test-Path -Path "$NewLoads\Microsoft.OutlookForWindows_1.2023.920.0_x64__8wekyb3d8bbwe.Msix"
		DownloadURL 		= "https://github.com/circlol/NewLoads/raw/main/src/apps/Microsoft.OutlookForWindows_1.2023.920.0_x64__8wekyb3d8bbwe.Msix"
	}
	# - Debloat
	"apps" = @(
		"Adobe offers",
		"Amazon",
		"Booking",
		"Booking.com",
		"ExpressVPN",
		"Forge of Empires",
		"Free Trials",
		"Planet9 Link",
		"Utomik - Play over 1000 games"
	)
	
	
	"Programs" = @(
		# Microsoft Applications
		"Microsoft.549981C3F5F10" 										# Cortana
		"Microsoft.3DBuilder" 											# 3D Builder
		"Microsoft.Appconnector" 										# App Connector
		#"*Microsoft.Advertising.Xaml*"									 # Advertising 
		#"Microsoft.BingFinance" 										 # Bing Finance
		#"Microsoft.BingFoodAndDrink" 									 # Food And Drink
		"Microsoft.BingHealthAndFitness" 								 # Health And Fitness
		#"Microsoft.BingNews" 											 # Bing News
		#"Microsoft.BingSports" 										 # Bing Sports
		#"Microsoft.BingTranslator" 									 # Bing Translator
		#"Microsoft.BingTravel" 										 # Bing Travel
		#"Microsoft.BingWeather" 										 # Weather
		"Microsoft.CommsPhone" 											# Your Phone
		"Microsoft.ConnectivityStore" 									# Connectivity Store
		"Microsoft.windowscommunicationsapps" 							# Old mail and calendar
		"Microsoft.Messaging" 											# Messaging
		"Microsoft.Microsoft3DViewer" 									# 3D Viewer
		"Microsoft.MicrosoftOfficeHub" 									# Office
		"Microsoft.MicrosoftPowerBIForWindows" 							# Power Automate
		"Microsoft.MicrosoftSolitaireCollection" 						# MS Solitaire
		"Microsoft.MinecraftEducationEdition" 							# Minecraft Education Edition for Windows 10
		"Microsoft.MinecraftUWP" 										# Minecraft
		"Microsoft.MixedReality.Portal" 								# Mixed Reality Portal
		"Microsoft.Office.Hub" 											# Office Hub
		"Microsoft.Office.Lens" 										# Office Lens
		"Microsoft.Office.OneNote" 										# Office One Note
		"Microsoft.Office.Sway" 										# Office Sway
		"Microsoft.OneConnect" 											# OneConnect
		"Microsoft.People" 												# People
		"Microsoft.SkypeApp" 											# Skype (Who still uses Skype? Use Discord)
		"MicrosoftTeams" 												# Teams / Preview
		"Microsoft.Todos" 												# To Do
		"Microsoft.Wallet" 												# Wallet
		"Microsoft.Whiteboard" 											# Microsoft Whiteboard
		"Microsoft.WindowsPhone" 										# Your Phone Alternate
		"Microsoft.WindowsReadingList" 									# Reading List
		#"Microsoft.WindowsSoundRecorder"            			 		 # Sound Recorder
		"Microsoft.ZuneMusic" 											# Groove Music / (New) Windows Media Player
		"Microsoft.ZuneVideo" 											# Movies & TV
		"Microsoft.XboxApp" 											# Xbox App
		#"Microsoft.Xbox.TCUI" 											# Xbox
		# "Microsoft.XboxGameCallableUI"                         		 # Xbox Game Callable UI ## NON-REMOVABLE = TRUE
		#"Microsoft.XboxIdentityProvider"								# Xbox Identity Provider
		#"Microsoft.XboxGameOverlay" 									# Xbox Game Overlay
		#"Microsoft.XboxGamingOverlay" 									# Xbox Game Bar 
		# "Microsoft.XboxSpeechToTextOverlay"							 # Xbox Text To Speech Overlay
		# 3rd party Apps
		"*ACGMediaPlayer*" 												# ACGMediaPlayer
		"*ActiproSoftwareLLC*" 											# ActiproSoftware
		"*AdobeSystemsIncorporated.AdobePhotoshopExpress*" 				# Adobe Photoshop Express
		"*AdobePhotoshopExpress*"										# Adobe Photoshop Express
		"AdobeSystemsIncorporated.AdobeLightroom" 						# Adobe Lightroom
		"AdobeSystemsIncorporated.AdobeCreativeCloudExpress" 			# Adobe Creative Cloud Express
		"AdobeSystemsIncorporated.AdobeExpress" 						# Adobe Creative Cloud Express
		"*Amazon.com.Amazon*" 											# Amazon
		"AmazonVideo.PrimeVideo" 										# Amazon Prime Video
		"57540AMZNMobileLLC.AmazonAlexa" 								# Amazon Alexa
		"*BubbleWitch3Saga*" 											# Bubble Witch 3 Saga
		"*CandyCrush*" 													# Candy Crush
		"Clipchamp.Clipchamp"											# Clip Champ
		"*DisneyMagicKingdoms*" 										# Disney Magic Kingdom
		"Disney.37853FC22B2CE" 											# Disney Plus
		"*Disney*" 														# Disney Plus
		"*Dolby*"														# Dolby Products (Like Atmos)
		"*DropboxOEM*" 													# Dropbox
		"*Duolingo-LearnLanguagesforFree*" 								# Duolingo
		"*EclipseManager*" 												# EclipseManager
		"Evernote.Evernote" 											# Evernote
		"*ExpressVPN*" 													# ExpressVPN
		"*Facebook*" 													# Facebook
		"*Flipboard*" 													# Flipboard
		"*HiddenCity*" 													# Hidden City
		"*HiddenCityMysteryofShadows*" 									# Hidden City Mystery of Shadows
		"*HotspotShieldFreeVPN*" 										# Hotspot Shield VPN
		"*Hulu*" 														# Hulu
		"*Instagram*" 													# Instagram
		"*LinkedInforWindows*" 											# LinkedIn
		"*McAfee*" 														# McAfee
		"5A894077.McAfeeSecurity" 										# McAfee Security
		"4DF9E0F8.Netflix" 												# Netflix
		"*Netflix*"														# Netflix
		"*PicsArt-PhotoStudio*" 										# PhotoStudio
		"*Pinterest*" 													# Pinterest
		"142F4566A.147190D3DE79" 										# Pinterest
		"1424566A.147190DF3DE79" 										# Pinterest
		"SpotifyAB.SpotifyMusic" 										# Spotify
		"*Sway*"														# Sway
		"*Twitter*" 													# Twitter
		"*TikTok*"	 													# TikTok
		"*Viber*"														# Viber
		"5319275A.WhatsAppDesktop" 										# WhatsApp
		# Acer OEM Bloat
		"AcerIncorporated.AcerRegistration" 							# Acer Registration
		"AcerIncorporated.QuickAccess" 									# Acer Quick Access
		"AcerIncorporated.UserExperienceImprovementProgram" 			# Acer User Experience Improvement Program
		#"AcerIncorporated.AcerCareCenterS"         					 # Acer Care Center
		"AcerIncorporated.AcerCollectionS" 								# Acer Collections
		# HP Bloat
		"AD2F1837.HPPrivacySettings" 									# HP Privacy Settings
		"AD2F1837.HPInc.EnergyStar" 									# Energy Star
		"AD2F1837.HPAudioCenter" 										# HP Audio Center
		# Common HP & Acer Bloat
		"CyberLinkCorp.ac.PowerDirectorforacerDesktop" 					# CyberLink Power Director for Acer
		"CorelCorporation.PaintShopPro" 								# Coral Paint Shop Pro
		"26720RandomSaladGamesLLC.HeartsDeluxe" 						# Hearts Deluxe
		"26720RandomSaladGamesLLC.SimpleSolitaire" 						# Simple Solitaire
		"26720RandomSaladGamesLLC.SimpleMahjong" 						# Simple Mahjong
		"26720RandomSaladGamesLLC.Spades" 								# Spades
)
}
$Visuals = @{
	"WallpaperURL" = "https://raw.githubusercontent.com/circlol/NewLoads/main/src/assets/wallpaper.jpg"
	
	"StartLayout" = @"
<LayoutModificationTemplate xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
    xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
    xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
    xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
    Version="1">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
        <StartLayoutCollection>
        <defaultlayout:StartLayout GroupCellWidth="6" />
        </StartLayoutCollection>
    </DefaultLayoutOverride>
    <CustomTaskbarLayoutCollection PinListPlacement="Replace">
        <defaultlayout:TaskbarLayout>
        <taskbar:TaskbarPinList>
        <taskbar:UWA AppUserModelID="windows.immersivecontrolpanel_cw5n1h2txyewy!Microsoft.Windows.ImmersiveControlPanel" />
        <taskbar:UWA AppUserModelID="Microsoft.WindowsStore_8wekyb3d8bbwe!App" />
        <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.SecHealthUI" />
        <taskbar:DesktopApp DesktopApplicationID="Chrome" />
        <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.Explorer" />
        </taskbar:TaskbarPinList>
    </defaultlayout:TaskbarLayout>
    </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
"@
	#<taskbar:UWA AppUserModelID="Microsoft.SecHealthUI_8wekyb3d8bbwe!SecHealthUI" />
	#<taskbar:UWA AppUserModelID="Microsoft.Windows.SecHealthUI_cw5n1h2txyewy!SecHealthUI" />
	#<taskbar:UWA AppUserModelID="Microsoft.OutlookForWindows_8wekyb3d8bbwe!Microsoft.OutlookforWindows" />
}



#endregion
#region Functions
#region Formatting
function Get-Status {
	<#
.SYNOPSIS
This function is used to get the status of a log entry and perform actions based on the status.

.NOTES
    Author: Circlol
    Version: 1.0
    Release Notes:
        1.0:
            - Started logging changes.
#>
	[CmdletBinding()]
	param (
		[Switch]$SkipLogEntry,
		[Switch]$StartTranscript,
		[Switch]$StopTranscript,
		[Switch]$WriteToLog
	)
	
	If ($StartTranscript) {
		If ($StopTranscript) { break }
		Start-Transcript -Path $Variables.Log -Append | Write-ModifiedStatus -Types "STARTING" -Status "Starting Transcript"
		Start-Transcript -Path $Variables.Log -Append | Write-ModifiedStatus -Types "STARTING" -Status "Starting Transcript"
	} elseif ($StopTranscript) {
		If ($StartTranscript) { break }
		Stop-Transcript | Write-ModifiedStatus -Types "STOPPING" -Status "Stopping Transcript"
	}
	If ($WriteToLog) {
		Add-Content -Path $Variables.Log -Value "New Loads Log $date $time"
		$LogEntries | Out-File $Variables.Log -NoClobber -Append
	}
	If ($? -eq $True) {
		# Write a success message
		Write-Caption -Type Success

		If (!$SkipLogEntry) {
			# Marks entry as successful
			$LogEntry.Successful = $true
			Add-Content -Path $Variables.Log -Value $logEntry
		}
		
	} else {
		# Write a failure message
		Write-Caption -Type Failed
		If (!$SkipLogEntry) {
			# Marks entry as unsuccessful
			$LogEntry.Successful = $false
			Add-Content -Path $Variables.Log -Value $logEntry
			Get-Error $error[0].Exception.Message
		}
	}
}
function Write-Center {
	param (
		[Parameter(Mandatory = $true)]
		[string]$text,
		[Switch]$NoNewLine,
		$Offset = 0,
		$ForegroundColor = 'White',
		$BackgroundColor = 'Black'
	)
	
	$padding = [Console]::WindowWidth - $text.Length
	$padding = $padding - $offset
	$leftPadding = ' ' * [math]::Floor($padding / 2)
	Write-Host "$leftPadding $Text" -NoNewline:$NoNewLine -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}
Function Write-Break {
<#
.SYNOPSIS
Writes a break line to the console.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	$Width = [Console]::WindowWidth - 2
	$line = "=" * $Width
	Write-Host "`n`n[" -NoNewline -ForegroundColor $Variables.AccentColor1 -Backgroundcolor $Variables.BackgroundColor
	Write-Host $line -NoNewLine -ForegroundColor $Variables.AccentColor3 -BackgroundColor $Variables.BackgroundColor
	Write-Host "]" -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	[System.Environment]::NewLine
}
Function Write-Caption {
<#
.SYNOPSIS
Writes a caption to the console.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding()]
	param (
		[ValidateSet("Failed", "Success", "Warning", "none")]
		[String]$Type = "none",
		[String]$Text = "No Text"
	)
	If ($Text -ne "No Text") {
		$OverrideText = $Text
	}
	
	switch ($Type) {
		"Failed" {
			$foreg = "DarkRed"
			$foreg1 = "Red"
			$symbol = "X"
			$text = "Failed"
		}
		"Success" {
			$foreg = "DarkGreen"
			$foreg1 = "Green"
			$symbol = "√"
			$text = "Success"
		}
		"Warning" {
			$foreg = "DarkYellow"
			$foreg1 = "Yellow"
			$symbol = "!"
			$text = "Warning"
		}"None" {
			$foreg = "white"
			$foreg1 = "Gray"
			$symbol = ""
			$text = ""
		}
	}
	If ($OverrideText) {
		$Text = $OverrideText
	}
	Write-Host "  " -NoNewline #-ForegroundColor $foreg
	Write-Host $Symbol -NoNewline -ForegroundColor $foreg1
	Write-Host "$Text" -ForegroundColor $foreg
}
Function Write-HostReminder {
<#
.SYNOPSIS
Writes a reminder to the console.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding()]
	[OutputType([String])]
	param (
		[String]$Text = "Example text"
	)
	Write-Host "[" -BackgroundColor $Variables.BackgroundColor -ForegroundColor $Variables.AccentColor1 -NoNewline
	Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine
	Write-Host "]" -BackgroundColor $Variables.BackgroundColor -ForegroundColor $Variables.AccentColor1 -NoNewline
	Write-Host ": $text"
	[System.Environment]::NewLine
}
function Write-Log {
	$TableToOutput | Format-Table -Property "Time", "Successful", "Types", "Status" | Out-File $Variables.Log
}
function Write-Logo {
	<#
	.SYNOPSIS
	Displays the New Loads initialization logo and information.
	
	.NOTES
	Author: Circlol
	Version: 1.0
	History:
		1.0:
			- Started logging changes.
	#>
	$consoleWidth = [Console]::WindowWidth
	$length = [Math]::Floor($consoleWidth / 2)
	$padding = $length - ($Variables.Creator).Length - ($Variables.ProgramVersion).Length - ($Variables.LastUpdate).Length
	$leftPadding = ' ' * [math]::Floor($padding)
	$logoWidth = 74 # Assuming the logo width is 74 characters
	$logoPadding = ($consoleWidth - $logoWidth) / 2
	$logoPadding = " " * [math]::Floor($logoPadding)
	

	
	
	Write-Host "`n`n`n"
	$b = '▀' * [Console]::WindowWidth
	Write-Host $b -NoNewLine -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.AccentColor3
	Write-Host "`n`n"
	$Logo = "
$LogoPadding███╗   ██╗███████╗██╗    ██╗    ██╗      ██████╗  █████╗ ██████╗ ███████╗
$LogoPadding████╗  ██║██╔════╝██║    ██║    ██║     ██╔═══██╗██╔══██╗██╔══██╗██╔════╝
$LogoPadding██╔██╗ ██║█████╗  ██║ █╗ ██║    ██║     ██║   ██║███████║██║  ██║███████╗
$LogoPadding██║╚██╗██║██╔══╝  ██║███╗██║    ██║     ██║   ██║██╔══██║██║  ██║╚════██║
$LogoPadding██║ ╚████║███████╗╚███╔███╔╝    ███████╗╚██████╔╝██║  ██║██████╔╝███████║
$LogoPadding╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝"
	[System.Environment]::NewLine
	Write-Host "$Logo`n`n`n$leftPadding" -NoNewline -ForegroundColor $Variables.LogoColor -BackgroundColor $Variables.BackgroundColor 
	Write-Host "Created by " -NoNewLine -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	Write-Host "$($Variables.Creator)    " -NoNewLine -ForegroundColor Red -BackgroundColor $Variables.BackgroundColor 
	Write-Host "Version: " -NoNewLine -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	Write-Host $($Variables.ProgramVersion) -NoNewline -ForegroundColor Green -BackgroundColor $Variables.BackgroundColor
	Write-Host "   Last Update: " -NoNewLine -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	Write-Host "$($Variables.LastUpdate)" -NoNewline -ForegroundColor Green -BackgroundColor $Variables.BackgroundColor
	Write-Host "`n`n" -NoNewline
	Write-Center "Notice: For best functionality, it is strongly suggested to update windows before running New Loads." -ForegroundColor $Variables.AccentColor3 -BackgroundColor $Variables.BackgroundColor
	<#If ($Null -ne $Params) {
	Write-Host "     Parameters Specified: " -NoNewLine -ForegroundColor $Variables.AccentColor2 -BackgroundColor $Variables.BackgroundColor
		$Params | ForEach-Object {
			Write-Host " -$_" -NoNewline -ForegroundColor $Variables.AccentColor2 -BackgroundColor $Variables.BackgroundColor
		}
		
	}#>
	Write-Host "`n`n`n"
	Write-Host $b -BackgroundColor $Variables.AccentColor1 -ForegroundColor $Variables.AccentColor3
	Write-Host "`n`n"
	#Set-ScriptStatus -TitleText $null
}

Function Write-ModifiedStatus {
	param (
		[string]$Types,
		[string[]]$Status,
		[switch]$WriteWarning
	)
	Write-Host "$($LogEntry.Time) " -NoNewline -ForegroundColor DarkGray -BackgroundColor $Variables.BackgroundColor
	
	ForEach ($Type in $Types) {
		Write-Host "$Type " -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	}
	
	If ($WriteWarning) {
		Write-Host "::Warning:: -> $Status" -ForegroundColor Red -BackgroundColor $Variables.BackgroundColor -NoNewline
	} Else {
		Write-Host "-> $Status" -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	}
}
Function Write-Section {
<#
.SYNOPSIS
Writes a section to the console.

.NOTES
Author: Circlol
Version: 1.1
History:
	1.2: (07.07.2024)
		- Added math for centering text
    1.1: (10.29.2023)
        - Added break paramater with purpose of modularity
    1.0:
        - Started logging changes.
#>
	[CmdletBinding()]
	param (
		[String]$Text = "No Text",
		[String]$break = "=" * 27
	)
	
	$break = '=' * ([Console]::WindowWidth / 6)
	$totalLength = $break.Length * 2 + $Text.Length + 4 # 4 for the two "<" and two ">" characters
	$padding = [Console]::WindowWidth - $totalLength
	$leftPadding = ' ' * [math]::Floor($padding / 2)
	
	[System.Environment]::NewLine
	Write-Host "$leftPadding<" -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host $break -NoNewline -ForegroundColor $Variables.AccentColor3 -BackgroundColor $Variables.BackgroundColor
	Write-Host "] " -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host "$Text " -NoNewline -ForegroundColor $Variables.AccentColor2 -BackgroundColor $Variables.BackgroundColor
	Write-Host "[" -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host $break -NoNewline -ForegroundColor $Variables.AccentColor3 -BackgroundColor $Variables.BackgroundColor
	Write-Host ">" -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	#$TitleToLogFormat = "`n`n   $Text`n`n"
	#Add-Content -Path $Variables.Log -Value $TitleToLogFormat
}
function Write-Status {
	<#
	.SYNOPSIS
		Writes a status to the console.
	
	.NOTES
		Author: Circlol
		Version: 1.0.1
		Date: Nov 5 23
		History:
		1.0.1
		(Nov 5, 2023)
		- Removed mandatory param on types for simple status
		1.0:
		- Started logging changes.
#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[String]$Status,
		[Parameter(Position = 2)]
		[Array]$Types,
		[Parameter(Position = 4)]
		[Switch]$NoLogEntry,
		[Parameter(Position = 7)]
		[Switch]$WriteWarning,
		[Parameter(Position = 3)]
		[Switch]$NoNewLine,
		[Parameter(Position = 5)]
		[ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')]
		[String]$ForegroundColor = $Variables.TextColor,
		[Parameter(Position = 6)]
		[ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')]
		[String]$BackgroundColor = $Variables.BackgroundColor
	)
	
	If ($null -eq $ForegroundColor) {
		$ForegroundColor = [Console]::ForegroundColor
	}
	If ($null -eq $BackgroundColor) {
		$BackgroundColor = [Console]::BackgroundColor
	}
	
	If ($WriteWarning -eq $True) {
		$ForegroundColor = "Yellow"
	}
	$time = (Get-Date).ToString("h:mm:ss tt")
	If (!$NoLogEntry) {
		# Prints date in line, converts to Month Day Year Hour Minute Period
		$Global:LogEntry = [PSCustomObject]@{
			Time = $time
			Successful = $false
			Types = $Types -join ', '
			Status = $Status
		}
		$LogEntry | Out-Null
	}

	# Output the log entry to the console
	Write-Host "$time " -NoNewline -ForegroundColor DarkGray -BackgroundColor $BackgroundColor
	
	
	If ($WriteWarning) {
		Write-Host $TweakType -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
		Write-Host " ::Warning:: -> " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
		Write-Host $Status -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -NoNewline:$NoNewLine
	} Else { 
		ForEach ($Type in $Types) {
			Write-Host "$Type " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
		}
		
		Write-Host $TweakType -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $BackgroundColor
		Write-Host " -> " -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $BackgroundColor
		Write-Host $Status -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -NoNewline:$NoNewLine
	}
	
	
}
Function Write-Title {
<#
.SYNOPSIS
Writes a title to the console.

.NOTES
Author: Circlol
Version: 1.1
History:
    1.1: (10.29.2023)
        - Added break parameter with purpose of modularity
    1.0:
        - Started logging changes.
#>
	[CmdletBinding()]
	param (
		[String]$Text = "No Text",
		[String]$break
	)
	$break = '=' * ([Console]::WindowWidth / 4)
	$totalLength = $break.Length * 2 + $Text.Length + 4 # 4 for the two "<" and two ">" characters
	$padding = [Console]::WindowWidth - $totalLength
	$leftPadding = ' ' * [math]::Floor($padding / 2)
	
	Write-Host "`n`n$leftpadding<" -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host $break -NoNewline -ForegroundColor $Variables.AccentColor3 -BackgroundColor $Variables.BackgroundColor
	Write-Host "] " -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host "$Text " -NoNewline -ForegroundColor $Variables.TextColor -BackgroundColor $Variables.BackgroundColor
	Write-Host "[" -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host $break -NoNewline -ForegroundColor $Variables.AccentColor3 -BackgroundColor $Variables.BackgroundColor
	Write-Host ">`n`n" -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
}
Function Write-TitleCounter {
<#
.SYNOPSIS
Writes a title counter to the console.

.NOTES
Author: Circlol
Version: 1.1
History:
    1.1: (10.29.2023)
        - Added break parameter with purpose of modularity.
    1.0:
        - Started logging changes.
#>
	[CmdletBinding()]
	[OutputType([System.Int32])]
	param (
		[String]$Text = "No Text",
		[Int]$Counter = 0,
		[Int]$MaxLength
	)
	$Offset = (8 + $MaxLength.Length + $Counter.Length + $Text.Length)
	$padding = [Console]::WindowWidth - $Offset
	$leftPadding = ' ' * [math]::Floor($padding / 2)
	
	Write-Break
	Write-Host "$leftPadding(" -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host " $($Counter)/$($Variables.MaxLength) " -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	Write-Host ")" -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host " | " -NoNewline -ForegroundColor $Variables.AccentColor2 -BackgroundColor $Variables.BackgroundColor
	Write-Host "$Text" -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Break
	#$TitleCounterLogFormat = "`n`n$break`n`n    ($Counter)/$($Variables.MaxLength)) | $Text`n`n$break`n"
	# Writes to Log
	Add-Content -Path $Variables.Log -Value "$TitleCounterLogFormat"
}


#endregion
#region Information based
Function Get-CPU {
<# .SYNOPSIS
	This function retrieves information about the CPU of the current system.

.NOTES
	Author: Circlol
	Version: 1.0
	Release Notes:
	1.0:
		- Started logging changes.
	#>
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable], [String])]
	param (
		[switch]$Formatted,
		[Switch]$NameOnly
	)
	
	try {
		$RawInfo = Get-CimInstance -ClassName Win32_Processor
		
		$cpuName = ($RawInfo).Name
		$cores = ($RawInfo).NumberOfCores
		$threads = ($RawInfo).NumberOfLogicalProcessors
	} catch {
		return "Error retrieving CPU information: $($_)"
	}
	
	if ($NameOnly) {
		return $cpuName
	}
	
	if ($Formatted) {
		return "CPU: $cpuName`nCores: $cores`nThreads: $threads"
	} else {
		return @{
			CPU	    = $cpuName
			Cores   = $cores
			Threads = $threads
		}
	}
}
Function Get-DriveInfo {
<#
.SYNOPSIS
Retrieves information about physical disks.

.NOTES
Author: Circlol
Version: 1.0
Release Notes:
1.0:
- Started logging changes.
#>
	$driveInfo = @()
	$physicalDisks = Get-PhysicalDisk | Where-Object {
		$null -ne $_.MediaType
	}
	foreach ($disk in $physicalDisks) {
		$model = $disk.FriendlyName
		$driveType = $disk.MediaType
		$sizeGB = [math]::Round($disk.Size / 1GB)
		$healthStatus = $disk.HealthStatus
		$driveInfo += [PSCustomObject]@{
			Status   = $healthStatus
			Model    = $model
			Type	 = $driveType
			Capacity = "${sizeGB} GB"
		}
	}
	return $driveInfo
}
Function Get-DriveSpace {
<#
.SYNOPSIS
Retrieves information about the available and total storage space for all file system drives.
.NOTES
Author: Circlol
Version: 1.0
Release Notes:
1.0 - Started logging changes.
#>
	[CmdletBinding()]
	[OutputType([String])]
	param (
		[Parameter(Mandatory = $false, ValueFromPipeline = $true)]
		[String]$DriveLetter = $env:SystemDrive[0]
	)
	process {
		$drives = Get-PSDrive -PSProvider FileSystem | Where-Object {
			$_.Free -ge 0 -and $_.Used -ge 0
		}
		foreach ($drive in $drives) {
			$driveLetter = $drive.Name
			$availableStorage = $drive.Free / 1GB
			$totalStorage = ($drive.Free + $drive.Used) / 1GB
			if ($totalStorage -ge 1024) {
				$totalStorage = $totalStorage / 1024
				$availableStorage = $availableStorage / 1024
				$sizeUnit = "TB"
			} else {
				$sizeUnit = "GB"
			}
			$percentageAvailable = [math]::Round(($availableStorage / $totalStorage) * 100, 1)
			$driveInfo = "$driveLetter`: $([math]::Round($availableStorage, 1)) $sizeUnit free of $([math]::Round($totalStorage, 1)) $sizeUnit ($percentageAvailable% Available)"
			Write-Output "$driveInfo"
		}
	}
}
function Get-Error {
<#
.SYNOPSIS
Logs error messages to a specified file.
.NOTES
Author: Circlol
Version: 1.0
Release Notes:
    1.0 - Started logging changes.
#>
	## TODO This functions compatability needs to be increased before it can be deployed 
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		$ErrorMessage
		
	)
	process {
		
		$lineNumber = $MyInvocation.ScriptLineNumber
		$command = $Error[0].InvocationInfo.MyCommand
		$errorType = $Error[0].CategoryInfo.Reason
		$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
		$scriptPath = $MyInvocation.MyCommand.Path
		$userName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
		$errorString = "

**********************************************************************
$timestamp Executed by: $userName
Command: $command
Script Path: $scriptPath
Error Type: $errorType
Offending line number: $lineNumber
Error Message:
$ErrorMessage
**********************************************************************

"
		try {
			Add-Content -Path $Variables.Log -Value $errorString
		} catch {
			Write-Error "Error writing to log: $($_.Exception.Message)"
		}
	}
}
Function Get-GPU {
<#
.SYNOPSIS
Gets the name of the GPU installed on the local computer.
.NOTES
Author: Circlol
Version: 1.0
Release Notes:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding()]
	[OutputType([String])]
	param ()
	$gpu = Get-CimInstance -ClassName Win32_VideoController | Select-Object -ExpandProperty Name
	return $gpu.Trim()
}
function Get-InstalledProgram {
<#
.SYNOPSIS
Gets a list of installed programs matching a specified name.
.EXAMPLE
PS C:\> Get-InstalledProgram -Name "Microsoft Visual"
Name                                Version         Publisher               UninstallString
----                                -------         ---------               ---------------
Microsoft Visual C++ 2015 Redist... 14.0.24215     Microsoft Corporation   MsiExec.exe /X{e46eca4f-393b-40df-9f49-076faf788d83}
Microsoft Visual C++ 2017 Redist... 14.16.27024    Microsoft Corporation   MsiExec.exe /X{e2ee15e2-a480-4bc5-bfb7-e9803d1d9823}
.NOTES
Author: Circlol
Version: 1.0
Release Notes:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding()]
	[OutputType([String])]
	Param (
		[string]$Name
	)
	$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
	$registryPath2 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
	$installedPrograms = Get-ChildItem -Path $registryPath
	$installedPrograms += Get-ChildItem -Path $registryPath2
	
	
	$registryPath3 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\*"
	# Scan through everything in products to find the InstallProperties key
	$installedPrograms += Get-ChildItem -Path $registryPath3 -Recurse | Where-Object {
		$_.Name -like "*InstallProperties"
	}
	
	# - Filter the list of installed programs to only include programs that match the specified name
	$matchingPrograms = $installedPrograms | Where-Object {
		($_.GetValue("DisplayName") -like "*$Name*") -or
		($_.GetValue("DisplayVersion") -like "*$Name*") -or
		($_.GetValue("Publisher") -like "*$Name*") -or
		($_.GetValue("Comments") -like "*$Name*")
	}
	# - Output the matching programs as a list of objects with Name, Version, Publisher, and UninstallString properties
	# - Sort the list by name and remove duplicates
	$matchingPrograms | ForEach-Object {
		[PSCustomObject]@{
			Name		    = $_.GetValue("DisplayName")
			Publisher	    = $_.GetValue("Publisher")
			Version		    = $_.GetValue("DisplayVersion")
			InstallDate     = $_.GetValue("InstallDate")
			UninstallString = $_.GetValue("UninstallString")
		}
	} | Sort-Object -Property Name -Unique | Format-Table -AutoSize
}
function Get-MissingDriver {
	[CmdletBinding()]
	param ()
	$Text = "Drivers"
	Set-ScriptStatus -SectionText $text -TweakTypeText $text -WindowTitle $text
	# Create an array to store the driver information
	$drivers = @()
	
	# Get a list of all PnP devices
	$devices = Get-CimInstance -ClassName Win32_PnPEntity | Where-Object {
		$_.Status -ne "OK" -or $null -eq $_.DeviceID -or $_.Name -like "*Microsoft Basic Display Adapter*"
	}

	foreach ($device in $devices) {
		# Create a hashtable for the device information
		If ($null -eq $device.Name) {
			$friendly = $device.Caption
		}
		$driverInfo = @{
			FriendlyName = $device.Name
			DeviceID	 = $device.DeviceID
		}
		# Add the hashtable to the array
		$drivers += $driverInfo
	}

	If (!$drivers) {
		Write-Status "No drivers seem to be missing." "ALL GOOD" -ForegroundColor Green
	} else {
		Write-Status "Drivers are missing." "!!"
		Write-Output $drivers
		$q = Show-Question -Buttons YesNo -Message "`nThere seems to be drivers missing. Please fix them before continuing.`n`n Skip this warning and continue?" -Icon Information
		write-output $q | out-null
		If ($q = $true) {
			Write-Status "Moving on." ">:("
		} else {
			exit
		}
	}
}

function Get-NetworkStatus {
<#
.SYNOPSIS
Checks the network status and waits for internet connection if necessary.
.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding()]
	param (
		[string]$NetworkStatusType = "IPv4Connectivity"
	)
	$BackupTweakType = $TweakType
	$NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
	if ($NetStatus -ne 'Internet') {
		$TweakType = "NOT CONNECTED"
		Write-Status "Seems like there's no network connection. Please reconnect." 'WAITING' -ForegroundColor Yellow
		while ($NetStatus -ne 'Internet') {
			Write-Status "Waiting for Internet" "WAITING" -ForegroundColor Yellow
			Start-Sleep -Milliseconds 3500
			$NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
		}
		Test-Connection -ComputerName $Env:COMPUTERNAME -AsJob
		Start-Sleep -Seconds 2
		Write-Output "Connected: Moving On"
		$Tweaktype = $BackupTweakType
	}
}
function Get-Office {
<#
.SYNOPSIS
The Get-Office function checks if Microsoft Office is installed on the device by looking for the installation paths of both 32-bit and 64-bit versions of Office. If either path exists, the function sets the $Variables.officecheck variable to true, indicating that Office is installed. If Office is installed, the function calls the Remove-Office function to remove it.

This command checks if Microsoft Office is installed on the device and removes it if it exists.
.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	Set-ScriptStatus -WindowTitle "Office" -TweakTypeText "Office" -TitleCounterText "Office" -AddCounter
	Write-Status "Checking for Office" '?'
	If (Test-Path $Variables.PathToOffice64) {
		$Variables.office64 = $true
	} Else {
		$Variables.office64 = $false
	}
	
	If (Test-Path $Variables.PathToOffice86) {
		$Variables.Office32 = $true
	} Else {
		$Variables.office32 = $false
	}
	
	If ($Variables.office32 -or $Variables.Office64 -eq $true) {
		$Variables.officecheck = $true
	}
	
	If ($Variables.officecheck -eq $true) {
		Write-Status "Office Exists" 'WAITING' -WriteWarning
	} Else {
		$message = "There are no Microsoft Office products on this device."
		Write-Status $Message '?' -WriteWarning
		Add-Content -Path $Variables.Log -Value $message
	}
	
	If ($Variables.officecheck -eq $true) {
		Remove-Office
	}
}
Function Get-RAM {
<#
.SYNOPSIS
The Get-RAM function uses the Get-CimInstance cmdlet to retrieve the total physical memory of the computer.
It then converts the value to GB and returns it as a formatted string.
.NOTES
Author: Circlol
Version: 1.0
Changes:
1.0:
    - Started logging changes.
#>
	[CmdletBinding()]
	[OutputType([String])]
	param ()
	
	# Retrieve total physical memory of the computer
	$ram = Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
	
	# Convert value to GB and return as formatted string
	$ram = $ram / 1GB
	return "{0:N2} GB" -f $ram
}
function Get-SystemInfo {
<#
.SYNOPSIS
This function retrieves system information such as CPU, GPU, RAM, Motherboard, OS, and Disk Info.

.NOTES
Author: Circlol
Last Edit: 10-16-2023
#>
	[CmdletBinding()]
	[OutputType([String])]
	param ()
	
	Begin {
		# Grab CPU info
		try {
			$cpu = Get-CimInstance -ClassName Win32_Processor -Property Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed, SocketDesignation
			$cpuName = $cpu.Name
			$SocketDesignation = $cpu.SocketDesignation
			$clockSpeed = $cpu.MaxClockSpeed / 1000
			$clockSpeed = [math]::Round($clockSpeed, 2)
			$CPUCombinedString = "$cpuName @ $clockSpeed GHz on $SocketDesignation"
		} catch {
			return "Error retrieving CPU information: $($_)"
			Continue
		}
		
		# Grab GPU info
		try {
			$gpu = (Get-CimInstance -ClassName Win32_VideoController).Name
		} catch {
			return "Error retrieving GPU information: $($_)"
			Continue
		}
		
		# Grab RAM info
		try {
			$ram = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
			$ram = $ram / 1GB
		} catch {
			return "Error retrieving RAM information: $($_)"
			Continue
		}
		
		# Grab Motherboard info
		try {
			$motherboardModel = (Get-CimInstance -ClassName Win32_BaseBoard).Product
			$motherboardOEM = (Get-CimInstance -ClassName Win32_BaseBoard).Manufacturer
			$BIOSVersion = (Get-CimInstance -ClassName Win32_BIOS).Caption
			$BIOSReleaseDate = (Get-CimInstance -ClassName Win32_BIOS).ReleaseDate
			$motherboardSerial = (Get-CimInstance -ClassName Win32_BaseBoard).SerialNumber
			$MotherboardCombinedString = "$motherboardOEM $motherboardModel`n    - Serial: ($motherboardSerial)`n    - BIOS: $BIOSVersion`n    - BIOS Release Date: $BIOSReleaseDate"
		} catch {
			return "Error retrieving Motherboard information: $($_)"
			Continue
		}
		
		# Grab Windows Version
		try {
			$PathToLMCurrentVersion = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
			$WinVer = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption -replace 'Microsoft ', ''
			$DisplayVersion = (Get-ItemProperty $PathToLMCurrentVersion).DisplayVersion
			$osBuildNumber = (Get-ItemProperty $PathToLMCurrentVersion).CurrentBuild
			$completedBuildNumber = "$DisplayVersion ($osBuildNumber)"
		} catch {
			return "Error retrieving Windows information: $($_)"
			Continue
		}
		
		# Grabs drive space
		try {
			$drives = Get-PSDrive -PSProvider FileSystem | Where-Object {
				$_.Free -ge 0 -and $_.Used -ge 0
			}
			foreach ($drive in $drives) {
				$driveRoot = $drive.Root
				$availableStorage = $drive.Free / 1TB
				$totalStorage = ($drive.Free + $drive.Used) / 1TB
				$percentageAvailable = [math]::Round(($availableStorage / $totalStorage) * 100, 1)
				
				$unit = "TB"
				
				# Check if the available storage is less than 1 TB, then display it in GB
				if ($availableStorage -lt 1) {
					$availableStorage = $availableStorage * 1024
					$totalStorage = $totalStorage * 1024
					$unit = "GB"
				} elseif ($availableStorage -lt 0.1) {
					$availableStorage = $availableStorage * 1024 * 1024
					$totalStorage = $totalStorage * 1024 * 1024
					$unit = "MB"
				}
				
				# Create a visual bar for the storage percentage
				$barLength = 20
				$filledLength = [math]::Round($barLength * ($percentageAvailable / 100))
				$emptyLength = $barLength - $filledLength
				$storageBar = "[" + ("#" * $filledLength) + ("." * $emptyLength) + "]"
				
				$driveInfo = "    $driveRoot $([math]::Round($availableStorage, 1)) $unit free of $([math]::Round($totalStorage, 1)) $unit ($percentageAvailable% Available) $storageBar"
				$CombinedDriveInfo = "$($CombinedDriveInfo)`n$($driveInfo)"
			}
		} catch {
			return "Error retrieving disk information: $($_)"
			Continue
		}
		
		# Grabs screen resolution and refresh rate
		try {
			$screenResolutionHorizontal = (Get-CimInstance -ClassName Win32_VideoController).CurrentHorizontalResolution
			$screenResolutionVertical = (Get-CimInstance -ClassName Win32_VideoController).CurrentVerticalResolution
			$screenRefreshRate = (Get-CimInstance -ClassName Win32_VideoController).CurrentRefreshRate
			$screenCombinedString = "$screenResolutionHorizontal`x$screenResolutionVertical @$screenRefreshRate`Hz"
		} catch {
			return "Error retrieving screen information: $($_)"
			Continue
		}
		
		$title = "$env:USERNAME@$env:COMPUTERNAME"
		$line = "-" * $title.Length
		$CombinedString = "
$title
$line

OS: $WinVer 
Build: $completedBuildNumber
Resolution: $screenCombinedString
CPU: $($CPUCombinedString)
GPU: $($gpu.Trim())
RAM: $("{0:N2} GB" -f $ram)
Motherboard: $($MotherboardCombinedString)
Disk Info: $($CombinedDriveInfo)
"
	}
	process {
		return $CombinedString
	}
}


#endregion
#region Optimizations
Function Optimize-General {
<#
.SYNOPSIS
This function optimizes Windows 10 and 11 by disabling various features and services.

.NOTES
Author: Circlol
Version: 1.0
Release Notes:
1.0.1:
- Added support for undoing the optimization process.
- Removes copilot from taskbar
1.0:
- Started logging changes.

#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Undo,
		[Switch]$Skip = $SkipOptimization
	)
	$Zero = 0
	$One = 1
	$OneTwo = 1
	Set-ScriptStatus -WindowTitle "Optimization" -TweakTypeText "Registry" -TitleCounterText "Optimization" -TitleText "Optimization: General" -LogSection "Optimize: General Tweaks"	
	$EnableStatus = @(
		@{
			Symbol = "-"; Status = "Disabling";
		}
		@{
			Symbol = "+"; Status = "Enabling";
		}
	)
	
	If (($Undo)) {
		Write-Status "Reverting the tweaks is set to '$Undo'." "<"
		$Zero = 1
		$One = 0
		$OneTwo = 2
		$EnableStatus = @(
			@{
				Symbol = "<"; Status = "Re-Enabling";
			}
			@{
				Symbol = "<"; Status = "Re-Disabling";
			}
		)
	}
	
	If ($Skip) {
		Write-Status "Parameter -Skip was detected.. Skipping General Tweaks." "@" -WriteWarning -ForegroundColor Red
	} else {
		if ($PSCmdlet.ShouldProcess("Optimize-General", "Optimize on General Tweaks")) {
			If ($Variables.osVersion -like "*Windows 10*") {
				#region 10
				Write-Section -Text "Applying Windows 10 Specific Reg Keys"
				
				## Changes search box to an icon
				Write-Status "Switching Search Box to an Icon." $EnableStatus[0].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToCUSearch -Name "SearchboxTaskbarMode" -Value $OneTwo -Type DWord
				
				## Removes Cortana from the taskbar
				Write-Status "$($EnableStatus[0].Status) Cortana Button from Taskbar..." $EnableStatus[0].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToCUExplorerAdvanced -Name "ShowCortanaButton" -Value $Zero -Type DWord
				
				##  Removes 3D Objects from "This PC"
				Write-Status "$($EnableStatus[0].Status)  3D Objects from This PC.." $EnableStatus[0].Symbol
				Get-Item $Registry.PathToHide3DObjects | Remove-Item -Recurse
				
				# Expands ribbon in 10 explorer
				Write-Status "$($EnableStatus[1].Status) Expanded Ribbon in Explorer.." $EnableStatus[1].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToCUExplorerRibbon -Name "MinimizedStateTabletModeOff" -Type DWORD -Value $Zero
				
				## Disabling Feeds Open on Hover
				Write-Status "$($EnableStatus[0].Status) Feeds Open on Hover..." $EnableStatus[0].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToRegCurrentVersionFeeds -Name "ShellFeedsTaskbarOpenOnHover" -Value $Zero -Type DWord
				
				#Disables live feeds in search
				Write-Status "$($EnableStatus[0].Status) Dynamic Content in Windows Search..." $EnableStatus[0].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToCUFeedsDSB -Name "ShowDynamicContent" -Value $Zero -type DWORD
				Set-ItemPropertyVerified -Path $Registry.PathToCUSearchSettings -Name "IsDynamicSearchBoxEnabled" -Value $Zero -Type DWORD
				
				#endregion
			} elseif ($Variables.osVersion -like "*Windows 11*") {
				#region 11
				Write-Section -Text "Applying Windows 11 Specific Reg Keys"
				
				# Sets Start Menu to More icons
				Write-Status "$($EnableStatus[1].Status) More Icons in the Start Menu.." $EnableStatus[1].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToCUExplorerAdvanced -Name Start_Layout -Value $One -Type DWORD -Force
				
				# Sets Scrollbars to always shown
				Write-Status "$($EnableStatus[1].Status) Always Show Scroll Bars..." $EnableStatus[1].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToCUAccessibility -Name DynamicScrollbars -Value $Zero -Type DWORD
				
				# Sets explorer to compact mode
				Write-Status "$($EnableStatus[0].Status) Compact Mode View in Explorer..." $EnableStatus[0].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToCUExplorerAdvanced -Name UseCompactMode -Value $One -Type DWORD
				
				# Removes Chats from the taskbar
				Write-Status "$($EnableStatus[0].Status) Chats from the Taskbar..." $EnableStatus[0].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToCUExplorerAdvanced -Name "TaskBarMn" -Value $Zero -Type DWORD
				
				# Removes Copilot from the taskbar
				Write-Status "$($EnableStatus[0].Status) Copilot from the Taskbar..." $EnableStatus[0].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToCUExplorerAdvanced -Name "ShowCopilotButton" -Type DWORD -Value $Zero
				
				# Removes Meet Now from the taskbar
				Write-Status "$($EnableStatus[0].Status) Meet Now from the Taskbar..." $EnableStatus[0].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToRegCurrentVersionExplorerPolicy -Name "HideSCAMeetNow" -Type DWORD -Value $One
				
				# Adds End Task to taskbar
				Write-Status "$($EnableStatus[1].Status) End Task on the Taskbar..." $EnableStatus[1].Symbol
				Set-ItemPropertyVerified -Path $Registry.TaskBarEndTask -Name "TaskbarEndTask" -Type DWORD -Value $One


				#endregion
			} else {
				# code for other operating systems
				Get-Error $Error[0]
				Stop-Process $Pid
			}
			
			Write-Section -Text "Explorer Related"
			
			## Unpins taskview from Taskbar
			Write-Status "$($EnableStatus[0].Status) Task View from Taskbar..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToCUExplorerAdvanced -Name "ShowTaskViewButton" -Value $Zero -Type DWord
			
			
			# Pinning This PC to Quick Access Page in Home (11) & Quick Access (10)
			Write-Status "$($EnableStatus[1].Status) This PC in Quick Access..." $EnableStatus[1].Symbol
			$ThisPC = (New-Object -ComObject Shell.Application).Namespace(0).ParseName("::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
			$verbs = $ThisPC.Verbs()
			foreach ($verb in $verbs) {
				if ($verb.Name -eq "Pin to Quick access") {
					$verb.DoIt()
					break
				}
			}
			
			### Explorer related
			# Removes recent files in explorer quick menu
			Write-Status "$($EnableStatus[0].Status) Show Recents in Explorer..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToCUExplorer -Name "ShowRecent" -Value $Zero -Type DWORD
			
			# Removes frequent files in explorer quick menu
			Write-Status "$($EnableStatus[0].Status) Show Frequent in Explorer..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToCUExplorer -Name "ShowFrequent" -Value $Zero -Type DWORD
			
			# Removes drives without any media (usb hubs, wifi adapters, sd card readers, ect.)
			Write-Status "$($EnableStatus[0].Status) Show Drives without Media..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToCUExplorerAdvanced -Name "HideDrivesWithNoMedia" -Type DWord -Value $Zero
			
			# Launches Explorer to This PC
			Write-Status "Setting Explorer Launch to This PC.." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToCUExplorerAdvanced -Name "LaunchTo" -Value $One -Type Dword
			
			# Adds User shortcut to desktop
			Write-Status "$($EnableStatus[1].Status) User Files to Desktop..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path "$($Registry.PathToCUExplorer)\HideDesktopIcons\NewStartPanel" -Name $Variables.UsersFolder -Value $Zero -Type DWORD
			
			# Adds This PC shortcut to desktop
			Write-Status "$($EnableStatus[1].Status) This PC to Desktop..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path "$($Registry.PathToCUExplorer)\HideDesktopIcons\NewStartPanel" -Name $Variables.ThisPC -Value $Zero -Type DWORD
			
			# Expands details of file operations window
			Write-Status "$($EnableStatus[1].Status) Expanded File Operation Details by Default.." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path "$($Registry.PathToCUExplorer)\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value $One
				
		}
	}
}
Function Optimize-Performance {
<#
.SYNOPSIS
This function optimizes Windows 10 and 11 by disabling various features and services.
	
.NOTES
Author: Circlol
Version: 1.0
Release Notes:
1.0:
- Started logging changes.

#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Int]$Zero = 0,
		[Int]$One = 1,
		[Int]$OneTwo = 1,
		[Switch]$Undo,
		[Switch]$Skip = $SkipOptimization
	)
	Set-ScriptStatus -TweakTypeText "Performance" -TitleText "Optimization: Performance" -LogSection "Optimize: Performance Tweaks"
	$EnableStatus = @(
		@{
			Symbol = "-"; Status = "Disabling";
		}
		@{
			Symbol = "+"; Status = "Enabling";
		}
	)
	
	If (($Undo)) {
		Write-Status "Reverting the tweaks is set to '$Undo'." "<"
		$Zero = 1
		$One = 0
		$OneTwo = 2
		$EnableStatus = @(
			@{
				Symbol = "<"; Status = "Re-Enabling";
			}
			@{
				Symbol = "<"; Status = "Re-Disabling";
			}
		)
	}
	
	If ($Skip) {
		Write-Status "Parameter -Skip was detected.. Skipping Performance." "@" -WriteWarning -ForegroundColor Red
		
	} else {
		if ($PSCmdlet.ShouldProcess("Optimize-Performance", "Performance enhancing tweaks")) {
		# Power Plans
		Write-Section -Text "Power Plan Tweaks"
		Write-Status "Cleaning up duplicated Power plans..." "@"
		$ExistingPowerPlans = $((powercfg -L)[3 .. (powercfg -L).Count])
		# Found on the registry: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\Default\PowerSchemes
		$BuiltInPowerPlans = @{
			"Power Saver"		     = "a1841308-3541-4fab-bc81-f71556f20b4a"
			"Balanced" 				 = "381b4222-f694-41f0-9685-ff5bb260df2e"
			"High Performance"	     = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
		}
		$UniquePowerPlans = $BuiltInPowerPlans.Clone()
		ForEach ($PowerCfgString in $ExistingPowerPlans) {
			$PowerPlanGUID = $PowerCfgString.Split(':')[1].Split('(')[0].Trim()
			$PowerPlanName = $PowerCfgString.Split('(')[-1].Replace(')', '').Trim()
			If (($PowerPlanGUID -in $BuiltInPowerPlans.Values)) {
				Write-Status "The '$PowerPlanName' power plan` is built-in, skipping $PowerPlanGUID ..." '@'
				Continue
			}
			Try {
				If (($PowerPlanName -notin $UniquePowerPlans.Keys) -and ($PowerPlanGUID -notin $UniquePowerPlans.Values)) {
					$UniquePowerPlans.Add($PowerPlanName, $PowerPlanGUID)
				} Else {
					Write-Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..." "-" -NoNewLine
					powercfg -Delete $PowerPlanGUID
					Get-Status
				}
			} Catch {
				Write-Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..." "-" -NoNewLine
				powercfg -Delete $PowerPlanGUID
				Get-Status
			}
		}
		
		Write-Status "Setting Power Plan to High Performance..." $EnableStatus[1].Symbol -NoNewLine
		powercfg -SetActive "381b4222-f694-41f0-9685-ff5bb260df2e"
		Get-Status
		
		Write-Caption -Text "Display" -Type None
		Write-Status "Enable Hardware Accelerated GPU Scheduling... (Windows 10 20H1+ - Needs Restart)" $EnableStatus[1].Symbol
		Set-ItemPropertyVerified -Path $Registry.PathToGraphicsDrives -Name "HwSchMode" -Type DWord -Value 2
		

		# Details: https://www.tenforums.com/tutorials/94628/change-split-threshold-svchost-exe-windows-10-a.html
		# Will reduce Processes number considerably on > 4GB of RAM systems
		Write-Status "Setting SVCHost to match installed RAM size..." $EnableStatus[1].Symbol
		$RamInKB = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1KB
		Set-ItemPropertyVerified -Path $Registry.PathToLMControl -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $RamInKB
		
		
		Write-Section "Microsoft Edge Tweaks"
		Write-Caption -Text "System and Performance" -Type None
		
		Write-Status "$($EnableStatus[0].Status) Edge Startup boost..." $EnableStatus[0].Symbol
		Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesEdge -Name "StartupBoostEnabled" -Type DWord -Value $Zero
		
		Write-Status "$($EnableStatus[0].Status) run extensions and apps when Edge is closed..." $EnableStatus[0].Symbol
		Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesEdge -Name "BackgroundModeEnabled" -Type DWord -Value $Zero
		
		# Sleep Settings
		$Num = 0
		foreach ($Setting in $OptionalFeatures.SleepSettings) {
			Write-Status "Setting the $($OptionalFeatures.SleepText[$Num])..." $EnableStatus[1].Symbol -NoNewLine
			powercfg /X $Setting
			Get-Status
			$Num++
		}

	
		Write-Status "Setting Power Plan to High Performance..." $EnableStatus[1].Symbol -NoNewLine
		powercfg /S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
		Get-Status
		Write-Status "Creating the Ultimate Performance hidden Power Plan..." $EnableStatus[1].Symbol -NoNewLine
		powercfg /DuplicateScheme e9a42b02-d5df-448d-aa00-03f14749eb61
		Get-Status
		
		
		Write-Section "Network & Internet"
		Write-Status "Unlimiting your network bandwidth for all your system..." $EnableStatus[1].Symbol
		# Based on this Chris Titus video: https://youtu.be/7u1miYJmJ_4
		Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesPsched -Name "NonBestEffortLimit" -Type DWord -Value 0
		Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfile -Name "NetworkThrottlingIndex" -Type DWord -Value 0xffffffff
		Write-Section "System & Apps Timeout behaviors"
		Write-Status "Reducing Time to services app timeout to 2s to ALL users..." $EnableStatus[1].Symbol
		Set-ItemPropertyVerified -Path $Registry.PathToLMControl -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000 # Default: 20000 / 5000
		Write-Status "Don't clear page file at shutdown (takes more time) to ALL users..." "*"
		Set-ItemPropertyVerified -Path $Registry.PathToLMMemoryManagement -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
		Write-Status "Reducing mouse hover time events to 10ms..." $EnableStatus[1].Symbol
		Set-ItemPropertyVerified -Path $Registry.PathToCUMouse -Name "MouseHoverTime" -Type String -Value "1000" # Default: 400
		# Details: https://windowsreport.com/how-to-speed-up-windows-11-animations/ and https://www.tenforums.com/tutorials/97842/change-hungapptimeout-value-windows-10-a.html
		ForEach ($DesktopRegistryPath in @($Registry.PathToUsersControlPanelDesktop, $Registry.PathToCUControlPanelDesktop)) {
<# $DesktopRegistryPath is the path related to all users and current user configuration #>
			If ($DesktopRegistryPath -eq $Registry.PathToUsersControlPanelDesktop) {
				Write-Caption -Text "TO ALL USERS" -Type None
			} ElseIf ($DesktopRegistryPath -eq $Registry.PathToCUControlPanelDesktop) {
				Write-Caption -Text "TO CURRENT USER" -Type None
			}
			Write-Status "Don't prompt user to end tasks on shutdown..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path $DesktopRegistryPath -Name "AutoEndTasks" -Type DWord -Value 1 # Default: Removed or 0
			
			If ((Get-Item "$DesktopRegistryPath").Property -contains "HungAppTimeout") {
				Write-Status "Returning 'Hung App Timeout' to default..." "*"
				Remove-ItemProperty "$DesktopRegistryPath" -Name "HungAppTimeout"
			}
			
			Write-Status "Reducing mouse and keyboard hooks timeout to 1s..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path "$DesktopRegistryPath" -Name "LowLevelHooksTimeout" -Type DWord -Value 1000 # Default: Removed or 5000
			
			Write-Status "Reducing animation speed delay to 1ms on Windows 11..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path "$DesktopRegistryPath" -Name "MenuShowDelay" -Type DWord -Value 1 # Default: 400
			
			Write-Status "Reducing Time to kill apps timeout to 5s..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path "$DesktopRegistryPath" -Name "WaitToKillAppTimeout" -Type DWord -Value 5000 # Default: 20000
		}
		
		Write-Section "Gaming Responsiveness Tweaks"
		Write-Status "Enabling game mode..." "*"
		Set-ItemPropertyVerified -Path $Registry.PathToCUGameBar -Name "AllowAutoGameMode" -Type DWord -Value 1
		Set-ItemPropertyVerified -Path $Registry.PathToCUGameBar -Name "AutoGameModeEnabled" -Type DWord -Value 1
		
		# Details: https://www.reddit.com/r/killerinstinct/comments/4fcdhy/an_excellent_guide_to_optimizing_your_windows_10/
		Write-Status "Reserving 100% of CPU to Multimedia/Gaming tasks..." $EnableStatus[1].Symbol
		Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfile -Name "SystemResponsiveness" -Type DWord -Value 0 # Default: 20
		
		Write-Status "Dedicate more CPU/GPU usage to Gaming tasks..." $EnableStatus[1].Symbol
		Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfileOnGameTask -Name "GPU Priority" -Type DWord -Value 8 # Default: 8
		Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfileOnGameTask -Name "Priority" -Type DWord -Value 6 # Default: 2
		Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfileOnGameTask -Name "Scheduling Category" -Type String -Value "High" # Default: "Medium"
		}
	}
	
}
Function Optimize-Privacy {
<#
.SYNOPSIS
Performs privacy optimizations on the Windows operating system.

.NOTES
Author: Circlol
Version: 1.0
Release Notes:
1.0:
- Started logging changes.

#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Int]$Zero = 0,
		[Int]$One = 1,
		[Int]$OneTwo = 1,
		[Switch]$Undo,
		[Switch]$Skip = $SkipOptimization
	)
	Set-ScriptStatus -TweakTypeText "Privacy" -TitleText "Optimization: Privacy" -LogSection "Optimize: Privacy Tweaks"
	$EnableStatus = @(
		@{
			Symbol = "-"; Status = "Disabling";
		}
		@{
			Symbol = "+"; Status = "Enabling";
		}
	)
	
	If (($Undo)) {
		Write-Status "Reverting the tweaks is set to '$Undo'." "<"
		$Zero = 1
		$One = 0
		$OneTwo = 2
		$EnableStatus = @(
			@{
				Symbol = "<"; Status = "Re-Enabling";
			}
			@{
				Symbol = "<"; Status = "Re-Disabling";
			}
		)
	}
	
	If ($Skip) {
		Write-Status "Parameter -Skip was detected.. Skipping Privacy Tweaks." "@" -WriteWarning -ForegroundColor Red
		
	} else {
		
		if ($PSCmdlet.ShouldProcess("Optimize-Privacy", "Optimize on Privacy")) {
			
			Write-Section -Text "Personalization"
			Write-Caption -Text "Start & Lockscreen"
			
			# Executes the array above
			Write-Status "From Path: [$($Registry.PathToCUContentDeliveryManager)]." "?" -WriteWarning
			ForEach ($Name in $Registry.ContentDeliveryManagerDisableOnZero) {
				Write-Status "$($EnableStatus[0].Status) $($Name): $Zero" $EnableStatus[0].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToCUContentDeliveryManager -Name "$Name" -Type DWord -Value $Zero
			}
			
			# Disables content suggestions in settings
			If (Test-Path "$($Registry.PathToCUContentDeliveryManager)\Subscriptions") {
				Write-Status "$($EnableStatus[0].Status) 'Suggested Content in the Settings App'..." "-" -NoNewLine
				Remove-Item -Path "$($Registry.PathToCUContentDeliveryManager)\Subscriptions" -Recurse
				Get-Status
			}
			
			# Disables content suggestion in start
			If (Test-Path "$($Registry.PathToCUContentDeliveryManager)\SuggestedApps") {
				Write-Status "$($EnableStatus[0].Status) 'Show Suggestions' in Start..." $EnableStatus[0].Symbol -NoNewLine
				Remove-Item -Path "$($Registry.PathToCUContentDeliveryManager)\SuggestedApps" -Recurse
				Get-Status
			}
			
			Write-Section -Text "Privacy -> Windows Permissions"
			Write-Caption -Text "General"
			
			# Disables Advertiser ID through permissions and group policy.
			Write-Status "$($EnableStatus[0].Status) Let apps use my advertising ID..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToRegAdvertising -Name "Enabled" -Type DWord -Value $Zero
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesAdvertisingInfo -Name "DisabledByGroupPolicy" -Type DWord -Value $One
			
			# Disables locally relevant content
			Write-Status "$($EnableStatus[0].Status) 'Let websites provide locally relevant content by accessing my language list'..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToCUUP -Name "HttpAcceptLanguageOptOut" -Type DWord -Value $One
			
			Write-Caption -Text "Speech"
			# Removes consent for online speech recognition services.
			# [@] (0 = Decline, 1 = Accept)
			Write-Status "$($EnableStatus[0].Status) Online Speech Recognition..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToCUOnlineSpeech -Name "HasAccepted" -Type DWord -Value $Zero
			
			Write-Caption -Text "Inking & Typing Personalization"
			# Disables personalization of inking and typing data (Keystrokes)
			Set-ItemPropertyVerified -Path "$($Registry.PathToCUInputPersonalization)\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value $Zero
			Set-ItemPropertyVerified -Path $Registry.PathToCUInputPersonalization -Name "RestrictImplicitInkCollection" -Type DWord -Value $One
			Set-ItemPropertyVerified -Path $Registry.PathToCUInputPersonalization -Name "RestrictImplicitTextCollection" -Type DWord -Value $One
			Set-ItemPropertyVerified -Path $Registry.PathToCUPersonalization -Name "AcceptedPrivacyPolicy" -Type DWord -Value $Zero
			
			Write-Caption -Text "Diagnostics & Feedback"
			#Disables Telemetry
			Write-Status "$($EnableStatus[0].Status) telemetry..." $EnableStatus[0].Symbol
			# [@] (0 = Security (Enterprise only), 1 = Basic Telemetry, 2 = Enhanced Telemetry, 3 = Full Telemetry)
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesTelemetry -Name "AllowTelemetry" -Type DWord -Value $Zero
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesTelemetry2 -Name "AllowTelemetry" -Type DWord -Value $Zero
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesTelemetry -Name "AllowDeviceNameInTelemetry" -Type DWord -Value $Zero
			# Disables Microsofts collection of inking and typing data
			Write-Status "$($EnableStatus[0].Status) send inking and typing data to Microsoft..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToCUInputTIPC -Name "Enabled" -Type DWord -Value $Zero
			# Disables Microsoft's tailored experiences.
			Write-Status "$($EnableStatus[0].Status) Tailored Experiences..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToPrivacy -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Type DWord -Value $Zero
			# Disables transcript of diagnostic data for collection
			Write-Status "$($EnableStatus[0].Status) View diagnostic data..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToLMEventKey -Name "EnableEventTranscript" -Type DWord -Value $Zero
			# Sets feedback frequency to 0
			Write-Status "$($EnableStatus[0].Status) feedback frequency..." $EnableStatus[0].Symbol
			If ((Test-Path "$($Registry.PathToCUSiufRules)\PeriodInNanoSeconds")) {
				Remove-ItemProperty -Path $Registry.PathToCUSiufRules -Name "PeriodInNanoSeconds"
			}
			Set-ItemPropertyVerified -Path $Registry.PathToCUSiufRules -Name "NumberOfSIUFInPeriod" -Type DWord -Value $Zero
			
			Write-Caption -Text "Activity History"
			Write-Status "$($EnableStatus[0].Status) Activity History..." $EnableStatus[0].Symbol
			Write-Status "From Path: [$($Registry.PathToLMActivityHistory)]" "?" -WriteWarning
			ForEach ($Name in $Registry.ActivityHistoryDisableOnZero) {
				Write-Status "$($EnableStatus[0].Status) $($Name): $Zero" $EnableStatus[0].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToLMActivityHistory -Name $Name -Type DWord -Value $Zero
			}
			# Disables Suggested ways of getting the most out of windows (Microsoft account spam)
			Write-Status "$($EnableStatus[1].Status) 'Suggest ways i can finish setting up my device to get the most out of windows.')" "-"
			Set-ItemPropertyVerified -Path $Registry.PathToCUUserProfileEngagemment -Name "ScoobeSystemSettingEnabled" -Value $Zero -Type DWord
			
			### Privacy
			Write-Section -Text "Privacy"
			
			If (Test-Path "$($Registry.PathToCUContentDeliveryManager)\Subscription") {
				Write-Status "Removing $($Registry.PathToCUContentDeliveryManager)\Subscription" '-' -NoNewLine
				Remove-Item "$($Registry.PathToCUContentDeliveryManager)\Subscription" -Recurse
				Get-Status
			}
			#Get-Item "$($Registry.PathToCUContentDeliveryManager)\SuggestedApps" | Remove-Item -Recurse
			If (Test-Path -Path "$($Registry.PathToCUContentDeliveryManager)\SuggestedApps") {
				Write-Status "Removing $($Registry.PathToCUContentDeliveryManager)\SuggestedApps" '-' -NoNewLine
				Remove-Item -Path "$($Registry.PathToCUContentDeliveryManager)\SuggestedApps" -Recurse
				Get-Status
			}
			
			# Disables app launch tracking
			Write-Status "$($EnableStatus[0].Status) App Launch Tracking..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.EdgeUI -Name "DisableMFUTracking" -Value $One -Type DWORD
			
			If ($vari -eq 2) {
				Remove-Item -Path $Registry.EdgeUI
			}
			
			# Sets windows feeback notifciations to never show
			Write-Status "$($EnableStatus[0].Status) Windows Feedback Notifications..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesTelemetry -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value $One
			
			# Disables location tracking
			Write-Status "$($EnableStatus[0].Status) Location Tracking..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.RegLocationLM -Name "Value" -Type String -Value "Allow"
			Set-ItemPropertyVerified -Path $Registry.PathToLFSVC -Name "Status" -Type DWORD -Value $Zero
			
			# Let desktop apps access your location
			Write-Status "$($EnableStatus[0].Status) desktop app access to your Location..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path "$($Registry.RegLocationCU)\NonPackaged" -Name "Value" -Value "Deny" -Type String

			# Let desktop apps access your location
			Write-Status "$($EnableStatus[0].Status) app access to your Location..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.RegLocationCU -Name "Value" -Value "Deny" -Type String


			# Disables map updates (Windows Maps is removed)
			Write-Status "$($EnableStatus[0].Status) Automatic Map Updates..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\Maps -Name "AutoUpdateEnabled" -Type DWORD -Value $Zero
			
			# AutoConnect to Hotspots disabled
			Write-Status "$($EnableStatus[0].Status) AutoConnect to Sense Hotspots..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path "$($Registry.PathToLMPoliciesToWifi)\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWORD -Value $Zero
			
			# Disables reporting hotspots to microsoft
			Write-Status "$($EnableStatus[0].Status) Hotspot Reporting to Microsoft..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path "$($Registry.PathToLMPoliciesToWifi)\AllowWiFiHotSpotReporting" -Name "Value" -Type DWORD -Value $Zero
			
			# Disables cloud content from search (OneDrive, Office, Dropbox, ect.)
			Write-Status "$($EnableStatus[0].Status) Cloud Content from Windows Search..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesCloudContent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value $One
			
			# Disables tailored experience w users diagnostic data.
			Write-Status "$($EnableStatus[0].Status) Tailored Experience w/ Diagnostic Data..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToPrivacy -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value $Zero -Type DWORD
			
<# Disables HomeGroup
Write-Status -Types $EnableStatus[1].Symbol, "$TweakType" -Status "Stopping and disabling Home Groups services.."
If (!(Get-Service -Name HomeGroupListener )) { } else {
Stop-Service "HomeGroupListener"
Set-Service "HomeGroupListener" -StartupType Disabled
}
If (!(Get-Service -Name HomeGroupListener )) { } else {
Stop-Service "HomeGroupProvider"
Set-Service "HomeGroupProvider" -StartupType Disabled
}#>
			
			# Disables SysMain
			If ((Get-Service -Name SysMain).Status -eq 'Stopped') {
			} else {
				try {
					Write-Status 'Stopping Superfetch service' '-' -NoNewLine
					Stop-Service "SysMain"
					Get-Status
				} catch {
					Get-Status
					Get-Error $Error[0]
				}
				try {
					Write-Status 'Stopping Superfetch service' '-' -NoNewLine
					Set-Service "SysMain" -StartupType Disabled
					Get-Status
				} catch {
					Get-Status
					Get-Error $Error[0]
				}
			}
			
			
			
			# Disables volume lowering during calls
			Write-Status "$($EnableStatus[0].Status) Volume Adjustment During Calls..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path "HKCU:\Software\Microsoft\MultiMedia\Audio" -Name "UserDuckingPreference" -Value 3 -Type DWORD
			
			# Groups SVChost processes
			$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
			Write-Status "Grouping svchost.exe Processes" $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWORD -Value $ram
			
			# Stack size increased for greater performance
			Write-Status "Increasing Stack Size to 30" $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "IRPStackSize" -Type DWORD -Value 30
			
			# Sets DNS settings to Google with CloudFlare as backup
			If (Get-Command Set-DnsClientDohServerAddress) {
				Write-Status "Setting up the DNS over HTTPS for Cloudflare (ipv4 and ipv6)..." $EnableStatus[1].Symbol
				# Cloudflare
				Set-DnsClientDohServerAddress -ServerAddress ("1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2606:4700:4700::1001") -AutoUpgrade $true -AllowFallbackToUdp $true
				Write-Status "Setting up the DNS from Cloudflare (ipv4 and ipv6)..." $EnableStatus[1].Symbol
				Set-DNSClientServerAddress -InterfaceAlias "Ethernet*" -ServerAddresses ("1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2001:4860:4860::8888")
				Set-DNSClientServerAddress -InterfaceAlias "Wi-Fi*" -ServerAddresses ("1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2001:4860:4860::8888")
			} else {
				Write-Status "Failed to set up DNS - DNSClient is not Installed..." "?" -WriteWarning
			}
			
			Write-Section -Text "Ease of Access"
			Write-Caption -Text "Keyboard"
			# Disables Sticky Keys
			Write-Status "$($EnableStatus[0].Status) Sticky Keys..." "-"
			Set-ItemPropertyVerified -Path "$($Registry.PathToCUAccessibility)\StickyKeys" -Name "Flags" -Value 506 -Type STRING
			Set-ItemPropertyVerified -Path "$($Registry.PathToCUAccessibility)\Keyboard Response" -Name "Flags" -Value 122 -Type STRING
			Set-ItemPropertyVerified -Path "$($Registry.PathToCUAccessibility)\ToggleKeys" -Name "Flags" -Value 58 -Type STRING
			
			If ($Undo) {
				Remove-ItemPropertyVerified -Path $Registry.PathToLMPoliciesTelemetry -Name "AllowTelemetry"
				Remove-ItemPropertyVerified -Path $Registry.PathToLMPoliciesTelemetry2 -Name "AllowTelemetry"
				Remove-ItemPropertyVerified -Path $Registry.PathToCUPersonalization -Name "AcceptedPrivacyPolicy"
				Remove-ItemPropertyVerified -Path $Registry.PathToCUInputPersonalization -Name "RestrictImplicitTextCollection"
				Remove-ItemPropertyVerified -Path $Registry.PathToCUInputPersonalization -Name "RestrictImplicitInkCollection"
				Set-Service "DiagTrack" -StartupType Automatic
				Set-Service "dmwappushservice" -StartupType Automatic
				Set-Service "SysMain" -StartupType Automatic
			}
			
			Write-Section -Text "Privacy -> Apps Permissions"
			Write-Caption -Text "Notifications"
			Set-ItemPropertyVerified -Path $Registry.PathToLMConsentStoreUN -Name "Value" -Value "Deny" -Type String
			
			Write-Caption -Text "App Diagnostics"
			Set-ItemPropertyVerified -Path $Registry.PathToCUConsentStoreAD -Name "Value" -Value "Deny" -Type String
			Set-ItemPropertyVerified -Path $Registry.PathToLMConsentStoreAD -Name "Value" -Value "Deny" -Type String
			
			Write-Caption -Text "Account Info Access"
			Set-ItemPropertyVerified -Path $Registry.PathToCUConsentStoreUAI -Name "Value" -Value "Deny" -Type String
			Set-ItemPropertyVerified -Path $Registry.PathToLMConsentStoreUAI -Name "Value" -Value "Deny" -Type String
			
			Write-Caption -Text "Voice Activation"
			Write-Status "$($EnableStatus[0].Status) Voice Activation" $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToVoiceActivation -Name "AgentActivationEnabled" -Value $Zero -Type DWord
			
			Write-Caption -Text "Background Apps"
			Write-Status "$($EnableStatus[0].Status) Background Apps" $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToBackgroundAppAccess -Name "GlobalUserDisabled" -Value $One -Type DWord
			Write-Status "$($EnableStatus[0].Status) Background Apps Global" $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToCUSearch -Name "BackgroundAppGlobalToggle" -Value $Zero -Type DWord
			
			Write-Caption -Text "Other Devices"
			Write-Status "Denying device access..." "-"
			# Disable sharing information with unpaired devices
			Set-ItemPropertyVerified -Path "$($Registry.PathToCUDeviceAccessGlobal)\LooselyCoupled" -Name "Value" -Value "Deny" -Type String
			ForEach ($key in (Get-ChildItem $Registry.PathToCUDeviceAccessGlobal)) {
				If ($key.PSChildName -EQ "LooselyCoupled") {
					continue
				}
				Write-Status "$($EnableStatus[1].Status) Setting $($key.PSChildName) value to 'Deny' ..." $EnableStatus[1].Symbol
				Set-ItemPropertyVerified -Path "$("$($Registry.PathToCUDeviceAccessGlobal)\" + $key.PSChildName)" -Name "Value" -Value "Deny"
			}
			
			Write-Caption -Text "Background Apps"
			Write-Status "$($EnableStatus[1].Status) Background Apps..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToBackgroundAppAccess -Name "GlobalUserDisabled" -Type DWord -Value 0
			Set-ItemPropertyVerified -Path $Registry.PathToCUSearch -Name "BackgroundAppGlobalToggle" -Type DWord -Value 1
			
			Write-Caption -Text "Troubleshooting"
			Write-Status "$($EnableStatus[1].Status) Automatic Recommended Troubleshooting, then notify me..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToLMWindowsTroubleshoot -Name "UserPreference" -Type DWord -Value 3
			
			Write-Section -Text "$($EnableStatus[0].Status) More Telemetry Features..."
			
			Write-Status "From Path: [$PathToCUPoliciesCloudContent]." "?" -WriteWarning
			ForEach ($Name in $Variables.CloudContentDisableOnOne) {
				Write-Status "$($EnableStatus[0].Status) $($Name): $One" $EnableStatus[0].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToCUPoliciesCloudContent -Name "$Name" -Type DWord -Value $One
			}
			Set-ItemPropertyVerified -Path $Registry.PathToCUPoliciesCloudContent -Name "ConfigureWindowsSpotlight" -Type DWord -Value 2
			Set-ItemPropertyVerified -Path $Registry.PathToCUPoliciesCloudContent -Name "IncludeEnterpriseSpotlight" -Type DWord -Value $Zero
			
			# Disabling app suggestions
			Write-Status "$($EnableStatus[0].Status) Apps Suggestions..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesCloudContent -Name "DisableThirdPartySuggestions" -Type DWord -Value $One
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesCloudContent -Name "DisableWindowsConsumerFeatures" -Type DWord -Value $One
			
			
			# Reference: https://forums.guru3d.com/threads/windows-10-registry-tweak-for-disabling-drivers-auto-update-controversy.418033/
			Write-Status "$($EnableStatus[0].Status) automatic driver updates..." $EnableStatus[0].Symbol
			# [@] (0 = Yes, do this automatically,
			#      1 = No, let me choose what to do, Always install the best,
			#      2 = [...] Install driver software from Windows Update,
			#      3 = [...] Never install driver software from Windows Update)
			Set-ItemPropertyVerified -Path $Registry.PathToLMDeviceMetaData -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value $One
			# [@] (0 = Enhanced icons enabled,
			#      1 = Enhanced icons disabled)
			Set-ItemPropertyVerified -Path $Registry.PathToLMDriverSearching -Name "SearchOrderConfig" -Type DWord -Value $Zero
			
			
			## Performance Tweaks and More Telemetry
			Set-ItemPropertyVerified -Path $Registry.PathToLMControl -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
			Set-ItemPropertyVerified -Path $Registry.PathToCUControlPanelDesktop -Name "MenuShowDelay" -Type DWord -Value 1
			Set-ItemPropertyVerified -Path $Registry.PathToCUControlPanelDesktop -Name "WaitToKillAppTimeout" -Type DWord -Value 5000
			Remove-ItemPropertyVerified -Path $Registry.PathToCUControlPanelDesktop -Name "HungAppTimeout"
			# Set-ItemPropertyVerified -Path $Registry.PathToCUControlPanelDesktop -Name "HungAppTimeout" -Type DWord -Value 4000 # Note: This caused flickering
			Set-ItemPropertyVerified -Path $Registry.PathToCUControlPanelDesktop -Name "AutoEndTasks" -Type DWord -Value 1
			Set-ItemPropertyVerified -Path $Registry.PathToCUControlPanelDesktop -Name "LowLevelHooksTimeout" -Type DWord -Value 1000
			Set-ItemPropertyVerified -Path $Registry.PathToCUControlPanelDesktop -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
			Set-ItemPropertyVerified -Path $Registry.PathToLMMemoryManagement -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
			Set-ItemPropertyVerified -Path $Registry.PathToCUMouse -Name "MouseHoverTime" -Type DWord -Value 10
			
			# Network Tweaks
			Set-ItemPropertyVerified -Path $Registry.PathToLMLanmanServer -Name "IRPStackSize" -Type DWord -Value 20
			
			# Gaming Tweaks
			Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfileOnGameTask -Name "GPU Priority" -Type DWord -Value 8
			Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfileOnGameTask -Name "Priority" -Type DWord -Value 6
			Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfileOnGameTask -Name "Scheduling Category" -Type String -Value "High"
			
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesSQMClient -Name "CEIPEnable" -Type DWord -Value $Zero
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesAppCompact -Name "AITEnable" -Type DWord -Value $Zero
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesAppCompact -Name "DisableUAR" -Type DWord -Value $One
			
			# Details: https://docs.microsoft.com/pt-br/windows-server/remote/remote-desktop-services/rds-vdi-recommendations-2004#windows-system-startup-event-traces-autologgers
			Write-Status "$($EnableStatus[0].Status) some startup event traces (AutoLoggers)..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path "$($Registry.PathToLMAutoLogger)\AutoLogger-Diagtrack-Listener" -Name "Start" -Type DWord -Value $Zero
			Set-ItemPropertyVerified -Path "$($Registry.PathToLMAutoLogger)\SQMLogger" -Name "Start" -Type DWord -Value $Zero
			
			Write-Status "$($EnableStatus[0].Status) 'WiFi Sense: HotSpot Sharing'..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path "$($Registry.PathToLMPoliciesToWifi)\AllowWiFiHotSpotReporting" -Name "value" -Type DWord -Value $Zero
			
			Write-Status "$($EnableStatus[0].Status) 'WiFi Sense: Shared HotSpot Auto-Connect'..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path "$($Registry.PathToLMPoliciesToWifi)\AllowAutoConnectToWiFiSenseHotspots" -Name "value" -Type DWord -Value $Zero
			
			ForEach ($Key in $Registry.KeysToDelete) {
				$KeyExist = Test-Path $key
				If ($KeyExist -eq $true) {
					Write-Status "Removing Key: [$Key]" "-"
					Remove-Item $Key -Recurse
				}
			}
		}
	}
}
Function Optimize-Security {
<#
.SYNOPSIS
This function applies various security patches and tweaks to optimize the security of the system.

.NOTES
Author: Circlol
Version: 1.0
Release Notes:
1.0:
- Started logging changes.

#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Int]$Zero = 0,
		[Int]$One = 1,
		[Int]$OneTwo = 1,
		[Switch]$Undo,
		[Switch]$Skip = $SkipOptimization
	)
	Set-ScriptStatus -TweakTypeText "Security" -TitleText "Optimization: Security" -LogSection "Optimize: Security Tweaks"
	$EnableStatus = @(
		@{
			Symbol = "-"; Status = "Disabling";
		} # 0 = Disabled
		@{
			Symbol = "+"; Status = "Enabling";
		} # 1 = Enabled
	)
	
	If (($Undo)) {
		Write-Status "Reverting the tweaks is set to '$Undo'." "<"
		$Zero = 1
		$One = 0
		$OneTwo = 2
		$EnableStatus = @(
			# Reversed
			@{
				Symbol = "+"; Status = "Enabling";
			} # 0 = Disabled
			@{
				Symbol = "-"; Status = "Disabling";
			} # 1 = Enabled
		)
	}
	If ($Skip) {
		Write-Status "Parameter -Skip was detected.. Skipping Security tweaks." "@" -WriteWarning -ForegroundColor Red
		
	} else {
		
		if ($PSCmdlet.ShouldProcess("Optimize-Security", "Optimize on Security")) {
			Write-Section "Security Patch"

			Write-Status "Applying Security Vulnerability Patch CVE-2023-36884 - Office and Windows HTML Remote Code Execution Vulnerability" $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path $Registry.SecurityPath -Name "Excel.exe" -Type DWORD -Value $One
			Set-ItemPropertyVerified -Path $Registry.SecurityPath -Name "Graph.exe" -Type DWORD -Value $One
			Set-ItemPropertyVerified -Path $Registry.SecurityPath -Name "MSAccess.exe" -Type DWORD -Value $One
			Set-ItemPropertyVerified -Path $Registry.SecurityPath -Name "MSPub.exe" -Type DWORD -Value $One
			Set-ItemPropertyVerified -Path $Registry.SecurityPath -Name "Powerpnt.exe" -Type DWORD -Value $One
			Set-ItemPropertyVerified -Path $Registry.SecurityPath -Name "Visio.exe" -Type DWORD -Value $One
			Set-ItemPropertyVerified -Path $Registry.SecurityPath -Name "WinProj.exe" -Type DWORD -Value $One
			Set-ItemPropertyVerified -Path $Registry.SecurityPath -Name "WinWord.exe" -Type DWORD -Value $One
			Set-ItemPropertyVerified -Path $Registry.SecurityPath -Name "Wordpad.exe" -Type DWORD -Value $One
			
			Write-Section "Windows Firewall"
			Write-Status "$($EnableStatus[1].Status) default firewall profiles..." $EnableStatus[1].Symbol
			Set-NetFirewallProfile -Name Domain, Public, Private -Enabled True
			
			Write-Section "Windows Defender"
			If ($Undo) {
				Write-Status "$($EnableStatus[0].Status) detection for potentially unwanted applications and block them..." $EnableStatus[0].Symbol -NoNewLine
				Set-MpPreference -PUAProtection Enabled -Force -ErrorAction SilentlyContinue
				Get-Status
				Write-Status "$($EnableStatus[0].Status) Microsoft Defender Exploit Guard network protection..." $EnableStatus[0].Symbol -NoNewLine
				Set-MpPreference -EnableNetworkProtection Disabled -Force -ErrorAction SilentlyContinue
				Get-Status
			} else {
				Write-Status "$($EnableStatus[1].Status) detection for potentially unwanted applications and block them..." $EnableStatus[1].Symbol -NoNewLine
				Set-MpPreference -PUAProtection Enabled -Force -ErrorAction SilentlyContinue
				Get-Status
				Write-Status "$($EnableStatus[1].Status) Microsoft Defender Exploit Guard network protection..." $EnableStatus[1].Symbol -NoNewLine
				Set-MpPreference -EnableNetworkProtection Enabled -Force -ErrorAction SilentlyContinue
				Get-Status
			}
			
			Write-Section "SmartScreen"
			Write-Status "$($EnableStatus[1].Status) 'SmartScreen' for Microsoft Edge..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path "$($Registry.PathToLMPoliciesEdge)\PhishingFilter" -Name "EnabledV9" -Type DWord -Value $One
			
			Write-Status "$($EnableStatus[1].Status) 'SmartScreen' for Store Apps..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToCUAppHost -Name "EnableWebContentEvaluation" -Type DWord -Value $One
			
			Write-Section "Old SMB Protocol"
			try {
				Write-Status "$($EnableStatus[0].Status) SMB 1.0 protocol..." $EnableStatus[0].Symbol -NoNewLine
				Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force
				Get-Status
			} catch {
				Get-Status
				Get-Error $Error[0]
				Continue
			}
			
			Write-Section "Old .NET cryptography"
			Write-Status "$($EnableStatus[1].Status) .NET strong cryptography..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToLMOldDotNet -Name "SchUseStrongCrypto" -Type DWord -Value $One
			Set-ItemPropertyVerified -Path $Registry.PathToLMWowNodeOldDotNet -Name "SchUseStrongCrypto" -Type DWord -Value $One
			
			Write-Section "Autoplay and Autorun (Removable Devices)"
			Write-Status "$($EnableStatus[0].Status) Autoplay..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path "$($Registry.PathToCUExplorer)\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value $One
			
			Write-Status "$($EnableStatus[0].Status) Autorun for all Drives..." $EnableStatus[0].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesExplorer -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
			
			Write-Section "Windows Explorer"
			Write-Status "$($EnableStatus[1].Status) Show file extensions in Explorer..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path "$($Registry.PathToCUExplorerAdvanced)" -Name "HideFileExt" -Type DWord -Value $Zero
			
			Write-Section "User Account Control (UAC)"
			If (!$Undo) {
				Write-Status "Raising UAC level..." "+"
				Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesSystem -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
				Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesSystem -Name "PromptOnSecureDesktop" -Type DWord -Value 1
			}
			
			Write-Section "Windows Update"
			Write-Status "$($EnableStatus[1].Status) offer Malicious Software Removal Tool via Windows Update..." $EnableStatus[1].Symbol
			Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesMRT -Name "DontOfferThroughWUAU" -Type DWord -Value $Zero
		}
	}
}
Function Optimize-Service {
<#
.SYNOPSIS
This script optimizes Windows services by disabling unnecessary services and enabling essential services.

.NOTES
Author: Circlol
Version: 1.0
History:
1.0:
- Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Undo,
		[Switch]$Skip = $SkipOptimization
	)
	Set-ScriptStatus -TweakTypeText "Services" -TitleText "Optimization: Services" -LogSection "Optimize: Service Tweaks"
	
	If ($Skip) {
		Write-Status "Parameter -Skip was detected.. Skipping Sevices ." "@" -WriteWarning -ForegroundColor Red
		
	} else {
		if ($PSCmdlet.ShouldProcess("Optimize-Services", "Optimize on Services")) {
			
			## Obsolete code
			If ($Undo) {
				Write-Status "Reverting the tweaks is set to '$Undo'." "Services", "*"
				Set-ServiceStartup -State 'Manual' -Services $Services.ToDisable -Filter $Variables.EnableServicesOnSSD
			} Else {
				Set-ServiceStartup -State 'Disabled' -Services $Services.ToDisable -Filter $Variables.EnableServicesOnSSD
			}
			##
			
			Write-Section "Enabling services from Windows"
			If ($Variables.IsSystemDriveSSD -or $Undo) {
				Set-ServiceStartup -State 'Automatic' -Services $Variables.EnableServicesOnSSD
			}
			Set-ServiceStartup -State 'Manual' -Services $Services.ToManual
		}
	}
}
Function Optimize-SSD {
<#
.SYNOPSIS
Optimizes SSD performance by disabling/enabling last access timestamps updates on files.

.NOTES
Author: Circlol
Version: 1.0
History:
1.0:
- Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter()]
		[Switch]$Undo,
		[Switch]$Skip = $SkipOptimization
	)
	
	
	If ($Skip) {
		Write-Status "Parameter -Skip was detected.. Skipping Sevices ." "@" -WriteWarning -ForegroundColor Red
		
	} else {
		if ($PSCmdlet.ShouldProcess("Optimize-SSD", "Optimize SSD's")) {
			# SSD life improvement
			Write-Section "SSD Optimization"
			If ($Undo) {
				Write-Status "Enabling last access timestamps updates on files" '+'
				fsutil behavior set DisableLastAccess 0
			} else {
				Write-Status "Disabling last access timestamps updates on files" '+'
				fsutil behavior set DisableLastAccess 1
			}
			Get-Status
		}
	}
}
Function Optimize-TaskScheduler {
<#
.SYNOPSIS
This function optimizes the Task Scheduler by disabling or enabling scheduled tasks in Windows.

.NOTES
Author: Circlol
Version: 1.0
History:
1.0:
- Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Undo,
		[Switch]$Skip = $SkipOptimization
	)
	Set-ScriptStatus -TweakTypeText "TaskScheduler" -TitleText "Optimization: Task Scheduler" -LogSection "Optimize: Task Scheduler"
	If ($Skip) {
		Write-Status "Parameter -Skip was detected.. Skipping Sevices ." "@" -WriteWarning -ForegroundColor Red
		
	} else {
		if ($PSCmdlet.ShouldProcess("Optimize-TaskScheduler", "Optimize on Task Scheduler")) {
			If ($Undo) {
				Write-Status "Reverting the tweaks is set to '$Undo'." "*"
				$CustomMessage = {
					"Resetting the $ScheduledTask task as 'Ready' ..."
				}
				Set-ScheduledTaskState -Ready -ScheduledTasks $ScheduledTasks.ToDisable -CustomMessage $CustomMessage
			} Else {
				Set-ScheduledTaskState -Disabled -ScheduledTasks $ScheduledTasks.ToDisable
			}
			
			Write-Section -Text "Enabling Scheduled Tasks from Windows"
			Set-ScheduledTaskState -Ready -ScheduledTasks $ScheduledTasks.ToEnable
		}
	}
}
Function Optimize-WindowsOptional {
<#
.SYNOPSIS
This function optimizes Windows by disabling unnecessary optional features and removing unnecessary printers.

.NOTES
Author: Circlol
Version: 1.0
History:
1.0:
- Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Undo,
		[Switch]$Skip = $SkipOptimization
	)
	Set-ScriptStatus -TweakTypeText "OptionalFeatures" -TitleText "Optimization: Optional Features" -LogSection "Optimize: Optional Features"
	If ($Skip) {
		Write-Status "Parameter -Skip was detected.. Skipping Sevices ." "@" -WriteWarning -ForegroundColor Red
		
	} else {
		if ($PSCmdlet.ShouldProcess("Optimize-WindowsOptional", "Optimization on Optional Features")) {
			If ($Undo) {
				Write-Status "Reverting the tweaks is set to '$Undo'."
				$CustomMessage = {
					"Re-Installing the $OptionalFeature optional feature..."
				}
				Set-OptionalFeatureState -Enabled -OptionalFeatures $OptionalFeatures.ToDisable -CustomMessage $CustomMessage
			} Else {
				$CustomMessage = {
					"Disabling the $OptionalFeature optional feature..."
				}
				Set-OptionalFeatureState -Disabled -OptionalFeatures $OptionalFeatures.ToDisable -CustomMessage $CustomMessage
			}
			
			
			Write-Section -Text "Install Optional Features from Windows"
			$CustomMessage = {
				"Installing the $OptionalFeature optional feature ..."
			}
			Set-OptionalFeatureState -Enabled -OptionalFeatures $OptionalFeatures.ToEnable -CustomMessage $CustomMessage
			
			
			Write-Section -Text "Removing Unnecessary Printers"
			$printers = "Microsoft XPS Document Writer", "Fax", "OneNote"
			foreach ($printer in $printers) {
				$PrinterExists = Get-Printer -Name $Printer -ErrorAction SilentlyContinue
				If ($PrinterExists) {
					try {
						Write-Status "Attempting removal of $printer..." "-" -NoNewLine
						Remove-Printer -Name $printer
						Get-Status
					} catch {
						Get-Status
						Get-Error $Error[0]
						Write-Status "Failed to remove $printer :`n$($_)" "?" -WriteWarning
					}
				}
			}
		}
	}
}

#endregion
#region Helpers
function Find-ScheduledTask {
<#
.SYNOPSIS
This script contains a function named Find-ScheduledTask that checks if a scheduled task exists.

.NOTES
Author: Circlol
Version: 1.0
Release Notes:
1.0:
    - Started logging changes.

#>
	[CmdletBinding()]
	[OutputType([Bool])]
	param (
		[String]$ScheduledTask
	)
	
	If (!$ScheduledTask) {
		$scheduledTask = Get-ScheduledTask
		return $ScheduledTask
	} else {
		Try {
			$task = Get-ScheduledTaskInfo -TaskName $ScheduledTask -ErrorAction SilentlyContinue
			$task = $task
			return $true
		} Catch {
			$Status = "The $ScheduledTask task was not found."
		<#
			For more information on the try, catch and finally keywords, see:
				Get-Help about_try_catch_finally
		#>
			
			# Try one or more commands
			try {
				Write-Status $Status '?' -WriteWarning
			} catch {
				Write-Output "? $TweakType  $Status"
			}
			
			Add-Content -Path $Variables.Log -Value $Status
			return $false
		}
	}
	
}
function Get-ActivationStatus {
<#
.SYNOPSIS
Checks activation status, if not activate, asks user if they want to activate using MAS (Microsoft Activation Scripts)

.NOTES
Author: Circlol
Version: 1.0
Activation Script: https://github.com/massgravel/Microsoft-Activation-Scripts
Modified from https://www.reddit.com/r/PowerShell/comments/1b6b4wr/comment/ktar0t9/
Release Notes:
1.0:
- Started logging changes.

#>
	$text = "Activation"
	Set-ScriptStatus -SectionText $text -TweakTypeText $text -WindowTitle $text

	Write-Status "Searching for Windows License Status" "@"
	$Activated = if(( Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object { $_.PartialProductKey } | Select-Object -ExpandProperty LicenseStatus) -eq 1) { 
		Write-Output $True
	} else {
		Write-Output $False
	}

	If ($Activated -ne $True) {

		$message = "Warning: Windows is not Activated. Would you like to run MAS now?"
		Write-Status $message "?"

		do {
			$q = Show-Question -Message $message -Title 'Windows Activation' -Buttons YesNo -Icon Information
		} until ($q -eq "Yes" -or $q -eq "No")

		switch ($q) {
			"Yes" {
				# Script from massgrave.dev/get

				[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
				$URLs = @(
					'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/f1ddb83df092478741344fc55351a65cf6eeafd8/MAS/All-In-One-Version-KL/MAS_AIO.cmd',
					'https://dev.azure.com/massgrave/Microsoft-Activation-Scripts/_apis/git/repositories/Microsoft-Activation-Scripts/items?path=/MAS/All-In-One-Version-KL/MAS_AIO.cmd&versionType=Commit&version=f1ddb83df092478741344fc55351a65cf6eeafd8',
					'https://git.activated.win/massgrave/Microsoft-Activation-Scripts/raw/commit/f1ddb83df092478741344fc55351a65cf6eeafd8/MAS/All-In-One-Version-KL/MAS_AIO.cmd'
				)
				
				foreach ($URL in $URLs | Sort-Object { Get-Random }) {
					try { $response = Invoke-WebRequest -Uri $URL -UseBasicParsing; break } catch {}
				}
				
				if (-not $response) {
					Check3rdAV
					Write-Host "Failed to retrieve MAS from any of the available repositories, aborting!"
					return
				}
				
				# Verify script integrity
				$releaseHash = '2A0A5F9675BA93D11DF5EB531810F8097D1C13CE3A723FC2235A85127E86E172'
				$stream = New-Object IO.MemoryStream
				$writer = New-Object IO.StreamWriter $stream
				$writer.Write($response)
				$writer.Flush()
				$stream.Position = 0
				$hash = [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($stream)) -replace '-'
				if ($hash -ne $releaseHash) {
					return
				}
				
				$rand = [Guid]::NewGuid().Guid
				$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
				$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\MAS_$rand.cmd" } else { "$env:USERPROFILE\AppData\Local\Temp\MAS_$rand.cmd" }
				Set-Content -Path $FilePath -Value "@::: $rand `r`n$response"
				
				$env:ComSpec = "$env:SystemRoot\system32\cmd.exe"
				Start-Process -FilePath $env:ComSpec -ArgumentList "/c """"$FilePath"" $args""" -Wait
				
				if (-not (Test-Path -Path $FilePath)) {
					Check3rdAV
					Write-Host "Failed to create MAS file in temp folder, aborting!"
					return
				}
				
				$FilePaths = @("$env:SystemRoot\Temp\MAS*.cmd", "$env:USERPROFILE\AppData\Local\Temp\MAS*.cmd")
				foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }

				# end script from massgrave.dev/get
			}
			"No" { Write-Status "Skipping Windows Activation" "/" }
			default { Write-Output "Comeonnow" }
		}
	}
}
function Get-Administrator {
	
	# Imported from Winutil @ChrisTitusTech - Unused
	#if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	# New Loads checks and assures it is running as admin
	If (!([bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544'))) {
		Write-Host $Errors.errorMessage2 -ForegroundColor Yellow
		$wtExists = Get-Command wt
		If ($wtExists) {
			Start-Process wt -verb runas -ArgumentList "powershell -command ""irm $($Variables.NewLoadsURL) | iex"""
			Stop-Process $pid
		} else {
			Start-Process powershell -verb runas -ArgumentList "-command ""irm $($Variables.NewLoadsURL) | iex"""
			Stop-Process $pid
		}

		Write-Output "Exiting"
		exit
	}
}
function Get-LastCheckForUpdate {
<#
.SYNOPSIS
Checks last time updates were ran.

.EXAMPLE
PS C:\> Get-LastCheckForUpdate

November 5, 2023 2:53:49 PM
.NOTES
Author: Circlol
Date Created: Nov 5, 2023
Version: 1.0
Changes:
    1.0:
        - Started logging changes.
#>
	$wu = New-Object -ComObject Microsoft.Update.AutoUpdate
	$lastUpdateCheck = $wu.Results.LastSearchSuccessDate
	$lastUpdateCheck = $lastUpdateCheck.ToLocalTime()
	return $lastUpdateCheck
}
function Remove-ItemPropertyVerified {
<#
.SYNOPSIS
Removes a property from an item at the specified path.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(Mandatory = $true)]
		[String]$Path,
		[Parameter(Mandatory = $true)]
		[String]$Name,
		[Parameter(Mandatory = $false)]
		[Switch]$Force
	)
	
	$confirmationMessage = "This action will remove the property '$Name' from '$Path'. Do you want to proceed?"
	$actionDescription = "Remove Item Property"
	if ($PSCmdlet.ShouldProcess($actionDescription, $confirmationMessage)) {
		$PathExists = Test-Path $Path
		If ($PathExists -eq $false) {
			Write-Status "Path [$Path] does not exist." "?" -WriteWarning
			return
		} else {
			try {
				Write-Status "Removing Item Property: [$Name] from [$Path]..." "-" -NoNewLine
				if ($force) {
					Remove-ItemProperty -Path $Path -Name $Name -Force -ErrorAction SilentlyContinue
				} else {
					Remove-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
				}
				Get-Status
			} catch {
				Get-Status
				Get-Error $Error[0]
			}
		}
	}
}
function Restart-Explorer {
<#
.SYNOPSIS
This script defines a function to restart Windows Explorer.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param ()
	# Checks is explorer is running
	$confirmationMessage = "This action will restart Windows Explorer. Do you wish to continue?"
	$actionDescription = "Restarts Windows Explorer."
	if ($PSCmdlet.ShouldProcess($actionDescription, $confirmationMessage)) {
		$ExplorerActive = Get-Process -Name explorer
		if ($ExplorerActive) {
			try {
				taskkill /f /im explorer.exe | Write-ModifiedStatus -Types "X", "Stopping" -Status "Explorer"
			} catch {
				Write-Warning "Failed to stop Explorer process: $_"
				Get-Error $Error[0]
				Continue
			}
		}
		try {
			Start-Process explorer -Wait | Write-ModifiedStatus -Types "√", "Starting" -Status "Explorer"
		} catch {
			Write-Error "Failed to start Explorer process: $_"
			Get-Error $Error[0]
			Continue
		}
	}
}
function Request-PCRestart {
<#
.SYNOPSIS
This function prompts the user to restart their computer in order to apply changes.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	Param (
		$Skip = $NoRestart
	)
	If ($Skip) {
		Write-Status "Parameter -NoRestart detected. Skipping Restart ." "@" -WriteWarning -ForegroundColor Red
		
	} else {
		Write-Status "User action needed - You may have to ALT + TAB " 'WAITING' -WriteWarning
		$restartMessage = "For changes to apply please restart your computer. Ready?"
		switch (Show-Question -Chime -Buttons YesNoCancel -Title "New Loads Completed" -Icon Warning -Message $restartMessage) {
			'Yes' {
				Write-Host "You choose to Restart now"
				Restart-Computer
			}
			'No' {
				Write-Host "You choose to Restart later"
			}
			'Cancel' {
				Write-Host "You choose to Restart later"
			}
		}
	}
}
function Remove-UWPAppx {
<#
.SYNOPSIS
Removes specified UWP appx packages from the system.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Array]$AppxPackages,
		[String]$TweakType = "UWP"
	)
	ForEach ($AppxPackage in $AppxPackages) {
		$appxPackageToRemove = Get-AppxPackage -AllUsers -Name $AppxPackage
		if ($appxPackageToRemove) {
			$actionDescription = "Removing $AppxPackage"
			if ($PSCmdlet.ShouldProcess($actionDescription, "Do you want to remove the app $AppxPackage?")) {
				$appxPackageToRemove | ForEach-Object -Process {
					Write-Status "Trying to remove $AppxPackage" "-" -NoNewLine
					Remove-AppxPackage $_.PackageFullName -ErrorAction SilentlyContinue | Out-Null
					Get-Status
					If ($?) {
						$Variables.Removed++
						$Variables.PackagesRemoved += "$appxPackageToRemove.PackageFullName`n"
					} elseif (!($?)) {
						$Variabless.Failed++
					}
					Write-Status "Trying to remove provisioned $AppxPackage" "-" -NoNewLine
					Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object DisplayName -like $AppxPackage | Remove-AppxProvisionedPackage -Online -AllUsers -ErrorAction SilentlyContinue | Out-Null
					Get-Status
					If ($?) {
						$Variables.Removed++
						$Variables.PackagesRemoved += "Provisioned Appx $($appxPackageToRemove.PackageFullName)`n"
					} elseif (!($?)) {
						$Variables.FailedPackages++
					}
				}
			}
		} else {
			$Variables.PackagesNotFound++
		}
	}
}
function Set-ItemPropertyVerified {
<#
.SYNOPSIS
This function sets a registry value if it doesn't exist or if it's different from the desired value.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
	Param (
		[Alias("V")]
		[Parameter(Mandatory = $true)]
		$Value,
		[Alias("N")]
		[Parameter(Mandatory = $true)]
		$Name,
		[Alias("T")]
		[Parameter(Mandatory = $true)]
		[ValidateSet("String", "ExpandString", "Binary", "DWord", "MultiString", "QWord", "Unknown")]
		$Type,
		[Alias("P")]
		[Parameter(Mandatory = $true)]
		$Path,
		[Alias("F")]
		[Parameter(Mandatory = $False)]
		[Switch]$Force,
		[Parameter(Mandatory = $False)]
		[Switch]$Passthru
	)
	
	$keyExists = Test-Path -Path $Path
	if (!$keyExists) {
		if ($PSCmdlet.ShouldProcess("Creating registry key at $Path")) {
			New-Item -Path $Path -Force | Out-Null
			$Variables.CreatedKeys++
		}
	}
	
	$currentValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
	if (!$currentValue -or $currentValue.$Name -ne $Value) {
		if ($PSCmdlet.ShouldProcess("Setting $Name to $Value in $Path")) {
			
			try {
				Write-Status "$Name set to $Value" '+' -NoNewLine
				$params = @{
					Path		  = $Path
					Name		  = $Name
					Value		  = $Value
					Type		  = $Type
					ErrorAction   = 'Stop'
					Passthru	  = $Passthru
					WarningAction = $warningPreference
					WhatIf		  = $WhatIfPreference
				}
				
				if ($Force) { $params['Force'] = $true }
				Set-ItemProperty @params
				Get-Status
				$Variables.ModifiedRegistryKeys++
			} catch {
				Get-Status
				Get-Error $Error[0]
				$Variables.FailedRegistryKeys++
			}
		}
	} else {
		Write-Status "Key already set to the desired value. Skipping" '@'
	}
}
function Set-OptionalFeatureState {
<#
.SYNOPSIS
Sets the state of Windows optional features.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	param (
		[ScriptBlock]$CustomMessage,
		[Switch]$Enabled,
		[Switch]$Disabled,
		[Array]$OptionalFeatures,
		[String]$TweakType = "OptionalFeature"
	)
	$SecurityFilterOnEnable = @("IIS-*")
	$OptionalFeatures | ForEach-Object {
		$feature = Get-WindowsOptionalFeature -Online -FeatureName $_
		if ($feature) {
			if ($_.DisplayName -in $Filter) {
				Write-Status "The $_ ($($feature.DisplayName)) will be skipped as set on Filter..." "@" -WriteWarning
				return
			}
			
			if (($_.DisplayName -in $SecurityFilterOnEnable) -and $Enabled) {
				Write-Status "Skipping $_ ($($feature.DisplayName)) to avoid a security vulnerability..." "@" -WriteWarning
				return
			}
			
			if (!$CustomMessage) {
				if ($Disabled) {
					Write-Status $actionDescription "-" -NoNewLine
					try {
						$feature | Where-Object State -Like "Enabled" | Disable-WindowsOptionalFeature -Online -NoRestart
						Get-Status
					} catch {
						Get-Error $Error[0]
						Continue
					}
				} elseif ($Enabled) {
					Write-Status $actionDescription "+" -NoNewLine
					try {
						$feature | Where-Object State -Like "Disabled*" | Enable-WindowsOptionalFeature -Online -NoRestart
						Get-Status
					} catch {
						Get-Error $Error[0]
						Continue
					}
				} else {
					Write-Status "No parameter received (valid params: -Disabled or -Enabled)" "?"
				}
			} else {
				$customMessageText = $CustomMessage.Invoke($_)
				Write-Status $customMessageText "@"
			}
		} else {
			$Status = "The $_ optional feature was not found."
			Write-Status $Status "?" -WriteWarning
			Add-Content -Path $Variables.Log -Value $Status
		}
	}
}
function Set-ScheduledTaskState {
<#
.SYNOPSIS
Sets the state of one or more scheduled tasks.

.NOTES
Author: Circlol
#>
	[CmdletBinding(SupportsShouldProcess)]
	param (
		[Parameter(Mandatory = $false)]
		[Switch]$Disabled,
		[Parameter(Mandatory = $false)]
		[Switch]$Ready,
		[Parameter(Mandatory = $true)]
		[Array]$ScheduledTasks,
		[Parameter(Mandatory = $false)]
		[Array]$Filter,
		[String]$TweakType = "ScheduledTask"
	)
	
	ForEach ($ScheduledTask in $ScheduledTasks) {
		If (Find-ScheduledTask $ScheduledTask) {
			If ($ScheduledTask -in $Filter) {
				Write-Status "The $ScheduledTask ($((Get-ScheduledTask $ScheduledTask).TaskName)) will be skipped as set on Filter..." "?" -WriteWarning
				Continue
			}
			
			If ($Disabled) {
				$action = "Disable"
			} ElseIf ($Ready) {
				$action = "Enable"
			} Else {
				Write-Status "No parameter received (valid params: -Disabled or -Ready)" "?" -WriteWarning
				$action = $null
			}
			
			If ($action) {
				if ($PSCmdlet.ShouldProcess("$ScheduledTask task", "Set state to $action")) {
					Write-Status "$action the $ScheduledTask task..." $action.Substring(0, 1) -NoNewLine
					Try {
						If ($action -eq "Disable") {
							Get-ScheduledTask -TaskName (Split-Path -Path $ScheduledTask -Leaf) -ErrorAction SilentlyContinue | Where-Object State -Like "R*" | Disable-ScheduledTask | Out-Null # R* = Ready/Running
							Get-Status
						} ElseIf ($action -eq "Enable") {
							Get-ScheduledTask -TaskName (Split-Path -Path $ScheduledTask -Leaf) -ErrorAction SilentlyContinue | Where-Object State -Like "Disabled" | Enable-ScheduledTask | Out-Null
							Get-Status
						}
					} catch {
						[System.Environment]::NewLine
						Get-Status
						Get-Error $Error.Exception.Message
						Continue
					}
				}
			}
		}
	}
}
function Set-ScriptStatus {
<#
.SYNOPSIS
This script defines the Set-ScriptStatus function, which is used to display the status of the script.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	param (
		[Switch]$AddCounter,
		[String]$LogSection,
		[String]$SectionText,
		[String]$TitleText,
		[String]$TitleCounterText,
		[String]$TweakTypeText,
		[String]$WindowTitle
	)
	If ($LogSection){
		$Title = "

Section: $LogSection

"
		Add-Content -Path $Variables.Log -Value $Title
		
	}
	If ($WindowTitle) {
		$host.UI.RawUI.WindowTitle = "New Loads - $WindowTitle"
	}
	If ($TweakTypeText) {
		Set-Variable -Name 'TweakType' -Value $TweakTypeText -Scope Global -Force
	}
	If ($TitleCounterText) {
		Write-TitleCounter -Counter $Variables.Counter -MaxLength $Variables.MaxLength -Text $TitleCounterText
	}
	If ($TitleText) {
		Write-Title -Text $TitleText
	}
	If ($SectionText) {
		Write-Section -Text "Section: $SectionText"
	}
	If ($AddCounter) {
		$Variables.Counter++
	}
}
function Show-SkipQuestion {
	param (
		[string]$Prompt
	)
	while ($true) {
		$response = Read-Host "$Prompt (Y)es/(N)o"
		switch ($response.ToLower()) {
			'y' {
				Start-Process ms-settings:windowsupdate-options
				exit
			}
			'n' {
				exit
			}
			's' {
				return "Skipping"
				break
			}
			default {
				Write-Host "Invalid input. Please try again."
			}
		}
	}
}
function Show-Question {
<#
.SYNOPSIS
This script defines the Show-Question function which displays a message box with a specified message, title, buttons, and icon.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	param (
		[string]$Message,
		[string]$Title = "New Loads",
		[System.Windows.Forms.MessageBoxButtons]$Buttons = [System.Windows.Forms.MessageBoxButtons]::OK,
		[System.Windows.Forms.MessageBoxIcon]$Icon = [System.Windows.Forms.MessageBoxIcon]::Information,
		[switch]$Chime = $false
	)
	If ($Chime) { Start-Chime }
	$Box = [System.Windows.Forms.MessageBox]::Show($Message, $Title, $Buttons, $Icon)
	return $box
}


#endregion
#region Script Functions

function Get-ADWCleaner {
<#
.SYNOPSIS
This function downloads and runs Malwarebytes ADWCleaner to scan and clean adware from the system.

.NOTES
Author: Circlol
Version: 1.0
Release Notes:
    1.0:
        - Started logging changes.
        - Added support for the -Undo and -Skip parameters.
        - Added support for shouldprocess.
#>
	[CmdletBinding(SupportsShouldProcess)]
	param (
		[Switch]$Undo,
		[Switch]$Run = $ADWCleaner
	)
	Set-ScriptStatus -TitleText "ADWCleaner" -TweakTypeText "Debloat" -LogSection "ADWCleaner"
	If ($Undo) {
		Write-Status "Parameter -SkipADW detected.. Malwarebytes ADWCleaner will be skipped.." '@' -WriteWarning
	} elseif ($Run) {
		if ($PSCmdlet.ShouldProcess("Download and Run ADWCleaner", "Downloading ADWCleaner $description")) {
			If (!(Test-Path "$($Variables.adwDestination)")) {
				Write-Status "Downloading ADWCleaner" "+" -NoNewLine
				Start-BitsTransfer -Source $Software.ADWCleaner -Destination "$($Variables.adwDestination)" -Dynamic
				Get-Status
			}
			Write-Status "Starting ADWCleaner with ArgumentList /Scan & /Clean" "+"
			Start-Process -FilePath "$($Variables.adwDestination)" -ArgumentList "/EULA", "/PreInstalled", "/Clean", "/NoReboot" -Wait -NoNewWindow | Out-Host
			Write-Status "Removing traces of ADWCleaner" "-"
			Start-Process -FilePath "$($Variables.adwDestination)" -ArgumentList "/Uninstall", "/NoReboot" -WindowStyle Minimized
		}
	}
}
function Get-Program {
<#
.SYNOPSIS
This function installs various programs on the system.
	
.NOTES
Author: Circlol
Version: 1.0
History:
    1.2:
        - Replaced the VLC link from v3.0.18 to v3.0.20
    1.1:
        - Added support for undoing the program installation process.
        - Added support for skipping the program installation process.
        - Added support for logging the program installation process.
        - Added Outlook for Windows.
    1.0:
        - Started recording history of changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[switch]$Skip = $SkipPrograms
	)
	
	Set-ScriptStatus -WindowTitle "Apps" -TweakTypeText "Apps" -TitleCounterText "Programs" -TitleText "Application Installation" -AddCounter -LogSection "Program Installation"
	# - Program Information
	If ($Skip -eq $True) {
		Write-Status "Parameter -SkipPrograms detected.. Skipping Program Installation." '@' -WriteWarning -ForegroundColor RED
	} else {
		if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
			foreach ($program in $Software.chrome, $Software.vlc, $Software.zoom, $Software.acrobat) {
				# , $OutlookForWindows
				Write-Section -Text $program.Name
				# Checks if the program is installed
				if (-not $program.Installed) {
					# if not then checks if the installed exists
					if (-not $program.FileExists) {
						Get-NetworkStatus
						try {
							# if not then downloads installer
							Write-Status "Downloading $($program.Name)" '+' -NoNewLine
							Start-BitsTransfer -Source $program.DownloadURL -Destination $program.InstallerLocation -TransferType Download -Dynamic -DisplayName "$TweakType" -Description "Downloading $($program.Name)" | Out-Null
							Get-Status
						} catch {
							Get-Status
							Get-Error $Error.Exception.Message
						}
					}
					
					Write-Status "Installing $($program.Name)" '+' -NoNewLine
					
					# Checks if the program is HEVC/H.265 Codec or Outlook for Windows
					If ($program.Name -eq $Software.hevc.Name -or $program.Name -eq $Software.OutlookForWindows.Name) {
						If ($program.Name -eq $Software.hevc.Name) {
							try {
								Add-AppxPackage -Path $HEVC.InstallerLocation | Out-Null
								Get-Status
							} catch {
								Get-Status
								Get-Error $Error[0]
							}
						} elseif ($program.Name -eq $Software.OutlookForWindows.Name) {
							try {
								Add-AppxPackage -Path $Software.OutlookForWindows.InstallerLocation| Out-Null
								Get-Status
							} catch {
								Get-Status
								Get-Error $Error[0]
								Continue
							}
						}
					} else {
						try {
							Start-Process -FilePath $program.InstallerLocation -ArgumentList $program.ArgumentList -Wait
							Get-Status
						} catch {
							Get-Status
							Get-Error $Error[0]
							Continue
						}
					}
					
					<# Adds UBlock Origin to Chrome  - - - Disabled due to Manifest V3
					if ($program.Name -eq $Software.Chrome.name) {
						Write-Status "Adding UBlock Origin to Chrome" '+'
						Set-ItemPropertyVerified -Path $Registry.PathToUblockChrome -Name "update_url" -value $Software.Chrome.ChromeLink -Type STRING -WhatIf:$WhatIfPreference
						# TODO Create this - Set-ItemPropertyVerified -Path $Registry.PathToUblockEdge -Name "update_url" -value $Chrome.ChromeLink -Type STRING
					}#>
				} else {
					# Checks if installed if it is then skips the installation
					Write-Status "$($program.Name) already seems to be installed on this system.. Skipping Installation" "@"
					if ($program.Name -eq $Software.Chrome.name) { Write-Status "Adding UBlock Origin to Chrome" "+"
						Set-ItemPropertyVerified -Path $Registry.PathToUblockChrome -Name "update_url" -value $Software.Chrome.ChromeLink -Type STRING -WhatIf:$WhatIfPreference
					}
				}
			}
		}
	}
}
function Get-ExactTimeZone {
	Add-Type -AssemblyName "System.Windows.Forms"

	# Function to filter time zones by names containing "Pacific"
	function ScanForPacific {
		param (
			[Parameter(Mandatory=$true)]
			[System.Collections.Generic.List[System.TimeZoneInfo]]$timeZones
		)
		
		return $timeZones | Where-Object { $_.DisplayName -like "*Pacific*" }
	}

	# Function to filter time zones by names containing "Canada"
	function ScanForCanada {
		param (
			[Parameter(Mandatory=$true)]
			[System.Collections.Generic.List[System.TimeZoneInfo]]$timeZones
		)
		
		return $timeZones | Where-Object { $_.DisplayName -like "*Canada*" }
	}

	# Function to handle selection based on the number of results
	function Start-HandlingSelection {
		# Get all time zones
		$allTimeZones = [System.TimeZoneInfo]::GetSystemTimeZones()
		
		# Filter for "Pacific" and "Canada" time zones
		$pacificTimeZones = ScanForPacific -timeZones $allTimeZones
		$canadaTimeZones = ScanForCanada -timeZones $allTimeZones

		# If only one match in either category, show the time zone directly
		if ($pacificTimeZones.Count -eq 1) {
			$selectedTimeZone = $pacificTimeZones[0]
			return $($selectedTimeZone.DisplayName)
		}
		elseif ($canadaTimeZones.Count -eq 1) {
			$selectedTimeZone = $canadaTimeZones[0]
			return $($selectedTimeZone.DisplayName)
		}
		# If there are multiple matches in both categories, show the time zone selector window
		elseif ($pacificTimeZones.Count -gt 1 -and $canadaTimeZones.Count -gt 1) {
			Show-TimeZoneSelector -pacificTimeZones $pacificTimeZones -canadaTimeZones $canadaTimeZones
		}
		else {
			[System.Windows.Forms.MessageBox]::Show("Time zone matching 'Pacific' & 'Canada' not found.")
			return "Not Found"
		}
	}

	# Function to show the time zone selector form
	function Show-TimeZoneSelector {
		param (
			[Parameter(Mandatory=$true)]
			[System.Collections.Generic.List[System.TimeZoneInfo]]$pacificTimeZones,
			
			[Parameter(Mandatory=$true)]
			[System.Collections.Generic.List[System.TimeZoneInfo]]$canadaTimeZones
		)

		# Create the form
		$form = New-Object System.Windows.Forms.Form
		$form.Text = "Time Zone Selector"
		$form.Size = New-Object System.Drawing.Size(300, 400)
		$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
		$form.AutoScroll = $true  # Enable scrolling when content exceeds form size

		# Set up a panel for buttons, which allows for dynamic addition
		$panel = New-Object System.Windows.Forms.Panel
		$panel.Dock = [System.Windows.Forms.DockStyle]::Fill
		$panel.AutoScroll = $true  # Enable scrolling on the panel
		$form.Controls.Add($panel)

		# Define the starting position for buttons
		$topPosition = 10
		$buttonHeight = 30
		$buttonWidth = $panel.ClientSize.Width - 20

		# Combine Pacific and Canada time zones
		$combinedTimeZones = $pacificTimeZones + $canadaTimeZones

		# Loop through the combined filtered time zones and create buttons for each
		foreach ($timeZone in $combinedTimeZones) {
			$button = New-Object System.Windows.Forms.Button
			$button.Text = $timeZone.DisplayName
			$button.Size = New-Object System.Drawing.Size($buttonWidth, $buttonHeight)
			$button.Location = New-Object System.Drawing.Point(10, $topPosition)
			
			# Add click event to show the selected time zone's Id
			$button.Add_Click({
				$selectedTimeZone = $timeZone
				# Show the selected time zone's ID (which gives the correct representation)
				[System.Windows.Forms.MessageBox]::Show("You selected: $($selectedTimeZone.Id)")
			})
			
			$panel.Controls.Add($button)
			$topPosition += $buttonHeight + 5  # Adjust position for the next button
		}

		# Show the form
		$form.ShowDialog()
	}

	# Run the selection function
	$TimeZone = Start-HandlingSelection
	Return $TimeZone
}
function New-SystemRestorePoint {
<#
.SYNOPSIS
Creates a new system restore point with a given description.

.NOTES
Author: Circlol
Version: 1.0
Release Notes:
1.0:
    - Started logging changes.

#>
	[CmdletBinding(SupportsShouldProcess)]
	Param (
		$Skip = $SkipRestorePoint
	)
	Set-ScriptStatus -WindowTitle "Restore Point" -TweakTypeText "Backup" -TitleCounterText "Creating Restore Point" -LogSection "System Restore" -AddCounter 
	$description = "Mother Computers Initial Restore Point"
	$restorePointType = "MODIFY_SETTINGS"
	if ($PSCmdlet.ShouldProcess("Create System Restore Point", "Creating a new restore point with description: $description")) {
		If ($Skip) {
			Write-Status "Parameter -SkipRestorePoint was detected.. Skipping Restore Point" "@" -WriteWarning -ForegroundColor Red
			
		} else {
			
			try {
				Set-Variable -Name TweakType $null
				Write-Status "Enabling System Restore" '+' -NoNewLine -NoLogEntry
				Enable-ComputerRestore -Drive "$env:SystemDrive\"
				Get-Status -SkipLogEntry
				Write-Status "Creating System Restore Point: $description" '+' -NoLogEntry
				Checkpoint-Computer -Description $description -RestorePointType $restorePointType
				Get-Status -SkipLogEntry
			} catch {
				Get-Status -SkipLogEntry
				Get-Error $Error[0]
				Continue
			}
			Set-ScriptStatus -WindowTitle ""
		}
	}
}
function Remove-Office {
<#
.SYNOPSIS
Removes Microsoft Office from the system using Microsoft Support and Recovery Assistant (SaRA).

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param ()
	
	$confirmationMessage = "Office was found on this system. Do you want to remove it?"
	$actionDescription = "Remove Office"
	if ($PSCmdlet.ShouldProcess($actionDescription, $confirmationMessage)) {
		$msgBoxInput = Show-Question -Buttons YesNo -Message "Office was found on this system. Should I remove it?" -Icon Warning
		switch ($msgBoxInput) {
			'Yes' {
				$actionDescription = "Downloading Microsoft Support and Recovery Assistant (SaRA)..."
				try {
					Write-Status "Downloading Microsoft Support and Recovery Assistant (SaRA)..." "+" -NoNewLine
					Get-NetworkStatus
					Start-BitsTransfer -Source $Software.SaRAURL -Destination $Variables.SaRA -TransferType Download -Dynamic | Out-Host
					Get-Status
					Write-Status "Expanding SaRA" "+" -NoNewLine
					Expand-Archive -Path $Variables.SaRA -DestinationPath $Variables.Sexp -Force
					Get-Status
				} catch {
					Get-Status
					Get-Error $Error[0]
					Continue
				}
				
				$SaRAcmdexe = (Get-ChildItem $Variables.Sexp -Include SaRAcmd.exe -Recurse).FullName
				$actionDescription = "Starting OfficeScrubScenario via Microsoft Support and Recovery Assistant (SaRA)..."
				try {
					Write-Status $actionDescription "+" -NoNewLine
					Start-Process $SaRAcmdexe -ArgumentList "-S OfficeScrubScenario -AcceptEula -OfficeVersion All"
					Get-Status
				} catch {
					Get-Status
					Get-Error $Error[0]
					Continue
				}
			}
			'No' {
				Write-Status "Skipping Office Removal" '?' -WriteWarning
			}
		}
	}
}
function Remove-StartPin {
<#
.SYNOPSIS
Removes pinned items from the Start menu by applying a new start menu layout and then deleting it.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param ()
	$START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
<LayoutOptions StartTileGroupCellWidth="6" />
<DefaultLayoutOverride>
    <StartLayoutCollection>
        <defaultlayout:StartLayout GroupCellWidth="6" />
    </StartLayoutCollection>
</DefaultLayoutOverride>
</LayoutModificationTemplate>
"@
	
	$layoutFile = "C:\Windows\StartMenuLayout.xml"
	
	#Delete layout file if it already exists
	If (Test-Path $layoutFile) {
		Remove-Item $layoutFile
	}
	
	#Creates the blank layout file
	$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII
	
	$regAliases = @("HKLM", "HKCU")
	
	#Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
	foreach ($regAlias in $regAliases) {
		$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
		$keyPath = $basePath + "\Explorer"
		If (!(Test-Path -Path $keyPath)) {
			New-Item -Path $basePath -Name "Explorer"
		}
		Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
		Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
	}
	
	#Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
	Restart-Explorer
	Start-Sleep -Seconds 5
	$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
	Start-Sleep -Seconds 5
	
	#Enable the ability to pin items again by disabling "LockedStartLayout"
	foreach ($regAlias in $regAliases) {
		$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
		$keyPath = $basePath + "\Explorer"
		Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
	}
	
	#Restart Explorer and delete the layout file
	Restart-Explorer
	
	# Uncomment the next line to make clean start menu default for all new users
	#Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
	
	Remove-Item $layoutFile
}
function Send-EmailLog {
<#
.SYNOPSIS
Sends an email with the log files and system information.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	
	# Time related variables
	$EndTime = Get-Date
	$CurrentDateFormatted = $StartTime.ToString("dddd MMMM dd, yyyy - h:mm:ss tt")
	$FormattedStartTime = $StartTime.ToString("h:mm:ss tt")
	$FormattedEndTime = $EndTime.ToString("h:mm:ss tt")
	$ElapsedTime = $EndTime - $StartTime
	$FormattedElapsedTime = "{0:D2} minutes {1:D2} seconds" -f $ElapsedTime.Minutes, $ElapsedTime.Seconds

	# Gathers Powershell Version
	$PowershellTable = $PSVersionTable | Format-Table -AutoSize | Out-String
	
	# - Gathers some information about installed programs
	$ListOfInstalledApplications = (Get-InstalledProgram -Name "*").Name | Sort-Object
	$ListOfInstalledApplications = $ListOfInstalledApplications -join "`n"
	$ListOfInstalledPackages = (Get-appxpackage -User $Env:USERNAME).Name | Sort-Object
	$ListOfInstalledPackages = $ListOfInstalledPackages -join "`n"
	
	# - System Information
	$SystemSpecs = Get-SystemInfo
	$MoboSerial = (Get-CimInstance -ClassName Win32_BaseBoard).SerialNumber
	$CPUSerial  = (Get-CimInstance -ClassName Win32_Processor).SerialNumber
	$RAMSerial  = (Get-CimInstance -ClassName Win32_PhysicalMemory).SerialNumber
	$DiskSerial = (Get-CimInstance -ClassName Win32_DiskDrive).SerialNumber
	#$DiskSerial = (Get-Disk).SerialNumber    # Alternative Method

	# Resolves IP address using OpenDNS
	$IP = $(Resolve-DnsName -Name myip.opendns.com -Server 208.67.222.220).IPAddress

	# Checks the wallpaper was applied
	$WallpaperApplied = if ($Variables.CurrentWallpaper -eq $Variables.wpDest) { "YES" } else { "NO" }
	
	# - Checks if all the programs got installed
	$Programs = @("Google Chrome", "VLC", "Zoom", "Acrobat", "HEVC")
	$ProgramStatus = @{ }
	foreach ($program in $Programs) {
		$ProgramStatus[$program] = if (Get-InstalledProgram -Name $program) { "YES" } else { "NO" }
	}
	
	$OptionalFeaturesList = Get-CimInstance -ClassName Win32_OptionalFeature | Format-Table -AutoSize | Out-String
	$UsersList = Get-LocalUser | Out-String


	# - Email Settings
	$smtp = 'smtp.shaw.ca'
	$To = '<newloads@shaw.ca>'
	$From = 'New Loads Log <newloadslogs@shaw.ca>'
	$Sub = "$ElapsedTime"
	$EmailBody = "
<#####################################>
<#                                   #>
<#          NEW LOADS LOG            #>
<#                                   #>
<#####################################>

- Script Information -

Program Version: $($Variables.ProgramVersion)
Date: $CurrentDateFormatted
Elapsed Time: $FormattedElapsedTime

- System Information -

$SystemSpecs
$ip\$env:computername\$env:USERNAME

- Summary -

Applications Installed: $appsyns
Chrome: $($ProgramStatus["Google Chrome"])
VLC: $($ProgramStatus["VLC"])
Adobe: $($ProgramStatus["Acrobat"])
Zoom: $($ProgramStatus["Zoom"])
HEVC: $($ProgramStatus["HEVC"])
Packages Removed During Debloat: $($Variables.Removed)
Wallpaper Applied: $WallpaperApplied
Windows 11 Start Layout Applied: $StartMenuLayout
Registry Keys Modified: $($Variables.ModifiedRegistryKeys)
Failed Registry Keys: $($Variables.FailedRegistryKeys)
Start Time: $FormattedStartTime
End Time: $FormattedEndTime


- Serial Numbers -
CPU: 
Motherboard: $MoboSerial
RAM:
GPU:
Drives:
	
	



- Powershell Information:
$PowershellTable


- Packages Removed:
$($Variables.PackagesRemoved)


- Installed win32 Applications:
$ListOfInstalledApplications


- Installed Appx Packages:
$ListOfInstalledPackages

- OptionalFeatures Installed:
$OptionalFeaturesList

- Users List:
$UsersList
"
	
	# Initiates array
	$LogFiles = @()
	# - Joins log files into an array to send as attachments
	if (Test-Path -Path $Variables.log) { $LogFiles += $Variables.log }
	if (Test-Path -Path $Variables.errorlog) { $LogFiles += $Variables.errorlog }
	# Check if $LogFiles is empty and set it to $false if it is
	if ($LogFiles.Count -eq 0) { $LogFiles = $false }
	
	Send-MailMessage -From $From -To $To -Subject $Sub -Body $EmailBody -Attachments:$LogFiles -SmtpServer $smtp
}
function Set-Branding {
<#
.SYNOPSIS
Sets the branding information for Mother Computers.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	Param (
		[Switch]$Undo,
		[Switch]$Skip = $SkipBranding,
		[Switch]$NoBranding
	)
	$Page = "Model"
	If ($Undo) {
		$Branding = @{
			store = ""
			phone = ""
			hours = ""
			url   = ""
			model = ""
		}
	} else {
		$Branding = @{
			store = "Mother Computers"
			phone = "(250) 479-8561"
			hours = "Mon-Sat  9 AM - 5 PM | Sunday: Closed"
			url   = "https://www.mothercomputers.com"
			model = "Mother Computers - (250) 479-8561"
		}
	}
	if ($PSCmdlet.ShouldProcess('Set-Branding', "Mother Computers Branding")) {
		Set-ScriptStatus -WindowTitle "Branding" -TweakTypeText "Branding" -TitleText "Branding" -TitleCounterText "Mother Branding" -AddCounter -LogSection "Mother's Branding"
		If (!$Skip) {
			# - Adds Mother Computers support info to About.
			Write-Status "Adding Mother Computers to Support Page" '+'
			Set-ItemPropertyVerified -Path $Registry.PathToOEMInfo -Name "Manufacturer" -Type String -Value $Branding.store
			Write-Status "Adding Mothers Number to Support Page" '+'
			Set-ItemPropertyVerified -Path $Registry.PathToOEMInfo -Name "SupportPhone" -Type String -Value $Branding.phone
			Write-Status "Adding Store Hours to Support Page" '+'
			Set-ItemPropertyVerified -Path $Registry.PathToOEMInfo -Name "SupportHours" -Type String -Value $Branding.hours
			Write-Status "Adding Store URL to Support Page" '+'
			Set-ItemPropertyVerified -Path $Registry.PathToOEMInfo -Name "SupportURL" -Type String -Value $Branding.url
			Write-Status "Adding Store Number to Settings Page" '+'
			Set-ItemPropertyVerified -Path $Registry.PathToOEMInfo -Name $page -Type String -Value $Branding.Model
		} else {
			Write-Status "Parameter -SkipBranding detected.. Skipping Mother Computers specific branding" '@' -WriteWarning -ForegroundColor RED
		}
	} else {
		Write-Host "$actionDescription operation canceled."
	}
}
function Set-ServiceStartup {
<#
.SYNOPSIS
Sets the startup type of one or more services.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess)]
	param (
		[Parameter(Mandatory = $true)]
		[ValidateSet('Automatic', 'Boot', 'Disabled', 'Manual', 'System')]
		[String]$State,
		[Parameter(Mandatory = $true)]
		[String[]]$Services,
		[String[]]$Filter
	)
	
	Begin {
		$Script:SecurityFilterOnEnable = @("RemoteAccess", "RemoteRegistry")
		$Script:TweakType = "Service"
	}
	
	Process {
		ForEach ($Service in $Services) {
			If (!(Get-Service $Service -ErrorAction SilentlyContinue)) {
				$Status = "The $Service service was not found."
				Write-Status $Status "?" -WriteWarning
				Add-Content -Path $Variables.Log -Value $Status
				Continue
			}
			
			If (($Service -in $SecurityFilterOnEnable) -and (($State -eq 'Automatic') -or ($State -eq 'Manual'))) {
				$Status = "Skipping $Service ($((Get-Service $Service).DisplayName)) to avoid a security vulnerability..."
				Write-Status $Status "!" -WriteWarning
				Add-Content -Path $Variables.Log -Value $Status
				Continue
			}
			
			If ($Service -in $Filter) {
				$Status = "The $Service ($((Get-Service $Service).DisplayName)) will be skipped as set on Filter..."
				Write-Status $Status "!" -WriteWarning
				Add-Content -Path $Variables.Log -Value $Status
				Continue
			}
			
			Try {
				$target = "$Service ($((Get-Service $Service).DisplayName)) as '$State' on Startup"
				Write-Status "Setting $target" "@" -NoNewLine
				If ($WhatIf) {
					Get-Service -Name "$Service" | Set-Service -StartupType $State -WhatIf
					Get-Status
				} Else {
					Get-Service -Name "$Service" | Set-Service -StartupType $State
					Get-Status
				}
			} catch {
				Get-Status
				Get-Error $Error[0]
				Continue
			}
		}
	}
}
function Set-StartMenu {
<#
.SYNOPSIS
Applies a Start Menu Layout for Windows 10 and Windows 11.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Skip = $SkipBranding,
		[Switch]$Undo
	)
	
	If ($Undo) {$Skip = $True}
	Set-ScriptStatus -WindowTitle "Start Menu" -TweakTypeText "StartMenu" -TitleCounterText "Start Menu Layout" -TitleText "StartMenu" -AddCounter -LogSection "Start Menu & Taskbar"
	if ($PSCmdlet.ShouldProcess("Set-StartMenu", "Applies a Start Menu Layout")) {
		If ($Skip) {
			Write-Status "Parameter -SkipBranding detected.. Skipping Mother Computers specific branding" '@' -WriteWarning -ForegroundColor RED
		}
		else {
			If ($Variables.osVersion -like "*Windows 10*") {
				Write-Section -Text "Clearing pinned start menu items for Windows 10"
				Write-Status "Clearing Windows 10 start pins" "@"
				Remove-StartPin
				
				<#$layoutFile = "C:\Windows\StartMenuLayout.xml"
				# Delete layout file if it already exists
				# Creates the blank layout file
				If (Test-Path $layoutFile) {
					Remove-Item $layoutFile
				}
				$Varaibles.START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII
				$regAliases = @("HKLM", "HKCU")
				#Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
				foreach ($regAlias in $regAliases) {
					$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
					$keyPath = $basePath + "\Explorer"
					Set-ItemPropertyVerified -Path $keyPath -Name "LockedStartLayout" -Value 1 -Type DWORD
					Set-ItemPropertyVerified -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile -Type ExpandString
				}
				#Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
				Restart-Explorer
				Start-Sleep -Seconds 5
				$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
				Start-Sleep -Seconds 5
				#Enable the ability to pin items again by disabling "LockedStartLayout"
				foreach ($regAlias in $regAliases) {
					$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
					$keyPath = $basePath + "\Explorer"
					Set-ItemPropertyVerified -Path $keyPath -Name "LockedStartLayout" -Value 0 -Type DWORD
				}
				Restart-Explorer
				# Uncomment the next line to make clean start menu default for all new users
				Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
				Remove-Item $layoutFile
				#>
				
				
				
			} elseif ($Variables.osVersion -like "*Windows 11*") {
				
				Write-Section -Text "Applying start menu layout for Windows 11"
				
				Write-Status "Attempting Start Menu Application" "+"
				If (!(Test-Path -Path $Variables.StartBin)) {
					Start-BitsTransfer -Source $Variables.StartBin2URL -Destination $Variables.StartBin -Dynamic
				}
				
				
				<#	Removed. Seems like 23H2 doesn't generate these files until the user account is created. 
					files are not preloaded in %LAP%\Packages\shellhostexperience (not actual path) and it does
					not seem like you can just copy these files into it.
				
				$Exists = Test-Path $Variables.StartBinDefault -ErrorAction SilentlyContinue
				If (!($Exists)) {
					Write-Status "Creating Microsoft.Windows.StartMenuExperienceHost in default user"
					mkdir $Variables.StartBinDefault -Force
				}
				Write-Status "Copying $newloads\start2.bin for new users" "+" -NoNewLine
				xcopy $Variables.StartBin $Variables.StartBinDefault /y | Out-Null
				Get-Status
				#>
				
				Write-Status "Copying $newloads\start2.bin to current user" "+" -NoNewLine
				xcopy $Variables.StartBin $Variables.StartBinCurrent /y | Out-Null
				Get-Status
			}
		}
	}
}
function Set-Taskbar {
<#
.SYNOPSIS
Applies a taskbar layout.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Undo,
		[Switch]$Skip = $SkipBranding
	)
	if ($PSCmdlet.ShouldProcess("Set-Taskbar", "Applies a taskbar layout")) {
		If ($Skip -or $Undo) {
			Write-Status "Parameter -SkipBranding detected.. Skipping Mother Computers specific branding" '@' -WriteWarning -ForegroundColor RED
		} else {
			Write-Status "Applying Taskbar Layout" '+' -NoNewLine
			If (Test-Path $Variables.layoutFile) {
				Remove-Item $Variables.layoutFile | Out-Null
			}
			$Visuals.StartLayout | Out-File $Variables.layoutFile -Encoding ASCII
			Get-Status
			Restart-Explorer
			Start-Sleep -Seconds 4
		}
	}
}
function Set-Wallpaper {
<#
.SYNOPSIS
Sets the wallpaper of the system to a specified image and sets the system to use light mode.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[String]$WallpaperURL = $Visuals.WallpaperURL,
		[Switch]$Undo,
		[Switch]$Skip = $skipBranding
	)
	Set-ScriptStatus -WindowTitle "Visual" -TweakTypeText "Visuals" -TitleCounterText "Visuals" -AddCounter -LogSection "Wallpaper & Visuals"
	if ($PSCmdlet.ShouldProcess("Set-Wallpaper", "Sets desktop wallpaper to a specified file")) {
		If ($Undo) {
			Start-Process "C:\Windows\Resources\Themes\aero.theme"
		} elseif ($Skip) {
			Write-Status "Parameter -SkipBranding detected.. Skipping Mother Computers specific branding" '@' -WriteWarning -ForegroundColor RED
		} else {
			$WallpaperPathExists = Test-Path $Variables.wallpaperPath
			If (!$WallpaperPathExists) {
				#$WallpaperURL = "https://raw.githubusercontent.com/circlol/newload/main/assets/mother.jpg"

				Write-Status "Downloading Wallpaper" "@" -NoNewLine
				Start-BitsTransfer -Source $WallpaperURL -Destination $Variables.wpDest -Dynamic
				Get-Status
			}
			Write-Status "Applying Wallpaper" "+"
			Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine
			Write-Host ": Wallpaper might not Apply UNTIL System is Rebooted"
			[System.Environment]::NewLine
			If (!(Test-Path $Variables.wpDest)) {
				Write-Status "Copying Wallpaper to Destination" "+" -NoNewLine
				Copy-Item -Path $Variables.wallpaperPath -Destination $Variables.wpDest -Force -Confirm:$False
				Get-Status
			}
			Write-Status "Setting WallpaperStyle to 'Stretch'" "+"
			Set-ItemPropertyVerified -Path $Registry.PathToCUControlPanelDesktop -Name WallpaperStyle -Value 2 -Type String
			Write-Status "Setting Wallpaper to Destination" "+"
			Set-ItemPropertyVerified -Path $Registry.PathToCUControlPanelDesktop -Name Wallpaper -Value $Variables.wpDest -Type String
			Write-Status "Setting System to use Light Mode" "+"
			Set-ItemPropertyVerified -Path $Registry.PathToRegPersonalize -Name "SystemUsesLightTheme" -Value 1 -Type DWord
			Write-Status "Setting Apps to use Light Mode" "+"
			Set-ItemPropertyVerified -Path $Registry.PathToRegPersonalize -Name "AppsUseLightTheme" -Value 1 -Type DWord
			Write-Status "Updating Wallpaper" "+" -NoNewLine
			Start-Process "RUNDLL32.EXE" "user32.dll, UpdatePerUserSystemParameters"
			Get-Status
		}
	}
}
function Start-Activation {
	Get-NetworkStatus
	Invoke-RestMethod $Variables.MAS | Invoke-Expression
}
function Start-BitlockerDecryption {
<#
.SYNOPSIS
Starts the decryption process for Bitlocker.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Skip = $SkipBitlocker
	)
	Set-ScriptStatus -WindowTitle "Bitlocker" -TweakTypeText "Bitlocker" -TitleCounterText "Bitlocker Decryption" -AddCounter -LogSection "Bitlocker Decryption"
	Write-Status "Checking for Bitlocker" "@"
	If ($Skip) {
		Write-Status "Parameter -SkipBitlocker detected.. Skipping Bitlocker Decryption." '@' -WriteWarning -ForegroundColor RED
	} else {
		if ($PSCmdlet.ShouldProcess("Start-BitlockerDecryption", "Starts the decryption process for Bitlocker.")) {
			# Checks if Bitlocker is active on the host
			$bitlockerVolume = Get-BitLockerVolume -MountPoint "C:" -WarningAction SilentlyContinue
			If ($bitlockerVolume -and $bitlockerVolume.ProtectionStatus -eq "On") {
				
				# Starts Bitlocker Decryption
				$messagebld = "Bitlocker was detected turned on. Do you want to start the decryption process?"
				$q = Show-Question -Buttons YesNo -Title "New Loads" -Icon Warning -Message $messagebld
				
				If ($q -eq $True) {
					Import-Module Bitlocker
					Write-Status "Alert: Bitlocker is enabled. Starting the decryption process" '@' -Types Warning
					Disable-BitLocker -MountPoint C:\
					Get-Status
				} else {
					Write-Status "Alert: Bitlocker is enabled. However user declined decryption" '@' -Types Warning
				}
				
			} else {
				$message = "Bitlocker is not enabled on this machine"
				Write-Status $message '?' -WriteWarning
				Add-Content -Path $Variables.Log -Value $message
			}
		}
	}
}
function Start-Bootup {
<#
.SYNOPSIS
This function checks the requirements for running the New Loads script and starts the bootup process.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	param ()
	Set-ScriptStatus -WindowTitle "Checking Requirements"
	
	# Checks OS version to make sure Windows is atleast v20H2 otherwise it'll display a message and close
	If ($Variables.BuildNumber -lt $variables.minbuildnumber) {
		Write-Host $Errors.errorMessage1 -ForegroundColor Yellow
		Read-Host -Prompt "Press enter to close New Loads"
		Exit
	}
	
	
	Get-Administrator
	Write-Logo
	$Text = "Bootup"
	Set-ScriptStatus -TitleCounterText $text -AddCounter
	Get-MissingDriver
	Get-ActivationStatus
	Update-Time
	
	$Global:StartTime = Get-Date
	$FormattedStartTime = $StartTime.ToString("yyMMdd")
	
	#New-Variable -Name Time -Value (Get-Date -UFormat %Y%m%d) -Scope Global
	If ($FormattedStartTime -gt $Variables.MaxTime -or $FormattedStartTime -lt $Variables.MinTime) {
		#Clear-Host
		Write-Status "Please manually update the time before continuing.." @(":(", "::ERROR::")
		Read-Host -Prompt "Press enter to close New Loads ::: The Settings page for time will open so you can sync right away"
		Start-Process ms-settings:dateandtime
		Stop-Process $Pid
	}
	
	

	try {
		Get-Item $Variables.Log -ErrorAction SilentlyContinue | Remove-Item
		
	} catch {
		return "An error occurred while removing the files: $_"
		Continue
	}
}
function Start-Chime {
<#
.SYNOPSIS
This function plays a sound file.
.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(Mandatory = $False)]
		[ValidateScript({
				Test-Path $_
			})]
		[String]$File = "C:\Windows\Media\Alarm06.wav"
	)
	
	if ($PSCmdlet.ShouldProcess("Play sound file", "Play sound file at $File")) {
		if (Test-Path $File) {
			try {
				$soundPlayer = New-Object System.Media.SoundPlayer
				$soundPlayer.SoundLocation = $File
				$soundPlayer.Play()
				$soundPlayer.Dispose()
			} catch {
				Write-Error "An error occurred while playing the sound: $_.Exception.Message"
			}
		} else {
			Write-Error "The sound file doesn't exist at the specified path."
		}
	}
}
function Start-Cleanup {
<#
.SYNOPSIS 
	Cleans up after New Loads.
.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Skip = $SkipCleanup,
		[String]$TweakType = "Cleanup",
		[Switch]$Undo
	)
	Set-ScriptStatus -WindowTitle "Cleanup" -TweakTypeText "Cleanup" -TitleCounterText "Cleanup" -TitleText "Cleanup" -AddCounter -LogSection "Cleanup"
	If ($Undo -or $Skip) {
		Write-Status "Parameter -SkipCleanup was detected.. Skipping this section." "@" -WriteWarning -ForegroundColor Red
	} else {
		if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
			
			# - Starts Explorer if it isn't already running
			If (!(Get-Process -Name Explorer)) {
				Restart-Explorer
			}
			
			# Removes layout file if it exists
			Get-Item $Variables.layoutFile -ErrorAction SilentlyContinue | Remove-Item
			

				
			# - Clears Temp Folder
			Write-Status "Cleaning Temp Folder" -NoLogEntry
			Remove-Item $NewLoads -Force -Recurse
			
			# - Removes installed program shortcuts from Public/User Desktop
			foreach ($shortcut in $Variables.shortcuts) {
				$ShortcutExist = Test-Path $shortcut
				If ($ShortcutExist) {
					Write-Status "Removing $shortcut" -NoLogEntry -NoNewLine
					Remove-Item -Path "$shortcut" -Force -ErrorAction SilentlyContinue | Out-Null
					Get-Status
				}
			}
			
			Write-Status "Launching Set As Default for Http and Https, Make sure to select always use and preferred browser." "@" -NoLogEntry
			Start-Process "https://google.ca"
			Start-Sleep -Seconds 5

			try {
				Write-Status "Removing Log: $($Variables.Log)" "-" -NoLogEntry
				Get-Item $Variables.Log -ErrorAction SilentlyContinue | Remove-Item
				#Get-Item $Variables.ErrorLog -ErrorAction SilentlyContinue | Remove-Item
			}catch {
				return "Error removing log files. Likely the log doesn't exist."
			}
			
			
		}
	}
}
function Start-Debloat {
<#
.SYNOPSIS
This function is used to debloat Windows 10 by removing Win32 apps, Start Menu Ads, and UWP apps.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess)]
	param (
		[Switch]$Undo,
		[Switch]$Skip = $SkipPrograms,
		[String]$TweakType = "UWP"
		
	)
	Set-ScriptStatus -WindowTitle "Debloat" -TweakTypeText "Debloat" -TitleCounterText "Debloat" -AddCounter -LogSection "Debloat"
	If ($Skip) {
		Write-Status "Parameter -SkipDebloat was detected.. Skipping Debloat." "@" -WriteWarning -ForegroundColor Red
	} else {
		If (!$Undo) {
			# Remove Win32 apps
			# TODO: Fix Debloat Remove Win32 apps
			# $Win32apps = @(
			#     "Avast"
			#     "ExpressVPN"
			#     "McAfee"
			#     "WebAdvisor"
			#     "Norton"
			#     "WildTangent"
			# )
			# foreach ($app in $Win32apps) { Remove-InstalledProgram "$app" }
			
			# Remove Start Menu Ads (.url, .lnk)
			ForEach ($app in $apps) {
				try {
					if (Test-Path -Path "$commonapps\$app.url") {
						# - Checks common start menu .urls
						if ($PSCmdlet.ShouldProcess("$app.url", "Remove")) {
							Write-Status "Removing $app.url" "-" -NoNewLine
							Remove-Item -Path "$commonapps\$app.url" -Force
							Get-Status
						}
					}
					if (Test-Path -Path "$commonapps\$app.lnk") {
						# - Checks common start menu .lnks
						if ($PSCmdlet.ShouldProcess("$app.lnk", "Remove")) {
							Write-Status "Removing $app.lnk" "-" -NoNewLine
							Remove-Item -Path "$commonapps\$app.lnk" -Force
							Get-Status
						}
					}
				} catch {
					Write-Status "An error occurred while removing $app`: $_" "!"
				}
			}
			
			# Remove UWP Apps
			Write-Section -Text "UWP Apps"
			$TotalItems = $Software.Programs.Count
			$CurrentItem = 0
			$PercentComplete = 0
			ForEach ($Program in $Software.Programs) {
				# - Uses blue progress bar to show debloat progress -- ## Doesn't seem to be working currently.
				Write-Progress -Activity "Debloating System" -Status " $PercentComplete% Complete:" -PercentComplete $PercentComplete
				# - Starts Debloating the system
				if ($PSCmdlet.ShouldProcess($Program, "Remove")) {
					Remove-UWPAppx -AppxPackages $Program
				}
				$CurrentItem++
				$PercentComplete = [int](($CurrentItem / $TotalItems) * 100)
			}
			# Disposing the progress bar after the loop finishes
			Write-Progress -Activity "Debloating System" -Completed
			
			# Debloat Completion
			Write-Host "Debloat Completed!" -Foregroundcolor Green
			[System.Environment]::NewLine
			Write-Host "Packages Removed: " -NoNewline -ForegroundColor Gray
			Write-Host $Variables.Removed -ForegroundColor Green
			If ($Failed) {
				Write-Host "Failed: " -NoNewline -ForegroundColor Gray
				Write-Host $Variables.FailedPackages -ForegroundColor Red
			}
			Write-Host "Packages Scanned For: " -NoNewline -ForegroundColor Gray
			Write-Host "$($Variables.PackagesNotFound)" -ForegroundColor Yellow
			[System.Environment]::NewLine
		} elseif ($Undo) {
			
			if ($PSCmdlet.ShouldProcess("Default Apps", "Reinstall")) {
				Write-Status "Reinstalling Default Apps from manifest" "+"
				Get-AppxPackage -allusers | ForEach-Object {
					Add-AppxPackage -register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode
				} | Out-Host
			}
			
		}
	}
}
function Start-Update {
<#
.SYNOPSIS
This function is used to update the system if the user accepts a prompt.

.NOTES
Author: Circlol
Date Created: Nov 5, 2023
Version: 1.0.1
History:
    1.0.1:
        - Added execution policy check and change
    1.0:
        - Created function
#>
	$lastUpdateCheckTime = Get-LastCheckForUpdate
	$currentTime = Get-Date
	# Calculate time difference in hours
	$timeDifference = ($currentTime - $lastUpdateCheckTime).TotalHours
	
	if ($timeDifference -gt 6) {
		$Message = "The last update check was more than 6 hour ago. Do you want to run Windows Update through New Loads now?"
		Write-Status "Press ALT + TAB if you dont see the form`n$Message"
		switch (Show-Question -Buttons YesNo -Title "Windows Updates Notification" -Icon Information -Message $Message) {
			'Yes' {
				## INSTALLATION
				Write-Status "Installing Assets" '+'
				
				# Installs NuGet
				Write-Status "NuGet" '+' -NoNewLine
				Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false | Out-Null
				Get-Status
				
				# Installs PSWindowsUpdate
				Write-Status "PSWindowsUpdate" '+' -NoNewLine
				Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
				Get-Status
				
				$Policy = Get-ExecutionPolicy
				If ($Policy -ne "RemoteSigned") {
					Write-Status "Changing Execution Policy"
					Set-ExecutionPolicy RemoteSigned -Confirm:$False -Scope Process -Force
				}
				
				# Small sleep to assure PSWindowsUpdate can be loaded
				Start-Sleep -Seconds 3
				try {
					
					# Imports PSWindowsUpdate
					Write-Status "Importing PSWindowsUpdate" '+' -NoNewLine
					Import-Module -Name PSWindowsUpdate -Force
					Get-Status
					Write-Status "Starting Windows Updates - Download, Install, IgnoreReboot, AcceptAll" '+'
					Get-WindowsUpdate -AcceptAll -Install -Download -IgnoreReboot
					
					# CLEANUP & REMOVAL OF START-UPDATE ASSETS
					#Write-Status "Removing Start-Update Assets" '-'
					#Write-Status "PSWindowsUpdate" '-' -NoNewLine
					#Remove-Module -Name PSWindowsUpdate -Force -Confirm:$false
					#Get-Status
					#Write-Status "NuGet" '-' -NoNewLine
					#Uninstall-PackageProvider -Name NuGet -Force -Confirm:$false | Out-Null
					#Get-Status
				} catch {
					Start-Process ms-settings:windowsupdate
					Write-Status "Failed to Update through the script. Please manually do it."
					Read-Host
					Stop-Process $Pid
				}
				
				Write-Status "Updates finished"
			}
			'No' {
				Write-Status "You choose to skip Windows Updates. Naughty Naughty" 'D:'
			}
		}
	} else {
		Write-Status "The last update check was within the 6 hours."
	}
}
function Update-Time {
	<#
.SYNOPSIS
Updates the time zone and synchronizes the system time.
.NOTES
	Author: Circlol
	Version: 1.1
	Change Log: 
		- 1.0
			Created function.
		- 1.1
			Added manual time synchronization using external time server.
			Created Get-ExactTimeZone function to handle scanning for Pacific Canada.
#>
	[CmdletBinding(SupportsShouldProcess)]
	param ()
	[String]$TimeZoneId = Get-ExactTimeZone
	#[string]$TimeZoneId = (Get-TimeZone -ListAvailable | Where-Object -Property ID -like 'Pacific Standard Time').ID
	$text = "Time & Date"
	Set-ScriptStatus -SectionText $Text -TweakTypeText $text -WindowTitle $text
	try {
		# Checks Time zone against specified
		$currentTimeZone = (Get-TimeZone).DisplayName
		If ($currentTimeZone -ne $TimeZoneId) {
			if ($PSCmdlet.ShouldProcess("Time zone change", "Setting time zone to $TimeZoneId")) {
				# Replaces if needed
				Write-Status "Current Time Zone: $currentTimeZone, Setting to $TimeZoneId" "+" -NoNewLine
				Set-TimeZone -Id $TimeZoneId -ErrorAction Stop
				Get-Status
			}
		}
				
	} catch {
		Return "Error: $($_.Exception.Message)"
		Continue
	}


		# Synchronize Time
		$w32TimeService = Get-Service W32Time
		if ($w32TimeService.Status -ne "Running") {
			if ($PSCmdlet.ShouldProcess("W32Time Service", "Starting service")) {
				Write-Status "Starting W32Time Service" "@" -NoNewLine
				Start-Service -Name W32Time
				Get-Status
			}
		}
		
		if ($PSCmdlet.ShouldProcess("Time synchronization", "Syncing time")) {
			Write-Status "Syncing Time" "@"
			
			# Sets service to manual 
			If ($w32TimeService.StartType -eq "Disabled") {
				Set-Service W32Time -StartupType Manual
			}
			
			If ($w32TimeService.Status -ne "Running") {
				Start-Service W32Time
			}
			
			# Resyncs time
			$resyncOutput = w32tm /resync
			
			# Catches resyncs output, if it couldn't change it will be attempted manually here.
			if ($resyncOutput -like "*The computer did not resync because the required time change was too big.*") {
				if ($PSCmdlet.ShouldProcess("Time synchronization", "Setting time manually")) {
					
					Write-Status "Setting time manually." '+'
					
					# Get time from an external time server
					try {
						
						Get-NetworkStatus
						$timeUrl = "http://worldtimeapi.org/api/ip"
						Write-Status "Getting time from $timeURL" "@" -NoNewLine
						$timeResponse = Invoke-RestMethod -Uri $timeUrl -Method Get
						Get-Status
						
						Write-Status "Converting Output to Local Time" "@" -NoNewLine
						$localTime = [datetime]::Parse($timeResponse.datetime).ToLocalTime()
						Get-Status
						
						$dateTimeString = $localTime.ToString("yyyy-MM-dd HH:mm:ss")
						$dateTime = [DateTime]::ParseExact($dateTimeString, "yyyy-MM-dd HH:mm:ss", $null)
						Write-Status "Setting date and time to $dateTimeString" "+" -NoNewLine
						Set-Date -Date $dateTime | Out-Null
						Get-Status
						
						
					} catch {
						Get-Status
						Get-Error $Error[0]
						$Variables.FailedRegistryKeys++
						Continue
					}
				}
			}
		}
}

#endregion

#region depricated
<#
function Update-Time.Old {
<#
.SYNOPSIS
Updates the time zone and synchronizes the system time.

.EXAMPLE
Update-Time -TimeZoneId "(UTC-05:00) Eastern Time (US & Canada)"
This example updates the system time zone to Eastern Time (US & Canada) and synchronizes the system time.
.NOTES
	Author: Circlol
	Version: 1.0
	Change Log: 
		- 1.0
			Created function.
##
	[CmdletBinding(SupportsShouldProcess)]
	param (
		[string]$TimeZoneId = "Pacific Standard Time"
	)
	
	try {
		$currentTimeZone = (Get-TimeZone).DisplayName
		If ($currentTimeZone -ne $TimeZoneId) {
			if ($PSCmdlet.ShouldProcess("Time zone change", "Setting time zone to $TimeZoneId")) {
				Write-Status "Current Time Zone: $currentTimeZone, Setting to $TimeZoneId" -NoNewLine
				Set-TimeZone -Id $TimeZoneId -ErrorAction Stop
				Get-Status
			}
		}
		
		# Synchronize Time
		$w32TimeService = Get-Service -Name W32Time
		if ($w32TimeService.Status -ne "Running") {
			if ($PSCmdlet.ShouldProcess("W32Time Service", "Starting service")) {
				Write-Status "Starting W32Time Service" "+" -NoNewLine
				Start-Service -Name W32Time
				Get-Status
			}
		}
		
		if ($PSCmdlet.ShouldProcess("Time synchronization", "Syncing time")) {
			Write-Status "Syncing Time" 'F5'
			If ($w32TimeService.StartType -eq "Disabled") {
				Set-Service W32Time -StartupType Manual
			}
			If ($w32TimeService.Status -ne "Running") {
				Start-Service W32Time
			}
			# Resyncs time
			$resyncOutput = w32tm /resync
			# Catches resyncs output, if it couldnt change it will be attempted manually here.
			if ($resyncOutput -like "*The computer did not resync because the required time change was too big.*") {
				if ($PSCmdlet.ShouldProcess("Time synchronization", "Setting time manually")) {
					Write-Status "Time change is too big. Setting time manually." '@' -WriteWarning
					Get-NetworkStatus
					w32tm /resync /force
				}
			}
		}
		
	} catch {
		Get-Status
		Get-Error $Error[0]
		Continue
	}
}
Function Get-Motherboard {
	<#
	.SYNOPSIS
	Retrieves the motherboard model and OEM information.
	.NOTES
	Author: Circlol
	Version: 1.0
	Release Notes:
	1.0:
		- Started logging changes.
	#
		[CmdletBinding()]
		[OutputType([String])]
		param ()
		$motherboardModel = Get-CimInstance -ClassName Win32_BaseBoard | Select-Object -ExpandProperty Product
		$motherboardOEM = Get-CimInstance -ClassName Win32_BaseBoard | Select-Object -ExpandProperty Manufacturer
		[String]$CombinedString = "$motherboardOEM $motherboardModel"
		return "$CombinedString"
	}
function Remove-InstalledProgram {

	## TODO Attempt to make this function compatible with all types of programs and strings
<#
.SYNOPSIS
Removes an installed program from the system.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#
	[CmdletBinding(SupportsShouldProcess)]
	param (
		[Parameter(Mandatory = $true)]
		[String]$Name,
		[String]$TweakType = "x86"
	)
	
	$uninstall32 = Get-ChildItem "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" |
	ForEach-Object {
		Get-ItemProperty $_.PSPath
	} |
	Where-Object {
		$_.DisplayName -like "*$Name*"
	} |
	Select-Object UninstallString
	
	$uninstall64 = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" |
	ForEach-Object {
		Get-ItemProperty $_.PSPath
	} |
	Where-Object {
		$_.DisplayName -like "*$Name*"
	} |
	
	Select-Object UninstallString
	if ($uninstall64) {
		if ($PSCmdlet.ShouldProcess("Uninstalling program: $Name")) {
			$uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe", "" -Replace "/I", "" -Replace "/X", ""
			$uninstall64 = $uninstall64.Trim()
			$TweakType = "x64"
			#Write-Output "Uninstalling $Name..."
			
			Write-Status "Uninstalling $Name..." "-" -NoNewLine
			
			try {
				$process = Start-Process "msiexec.exe" -ArgumentList "/X $uninstall64 /qb" -Wait -PassThru
				$exitCode = $process.ExitCode
				if ($exitCode -eq 0) {
					$LogEntry.Successful = $True
					Write-Output "Uninstall of $Name succeeded with exit code $exitCode."
					Add-Content -Path $Variables.Log -Value $logEntry
				} else {
					$LogEntry.Successful = $false
					$status = "Uninstall of $Name failed with exit code $exitCode."
					Write-Output $status
					Add-Content -Path $Variables.Log -Value $logEntry
					Add-Content -Path $Variables.Log -Value $status
				}
			} catch {
				$status = "Uninstall of $Name failed with error: $_"
				Write-Output $status
				Add-Content -Path $Variables.Log -Value $status
			}
		}
	}
	
	
	if ($uninstall32) {
		if ($PSCmdlet.ShouldProcess("Uninstalling program: $Name")) {
			$uninstall32 = $uninstall32.UninstallString -Replace "msiexec.exe", "" -Replace "/I", "" -Replace "/X", ""
			$uninstall32 = $uninstall32.Trim()
			$TweakType = "x86"
			#Write-Output "Uninstalling $Name..."
			Write-Status "Uninstalling $Name..." "-" -NoNewLine
			
			try {
				$process = Start-Process "msiexec.exe" -ArgumentList "/X $uninstall32 /qb" -Wait -PassThru
				if ($exitCode -eq 0) {
					$LogEntry.Successful = $True
					Write-Output "Uninstall of $Name succeeded with exit code $exitCode."
					Add-Content -Path $Variables.Log -Value $logEntry
				} else {
					$LogEntry.Successful = $false
					$status = "Uninstall of $Name failed with exit code $exitCode."
					Write-Output $status
					Add-Content -Path $Variables.Log -Value $logEntry
					Add-Content -Path $Variables.Log -Value $status
				}
			} catch {
				$status = "Uninstall of $Name failed with error: $_"
				Write-Output $status
				Add-Content -Path $Variables.Log -Value $status
			}
		}
	}
}
#>
#endregion

#>
#endregion
#region Execution




try {
	Start-Bootup
	Add-Type -AssemblyName System.Windows.Forms -Verbose:$VerbosePreference
	Add-Type -AssemblyName System.Drawing -Verbose:$VerbosePreference

	Import-Module Appx -Verbose:$VerbosePreference
	Import-Module BitsTransfer -Verbose:$VerbosePreference
	Import-Module CimCmdlets -Verbose:$VerbosePreference
	Import-Module ScheduledTasks -Verbose:$VerbosePreference
	Import-Module PrintManagement -Verbose:$VerbosePreference
	Import-Module DnsClient -Verbose:$VerbosePreference
} catch {
	throw "An error occured while booting up. Error: $_"
}

Get-Program -WhatIf:$WhatIfPreference
Set-StartMenu -Undo:$Undo -WhatIf:$WhatIfPreference
Set-Taskbar  -Undo:$Undo -WhatIf:$WhatIfPreference
Set-Wallpaper -Undo:$Undo -WhatIf:$WhatIfPreference
Set-Branding -Undo:$Undo -WhatIf:$WhatIfPreference
Start-Debloat -Undo:$Undo -WhatIf:$WhatIfPreference
Get-ADWCleaner -WhatIf:$WhatIfPreference
Get-Office
Start-BitlockerDecryption -WhatIf:$WhatIfPreference
Optimize-General -Undo:$Undo -WhatIf:$WhatIfPreference
Optimize-Performance -Undo:$Undo -WhatIf:$WhatIfPreference
Optimize-Privacy -Undo:$Undo -WhatIf:$WhatIfPreference
Optimize-Security -Undo:$Undo -WhatIf:$WhatIfPreference
Optimize-Service -Undo:$Undo -WhatIf:$WhatIfPreference
Optimize-SSD -Undo:$Undo -WhatIf:$WhatIfPreference
Optimize-TaskScheduler -Undo:$Undo -WhatIf:$WhatIfPreference
Optimize-WindowsOptional -Undo:$Undo -WhatIf:$WhatIfPreference
New-SystemRestorePoint -WhatIf:$WhatIfPreference
Get-Status -WriteToLog
Send-EmailLog
Start-Cleanup -WhatIf:$WhatIfPreference
Request-PCRestart


#endregion 
