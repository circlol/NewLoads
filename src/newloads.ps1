﻿#region Beginning
Clear-Host
#.NOTES
#Author         : Circlol
#GitHub         : https://github.com/Circlol/NewLoads
#Version        : 1.08.02_beta

#Changelog: 
# 1.08
	# - Adjusted custom Write- functions to calculate current width and fill/center in terminal
# - Split variables into categorized hashtables
# -	Fixed Get-Status failed action
	


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[Console]::Title = "New Loads"
[Console]::ForegroundColor = "White"
[Console]::BackgroundColor = 'Black'
$ErrorActionPreference = "SilentlyContinue"
$NewLoads =  [System.IO.DirectoryInfo]::new($Env:temp)
Clear-Host




#endregion
#region Variables
$Variables = @{
	"Creator"		   = "Mike Ivison"
	"ProgramVersion"   = "v1.08.02_beta"
	"LastUpdate" 	   = "19-07-2024"
	
	
	"ForegroundColor"  = "White"
	"BackgroundColor"  = "Black"
	"AccentColor1"	   = "Magenta"
	"AccentColor2"	   = "White"
	"AccentColor3"	   = "DarkMagenta"
	"LogoColor"	       = "Magenta"
	
	"Time"			   = Get-Date -UFormat %Y%m%d
	"MaxTime"		   = 250101
	"MinTime"		   = 240710
	"Counter"		   = 1
	"MaxLength"	       = 11
	"Win11"		       = 22000
	"Win22H2"		   = 22621
	"Win23H2"		   = 22631
	"MinBuildNumber"   = 19042
	"BuildNumber"	   = [System.Environment]::OSVersion.Version.Build
	"OSVersion"	       = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
	"Connected"	       = "Internet"
	# Local File Paths
	"wpDest"		   = [System.IO.DirectoryInfo]::new("$env:SystemRoot\Resources\Themes\mother.jpg")
	"ErrorLog"		   = [System.IO.DirectoryInfo]::new("$Env:UserProfile\Desktop\New Loads Errors.txt")
	"Log"			   = [System.IO.DirectoryInfo]::new("$Env:UserProfile\Desktop\New Loads.txt")
	
	"adwDestination"   = [System.IO.DirectoryInfo]::new("$NewLoads\adwcleaner.exe")
	"WallpaperPath"    = [System.IO.DirectoryInfo]::new("$NewLoads\mother.jpg")
	"SaRA"			   = [System.IO.DirectoryInfo]::new("$NewLoads\SaRA.zip")
	"Sexp"			   = [System.IO.DirectoryInfo]::new("$NewLoads\SaRA")
	
	"MAS"			   = "mas.newloads.ca"
	"SaRAURL"		   = "https://github.com/circlol/newload/raw/main/SaRACmd_17_01_0495_021.zip"
	"StartBinURL"	   = "https://github.com/circlol/newload/raw/main/assets/start.bin"
	"StartBin2URL"	   = "https://github.com/circlol/newload/raw/main/assets/start2.bin"
	#"adwLink"		   = "https://github.com/circlol/newload/raw/main/adwcleaner.exe"
	
	"PackagesRemoved"  = @()
	"Removed"		   = 0
	"FailedPackages"   = 0
	"PackagesNotFound" = 0
	"CreatedKeys"	   = 0
	"FailedRegistryKeys" = 0
	"ModifiedRegistryKeys" = 0
	
	"TimeoutScreenBattery" = 5
	"TimeoutScreenPluggedIn" = 10
	"TimeoutStandByBattery" = 15
	"TimeoutStandByPluggedIn" = 30
	"TimeoutDiskBattery" = 15
	"TimeoutDiskPluggedIn" = 30
	"TimeoutHibernateBattery" = 15
	"TimeoutHibernatePluggedIn" = 30
	
	"StartBinDefault"  = [System.IO.DirectoryInfo]::new("$Env:SystemDrive\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\")
	"StartBinCurrent"  = [System.IO.DirectoryInfo]::new("$Env:LocalAppData\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState")
	"LayoutFile"	   = [System.IO.DirectoryInfo]::new("$Env:LocalAppData\Microsoft\Windows\Shell\LayoutModification.xml")
	"CommonApps"	   = [System.IO.DirectoryInfo]::new("$Env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs")
	
	#Wallpaper
	"CurrentWallpaper" = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper
	
	#Office Removal
	"PathToOffice86"   = [System.IO.DirectoryInfo]::new("${env:ProgramFiles(x86)}\Microsoft Office")
	"PathToOffice64"   = [System.IO.DirectoryInfo]::new("$env:ProgramFiles\Microsoft Office 15")
	"OfficeCheck"	   = $false
	"Office32"		   = $false
	"Office64"		   = $false
	"UsersFolder"	   = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
	"ThisPC"		   = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
	
	
	# - Shortcuts
	"Shortcuts"	       = @(
		[System.IO.DirectoryInfo]::new("$Env:USERPROFILE\Desktop\Microsoft Edge.lnk")
		[System.IO.DirectoryInfo]::new("$Env:PUBLIC\Desktop\Microsoft Edge.lnk")
		[System.IO.DirectoryInfo]::new("$Env:PUBLIC\Desktop\Adobe Reader.lnk")
		[System.IO.DirectoryInfo]::new("$Env:PUBLIC\Desktop\Acrobat Reader DC.lnk")
		[System.IO.DirectoryInfo]::new("$Env:PUBLIC\Desktop\VLC Media Player.lnk")
		[System.IO.DirectoryInfo]::new("$Env:PUBLIC\Desktop\Zoom.lnk")
	)
	
	

	
	"EnableServicesOnSSD" = @("SysMain", "WSearch")

}
$Bloatware = @{
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
	
	
	"List" = @(
		# Microsoft Applications
		"Microsoft.549981C3F5F10" # Cortana
		"Microsoft.3DBuilder" # 3D Builder
		"Microsoft.Appconnector" # App Connector
		#"*Microsoft.Advertising.Xaml*"
		#"Microsoft.BingFinance" 										# Bing Finance
		#"Microsoft.BingFoodAndDrink" 									# Food And Drink
		#"Microsoft.BingHealthAndFitness" 								# Health And Fitness
		#"Microsoft.BingNews" 											 # Bing News
		#"Microsoft.BingSports" 										# Bing Sports
		#"Microsoft.BingTranslator" 									 # Bing Translator
		#"Microsoft.BingTravel" 										 # Bing Travel
		#"Microsoft.BingWeather" 										# Weather
		"Microsoft.CommsPhone" # Your Phone
		"Microsoft.ConnectivityStore" # Connectivity Store
		"Microsoft.windowscommunicationsapps" # Old mail and calendar
		"Microsoft.Messaging" # Messaging
		"Microsoft.Microsoft3DViewer" # 3D Viewer
		"Microsoft.MicrosoftOfficeHub" # Office
		"Microsoft.MicrosoftPowerBIForWindows" # Power Automate
		"Microsoft.MicrosoftSolitaireCollection" # MS Solitaire
		"Microsoft.MinecraftEducationEdition" # Minecraft Education Edition for Windows 10
		"Microsoft.MinecraftUWP" # Minecraft
		"Microsoft.MixedReality.Portal" # Mixed Reality Portal
		"Microsoft.Office.Hub" # Office Hub
		"Microsoft.Office.Lens" # Office Lens
		"Microsoft.Office.OneNote" # Office One Note
		"Microsoft.Office.Sway" # Office Sway
		"Microsoft.OneConnect" # OneConnect
		"Microsoft.People" # People
		"Microsoft.SkypeApp" # Skype (Who still uses Skype? Use Discord)
		"MicrosoftTeams" # Teams / Preview
		"Microsoft.Todos" # To Do
		"Microsoft.Wallet" # Wallet
		"Microsoft.Whiteboard" # Microsoft Whiteboard
		"Microsoft.WindowsPhone" # Your Phone Alternate
		"Microsoft.WindowsReadingList" # Reading List
		#"Microsoft.WindowsSoundRecorder"            			 		 # Sound Recorder
		"Microsoft.ZuneMusic" # Groove Music / (New) Windows Media Player
		"Microsoft.ZuneVideo" # Movies & TV
		"Microsoft.XboxApp" # Xbox
		"Microsoft.Xbox.TCUI" # Xbox
		#"Microsoft.XboxGameCallableUI"                         		 # Xbox Game Callable UI ## NON-REMOVABLE = TRUE
		"Microsoft.XboxIdentityProvider" # Xbox Identity Provider
		"Microsoft.XboxGameOverlay" # Xbox Game Overlay
		"Microsoft.XboxSpeechToTextOverlay" # Xbox Text To Speech Overlay
		# 3rd party Apps
		"*ACGMediaPlayer*" # ACGMediaPlayer
		"*ActiproSoftwareLLC*" # ActiproSoftware
		"*AdobeSystemsIncorporated.AdobePhotoshopExpress*" # Adobe Photoshop Express
		"*AdobePhotoshopExpress*" # Adobe Photoshop Express
		"AdobeSystemsIncorporated.AdobeLightroom" # Adobe Lightroom
		"AdobeSystemsIncorporated.AdobeCreativeCloudExpress" # Adobe Creative Cloud Express
		"AdobeSystemsIncorporated.AdobeExpress" # Adobe Creative Cloud Express
		"*Amazon.com.Amazon*" # Amazon
		"AmazonVideo.PrimeVideo" # Amazon Prime Video
		"57540AMZNMobileLLC.AmazonAlexa" # Amazon Alexa
		"*BubbleWitch3Saga*" # Bubble Witch 3 Saga
		"*CandyCrush*" # Candy Crush
		"Clipchamp.Clipchamp" # Clip Champ
		"*DisneyMagicKingdoms*" # Disney Magic Kingdom
		"Disney.37853FC22B2CE" # Disney Plus
		"*Disney*" # Disney Plus
		"*Dolby*" # Dolby Products (Like Atmos)
		"*DropboxOEM*" # Dropbox
		"*Duolingo-LearnLanguagesforFree*" # Duolingo
		"*EclipseManager*" # EclipseManager
		"Evernote.Evernote" # Evernote
		"*ExpressVPN*" # ExpressVPN
		"*Facebook*" # Facebook
		"*Flipboard*" # Flipboard
		"*HiddenCity*" # Hidden City
		"*HiddenCityMysteryofShadows*" # Hidden City Mystery of Shadows
		"*HotspotShieldFreeVPN*" # Hotspot Shield VPN
		"*Hulu*" # Hulu
		"*Instagram*" # Instagram
		"*LinkedInforWindows*" # LinkedIn
		"*McAfee*" # McAfee
		"5A894077.McAfeeSecurity" # McAfee Security
		"4DF9E0F8.Netflix" # Netflix
		"*Netflix*"
		"*OneCalendar*"
		"*PandoraMediaInc*"
		"*PicsArt-PhotoStudio*" # PhotoStudio
		"*Pinterest*" # Pinterest
		"142F4566A.147190D3DE79" # Pinterest
		"1424566A.147190DF3DE79" # Pinterest
		"*Royal Revolt*"
		"*Speed Test*"
		"SpotifyAB.SpotifyMusic" # Spotify
		"*Sway*"
		"*Twitter*" # Twitter
		"*TikTok*" # TikTok
		"*Viber*"
		"5319275A.WhatsAppDesktop" # WhatsApp
		"*Wunderlist*"
		# Acer OEM Bloat
		"AcerIncorporated.AcerRegistration" # Acer Registration
		"AcerIncorporated.QuickAccess" # Acer Quick Access
		"AcerIncorporated.UserExperienceImprovementProgram" # Acer User Experience Improvement Program
		#"AcerIncorporated.AcerCareCenterS"         					# Acer Care Center
		"AcerIncorporated.AcerCollectionS" # Acer Collections
		# HP Bloat
		"AD2F1837.HPPrivacySettings" # HP Privacy Settings
		"AD2F1837.HPInc.EnergyStar" # Energy Star
		"AD2F1837.HPAudioCenter" # HP Audio Center
		# Common HP & Acer Bloat
		"CyberLinkCorp.ac.PowerDirectorforacerDesktop" # CyberLink Power Director for Acer
		"CorelCorporation.PaintShopPro" # Coral Paint Shop Pro
		"26720RandomSaladGamesLLC.HeartsDeluxe" # Hearts Deluxe
		"26720RandomSaladGamesLLC.SimpleSolitaire" # Simple Solitaire
		"26720RandomSaladGamesLLC.SimpleMahjong" # Simple Mahjong
		"26720RandomSaladGamesLLC.Spades" # Spades
)
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
	"PathToLMCurrentVersion"																												  = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
	"PathToLMOldDotNet"																													      = "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319"
	"PathToLMPoliciesToWifi"																												  = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi"
	"PathToLMConsentStoreAD"																												  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics"
	"PathToLMConsentStoreUAI"																												  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation"
	"SecurityPath"																														      = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BLOCK_CROSS_PROTOCOL_FILE_NAVIGATION"
	"RegCAM"																																  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	"PathToLMConsentStoreUN"																												  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener"
	"PathToLMDeviceMetaData"																												  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata"
	"PathToLMEventKey"																													      = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey"
	"PathToLMDriverSearching"																												  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching"
	#"PathToRegExplorerLocalMachine"																										      = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
	"PathToHide3DObjects"																													  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	"PathToLMPoliciesTelemetry2"																											  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	"PathToLMPoliciesExplorer"																											      = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	"PathToLMPoliciesSystem"																												  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
	"PathToLMWindowsTroubleshoot"																											  = "HKLM:\SOFTWARE\Microsoft\WindowsMitigation"
	"PathToLMMultimediaSystemProfile"																										  = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
	"PathToLMMultimediaSystemProfileOnGameTasks"																							  = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
	"PathToLMPoliciesEdge"																												      = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
	"PathToLMPoliciesMRT"																													  = "HKLM:\SOFTWARE\Policies\Microsoft\MRT"
	"PathToLMPoliciesPsched"																												  = "HKLM:\SOFTWARE\Policies\Microsoft\Psched"
	"PathToLMPoliciesSQMClient"																											      = "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows"
	"PathToLMActivityHistory"																												  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	"PathToLMPoliciesAdvertisingInfo"																										  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	"PathToLMPoliciesAppCompact"																											  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"
	"PathToLMPoliciesCloudContent"																										      = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	"PathToLMPoliciesTelemetry"																											      = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	#"PathToLMPoliciesWindowsStore"																										      = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
	"PathToUblockChrome"																													  = "HKLM:\SOFTWARE\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm"
	"PathToLMWowNodeOldDotNet"																											      = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319"
	"PathToGraphicsDrives"																												      = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
	"PathToLMAutoLogger"																													  = "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger"
	"PathToLMControl"																														  = "HKLM:\SYSTEM\CurrentControlSet\Control"
	"PathToLMLanmanServer"																												      = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
	"PathToLFSVC"																															  = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
	"PathToLMMemoryManagement"																											      = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
	"PathToLMNdu"																															  = "HKLM:\SYSTEM\ControlSet001\Services\Ndu"
	
	#$PathToLMPoliciesWindowsUpdate = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
	"PathToCUAccessibility"																												      = "HKCU:\Control Pane\Accessibility"
	"PathToCUControlPanelDesktop"																											  = "HKCU:\Control Panel\Desktop"
	"PathToCUMouse"																														      = "HKCU:\Control Panel\Mouse"
	"PathToCUUP"																															  = "HKCU:\Control Panel\International\User Profile"
	"PathToCUGameBar"																														  = "HKCU:\SOFTWARE\Microsoft\GameBar"
	"PathToCUInputTIPC"																													      = "HKCU:\SOFTWARE\Microsoft\Input\TIPC"
	"PathToCUInputPersonalization"																										      = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
	"PathToCUPersonalization"																												  = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
	"PathToCUSiufRules"																													      = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	"PathToCUOnlineSpeech"																												      = "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	"PathToVoiceActivation"																												      = "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps"
	"PathToRegCurrentVersion"																												  = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion"
	"PathToRegCurrentVersionFeeds"																										      = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds"
	"PathToRegAdvertising"																												      = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
	"PathToCUAppHost"																														  = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost"
	"PathToBackgroundAppAccess"																											      = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
	"PathToCUContentDeliveryManager"																										  = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	"PathToCUConsentStoreAD"																												  = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics"
	"PathToCUConsentStoreUAI"																												  = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation"
	"PathToCUDeviceAccessGlobal"																											  = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global"
	"PathToCUExplorer"																													      = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
	"PathToCUExplorerAdvanced"																											      = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	"PathToCUExplorerRibbon"																												  = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon"
	"PathToCUFeedsDSB"																													      = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds\DSB"
	"PathToRegCurrentVersionExplorerPolicy"																								      = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	"PathToPrivacy"																														      = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy"
	"PathToOEMInfo"																														      = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"
	"PathToCUSearch"																														  = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
	"PathToCUSearchSettings"																												  = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings"
	"PathToRegPersonalize"																												      = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
	"PathToCUUserProfileEngagemment"																										  = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement"
	"PathToCUPoliciesCloudContent"																										      = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	"PathToUsersControlPanelDesktop"																										  = "REGISTRY::HKEY_USERS\.DEFAULT\Control Panel\Desktop"
	
	"KeysToDelete"																														      = @(
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
		"SubscribedContent-310093Enabled" # "Show me the Windows Welcome Experience after updates and when I sign in highlight whats new and suggested"
		"RotatingLockScreenOverlayEnabled" # Rotation Lock
		"RotatingLockScreenEnabled" # Rotation Lock
		# Prevents Apps from re-installing
		"ContentDeliveryAllowed" # Disables Content Delivery
		"FeatureManagementEnabled" #
		"OemPreInstalledAppsEnabled" # OEM Advertising
		"PreInstalledAppsEnabled" # Preinstalled apps like Disney+, Adobe Express, ect.
		"PreInstalledAppsEverEnabled" # Preinstalled apps like Disney+, Adobe Express, ect.
		"RemediationRequired" #
		"SilentInstalledAppsEnabled" #
		"SoftLandingEnabled" #
		"SubscribedContent-314559Enabled" #
		"SubscribedContent-314563Enabled" # My People Suggested Apps
		"SubscribedContent-338387Enabled" # Facts, Tips and Tricks on Lock Screen
		"SubscribedContent-338388Enabled" # App Suggestions on Start
		"SubscribedContent-338389Enabled" # Tips, Tricks, and Suggestions Notifications
		"SubscribedContent-338393Enabled" # Suggested content in Settings
		'SubscribedContent-353694Enabled' # Suggested content in Settings
		'SubscribedContent-353696Enabled' # Suggested content in Settings
		"SubscribedContent-353698Enabled" # Timeline Suggestions
		"SubscribedContentEnabled" # Disables Subscribed content
		"SystemPaneSuggestionsEnabled" #
	)
	"ActivityHistoryDisableOnZero"																										      = @(
		"EnableActivityFeed"
		"PublishUserActivities"
		"UploadUserActivities"
	)
	
}
$ScheduledTasks = @{
	"ToEnable"																																																   = @(
		"\Microsoft\Windows\Defrag\ScheduledDefrag" # Defragments all internal storages connected to your computer
		"\Microsoft\Windows\Maintenance\WinSAT" # WinSAT detects incorrect system configurations, that causes performance loss, then sends it via telemetry | Reference (PT-BR): https://youtu.be/wN1I0IPgp6U?t=16
		"\Microsoft\Windows\RecoveryEnvironment\VerifyWinRE" # Verify the Recovery Environment integrity, it's the Diagnostic tools and Troubleshooting when your PC isn't healthy on BOOT, need this ON.
		"\Microsoft\Windows\Windows Error Reporting\QueueReporting" # Windows Error Reporting event, needed to improve compatibility with your hardware
	)
	"ToDisable"																																															       = @(
		"\Microsoft\Office\OfficeTelemetryAgentLogOn"
		"\Microsoft\Office\OfficeTelemetryAgentFallBack"
		"\Microsoft\Office\Office 15 Subscription Heartbeat"
		"\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
		"\Microsoft\Windows\Application Experience\ProgramDataUpdater"
		"\Microsoft\Windows\Application Experience\StartupAppTask"
		"\Microsoft\Windows\Autochk\Proxy"
		"\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" # Recommended state for VDI use
		"\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" # Recommended state for VDI use
		"\Microsoft\Windows\Customer Experience Improvement Program\Uploader"
		"\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" # Recommended state for VDI use
		"\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
		"\Microsoft\Windows\Location\Notifications" # Recommended state for VDI use
		"\Microsoft\Windows\Location\WindowsActionDialog" # Recommended state for VDI use
		"\Microsoft\Windows\Maps\MapsToastTask" # Recommended state for VDI use
		"\Microsoft\Windows\Maps\MapsUpdateTask" # Recommended state for VDI use
		"\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" # Recommended state for VDI use
		"\Microsoft\Windows\Retail Demo\CleanupOfflineContent" # Recommended state for VDI use
		"\Microsoft\Windows\Shell\FamilySafetyMonitor" # Recommended state for VDI use
		"\Microsoft\Windows\Shell\FamilySafetyRefreshTask" # Recommended state for VDI use
		"\Microsoft\Windows\Shell\FamilySafetyUpload"
		"\Microsoft\Windows\Windows Media Sharing\UpdateLibrary" # Recommended state for VDI use
	)
	
	
	
}
$Services = @{
	# Services which will be totally disabled
	"ToDisable"																											       = @(
		"DiagTrack" # DEFAULT: Automatic | Connected User Experiences and Telemetry
		"diagnosticshub.standardcollector.service" # DEFAULT: Manual    | Microsoft (R) Diagnostics Hub Standard Collector Service
		"dmwappushservice" # DEFAULT: Manual    | Device Management Wireless Application Protocol (WAP)
		"BthAvctpSvc" # DEFAULT: Manual    | AVCTP Service - This is Audio Video Control Transport Protocol service
		#"Fax"                                         # DEFAULT: Manual    | Fax Service
		"fhsvc" # DEFAULT: Manual    | Fax History Service
		"GraphicsPerfSvc" # DEFAULT: Manual    | Graphics performance monitor service
		#"HomeGroupListener"                         # NOT FOUND (Win 10+)| HomeGroup Listener
		#"HomeGroupProvider"                         # NOT FOUND (Win 10+)| HomeGroup Provider
		"lfsvc" # DEFAULT: Manual    | Geolocation Service
		"MapsBroker" # DEFAULT: Automatic | Downloaded Maps Manager
		"PcaSvc" # DEFAULT: Automatic | Program Compatibility Assistant (PCA)
		"RemoteAccess" # DEFAULT: Disabled  | Routing and Remote Access
		"RemoteRegistry" # DEFAULT: Disabled  | Remote Registry
		"RetailDemo" # DEFAULT: Manual    | The Retail Demo Service controls device activity while the device is in retail demo mode.
		"SysMain" # DEFAULT: Automatic | SysMain / Superfetch (100% Disk usage on HDDs)
		# read://https_helpdeskgeek.com/?url=https%3A%2F%2Fhelpdeskgeek.com%2Fhelp-desk%2Fdelete-disable-windows-prefetch%2F%23%3A~%3Atext%3DShould%2520You%2520Kill%2520Superfetch%2520(Sysmain)%3F
		"TrkWks" # DEFAULT: Automatic | Distributed Link Tracking Client
		"WSearch" # DEFAULT: Automatic | Windows Search (100% Disk usage on HDDs)
		# - Services which cannot be disabled (and shouldn't)
		#"wscsvc"                                   # DEFAULT: Automatic | Windows Security Center Service
		#"WdNisSvc"                                 # DEFAULT: Manual    | Windows Defender Network Inspection Service
		"NPSMSvc_df772"
		"LanmanServer"
		
	)
	
	# Making the services to run only when needed as 'Manual' | Remove the # to set to Manual
	"ToManual"																												   = @(
		"BITS" # DEFAULT: Manual    | Background Intelligent Transfer Service
		"BDESVC" # DEFAULT: Manual    | BItLocker Drive Encryption Service
		#"cbdhsvc_*"                      # DEFAULT: Manual    | Clipboard User Service
		"edgeupdate" # DEFAULT: Automatic | Microsoft Edge Update Service
		"edgeupdatem" # DEFAULT: Manual    | Microsoft Edge Update Service²
		"FontCache" # DEFAULT: Automatic | Windows Font Cache
		"iphlpsvc" # DEFAULT: Automatic | IP Helper Service (IPv6 (6to4, ISATAP, Port Proxy and Teredo) and IP-HTTPS)
		"lmhosts" # DEFAULT: Manual    | TCP/IP NetBIOS Helper
		"ndu" # DEFAULT: Automatic | Windows Network Data Usage Monitoring Driver (Shows network usage per-process on Task Manager)
		#"NetTcpPortSharing"             # DEFAULT: Disabled  | Net.Tcp Port Sharing Service
		"PhoneSvc" # DEFAULT: Manual    | Phone Service (Manages the telephony state on the device)
		"SCardSvr" # DEFAULT: Manual    | Smart Card Service
		"SharedAccess" # DEFAULT: Manual    | Internet Connection Sharing (ICS)
		"stisvc" # DEFAULT: Automatic | Windows Image Acquisition (WIA) Service
		"WbioSrvc" # DEFAULT: Manual    | Windows Biometric Service (required for Fingerprint reader / Facial detection)
		"Wecsvc" # DEFAULT: Manual    | Windows Event Collector Service
		"WerSvc" # DEFAULT: Manual    | Windows Error Reporting Service
		"wisvc" # DEFAULT: Manual    | Windows Insider Program Service
		"WMPNetworkSvc" # DEFAULT: Manual    | Windows Media Player Network Sharing Service
		"WpnService" # DEFAULT: Automatic | Windows Push Notification Services (WNS)
		# - Diagnostic Services
		"DPS" # DEFAULT: Automatic | Diagnostic Policy Service
		"WdiServiceHost" # DEFAULT: Manual    | Diagnostic Service Host
		"WdiSystemHost" # DEFAULT: Manual    | Diagnostic System Host
		# - Bluetooth services
		"BTAGService" # DEFAULT: Manual    | Bluetooth Audio Gateway Service
		"BthAvctpSvc" # DEFAULT: Manual    | AVCTP Service
		"bthserv" # DEFAULT: Manual    | Bluetooth Support Service
		"RtkBtManServ" # DEFAULT: Automatic | Realtek Bluetooth Device Manager Service
		# - Xbox services
		"XblAuthManager" # DEFAULT: Manual    | Xbox Live Auth Manager
		"XblGameSave" # DEFAULT: Manual    | Xbox Live Game Save
		"XboxGipSvc" # DEFAULT: Manual    | Xbox Accessory Management Service
		"XboxNetApiSvc" # DEFAULT: Manual    | Xbox Live Networking Service
		# - NVIDIA services
		"NVDisplay.ContainerLocalSystem" # DEFAULT: Automatic | NVIDIA Display Container LS (NVIDIA Control Panel)
		"NvContainerLocalSystem" # DEFAULT: Automatic | NVIDIA LocalSystem Container (GeForce Experience / NVIDIA Telemetry)
		# - Printer services
		#"PrintNotify"                   # DEFAULT: Manual    | WARNING! REMOVING WILL TURN PRINTING LESS MANAGEABLE | Printer Extensions and Notifications
		#"Spooler"                       # DEFAULT: Automatic | WARNING! REMOVING WILL DISABLE PRINTING              | Print Spooler
		# - Wi-Fi services
		#"WlanSvc"                       # DEFAULT: Manual (No Wi-Fi devices) / Automatic (Wi-Fi devices) | WARNING! REMOVING WILL DISABLE WI-FI | WLAN AutoConfig
		# - 3rd Party Services
		"gupdate" # DEFAULT: Automatic | Google Update Service
		"gupdatem" # DEFAULT: Manual    | Google Update Service²
		"DisplayEnhancementService" # DEFAULT: Manual    | A service for managing display enhancement such as brightness control.
		"DispBrokerDesktopSvc" # DEFAULT: Automatic | Manages the connection and configuration of local and remote displays
	)
	
}
$StartMenu = @{
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
        <taskbar:UWA AppUserModelID="Microsoft.SecHealthUI_8wekyb3d8bbwe!SecHealthUI" />
        <taskbar:UWA AppUserModelID="Microsoft.Windows.SecHealthUI_cw5n1h2txyewy!SecHealthUI" />
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
	#<taskbar:UWA AppUserModelID="Microsoft.OutlookForWindows_8wekyb3d8bbwe!Microsoft.OutlookforWindows" />
}



#endregion
#region Functions
#region Formatting
Function Add-LogSection {
	<#
.DESCRIPTION
The Add-LogSection function takes a section name as input and adds a new section to the log file with the section name as the title.

.EXAMPLE
Add-LogSection -Section "New Section"

This example adds a new section to the log file with the title "Section: New Section".

.NOTES
Author: Circlol
Version: 1.0
Release Notes:
    1.0:
        - Started logging changes.

#>
	param (
		$Section = "Next Section"
	)
	$Title = "

Section: $Section

"
	Add-Content -Path $Variables.Log -Value $Title
}
Function Get-Status {
	# Similar function to Get-Status, instead it stores all the information in a variable and outputs to a log at the end of the script. the function has a passhrough to start a new log entry. and end the log entry.
	<#
.SYNOPSIS
This function is used to get the status of a log entry and perform actions based on the status.

.DESCRIPTION
This function takes in a log entry and performs actions based on the status of the log entry. It can start or stop a transcript, and write to the log file.

.PARAMETER LogEntry
The log entry to be processed.

.PARAMETER EndLogEntry
A switch parameter that indicates whether the log entry is the last entry in the log.

.PARAMETER StartTranscript
A switch parameter that indicates whether to start a transcript.

.PARAMETER StopTranscript
A switch parameter that indicates whether to stop a transcript.

.NOTES
    Author: Circlol
    Version: 1.0
    Release Notes:
        1.0:
            - Started logging changes.
#>
	[CmdletBinding()]
	param (
		[Switch]$EndLogEntry,
		[Switch]$StartTranscript,
		[Switch]$StopTranscript
	)
	process {
		If ($StartTranscript) {
			Start-Transcript -Path $Variables.Log -Append | Write-ModifiedStatus -Types "STARTING" -Status "Starting Transcript"
		}
		
		If ($StopTranscript) {
			Stop-Transcript | Write-ModifiedStatus -Types "STOPPING" -Status "Stopping Transcript"
		}
		
		<#If (!$EndLogEntry) {
			If ($? -eq $True) {
				# If no error message is provided, assume success
				$LogEntry.Successful = $true
				Write-Caption -Type Success
			}
			else {
				# Set the global LogEntry.Successful to false
				$LogEntry.Successful = $false
				$LogEntry.ErrorMessage = $Error.Exception.Message
				# Log a failure message
				Write-Caption -Type Failed
				# Handle the error message
				Get-Error
			}
		}#>
		
		If (!$EndLogEntry) {
			# Ensure LogEntry is a hashtable to support property assignment
			If ($? -eq $True) {
				# If no error message is provided, assume success
				$LogEntry.Successful = $true
				Add-Content -Path $Variables.Log -Value $logEntry
				
				Write-Caption -Type Success
			} else {
				# Set the global LogEntry.Successful to false
				$LogEntry.Successful = $false
				$LogEntry += @{
					'ErrorMessage'= $Error[0].Exception.Message
				}
				Add-Content -Path $Variables.Log -Value $logEntry
				
				# Log a failure message
				Write-Caption -Type Failed
				# Handle the error message
				Get-Error $error[0].Exception.Message
			}
		} else {
			Add-Content -Path $Variables.Log -Value $logEntry
		}
	}
}
function Show-ScriptLogo {
	<#
	.SYNOPSIS
	Displays the New Loads initialization logo and information.
	
	.DESCRIPTION
	This function displays the New Loads initialization logo and information, including the creator, program version, release date, and specified parameters (if any). It also provides a notice to update Windows for best functionality.
	
	.EXAMPLE
	Show-ScriptLogo
	
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
$LogoPadding╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝`n"
	Write-Host "$Logo`n`n`n$leftPadding" -NoNewline -ForegroundColor $Variables.LogoColor -BackgroundColor $Variables.BackgroundColor 
	Write-Host "Created by " -NoNewLine -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	Write-Host "$($Variables.Creator)    " -NoNewLine -ForegroundColor Red -BackgroundColor $Variables.BackgroundColor 
	Write-Host "Version: " -NoNewLine -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	Write-Host $($Variables.ProgramVersion) -NoNewline -ForegroundColor Green -BackgroundColor $Variables.BackgroundColor
	Write-Host "   Last Update: " -NoNewLine -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	Write-Host "$($Variables.LastUpdate)" -NoNewline -ForegroundColor Green -BackgroundColor $Variables.BackgroundColor 
	Write-Host "`n`n" -NoNewline
	Write-Center "Notice: For best functionality, it is strongly suggested to update windows before running New Loads." -NoNewLine -ForegroundColor $Variables.AccentColor3 -BackgroundColor $Variables.BackgroundColor
	Write-Host "`n`n`n"
	Write-Host $b -BackgroundColor $Variables.AccentColor1 -ForegroundColor $Variables.AccentColor3
	Write-Host "`n`n"
	#Show-ScriptStatus -TitleText $null
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

.DESCRIPTION
This function writes a break line to the console.

.EXAMPLE
Write-Break

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
	Write-Host $line -NoNewLine -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	Write-Host "]`n" -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
}
Function Write-Caption {
<#
.SYNOPSIS
Writes a caption to the console.

.DESCRIPTION
This function writes a caption to the console.

.EXAMPLE
Write-Caption -Type Success -Text "Operation completed successfully."

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

.DESCRIPTION
This function writes a reminder to the console.

.EXAMPLE
Write-HostReminder -Text "Remember to save your work."

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding()]
	param (
		[String]$Text = "Example text"
	)
	Write-Host "[" -BackgroundColor $Variables.BackgroundColor -ForegroundColor $Variables.AccentColor1 -NoNewline
	Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine
	Write-Host "]" -BackgroundColor $Variables.BackgroundColor -ForegroundColor $Variables.AccentColor1 -NoNewline
	Write-Host ": $text`n"
}
function Write-Log {
	$TableToOutput | Format-Table -Property "Time", "Successful", "Types", "Status" | Out-File $Variables.Log
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

.DESCRIPTION
This function writes a section to the console.

.EXAMPLE
Write-Section -Text "Section Title"

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
	
	
	Write-Host "`n$leftPadding<" -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host $break -NoNewline -ForegroundColor $Variables.AccentColor2 -BackgroundColor $Variables.BackgroundColor
	Write-Host "] " -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host "$Text " -NoNewline -ForegroundColor $Variables.AccentColor2 -BackgroundColor $Variables.BackgroundColor
	Write-Host "[" -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host $break -NoNewline -ForegroundColor $Variables.AccentColor2 -BackgroundColor $Variables.BackgroundColor
	Write-Host ">" -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	#$TitleToLogFormat = "`n`n   $Text`n`n"
	Add-Content -Path $Variables.Log -Value $TitleToLogFormat
	
}
function Write-Status {
	<#
	.SYNOPSIS
		Writes a status to the console.
	
	.DESCRIPTION
		This function writes a status to the console.
	
	.PARAMETER Status
		A description of the Status parameter.
	
	.PARAMETER Types
		A description of the Types parameter.
	
	.PARAMETER WriteWarning
		A description of the WriteWarning parameter.
	
	.PARAMETER NoNewLine
		A description of the NoNewLine parameter.
	
	.PARAMETER ForegroundColorText
		A description of the ForegroundColorText parameter.
	
	.EXAMPLE
		Write-Status -Types "Info", "Verbose" -Status "Operation in progress."
	
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
		[Switch]$WriteWarning,
		[Parameter(Position = 3)]
		[Switch]$NoNewLine,
		[Parameter(Position = 5)]
		[ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')]
		[String]$ForegroundColorText = $Variables.ForegroundColor,
		[Parameter(Position = 6)]
		[ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')]
		[String]$BackgroundColorText = $Variables.BackgroundColor
	)
	
	If ($null -eq $ForegroundColorText) {
		$ForegroundColorText = [Console]::ForegroundColor
	}
	If ($null -eq $BackgroundColorText) {
		$BackgroundColorText = [Console]::BackgroundColor
	}
	
	If ($WriteWarning -eq $True) {
		$ForegroundColorText = "Yellow"
	}
	$time = (Get-Date).ToString("h:mm:ss tt")
	# Prints date in line, converts to Month Day Year Hour Minute Period
	$LogEntry = [PSCustomObject]@{
		Time	   = $time
		Successful = $false
		Types	   = $Types -join ', '
		Status	   = $Status
	}
	$Global:LogEntry = $LogEntry
	
	# Output the log entry to the console
	Write-Host "$time " -NoNewline -ForegroundColor DarkGray -BackgroundColor $BackgroundColorText
	
	
	If ($WriteWarning) {
		Write-Host $TweakType -NoNewline -ForegroundColor $ForegroundColorText -BackgroundColor $BackgroundColorText
		Write-Host " ::Warning:: -> " -NoNewline -ForegroundColor $ForegroundColorText -BackgroundColor $BackgroundColorText
		Write-Host $Status -ForegroundColor $ForegroundColorText -BackgroundColor $BackgroundColorText -NoNewline:$NoNewLine
	} Else { 
		ForEach ($Type in $Types) {
			Write-Host "$Type " -NoNewline -ForegroundColor $ForegroundColorText -BackgroundColor $BackgroundColorText
		}
		
		Write-Host $TweakType -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $BackgroundColorText
		Write-Host " -> " -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $BackgroundColorText
		Write-Host $Status -ForegroundColor $ForegroundColorText -BackgroundColor $BackgroundColorText -NoNewline:$NoNewLine
	}
	
	
	<#
		
	"ForegroundColor"  = "Magenta"
	"BackgroundColor"  = "Black"
	"AccentColor1"	   = "Magenta"
	"AccentColor2"	   = "White"
	"LogoColor"	       = "Magenta"
	
	
	#>
	
}
Function Write-Title {
<#
.SYNOPSIS
Writes a title to the console.

.DESCRIPTION
This function writes a title to the console.

.PARAMETER Text
The text to be displayed as the title.

.EXAMPLE
Write-Title -Text "Title Text"

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
	Write-Host $break -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	Write-Host "] " -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	Write-Host "[" -NoNewline -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Host $break -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	Write-Host ">`n`n" -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	
	
}
Function Write-TitleCounter {
<#
.SYNOPSIS
Writes a title counter to the console.

.DESCRIPTION
This function writes a title counter to the console, which includes a counter, a text, and a progress bar.

.PARAMETER Text
The text to display in the title counter.

.PARAMETER Counter
The current count to display in the title counter.

.PARAMETER MaxLength
The maximum length of the progress bar.

.EXAMPLE
Write-TitleCounter -Text "Processing data" -Counter 5 -MaxLength 10

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
	Write-Host " | " -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
	Write-Host "$Text" -ForegroundColor $Variables.AccentColor1 -BackgroundColor $Variables.BackgroundColor
	Write-Break
	#$TitleCounterLogFormat = "`n`n$break`n`n    ($Counter)/$($Variables.MaxLength)) | $Text`n`n$break`n"
	# Writes to Log
	Add-Content -Path $Variables.Log -Value "$TitleCounterLogFormat"
}


#endregion
#region Information based
Function Get-CPU {
<#
.SYNOPSIS
This function retrieves information about the CPU of the current system.

.DESCRIPTION
The Get-CPU function uses the Get-CimInstance cmdlet to retrieve information about the CPU of the current system, including the CPU name, number of cores, and number of threads.

.PARAMETER Formatted
If this switch is specified, the function returns the CPU information in a formatted string.

.PARAMETER NameOnly
If this switch is specified, the function returns only the CPU name.

.EXAMPLE
Get-CPU -Formatted
Returns the CPU information in a formatted string.

.EXAMPLE
Get-CPU -NameOnly
Returns only the CPU name.

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
		$cpuName = (Get-CimInstance -ClassName Win32_Processor).Name
		$cores = (Get-CimInstance -ClassName Win32_Processor).NumberOfCores
		$threads = (Get-CimInstance -ClassName Win32_Processor).NumberOfLogicalProcessors
	} catch {
		return "Error retrieving CPU information: $($_)"
	}
	
	if ($NameOnly) {
		return $cpuName
	}
	
	if ($Formatted) {
		return "CPU: $cpuName`nCores: $cores`nThreads: $threads"
	}
	
	return @{
		CPU	    = $cpuName
		Cores   = $cores
		Threads = $threads
	}
}
Function Get-DriveInfo {
<#
.SYNOPSIS
Retrieves information about physical disks.

.DESCRIPTION
This function retrieves information about physical disks, including the model, type, capacity, and health status.

.EXAMPLE
Get-DriveInfo

This example retrieves information about physical disks.

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

.DESCRIPTION
The Get-DriveSpace function retrieves information about the available and total storage space for all file system drives.
The function calculates the percentage of available storage space and outputs the results in a formatted string.

.PARAMETER DriveLetter
Specifies the drive letter for which to retrieve information. If not specified, the function retrieves information for all file system drives.

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
.DESCRIPTION
This function logs error messages to a specified file. It includes information such as the timestamp, user name, command, script path, error type, offending line number, and error message.
.PARAMETER ErrorMessage
The error message to be logged.
.PARAMETER ErrorLog
The path to the log file. Defaults to $Variables.Log.
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
		$ErrorMessage,
		#[string]$ErrorLog = $Variables.Log
		[string]$ErrorLog = $Variables.Errorlog
		
	)
	process {
		
		$lineNumber = $MyInvocation.ScriptLineNumber
		$command = $Error[0].InvocationInfo.MyCommand
		$errorType = $Error[0].CategoryInfo.Reason
		$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
		$scriptPath = $MyInvocation.MyCommand.Path
		$userName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
		$errorString = @"
**********************************************************************
$timestamp Executed by: $userName
Command: $command
Script Path: $scriptPath
Error Type: $errorType
Offending line number: $lineNumber
Error Message:
$ErrorMessage
**********************************************************************
"@
		try {
			Add-Content -Path $ErrorLog -Value $errorString
		} catch {
			Write-Error "Error writing to log: $($_.Exception.Message)"
		}
	}
}
Function Get-GPU {
<#
.SYNOPSIS
Gets the name of the GPU installed on the local computer.
.DESCRIPTION
This function uses the Get-CimInstance cmdlet to retrieve information about the video controller (GPU) installed on the local computer. It then selects the Name property of the returned object and returns it as a string.
.PARAMETER None
This function does not accept any parameters.
.OUTPUTS
System.String
This function returns a string that contains the name of the GPU installed on the local computer.
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
.DESCRIPTION
This function searches the registry for installed programs and returns a list of programs that match the specified name.
.PARAMETER Name
The name of the program to search for. This can be a partial or full name.
.OUTPUTS
A list of objects with Name, Version, Publisher, and UninstallString properties.
.EXAMPLE
PS C:\> Get-InstalledProgram -Name "Microsoft Visual"
Name                                Version         Publisher               UninstallString
----                                -------         ---------               ---------------
Microsoft Visual C++ 2015 Redist... 14.0.24215     Microsoft Corporation   MsiExec.exe /X{e46eca4f-393b-40df-9f49-076faf788d83}
Microsoft Visual C++ 2017 Redist... 14.16.27024    Microsoft Corporation   MsiExec.exe /X{e2ee15e2-a480-4bc5-bfb7-e9803d1d9823}
Microsoft Visual C++ 2019 Redist... 14.28.29913    Microsoft Corporation   MsiExec.exe /X{1d8e6291-b0d5-35ec-8441-6616f567a0f7}
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
			UninstallString = $_.GetValue("UninstallString")
		}
	} | Sort-Object -Property Name -Unique
}
function Get-MissingDriver {
	[CmdletBinding()]
	param ()
	
	# Create an array to store the driver information
	$drivers = @()
	
	# Get a list of all PnP devices
	$devices = Get-WmiObject -Class Win32_PnPEntity | Where-Object {
		$_.Status -ne "OK" -or $null -eq $_.DeviceID -or $_.Name -like "*Microsoft Basic Display Adapter*"
	}
	
	foreach ($device in $devices) {
		# Create a hashtable for the device information
		If ($null -eq $device.Name) {
			#$friendly = $device.Caption
		}
		
		
		$driverInfo = @{
			FriendlyName = $device.Name
			DeviceID	 = $device.DeviceID
		}
		# Add the hashtable to the array
		$drivers += $driverInfo
	}
	
	return $drivers
	
	#$driverStatus = Get-DriverStatus
	#$driverStatus | Format-Table -AutoSize	
}
Function Get-Motherboard {
<#
.SYNOPSIS
Retrieves the motherboard model and OEM information.
.DESCRIPTION
This function uses the Get-CimInstance cmdlet to retrieve the motherboard model and OEM information.
It then combines the two pieces of information into a single string and returns it.
.OUTPUTS
System.String
.EXAMPLE
PS C:\> Get-Motherboard
Dell Inc. 0YJPT1
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
	$motherboardModel = Get-CimInstance -ClassName Win32_BaseBoard | Select-Object -ExpandProperty Product
	$motherboardOEM = Get-CimInstance -ClassName Win32_BaseBoard | Select-Object -ExpandProperty Manufacturer
	[String]$CombinedString = "$motherboardOEM $motherboardModel"
	return "$CombinedString"
}
function Get-NetworkStatus {
<#
.SYNOPSIS
Checks the network status and waits for internet connection if necessary.
.DESCRIPTION
This function checks the network status and waits for internet connection if necessary. If the network status is not 'Internet', it displays a warning message and waits until the status changes to 'Internet'. Once the status changes, it tests the connection to the local computer and displays a message indicating that the computer is connected.
.PARAMETER NetworkStatusType
Specifies the type of network status to check. The default value is 'IPv4Connectivity'.
.EXAMPLE
Get-NetworkStatus
This example checks the network status and waits for internet connection if necessary.
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
	$NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
	if ($NetStatus -ne 'Internet') {
		Write-Status "Seems like there's no network connection. Please reconnect." 'WAITING' -ForegroundColorText Yellow
		while ($NetStatus -ne 'Internet') {
			Write-Status "Waiting for Internet" "WAITING" -ForegroundColorText Yellow
			Start-Sleep -Milliseconds 3500
			$NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
		}
		Test-Connection -ComputerName $Env:COMPUTERNAME -AsJob
		Start-Sleep -Seconds 2
		Write-Output "Connected: Moving On"
	}
}
function Get-Office {
<#
.SYNOPSIS
This function checks if Microsoft Office is installed on the device and removes it if it exists.
.DESCRIPTION
The Get-Office function checks if Microsoft Office is installed on the device by looking for the installation paths of both 32-bit and 64-bit versions of Office. If either path exists, the function sets the $Variables.officecheck variable to true, indicating that Office is installed. If Office is installed, the function calls the Remove-Office function to remove it.
.EXAMPLE
Get-Office

This command checks if Microsoft Office is installed on the device and removes it if it exists.
.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	Show-ScriptStatus -WindowTitle "Office" -TweakTypeText "Office" -TitleCounterText "Office" -AddCounter
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
This function retrieves the total physical memory of the computer and returns it in GB.
.DESCRIPTION
The Get-RAM function uses the Get-CimInstance cmdlet to retrieve the total physical memory of the computer.
It then converts the value to GB and returns it as a formatted string.
.PARAMETER None
This function does not accept any parameters.
.OUTPUTS
Returns a formatted string representing the total physical memory of the computer in GB.
.EXAMPLE
PS C:\> Get-RAM
16.00 GB
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

.DESCRIPTION
This function uses PowerShell's CIM cmdlets to retrieve system information such as CPU, GPU, RAM, Motherboard, OS, and Disk Info.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Get-SystemInfo
This example retrieves system information such as CPU, GPU, RAM, Motherboard, OS, and Disk Info.

.OUTPUTS
System information in the form of a string.

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
			$cpu = Get-CimInstance -ClassName Win32_Processor -Property Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
			$cpuName = $cpu.Name
			$clockSpeed = $cpu.MaxClockSpeed / 1000
			$clockSpeed = [math]::Round($clockSpeed, 2)
			$CPUCombinedString = "$cpuName @ $clockSpeed GHz"
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

.DESCRIPTION
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
		[Switch]$Undo
	)
	$Zero = 0
	$One = 1
	$OneTwo = 1
	Show-ScriptStatus -WindowTitle "Optimization" -TweakTypeText "Registry" -TitleCounterText "Optimization" -TitleText "General" -AddCounter -SectionText "Optimization: General"
	Add-LogSection -Section "Optimize: General Tweaks"
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
	
	if ($PSCmdlet.ShouldProcess("Optimize-General", "General tweaks to Windows")) {
		If ($Variables.osVersion -like "*Windows 10*") {
			# code for Windows 10
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
		} elseif ($Variables.osVersion -like "*Windows 11*") {
			## Code for Windows 11
			Write-Section -Text "Applying Windows 11 Specific Reg Keys"
			If ($Variables.BuildNumber -GE $Variables.Win22H2) {
				Write-Status "$($EnableStatus[1].Status) More Icons in the Start Menu.." $EnableStatus[1].Symbol
				Set-ItemPropertyVerified -Path $Registry.PathToCUExplorerAdvanced -Name Start_Layout -Value $One -Type DWORD -Force
			}
			
			# Sets explorer to compact mode
			Write-Status "$($EnableStatus[0].Status) Compact Mode View in Explorer " $EnableStatus[0].Symbol
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
Function Optimize-Performance {
<#
.SYNOPSIS
This function optimizes Windows 10 and 11 by disabling various features and services.

.DESCRIPTION
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
		[Switch]$Undo
	)
	Show-ScriptStatus -TweakTypeText "Performance" -TitleText "Performance" -SectionText "Optimization: System"
	Add-LogSection -Section "Optimize: Performance Tweaks"
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
	
	if ($PSCmdlet.ShouldProcess("Optimize-Performance", "Performance enhancing tweaks")) {
		$ExistingPowerPlans = $((powercfg -L)[3 .. (powercfg -L).Count])
		# Found on the registry: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\Default\PowerSchemes
		$BuiltInPowerPlans = @{
			"Power Saver"		     = "a1841308-3541-4fab-bc81-f71556f20b4a"
			"Balanced (recommended)" = "381b4222-f694-41f0-9685-ff5bb260df2e"
			"High Performance"	     = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
			"Ultimate Performance"   = "e9a42b02-d5df-448d-aa00-03f14749eb61"
		}
		$UniquePowerPlans = $BuiltInPowerPlans.Clone()
		
		Write-Caption -Text "Display" -Type None
		Write-Status "Enable Hardware Accelerated GPU Scheduling... (Windows 10 20H1+ - Needs Restart)" $EnableStatus[1].Symbol
		Set-ItemPropertyVerified -Path $Registry.PathToGraphicsDrives -Name "HwSchMode" -Type DWord -Value 2
		
		<# Retired due to Snapdragon processors #>
		# [@] (2 = Enable Ndu, 4 = Disable Ndu)
		#Write-Status "$($EnableStatus[0].Status) Ndu High RAM Usage..." $EnableStatus[0].Symbol
		#Set-ItemPropertyVerified -Path $Registry.PathToLMNdu -Name "Start" -Type DWord -Value 2
		
		# Details: https://www.tenforums.com/tutorials/94628-change-split-threshold-svchost-exe-windows-10-a.html
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
		
		Write-Section -Text "Power Plan Tweaks"
		Write-Status "Cleaning up duplicated Power plans..." "@"
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
		
		Write-Status "Setting the Monitor Timeout to AC: $($Variables.TimeoutScreenPluggedIn)..." $EnableStatus[1].Symbol -NoNewLine
		powercfg -Change Monitor-Timeout-AC $Variables.TimeoutScreenPluggedIn
		Get-Status
		Write-Status "Setting the Monitor Timeout to DC: $($Variables.TimeoutScreenBattery)..." $EnableStatus[1].Symbol -NoNewLine
		powercfg -Change Monitor-Timeout-DC $Variables.TimeoutScreenBattery
		Get-Status
		Write-Status "Setting the Standby Timeout to AC: $($Variables.TimeoutStandByPluggedIn)" $EnableStatus[1].Symbol -NoNewLine
		powercfg -Change Standby-Timeout-AC $Variables.TimeoutStandByPluggedIn
		Get-Status
		Write-Status "Setting the Standby Timeout to DC: $($Variables.TimeoutStandByBattery)..." $EnableStatus[1].Symbol -NoNewLine
		powercfg -Change Standby-Timeout-DC $Variables.TimeoutStandByBattery
		Get-Status
		Write-Status "Setting the Disk Timeout to AC: $($Variables.TimeoutDiskPluggedIn)" $EnableStatus[1].Symbol -NoNewLine
		powercfg -Change Disk-Timeout-AC $Variables.TimeoutDiskPluggedIn
		Get-Status
		Write-Status "Setting the Disk Timeout to DC: $($Variables.TimeoutDiskBattery)..." $EnableStatus[1].Symbol -NoNewLine
		powercfg -Change Disk-Timeout-DC $Variables.TimeoutDiskBattery
		Get-Status
		Write-Status "Setting the Hibernate Timeout to AC: $($Variables.TimeoutHibernatePluggedIn)..." $EnableStatus[1].Symbol -NoNewLine
		powercfg -Change Hibernate-Timeout-AC $Variables.TimeoutHibernatePluggedIn
		Get-Status
		Write-Status "Setting the Hibernate Timeout to DC: $($Variables.TimeoutHibernateBattery)..." $EnableStatus[1].Symbol -NoNewLine
		Powercfg -Change Hibernate-Timeout-DC $Variables.TimeoutHibernateBattery
		Get-Status
		Write-Status "Setting Power Plan to High Performance..." $EnableStatus[1].Symbol -NoNewLine
		powercfg -SetActive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
		Get-Status
		Write-Status "Creating the Ultimate Performance hidden Power Plan..." $EnableStatus[1].Symbol -NoNewLine
		powercfg -DuplicateScheme e9a42b02-d5df-448d-aa00-03f14749eb61
		Get-Status
		
		
		Write-Section "Network & Internet"
		Write-Status "Unlimiting your network bandwidth for all your system..." $EnableStatus[1].Symbol # Based on this Chris Titus video: https://youtu.be/7u1miYJmJ_4
		Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesPsched -Name "NonBestEffortLimit" -Type DWord -Value 0
		Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfile -Name "NetworkThrottlingIndex" -Type DWord -Value 0xffffffff
		Write-Section "System & Apps Timeout behaviors"
		Write-Status "Reducing Time to services app timeout to 2s to ALL users..." $EnableStatus[1].Symbol
		Set-ItemPropertyVerified -Path $Registry.PathToLMControl -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000 # Default: 20000 / 5000
		Write-Status "Don't clear page file at shutdown (takes more time) to ALL users..." "*"
		Set-ItemPropertyVerified -Path $Registry.PathToLMMemoryManagement -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
		Write-Status "Reducing mouse hover time events to 10ms..." $EnableStatus[1].Symbol
		Set-ItemPropertyVerified -Path $Registry.PathToCUMouse -Name "MouseHoverTime" -Type String -Value "1000" # Default: 400
		# Details: https://windowsreport.com/how-to-speed-up-windows-11-animations/ and https://www.tenforums.com/tutorials/97842-change-hungapptimeout-value-windows-10-a.html
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
		Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfileOnGameTasks -Name "GPU Priority" -Type DWord -Value 8 # Default: 8
		Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfileOnGameTasks -Name "Priority" -Type DWord -Value 6 # Default: 2
		Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfileOnGameTasks -Name "Scheduling Category" -Type String -Value "High" # Default: "Medium"
	}
}
Function Optimize-Privacy {
<#
.SYNOPSIS
Performs privacy optimizations on the Windows operating system.

.DESCRIPTION
This function performs various privacy optimizations on the Windows operating system, including disabling content suggestions, disabling advertiser ID, disabling telemetry, and more.

.PARAMETER Undo
Reverts the privacy tweaks that were previously applied.

.EXAMPLE
Optimize-Privacy
Optimize-Privacy -Undo
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
		[Switch]$Undo
	)
	Show-ScriptStatus -TweakTypeText "Privacy" -TitleText "Privacy" -SectionText "Optimization: Privacy"
	Add-LogSection -Section "Optimize: Privacy Tweaks"
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
	
	
	if ($PSCmdlet.ShouldProcess("Optimize-Privacy", "Perform privacy optimizations")) {
		
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
		Set-ItemPropertyVerified -Path REGISTRY::HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Name "DisableMFUTracking" -Value $One -Type DWORD
		
		If ($vari -eq 2) {
			Remove-Item -Path REGISTRY::HKCU:\Software\Policies\Microsoft\Windows\EdgeUI
		}
		
		# Sets windows feeback notifciations to never show
		Write-Status "$($EnableStatus[0].Status) Windows Feedback Notifications..." $EnableStatus[0].Symbol
		Set-ItemPropertyVerified -Path $Registry.PathToLMPoliciesTelemetry -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value $One
		
		# Disables location tracking
		Write-Status "$($EnableStatus[0].Status) Location Tracking..." $EnableStatus[0].Symbol
		Set-ItemPropertyVerified -Path $Registry.RegCAM -Name "Value" -Type String -Value "Deny"
		Set-ItemPropertyVerified -Path $Registry.PathToLFSVC -Name "Status" -Type DWORD -Value $Zero
		
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
			Write-Status "Setting up the DNS over HTTPS for Google and Cloudflare (ipv4 and ipv6)..." $EnableStatus[1].Symbol
			# Cloudflare
			Set-DnsClientDohServerAddress -ServerAddress ("1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2606:4700:4700::1001") -AutoUpgrade $true -AllowFallbackToUdp $true
			# Google
			Set-DnsClientDohServerAddress -ServerAddress ("8.8.8.8", "8.8.4.4", "2001:4860:4860::8888", "2001:4860:4860::8844") -AutoUpgrade $true -AllowFallbackToUdp $true
			Write-Status "Setting up the DNS from Cloudflare and Google (ipv4 and ipv6)..." $EnableStatus[1].Symbol
			Set-DNSClientServerAddress -InterfaceAlias "Ethernet*" -ServerAddresses ("1.1.1.1", "8.8.8.8", "2606:4700:4700::1111", "2001:4860:4860::8888")
			Set-DNSClientServerAddress -InterfaceAlias "Wi-Fi*" -ServerAddresses ("1.1.1.1", "8.8.8.8", "2606:4700:4700::1111", "2001:4860:4860::8888")
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
		Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfileOnGameTasks -Name "GPU Priority" -Type DWord -Value 8
		Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfileOnGameTasks -Name "Priority" -Type DWord -Value 6
		Set-ItemPropertyVerified -Path $Registry.PathToLMMultimediaSystemProfileOnGameTasks -Name "Scheduling Category" -Type String -Value "High"
		
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
Function Optimize-Security {
<#
.SYNOPSIS
This function applies various security patches and tweaks to optimize the security of the system.

.DESCRIPTION
The Optimize-Security function applies various security patches and tweaks to optimize the security of the system. It disables cross-protocol file navigation, enables default firewall profiles, enables detection for potentially unwanted applications, enables Microsoft Defender Exploit Guard network protection, enables SmartScreen for Microsoft Edge and Store Apps, disables SMB 1.0 protocol, enables .NET strong cryptography, and disables Autoplay for removable devices.

.EXAMPLE
Optimize-Security

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
		[Switch]$Undo
	)
	Show-ScriptStatus -TweakTypeText "Security" -TitleText "Security" -SectionText "Optimization: Security"
	Add-LogSection -Section "Optimize: Security Tweaks"
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
	
	if ($PSCmdlet.ShouldProcess("Optimize-Security", "Application of various patches, tighten Security")) {
		Write-Section "Security Patch"
		Write-Status "Applying Security Vulnerability Patch CVE-2023-36884 - Office and Windows HTML Remote Code Execution Vulnerability" $EnableStatus[1]
		
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
			Set-MpPreference -PUAProtection Enabled -Force
			Get-Status
			Write-Status "$($EnableStatus[0].Status) Microsoft Defender Exploit Guard network protection..." $EnableStatus[0].Symbol -NoNewLine
			Set-MpPreference -EnableNetworkProtection Disabled -Force
			Get-Status
		} else {
			Write-Status "$($EnableStatus[1].Status) detection for potentially unwanted applications and block them..." $EnableStatus[1].Symbol -NoNewLine
			Set-MpPreference -PUAProtection Enabled -Force
			Get-Status
			Write-Status "$($EnableStatus[1].Status) Microsoft Defender Exploit Guard network protection..." $EnableStatus[1].Symbol -NoNewLine
			Set-MpPreference -EnableNetworkProtection Enabled -Force
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
Function Optimize-Service {
<#
.SYNOPSIS
This script optimizes Windows services by disabling unnecessary services and enabling essential services.
.DESCRIPTION
This script disables the services listed in the $Services.ToDisable variable and enables the services listed in the $Variables.EnableServicesOnSSD variable.
It also sets the startup type of the services listed in the $Services.ToManual variable to 'Manual'.
.EXAMPLE
Optimize-Service
This command optimizes the Windows services by disabling unnecessary services and enabling essential services.
.NOTES
Author: Circlol
Version: 1.0
History:
1.0:
- Started logging changes.
#>
	[CmdletBinding()]
	param (
		[Parameter()]
		[Switch]$Undo
	)
	Show-ScriptStatus -TweakTypeText "Services" -TitleText "Services" -SectionText "Optimization: Services"
	Add-LogSection -Section "Optimize: Service Tweaks"
	
	
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
Function Optimize-SSD {
<#
.SYNOPSIS
Optimizes SSD performance by disabling/enabling last access timestamps updates on files.

.DESCRIPTION
This function optimizes SSD performance by disabling/enabling last access timestamps updates on files.
Disabling last access timestamps updates on files can improve the life of SSDs.

.PARAMETER Undo
If specified, enables last access timestamps updates on files.

.EXAMPLE
Optimize-SSD
Disables last access timestamps updates on files.

.EXAMPLE
Optimize-SSD -Undo
Enables last access timestamps updates on files.

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
		[Switch]$Undo
	)
	if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
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
Function Optimize-TaskScheduler {
<#
.SYNOPSIS
This function optimizes the Task Scheduler by disabling or enabling scheduled tasks in Windows.
.DESCRIPTION
This function disables or enables scheduled tasks in Windows Task Scheduler. It can also undo the changes made by the function.
.EXAMPLE
Optimize-TaskScheduler -Undo
This command undoes the changes made by the Optimize-TaskScheduler function.
.NOTES
Author: Circlol
Version: 1.0
History:
1.0:
- Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Undo
	)
	Show-ScriptStatus -TweakTypeText "TaskScheduler" -TitleText "Task Scheduler" -SectionText "Optimization: Task Scheduler"
	Add-LogSection -Section "Optimize: Task Scheduler"
	if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
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
Function Optimize-WindowsOptional {
<#
.SYNOPSIS
This function optimizes Windows by disabling unnecessary optional features and removing unnecessary printers.

.DESCRIPTION
This function disables unnecessary optional features and removes unnecessary printers to optimize Windows.

.EXAMPLE
Optimize-WindowsOptional

.NOTES
Author: Circlol
Version: 1.0
History:
1.0:
- Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Undo
	)
	Show-ScriptStatus -TweakTypeText "OptionalFeatures" -TitleText "Optional Features" -SectionText "Optimization: Optional Features"
	Add-LogSection -Section "Optimize: Optional Features"
	if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
		If ($Undo) {
			Write-Status "Reverting the tweaks is set to '$Undo'."
			$CustomMessage = {
				"Re-Installing the $OptionalFeature optional feature..."
			}
			Set-OptionalFeatureState -Enabled -OptionalFeatures $OptionalFeatures.ToDisable -CustomMessage $CustomMessage
		} Else {
			Set-OptionalFeatureState -Disabled -OptionalFeatures $OptionalFeatures.ToDisable
		}
		
		Write-Section -Text "Install Optional Features from Windows"
		Set-OptionalFeatureState -Enabled -OptionalFeatures $OptionalFeatures.ToEnable
		
		
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


#endregion
#region Helpers
function Find-ScheduledTask {
<#
.SYNOPSIS
This script contains a function named Find-ScheduledTask that checks if a scheduled task exists.

.DESCRIPTION
This script is used to check if a scheduled task exists. The Find-ScheduledTask function takes a parameter named ScheduledTask, which is the name of the scheduled task to check. If the scheduled task exists, the function returns true. If the scheduled task does not exist, the function returns false and writes a warning to the log file.

.EXAMPLE
Find-ScheduledTask -ScheduledTask "MyScheduledTask"

This example checks if a scheduled task named "MyScheduledTask" exists.

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
	$LicenseCodes = @{
		0 = 'Unlicensed'
		1 = 'Licensed'
		2 = 'OOBGrace'
		3 = 'OOTGrace'
		4 = 'NonGenuineGrace'
		5 = 'Notification'
		6 = 'ExtendedGrace'
	}
	
	$text = "Activation"
	Show-ScriptStatus -AddCounter -TitleText $text -TitleCounterText $text -TweakTypeText $text -WindowTitle $text
	
	Write-Status "Searching for Windows License Status" "@"
	$LicenseStatus = Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" |
	Where-Object {
		$_.PartialProductKey
	} | Select-Object Description, LicenseStatus
	
	If ($LicenseStatus.LicenseStatus -ne $LicenseCodes.1) {
		$message = "Warning: Windows is not Activated. Would you like to run MAS now?"
		Write-Status $message "?"
		do {
			$q = Show-Question -Message $message -Title 'Windows Activation' -Buttons YesNo -Icon Warning
		} until ($q -eq "Yes" -or $q -eq "No")
		switch ($q) {
			"Yes" {
				# Enable TLSv1.2 for compatibility with older clients for current session
				[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
				
				$DownloadURL1 = 'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/0884271c4fcdc72d95bce7c5c7bdf77ef4a9bcef/MAS/All-In-One-Version/MAS_AIO-CRC32_31F7FD1E.cmd'
				$DownloadURL2 = 'https://bitbucket.org/WindowsAddict/microsoft-activation-scripts/raw/0884271c4fcdc72d95bce7c5c7bdf77ef4a9bcef/MAS/All-In-One-Version/MAS_AIO-CRC32_31F7FD1E.cmd'
				
				$URLs = @($DownloadURL1, $DownloadURL2)
				$RandomURL1 = Get-Random -InputObject $URLs
				$RandomURL2 = $URLs -ne $RandomURL1
				
				try {
					$response = Invoke-WebRequest -Uri $RandomURL1 -UseBasicParsing
				} catch {
					$response = Invoke-WebRequest -Uri $RandomURL2 -UseBasicParsing
				}
				
				$rand = Get-Random -Maximum 99999999
				$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
				$FilePath = if ($isAdmin) {
					"$env:SystemRoot\Temp\MAS_$rand.cmd"
				} else {
					"$env:TEMP\MAS_$rand.cmd"
				}
				
				$ScriptArgs = "$args "
				$prefix = "@::: $rand `r`n"
				$content = $prefix + $response
				Set-Content -Path $FilePath -Value $content
				
				Start-Process $FilePath $ScriptArgs -Wait
				
				$FilePaths = @("$env:TEMP\MAS*.cmd", "$env:SystemRoot\Temp\MAS*.cmd")
				foreach ($FilePath in $FilePaths) {
					Get-Item $FilePath | Remove-Item
				}
			}
			"No" {
				try {
					Write-Status "Skipping Windows Activation" "/"
				} catch {
					Write-Output "Skipping Windows Activation"
				}
			}
			default {
				Write-Output "Comeonnow"
			}
		}
	}
}
function Get-Administrator {
	# Checks to make sure New Loads is run as admin otherwise it'll display a message and close
	If (!([bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544'))) {
		Write-Host $Errors.errorMessage2 -ForegroundColor Yellow
		do {
			$SelfElevate = Read-Host -Prompt "Would you like to run New Loads as an Administrator? (Y/N) "
			switch ($SelfElevate.ToUpper()) {
				"Y" {
					$wtExists = Get-Command wt
					If ($wtExists) {
						Start-Process wt -verb runas -ArgumentList "new-tab powershell -c ""irm run.newloads.ca | iex"""
					} else {
						Start-Process powershell -verb runas -ArgumentList "-command ""irm run.newloads.ca | iex"""
					}
					Write-Output "Exiting"
					exit
				}
				"N" {
					exit
				}
				default {
					Write-Host "Invalid input. Please enter Y or N."
				}
			}
		} while ($true)
	}
}
function Get-CheckForLastUpdate {
<#
.SYNOPSIS
Checks last time updates were ran.
.DESCRIPTION
Checks the last time the user Checked for Updates. This is done to assure technicians have updated before new loads is run.
.OUTPUTS
Outputs a date
.EXAMPLE
PS C:\> Get-CheckForLastUpdate

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
function Remove-InstalledProgram {
	## TODO Attempt to make this function compatible with all types of programs and strings
<#
.SYNOPSIS
Removes an installed program from the system.

.DESCRIPTION
This function removes an installed program from the system by searching for the program name in the registry and running the uninstall command.

.PARAMETER Name
Specifies the name of the program to be uninstalled.

.EXAMPLE
Remove-InstalledProgram -Name "Google Chrome"

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
function Remove-ItemPropertyVerified {
<#
.SYNOPSIS
Removes a property from an item at the specified path.

.DESCRIPTION
This function removes a property from an item at the specified path. It prompts for confirmation before removing the property.

.PARAMETER Path
Specifies the path of the item from which to remove the property.

.PARAMETER Name
Specifies the name of the property to remove.

.PARAMETER Force
Indicates that the cmdlet should not prompt for confirmation before removing the property.

.EXAMPLE
Remove-ItemPropertyVerified -Path "C:\Temp\file.txt" -Name "ReadOnly"

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
					Remove-ItemProperty -Path $Path -Name $Name -Force
				} else {
					Remove-ItemProperty -Path $Path -Name $Name
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

.DESCRIPTION
The Restart-Explorer function checks if Windows Explorer is running and restarts it if it is.

.EXAMPLE
Restart-Explorer

This command restarts Windows Explorer.

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
				taskkill /f /im explorer.exe
			} catch {
				Write-Warning "Failed to stop Explorer process: $_"
				Get-Error $Error[0]
				Continue
			}
		}
		try {
			Start-Process explorer -Wait
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

.DESCRIPTION
This function displays a message box to the user, asking if they want to restart their computer to apply changes. If the user selects "Yes", the function will restart the computer. If the user selects "No" or "Cancel", the function will exit without restarting the computer.

.EXAMPLE
Request-PCRestart

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	Param ()
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
function Remove-UWPAppx {
<#
.SYNOPSIS
Removes specified UWP appx packages from the system.

.DESCRIPTION
This function removes specified UWP appx packages from the system. It uses the Get-AppxPackage cmdlet to get the package to remove, and then removes it using the Remove-AppxPackage cmdlet. It also removes any provisioned packages using the Get-AppxProvisionedPackage cmdlet.

.PARAMETER AppxPackages
Specifies an array of UWP appx package names to remove.

.EXAMPLE
Remove-UWPAppx -AppxPackages "Microsoft.WindowsCalculator", "Microsoft.WindowsStore"

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
					Remove-AppxPackage $_.PackageFullName | Out-Null
					Get-Status
					If ($?) {
						$Variables.Removed++
						$Variables.PackagesRemoved += "$appxPackageToRemove.PackageFullName`n"
					} elseif (!($?)) {
						$Variabless.Failed++
					}
					Write-Status "Trying to remove provisioned $AppxPackage" "-" -NoNewLine
					Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null
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

.DESCRIPTION
This function sets a registry value if it doesn't exist or if it's different from the desired value. It can also create the registry key if it doesn't exist.

.PARAMETER Value
The value to set.

.PARAMETER Name
The name of the registry value.

.PARAMETER Type
The type of the registry value. Valid values are String, ExpandString, Binary, DWord, MultiString, QWord, and Unknown.

.PARAMETER Path
The path of the registry key.

.PARAMETER Force
If specified, creates the registry key if it doesn't exist.

.PARAMETER Passthru
If specified, returns the modified registry key.

.EXAMPLE
Set-ItemPropertyVerified -Value "1" -Name "TestValue" -Type "DWord" -Path "HKLM:\SOFTWARE\Test" -Force

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
				}
				
				if ($Force) {
					$params['Force'] = $true
				}
				Set-ItemProperty @params
				Get-Status
				$Variables.ModifiedRegistryKeys++
			} catch {
				Get-Status
				$Variables.FailedRegistryKeys++
				Get-Error $Error[0]
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
.DESCRIPTION
This function sets the state of Windows optional features. It can enable or disable the features based on the parameters passed.
.PARAMETER CustomMessage
A script block that can be used to provide a custom message for each feature being modified.
.PARAMETER Enabled
Enables the specified optional features.
.PARAMETER Disabled
Disables the specified optional features.
.PARAMETER OptionalFeatures
An array of optional feature names to enable or disable.
.EXAMPLE
Set-OptionalFeatureState -Enabled -OptionalFeatures "Microsoft-Windows-Subsystem-Linux"
This example enables the "Microsoft-Windows-Subsystem-Linux" optional feature.
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
				Write-Status "The $_ ($($feature.DisplayName)) will be skipped as set on Filter..." "@"
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
						$feature | Where-Object State -Like "Enabled" | Disable-WindowsOptionalFeature -Online -NoRestart -WhatIf:$WhatIf
						Get-Status
					} catch {
						Get-Error $Error[0]
						Continue
					}
				} elseif ($Enabled) {
					Write-Status $actionDescription "+" -NoNewLine
					try {
						$feature | Where-Object State -Like "Disabled*" | Enable-WindowsOptionalFeature -Online -NoRestart -WhatIf:$WhatIf
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

.DESCRIPTION
This function sets the state of one or more scheduled tasks. The state can be either disabled or ready.

.PARAMETER Disabled
If specified, the scheduled task(s) will be disabled.

.PARAMETER Ready
If specified, the scheduled task(s) will be set to ready.

.PARAMETER ScheduledTasks
An array of scheduled task paths to modify.

.PARAMETER Filter
An array of scheduled task names to skip.

.EXAMPLE
Set-ScheduledTaskState -Disabled -ScheduledTasks "C:\Windows\System32\Tasks\Task1", "C:\Windows\System32\Tasks\Task2"

This example disables the scheduled tasks "Task1" and "Task2".

.EXAMPLE
Set-ScheduledTaskState -Ready -ScheduledTasks "C:\Windows\System32\Tasks\Task1", "C:\Windows\System32\Tasks\Task2" -Filter "Task2"

This example sets the scheduled task "Task1" to ready, but skips "Task2".

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
						Write-Output "`n"
						Get-Status
						Get-Error $Error.Exception.Message
						Continue
					}
				}
			}
		}
	}
}
function Show-ScriptStatus {
<#
.SYNOPSIS
This script defines the Show-ScriptStatus function, which is used to display the status of the script.
.DESCRIPTION
The Show-ScriptStatus function is used to display the status of the script. It can be used to set the window title, tweak type, and display section and title text. It also has the ability to add a counter to the title text.
.PARAMETER AddCounter
Adds a counter to the title text.
.PARAMETER SectionText
The text to display for the section.
.PARAMETER TitleText
The text to display for the title.
.PARAMETER TitleCounterText
The text to display for the title counter.
.PARAMETER TweakType
The tweak type to set.
.PARAMETER WindowTitle
The window title to set.
.EXAMPLE
Show-ScriptStatus -AddCounter -SectionText "Section 1" -TitleText "Title" -TitleCounterText "Counter" -TweakType "Type" -WindowTitle "Window Title"
.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	param (
		[Switch]$AddCounter,
		[String]$SectionText,
		[String]$TitleText,
		[String]$TitleCounterText,
		[String]$TweakTypeText,
		[String]$WindowTitle
	)
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
function Show-Question {
<#
.SYNOPSIS
This script defines the Show-Question function which displays a message box with a specified message, title, buttons, and icon.

.DESCRIPTION
The Show-Question function is used to display a message box with a specified message, title, buttons, and icon. It also has an optional Chime parameter which, when specified, plays a chime sound before displaying the message box.

.PARAMETER Message
The message to display in the message box.

.PARAMETER Title
The title of the message box. Default value is "New Loads".

.PARAMETER Buttons
The buttons to display in the message box. Valid values are OK, OKCancel, YesNo, YesNoCancel, RetryCancel, and AbortRetryIgnore. Default value is OK.

.PARAMETER Icon
The icon to display in the message box. Valid values are None, Hand, Question, Exclamation, Asterisk, Stop, and Warning. Default value is Information.

.PARAMETER Chime
Specifies whether to play a chime sound before displaying the message box. Default value is $false.

.EXAMPLE
Show-Question -Message "Are you sure you want to delete this file?" -Title "Delete File" -Buttons YesNo -Icon Warning -Chime

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
	If ($Chime) {
		Start-Chime
	}
	$Box = [System.Windows.Forms.MessageBox]::Show($Message, $Title, $Buttons, $Icon)
	return $box
}


#endregion
#region Script Functions
function Get-ADWCleaner {
<#
.SYNOPSIS
This function downloads and runs Malwarebytes ADWCleaner to scan and clean adware from the system.

.DESCRIPTION
The function downloads Malwarebytes ADWCleaner from the specified link and runs it with the arguments "/EULA", "/PreInstalled", "/Clean", and "/NoReboot". It then removes traces of ADWCleaner by running it with the arguments "/Uninstall" and "/NoReboot".

.PARAMETER Undo
If this switch is specified, the function will skip running ADWCleaner.

.PARAMETER Skip
If this switch is specified, the function will skip downloading and running ADWCleaner.

.EXAMPLE
Get-ADWCleaner

This command downloads and runs ADWCleaner to scan and clean adware from the system.

.NOTES
Author: Circlol
Version: 1.0
Release Notes:
    1.0:
        - Started logging changes.
        - Added support for the -Undo and -Skip parameters.
        - Added support for shouldprocess.
#>
	[CmdletBinding(
				   SupportsShouldProcess
				   )]
	param (
		[Switch]$Undo,
		[Switch]$Skip
	)
	Show-ScriptStatus -TitleText "ADWCleaner" -TweakTypeText "Debloat"
	Add-LogSection -Section "ADWCleaner"
	If ($Skip -or $Undo) {
		Write-Status "Parameter -SkipADW or -Undo detected.. Malwarebytes ADWCleaner will be skipped.." '@' -WriteWarning -ForegroundColorText RED
	} else {
		if ($PSCmdlet.ShouldProcess("Download and Run ADWCleaner", "Downloading ADWCleaner $description")) {
			If (!(Test-Path $Variables.adwDestination)) {
				Write-Status "Downloading ADWCleaner" "+" -NoNewLine
				Start-BitsTransfer -Source $Variables.adwLink -Destination $Variables.adwDestination -Dynamic
				Get-Status
			}
			Write-Status "Starting ADWCleaner with ArgumentList /Scan & /Clean" "+"
			Start-Process -FilePath $Variables.adwDestination -ArgumentList "/EULA", "/PreInstalled", "/Clean", "/NoReboot" -Wait -NoNewWindow | Out-Host
			Write-Status "Removing traces of ADWCleaner" "-"
			Start-Process -FilePath $Variables.adwDestination -ArgumentList "/Uninstall", "/NoReboot" -WindowStyle Minimized
		}
	}
}
function Get-Program {
<#
.SYNOPSIS
This function installs various programs on the system.
.DESCRIPTION
This function installs various programs on the system, including Google Chrome, VLC Media Player, Zoom, Adobe Acrobat Reader, HEVC/H.265 Codec, and Outlook for Windows.
.PARAMETER Skip
Skips the program installation process.
.PARAMETER Undo
Undoes the program installation process.
.EXAMPLE
Get-Program
Installs the programs on the system.
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
		[switch]$Skip,
		[switch]$Undo
	)
	
	Show-ScriptStatus -WindowTitle "Apps" -TweakTypeText "Apps" -TitleCounterText "Programs" -TitleText "Application Installation" -AddCounter
	Add-LogSection -Section "Program Installation"
	# - Program Information
	$chrome = @{
		Name	  = "Google Chrome"
		Installed = Test-Path -Path "$Env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
		ChromeLink = "https://clients2.google.com/service/update2/crx"
		DownloadURL = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
		InstallerLocation = [System.IO.DirectoryInfo]::new("$NewLoads\googlechromestandaloneenterprise64.msi")
		FileExists = Test-Path -Path "$NewLoads\googlechromestandaloneenterprise64.msi"
		ArgumentList = "/passive"
	}
	$vlc = @{
		Name	  = "VLC Media Player"
		Installed = Test-Path -Path "$Env:ProgramFiles\VideoLAN\VLC\vlc.exe"
		#DownloadURL       = "https://get.videolan.org/vlc/3.0.18/win64/vlc-3.0.18-win64.exe"
		DownloadURL = "https://mirror.csclub.uwaterloo.ca/vlc/vlc/3.0.20/win64/vlc-3.0.20-win64.exe"
		InstallerLocation = [System.IO.DirectoryInfo]::new("$NewLoads\vlc-3.0.18-win64.exe")
		FileExists = Test-Path -Path "$NewLoads\vlc-3.0.18-win64.exe"
		ArgumentList = "/S /L=1033"
	}
	$zoom = @{
		Name	  = "Zoom"
		Installed = Test-Path -Path "$Env:ProgramFiles\Zoom\bin\Zoom.exe"
		DownloadURL = "https://zoom.us/client/5.16.2.22807/ZoomInstallerFull.msi?archType=x64"
		InstallerLocation = [System.IO.DirectoryInfo]::new("$NewLoads\ZoomInstallerFull.msi")
		FileExists = Test-Path -Path "$NewLoads\ZoomInstallerFull.msi"
		ArgumentList = "/quiet"
	}
	$acrobat = @{
		Name	  = "Adobe Acrobat Reader"
		Installed = Test-Path -Path "${Env:Programfiles(x86)}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
		DownloadURL = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2200120169/AcroRdrDC2200120169_en_US.exe"
		InstallerLocation = [System.IO.DirectoryInfo]::new("$NewLoads\AcroRdrDCx642200120085_MUI.exe")
		FileExists = Test-Path -Path "$NewLoads\AcroRdrDCx642200120085_MUI.exe"
		ArgumentList = "/sPB"
	}
	$HEVC = @{
		Name	  = "HEVC/H.265 Codec"
		Installed = Get-AppxPackage -Name "Microsoft.HEVCVideoExtension"
		#DownloadURL       = "https://github.com/circlol/newload/raw/main/assets/Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx"
		DownloadURL = "https://github.com/circlol/newload/raw/main/assets/Microsoft.HEVCVideoExtensions_2.0.61933.0_neutral_~_8wekyb3d8bbwe.AppxBundle"
		InstallerLocation = [System.IO.DirectoryInfo]::new("$NewLoads\Microsoft.HEVCVideoExtensions_2.0.61933.0_neutral_~_8wekyb3d8bbwe.AppxBundle")
		FileExists = Test-Path -Path "$NewLoads\Microsoft.HEVCVideoExtensions_2.0.61933.0_neutral_~_8wekyb3d8bbwe.AppxBundle"
	}
	$OutlookForWindows = @{
		Name	  = "Outlook for Windows"
		Installed = Get-AppxPackage -Name "Microsoft.OutlookForWindows"
		DownloadURL = "https://github.com/circlol/newload/raw/main/assets/Microsoft.OutlookForWindows_1.2023.920.0_x64__8wekyb3d8bbwe.Msix"
		InstallerLocation = [System.IO.DirectoryInfo]::new("$NewLoads\Microsoft.OutlookForWindows_1.2023.920.0_x64__8wekyb3d8bbwe.Msix")
		FileExists = Test-Path -Path "$NewLoads\Microsoft.OutlookForWindows_1.2023.920.0_x64__8wekyb3d8bbwe.Msix"
	}
	
	If ($Skip -or $Undo) {
		Write-Status "Parameter -SkipProgams and/or -Undo detected.. Ignoring this section." '@' -WriteWarning -ForegroundColorText RED
	} else {
		if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
			foreach ($program in $chrome, $vlc, $zoom, $acrobat, $hevc, $OutlookForWindows) {
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
							Start-BitsTransfer -Source $program.DownloadURL -Destination $program.InstallerLocation -TransferType Download -Dynamic -DisplayName "$TweakType" -Description "Downloading $($program.Name)"
							Get-Status
						} catch {
							Get-Status
							Get-Error $Error.Exception.Message
						}
					}
					
					Write-Status "Installing $($program.Name)" '+' -NoNewLine
					
					# Checks if the program is HEVC/H.265 Codec or Outlook for Windows
					If ($program.Name -eq $hevc.Name -or $program.Name -eq $OutlookForWindows.Name) {
						If ($program.Name -eq $hevc.Name) {
							try {
								Add-AppxPackage -Path $HEVC.InstallerLocation
								Get-Status
							} catch {
								Get-Status
								Get-Error $Error[0]
							}
						} elseif ($program.Name -eq $OutlookForWindows.Name) {
							try {
								Add-AppxPackage -Path $OutlookForWindows.InstallerLocation
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
					
					# Adds UBlock Origin to Chrome
					if ($program.Name -eq $Chrome.name) {
						Write-Status "Adding UBlock Origin to Chrome" '+'
						Set-ItemPropertyVerified -Path $Registry.PathToUblockChrome -Name "update_url" -value $Chrome.ChromeLink -Type STRING
						# TODO Create this - Set-ItemPropertyVerified -Path $Registry.PathToUblockEdge -Name "update_url" -value $Chrome.ChromeLink -Type STRING
					}
				} else {
					# Checks if installed if it is then skips the installation
					Write-Status "$($program.Name) already seems to be installed on this system.. Skipping Installation" "@"
					if ($program.Name -eq $Chrome.name) {
						Write-Status "Adding UBlock Origin to Chrome" "+"
						Set-ItemPropertyVerified -Path $Registry.PathToUblockChrome -Name "update_url" -value $Chrome.ChromeLink -Type STRING
					}
				}
			}
		}
	}
}
function New-SystemRestorePoint {
<#
.SYNOPSIS
Creates a new system restore point with a given description.

.DESCRIPTION
This function creates a new system restore point with a given description. It enables system restore on the system drive if it is not already enabled, and then creates a new restore point with the specified description.

.NOTES
Author: Circlol
Version: 1.0
Release Notes:
1.0:
    - Started logging changes.

#>
	[CmdletBinding(SupportsShouldProcess)]
	Param ()
	Show-ScriptStatus -WindowTitle "Restore Point" -TweakTypeText "Backup" -TitleCounterText "Creating Restore Point" -AddCounter
	Add-LogSection -Section "System Restore"
	$description = "Mother Computers Courtesy Restore Point"
	$restorePointType = "MODIFY_SETTINGS"
	if ($PSCmdlet.ShouldProcess("Create System Restore Point", "Creating a new restore point with description: $description")) {
		try {
			Set-Variable -Name TweakType $null
			Write-Status "Enabling System Restore" '+' -NoNewLine
			Enable-ComputerRestore -Drive "$env:SystemDrive\"
			Get-Status
			Write-Status "Creating System Restore Point: $description" '+'
			Checkpoint-Computer -Description $description -RestorePointType $restorePointType
			Get-Status
		} catch {
			Get-Status
			Get-Error $Error[0]
			Continue
		}
		Show-ScriptStatus -WindowTitle ""
	} else {
		Write-Output "Operation Canceled."
	}
}
function Remove-Office {
<#
.SYNOPSIS
Removes Microsoft Office from the system using Microsoft Support and Recovery Assistant (SaRA).

.DESCRIPTION
This function removes Microsoft Office from the system using Microsoft Support and Recovery Assistant (SaRA).
It downloads SaRA from the specified URL, expands it, and starts OfficeScrubScenario via SaRAcmd.exe to remove Office.
If the user chooses not to remove Office, the function skips the removal process.

.EXAMPLE
Remove-Office

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
					Start-BitsTransfer -Source $Variables.SaRAURL -Destination $Variables.SaRA -TransferType Download -Dynamic | Out-Host
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
function Remove-PinnedStartMenu {
<#
.SYNOPSIS
Removes pinned items from the Start menu by applying a new start menu layout and then deleting it.

.DESCRIPTION
This function removes pinned items from the Start menu by applying a new start menu layout and then deleting it. It does this by creating a new start menu layout file, assigning it to the start menu, and then restarting Explorer to load the new layout. After a few seconds, it opens the start menu and then disables the new layout, allowing the user to pin items again. Finally, it restarts Explorer and deletes the layout file.

.EXAMPLE
Remove-PinnedStartMenu

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
function Set-Branding {
<#
.SYNOPSIS
Sets the branding information for Mother Computers.

.DESCRIPTION
This function sets the branding information for Mother Computers, including the store name, phone number, hours of operation, URL, and model.

.PARAMETER Undo
If specified, undoes the branding changes made by this function.

.PARAMETER NoBranding
If specified, skips the branding changes and only logs a warning message.

.EXAMPLE
Set-Branding

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
		Show-ScriptStatus -WindowTitle "Branding" -TweakTypeText "Branding" -TitleText "Branding" -TitleCounterText "Mother Branding" -AddCounter
		Add-LogSection -Section "Mother's Branding"
		If (!$NoBranding) {
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
			Write-Status "Parameter -NoBranding detected.. Skipping Mother Computers branding" '@' -WriteWarning -ForegroundColorText RED
		}
	} else {
		Write-Host "$actionDescription operation canceled."
	}
}
function Set-ServiceStartup {
<#
.SYNOPSIS
Sets the startup type of one or more services.

.DESCRIPTION
The Set-ServiceStartup function sets the startup type of one or more services. It supports setting the startup type to Automatic, Boot, Disabled, Manual, and System. It also supports filtering services to skip and avoiding security vulnerabilities for certain services.

.PARAMETER State
Specifies the startup type to set. Valid values are Automatic, Boot, Disabled, Manual, and System.

.PARAMETER Services
Specifies the name of the service(s) to set the startup type for.

.PARAMETER Filter
Specifies an array of service names to skip.

.EXAMPLE
Set-ServiceStartup -State Automatic -Services "Service1", "Service2"

Sets the startup type of Service1 and Service2 to Automatic.

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
			If (!(Get-Service $Service)) {
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

.DESCRIPTION
This function applies a Start Menu Layout for Windows 10 and Windows 11. For Windows 10, it clears pinned start menu items and assigns the start layout. For Windows 11, it copies start menu binary files to the default and current user directories.

.EXAMPLE
Set-StartMenu

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Skip
	)
	
	
	
	Show-ScriptStatus -WindowTitle "Start Menu" -TweakTypeText "StartMenu" -TitleCounterText "Start Menu Layout" -TitleText "StartMenu" -AddCounter
	Add-LogSection -Section "Start Menu & Taskbar"
	if ($PSCmdlet.ShouldProcess("Set-StartMenu", "Applies a Start Menu Layout")) {
		If (!$Skip) {
			If ($Variables.osVersion -like "*Windows 10*") {
				Write-Section -Text "Clearing pinned start menu items for Windows 10"
				Write-Status "Clearing Windows 10 start pins" "@"
				$layoutFile = "C:\Windows\StartMenuLayout.xml"
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
				
				
				#Restart Explorer and delete the layout file
				Restart-Explorer
				
				# Uncomment the next line to make clean start menu default for all new users
				Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
				Remove-Item $layoutFile
			} elseif ($Variables.osVersion -like "*Windows 11*") {
				Write-Section -Text "Applying start menu layout for Windows 11"
				Write-Status "Attempting application" "+"
				$StartBinFiles = Get-ChildItem -Path "$newloads" -Filter "start*.bin" -file
				If (!(Test-Path -Path "$newloads\start.bin")) {
					Start-BitsTransfer -Source $Variables.StartBinURL -Destination $Newloads -Dynamic
				}
				If (!(Test-Path -Path "$newloads\start1.bin")) {
					Start-BitsTransfer -Source $Variables.StartBin2URL -Destination $Newloads -Dynamic
				}
				$StartBinFiles = Get-ChildItem -Path $newloads -Filter "start*.bin" -file
				$TotalBinFiles = ($StartBinFiles).Count * 2
				$progress = 0
				
				Foreach ($StartBinFile in $StartBinFiles) {
					$progress++
					Write-Status "Copying $($StartBinFile.Name) for new users ($progress/$TotalBinFiles)" "+" -NoNewLine
					xcopy $StartBinFile.FullName $Variables.StartBinDefault /y | Out-Null
					Get-Status
							   $progress++
					Write-Status "Copying $($StartBinFile.Name) to current user ($progress)/$TotalBinFiles)" "+" -NoNewLine
					xcopy $StartBinFile.FullName $Variables.StartBinCurrent /y | Out-Null
					Get-Status
				}
			}
		}
	}
}
function Set-Taskbar {
<#
.SYNOPSIS
Applies a taskbar layout.

.DESCRIPTION
This function applies a taskbar layout by writing the layout to a file and then restarting Windows Explorer.

.EXAMPLE
Set-Taskbar

Applies the taskbar layout.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Undo
	)
	if ($PSCmdlet.ShouldProcess("Set-Taskbar", "Applies a taskbar layout")) {
		If ($Undo) {
			Write-Output "Skipping Set-Taskbar"
		} else {
			Write-Status "Applying Taskbar Layout" '+' -NoNewLine
			If (Test-Path $Variables.layoutFile) {
				Remove-Item $Variables.layoutFile -Verbose | Out-Null
			}
			$StartMenu.StartLayout | Out-File $Variables.layoutFile -Encoding ASCII
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

.DESCRIPTION
This function sets the wallpaper of the system to a specified image and sets the system to use light mode. If the wallpaper file does not exist, it is downloaded from a specified URL. The function also sets the wallpaper style to 'Stretch' and updates the wallpaper.

.EXAMPLE
Set-Wallpaper

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Undo
	)
	Show-ScriptStatus -WindowTitle "Visual" -TweakTypeText "Visuals" -TitleCounterText "Visuals" -AddCounter
	Add-LogSection -Section "Wallpaper & Visuals"
	if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
		If ($Undo) {
			Start-Process "C:\Windows\Resources\Themes\aero.theme"
		} else {
			$WallpaperPathExists = Test-Path $Variables.wallpaperPath
			If (!$WallpaperPathExists) {
				$WallpaperURL = "https://raw.githubusercontent.com/circlol/newload/main/assets/mother.jpg"
				Write-Status "Downloading Wallpaper" "@" -NoNewLine
				Start-BitsTransfer -Source $WallpaperURL -Destination $Variables.wpDest -Dynamic
				Get-Status
			}
			Write-Status "Applying Wallpaper" "+"
			Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine
			Write-Host ": Wallpaper might not Apply UNTIL System is Rebooted`n"
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
function Send-EmailLog {
<#
.SYNOPSIS
Sends an email with the log files and system information.

.DESCRIPTION
This function sends an email with the log files and system information to the specified email address. The email includes information about the system, the script, the installed programs, and the PowerShell version.

.EXAMPLE
Send-EmailLog

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	
	$EndTime = Get-Date
	# - Formats current date to display as 04 November 2023 5:20:22 PM
	$CurrentDateFormatted = $StartTime.ToString("dddd MMMM dd, yyyy - h:mm:ss tt")
	# - Formats time to display as 5:20:22 PM
	$FormattedStartTime = $StartTime.ToString("h:mm:ss tt")
	$FormattedEndTime = $EndTime.ToString("h:mm:ss tt")
	# Formats Time Strings
	$StartTime = ($StartTime).ToString("yyyyMMdd")
	$EndTime = ($EndTime).ToString("yyyyMMdd")
	$ElapsedTime = $EndTime - $StartTime
	$FormattedElapsedTime = "{0:mm} minutes {0:ss} seconds" -f $ElapsedTime
	
	# Gathers Powershell Version
	$PowershellTable = $PSVersionTable | Out-String
	
	# - Gathers some information about installed programs
	$ListOfInstalledApplications = (Get-InstalledProgram -Name "*").Name | Sort-Object
	$ListOfInstalledApplications = $ListOfInstalledApplications -join "`n"
	$ListOfInstalledPackages = (Get-appxpackage -User $Env:USERNAME).Name | Sort-Object
	$ListOfInstalledPackages = $ListOfInstalledPackages -join "`n"
	
	# - System Information
	$SystemSpecs = Get-SystemInfo
	$IP = $(Resolve-DnsName -Name myip.opendns.com -Server 208.67.222.220).IPAddress
	$WallpaperApplied = if ($Variables.CurrentWallpaper -eq $Variables.wpDest) { "YES" } else { "NO" }
	
	# - Checks if all the programs got installed
	$Programs = @("Google Chrome", "VLC", "Zoom", "Acrobat", "HEVC")
	$ProgramStatus = @{
	}
	foreach ($program in $Programs) { $ProgramStatus[$program] = if (Get-InstalledProgram -Name $program) { "YES" } else { "NO" } }
	
	# - Joins log files to send as attachments
	$LogFiles = @()
	if (Test-Path -Path $Variables.log) { $LogFiles += $Variables.log }
	if (Test-Path -Path $Variables.errorlog) { $LogFiles += $Variables.errorlog }
	
	$Space = " " * 34
	
	# - Email Settings
	$smtp = 'smtp.shaw.ca'
	$To = '<newloads@shaw.ca>'
	$From = 'New Loads Log <newloadslogs@shaw.ca>'
	$Sub = "New Loads Log"
	$EmailBody = "
<####################################>
<#$space`##>
<#          NEW LOADS LOG           #>
<#$space`##>
<####################################>


$ip\$env:computername\$env:USERNAME

- System Information:

$SystemSpecs


- Script Information:

- Program Version: $($Variables.ProgramVersion)
- Date: $CurrentDateFormatted
- Start Time: $FormattedStartTime
- End Time: $FormattedEndTime
- Elapsed Time: $FormattedElapsedTime

- Summary:
- Applications Installed: $appsyns
- Chrome: $($ProgramStatus["Google Chrome"])
- VLC: $($ProgramStatus["VLC"])
- Adobe: $($ProgramStatus["Acrobat"])
- Zoom: $($ProgramStatus["Zoom"])
- HEVC: $($ProgramStatus["HEVC"])
- Packages Removed During Debloat: $($Variables.Removed)
- Wallpaper Applied: $WallpaperApplied
- Windows 11 Start Layout Applied: $StartMenuLayout
- Registry Keys Modified: $($Variables.ModifiedRegistryKeys)
- Failed Registry Keys: $($Variables.FailedRegistryKeys)


- Powershell Information:
$PowershellTable


- List of Packages Removed:
$($Variables.PackagesRemoved)


- List of Installed Win32 Applications:
$ListOfInstalledApplications


- List of Installed Appx Packages:
$ListOfInstalledPackages

"
	
	
	# - Sends the mail
	Send-MailMessage -From $From -To $To -Subject $Sub -Body $EmailBody -Attachments $LogFiles -DeliveryNotification OnSuccess, OnFailure -SmtpServer $smtp
}
function Start-Activation {
	Get-NetworkStatus
	Invoke-RestMethod $Variables.MAS | Invoke-Expression
}
function Start-BitlockerDecryption {
<#
.SYNOPSIS
Starts the decryption process for Bitlocker.

.DESCRIPTION
This function checks if Bitlocker is active on the host and starts the decryption process if it is. If Bitlocker is not enabled on the machine, it will display a message indicating so.

.PARAMETER Skip
If this switch is present, the function will skip the Bitlocker decryption process.

.EXAMPLE
Start-BitlockerDecryption

This example starts the decryption process for Bitlocker.

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Skip
	)
	Show-ScriptStatus -WindowTitle "Bitlocker" -TweakTypeText "Bitlocker" -TitleCounterText "Bitlocker Decryption" -AddCounter
	Add-LogSection -Section "Bitlocker Decryption"
	If ($Skip) {
		Write-Status "Parameter -Skip detected.. Skipping Bitlocker Decryption." '@' -WriteWarning -ForegroundColorText RED
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
				Write-Status $message '?'
				Add-Content -Path $Variables.Log -Value $message
			}
		}
	}
}
function Start-Bootup {
<#
.SYNOPSIS
This function checks the requirements for running the New Loads script and starts the bootup process.

.DESCRIPTION
This function checks the OS version, whether the script is run as admin, and the current time to ensure that the script can run properly. If any of these requirements are not met, the function will display an error message and close the script.

.EXAMPLE
Start-Bootup

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	param ()
	Show-ScriptStatus -WindowTitle "Checking Requirements"
	
	# Checks OS version to make sure Windows is atleast v20H2 otherwise it'll display a message and close
	If ($Variables.BuildNumber -lt $variables.minbuildnumber) {
		Write-Host $Errors.errorMessage1 -ForegroundColor Yellow
		Read-Host -Prompt "Press enter to close New Loads"
		Exit
	}
	
	
	Get-Administrator
	Show-ScriptLogo
	Update-Time
	
	New-Variable -Name "StartTime" -Value (Get-Date) -Scope Global -Force
	
	
	#New-Variable -Name Time -Value (Get-Date -UFormat %Y%m%d) -Scope Global
	If ($StartTime.ToString("yyMMdd") -GT $Variables.MaxTime -or $StartTime.ToString("yyMMdd") -LT $Variables.MinTime) {
		Clear-Host
		Write-Status "Please manually update the time before continuing.." @(":(", "::ERROR::")
		Read-Host -Prompt "Press enter to close New Loads ::: The Settings page for time will open so you can sync right away"
		Start-Process ms-settings:dateandtime
		Stop-Process $Pid
	}
	
	
	try {
		Import-Module Appx
		Import-Module BitsTransfer
		Import-Module ScheduledTasks
		Import-Module PrintManagement
		Import-Module DnsClient
		
	} catch {
		return "An error occured while importing modules: $_"
	}
	
	
	try {
		Get-Item $Variables.Log | Remove-Item
		
	} catch {
		return "An error occurred while removing the files: $_"
		Continue
	}
}
function Start-Chime {
<#
.SYNOPSIS
This function plays a sound file.
.DESCRIPTION
The Start-Chime function plays a sound file. The default sound file is Alarm06.wav located in C:\Windows\Media.
.EXAMPLE
Start-Chime
Start-Chime -File "C:\Windows\Media\Alarm01.wav"
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

.DESCRIPTION

.EXAMPLE

.NOTES
Author: Circlol
Version: 1.0
History:
    1.0:
        - Started logging changes.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Switch]$Skip,
		[String]$TweakType = "Cleanup",
		[Switch]$Undo
	)
	Show-ScriptStatus -WindowTitle "Cleanup" -TweakTypeText "Cleanup" -TitleCounterText "Cleanup" -TitleText "Cleanup" -AddCounter
	Add-LogSection -Section "Cleanup"
	If ($Undo -or $Skip) {
		Write-Status "Parameter -Undo or -Skip was detected.. Skipping this section." "@" -WriteWarning -ForegroundColorText Red
	} else {
		if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
			# - Starts Explorer if it isn't already running
			If (!(Get-Process -Name Explorer)) {
				Restart-Explorer
			}
			# Removes layout file if it exists
			Get-Item $Variables.layoutFile | Remove-Item
			# - Launches Chrome to initiate UBlock Origin
			Write-Status "Launching Google Chrome" "+"
			Start-Process Chrome -ArgumentList "chrome://extensions" -WarningAction SilentlyContinue
			
			# - Clears Temp Folder
			Write-Status "Cleaning Temp Folder" "-"
			Remove-Item "$NewLoads\*.*" -Force -Recurse -Exclude "New Loads"
			
			Write-Status "Looking for New Loads logs to remove"
			Remove-Item "$Env:USERPROFILE\Desktop\New Loads.txt"
			Get-Status
			Remove-Item "$Env:USERPROFILE\Desktop\New Loads Errors.txt"
			Get-Status
			Remove-Item "$Env:OneDrive\Desktop\New Loads.txt"
			Get-Status
			Remove-Item "$Env:OneDrive\Desktop\New Loads Errors.txt"
			Get-Status
			
			
			# - Removes installed program shortcuts from Public/User Desktop
			foreach ($shortcut in $Variables.shortcuts) {
				$ShortcutExist = Test-Path $shortcut
				If ($ShortcutExist) {
					Write-Status "Removing $shortcut" "-"
					Remove-Item -Path "$shortcut" -Force | Out-Null
					Get-Status
				}
			}
		}
	}
}
function Start-Debloat {
<#
.SYNOPSIS
This function is used to debloat Windows 10 by removing Win32 apps, Start Menu Ads, and UWP apps.

.DESCRIPTION
This function removes Win32 apps, Start Menu Ads, and UWP apps from Windows 10. It uses the Show-ScriptStatus and Add-LogSection functions to log changes and the Remove-InstalledProgram and Remove-UWPAppx functions to remove the apps. If the $Undo switch is specified, it reinstalls the default apps from the manifest.

.EXAMPLE
Start-Debloat

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
		[String]$TweakType = "UWP"
		
	)
	Show-ScriptStatus -WindowTitle "Debloat" -TweakTypeText "Debloat" -TitleCounterText "Debloat" -AddCounter
	Add-LogSection -Section "Debloat"
	
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
		$TotalItems = $Bloatware.List.Count
		$CurrentItem = 0
		$PercentComplete = 0
		ForEach ($Program in $Bloatware.List) {
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
		Write-Host "Debloat Completed!`n" -Foregroundcolor Green
		Write-Host "Packages Removed: " -NoNewline -ForegroundColor Gray
		Write-Host $Variables.Removed -ForegroundColor Green
		If ($Failed) {
			Write-Host "Failed: " -NoNewline -ForegroundColor Gray
			Write-Host $Variables.FailedPackages -ForegroundColor Red
		}
		Write-Host "Packages Scanned For: " -NoNewline -ForegroundColor Gray
		Write-Host "$($Variables.PackagesNotFound)`n" -ForegroundColor Yellow
	} elseif ($Undo) {
		if ($PSCmdlet.ShouldProcess("Default Apps", "Reinstall")) {
			Write-Status "Reinstalling Default Apps from manifest" "+"
			Get-AppxPackage -allusers | ForEach-Object {
				Add-AppxPackage -register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode
			} | Out-Host
		}
	}
}
function Start-Update {
<#
.SYNOPSIS
This function is used to update the system if the user accepts a prompt.

.DESCRIPTION
This function uses PSWindowsUpdate to update the system, once finished the function will remove itself

.EXAMPLE
Start-Update

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
	$lastUpdateCheckTime = Get-CheckForLastUpdate
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

.DESCRIPTION
This function updates the system time zone to the specified time zone and synchronizes the system time with the time server. If the time change is too big, it sets the time manually.

.PARAMETER TimeZoneId
Specifies the time zone to set. The default value is "Pacific Standard Time".

.EXAMPLE
Update-Time -TimeZoneId "Eastern Standard Time"
This example updates the system time zone to Eastern Time (US & Canada) and synchronizes the system time.

.NOTES
	Author: Circlol
	Version: 1.1
	Change Log: 
		- 1.0
			Created function.
		- 1.1
			Added manual time synchronization using external time server.
#>
	[CmdletBinding(SupportsShouldProcess)]
	param (
		[string]$TimeZoneId = "(UTC-08:00) Pacific Time (US & Canada)"
	)
	
	try {
		# Checks Time zone against specified
		$currentTimeZone = (Get-TimeZone).DisplayName
		If ($currentTimeZone -ne $TimeZoneId) {
			if ($PSCmdlet.ShouldProcess("Time zone change", "Setting time zone to $TimeZoneId")) {
				# Replaces if needed
				Write-Status "Current Time Zone: $currentTimeZone, Setting to $TimeZoneId" "+" $true
				Set-TimeZone -Id $TimeZoneId -ErrorAction Stop
				Get-Status
			}
		}
		
		# Synchronize Time
		$w32TimeService = Get-Service W32Time
		if ($w32TimeService.Status -ne "Running") {
			if ($PSCmdlet.ShouldProcess("W32Time Service", "Starting service")) {
				Write-Status "Starting W32Time Service" "@" $true
				Start-Service -Name W32Time
				Get-Status
			}
		}
		
		if ($PSCmdlet.ShouldProcess("Time synchronization", "Syncing time")) {
			Write-Status "Syncing Time"
			
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
					
					Write-Status "Time change is too big. Setting time manually." '+'
					
					# Get time from an external time server
					try {
						
						Get-NetworkStatus
						Write-Status "Getting time from worldtimeapi.org" "@" $true
						$timeUrl = "http://worldtimeapi.org/api/ip"
						$timeResponse = Invoke-RestMethod -Uri $timeUrl -Method Get
						Get-Status
						
						Write-Status "Converting Output to Local Time" "@" $True
						$localTime = [datetime]::Parse($timeResponse.datetime).ToLocalTime()
						Get-Status
						
						# Set the system time manually
						$timeString = $localTime.ToString("HH:mm:ss")
						$dateString = $localTime.ToString("yyyy-MM-dd")
						
						Write-Status "Setting date to $dateString"
						Set-Date -Date $dateString | Out-Null
						Get-Status
						
						Write-Status "Setting time to $localTime"
						Set-Date -Date $timeString | Out-Null
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
		
	} catch {
		Return "Error: $($_.Exception.Message)"
		Continue
	}
}


#endregion
#region depricated
function Update-Time.Old {
<#
.SYNOPSIS
Updates the time zone and synchronizes the system time.

.DESCRIPTION
This function updates the system time zone to the specified time zone and synchronizes the system time with the time server. If the time change is too big, it sets the time manually.

.PARAMETER TimeZoneId
Specifies the time zone to set. The default value is "(UTC-08:00) Pacific Time (US & Canada)".

.EXAMPLE
Update-Time -TimeZoneId "(UTC-05:00) Eastern Time (US & Canada)"
This example updates the system time zone to Eastern Time (US & Canada) and synchronizes the system time.
.NOTES
	Author: Circlol
	Version: 1.0
	Change Log: 
		- 1.0
			Created function.
#>
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


#endregion
#endregion


If (!$Undo -and !$WhatIfPreference) {
	Start-Bootup
	#Start-Update
	Get-Program # Task1
	Get-ActivationStatus
	Set-StartMenu # Task2
	Set-Taskbar
	Set-Wallpaper
	Set-Branding
	Start-Debloat # Task3
	#Get-AdwCleaner
	Get-Office
	Start-BitlockerDecryption
	Optimize-General
	Optimize-Performance
	Optimize-Privacy
	Optimize-Security
	Optimize-Service
	Optimize-SSD
	Optimize-TaskScheduler
	Optimize-WindowsOptional
	New-SystemRestorePoint
	Send-EmailLog
	Start-Cleanup
	Request-PCRestart
	
} else {
	Start-Bootup
	Get-Program -WhatIf:$WhatIfPreference -Skip:$Undo
	Set-StartMenu -WhatIf:$WhatIfPreference -Skip:$Undo
	Set-Taskbar -WhatIf:$WhatIfPreference -Undo:$Undo
	Set-Wallpaper -WhatIf:$WhatIfPreference -Undo:$Undo
	Set-Branding -WhatIf:$WhatIfPreference -Undo:$Undo
	Start-Debloat -WhatIf:$WhatIfPreference -Undo:$Undo
	#Get-AdwCleaner -WhatIf:$WhatIfPreference -Undo:$Undo
	Start-BitlockerDecryption -Skip:$Undo
	Optimize-General -WhatIf:$WhatIfPreference -Undo:$Undo
	Optimize-Performance -WhatIf:$WhatIfPreference -Undo:$Undo
	Optimize-SSD -WhatIf:$WhatIfPreference -Undo:$Undo
	Optimize-Privacy -WhatIf:$WhatIfPreference -Undo:$Undo
	Optimize-Security -WhatIf:$WhatIfPreference -Undo:$Undo
	Optimize-Service -WhatIf:$WhatIfPreference -Undo:$Undo
	Optimize-TaskScheduler -WhatIf:$WhatIfPreference -Undo:$Undo
	Optimize-WindowsOptional -WhatIf:$WhatIfPreference -Undo:$Undo
	Start-Cleanup -WhatIf:$WhatIfPreference -Undo:$Undo
	Send-EmailLog
	Request-PCRestart
}