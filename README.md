# BindDeluge2PIA
### Author: @R3MRUM

A powershell script that binds the Deluge listen_interface and listen_ports to  Private Internet Access' TAP IP and ports that are forwarded.

I wrote this script because i needed to bind deluge to PIA while everything else went out on the dirty net. The problem is that every now and then, PIA would reset the connection which would result in a new TAP IP and new ports being forwarded

  1. This script first checks to see if deluged-debug.exe is running. If it isnt, start it
  2. Then it parses pia_manager.log, looking for the most recent entry of 'Forwarded port:' for the port info.
  3. Then, using Get-NetAdapter and Get-NetIPAddress, it identifies the IP address of the TAP-Windows Adapter
  4. Then both the TAP IP and the Forwarded ports are set in deluge via deluge-console.exe

# Implementation
There are dozens of different ways that you can choose to implement this kind of script. Since Windows creates an Event every time it detects a successful network connection, I found that the best option was to trigger the script to run whenever the PIA connection would be reestablished. Below are the steps for accomplishing this (at least in Windows 10. Not sure of the exact steps in other Operating Systems):

  1. Open Task Scheduler (taskschd.msc)
  2. With "TaskSchedular (Local)" selected, click the Action menu item and then select "Create Basic Task". This will launch the "Create Basic Task Wizard"
  3. Provide a name and description of your choosing for this task. Click Next
  4. Set the trigger to "When a specific event is logged". Click Next
  5. Here is the information you need to provide for this section. After you populate this information, click Next:
      * Log: Microsoft-Windows-NetworkProfile/Operational
      * Source: NetworkProfile
      * Event ID: 10000
  6. For the Action, you want to select "Start a program". Click Next
  7. Here is the information you need to provide for this section. After you populate this information, click Next:
      * Program/script: powershell
      * Add arguments (optional): -ExecutionPolicy ByPass -file "PATH_TO_SCRIPT"
      
      ** Example: -ExecutionPolicy ByPass -file "C:\Scripts\BindDeluge2PIA.ps1"
      
  8. This step can be optional, but I like to provide a 30 second delay in execution so that PIA has enough time to fully set up its connection and port forwardning. Before you click Finish, check the "Open the Properties dialog for this task when I click Finish". Then click Finish
  9. In the Properties, select the Triggers tab and hten double click on your "On an event" trigger 
  10. Under the "Advanced settings" section, check the "Delay task for" checkbox and select the amount of time you want the script to delay execution for
  11. And you're done!

# References
* http://deluge-torrent.org/
* https://www.privateinternetaccess.com/
* https://www.groovypost.com/howto/automatically-run-script-on-internet-connect-network-connection-drop/
