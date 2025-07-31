# This script enables Developer Command Prompt
# See https://github.com/microsoft/vswhere/wiki/Start-Developer-Command-Prompt#using-powershell

# Determine architecture from runner or environment
$arch = if ($env:RUNNER_ARCH -eq "ARM64") { "arm64" } else { "x64" }

# Set the appropriate component requirement based on architecture
$component = if ($arch -eq "arm64") { 
  "Microsoft.VisualStudio.Component.VC.Tools.ARM64" 
} else { 
  "Microsoft.VisualStudio.Component.VC.Tools.x86.x64" 
}

$installationPath = vswhere.exe -latest -requires $component -property installationPath
if ($installationPath -and (Test-Path "$installationPath\Common7\Tools\vsdevcmd.bat")) {
  & "${env:COMSPEC}" /s /c "`"$installationPath\Common7\Tools\vsdevcmd.bat`" -arch=$arch -no_logo && set" | ForEach-Object {
    $name, $value = $_ -split '=', 2
    "$name=$value" >> $env:GITHUB_ENV
  }
}
