Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('MyDocuments')
    MultiSelect = $true
    Title='HRIntelex File Place'
}

if($FileBrowser.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK){
    break;
}


 $FolderName = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
    Description = "Select Receive Location Folder"
    ShowNewFolderButton = $false

 }

$Topmost = New-Object System.Windows.Forms.Form
$Topmost.TopMost = $True
$Topmost.MinimizeBox = $True

if ($FolderName.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK){
    break;
}

$outputFolder = $FolderName.SelectedPath
$NewFile = @()
foreach($File in $FileBrowser.FileNames){
    $FileName = (gi $File).Name
    $fileContent = gc $file -ReadCount 0
    $NewFile+= (New-Item -Path "$outputFolder\$FileName" -ItemType File -Value $fileContent -Force).FullName
}

Write-Host "File(s) Placed for Processing :`n$($Newfile -join "`n")"
$FileBrowser.Dispose()
$FolderName.Dispose()