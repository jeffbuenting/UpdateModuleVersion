Write-Output "Updating Version on $(($env:GITHUB_REPOSITORY -split '/')[-1]).psd1"

Try {
    $PSD = Get-Content "$(($env:GITHUB_REPOSITORY -split '/')[-1]).psd1" -ErrorAction Stop
}
Catch {
    Write-Error "Error getting manifest"
    Exit 1
}

Try {
    $CurrentVersion = $PSD | Select-String -Pattern "ModuleVersion = '(.*)'" -ErrorAction Stop | foreach { $_.Matches.Groups[1].Value }
}
Catch {
    Write-Error "Error finding ModuleVersion."
    Exit 1
}
          
Write-Output "CurrentVersion = $CurrentVertion"


$SplitVer = $CurrentVersion -split '.'
$NewVer = "$SplitVer[0].$SplitVer[1].$([int]$SplitVer[2] + 1)"

Write-Output "Updating to $NewVer"         

Try {    
    Update-ModuleManifest -Path "$($env:GITHUB_REPOSITORY -split '/')[-1]).psd1" -ModuleVersion $NewVer -ErrorAction Stop
}
Catch {
    Write-Error "Error updating manifest file."
    Exit 1
}