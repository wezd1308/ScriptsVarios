# Nombre del servidor remoto
$server = "server"

# Intervalo de actualización en segundos
$interval = 5

# Número de procesos a mostrar (los que consumen más recursos)
$topProcesses = 5

while ($true) {
    # Limpiar la pantalla
    Clear-Host

    # Obtener los procesos ordenados por uso de CPU y Memoria en el servidor remoto
    $processes = Get-Process -ComputerName $server | Sort-Object -Property CPU -Descending | Select-Object -First $topProcesses

    # Mostrar los procesos que más CPU están consumiendo
    Write-Host "Procesos que más CPU están consumiendo en $server"
    $processes | Format-Table -Property Id, ProcessName, CPU, PM -AutoSize

    Write-Host ""
    
    # Obtener los procesos ordenados por uso de Memoria en el servidor remoto
    $processesMem = Get-Process -ComputerName $server | Sort-Object -Property PM -Descending | Select-Object -First $topProcesses

    # Mostrar los procesos que más Memoria están consumiendo
    Write-Host "Procesos que más Memoria están consumiendo en $server"
    $processesMem | Format-Table -Property Id, ProcessName, CPU, PM -AutoSize

    # Esperar el intervalo definido antes de la próxima actualización
    Start-Sleep -Seconds $interval
}
