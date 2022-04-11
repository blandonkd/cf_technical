#Requires -Version 3
<#
.DESCRIPTION
  This script is intended to create and configure a GPO for policy setting which prohibits users from connecting to a computer from across the network, which would allow users to access and potentially modify data remotely.
  Additionally, this will also configure the policy setting that sets the Attack Surface Reduction rules.
.PARAMETER GPOName
    The name that will be used for the GPO. This is up to the engineer deploying this script.
.PARAMETER Domain
    The full name of the domain that the GPO will be created in. 
.PARAMETER OU
    The OU to apply the GPO to. 
 
.NOTES
  Version:        1.0
  Author:         Keifer Blandon
  
.EXAMPLE
  PS> .\createGPO1.ps1 -GPOName "Vuln Remediation" -Domain "clientapp.com" -OU "OU=Computers,DC=ClientApp,DC=Com"
#>

#--------[Params]---------------
Param(
  [parameter(Mandatory=$True,Valuefrompipelinebypropertyname)] 
  [String]
  $GPOname,
  [parameter(Mandatory=$True,Valuefrompipelinebypropertyname)] 
  [String]
  $Domain,
  [parameter(Mandatory=$True,Valuefrompipelinebypropertyname)] 
  [String]
  $OU
)

#--------[Script]---------------

$gpo = New-GPO -Name $GPOname -Domain $Domain | New-gplink -target $OU
$gpoDispName = Get-GPO $gpo.displayName

Set-GPPrefRegistryValue -Name $gpoDispName -Context User -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\" -ValueName "Rules:26190899-1602-49e8-8b27-eb1d0a1ce869" -Value "1" -Type String -Action Update
Set-GPPrefRegistryValue -Name $gpoDispName -Context User -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\" -ValueName "Rules:3b576869-a4ec-4529-8536-b80a7769e899" -Value "1" -Type String -Action Update
Set-GPPrefRegistryValue -Name $gpoDispName -Context User -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\" -ValueName "Rules:5beb7efe-fd9a-4556-801d-275e5ffc04cc" -Value "1" -Type String -Action Update
Set-GPPrefRegistryValue -Name $gpoDispName -Context User -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\" -ValueName "Rules:75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84" -Value "1" -Type String -Action Update
Set-GPPrefRegistryValue -Name $gpoDispName -Context User -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\" -ValueName "Rules:7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c" -Value "1" -Type String -Action Update
Set-GPPrefRegistryValue -Name $gpoDispName -Context User -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\" -ValueName "Rules:92e97fa1-2edf-4476-bdd6-9dd0b4dddc7b" -Value "1" -Type String -Action Update
Set-GPPrefRegistryValue -Name $gpoDispName -Context User -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\" -ValueName "Rules:9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2" -Value "1" -Type String -Action Update
Set-GPPrefRegistryValue -Name $gpoDispName -Context User -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\" -ValueName "Rules:b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4" -Value "1" -Type String -Action Update
Set-GPPrefRegistryValue -Name $gpoDispName -Context User -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\" -ValueName "Rules:be9ba2d9-53ea-4cdc-84e5-9b1eeee46550" -Value "1" -Type String -Action Update
Set-GPPrefRegistryValue -Name $gpoDispName -Context User -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\" -ValueName "Rules:d3e037e1-3eb8-44c8-a917-57927947596d" -Value "1" -Type String -Action Update
Set-GPPrefRegistryValue -Name $gpoDispName -Context User -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\" -ValueName "Rules:d4f940ab-401b-4efc-aadc-ad5f3c50688a" -Value "1" -Type String -Action Update
Set-GPPrefRegistryValue -Name $gpoDispName -Context User -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\" -ValueName "Rules:e6db77e5-3df2-4cf1-b95a-636979351e5b" -Value "1" -Type String -Action Update

gpupdate /force
