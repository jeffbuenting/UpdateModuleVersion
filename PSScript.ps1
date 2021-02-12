<#
    .SYNOPSIS
        updats a Github Repositories version.

    .DESCRIPTION
        The version can be either from a powershell module or from the readme.md file in the repo.
#>

[CmdletBinding()]
Param (
    [String]$VerType = $env:INPUT_VERTYPE,

    [String]$NewVer = $env:INPUT_NewVer
)

$VerbosePreference = 'Continue' 

Write-Verbose "Updating to $NewVer"   

switch ( $VerType ) {
    'modulemanifest' {
        Try {    
        Update-ModuleManifest -Path $File.FullName -ModuleVersion $NewVer -ErrorAction Stop
        }
        Catch {
            Write-Error "Error updating manifest file."
            Exit 1
        }
    }

    'package.json' {
        Write-Verbose "updating package.json"

        Try {
            $PJSON = Get-Content "package.json" -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            $PJSON.Version = $NewVer
            $PJSON | ConvertTo-Json -depth 32 -ErrorAction Stop | set-content 'package.json' -ErrorAction Stop
        }
        Catch {
            Write-Error "Error updating package.json file."
            Exit 1
        }
    }

    'readme' {
        Write-verbose "Oops, use the UpdateCustomBadge action to update the README.md Version"
    }
}

#$NewVer | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
#"::set-output name=version::$NewVer"

Exit 0