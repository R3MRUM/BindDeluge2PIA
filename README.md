# DelugePIANetUpdate
A powershell script that updates the Deluge listen_interface and listen_ports to reflect Private Internet Access' TAP IP and ports that are forwarded.

I wrote this script because i needed to bind deluge to PIA while everything else went out on the dirty net. The problem is that every now and then, PIA would reset the connection which would result in a new TAP IP and new ports being forwarded.

  1. This script first checks to see if deluged-debug.exe is running. If it isnt, start it
  2. Then it parses pia_manager.log, looking for the most recent entry of 'forwarded_port:' for the port info.
  3. Then, using Get-NetAdapter and Get-NetIPAddress, it identifies the IP address of the TAP-Windows Adapter
  4. Then both the TAP IP and the Forwarded ports are set in deluge via deluge-console.exe

TODO - Document how to implement
