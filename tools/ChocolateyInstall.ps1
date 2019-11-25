
$ErrorActionPreference = 'Stop';

$packageName= 'xmlspypro'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://cdn.sw.altova.com/v2019r3sp1/en/XMLSpyProf2019rel3sp1.exe'
$checksum   = 'CBCD3F14EC45E2656B8E56F2B5FCD45078533741288176E37A6536FA81D7F870'
$url64      = 'https://cdn.sw.altova.com/v2019r3sp1/en/XMLSpyProf2019rel3sp1_x64.exe'
$checksum64 = 'F271297C4AB2E90F9564F9BE04DCD5B0CB321BEA16BC651043F36FE583059C51'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64

  silentArgs    = "/qn /l*v `"$env:TEMP\$($packageName).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)

  softwareName  = 'xmlspy*'
  checksum      = $checksum
  checksumType  = 'sha256'
  checksum64    = $checksum64
  checksumType64= 'sha256'
}


# HACK: The XMLSpy installer fails when this key is already present.
$key = "MenuExt"
$path = "HKCU:\SOFTWARE\Microsoft\Internet Explorer\$key"
Rename-Item -Path $path  -NewName "$key BAK" -ea SilentlyContinue

Try {
	Install-ChocolateyPackage @packageArgs
}
Finally {
	# Restore the hack.
	Remove-Item -Path $path -Recurse -ea SilentlyContinue
	Rename-Item -Path "$path BAK"  -NewName $key -ea SilentlyContinue
}
