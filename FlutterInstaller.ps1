try {
  choco upgrade chocolatey -y
} catch [System.Management.Automation.CommandNotFoundException] {
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} finally {
  choco upgrade git -y
  choco upgrade fvm -y
  Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
  refreshenv
  fvm install stable
  $UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
  $PathWithoutDartSDK = $UserPath.Replace("$Env:HOMEDRIVE\tools\dart-sdk\bin;","")
  $FlutterPath = "$Env:HOMEDRIVE$Env:HOMEPATH\fvm\versions\stable\bin"
  [Environment]::SetEnvironmentVariable('Path', "$PathWithoutDartSDK$FlutterPath;", 'User')
  refreshenv
  flutter doctor
}