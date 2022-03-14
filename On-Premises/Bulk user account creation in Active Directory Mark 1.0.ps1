#Script for bulk user accounts in Active Directory
Import-Module ActiveDirectory

#Tittle
Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::YesNoCancel
$MessageIcon = [System.Windows.MessageBoxImage]::Error
$MessageBody = "Youre about to lunch bulk creation of User accounts in Active Directory.Ensure you have the location of your CSV file, the delimiter your using, and correct credentials to perform this task?"
$MessageTitle = "Confirm Bulk creation"
$Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
Write-Host "Your choice is $Result"


 
            
#Data
Get-Credential
$dest = read-Host "Insert Path to CSV File"
$del = read-Host "Input File Delimiter"
$Users = Import-Csv -Delimiter ("$del") -Path $dest            
foreach ($User in $Users)            
{            
    $Displayname = $User.FirstName + " " + $User.Lastname            
    $UserFirstname = $User.Firstname            
    $UserLastname = $User.Lastname            
    $OU = $User.OU           
    $SAM = $User.SAM            
    $UPN = $User.Firstname + $User.Lastname + "@" + $User.MailDomain            
    $Description = $User.Description            
    $Password = $User.Password       
 
 } if (Get-ADUser -F { UserPrincipalName -eq $UPN }) {
         
  # If user does exist, give a warning
  Write-Warning "A user account with username $DisplayName already exists in Active Directory."
}else 
{
  # User does not exist then proceed to create the new user account
  # Account will be created in the OU provided by the $OU variable read from the CSV file
   New-ADUser -Name $Displayname -DisplayName $Displayname -SamAccountName $SAM -UserPrincipalName $UPN -GivenName $UserFirstname -Surname $UserLastname -Description $Description -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -Path "$OU" -ChangePasswordAtLogon $false –PasswordNeverExpires $true
    Write-Host $Displayname "created successfully"
    }
