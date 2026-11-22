<#
.SYNOPSIS  Turns on optional modules.   .\Add-Module.ps1 Ui,Forge,Compat,Input     (or: .\Add-Module.ps1 all)
#>
param([Parameter(Mandatory = $true, Position = 0)][string[]]$Name)
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$have = Get-ChildItem modules -Directory -ErrorAction SilentlyContinue | ForEach-Object Name
if ($Name -contains 'all') { $Name = $have }
foreach ($n in $Name) {
    if ($have -notcontains $n -and -not (Test-Path $n)) { throw "No module '$n' (have: $($have -join ', '))" }
    if (Test-Path $n) { Write-Host "$n already added"; continue }
    Move-Item "modules\$n" $n
    Write-Host "Added $n"
}
if ((Test-Path modules) -and -not (Get-ChildItem modules)) { Remove-Item modules }
