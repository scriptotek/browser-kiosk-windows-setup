# Scriptoteket startup script for kiosk screens
# Author: Dan Michael
# Modified: 2019-07-01

# 1. Blank slate: Ensure Chrome is not running
Get-Process -Name chrome -ErrorAction SilentlyContinue | Stop-Process
Wait-Process -Name chrome -ErrorAction SilentlyContinue

# 2. Avoid Chrome restore dialog if Chrome did not exit cleanly
$chrome_prefs_file = Join-Path ${env:LOCALAPPDATA} "Google\Chrome\User Data\Default\Preferences"
$prefs = Get-Content $chrome_prefs_file -raw | ConvertFrom-Json
$prefs.profile.exit_type = "Normal"
$prefs.profile.exited_cleanly = $true
$prefs | ConvertTo-Json -depth 32 | set-content $chrome_prefs_file
      
# 3. Wait for network	  
Write-Host "Waiting for network..."
do {
  $ping = test-connection -comp uio.no -count 1 -Quiet
} until ($ping)

# 4. Start Chrome
$url = "http://ub-www01.uio.no/propaganda/kommende-disputaser/mn.html"
$chrome = Join-Path ${env:ProgramFiles(x86)} "Google\Chrome\Application\chrome.exe"
$chrome_args = "--kiosk --noerrdialogs --disable-infobars --disable-translate-new-ux $url"

Write-Host "Starting browser"
Start-Process $chrome $chrome_args

# Debug:
# write-host "Press any key to close"
# [void][System.Console]::ReadKey($true)



