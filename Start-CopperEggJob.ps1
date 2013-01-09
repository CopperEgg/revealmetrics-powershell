#
#    Start-CopperEggJob.ps1 : a minimal background monitoring job.
# Copyright (c) 2012 CopperEgg Corporation. All rights reserved.
#
param([string[]]$MSCounters,[string]$group_name,[string]$mhj,[string]$apikey,[string]$cname)
function Start-CopperEggJob {
param(
  [string[]]$MSCounters,
  [string]$group_name,
  [string]$mhj,
  [string]$apikey,
  [string]$cname
  )
  # Convert the result into an array of strings so it works with get-counter.
  [string[]]$result = $MSCounters.replace(",","`n")
  $metric_data = @{}
  [int]$epochtime = 0
  $unixEpochStart = new-object DateTime 1970,1,1,0,0,0,([DateTimeKind]::Utc)
  $newhash = $mhj | ConvertFrom-Json
  While($True) {
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
        $metric_data.Add( ($newhash | Select-Object $path).$path.ToString(), $sample.CookedValue )
      }
    }
    $apicmd = '/revealmetrics/samples/' + $group_name + '.json'
    $payload = New-Object PSObject -Property @{
      "timestamp"=$epochtime;
      "identifier"=[string]$cname;
      "values"=$metric_data
    }
    $data = $payload
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
    $rslt = $req.UploadString($uri, $data_json)
    Start-Sleep -s 15
  }
}
Start-CopperEggJob $MSCounters $group_name $mhj $apikey $cname
