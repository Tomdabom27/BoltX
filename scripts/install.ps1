$Repo = "Tomdabom27/BoltX"
$Url = "https://github.com/$Repo/releases/download/Windows/boltx.exe"
$InstallDir = "$env:USERPROFILE\bin"

Write-Output "Downloading BoltX..."

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

Invoke-WebRequest $Url -OutFile "$InstallDir\boltx.exe"

# Add to PATH (user level)
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($oldPath -notlike "*$InstallDir*") {
  [Environment]::SetEnvironmentVariable("Path", "$oldPath;$InstallDir", "User")
}

Write-Output "BoltX installed!"
Write-Output "Restart terminal then run: boltx search hello"