<#Write-Host " Do you want to retrive a list of accounts that experied in the last 24Hrs?"
$date = Get-Date
$date = $date.AddDays(6)
$begdate = Get-Date -date $date -Format "MMM d"
$dateadd = $date.adddays(31) -as [datetime]
$enddate = Get-Date -date $dateadd -Format "MMM d"
$delacc = $expireds | Out-String
$users = $expireds#>

$Cred = Get-Credential -Credential adatum\Administrator
$moveToDis = "$target,DC=adatum,DC=com"


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

#Funtion to Move Disabled accounts to new OU
Function Move-Disacc 
{$target= read-host "Enter the Name of the OU to use to"}
{$move = Search-ADAccount -AccountDisabled -Usersonly | where {$_.distinguishedname -notlike '*OU=DisabledUsers*'} |
Select Name,Distinguishedname
if ($move -eq $null){
Write-Host "There are no accounts to move."
     }else
    {$move|foreach { 
 Move-ADObject -Identity $_.DistinguishedName -TargetPath $moveToDis
  }
write-host "The following accounts have been Moved "
$move | Out-String
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
'3' {show-Menux}
}
pause
}
until ($selectionx -eq 'q')


 function show-Menux {
param (
[string]$Title2 = 'Disable Accounts'
)
clear-host
Get-expired  
Write-Host "================ $Title2 ================"
Write-Host "1: Press '1' To Disable The Expired Accounts."
Write-Host "1: Press '2' To Move The Disabled Account."
Write-Host "1: Press '3' To Remove accounts from security group except Domain Users Group."
Write-Host "1: Press '5' To Disable User Accounts That Have Not Logon In the past 30 days."
write-Host "Q: Press 'Q' to quit"
Write-Host "======================================================"
 $selectionz= Read-Host "Please make a selection"
 switch ($selectionz)
  {
 '1' {disable-expacc}
 '2' {Move-Disacc}
 '3' {Remove-SecurityGroup}
 
 '4' {Show-Menu }
  
 } 
 }
 



   
