FROM mcr.microsoft.com/powershell:ubuntu-18.04

LABEL "com.github.actions.name"="UpdateModuleVersion"
LABEL "com.github.actions.description"="Updates the Version in a Module Manifest"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/jeffbuenting/UpdateModuleVersion"
LABEL "homepage"="https://jeffbuenting.github.io"
LABEL "maintainer"="Jeff Buenting"

ADD Action.ps1 /Action.ps1
ENTRYPOINT ["pwsh", "/Action.ps1"]