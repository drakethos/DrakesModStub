<#
.SYNOPSIS  Turns this template into a new mod.   .\New-Mod.ps1 -Name MyMod -Description "One sentence"
#>
param(
    [Parameter(Mandatory = $true)][ValidatePattern('^[A-Za-z][A-Za-z0-9]*$')][string]$Name,
    [string]$Description = 'Template mod. Replace this sentence.'
)
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$old = 'DrakesModStub'; $oldGuid = 'com.drakemods.modstub'; $oldProj = '7C0A4D52-3E19-4B6F-9A21-D8E5F10B3C47'
$newGuid = 'com.drakemods.' + $Name.ToLowerInvariant()
$newProj = [guid]::NewGuid().ToString().ToUpperInvariant()
$utf8 = New-Object System.Text.UTF8Encoding($false)

Get-ChildItem -Recurse -File | Where-Object {
    $_.FullName -notmatch '[\\/]\.git[\\/]' -and $_.Name -notin @('new-mod.sh', 'New-Mod.ps1') -and $_.Extension -notin @('.png', '.dll')
} | ForEach-Object {
    $text = [IO.File]::ReadAllText($_.FullName)
    if ($text.Contains($old) -or $text.Contains($oldGuid) -or $text.Contains($oldProj)) {
        $text = $text.Replace($oldProj, $newProj).Replace($oldGuid, $newGuid).Replace($old, $Name)
        [IO.File]::WriteAllText($_.FullName, $text, $utf8)
    }
}
$props = [IO.File]::ReadAllText("$PSScriptRoot\mod.package.props")
$props = [regex]::Replace($props, '<Description>.*</Description>', { param($m) "<Description>$Description</Description>" })
[IO.File]::WriteAllText("$PSScriptRoot\mod.package.props", $props, $utf8)

foreach ($f in "$old.cs", "${old}Config.cs", "$old.csproj", "$old.sln") {
    if (Test-Path $f) { Rename-Item $f ($f -replace $old, $Name) }
}
[IO.File]::WriteAllText("$PSScriptRoot\README.md", "# $Name`n`n$Description`n", $utf8)
[IO.File]::WriteAllText("$PSScriptRoot\CHANGELOG.md", "# Changelog`n`n## 0.1.0`n`nInitial version.`n", $utf8)
Remove-Item "$PSScriptRoot\new-mod.sh", "$PSScriptRoot\New-Mod.ps1" -Force
Write-Host "Created $Name ($newGuid). Edit mod.package.props, copy environment.props.example to environment.props, then build."
