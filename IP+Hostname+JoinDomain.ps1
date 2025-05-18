#Definicion de variables que van a ser populadas con lo que ingrese el usuario
$hostname= Read-Host "Ingrese el hostname del equipo" 
$ip= Read-host "IP"
$mascara= Read-Host "Mascara de Subred"
$gateway= Read-Host "Ingrese el Gateway"
$dns= Read-Host "DNS" 

#Obtenemos las propiedades del adaptadore de red
$NIC= Get-NetAdapter

#Obtenemos la propiedad Name del adaptador de red
$NICName= $NIC.Name

#Cambiamos el nombre de equipo con el hostname que esta almacenado en la variable $hostname
Rename-Computer -NewName $hostname -force

#Removemos la coifguracion ip que exista previamente
Remove-NetIPAddress -InterfaceAlias $NICName -AddressFamily IPv4 -Confirm:$false

#Removemos la configuracion del gateway que exista previamente
Remove-NetRoute -InterfaceAlias $NICName -Confirm:$false -ErrorAction SilentlyContinue

#Seteamos la direccion ip y gateway  nuevo con lo que esta almacenado en las variables
New-NetIPAddress -InterfaceAlias $NICName -IPAddress $ip -PrefixLength 24 -DefaultGateway $gateway

#Seteamos la direccion ip de servidor DNS con lo que esta almacenado en la variable $dns
Set-DnsClientServerAddress -InterfaceAlias $NICName -ServerAddresses $dns

#Preguntamos si desea unir el equipo a dominio
$opcion= Read-Host "Ingresar el equipo a dominio?: Y/N"

#Si es Y ejecuta la instruccion para unir el equipo a dominio
if ($opcion -eq "Y" ) {

Add-Computer -DomainName "test.local" -Credential (Get-Credential) -OUPath "OU=OU_Servidores,DC=test,DC=local" -Restart }

#Si el usuario ingresa N sale de la ejecion del script

else {

Exit
}







