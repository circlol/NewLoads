<####################

    New Loads
    Main Menu

####################>

function Start-Terminal {
    param (
        [string]$link
    )

	# Checks to make sure New Loads is run as admin otherwise it'll display a message and close
	If (!([bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544'))) {
        $wtExists = Get-Command wt
        If ($wtExists) {
            $command = "new-tab powershell -c ""irm $($link) | iex"" "
            Start-Process wt -verb runas -ArgumentList $command
        } else {
            $command = "-command ""irm $($link) | iex"""
            Start-Process powershell -verb runas -ArgumentList $command
        }
        Show-MainMenu
	}
}




function Show-MainMenu {
    $width = [Console]::WindowWidth
    $border = "*" * $width
    $text1 = "                    1 - New Loads"
    $text2 = "                    2 - New Loads (Beta)"
    $text3 = "                    3 - DataXFer"
    $text4 = "                    4 - OSBackupRestore"
    $text5 = "                    5 - MAS (Microsoft Activation Scripts)"
    $text6 = "                    6 - Windows Repair"
    $text7 = "                    7 - TechToolkit"
    $text8 = "                    8 - Windows Update (Through Terminal)"
    $text9 = "                    9 - Bitlocker Decryptor"
   $text10 = "                    10 - Program List Generator"
   $text11 = "                    11 - Tuneup"
    $text0 = "                    0 - Exit"

    Write-Output "$border`n`n`n$text1`n$text2`n$text3`n$text4`n$text5`n$text6`n$text7`n$text8`n$text9`n$text10`n$text11`n`n`n$text0`n`n`n$border"

    do {
        $answer = Read-Host -Prompt "Select which tool to run"
        switch ($Answer) {
            1 {
                Start-Terminal "run.newloads.ca"
            }
            2 {
                Start-Terminal "beta.newloads.ca"
            }
            3 {
                Start-Terminal "data.newloads.ca"
            }
            4 {
                Start-Terminal "backup.newloads.ca"
            }
            5 {
                Start-Terminal "mas.newloads.ca"
            }
            6 {
                Start-Terminal "repair.newloads.ca"
            }
            7 {
                Start-Terminal "ttk.newloads.ca"
            }
            8 {
                Start-Terminal "update.newloads.ca"
            }
            9 {
                Start-Terminal "bitlocker.newloads.ca"
            }
            10 {
                Start-Terminal "gpl.newloads.ca"
            }
            11 {
                Start-Terminal "tuneup.newloads.ca"
            }
            0 {
                exit
            }
            default {
                Write-Output "Invalid input. Please enter a number listed above"
            }
        }
    } while ($true)
}


Show-MainMenu