#
#	Initialize-MetricGroups.ps1 contains sample code for creating a default set of metric groups.
# Copyright (c) 2012 CopperEgg Corporation. All rights reserved.
#
#	Updated for version 0.9.1 to include support for UserDefined metrics
# This script assumes that the following metric groups are defined:
#
#   MSSQL
#   System_Memory
#   Storage
#   ASP_NET
#   NET_CLR
#   Web_Services
#   System
#	  UserDefined

function Initialize-MetricGroups {
  [string]$global:aspnet_group_name = "ASP_NET"
  [string]$global:netclr_group_name = "NET_CLR"
  [string]$global:mssql_group_name = "MSSQL"
  [string]$global:storage_group_name = "Storage"
  [string]$global:memory_group_name = "System_Memory"
  [string]$global:system_group_name = "System"
  [string]$global:web_group_name = "Web_Services"
  [string]$global:custom_group_name = "UserDefined"

  [string]$global:versioned_aspnet_group_name = "ASP_NET"
  [string]$global:versioned_netclr_group_name = "NET_CLR"
  [string]$global:versioned_mssql_group_name = "MSSQL"
  [string]$global:versioned_storage_group_name = "Storage"
  [string]$global:versioned_memory_group_name = "System_Memory"
  [string]$global:versioned_system_group_name = "System"
  [string]$global:versioned_web_group_name = "Web_Services"
  [string]$global:versioned_custom_group_name = "UserDefined"


  $global:aspnet_group = $null
  $global:netclr_group = $null
  $global:mssql_group = $null
  $global:storage_group = $null
  $global:memory_group = $null
  $global:system_group = $null
  $global:web_group = $null
  $global:custom_group = $null

  $global:master_hash = @{}
  $global:mssql_head = $null

  # Read in win_counters.txt, which lists the defined metric groups.
  #

  $fn = $global:mypath + "\win_counters.txt"
  $CounterList = Get-Content $fn | Where-Object {$_ -match '\S'}

  [string[]]$mg_asp_net = @()
  [string[]]$mg_net_clr = @()
  [string[]]$mg_mssql = @()
  [string[]]$mg_memory = @()
  [string[]]$mg_webservices = @()
  [string[]]$mg_storage = @()
  [string[]]$mg_system = @()
  [string[]]$mg_custom = @()

  # NOTE: Remove-CounterInstances replaces the '*' in 'PathsWithInstances' with a 'total' instance, where possible.
  # This was done to avoid creating a huge number of default metrics.

  $i = 0
  while( $i -lt $CounterList.length) {
    $line = $CounterList[$i]
    if( $line.StartsWith("[metric_group]") -eq $True ) {
      $mg = $line.Substring(14)
      if( $mg.Contains(",") ) {
        $split = $mg.split(",")
        $mg = $split[0]
        $versioned = $split[1]
      }
      else {
       $versioned = $mg
      }
      if( $mg -eq $global:aspnet_group_name ) {
        $global:versioned_aspnet_group_name = $versioned
        $i++
        $line = $CounterList[$i]
        $Err = $null
        $result = Get-Counter -ListSet 'ASP.NET' -ErrorAction SilentlyContinue  -ErrorVariable Err
        if( $? -ne $false) {
          while( ($line.StartsWith("[metric_group]") -ne $True) -and  ($i -lt $CounterList.length) ) {
            if( $line.StartsWith("\") ){
              $mg_asp_net = $mg_asp_net + (Remove-CounterInstances($line))
            }
            $i++
            if( $i -lt $CounterList.Length ) {
              $line = $CounterList[$i]
            }
          }
        }
      }
      elseif ( $mg -eq $global:netclr_group_name ) {
        $global:versioned_netclr_group_name = $versioned
        $i++
        $line = $CounterList[$i]
        $Err = $null
        $result = Get-Counter -ListSet '.NET CLR Memory' -ErrorAction SilentlyContinue  -ErrorVariable Err
        if( $? -ne $false) {
          while( ($line.StartsWith("[metric_group]") -ne $True) -and  ($i -lt $CounterList.length) ) {
            if( $line.StartsWith("\") ){
              $mg_net_clr = $mg_net_clr + (Remove-CounterInstances($line))
            }
            $i++
            if( $i -lt $CounterList.Length ) {
              $line = $CounterList[$i]
            }
          }
        }
      }
      elseif ($mg -eq $global:mssql_group_name ) {
        $global:versioned_mssql_group_name = $versioned
        $i++
        $line = $CounterList[$i]
        $Err = $null
        $result = Get-Counter -ListSet 'MSSQL$SQLEXPRESS:General Statistics' -ErrorAction SilentlyContinue  -ErrorVariable Err
        if( $? -ne $false) {
		  $global:mssql_head  = "MSSQL_SQLEXPRESS_"
          while( ($line.StartsWith("[metric_group]") -ne $True) -and  ($i -lt $CounterList.length) ) {
            if( $line.StartsWith("\MSSQL") ){
              $mg_mssql = $mg_mssql + (Remove-CounterInstances($line))
            }
            $i++
            if( $i -lt $CounterList.Length ) {
              $line = $CounterList[$i]
            }
          }
        }
        else {
          $Err = $null
          $result = Get-Counter -ListSet 'SQLServer:General Statistics' -ErrorAction SilentlyContinue  -ErrorVariable Err
          if( $? -ne $false) {
			$global:mssql_head  = "SQLServer_"
            while( ($line.StartsWith("[metric_group]") -ne $True) -and  ($i -lt $CounterList.length) ) {
              if( $line.StartsWith("\SQLServer") ){
                $mg_mssql = $mg_mssql + (Remove-CounterInstances($line))
              }
              $i++
              if( $i -lt $CounterList.Length ) {
                $line = $CounterList[$i]
              }
            }
          }
        }
      }
      elseif ($mg -eq $global:storage_group_name ) {
        $global:versioned_storage_group_name = $versioned
        $i++
        $line = $CounterList[$i]
        $Err = $null
        $result = Get-Counter -ListSet 'LogicalDisk' -ErrorAction SilentlyContinue  -ErrorVariable Err
        if( $? -ne $false) {
          while( ($line.StartsWith("[metric_group]") -ne $True) -and  ($i -lt $CounterList.length) ) {
            if( $line.StartsWith("\") ){
              $mg_storage = $mg_storage + (Remove-CounterInstances($line))
            }
            $i++
            if( $i -lt $CounterList.Length ) {
              $line = $CounterList[$i]
            }
          }
        }
      }
      elseif ($mg -eq $global:memory_group_name ) {
        $global:versioned_memory_group_name = $versioned
        $i++
        $line = $CounterList[$i]
        $Err = $null
        $result = Get-Counter -ListSet 'Memory' -ErrorAction SilentlyContinue  -ErrorVariable Err
        if( $? -ne $false) {
          while( ($line.StartsWith("[metric_group]") -ne $True) -and  ($i -lt $CounterList.length) ) {
            if( $line.StartsWith("\") ){
              $mg_memory = $mg_memory + (Remove-CounterInstances($line))
            }
            $i++
            if( $i -lt $CounterList.Length ) {
              $line = $CounterList[$i]
            }
          }
        }
      }
      elseif ($mg -eq $global:system_group_name ) {
        $global:versioned_system_group_name = $versioned
        $i++
        $line = $CounterList[$i]
        $Err = $null
        $result = Get-Counter -ListSet 'System' -ErrorAction SilentlyContinue  -ErrorVariable Err
        if( $? -ne $false) {
          while( ($line.StartsWith("[metric_group]") -ne $True) -and  ($i -lt $CounterList.length) ) {
            if( $line.StartsWith("\") ){
              $mg_system = $mg_system + (Remove-CounterInstances($line))
            }
            $i++
            if( $i -lt $CounterList.Length ) {
              $line = $CounterList[$i]
            }
          }
        }
      }
      elseif ($mg -eq $global:web_group_name ) {
        $global:versioned_web_group_name = $versioned
        $i++
        $line = $CounterList[$i]
        $Err = $null
        $result = Get-Counter -ListSet 'Web Service' -ErrorAction SilentlyContinue  -ErrorVariable Err
        if( $? -ne $false) {
          while( ($line.StartsWith("[metric_group]") -ne $True) -and  ($i -lt $CounterList.length) ) {
            if( $line.StartsWith("\") ){
              $mg_webservices = $mg_webservices + (Remove-CounterInstances($line))
            }
            $i++
            if( $i -lt $CounterList.Length ) {
              $line = $CounterList[$i]
            }
          }
        }
      }
      elseif ($mg -eq $global:custom_group_name ) {
        $global:versioned_custom_group_name = $versioned
        $i++
        $line = $CounterList[$i]
        $Err = $null
        while( ($line.StartsWith("[metric_group]") -ne $True) -and  ($i -lt $CounterList.length) ) {
          if( $line.StartsWith("\") ){
            $mg_custom = $mg_custom + (Remove-CounterInstances($line))
          }
          $i++
          if( $i -lt $CounterList.Length ) {
            $line = $CounterList[$i]
          }
        }

      }
    }
    else {
      $i++
    }
  }
  $ce_asp_net = @()
  $ce_net_clr = @()
  $ce_mssql = @()
  $ce_storage = @()
  $ce_memory = @()
  $ce_system = @()
  $ce_webservices = @()
  $ce_custom = @()


  [string]$path = $null
  $ValidMetricGroups = 0

  if( $mg_asp_net -ne $null) {
    $ValidMetricGroups++
    foreach( $path in $mg_asp_net) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_asp_net =  $ce_asp_net + $name
    }
  }
  if( $mg_net_clr -ne $null) {
    $ValidMetricGroups++
    foreach( $path in $mg_net_clr) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_net_clr = $ce_net_clr + $name
    }
  }
  if( $mg_mssql -ne $null) {
    $ValidMetricGroups++
    foreach( $path in $mg_mssql) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_mssql =  $ce_mssql + $name
    }
  }
  if( $mg_storage -ne $null) {
    $ValidMetricGroups++
    foreach( $path in $mg_storage) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_storage =  $ce_storage + $name
    }
  }
  if( $mg_memory -ne $null) {
    $ValidMetricGroups++
    foreach( $path in $mg_memory) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_memory =  $ce_memory + $name
    }
  }
  if( $mg_system -ne $null) {
    $ValidMetricGroups++
    foreach( $path in $mg_system) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_system =  $ce_system + $name }
  }
  if( $mg_webservices -ne $null) {
    $ValidMetricGroups++
    foreach( $path in $mg_webservices) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_webservices =  $ce_webservices + $name
    }
  }
  if( $mg_custom -ne $null) {
    $ValidMetricGroups++
    foreach( $path in $mg_custom) {
      $name = (ConvertTo-CEName($path))
      # hash table entries are 'variable', 'function' for custom metrics
      [string]$fxn = ($name + "_function")
      $global:master_hash.Add($name, $fxn)
      $ce_custom =  $ce_custom + $name
    }
  }

  # mg_ prefix: collections of windows-readable counter path names
  # ce_prefix:  same collections, escaped for use in revealmetrics
  #
  #   $mg_asp_net           $ce_asp_net
  #   $mg_net_clr           $ce_net_clr
  #   $mg_mssql             $ce_mssql
  #   $mg_storage           $ce_storage
  #   $mg_memory            $ce_memory
  #   $mg_system            $ce_system
  #   $mg_webservices       $ce_webservices
  #   $mg_custom            $ce_custom

  # The necessary structures and variables are set up.
  # Now we'll create corresponding metric groups at CopperEgg

  Write-Host  "Processing $ValidMetricGroups Metric Groups"

  #  create asp.net metric group
  if( $mg_asp_net -ne $null ) {
    $group_name = $global:aspnet_group_name
    $group_label = "ASP.NET metrics"
    $freq = 60
    $groupcfg = $null

    $marray = @(
      @{"type"="ce_gauge";    "name"="ASPNET_Applications_Running";      "label"="ASP.NET Apps Running";          "unit"="Apps"},
      @{"type"="ce_counter";  "name"="ASPNET_Requests_Rejected";         "label"="ASP.NET Requests Rejected";            "unit"="Requests"},
      @{"type"="ce_counter";  "name"="ASPNET_Requests_Queued";           "label"="ASP.NET Requests Queued";            "unit"="Requests"},
      @{"type"="ce_gauge";    "name"="ASPNET_Worker_Processes_Running";  "label"="ASP.NET Worker Processes Running";          "unit"="Processes"},
      @{"type"="ce_counter";  "name"="ASPNET_Worker_Process_Restarts";   "label"="ASP.NET Worker Process Restarts";          "unit"="Restarts"},
      @{"type"="ce_gauge_f";  "name"="ASPNET_Request_Wait_Time";         "label"="ASP.NET Request Wait Time";           "unit"="seconds"},
      @{"type"="ce_gauge";    "name"="ASPNET_Requests_Current";          "label"="ASP.NET Requests Current";           "unit"="Requests"},
      @{"type"="ce_counter";  "name"="ASPNET_Error_Events_Raised";       "label"="ASP.NET Error Events";              "unit"="Total Errors"},
      @{"type"="ce_counter";  "name"="ASPNET_Request_Error_Events_Raised";   "label"="ASP.NET Request Error Events";      "unit"="Request Errors"},
      @{"type"="ce_counter";  "name"="ASPNET_Infrastructure_Error_Events_Raised";  "label"="ASP.NET Infrastruct Error Events";   "unit"="Infrastructure Errors"},
      @{"type"="ce_gauge";    "name"="ASPNET_Requests_In_Native_Queue";   "label"="ASP.NET Requests in Native Queue";          "unit"="Requests"}
      )
    $global:aspnet_group =  @{}
    $global:aspnet_group.add("name",$group_name)
    $global:aspnet_group.add("label",$group_label)
    $global:aspnet_group.add("frequency",$freq)
    $global:aspnet_group.add("MSpaths",[string[]]$mg_asp_net)

    $groupcfg = New-Object PSObject -Property @{
      "name" = $group_name;
      "label" = $group_label;
      "frequency" = $freq;
      "metrics" = $marray
    }
    $rslt = New-MetricGroup $group_name $global:versioned_aspnet_group_name $groupcfg
    if( $rslt -ne $null ) {
      $global:versioned_aspnet_group_name = $rslt
    }
  }
  #   create .net clr metric group
  if( $mg_net_clr -ne $null ) {
    $group_name = $global:netclr_group_name
    $group_label = ".NET CLR metrics"
    $freq = 60

    $marray = @(
      @{"type"="ce_counter";   "name"="NET_CLR_Exceptions_global_Number_of_Exceps_Thrown";           "label"=".NET Global Number of Exceptions";  "unit"="Exceptions"},
      @{"type"="ce_gauge_f";   "name"="NET_CLR_Exceptions_global_Number_of_Exceps_Thrown_per_sec";  "label"=".NET Global Exceptions / sec";     "unit"="Exceptions / sec"},
      @{"type"="ce_gauge";     "name"="NET_CLR_Memory_global_Number_GC_Handles";        "label"=".NET Global GC Handles";        "unit"="Handles"},
      @{"type"="ce_gauge_f";   "name"="NET_CLR_Memory_global_Allocated_Bytes_per_sec";     "label"=".NET Global Allocated Bytes / sec";      "unit"="Bytes / sec"},
      @{"type"="ce_gauge";     "name"="NET_CLR_Memory_global_Number_Total_committed_Bytes"; "label"=".NET Global Total Committed Bytes";       "unit"="Bytes"}
      )
    $global:netclr_group =  @{}
    $global:netclr_group.add("name",$group_name)
    $global:netclr_group.add("label",$group_label)
    $global:netclr_group.add("frequency",$freq)
    $global:netclr_group.add("MSpaths",[string[]]$mg_net_clr)

    $groupcfg = New-Object PSObject -Property @{
      "name" = $group_name;
      "label" = $group_label;
      "frequency" = $freq;
      "metrics" = $marray
    }
    $rslt = New-MetricGroup $group_name $global:versioned_netclr_group_name $groupcfg
    if( $rslt -ne $null ) {
      $global:versioned_netclr_group_name = $rslt
    }
  }
  #  create mssql metric group
  if( $mg_mssql -ne $null ) {
    $group_name = $global:mssql_group_name
    $group_label = "MSSQL metrics"
    $freq = 60

    $groupcfg = $null

    $marray = @(
      @{"type"="ce_gauge_f";   "name"=[string]($global:mssql_head + "Buffer_Manager_Buffer_cache_hit_ratio"); "label"="MSSQL Buffer cache hit ratio";   },
      @{"type"="ce_gauge_f";   "name"=[string]($global:mssql_head + "Buffer_Manager_Checkpoint_pages_per_sec");  "label"="MSSQL Checkpoint pages / sec";   "unit"="Pages / sec"},
      @{"type"="ce_gauge_f";   "name"=[string]($global:mssql_head + "Buffer_Manager_Page_life_expectancy");     "label"="MSSQL Page life expectancy";    "unit"="Seconds"},
      @{"type"="ce_gauge";     "name"=[string]($global:mssql_head + "General_Statistics_User_Connections");     "label"="MSSQL User Connections";    "unit"="Connections"},
      @{"type"="ce_gauge_f";   "name"=[string]($global:mssql_head + "Access_Methods_Page_Splits_per_sec");       "label"="MSSQL Page Splits / sec";   "unit"="Page_splits / sec"},
      @{"type"="ce_gauge";     "name"=[string]($global:mssql_head + "General_Statistics_Processes_blocked");     "label"="MSSQL Processes blocked";  "unit"="Processes"},
      @{"type"="ce_gauge_f";   "name"=[string]($global:mssql_head + "SQL_Statistics_Batch_Requests_per_sec");     "label"="MSSQL Batch Requests / sec";  "unit"="Requests / sec"},
      @{"type"="ce_gauge_f";   "name"=[string]($global:mssql_head + "SQL_Statistics_SQL_Compilations_per_sec");    "label"="MSSQL SQL Compilations / sec"; "unit"="Compilations / sec"},
      @{"type"="ce_gauge_f";   "name"=[string]($global:mssql_head + "SQL_Statistics_SQL_Re-Compilations_per_sec"); "label"="MSSQL SQL Re-Compilations / sec"; "unit"="Re-Compilations / sec"}
      )

    $global:mssql_group =  @{}
    $global:mssql_group.add("name",$group_name)
    $global:mssql_group.add("label",$group_label)
    $global:mssql_group.add("frequency",$freq)
    $global:mssql_group.add("mssql_head",$global:mssql_head)
    $global:mssql_group.add("MSpaths",[string[]]$mg_mssql)

    $groupcfg = New-Object PSObject -Property @{
      "name" = $group_name;
      "label" = $group_label;
      "frequency" = $freq;
      "metrics" = $marray
    }
    $rslt = New-MetricGroup $group_name $global:versioned_mssql_group_name $groupcfg
    if( $rslt -ne $null ) {
       $global:versioned_mssql_group_name = $rslt
    }
  }
  #  create Storage metric group
  if( $mg_storage -ne $null ) {

    $group_name = $global:storage_group_name
    $group_label = "Storage metrics"
    $freq = 60

    $groupcfg = $null

    $marray = @(
      @{"type"="ce_gauge_f";   "name"="LogicalDisk_total_Percent_Free_Space";         "label"="LogicalDisk Total % Free Space";             "unit"="Percent" },
      @{"type"="ce_gauge";     "name"="LogicalDisk_total_Current_Disk_Queue_Length";    "label"="LogicalDisk Total Current Disk Q Length";  "unit"="Items"},
      @{"type"="ce_gauge_f";   "name"="LogicalDisk_total_Percent_Disk_Time";            "label"="LogicalDisk Total % Disk Time";            "unit"="Percent"},
      @{"type"="ce_gauge_f";   "name"="LogicalDisk_total_Avg_Disk_Queue_Length";        "label"="LogicalDisk Total Avg Disk Q Length";      "unit"="Items"},
      @{"type"="ce_gauge_f";   "name"="LogicalDisk_total_Percent_Disk_Read_Time";        "label"="LogicalDisk Total % Disk Read Time";      "unit"="Percent"},
      @{"type"="ce_gauge_f";   "name"="LogicalDisk_total_Avg_Disk_Read_Queue_Length";   "label"="LogicalDisk Total Avg Disk Read Q Length";  "unit"="Items"},
      @{"type"="ce_gauge_f";   "name"="LogicalDisk_total_Percent_Disk_Write_Time";       "label"="LogicalDisk Total % Disk Write time";       "unit"="Percent"},
      @{"type"="ce_gauge_f";   "name"="LogicalDisk_total_Avg_Disk_Write_Queue_Length";  "label"="LogicalDisk Total Avg Disk Write Q Length";  "unit"="Items"},
      @{"type"="ce_gauge";     "name"="PhysicalDisk_total_Current_Disk_Queue_Length";    "label"="PhysicalDisk Total Current Disk Q Length";    "unit"="Items"},
      @{"type"="ce_gauge_f";   "name"="PhysicalDisk_total_Percent_Disk_Time";            "label"="PhysicalDisk Total % Disk Time";            "unit"="Percent"},
      @{"type"="ce_gauge_f";   "name"="PhysicalDisk_total_Avg_Disk_Queue_Length";       "label"="PhysicalDisk Total Avg Disk Q Length";       "unit"="Items"},
      @{"type"="ce_gauge_f";   "name"="PhysicalDisk_total_Percent_Disk_Read_Time";       "label"="PhysicalDisk Total % Disk Read Time";       "unit"="Percent"},
      @{"type"="ce_gauge_f";   "name"="PhysicalDisk_total_Avg_Disk_Read_Queue_Length";  "label"="PhysicalDisk Total Avg Disk Read Q Length";  "unit"="Items"},
      @{"type"="ce_gauge_f";   "name"="PhysicalDisk_total_Percent_Disk_Write_Time";      "label"="PhysicalDisk Total % Disk Write time";      "unit"="Percent"},
      @{"type"="ce_gauge_f";   "name"="PhysicalDisk_total_Avg_Disk_Write_Queue_Length";  "label"="PhysicalDisk Total Avg Disk Write Q Length";  "unit"="Items"}
      )

    $global:storage_group =  @{}
    $global:storage_group.add("name",$group_name)
    $global:storage_group.add("label",$group_label)
    $global:storage_group.add("frequency",$freq)
    $global:storage_group.add("MSpaths",[string[]]$mg_storage)

    $groupcfg = New-Object PSObject -Property @{
      "name" = $group_name;
      "label" = $group_label;
      "frequency" = $freq;
      "metrics" = $marray
    }
    $rslt = New-MetricGroup $group_name $global:versioned_storage_group_name $groupcfg
    if( $rslt -ne $null ) {
      $global:versioned_storage_group_name = $rslt
    }
  }

  #  create System Memory metric group
  if( $mg_memory -ne $null ) {

    $group_name = $global:memory_group_name
    $group_label = "System Memory"
    $freq = 60

    $groupcfg = $null

    $marray = @(
      @{"type"="ce_gauge_f";   "name"="Memory_Page_Faults_per_sec";   "label"="Memory Page Faults / sec";          "unit"="Page faults / sec"  },
      @{"type"="ce_gauge";     "name"="Memory_Available_Bytes";       "label"="Memory Available Bytes";         "unit"="Bytes"},
      @{"type"="ce_gauge";     "name"="Memory_Committed_Bytes";         "label"="Memory Committed Bytes";        "unit"="Bytes"},
      @{"type"="ce_gauge";     "name"="Memory_Commit_Limit";            "label"="Memory Commit Limit";       "unit"="Bytes"},
      @{"type"="ce_gauge_f";   "name"="Memory_Write_Copies_per_sec";      "label"="Memory Write Copies / sec";      "unit"="Copies / sec"},
      @{"type"="ce_gauge_f";   "name"="Memory_Cache_Faults_per_sec";       "label"="Memory Cache Faults / sec";     "unit"="Cache faults / sec"}
      )
    $global:memory_group =  @{}
    $global:memory_group.add("name",$group_name)
    $global:memory_group.add("label",$group_label)
    $global:memory_group.add("frequency",$freq)
    $global:memory_group.add("MSpaths",[string[]]$mg_memory)

    $groupcfg = New-Object PSObject -Property @{
      "name" = $group_name;
      "label" = $group_label;
      "frequency" = $freq;
      "metrics" = $marray
    }
    $rslt = New-MetricGroup $group_name $global:versioned_memory_group_name $groupcfg
    if( $rslt -ne $null ) {
      $global:versioned_memory_group_name = $rslt
    }
  }
  #  create System metric group
  if( $mg_system -ne $null ) {

    $group_name = $global:system_group_name
    $group_label = "System metrics"
    $freq = 60

    $groupcfg = $null

    $marray = @(
      @{"type"="ce_gauge_f";   "name"="Paging_File_total_Percent_Usage";      "label"="Paging File Total % Usage";        "unit"="Percent" },
      @{"type"="ce_gauge_f";   "name"="Paging_File_total_Percent_Usage_Peak";    "label"="Paging File Peak Total % Usage";      "unit"="Percent"},
      @{"type"="ce_gauge_f";   "name"="System_File_Read_Operations_per_sec";     "label"="System File Read Ops / sec";      "unit"="File Reads / sec"},
      @{"type"="ce_gauge_f";   "name"="System_File_Write_Operations_per_sec";     "label"="System File Write Ops / sec";      "unit"="File Writes / sec"},
      @{"type"="ce_gauge_f";   "name"="System_File_Control_Operations_per_sec";    "label"="System File Control Ops / sec";    "unit"="File Control Ops / sec"},
      @{"type"="ce_gauge_f";   "name"="System_Context_Switches_per_sec";          "label"="System Context Switches / sec";      "unit"="Context Switches / sec"},
      @{"type"="ce_gauge_f";     "name"="System_System_Calls_per_sec";             "label"="System Calls / sec";            "unit"="Sys calls / sec"},
      @{"type"="ce_counter";   "name"="System_System_Up_Time";                      "label"="System Uptime";                "unit"="seconds"},
      @{"type"="ce_gauge";   "name"="System_Processor_Queue_Length";                "label"="System Processor Q Length";   "unit"="Queued threads"},
      @{"type"="ce_gauge";   "name"="System_Processes";                              "label"="System Processes";           "unit"="processes"},
      @{"type"="ce_gauge";   "name"="System_Threads";                                "label"="System Threads";              "unit"="Threads"},
      @{"type"="ce_gauge_f";   "name"="System_Exception_Dispatches_per_sec";         "label"="System Exceptions / Sec";     "unit"="Exceptions / sec"}
      )

    $global:system_group =  @{}
    $global:system_group.add("name",$group_name)
    $global:system_group.add("label",$group_label)
    $global:system_group.add("frequency",$freq)
    $global:system_group.add("MSpaths",[string[]]$mg_system)

    $groupcfg = New-Object PSObject -Property @{
      "name" = $group_name;
      "label" = $group_label;
      "frequency" = $freq;
      "metrics" = $marray
    }
    $rslt = New-MetricGroup $group_name $global:versioned_system_group_name $groupcfg
    if( $rslt -ne $null ) {
      $global:versioned_system_group_name = $rslt
    }
  }
  #  create Web Services metric group

  if( $mg_webservices -ne $null ) {

    $group_name = $global:web_group_name
    $group_label = "Web Services metrics"
    $freq = 60

    $groupcfg = $null

    $marray = @(
      @{"type"="ce_gauge";   "name"="Web_Service_total_Current_Connections";     "label"="Web Services Total Connections";        "unit"="Connections" },
      @{"type"="ce_gauge_f";   "name"="Web_Service_total_Get_Requests_per_sec";    "label"="Web Services Total GET Reqs / sec";      "unit"="Requests / sec"},
      @{"type"="ce_gauge_f";   "name"="Web_Service_total_Post_Requests_per_sec";    "label"="Web Services Total POST Reqs / sec";     "unit"="Requests / sec"},
      @{"type"="ce_gauge_f";   "name"="Web_Service_total_Put_Requests_per_sec";     "label"="Web Services Total PUT Reqs / sec";     "unit"="Requests / sec"},
      @{"type"="ce_gauge_f";   "name"="Web_Service_total_Delete_Requests_per_sec";    "label"="Web Services Total DELETE Reqs / sec";   "unit"="Requests / sec"},
      @{"type"="ce_gauge_f";   "name"="Web_Service_total_Trace_Requests_per_sec";     "label"="Web Services Total TRACE Reqs / sec";   "unit"="Requests / sec"}
      )

    $global:web_group =  @{}
    $global:web_group.add("name",$group_name)
    $global:web_group.add("label",$group_label)
    $global:web_group.add("frequency",$freq)
    $global:web_group.add("MSpaths",[string[]]$mg_webservices)

    $groupcfg = New-Object PSObject -Property @{
      "name" = $group_name;
      "label" = $group_label;
      "frequency" = $freq;
      "metrics" = $marray
    }
    $rslt = New-MetricGroup $group_name $global:versioned_web_group_name $groupcfg
    if( $rslt -ne $null ) {
      $global:versioned_web_group_name = $rslt
    }
  }

  #  create UserDefined metric group
  # Currently, you have to create the $marray table manually.

  if( $mg_custom -ne $null ) {

    $group_name = $global:custom_group_name
    $group_label = "User Defined Metrics"

	# *** NOTE: we're only checking this metric every 10 minutes
    $freq = 600
    $groupcfg = $null

    $marray = @(
      @{"type"="ce_gauge_f";   "name"="UserDefined_Hours_From_Last_Backup";   "label"="Hours from Last Backup";    "unit"="Hours" },
      @{"type"="ce_gauge";      "name"="UserDefined_Last_Backup_Result";       "label"="Last Backup Result";  }
      )

    $global:custom_group =  @{}
    $global:custom_group.add("name",$group_name)
    $global:custom_group.add("label",$group_label)
    $global:custom_group.add("frequency",$freq)
    $global:custom_group.add("CE_Variables",[string[]]$ce_custom)

    $groupcfg = New-Object PSObject -Property @{
      "name" = $group_name;
      "label" = $group_label;
      "frequency" = $freq;
      "metrics" = $marray
    }
    $rslt = New-MetricGroup $group_name $global:versioned_custom_group_name $groupcfg
    if( $rslt -ne $null ) {
      $global:versioned_custom_group_name = $rslt
    }
  }


  #Update the win_counters.txt file
  $fn = $global:mypath + "\win_counters.txt"
  $CounterList = Get-Content $fn
  $i = 0
  while( $i -lt $CounterList.Length ) {
    $line = $CounterList[$i]
    if( $line.StartsWith("[metric_group]") -eq $True ) {
      $mg = $line.Substring(14)
      if( $mg.Contains(",") ) {
        $mg = $mg.Substring(0,$mg.IndexOf(","))
      }
      if($mg -eq $global:aspnet_group_name) {
        $CounterList[$i] = '[metric_group]' + $global:aspnet_group_name + ',' + $global:versioned_aspnet_group_name
      }
      elseif( $mg -eq $global:netclr_group_name) {
        $CounterList[$i] = '[metric_group]' + $global:netclr_group_name + ',' + $global:versioned_netclr_group_name
      }
      elseif($mg -eq $global:mssql_group_name) {
        $CounterList[$i] = '[metric_group]' + $global:mssql_group_name + ',' + $global:versioned_mssql_group_name
      }
      elseif($mg -eq $global:storage_group_name) {
        $CounterList[$i] = '[metric_group]' + $global:storage_group_name + ',' + $global:versioned_storage_group_name
      }
      elseif($mg -eq $global:memory_group_name) {
        $CounterList[$i] = '[metric_group]' + $global:memory_group_name + ',' + $global:versioned_memory_group_name
      }
      elseif($mg -eq $global:system_group_name) {
        $CounterList[$i] = '[metric_group]' + $global:system_group_name + ',' + $global:versioned_system_group_name
      }
      elseif($mg -eq $global:web_group_name) {
        $CounterList[$i] = '[metric_group]' + $global:web_group_name + ',' + $global:versioned_web_group_name
      }
      elseif($mg -eq $global:custom_group_name) {
        $CounterList[$i] = '[metric_group]' + $global:custom_group_name + ',' + $global:versioned_custom_group_name
      }
    }
    $i++
  }
  $CounterList | Out-File $fn
}
