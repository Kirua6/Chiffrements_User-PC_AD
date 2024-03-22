Import-Module ActiveDirectory

# fenêtre
Add-Type -AssemblyName System.Windows.Forms
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = 'Rechercher et Sélectionner une OU pour mise à jour des ordinateurs'
$mainForm.Size = New-Object System.Drawing.Size(400,320) # Taille ajustée
$mainForm.StartPosition = 'CenterScreen'

# recherche
$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Location = New-Object System.Drawing.Point(20,20)
$searchBox.Size = New-Object System.Drawing.Size(340,20)

# affiche liste OU filtré
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(20,50)
$listBox.Size = New-Object System.Drawing.Size(340,180)

# Récup & stock liste complete OU
$allOUs = Get-ADOrganizationalUnit -Filter * | Select-Object -ExpandProperty DistinguishedName

# mise a jour OU en fonction de recherche
function UpdateFilteredList {
    $filter = $searchBox.Text
    $listBox.Items.Clear()
    $filteredOUs = $allOUs | Where-Object { $_ -like "*$filter*" }
    foreach ($ou in $filteredOUs) {
        $listBox.Items.Add($ou)
    }
}

$searchBox.Add_TextChanged({ UpdateFilteredList })

$mainForm.Controls.Add($searchBox)
$mainForm.Controls.Add($listBox)

# bouton exe script
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(260,240) # Position ajustée pour le bas à droite
$button.Size = New-Object System.Drawing.Size(100,30)
$button.Text = 'Exécuter'

$button.Add_Click({
    $selectedOU = $listBox.SelectedItem
    if ($selectedOU -ne $null) {
        $computers = Get-ADComputer -Filter * -SearchBase $selectedOU -Properties "msDS-SupportedEncryptionTypes"

        foreach ($computer in $computers) {
            $currentTypes = $computer."msDS-SupportedEncryptionTypes"

            if ($currentTypes -ne 48) {
                # Suppr chiffrements non securisé
                $currentTypes = $currentTypes -band (-bnot 1) -band (-bnot 2) -band (-bnot 4) -band (-bnot 8) -bor 16 -bor 32

                # Applique new valeur
                Set-ADComputer -Identity $computer.DistinguishedName -Replace @{"msDS-SupportedEncryptionTypes" = $currentTypes}

                # Affiche score final pour chaque ordi
                Write-Host "Le score final de msDS-SupportedEncryptionTypes pour '$($computer.Name)' est : $currentTypes"
            }
            else {
                Write-Host "Le score de msDS-SupportedEncryptionTypes pour '$($computer.Name)' est déjà de 48. Aucune modification nécessaire."
            }
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Veuillez sélectionner une OU.")
    }
})

$mainForm.Controls.Add($button)

$mainForm.ShowDialog()
