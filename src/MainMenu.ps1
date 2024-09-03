<####################

    New Loads
    Main Menu

####################>
Clear-Host


function Get-Administrator {
    # Define the command based on the presence of 'wt'
    $wtExists = Get-Command wt
    if ($wtExists) {
        $filePath = 'wt'
        $command = "new-tab powershell -c ""irm newloads.ca | iex"" "
    } else {
        $filePath = 'powershell'
        $command = "-command ""irm newloads.ca | iex"""
    }

    # Check if the user has administrative privileges
    If (!([bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544'))) {
        Write-Output "Requesting Administrative Privileges"
        Start-Process -FilePath $filePath -verb runas -ArgumentList $command
        exit
    }
}
function Start-Terminal {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [string]$link
    )

    # Define the command based on the presence of 'wt'
    $wtExists = Get-Command wt
    if ($wtExists) {
        $filePath = 'wt'
        $command = "new-tab powershell -c ""irm $($link) | iex"" "
    } else {
        $filePath = 'powershell'
        $command = "-command ""irm $($link) | iex"""
    }

    # Message describing the action
    $message = "Running '$filePath' with the following command: $command"

    if ($PSCmdlet.ShouldProcess($message)) {
        Write-Output $message
        Start-Process -FilePath $filePath -verb runas -ArgumentList $command
        $Global:CommandsRun += "$link`n"
        Show-MainMenu
    }
}
function Show-MainMenu {
    $width = [Console]::WindowWidth
    $border = "*" * $width
    $text1 = "                    1 - New Loads"
    $text2 = "                    2 - TechToolkit"
    $text3 = "                    3 - Tuneup"
    $text4 = "                    4 - DataXFer"
    $text5 = "                    5 - OSBackupRestore - Disabled"
    $text6 = "                    6 - MAS (Microsoft Activation Scripts)"
    $text7 = "                    7 - Windows Repair"
    $text8 = "                    8 - Windows Update (Through Terminal)"
    $text9 = "                    9 - Bitlocker Decryptor"
    $text10 = "                    10 - Program List Generator"
    $text11 = "                    11 - New Loads (Beta)"
    $text0 = "                    0 - Exit"

    If ($CommandsRun) { Write-Output "Commands run:`n$CommandsRun" }
    Write-Output "$border`n`n`n$text1`n$text2`n$text3`n$text4`n$text5`n$text6`n$text7`n$text8`n$text9`n$text10`n$text11`n`n`n$text0`n`n`n$border"

    do {
        $answer = Read-Host -Prompt "Select which tool to run"
        switch ($Answer) {
            1 { Start-Terminal "run.newloads.ca" }
            2 { Start-Terminal "ttk.newloads.ca" }
            3 { Start-Terminal "tuneup.newloads.ca" }
            4 { Start-Terminal "data.newloads.ca" }
            5 { Start-Terminal "backup.newloads.ca" }
            6 { Start-Terminal "mas.newloads.ca" }
            7 { Start-Terminal "repair.newloads.ca" }
            8 { Start-Terminal "update.newloads.ca" }
            9 { Start-Terminal "bitlocker.newloads.ca" }
            10 { Start-Terminal "gpl.newloads.ca" }
            11 { Start-Terminal "beta.newloads.ca" }
            WhatIf { If ($WhatIfPreference -eq $true ) {
                    $WhatIfPreference = $false
                    Write-Output 'Disabled WhatIfPreference'
                } else { 
                    $WhatIfPreference = $true 
                    Write-Output 'Enabled WhatIfPreference'
                }
            }
            0 { exit }
            default { Write-Output "Invalid input. Please enter a number listed above" }
        }
    } while ($true)
}

Get-Administrator
Show-MainMenu