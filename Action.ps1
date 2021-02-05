$env:GITHUB_WORKSPACE

Get-ChildItem -Path $env:GITHUB_WORKSPACE

#$PSD = Get-Content "$($env:GITHUB_REPOSITORY -split '/')[-1]).psd1";
#$CurrentVersion = $PSD | Select-String -Pattern "ModuleVersion = '(.*)'" | foreach { $_.Matches.Groups[1].Value }
#          
#Write-Output "CurrentVersion = $CurrentVertion";
#$SplitVer = $CurrentVersion -split '.';
#$NewVer = "$SplitVer[0].$SplitVer[1].$([int]SplitVer[2] + 1)"
#          
#
#Update-ModuleManifest -Path "$($env:GITHUB_REPOSITORY -split '/')[-1]).psd1" -ModuleVersion $NewVer