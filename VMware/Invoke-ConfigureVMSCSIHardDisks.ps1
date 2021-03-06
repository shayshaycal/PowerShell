# vCenter server information
$vCenterServer = "server.contoso.com"

try {
    # Load PSSnapin for PowerCLI
    if(-not (Get-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue)) {
        Add-PSSnapin VMware.VimAutomation.Core -ErrorAction Stop
    }

    # Configure CLI Configuration
    Set-PowerCLIConfiguration -DefaultVIServerMode Single -InvalidCertificateAction Ignore -Confirm:$false -ErrorAction Stop

    # Connect to VI server
    Connect-VIServer -Server $vCenterServer -ErrorAction Stop

    # Remove existing harddrives
    $VirtualMachine = Get-VM -Name "Win7Ref" -ErrorAction Stop
    Get-HardDisk -VM $VirtualMachine -ErrorAction Stop | Remove-HardDisk -Confirm:$false -ErrorAction Stop

    # Create new harddrive
    $VirtualMachine | New-HardDisk -CapacityGB "60" -Confirm:$false -ErrorAction Stop

    # Disconnect from VI server
    Disconnect-VIServer -Server $vCenterServer -Confirm:$false -ErrorAction Stop
    
    # Return published data success status
    $Success = "True"
}
catch [System.Exception] {
    $Success = "False"
}