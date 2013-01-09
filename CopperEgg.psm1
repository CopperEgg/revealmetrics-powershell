#
#	CopperEgg.psm1 contains the core components of the CopperEgg powershell module.
# Copyright (c) 2012 CopperEgg Corporation. All rights reserved.
#
# The where_am_i functions provides a simple way to avoid path issues
function where_am_i {$myInvocation}

[string]$global:mypath = $null
[string]$global:computer = (gc env:computername).ToString()
[string]$global:apikey = $null

# Convert MS Counter path to CopperEgg metric name
function ConvertTo-CEName {
param(
    [string]$counter
	)
    $a = $counter
    $a = $a.replace( '*','_total')
    $a = $a.replace( '#','Number')
    $a = $a.replace( '%','Percent')
    $a = $a.replace( '$','_')
    $a = $a.replace(' / ','/')
    $a = $a.replace('/','_per_')
    $a = $a.replace('\','_')
    $a = $a.replace( ' ','_')
    $a = $a.replace( '.','')
    $a = $a.replace( ':','_')
    $a = $a.replace( '(','_')
    $a = $a.replace( ')','_')
    $a = $a.replace( '___','_')
    $a = $a.replace( '__','_')
	if($a.StartsWith("_") -eq $TRUE){
	  $a = $a.Substring(1)
	}
    return [string]$a
}
export-modulemember -function ConvertTo-CEName

# Remove-CounterInstances eliminates instances, where possible
function Remove-CounterInstances {
param(
	[string]$counter
	)
    $a = $counter
    if ( $a.Contains("NET") )
    {  $a = $a.replace( '*','_global_') }
    else
    { $a = $a.replace( '*','_total') }
    return [string]$a
}
export-modulemember -function Remove-CounterInstances

# Send-CEGet formats and sends a CopperEgg API Get command
function Send-CEGet {
param(
    [string]$apikey,
    [string]$apicmd,
    $data
  )
  $uri = 'https://api.copperegg.com/v2' + $apicmd
  $authinfo = $apikey + ':U'
  $auth = 'Basic ' + [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($authinfo))
  $req = New-Object System.Net.WebClient
  $req.Headers.Add('Authorization', $auth )
  $req.Headers.Add('Accept', 'application/json')
  $req.Headers.Add("user-agent", "PowerShell")
  [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
  [System.Net.ServicePointManager]::Expect100Continue = $false
  $req.Headers.Add('Content-Type', 'application/json')
  try {
    $result = $req.DownloadString($uri)
  }
  catch [Exception] {
    #Write-Host "ERROR: " + $_.Exception.ToString() -foregroundcolor "red"
	$result = $null
  }
  return $result
}
export-modulemember -function Send-CEGet

# Send-CEPost formats and sends a CopperEgg API Post command
# TODO: add exception processing, retries
function Send-CEPost {
param(
    [string]$apikey,
    [string]$apicmd,
    $data
  )
  $uri = 'https://api.copperegg.com/v2' + $apicmd
  $authinfo = $apikey + ':U'
  $auth = 'Basic ' + [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($authinfo))
  $req = New-Object System.Net.WebClient
  $req.Headers.Add('Authorization', $auth )
  $req.Headers.Add('Accept', '*/*')
  $req.Headers.Add("user-agent", "PowerShell")
  [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
  [System.Net.ServicePointManager]::Expect100Continue = $false
  $req.Headers.Add('Content-Type', 'application/json')
  $data_json = $data | ConvertTo-JSON -Depth 5
  $result = $req.UploadString($uri, $data_json)
  return $result
}
export-modulemember -function Send-CEPost

# New-MetricGroup will:
#   first check for the existence of the metric group
#   if it exists, it will not be changed
#   if it does not exist, it will be created
# NOTE: The file metric_groups.txt contains the list of metric groups that will be created.
#       This file will be updated by the CopperEgg module when necessary to handle versioned metric_groups.
#
function New-MetricGroup {
param(
    [string]$group_name,
    [string]$versioned_group_name,
    $groupcfg
  )
  Write-Host "Checking for metric group $group_name"

  # now see if $versioned exists at CopperEgg
  [string]$cmd =  '/revealmetrics/metric_groups.json'
  $rslt = Send-CEGet $global:apikey $cmd ""
  if($rslt -ne $null){
    $rslt_decode = $rslt | ConvertFrom-Json
    $mgarray = $rslt_decode | Where-Object {$_.name -eq $versioned_group_name}
    if($mgarray -ne $null){
      Write-Host "Metric group $versioned_group_name found; skipping create"
      return $versioned_group_name
    }
  }
  # metric group doesn't exist ... create it
  Write-Host "Not Found. Creating metric group $versioned_group_name"
  $rslt = Send-CEPost $global:apikey '/revealmetrics/metric_groups.json' $groupcfg
  if($rslt -ne $null){
    $versioned_group_name = ($rslt | ConvertFrom-Json).name.ToString()
    Write-Host "Created metric group $versioned_group_name"
    return $versioned_group_name
  }
  else {
    Write-Host "Error Creating $group_name"
  }
  return $null
}
export-modulemember -function New-MetricGroup


# New-Dashboard will:
#   first check for the existence of the metric group
#   if it exists, it will not be changed
#   if it does not exist, it will be created
#
function New-Dashboard {
param(
    [string]$dash_name,
    $dashcfg
  )
  Write-Host "Checking for Dashboard $dash_name"
  [string]$cmd =  '/revealmetrics/dashboards.json'
  $rslt = Send-CEGet $global:apikey $cmd ""
  [int]$found = 0
  if( $rslt -ne $null ){
    $new = $rslt | ConvertFrom-Json
    foreach($name in $new.name) {
      if( $dash_name -eq $name.ToString() ) {
        $found = 1
        break
      }
    }
  }
  if( $found -eq 0 ){
	  Write-Host "Not Found. Creating Dashboard $dash_name"
	  $rslt = Send-CEPost $global:apikey $cmd $dashcfg
	  if($rslt -ne $null){
      $new = ($rslt | ConvertFrom-Json).name.ToString()
		  Write-Host "Created Dashboard $new"
	  }
    else {
	    Write-Host "Error Creating $dash_name"
	  }
  }
  else {
	  Write-Host "Found $dash_name"
  }
  return $rslt
}
export-modulemember -function New-Dashboard

# Send-CEMetrics is the routine used to send sample data to CopperEgg
# TODO: change to While( $True )
function Send-CEMetrics {
param(
  [string[]]$MSCounters,
  [string]$group_name
  )
  # Convert the result into an array of strings so it works with get-counter.
  [string[]]$result = $MSCounters.replace(",","`n")
  $metric_data = @{}
  [int]$epochtime = 0
  $unixEpochStart = new-object DateTime 1970,1,1,0,0,0,([DateTimeKind]::Utc)
  $i = 1
  While($i -lt 100) {
    $metric_data = $null
    $metric_data = new-object @{}
    $samples = Get-Counter -Counter $result
    foreach($counter in $samples){
      $sample=$counter.CounterSamples[0]
      if($sample.Timestamp.Kind -eq 'Local'){
        [DateTime]$utc = $sample.Timestamp.ToUniversalTime()
      }else{
        [DateTime]$utc = $sample.Timestamp
      }
      $epochtime=($utc - $unixEpochStart).TotalSeconds
      foreach($sample in $counter.CounterSamples){
        [string]$path = $sample.Path.ToString()
        if ($path.StartsWith('\\') -eq 'True'){
          [int]$off = $path.IndexOfAny('\', 2)
          [string]$path = $path.Substring($off).ToString()
        }
        $metric_data.Add( $master_hash.Get_Item($path), $sample.CookedValue )
      }
    }
    $apicmd = '/revealmetrics/samples/' + $group_name + '.json'
    $payload = New-Object PSObject -Property @{
      "timestamp"=$epochtime;
      [string]"identifier"=$global:computer.ToString();
      "values"=$metric_data
    }
    $rslt = Send-CEPost '3Kz4RsZoswHnz012' $apicmd $payload
    Start-Sleep -s 10
    $i++
  }
}
Export-ModuleMember -function Send-CEMetrics

# set the global script location variable
$global:mypath = (where_am_i).PSScriptRoot.ToString()

# Check for the existence of the CopperEgg_APIKEY.txt file
[string]$fullpath = $global:mypath + '\CopperEgg_APIKEY.txt'
$fail = $True
if((Test-Path $fullpath) -eq $True) {
	[string]$checkkey = Get-Content $fullpath
	if($checkkey -ne $null) {
		[string]$global:apikey = $checkkey
		$fail = $False
	}
}
if( $fail -eq $True) {
	Write-Host "Error: Cannot find $fullpath"
	Write-Host "Can't continue. Please copy your CopperEgg APIKEY to $fullpath"
	exit
}
