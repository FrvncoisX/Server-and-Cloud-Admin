#Write-Host " Do you want to retrive a list of accounts that experied in the last 24Hrs?"
$date = Get-Date
$date = $date.AddDays(6)
$begdate = Get-Date -date $date -Format "MMM d"
$dateadd = $date.adddays(31) -as [datetime]
$enddate = Get-Date -date $dateadd -Format "MMM d"
$piece="`n2"

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


Function delete-expacc
{}
function Show-Menu {
param (
[string]$Title = 'Expired Account Menu'
                )
Clear-Host
Write-Host "================ $Title ================"
                                    
Write-Host "1: Press '1' To Generate Accounts That Have Expired in the Past 24HRS."
Write-Host "2: Press '2' To Generate Accounts That will Be Expiring In The Next 31 Days."
Write-Host "3: Press '3' To Delete Expired Accounts."
 Write-Host "Q: Press 'Q' to quit."
                                }

do
{
 Show-Menu
$selection = Read-Host "Please make a selection"
switch ($selection)
{
'1' {
    get-expired
} '2' {
    get-expiring
} '3' {
    delete-expacc         
}

}
pause
}
until ($selection -eq 'q')