#Script For New Active Directory User


#Tittle
Write-Host "New User Creator Mark 1.0"

#Import the active directory module
Import-Module ActiveDirectory

#Data
$firstname = Read-Host "First Name?"
$lastname = Read-Host "Last name?"
$username = "$firstname.$lastname"

#Acctual Command

New-aduser -name ("$firstname") -displayname ("$username") -Accountpassword (Read-Host -AsSecureString "AccountPassword") -Enabled $true