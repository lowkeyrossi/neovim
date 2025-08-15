# This script enables Developer Command Prompt
# See https://github.com/microsoft/vswhere/wiki/Start-Developer-Command-Prompt#using-powershell

# Detect the architecture of the runner
$runnerArch = $env:RUNNER_ARCH
if (-not $runnerArch) {
  # Fallback to detecting processor architecture if RUNNER_ARCH is not set
  $processorArch = $env:PROCESSOR_ARCHITECTURE
  if ($processorArch -eq "ARM64") {
    $runnerArch = "ARM64"
  } else {
    $runnerArch = "X64"
  }
}

# Set the appropriate architecture for vsdevcmd
$vsArch = if ($runnerArch -eq "ARM64") { "arm64" } else { "x64" }

Write-Host "Detected runner architecture: $runnerArch"
Write-Host "Using Visual Studio architecture: $vsArch"

$installationPath = vswhere.exe -latest -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if ($installationPath -and (Test-Path "$installationPath\Common7\Tools\vsdevcmd.bat")) {
  & "${env:COMSPEC}" /s /c "`"$installationPath\Common7\Tools\vsdevcmd.bat`" -arch=$vsArch -no_logo && set" | ForEach-Object {
    $name, $value = $_ -split '=', 2
    "$name=$value" >> $env:GITHUB_ENV
  }
  Write-Host "Visual Studio Developer Command Prompt configured for $vsArch architecture"
} else {
  Write-Warning "Visual Studio installation not found or vsdevcmd.bat not available"
}
