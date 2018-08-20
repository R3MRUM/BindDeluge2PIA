function Get-PIA-Port{
    $pia_log="C:\Program Files\pia_manager\log\pia_manager.log"
    $port_line=Select-String $pia_log -pattern "Forwarded port: "|select -last 1
    $port=$port_line.Line.Split(": ")[-1].Trim()
    return $port.replace("`0", "")
}

function Get-PIA-IP{
    $TAPInterface=Get-NetAdapter -InterfaceDescription "TAP-Windows Adapter*"| Select -ExpandProperty ifIndex
    $TAPIP=Get-NetIPAddress -InterfaceIndex $TAPInterface |Select -ExpandProperty IPAddress|Where {$_ -notlike "*:*"}
    return $TAPIP

}


if (!(Get-Process deluged -ErrorAction SilentlyContinue)){
    while(!(Get-Process deluged-debug -ErrorAction SilentlyContinue)){
        Start-Process "C:\Program Files (x86)\Deluge\deluged-debug.exe" -WindowStyle Hidden
    }
}

$PIA_IFACE = Get-PIA-IP
$PIA_PORT = Get-PIA-Port

Start-Process "C:\Program Files (x86)\Deluge\deluge-console.exe" -ArgumentList "config -s listen_ports ($PIA_PORT,$PIA_PORT)" -Wait -NoNewWindow
Start-Process "C:\Program Files (x86)\Deluge\deluge-console.exe" -ArgumentList "config -s listen_interface $PIA_IFACE" -Wait -NoNewWindow
