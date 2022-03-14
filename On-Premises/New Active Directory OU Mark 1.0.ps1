#Script For New Active Directory Orginizational Unit



#Tittle 
Write-Host "New OU Creator Mark 1.0"

#Import the active directory module
Import-Module ActiveDirectory

#Data 
$name = Read-Host "New OU Name?"
$dest = Read-Host "New OU Path"
$Y=$True
$N=$False
$sec=$true
$Protect= Read-Host -prompt " 
`n1. Yes
`n2. NO
`nDo you want to Protect this OU from accidental deletion?"
switch ($Protect) {
    1{Write-Host OU is protected from accidental deletion ; $sec=$Y } 
    2{Write-Host OU is not protected from accidental deletion ; $sec=$N }
}
 #Acctual Command
Get-Credential
New-ADOrganizationalUnit -Name "$name" -Path "$dest" -protectedfromaccidentaldeletion $sec