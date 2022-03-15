#Write-Host " Do you want to retrive a list of accounts that experied in the last 24Hrs?"
$date = Get-Date
$date = $date.AddDays(6)
$begdate = Get-Date -date $date -Format "MMM d"
$dateadd = $date.adddays(31) -as [datetime]
$enddate = Get-Date -date $dateadd -Format "MMM d"
$piece="`n2"








$Exp= Read-Host -prompt " 
`n1. Yes
`n2. NO
`nDo you want to retrive a list of accounts that experied in the last 24Hrs?"
switch ($Exp) {
    
    1{$expireds = Search-ADAccount -AccountExpired | where {$_.Enabled -eq $true} | 
        Select Name, AccountExpirationdate,DistinguishedName,Enabled,@{Name='Manager';Expression={(Get-ADUser(Get-ADUser $_ -properties Manager).manager).Name}} | 
        fl Name, AccountExpirationdate, Enabled, Manager

        if ($expireds -eq $null){
            Write-Host "There are no currently expired accounts."
        } else {
                write-host "The following accounts have been detected as expired yet still active"
                $expireds | Out-String
             
            }
           }
           

          
       
        
     2{$exp2= Read-Host -prompt " 
                    `n1. Yes
                    `n2. NO
                    `nDo you want to retrive a list of accounts that will expire in the next 30 days?"
                     switch ($exp2) {
                                1{
                                    $expiring = Search-ADAccount -AccountExpiring -TimeSpan "31" | where {$_.Enabled -eq $true}| 
                                    Select Name, AccountExpirationdate,DistinguishedName,Enabled,@{Name='Manager';Expression={(Get-ADUser(Get-ADUser $_ -properties Manager).manager).Name}} | 
                                    fl Name, AccountExpirationdate, Enabled, Manager

                                                if ($expiring -eq $null){
                                                             Write-Host "There are no accounts set to expire in the next 30 days."
                                                         } else {
                                                                write-host "The following accounts have been detected to expire in the next 30 Days"
                                                                    $expiring | Out-String


                                                                     } 
                                                                 }

                                                    }


                                        
                                        }
                        }
