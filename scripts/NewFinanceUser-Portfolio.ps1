Import-Module ActiveDirectory

$FirstName = "Katherine"
$LastName = "Johnson"
$Username = "kjohnson"
$OU = "OU=Finance,OU=Departments,DC=nolancyber,DC=local"
$Group = "Finance Team"
$Password = ConvertTo-SecureString "<REPLACE_WITH_SECURE_PASSWORD>" -AsPlainText -Force

New-ADUser `
-Name "$FirstName $LastName" `
-GivenName $FirstName `
-Surname $LastName `
-SamAccountName $Username `
-UserPrincipalName "$Username@nolancyber.local" `
-AccountPassword $Password `
-Enabled $true `
-ChangePasswordAtLogon $false `
-Path $OU

Add-ADGroupMember -Identity $Group -Members $Username

Get-ADUser $Username -Properties MemberOf |
Select-Object Name, SamAccountName, Enabled, MemberOf
