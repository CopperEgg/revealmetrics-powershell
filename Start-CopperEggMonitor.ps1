#
#	Start-CopperEggMonitor.ps1 kicks off a series of background monitoring jobs.
# Copyright (c) 2012 CopperEgg Corporation. All rights reserved.
#
function Start-CopperEggMonitor {
  $cmd = 'c:\Program Files (x86)\CopperEgg\Modules\CopperEgg\Start-CopperEggJob.ps1'
  $mhj = $global:master_hash | ConvertTo-Json -Depth 5

  #   $global:system_group_name = "System"
  [string[]]$cpath = $global:system_group.Get_Item("MSpaths")
  [string]$gname = $global:system_group_name
  Write-Host "Starting job, monitoring $global:system_group_name"
  Start-Job -ScriptBlock {param($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer) & $cmd $cpath $gname $mhj $global:apikey $global:computer} -ArgumentList @($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer)

  #   $global:netclr_group_name = "NET_CLR"
  [string[]]$cpath = $global:netclr_group.Get_Item("MSpaths")
  [string]$gname = $global:netclr_group_name
  Write-Host "Starting job, monitoring $global:netclr_group_name"
  Start-Job -ScriptBlock {param($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer) & $cmd $cpath $gname $mhj $global:apikey $global:computer} -ArgumentList @($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer)

  #   $global:memory_group_name = "System_Memory"
  [string[]]$cpath = $global:memory_group.Get_Item("MSpaths")
  [string]$gname = $global:memory_group_name
  Write-Host "Starting job, monitoring $global:memory_group_name"
  Start-Job -ScriptBlock {param($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer) & $cmd $cpath $gname $mhj $global:apikey $global:computer} -ArgumentList @($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer)

  # $global:storage_group_name = "Storage"
  [string[]]$cpath = $global:storage_group.Get_Item("MSpaths")
  [string]$gname = $global:storage_group_name
  Write-Host "Starting job, monitoring $global:storage_group_name"
  Start-Job -ScriptBlock {param($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer) & $cmd $cpath $gname $mhj $global:apikey $global:computer} -ArgumentList @($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer)

  #   $global:aspnet_group_name = "ASP_NET"
  [string[]]$cpath = $global:aspnet_group.Get_Item("MSpaths")
  [string]$gname = $global:aspnet_group_name
  Write-Host "Starting job, monitoring $global:aspnet_group_name"
  Start-Job -ScriptBlock {param($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer) & $cmd $cpath $gname $mhj $global:apikey $global:computer} -ArgumentList @($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer)

  #  $global:mssql_group_name = "MSSQL"
  [string[]]$cpath = $global:mssql_group.Get_Item("MSpaths")
  [string]$gname = $global:mssql_group_name
  Write-Host "Starting job, monitoring $global:mssql_group_name"
  Start-Job -ScriptBlock {param($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer) & $cmd $cpath $gname $mhj $global:apikey $global:computer} -ArgumentList @($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer)

  #   $global:web_group_name = "Web_Services"
  [string[]]$cpath = $global:web_group.Get_Item("MSpaths")
  [string]$gname = $global:web_group_name
  Write-Host "Starting job, monitoring $global:web_group_name"
  Start-Job -ScriptBlock {param($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer) & $cmd $cpath $gname $mhj $global:apikey $global:computer} -ArgumentList @($cmd,$cpath,$gname,$mhj,$global:apikey,$global:computer)

}


