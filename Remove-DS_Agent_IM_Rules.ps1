Clear-Host
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

$ErrorActionPreference = 'Stop'

$Config 		    = (Get-Content "$PSScriptRoot\DS-Config.json" -Raw) | ConvertFrom-Json
$Manager    		= $Config.MANAGER
$Port     			= $Config.PORT
$APIKEY     		= $Config.APIKEY
$POLICYID			= $Config.POLICYID

$StartTime  		= $(get-date)

$DSM_URI			= "https://" + $Manager + ":" + $Port
$Search_Uri			= "$DSM_URI/api/computers/search"

$Data = @{
	searchCriteria = @{
		fieldName = "policyID"
		numericTest = "equal"
		numericValue = $POLICYID
		}
	sortByObjectID = "true"
}

$Data_JSON = $Data | ConvertTo-Json

$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Headers.Add("api-secret-key", $APIKEY)
$Headers.Add("api-version", 'v1')
$Headers.add("Content-Type", 'application/json')

$Computers = Invoke-RestMethod -Uri $Search_Uri -Method Post -Headers $Headers -Body $Data_JSON

foreach ($Item in $Computers.computers){
	$ComputerID			= $Item.ID
	$IM_List_Uri        = "$DSM_URI/api/computers/$ComputerID/integritymonitoring/assignments"
	$IM_List 			= Invoke-RestMethod -Uri $IM_List_Uri -Method Get -Headers $Headers	
	$Assigned_IM_Rules	= $IM_List.assignedRuleIDs

	foreach ($IM_Rule in $Assigned_IM_Rules){
		$IM_Remove_Uri        = "$DSM_URI/api/computers/$ComputerID/integritymonitoring/assignments/$IM_Rule"
		$Output = Invoke-RestMethod -Uri $IM_Remove_Uri -Method Delete -Headers $Headers
	}
}

$elapsedTime	= $(get-date) - $StartTime
$totalTime		= "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)

Write-Host "Script Execution is Complete.  It took $totalTime"