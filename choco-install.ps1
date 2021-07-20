# elevated check
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isElevated = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if(-not ($isElevated)) {
    exit
}
# install
$env:chocolateyProxyLocation = '$env:CL_PROXY_FULL_LOCAL'
.\install.ps1
.\ChocoInstall.ps1
# autocomplete
$path = "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
if (-not (Test-Path $path)) {
    echo > $path
}
choco install autocomplete
choco source disable -n=chocolatey
choco source add -n=cl-choco -s="$env:CL_REPO_ARTIFACT_CHOCO"
# proxies
choco config set proxy "$env:CL_PROXY_FULL_LOCAL"
choco config set proxyBypassOnLocal true
#
choco list --local-only
#
choco install -y choco-local.config
