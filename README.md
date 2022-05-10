# asap-cm
A PowerShell Module to manage changes using a Microsoft SQL backend.

## Requirements
* Container Platform (ie., Docker, Kubernetes, Rancher Desktop, etc...)
* Microsoft SQL Database
* PowerShell
  * sqlserver module
  ````
  Install-Module -Name sqlserver
  Import-Module -Name sqlserver
  ````
* Git

## Setup Environment
* Download bits
````
git clone https://github.com/rickjacobo/asap-cm
````
* If you don't already have a Microsoft SQL encvironment run Start-SQLContainer.ps1 setup wizard
````
./Start-SQLContainer.ps1
````
or
````
docker run -d --name="<name of container>" -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<secure password>" -e "MSSQL_PID=Express" -p $Port mcr.microsoft.com/mssql/server:2019-latest
````

* Setup Database (Enter sqlhost, username, password, database, table)
````
./Add-AsapCmDatabase.ps1
````

* Import AsapCm Module
````
Import-Module asapcm.psm1
````

* Add Change
````
Add-AsapCm -Change <change> -Description <description> -Notes <notes> -Status <status>
````

* Get Change
````
Get-AsapCm
````

* Update Change
  * Get Id with Get-AsapCm
````
Set-AsapCm -Id <obtain from Get-AsapCm> -Change <change> -Description <description> -Notes <notes> -Status <status>
````

* Remove Change
  * Get Id with Get-AsapCm
```
Remove-AsapCm -Id <obtain from Get-AsapCm>
````

