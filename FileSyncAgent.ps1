$srvName = 'LABWDFS1'
$rgName = 'WEZDRG'
$fsName = 'wezdafsy'

Invoke-Command -ComputerName $srvName -ArgumentList ($rgName, $fsName) {
	param($rgName, $fsName)
	Install-PackageProvider -Name NuGet -Force; 
	Install-Module az.StorageSync -Force;
	Start-Process -FilePath "C:\StorageSyncAgent_WS2022.msi" -ArgumentList "/quiet" -Wait;
	Connect-AzAccount -UseDeviceAuthentication; 
	Register-AzStorageSyncServer -ResourceGroupName $rgName -StorageSyncServiceName $fsName | Out-Null;
	Write-Output "Script finished"
}