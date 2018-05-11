# Tools and tips for Win 10 Kiosk mode with browser
Various tools and tips to set up a Windows 10 pc with Chrome and Firefox in Kiosk mode.
This document contains:
1. Recipe on how to autologon
2. Scheduled task restarting computer at a certain hour every night
3. Notes on how to disable screen saver and black screen
4. Disable Edge Swipe and Pinch Zoom in Windows 10
5. Flags for Chrome and Firefox with batch-file example to start in Kiosk mode

## Autologin
Create local user and make appropriate changes in Regedit for autologin

You will need to have one administrator user and one non-adminisitrator user for daily operation.
Here comes an instruction on how to make changes in Regedit to implement autologon with a non-administrator user:

1. Click on the Windows-icon on the start menu and type regedit (make sure you are doings this as an administrator and that you already have created a non-administrator user for the purpose of autologin, know the password of this user, and also know the computer name):
You will have to either change or create new entries depending on whether they already exist on the kiosk computer.
2. Go to HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System.
Change LocalAccountTokenFilterPolicy (32-bit DWORD) to 1 (hex or dec is the same).
3. Go to HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
Set AutoAdminLogon (STRING) to 1.
4. Set DefaultDomainName (STRING) to computer name.
5. Set AutoLogonCount (32-bit DWORD) to a really high number, ie. 100000 (unfortunately, 0 is not infinity or disable in this case).
6. Set DefaultUserName (STRING) to the name of your non-administrator user.
7. Set DefaultPassword (STRING) to the password of your non-administrator user. 

## Prevent screen from going black and entering screen saver mode
Turn off screen saver:
1. Make sure you are logged in as administrator, and click on the Windows-icon on the start menu and type regedit
2. Go to HKEY_USERS\.DEFAULT\Control Panel\Desktop
3. Set ScreenSaveActive string value to 0 (you might need to create this entry if it doesn't exist).
