# OU choisis
$computerOUs = @("OU=Ordinateurs,DC=sirailgroup,DC=local")
$userOUs = @("OU=Utilisateurs,DC=sirailgroup,DC=local")

if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Import-Module ActiveDirectory
}

# mise a jour chiffrements PC
function Update-ComputerEncryption {
    param($ou)
    $computers = Get-ADComputer -Filter * -SearchBase $ou -Properties "msDS-SupportedEncryptionTypes"
    foreach ($computer in $computers) {
        $currentTypes = $computer."msDS-SupportedEncryptionTypes"
        if ($currentTypes -ne 48) {
            $currentTypes = $currentTypes -band (-bnot 1) -band (-bnot 2) -band (-bnot 4) -band (-bnot 8) -bor 16 -bor 32
            Set-ADComputer -Identity $computer.DistinguishedName -Replace @{"msDS-SupportedEncryptionTypes" = $currentTypes}
            Write-Host "Updated encryption types for computer: $($computer.Name)"
        }
    }
}

# mise a jour chiffrements users
function Update-UserEncryption {
    param($ou)
    $users = Get-ADUser -Filter * -SearchBase $ou -Properties "msDS-SupportedEncryptionTypes"
    foreach ($user in $users) {
        $currentTypes = $user."msDS-SupportedEncryptionTypes"
        if ($currentTypes -ne 48) {
            $currentTypes = $currentTypes -band (-bnot 1) -band (-bnot 2) -band (-bnot 4) -band (-bnot 8) -bor 16 -bor 32
            Set-ADUser -Identity $user.DistinguishedName -Replace @{"msDS-SupportedEncryptionTypes" = $currentTypes}
            Write-Host "Updated encryption types for user: $($user.SamAccountName)"
        }
    }
}

# Exe mise à jour pour chaque OU
foreach ($ou in $computerOUs) {
    Update-ComputerEncryption -ou $ou
}
foreach ($ou in $userOUs) {
    Update-UserEncryption -ou $ou
}
