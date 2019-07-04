# Scriptoteket reboot script for kiosk screens
# Exits Powerpoint and Chrome gracefully before rebooting.
# Author: Dan Michael
# Modified: 2019-07-04

# ------------------------------------------------------------------------------------


# The following method works gracefully even if document recovery is visible
Try {
	$app = [System.Runtime.InteropServices.Marshal]::GetActiveObject("Powerpoint.Application")
	Write-Host "Trying to close Powerpoint gracefully..."
	$app.DisplayAlerts = $false
	$app.Quit()
	Wait-Process -Name POWERPNT -ErrorAction SilentlyContinue -Timeout 4
	Start-Sleep -Seconds 1
} Catch {}

$apps = @("POWERPNT", "chrome")
foreach ($app in $apps) {

	# Is it running?
	$appRunning = Get-Process $app -ErrorAction SilentlyContinue
	
	if ($appRunning) {

		# Try closing it gracefully first.
		$appRunning | Foreach-Object {
			Write-Host "Trying to close $app (process $($_.Id)) gracefully..."
			$_.CloseMainWindow() | Out-Null
		}
		Wait-Process -Name $app -ErrorAction SilentlyContinue -Timeout 4
		Start-Sleep -Seconds 1

		# If still running, kill it.
		Get-Process $app -ErrorAction SilentlyContinue | Foreach-Object {
			Write-Host "Sending stop signal to process $($_.Id)"
			Stop-Process $_ -Force | Out-Null
		}
		Wait-Process -Name $app -ErrorAction SilentlyContinue -Timeout 4
		Start-Sleep -Seconds 1
	}
}

Write-Host "Restarting computer"
Start-Sleep -Seconds 10

Restart-Computer -Force
