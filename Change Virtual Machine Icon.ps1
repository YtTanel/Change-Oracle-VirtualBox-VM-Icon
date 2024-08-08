# Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Set Original Path
$ogpath = Get-Location

# Script Directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

# Image Folder
$imagePath = Join-Path -Path $scriptDir -ChildPath "images\icon.ico"


# Text box for VM Name
$vmnametextbox = New-Object System.Windows.Forms.TextBox
$vmnametextbox.Multiline = $false
$vmnametextbox.Size = New-Object System.Drawing.Size(150,150)
$vmnametextbox.Location = New-Object System.Drawing.Size(20,50)
$vmnametextbox.Font = New-Object System.Drawing.Font("MS Shell Dlg",12,[System.Drawing.FontStyle]::Regular)



# Command Textbox properties
$cmdtextbox = New-Object System.Windows.Forms.TextBox
$cmdtextbox.Text = ".\VBoxManage.exe modifyvm `"$($vmnametextbox.Text)`" --iconfile `"$($picturebox.ImageLocation)`""
$cmdtextbox.Multiline = $false
$cmdtextbox.Size = New-Object System.Drawing.Size(430,400)
$cmdtextbox.Location = New-Object System.Drawing.Size(20,270)
$cmdtextbox.ReadOnly = $true

# VMName label control properties
$vmnamelabel = New-Object Windows.Forms.Label
$vmnamelabel.Text = "Virtual Machine Name"
$vmnamelabel.AutoSize = $true
$vmnamelabel.Location = New-Object Drawing.Point(20,30)
$vmnamelabel.ForeColor = [System.Drawing.Color]::Black

# Command label control properties
$cmdlabel = New-Object Windows.Forms.Label
$cmdlabel.Text = "Command:"
$cmdlabel.AutoSize = $true
$cmdlabel.Location = New-Object Drawing.Point(18,250)
$cmdlabel.ForeColor = [System.Drawing.Color]::Black

# Browse Image control properties
$button = New-Object System.Windows.Forms.Button
$button.Text = "Browse Image"
$button.Size = New-Object System.Drawing.Size(120, 30)
$button.Location = New-Object System.Drawing.Point(20, 90)

# Error label control properties
$errorlabel = New-Object Windows.Forms.Label
$errorlabel.Text = "Add virtual machine name or image"
$errorlabel.AutoSize = $true
$errorlabel.Location = New-Object Drawing.Point(150,400)
$errorlabel.ForeColor = [System.Drawing.Color]::Red
$errorlabel.Visible = $false

# Submit button control properties
$submitbutton = New-Object System.Windows.Forms.Button
$submitbutton.Text = "Change Icon"
$submitbutton.Size = New-Object System.Drawing.Size(120, 30)
$submitbutton.Location = New-Object System.Drawing.Point(180, 350)
$submitbutton.Anchor = 'right,bottom'

# Picturebox control properties
$picturebox = New-Object System.Windows.Forms.PictureBox
$picturebox.Size = New-Object System.Drawing.Size(100, 100)
$picturebox.Location = New-Object System.Drawing.Point(20, 140)
$picturebox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom

# Form properties
$form = New-Object Windows.Forms.Form
$form.Text = "Change Your Virtual Machine Icon"
$form.Width = 500
$form.Height = 500
$form.BackColor = "Whitesmoke"
$form.StartPosition = "CenterScreen"
$form.Icon = New-Object System.Drawing.Icon($imagePath)
$form.FormBorderStyle = "FixedDialog"

# Filter File Explorer .png and set the initial directory to Downloads folder
# VBoxManage.exe does not seem to accept .jpg files for icons, so convert or download an image thats in .png format

$filebrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
        InitialDirectory = [System.IO.Path]::Combine([Environment]::GetFolderPath('UserProfile'), 'Downloads')
        Filter           = 'Images (*.png*)|*.png'
}


# When "Browse Image" button is clicked
# Open File Explorer and choose image
# When image has been chosen display image in picturebox control
$button.Add_Click({

       
    if ($filebrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $Image = [System.Drawing.Image]::FromFile($filebrowser.FileName)
        $cmdtextbox.Text = ".\VBoxManage.exe modifyvm `"$($vmnametextbox.Text)`" --iconfile `"$($filebrowser.FileName)`""
        $picturebox.Image = $Image
        
     
    }

})


$submitbutton.Add_Click({

    # Set Virtualbox Path
    Set-Location -Path "C:\Program Files\Oracle\VirtualBox"

    # Make label invisible if all the fields are filled
    $errorlabel.Visible = $false

    # Execute the command with user input
    $output = & .\VBoxManage.exe modifyvm $vmnametextbox.Text --iconfile $filebrowser.FileName 2>&1

    # If one of the fields is empty
    # Make error label visible
    if ($output -like 'VBoxManage.exe:*') {

    $errorlabel.Visible = $true

    # If none of the fields are empty 
    # Display successful messagebox
    } else {

    [System.Windows.Forms.MessageBox]::Show('Icon successfully changed', 'Change Virtual Machine Icon', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) 
    }
})


# Updates text in-real time 
# When typing virtual machines name or uploading an image
$vmnametextbox.Add_TextChanged({
    $cmdtextbox.Text = ".\VBoxManage.exe modifyvm `"$($vmnametextbox.Text)`" --iconfile `"$($filebrowser.FileName)`""
})

$form.Add_FormClosing({

   Set-Location -Path $ogpath 

})

# Add all the controls
$form.Controls.Add($vmnametextbox)
$form.Controls.Add($vmnamelabel)
$form.Controls.Add($button)
$form.Controls.Add($picturebox)
$form.Controls.Add($cmdtextbox)
$form.Controls.Add($cmdlabel)
$form.Controls.Add($errorlabel)
$form.Controls.Add($submitbutton)
$form.Add_Shown({$form.Activate()})
$form.ShowDialog()