



![Logo](https://github.com/circlol/newload/raw/main/assets/icons/newloads-github.png)
New Loads started as a project to simplify the setup process of Windows. From debloating the operating system, services to tweaking personalization settings and installing common applications. It offers a simple script that can boost device security, anonymity and performance in a quick and convenient package.


Running New Loads is as simple as:

1) Open PowerShell as Administrator
2) Type in run command for version you want

<h5>Main Branch:</h5>
```powershell
irm run.newloads.ca | iex
```
or
```powershell
iwr -useb run.newloads.ca | iex
```

<h5>Beta Branch:</h5>
```powershell
irm beta.newloads.ca | iex
```
or
```powershell
iwr -useb beta.newloads.ca | iex
```

After a few minutes, your device will be set up and ready to go.


<h2>⚠️ Be Advised</h2>
1. New Loads is primarily used by Mother Computers. See related section for more info.
2. New Loads was not designed to account for an already lived in OS, it is meant to be run on a fresh operating system. Please note that you may experience unwanted changes

⚠️ **DISCLAIMER:** _You are using this software at your own risk, I am not responsible for any data loss. It's not guaranteed that every feature removed from the system can be easily restored._

# ![](https://raw.githubusercontent.com/circlol/newload/main/icon/curved-monitor_result%2064x64.png) **New Loads Overview**

- **Common Program Installation** (Chrome, VLC Media Player, Acrobat Acrobat Reader, Zoom)

- **Mother Computer's Specific Branding**

- **Custom Start Layout (Win11), Clear Start Menu pins (Win10) and Custom Taskbar Layout**

- **Debloat UWP Applications**

- **Microsoft Office Removal** - _by confirmation_

- **Optimization**

  - Explorer related
  - Performance related 
  - Privacy related
  - Security related
  - Services
  - Task Scheduler
  - Windows Optional Features 

- **Bitlocker Decryption**
- **System Restore Point 


<h2>Branches: </h2>

<div align="center">
  <table>
    <thead>
      <tr>
        <th style="text-align: center; vertical-align: middle;">Direct Download</th>
        <th style="text-align: center; vertical-align: middle;">Supported OS's</th>
        <th style="text-align: center; vertical-align: middle;">Edition(s)</th>
        <th style="text-align: center; vertical-align: middle;">Requirements</th>
      </tr>
    </thead>
    <tbody align="center">
      <tr>
        <td style="text-align: center; vertical-align: middle;">
            <h4><a href="https://github.com/circlol/newload/raw/main/exe/newloads.exe">⬇️ Main</a></h4>(Stable)
        </td>
        <td style="text-align: center; vertical-align: middle;" rowspan="2">Windows 10 and 11<br> 20H2 and Above</td>
        <td style="text-align: center; vertical-align: middle;" rowspan="2">Home / Pro / Edu / Ent / Server </td>
        <td style="text-align: center; vertical-align: middle;" rowspan="2">Admin<br>Powershell v5.1+<br></td>
      </tr>
      <tr>
        <td style="text-align: center; vertical-align: middle;">
            <h4><a href="https://github.com/circlol/newloadsTesting/raw/main/exe/newloads.exe">⬇️ Beta</a></h4>(Newer)
        </td>
      </tr>
    </tbody>
  </table>
</div>

<h2>Specific Mother Computers Tweaks</h2>

New Loads is run by a store called Mother Computers, you may find references to this, these are listed below

<h5>OEMInformation added:</h5>
This includes replacement of device Model, Manufacturer, Support Phone Number, Store Hours and Website URL. 

This information can be found in system settings under About your PC.

<h5>Desktop Wallpaper Changed:</h5>
Sets a vibrant Windows 11 style wallpaper used by the store.
Source:  [You Zhang](https://4kwallpapers.com/abstract/blue-abstract-17317.html)


<h2>☑️ In Depth Script Breakdown</h2>

<details>
  <summary>Click to Expand</summary>

- Start-Bootup checks requirements and sets execution policy
- All Variables are imported from function Import-Variables
- [Assets](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/exe/New%20Loads.ps1#L669) are acquired and imported
- [Get-Programs](https://github.com/circlol/newloadsTesting/blob/73f06a02cbc738639a279486f7dbbbc2c3e039ce/lib/scripts/Programs.psm1#L1) downloads [Google Chrome](https://www.google.com/chrome/), [VLC Media Player](https://www.videolan.org/), [Acrobat Reader](https://get.adobe.com/reader/), and [Zoom](https://zoom.us)
- ~~[^]: Use -SkipPrograms to skip installing these apps.~~
- [^]: Also installs [H.265 Codec from Device Manufacturer](https://apps.microsoft.com/detail/9pmmsr1cgpwg) and [UBlock Origin](https://ublockorigin.com/) into Chrome
- [Set-Visuals](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Visuals.psm1#L1) applies a wallpaper, sets to stretch and changes system to light mode
- [Set-Branding](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Branding.psm1#L1) sets Mother Computer's support info     _Seen in Settings -> About Your PC_
- [Set-StartMenu](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/StartMenu.psm1#L1) applies a taskbar layout then a  custom start menu layout in 11 and clears pinned tiles in 10. 
- List of [Debloat](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Debloat.psm1#L1) checks for common bloatware and attempts removal

- [Get-Office](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Office.psm1#L1) checks for any installed version of Office and prompts user for removal. Simple yes or no to remove all versions.

  [^]: Uses Microsoft [SaRACmd](https://aka.ms/SaRA_EnterpriseVersionFiles) to remove Office

- [General tweaks](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/GeneralTweaks.psm1#L1) does things like removes chat, Cortana from the taskbar, changes search into an icon, expands explorer ribbon, enables compact view, ect. General Tweaks

- [Performance tweaks](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Performance.psm1#L1) tweaks such as assuring game mode is enabled, sets hover time to 10ms for right click, games/multimedia usage set to 100%, enables hardware accelerated GPU scheduling, disables Edge startup boost.

- [Privacy tweaks](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Privacy.psm1#L2) disables a surprisingly large amount of tracking and telemetry, sets CloudFlare as default DNS provider, disables sending diagnostic data to Microsoft. 

- [Security tweaks](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Security.psm1#L2) applies various patches and exploit protections

- [Services](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Services.psm1#L1C10-L1C18) are optimized - listed below are all the services that are disabled

-  Changes to the [task scheduler](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/TaskScheduler.psm1#L2) are mostly tracking related but are also listed below

  - [Optional Features](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/OptionalFeatures.psm1#L1C10-L1C18) removes old legacy features

- Disables [Bitlocker](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/Start-BitLockerDecryption.psm1#L1C10-L1C18) on the system

- [Restore point](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/New-SystemRestorePoint.psm1#L1C10-L1C18) is created at the end
- Script [Cleanup](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Cleanup.psm1#L1C1-L1C1)

​	</details>

## Documentation

[Documentation](https://linktodocumentation)

<a href="https://www.flaticon.com/free-icons/monitor" title="monitor icons">Monitor icons created by Freepik - Flaticon</a>