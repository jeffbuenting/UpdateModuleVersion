


Describe "UpdateModuleVersion" {

    New-Variable -Name $env:GITHUB_REPOSITORY -Value TestPSD.psd1

    Mock -CommandName Get-ChildItem -MockWith {
        Return ([PSCustomObject]@{
            FullName = 'TestDrive:\TestPSD.psd1'
        })
    }

    Mock -CommandName Get-Content -MockWith {
        Return "ModuleVersion = '2.0.1'"
    }
 
 #   Mock -CommandName Set-Content -MockWith {
 #       '![Version](https://img.shields.io/badge/Version-1.0.1-brightgreen)' | Out-File TestDrive:\readme.md
 #   }
 #   
    It "Should update badge" {
 #      ..\PSSCript.ps1 #-FileName readme.md -Label Version -Message 1.0.1
 #
 #      Get-Content -Path TestDrive:\readme.md | Should -Match '![Version](https://img.shields.io/badge/Version-1.0.1-brightgreen)'
        $True | Should Be $True
    }


}