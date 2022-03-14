#Script for new Active Directory Groups


#Tittle 
Write-Host "New Group Creator Mark 1.0"

#Import the active directory module
Import-Module ActiveDirectory

#Data 
$name = Read-Host "New Group Name?"
#$SAN =  Read-Host "New SamAccountName?"
$S= "Security"
$D= "Distibution"
$Domain= "Domain"
$Global="Global"
$Universal="Universal"
$sectype=""
$ScopeType= ""

$GC = Read-Host -prompt " 
`n1. Distribution
`n2. Security
`nSelect a Group Catogory"
switch ($gc) {
    1{Write-Host GroupCategory Set to Distribution ; $sectype=$D } 
    2{Write-Host GroupCategory Set to Security ; $sectype=$s }
            
}

 $GS = Read-Host -prompt " 
 `n1. Domain
 `n2. Global
 `n3. Universal
 `nSelect a Group Scope"

 switch ($gs) {
 1{Write-Host GroupScope Set to Domain ; $ScopeType=$Domain }
 2{Write-Host GroupScope Set to Global; $ScopeType=$Global}
 3{Write-Host GroupScope Set to Universal ; $ScopeType = $Universal}
                            
                                
}

$DisplayName = Read-Host "Display Name?"
$P = Read-Host "Select Group Path" 

#Actual command
Get-Credential
New-ADGroup -Name("$name") -GroupCategory("$sectype") -GroupScope("$scopetype") -DisplayName("$DisplayName") -Path("$P") -Description "Members of this group are $displayname"
