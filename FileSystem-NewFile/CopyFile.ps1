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

$wshell = New-Object -ComObject Wscript.Shell

$confirmationMessage  =@"
Selected $($FileBrowser.FileNames.count) file(s) for processing: 
 ->$($FileBrowser.SafeFileNames -join "`r`n ->")

To Location : 
 ->$OutputFolder

Press Yes to confirm
"@
$Continue = $wshell.Popup("$confirmationMessage",0,"Confirmation",32+4)

if($Continue -ne 6){
    break;
}


$successFiles = @()
$failedFiles = @()
foreach($File in $FileBrowser.FileNames){
    $FileName = (gi $File).Name
    try{
        Copy-Item -Path $File -Destination $OutputFolder
        gi $OutputFolder\$Filename | where{$_.LastWriteTime = Get-Date}
        $successFiles += $FileName
    }
    catch{
        $failedFiles += $FileName
    }
}

@"
File(s) Placed for Processing :
 ->$($successFiles -join "`r`n ->")

Unable to place the following files: 
 ->$($failedFiles -join "`r`n ->")
"@

$FileBrowser.Dispose()
#$FolderName.Dispose();Start-BitsTransfer -Source $File -Destination $outputFolder