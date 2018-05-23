# Tools and tips for Win 10 Kiosk mode with browser
Various tools and tips to set up a Windows 10 pc with Chrome and Firefox in Kiosk mode.
This document contains:
1. Recipe on how to autologon
2. Scheduled task restarting computer at a certain hour every night
3. Prevent screen from going black and entering screen saver mode
4. Disable Edge Swipe and Pinch Zoom in Windows 10
5. Flags for Chrome and Firefox with batch-file example to start in Kiosk mode

## Recipe on how to autologon
Create local user and make appropriate changes in Regedit for autologin.

You will need to have one administrator user and one non-adminisitrator user for daily operation.
Here comes an instruction on how to make changes in Regedit to implement autologon with a non-administrator user:

1. Press the Windows key and type "regedit" (make sure you are doings this as an administrator and that you already have created a non-administrator user for the purpose of autologin, know the password of this user, and also know the computer name):
You will have to either change or create new entries depending on whether they already exist on the kiosk computer.
2. Go to `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System`.
Change `LocalAccountTokenFilterPolicy` (32-bit DWORD) to 1 (hex or dec is the same).
3. Go to `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon`
Set `AutoAdminLogon` (STRING) to 1.
4. Set `DefaultDomainName` (STRING) to computer name.
5. Set `AutoLogonCount` (32-bit DWORD) to a really high number, ie. 100000 (unfortunately, 0 is not infinity or disable in this case).
6. Set `DefaultUserName` (STRING) to the name of your non-administrator user.
7. Set `DefaultPassword` (STRING) to the password of your non-administrator user. 

## Scheduled task restarting computer at a certain hour every night
1.	Click on the Windows-icon and type `Task Scheduler`.
2.	In the right panel, click on `Create Basic Task`.
3.	Give it a name (like `Automatic restart every night`) and click Next.
4.	When asked `When do you want the task to start?`, select Daily. Click Next.
5.	Select some time in the night, like `05:00:00`
6.	Clicking Next will bring you to the Action page. Type `shutdown` on the Program/script space and `/r /f /t 0` in the Add arguments box (/r for `reboot`, /f for `force`, /t 0 for `now`). Alternatively, change /r to /s if you want to `shut down completely` and have BIOS boot up again.
7.  If you get the `Restore Sessions`-message when Chrome starts after reboot, you may need to add `taskkill` on a line before before the `shutdown` action and in the `Add arguments`-box fill in `/im CHROME.exe`, to make sure that Chrome is gently closed. 
8.	Click Next to review all and finally click Finish.

## Prevent screen from going black and entering screen saver mode
Prevent screen from going black:
1. Click on the Windows-icon on the start menu and type `Power Options`
2. Click on Change Plan Setting-link for Balanced and set both `Turn off the display` and `Put the computer to sleep` to `Never`.

Turn off screen saver:
1. Make sure you are logged in as administrator, and click on the Windows-icon on the start menu and type regedit
2. Go to `HKEY_USERS\.DEFAULT\Control Panel\Desktop`
3. Set `ScreenSaveActive` string value to 0 (you might need to create this entry if it doesn't exist). 
For `Windows 10 Pro`, go here to find a useful instruction: https://www.tenforums.com/tutorials/6567-enable-disable-lock-screen-windows-10-a.html#option2

## Disable Edge Swipe and Pinch Zoom in Windows 10
1. Disable Edge swipe i Windows 10: https://www.tenforums.com/tutorials/48507-enable-disable-edge-swipe-screen-windows-10-a.html
2- Disable Pinch Zoom option in Windows 10: https://answers.microsoft.com/en-us/windows/forum/windows_10-desktop-winpc/how-to-disable-pinch-zoom-option-in-windows-10/91124309-3177-4c7d-a52a-087f6e34772c
3. Disable right click in Windows 10: Open `Pen and Touch`, then go to `Press and Hold` and `Settings`, uncheck `Enable press and hold for right-clicking`. 
Right clicking can also be disabled in the web page by javascript:
`document.addEventListener('contextmenu', function(e) { e.preventDefault(); }, true);` 

## Flags for Chrome and Firefox with batch-file example to start in Kiosk mode

rem close chrome if already running
timeout /t 10
TASKKILL /F /IM CHROME.exe

rem wait for internet
timeout /t 60
start chrome --kiosk --noerrdialogs --disable-session-chrashed-bubble --disable-infobars --disable-translate http://www.link-to-your-app.com

