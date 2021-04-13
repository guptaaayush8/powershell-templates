Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('MyDocuments')
    MultiSelect = $true
    Title='Select files for drop location'
}

if($FileBrowser.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK){
    break;
}


$OutputFolder = $((New-Object -ComObject "Shell.Application").BrowseForFolder(0,"Select drop location:",2047)).Self.Path

if($OutputFolder -notmatch "\w"){
    break;
}

$NewFile = @()
foreach($File in $FileBrowser.FileNames){
    $FileName = (gi $File).Name
    $fileContent = gc $file -ReadCount 0
    $NewFile+= (New-Item -Path "$outputFolder\$FileName" -ItemType File -Value $fileContent -Force).FullName
}

Write-Host "File(s) Placed for Processing :`n$($Newfile -join "`n")"
$FileBrowser.Dispose()
#$FolderName.Dispose()