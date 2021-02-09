<#
    .SYNOPSIS
        updats a Github Repositories version.

    .DESCRIPTION
        The version can be either from a powershell module or from the readme.md file in the repo.
#>

[CmdletBinding()]
Param ()

if ( $env:INPUT_VERBOSE.tolower() -eq 'true' ) { $VerbosePreference = 'Continue' }

$File = get-childitem . -ErrorAction SilentlyContinue | where Name -EQ "$(($env:GITHUB_REPOSITORY -split '/')[-1]).psd1"

if ( $File ) {
    Write-Verbose "Powershell Module Repository."

    Try {
        $PSD = Get-Content $File.FullName -ErrorAction Stop
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
}
else {
    Write-Verbose "Not a PS Module repo."

    # ----- Grab the file
    Try {
        $ReadmeFile = get-item ./README.md -ErrorAction Stop 

        $ReadmeFile = Get-Content -Path $File.FullName -ErrorAction Stop
    }
    Catch {
        Write-Error "Error getting file $FileName"
        Exit 1
    }

    # ----- get the existing badge link
    Try {
        # ----- getting link and removing surrounding ()
        $ExistingBadge = ($FileTxt | Select-String -Pattern "(\(https:\/\/img\.shields\.io\/badge\/Version-.*-.*\))" -ErrorAction Stop | foreach { $_.Matches.Groups[1].Value }).trimstart( '(' ).Trimend( ')' )

        # ----- Get the existing badge parameters
        $MatchingGroups = $ExistingBadge | Select-String -Pattern "https:\/\/img\.shields\.io\/badge\/Version-(.*)-(.*)" -ErrorAction Stop | foreach { $_.Matches.Groups }
        $CurrentVersion = $MatchingGroups[1].Value

    }
    Catch {
        Write-Error "Error Finding existing version from badge"
        Exit 1
    }
}
          
Write-Verbose "CurrentVersion = $CurrentVersion"


$SplitVer = $CurrentVersion -split '\.'
$NewVer = "$($SplitVer[0]).$($SplitVer[1]).$([int]$SplitVer[2] + 1)"

Write-Verbose "Updating to $NewVer"   

if ( $File ) {      

    Try {    
        Update-ModuleManifest -Path $File.FullName -ModuleVersion $NewVer -ErrorAction Stop
    }
    Catch {
        Write-Error "Error updating manifest file."
        Exit 1
    }
}

#$NewVer | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
"::set-output name=version::$NewVer"

Exit 0