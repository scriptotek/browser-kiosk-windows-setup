# Tools and tips for Win 10 Kiosk mode with browser
Various tools and tips to set up a Windows 10 pc with Chrome and Firefox in Kiosk mode.
This document contains:

1. Setup automatic login
2. Setup nightly reboots
3. Prevent the screen from going black or enter screen saver
4. Disable lock screen
5. Disable Edge Swipe and Pinch Zoom
6. Prepare Chrome startup script
7. Prepare Firefox startup script


## Setup automatic login

You will need to have two (preferably local) users: one administrator (for setting things up) and one non-administrator (for auto-login). Once you have this, do the following:

1. As administrator, press the Windows key and type "regedit" and Enter.
You will have to either change or create new entries depending on whether they already exist or not.
2. Under `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System`:
    1. Change `LocalAccountTokenFilterPolicy` (32-bit DWORD) to 1 (hex or dec is the same).
3. Under `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon`:
    1. Set `AutoAdminLogon` (STRING) to 1.
    2. Set `DefaultDomainName` (STRING) to the computer name.
    3. Set `DefaultUserName` (STRING) to the name of your non-administrator user.
    4. Set `DefaultPassword` (STRING) to the password of your non-administrator user. 
    5. Delete `AutoLogonCount` if it exists.

## Setup nightly reboots

It can be a good idea to do a reboot every night (or every week if you like), to ensure updates are run and so on.
To schedule this, do the following:

1.	As administrator, press the Windows key and type `Task Scheduler` and Enter.
2.	In the right panel, click on `Create Basic Task`.
3.	Give it a name (like `Automatic restart every night`) and click Next.
4.	When asked `When do you want the task to start?`, select Daily. Click Next.
5.	Select some time in the night, like `05:00:00`
6.	Clicking Next will bring you to the Action page. Type `shutdown` on the Program/script space and `/r /f /t 0` in the Add arguments box (/r for `reboot`, /f for `force`, /t 0 for `now`). Alternatively, change /r to /s if you want to `shut down completely` and have BIOS boot up again.
7.  If you get the `Restore Sessions`-message when Chrome starts after reboot, you may need to add `taskkill` on a line before before the `shutdown` action and in the `Add arguments`-box fill in `/im CHROME.exe`, to make sure that Chrome is gently closed. 
8.	Click Next to review all and finally click Finish.

## Prevent the screen from going black or enter screen saver

Prevent screen from going black:
1. Click on the Windows-icon on the start menu and type `Power Options`
2. Click on Change Plan Setting-link for Balanced and set both `Turn off the display` and `Put the computer to sleep` to `Never`.

Turn off screen saver:
1. Make sure you are logged in as administrator, and click on the Windows-icon on the start menu and type regedit
2. Go to `HKEY_USERS\.DEFAULT\Control Panel\Desktop`
3. Set `ScreenSaveActive` string value to 0 (you might need to create this entry if it doesn't exist). 
For `Windows 10 Pro`, go here to find a useful instruction: https://www.tenforums.com/tutorials/6567-enable-disable-lock-screen-windows-10-a.html#option2

## Disable lock screen

There are different tips on how to disable the lock screen. None of these worked for us, since it's enforced by policy (the central IT administration has promised us a different policy for kiosk screens, but it hasn't materialized yet), so we have to do the "powerpoint trick"... Yes, the computer will not lock while a presentation is running, so we start a Powerpoint presentation before starting Chrome.

## Disable Edge Swipe and Pinch Zoom

For touch screens:

1. Disable Edge swipe i Windows 10: https://www.tenforums.com/tutorials/48507-enable-disable-edge-swipe-screen-windows-10-a.html
2- Disable Pinch Zoom option in Windows 10: https://answers.microsoft.com/en-us/windows/forum/windows_10-desktop-winpc/how-to-disable-pinch-zoom-option-in-windows-10/91124309-3177-4c7d-a52a-087f6e34772c
3. Disable right click in Windows 10: Open `Pen and Touch`, then go to `Press and Hold` and `Settings`, uncheck `Enable press and hold for right-clicking`. 
Right clicking can also be disabled in the web page by javascript:
`document.addEventListener('contextmenu', function(e) { e.preventDefault(); }, true);` 

## Prepare Chrome startup script

See [start-chrome-kiosk.ps1](https://github.com/scriptotek/browser-kiosk-windows-setup/blob/master/start-chrome-kiosk.ps1) for an example startup script for Chrome.

The most important flag is the `--kiosk` flag, but there's also some more that are useful. Unfortunately, the flags tend to change from version to version without much notice, so alway scheck with the updated list of working flags here: https://peter.sh/experiments/chromium-command-line-switches/

Useful flags:

- `--kiosk` : Enable kiosk mode (fullscreen with no menus)
- `--noerrdialogs`: Prevent error dialogs.
- `--disable-infobars`: Prevent the yellow information bars.

There used to be a flag called `--disable-session-crashed-bubble` for [disabling the restore dialog](https://superuser.com/questions/461035/disable-google-chrome-session-restore-functionality) that is shown if Chrome did not exit cleanly. After the flag was removed, the only way to avoid the restore dialog seems to be to manually alter the Preferences file (or lock it).
In the [start-chrome-kiosk.ps1](https://github.com/scriptotek/browser-kiosk-windows-setup/blob/master/start-chrome-kiosk.ps1) script, we are manually altering the file.



## Prepare Firefox startup script

Todo

