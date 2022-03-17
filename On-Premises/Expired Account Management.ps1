<#Write-Host " Do you want to retrive a list of accounts that experied in the last 24Hrs?"
$date = Get-Date
$date = $date.AddDays(6)
$begdate = Get-Date -date $date -Format "MMM d"
$dateadd = $date.adddays(31) -as [datetime]
$enddate = Get-Date -date $dateadd -Format "MMM d"
$delacc = $expireds | Out-String
$users = $expireds#>
#
#
#
#
#This Script is a GUI to manage accounts that have expired


$Cred = Get-Credential -Credential adatum\Administrator


#Funtion for expired accounts
Function get-expired
{$expireds = Search-ADAccount -AccountExpired | where {$_.Enabled -eq $true} | 
Select Name, AccountExpirationdate,DistinguishedName,Enabled,@{Name='Manager';Expression={(Get-ADUser(Get-ADUser $_ -properties Manager).manager).Name}} | 
fl Name, AccountExpirationdate, Enabled, Manager

if ($expireds -eq $null){
    Write-Host "There are no currently expired accounts."
} else {
        write-host "The following accounts have been detected as expired yet still active"
        $expireds | Out-String
        }
     
    
}



#Function to get accounts that will expire
function get-expiring
{$expiring = Search-ADAccount -AccountExpiring -TimeSpan "31" | where {$_.Enabled -eq $true}| 
Select Name, AccountExpirationdate,DistinguishedName,Enabled,@{Name='Manager';Expression={(Get-ADUser(Get-ADUser $_ -properties Manager).manager).Name}} | 
fl Name, AccountExpirationdate, Enabled, Manager

    if ($expiring -eq $null){
Write-Host "There are no accounts set to expire in the next 30 days."
     } else {
write-host "The following accounts have been detected to expire in the next 30 Days"
                $expiring | Out-String


 } 
}

#funtion to disable expired accounts
Function disable-expacc
{
[cmdletBinding()]
Param()


Try{
$disacc = Search-ADAccount -AccountExpired| where {$_.Enabled -eq $true} | Disable-ADAccount -credential $cred -ErrorAction Stop

if ($disacc -eq $null){
    Write-Host "There are no currently aedounts to diable."
} else { 
        write-host "The following accounts have been disabled"
        $disacc | Out-String
     
    } 
     
}CATCH [System.Security.Authentication.AuthenticationException]
{Write-Host "Your credentials could not be validated for this operation, please check username and password!" -foreground Red
}
}









#Funtion for menue

function Show-Menu {
param (
[string]$Title = 'Expired Account Menu'
                )
Clear-Host 
$Cred
Write-Host "WELCOME TO THE EXPIRED ACCOUNTS MANAGEMENT"
Write-Host "Within this GUI you can generate a list of expired accounts"
Write-Host "accounts that have expired"
Write-Host "disable expired accounts and move them to a new OU"
Write-Host
Write-Host
Write-Host "================ $Title ================"
                                    
Write-Host "1: Press '1' To Generate Accounts That Have Expired."
Write-Host "2: Press '2' To Generate Accounts That will Be Expiring In The Next 31 Days."
Write-Host "3: Press '3' To Disable Expired Accounts."
Write-Host "Q: Press 'Q' to quit."
Write-Host "======================================================"                              
                              
}

do

{
 Show-Menu
$selectionx = Read-Host "Please make a selection"
switch ($selectionx)
{
'1' {get-expired} 
'2' {get-expiring} 
'3' {show-Menux 


}
}
pause
}
until ($selectionx -eq 'q')


 function show-Menux {
param (
[string]$Title2 = 'Disable Accounts'
)
clear-host
Write-Host "================ $Title2 ================"
Write-Host "1: Press '1' To Disable These Accounts."
write-Host "Q: Press '2' to quit"
Write-Host "======================================================"
 $selectionz= Read-Host "Please make a selection"
 switch ($selectionz)
  {
 '1' {disable-expacc}
 '2' {Show-Menu }
  
 } 
 }
 



   
