# UpdateModuleVersion
Github Action to update PowerShell Module or package.json version.

---
[![GitHub Workflow - UnitTest](https://github.com/jeffbuenting/UpdateModuleVersion/workflows/UnitTest/badge.svg)](https://github.com/jeffbuenting/UpdateModuleVersion/actions?workflow='UnitTest')

![Version](https://img.shields.io/badge/Version-1.1.26-brightgreen)

Use this action to update the PowerShell or package.json version field.


### Inputs

- `vertype`: File type from where the version was optained.
- `version`: New version to update.

### Example

```yaml
  UpdateModuleVersion:
    name: UpdatesModuleVersion and returns that Version
    needs: pester-test
    if: ${{ success() }}
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository code
        uses: actions/checkout@v2        
        
      - name: GetRepoVersion
        if: success()
        id: GetRepoVer
        uses: jeffbuenting/GetRepoVersion@getfile

      - name: IncreaseVersion
        id: IncreaseVer
        shell: bash
        run: |
            CurVer=${{ steps.GetRepoVer.outputs.version }}
            IFS='.'
            read -a SplitVer <<<"$CurVer"
            Major=$((SplitVer[0]))
            Minor=$((SplitVer[1]))
            Build="$((SplitVer[2] + 1))"
            NewVer="$Major.$Minor.$Build"
            unset IFS
            echo "::set-output name=version::$NewVer"
         
      - name: Show Version
        run: |
          echo "NewVer = ${{ steps.IncreaseVer.outputs.version }}"
  
      - name: UpdateModuleVersion
        uses: ./
        with: 
          vertype: ${{ steps.GetRepoVer.outputs.versiontype }}
          newver: ${{ steps.IncreaseVer.outputs.version }}
           
      - name: UpdateReadmeVersionBadge
        uses: jeffbuenting/UpdateCustomBadge@jeffbuenting-patch-1
        with:
          filename: 'README.md'
          label: 'Version'
          message: ${{ steps.IncreaseVer.outputs.version }}
          
      - name: Commit
        if: ${{ success() }}
        run: |
          git show commit_id --name-only
          git config --global user.name 'github actions'      
          git config --global user.email 'actions@github.com'
          git ls-files --others --exclude-standard
          git commit -am "skip ci - Commit Updated files to Repo"
          git push
```

---

So this action is a docker container that runs a PowerShell script.

Used this as a starting point: https://toastit.dev/2018/12/19/powershell-flavoured-github-actions/

