Import-Module ActiveDirectory

$Password = ConvertTo-SecureString "<REPLACE_WITH_SECURE_PASSWORD>" -AsPlainText -Force
$Users = Import-Csv ".\NewEmployees.csv"

foreach ($User in $Users) {

    switch ($User.Department) {
        "Finance" {
            $OU = "OU=Finance,OU=Departments,DC=nolancyber,DC=local"
            $Group = "Finance Team"
        }
        "Human Resources" {
            $OU = "OU=Human Resources,OU=Departments,DC=nolancyber,DC=local"
            $Group = "Human Resources Team"
        }
        "Threat Intelligence" {
            $OU = "OU=Threat Intelligence,OU=Departments,DC=nolancyber,DC=local"
            $Group = "Threat Intelligence Team"
        }
        default {
            Write-Warning "Unknown department for $($User.Username): $($User.Department)"
            continue
        }
    }

    New-ADUser `
        -Name "$($User.FirstName) $($User.LastName)" `
        -GivenName $User.FirstName `
        -Surname $User.LastName `
        -SamAccountName $User.Username `
        -UserPrincipalName "$($User.Username)@nolancyber.local" `
        -AccountPassword $Password `
        -Enabled $true `
        -ChangePasswordAtLogon $false `
        -Path $OU

    Add-ADGroupMember -Identity $Group -Members $User.Username
}
