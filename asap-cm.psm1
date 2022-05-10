function Add-AsapCmConfiguration {
param (
    [parameter(mandatory=$true,position=1)]
    $SQLHost,
    [parameter(mandatory=$true,position=2)]
    $SQLUsername,
    [parameter(mandatory=$true,position=3)]
    $SQLPassword,
    [parameter(mandatory=$true,position=4)]
    $SQLDatabase,
    [parameter(mandatory=$true,position=5)]
    $SQLTable
)    

$Configuration = @"
{
    "sqlhost" : "$SQLHost",
    "sqlusername" : "$SQLUsername",
    "sqlpassword" : "$SQLPassword",
    "sqldatabase" : "$SQLDatabase",
    "sqltable" : "$SQLTable"
 }
"@

$Configuration | Out-File configuration.json -Force

}

function Add-AsapCmDatabase {
    param (

    )    
 #Requires -Modules sqlserver 
 $Configuration = "configuration.json"
 if (Test-Path -Path $Configuration){} else {Add-AsapCmConfiguration}
 $Values = Get-Content $Configuration | ConvertFrom-Json
 $SQLHost = $Values.sqlhost
 $SQLUsername = $Values.sqlusername
 $SQLPassword = $Values.sqlpassword
 $SQLDatabase = $Values.sqldatabase
 $SQLTable = $Values.sqltable
 
 Invoke-Sqlcmd -ServerInstance $SQLHost -Username $SQLUsername -Password $SQLPassword -Query "CREATE DATABASE $SQLDatabase;"
 Invoke-Sqlcmd -ServerInstance $SQLHost -Username $SQLUsername -Password $SQLPassword -Database $SQLDatabase -Query "CREATE TABLE $SQLTable (id varchar(50), change varchar(50), description varchar(50), notes varchar(50), status varchar(50), updated varchar(50), created varchar(50),PRIMARY KEY (id));"
}
function Add-AsapCm {
param (
    [parameter(mandatory=$true,position=1)]
    $Change,
    [parameter(mandatory=$true,position=2)]
    $Description,
    [parameter(mandatory=$true,position=3)]
    $Notes,
    [parameter(mandatory=$true,position=4)]
    $Status
)
#Requires -Modules sqlserver
$Configuration = "configuration.json"
if (Test-Path -Path $Configuration){} else {Add-AsapCmConfiguration}
$Values = Get-Content $Configuration | ConvertFrom-Json
$SQLHost = $Values.sqlhost
$SQLUsername = $Values.sqlusername
$SQLPassword = $Values.sqlpassword
$SQLDatabase = $Values.sqldatabase
$SQLTable = $Values.sqltable

$Id = New-Guid
$Timestamp = Get-Date -f "yyyy-MMdd hh:mm:ss"

$Query = @"
INSERT INTO $SQLTable (id,change,description,notes,status,updated,created)
VALUES ('$Id','$Change','$Description','$Notes','$Status','$Timestamp','$Timestamp')
"@

Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query

}

function Get-AsapCm {
param (
 [parameter(mandatory=$false,position=1)]
 $Id
)
#Requires -Modules sqlserver
$Configuration = "configuration.json"
if (Test-Path -Path $Configuration){} else {Add-AsapCmConfiguration}
$Values = Get-Content $Configuration | ConvertFrom-Json
$SQLHost = $Values.sqlhost
$SQLUsername = $Values.sqlusername
$SQLPassword = $Values.sqlpassword
$SQLDatabase = $Values.sqldatabase
$SQLTable = $Values.sqltable

if ($Id){
$Query = @"
SELECT * FROM $SQLTable WHERE id='$Id';
"@
}
else {
$Query = @"
SELECT * FROM $SQLTable;
"@
}

Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query

}


function Set-AsapCm {
    param (
        [parameter(mandatory=$true,position=1)]
        $Id,
        [parameter(mandatory=$false,position=2)]
        $Change,
        [parameter(mandatory=$false,position=3)]
        $Description,
        [parameter(mandatory=$false,position=4)]
        $Notes,
        [parameter(mandatory=$false,position=5)]
        $Status
    )
        #Requires -Modules sqlserver
        $Configuration = "configuration.json"
        if (Test-Path -Path $Configuration){} else {Add-AsapCmConfiguration}
        $Values = Get-Content $Configuration | ConvertFrom-Json
        $SQLHost = $Values.sqlhost
        $SQLUsername = $Values.sqlusername
        $SQLPassword = $Values.sqlpassword
        $SQLDatabase = $Values.sqldatabase
        $SQLTable = $Values.sqltable

$Timestamp = Get-Date -f "yyyy-MMdd hh:mm:ss"

if ($Change){
$Query = @"
UPDATE $SQLTable
SET change='$Change'
WHERE id='$Id';
"@
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query
}

if ($Description){
$Query = @"
UPDATE $SQLTable
SET description='$Description'
WHERE id='$Id';
"@
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query
}

if ($Notes){
$Query = @"
UPDATE $SQLTable
SET notes='$Notes'
WHERE id='$Id';
"@
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query
}

if ($Status){
$Query = @"
UPDATE $SQLTable
SET status='$Status'
WHERE id='$Id';
"@
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query
}

$Query = @"
UPDATE $SQLTable
SET updated='$Timestamp'
WHERE id='$Id';
"@
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query

}

function Remove-AsapCm {
param (
    [parameter(mandatory=$true,position=1)]
    $Id

)
#Requires -Modules sqlserver
$Configuration = "configuration.json"
if (Test-Path -Path $Configuration){} else {Add-AsapCmConfiguration}
$Values = Get-Content $Configuration | ConvertFrom-Json
$SQLHost = $Values.sqlhost
$SQLUsername = $Values.sqlusername
$SQLPassword = $Values.sqlpassword
$SQLDatabase = $Values.sqldatabase
$SQLTable = $Values.sqltable

$Query = @"
DELETE FROM $SQLTable WHERE id='$Id';
"@
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query
}

function Invoke-AsapCmDBQuery {
    param (
        [parameter(mandatory=$true,position=1)]
        $Query
    
    )
    #Requires -Modules sqlserver
    $Configuration = "configuration.json"
    if (Test-Path -Path $Configuration){} else {Add-AsapCmConfiguration}
    $Values = Get-Content $Configuration | ConvertFrom-Json
    $SQLHost = $Values.sqlhost
    $SQLUsername = $Values.sqlusername
    $SQLPassword = $Values.sqlpassword
    $SQLDatabase = $Values.sqldatabase
    $SQLTable = $Values.sqltable
    
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query
}


Export-ModuleMember -Function Add-AsapCmConfiguration
Export-ModuleMember -Function Add-AsapCmDatabase
Export-ModuleMember -Function Add-AsapCm
Export-ModuleMember -Function Get-AsapCm
Export-ModuleMember -Function Set-AsapCm
Export-ModuleMember -Function Remove-AsapCm
Export-ModuleMember -Function Invoke-AsapCmDBQuery
