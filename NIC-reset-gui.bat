@echo off
title NETWORK RESET SCRIPT
:prompt
color 1f
cls
echo NETWORK RESET SCRIPT
echo.
echo Type r to Reset Network
echo Type p to do a ping test
echo Type c to go to Command Prompt
echo Type q to exit
set /p answer=
if ‘%answer%’ == ‘r’ goto test
if ‘%answer%’ == ‘R’ goto test
if ‘%answer%’ == ‘C’ goto cmd
if ‘%answer%’ == ‘c’ goto cmd
if ‘%answer%’ == ‘q’ goto quit
if ‘%answer%’ == ‘Q’ goto quit
if ‘%answer%’ == ‘P’ goto ping
if ‘%answer%’ == ‘p’ goto ping
pause >nul

:test
cls
echo —————————————————-
echo – RELEASING IP…. –
echo —————————————————-
ipconfig /release >nul
echo.
echo Done!
echo.
echo —————————————————-
echo – RESETTING IP LOG… –
echo —————————————————-
@netsh int ip reset C:WindowsTEMPIPRESETLOG.txt >nul
echo.
echo Done!
echo.
echo —————————————————-
echo – FLUSHING ARP TABLES… –
echo —————————————————-
@arp -d >nul
echo.
echo Done!
echo.
echo —————————————————-
echo – FLUSHING DNS… –
echo —————————————————-
@ipconfig /flushdns >nul
echo.
echo Done!
echo.
echo —————————————————-
echo – RENEWING IP… –
echo —————————————————-
@ipconfig /renew >nul
echo.
echo Done!
echo.
cls
echo —————————————————-
echo Heres Your Status: –
echo —————————————————-
ipconfig /all
echo.
echo Press Any Key to Go To Menu
pause >nul
goto prompt

:ping
cls
echo —————————————————-
echo Starting Ping Test… –
echo —————————————————-
echo.
ping google.com
echo.
echo Press Any Key to goto MENU
pause >nul
goto prompt

:quit
cls
echo Thanks For Using The Network Reset Script
pause
exit

:cmd
@color 7
cls
cmd
@echo on

:: ____________________________________________________________________________________________

:: If those commands resolve the problem, you could put them in a batch file, e.g., reset.bat, 
::  and then schedule the batch file to run every 15 minutes with the schtasks command. E.g., 
::  supposing the file is named test.bat and that it is located in C:\users\jdoe, you could use
::  the following command:

:: 	schtasks /create /tn Reset_Wireless /tr c:\users\jdoe\reset.bat /sc minute /mo 15

:: The /create parameter creates a scheduled task, the /tn gives it a name, which you can use
::  to delete the task later, if needed, the /tr is used to specify the command to execute 
::  (include the full directory path), the /sc minute specifies that you wish to schedule the
::  task in increments of minutes, rather than hours, weekly, etc., and the /mo 15 is a modifier
::  value of 15, which because /sc minute was specified indicates the task will run every 15 
::  minutes. You can obtain further information on the use of the command by typing schtasks /? 
::  at a command prompt or by referring to the Microsoft TechNet article Schtasks.

:: If you wished to stop the task from running later, you could use:

:: 	schtasks /delete /tn Reset_Wireless. 

:: I.e., you would use the /tn parameter with the task name you used when you created the task.

:: _____________________________________!!!OR!!!_______________________________________________

:: Create a Windows Scheduled Task (taskschd.msc or Control Panel\System and 
:: Security\Administrative Tools\Task Scheduler) with a Trigger: begin the task At log on 
:: and in the Advanced settings delay task for 30 seconds. Then add an Action to Start a program
:: and select your .bat script.
:: ____________________________________________________________________________________________
