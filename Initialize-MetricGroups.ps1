#
#	Initialize-MetricGroups.ps1 contains sample code for creating a default set of metric groups.
# Copyright (c) 2012 CopperEgg Corporation. All rights reserved.
#
function Initialize-MetricGroups {
  [string]$global:aspnet_group_name = "ASP_NET"
  [string]$global:netclr_group_name = "NET_CLR"
  [string]$global:mssql_group_name = "MSSQL"
  [string]$global:storage_group_name = "Storage"
  [string]$global:memory_group_name = "System_Memory"
  [string]$global:system_group_name = "System"
  [string]$global:web_group_name = "Web_Services"
  $global:aspnet_group =  @{}
  $global:netclr_group =  @{}
  $global:mssql_group =  @{}
  $global:storage_group =  @{}
  $global:memory_group =  @{}
  $global:system_group =  @{}
  $global:web_group =  @{}
  $global:master_hash = @{}

  #
  # Read in win_counters.txt
  # That file contains the counters that CopperEgg chose as defaults to get started.
  #

  $fn = $global:mypath + "\win_counters.txt"
  $CounterList = Get-Content $fn

  [string[]]$mg_asp_net = @()
  [string[]]$mg_net_clr = @()
  [string[]]$mg_mssql = @()
  [string[]]$mg_logicaldisk = @()
  [string[]]$mg_physicaldisk = @()
  [string[]]$mg_memory = @()
  [string[]]$mg_pagingfile = @()
  [string[]]$mg_system = @()
  [string[]]$mg_webservices = @()
  [string[]]$mg_ipv4 = @()

  # NOTE: Remove-CounterInstances replaces the '*' in 'PathsWithInstances' with a 'total' instance, where possible.
  # This was done to avoid creating a huge number of default metrics.

  foreach($counter in $CounterList) {
    if ( $counter.Contains("ASP.NET") )
      { $mg_asp_net = $mg_asp_net + (Remove-CounterInstances($counter)) }

    if ( $counter.Contains(".NET CLR") )
      { $mg_net_clr = $mg_net_clr + (Remove-CounterInstances($counter))}

    if ( $counter.Contains("MSSQL") )
      { $mg_mssql = $mg_mssql + (Remove-CounterInstances($counter)) }

    if ( $counter.Contains("LogicalDisk") )
      { $mg_logicaldisk = $mg_logicaldisk + (Remove-CounterInstances($counter)) }

    if ( $counter.Contains("PhysicalDisk") )
      { $mg_physicaldisk = $mg_physicaldisk + (Remove-CounterInstances($counter))}

    if ( $counter.Contains("\Memory") )
      { $mg_memory  = $mg_memory + (Remove-CounterInstances($counter)) }

    if ( $counter.Contains("Paging File") )
      { $mg_pagingfile = $mg_pagingfile +(Remove-CounterInstances($counter)) }

    if ( $counter.Contains("System") )
      { $mg_system = $mg_system + (Remove-CounterInstances($counter)) }

    if ( $counter.Contains("Web Service") )
      { $mg_webservices = $mg_webservices + (Remove-CounterInstances($counter))}
  }

  $ce_asp_net = @()
  $ce_net_clr = @()
  $ce_mssql = @()
  $ce_logicaldisk = @()
  $ce_physicaldisk = @()
  $ce_memory = @()
  $ce_pagingfile = @()
  $ce_system = @()
  $ce_webservices = @()
  $ce_ipv4 = @()
  [string]$path = $null

  if( $mg_asp_net -ne $null) {
    foreach( $path in $mg_asp_net) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_asp_net =  $ce_asp_net + $name
    }
  }
  if( $mg_net_clr -ne $null) {
    foreach( $path in $mg_net_clr) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_net_clr = $ce_net_clr + $name
    }
  }
  if( $mg_mssql -ne $null) {
    foreach( $path in $mg_mssql) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_mssql =  $ce_mssql + $name
    }
  }
  if( $mg_logicaldisk -ne $null) {
    foreach( $path in $mg_logicaldisk) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_logicaldisk =  $ce_logicaldisk + $name
    }
  }
  if( $mg_physicaldisk -ne $null) {
    foreach( $path in $mg_physicaldisk ) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_physicaldisk =  $ce_physicaldisk + $name
    }
  }
  if( $mg_memory -ne $null) {
    foreach( $path in $mg_memory) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_memory =  $ce_memory + $name
    }
  }
  if( $mg_pagingfile -ne $null) {
    foreach( $path in $mg_pagingfile) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_pagingfile =  $ce_pagingfile + $name
    }
  }
  if( $mg_system -ne $null) {
    foreach( $path in $mg_system) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_system =  $ce_system + $name }
  }
  if( $mg_webservices -ne $null) {
    foreach( $path in $mg_webservices) {
      $name = (ConvertTo-CEName($path))
      $global:master_hash.Add($path.ToLower(),$name)
      $ce_webservices =  $ce_webservices + $name
    }
  }

  $ce_storage = $ce_logicaldisk + $ce_physicaldisk
  $ce_system = $ce_pagingfile + $ce_system

  [string[]]$mg_storage = $mg_logicaldisk + $mg_physicaldisk
  [string[]]$mg_system = $mg_pagingfile + $mg_system

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

  # The necessary structures and variables are set up.
  # Now we'll create corresponding metric groups at CopperEgg

  #  create asp.net metric group

  $group_name = "ASP_NET"
  $group_label = "ASP.NET metrics"
  $freq = 15
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
  $rslt = New-MetricGroup $group_name $groupcfg
  if( $rslt -ne $null ) {
    $global:aspnet_group_name = $rslt
  }

  #   create .net clr metric group

  $group_name = "NET_CLR"
  $group_label = ".NET CLR metrics"
  $freq = 15

  $marray = @(
    @{"type"="ce_counter";   "name"="NET_CLR_Exceptions_global_Number_of_Exceps_Thrown";           "label"=".NET Global Number of Exceptions";  "unit"="Exceptions"},
    @{"type"="ce_gauge_f";   "name"="NET_CLR_Exceptions_global_Number_of_Exceps_Thrown_per_sec";  "label"=".NET Global Exceptions / sec";     "unit"="Exceptions / sec"},
    @{"type"="ce_gauge";     "name"="NET_CLR_Memory_global_Number_GC_Handles";        "label"=".NET Global GC Handles";        "unit"="Handles"},
    @{"type"="ce_gauge_f";   "name"="NET_CLR_Memory_global_Allocated_Bytes_per_sec";     "label"=".NET Global Allocated Bytes / sec";      "unit"="Bytes / sec"},
    @{"type"="ce_gauge";     "name"="NET_CLR_Memory_global_Number_Total_committed_Bytes"; "label"=".NET Global Total Committed Bytes";       "unit"="Bytes"}
    )


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
  $rslt = New-MetricGroup $group_name $groupcfg
  if( $rslt -ne $null ) {
    $global:netclr_group_name = $rslt
  }
  #  create mssql metric group

  $group_name = "MSSQL"
  $group_label = "MSSQL metrics"
  $freq = 15

  $groupcfg = $null

  $marray = @(
    @{"type"="ce_gauge_f";   "name"="MSSQL_SQLEXPRESS_Buffer_Manager_Buffer_cache_hit_ratio"; "label"="MSSQL Buffer cache hit ratio";   },
    @{"type"="ce_gauge_f";   "name"="MSSQL_SQLEXPRESS_Buffer_Manager_Checkpoint_pages_per_sec";  "label"="MSSQL Checkpoint pages / sec";   "unit"="Pages / sec"},
    @{"type"="ce_gauge_f";   "name"="MSSQL_SQLEXPRESS_Buffer_Manager_Page_life_expectancy";     "label"="MSSQL Page life expectancy";    "unit"="Seconds"},
    @{"type"="ce_gauge";     "name"="MSSQL_SQLEXPRESS_General_Statistics_User_Connections";     "label"="MSSQL User Connections";    "unit"="Connections"},
    @{"type"="ce_gauge_f";   "name"="MSSQL_SQLEXPRESS_Access_Methods_Page_Splits_per_sec";       "label"="MSSQL Page Splits / sec";   "unit"="Page_splits / sec"},
    @{"type"="ce_gauge";     "name"="MSSQL_SQLEXPRESS_General_Statistics_Processes_blocked";     "label"="MSSQL Processes blocked";  "unit"="Processes"},
    @{"type"="ce_gauge_f";   "name"="MSSQL_SQLEXPRESS_SQL_Statistics_Batch_Requests_per_sec";     "label"="MSSQL Batch Requests / sec";  "unit"="Requests / sec"},
    @{"type"="ce_gauge_f";   "name"="MSSQL_SQLEXPRESS_SQL_Statistics_SQL_Compilations_per_sec";    "label"="MSSQL SQL Compilations / sec"; "unit"="Compilations / sec"},
    @{"type"="ce_gauge_f";   "name"="MSSQL_SQLEXPRESS_SQL_Statistics_SQL_Re-Compilations_per_sec"; "label"="MSSQL SQL Re-Compilations / sec"; "unit"="Re-Compilations / sec"}
    )

  $global:mssql_group.add("name",$group_name)
  $global:mssql_group.add("label",$group_label)
  $global:mssql_group.add("frequency",$freq)
  $global:mssql_group.add("MSpaths",[string[]]$mg_mssql)

  $groupcfg = New-Object PSObject -Property @{
    "name" = $group_name;
    "label" = $group_label;
    "frequency" = $freq;
    "metrics" = $marray
  }
  $rslt = New-MetricGroup $group_name $groupcfg
  if( $rslt -ne $null ) {
     $global:mssql_group_name = $rslt
  }

  #  create Storage metric group

  $group_name = "Storage"
  $group_label = "Storage metrics"
  $freq = 15

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
  $rslt = New-MetricGroup $group_name $groupcfg
  if( $rslt -ne $null ) {
    $global:storage_group_name = $rslt
  }


  #  create System Memory metric group

  $group_name = "System_Memory"
  $group_label = "System Memory"
  $freq = 15

  $groupcfg = $null

  $marray = @(
    @{"type"="ce_gauge_f";   "name"="Memory_Page_Faults_per_sec";   "label"="Memory Page Faults / sec";          "unit"="Page faults / sec"  },
    @{"type"="ce_gauge";     "name"="Memory_Available_Bytes";       "label"="Memory Available Bytes";         "unit"="Bytes"},
    @{"type"="ce_gauge";     "name"="Memory_Committed_Bytes";         "label"="Memory Committed Bytes";        "unit"="Bytes"},
    @{"type"="ce_gauge";     "name"="Memory_Commit_Limit";            "label"="Memory Commit Limit";       "unit"="Bytes"},
    @{"type"="ce_gauge_f";   "name"="Memory_Write_Copies_per_sec";      "label"="Memory Write Copies / sec";      "unit"="Copies / sec"},
    @{"type"="ce_gauge_f";   "name"="Memory_Cache_Faults_per_sec";       "label"="Memory Cache Faults / sec";     "unit"="Cache faults / sec"}
    )

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
  $rslt = New-MetricGroup $group_name $groupcfg
  if( $rslt -ne $null ) {
    $global:memory_group_name = $rslt
  }

  #  create System metric group

  $group_name = "System"
  $group_label = "System metrics"
  $freq = 15

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
    @{"type"="ce_gauge";   "name"="System_Processes";                              "label"="System Processors";           "unit"="processes"},
    @{"type"="ce_gauge";   "name"="System_Threads";                                "label"="System Threads";              "unit"="Threads"},
    @{"type"="ce_gauge_f";   "name"="System_Exception_Dispatches_per_sec";         "label"="System Exceptions / Sec";     "unit"="Exceptions / sec"}
    )

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
  $rslt = New-MetricGroup $group_name $groupcfg
  if( $rslt -ne $null ) {
    $global:system_group_name = $rslt
  }

  #  create Web Services metric group

  $group_name = "Web_Services"
  $group_label = "Web Services metrics"
  $freq = 15

  $groupcfg = $null

  $marray = @(
    @{"type"="ce_gauge";   "name"="Web_Service_total_Current_Connections";     "label"="Web Services Total Connections";        "unit"="Connections" },
    @{"type"="ce_gauge_f";   "name"="Web_Service_total_Get_Requests_per_sec";    "label"="Web Services Total GET Reqs / sec";      "unit"="Requests / sec"},
    @{"type"="ce_gauge_f";   "name"="Web_Service_total_Post_Requests_per_sec";    "label"="Web Services Total POST Reqs / sec";     "unit"="Requests / sec"},
    @{"type"="ce_gauge_f";   "name"="Web_Service_total_Put_Requests_per_sec";     "label"="Web Services Total PUT Reqs / sec";     "unit"="Requests / sec"},
    @{"type"="ce_gauge_f";   "name"="Web_Service_total_Delete_Requests_per_sec";    "label"="Web Services Total DELETE Reqs / sec";   "unit"="Requests / sec"},
    @{"type"="ce_gauge_f";   "name"="Web_Service_total_Trace_Requests_per_sec";     "label"="Web Services Total TRACE Reqs / sec";   "unit"="Requests / sec"}
    )


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
  $rslt = New-MetricGroup $group_name $groupcfg
  if( $rslt -ne $null ) {
    $global:web_group_name = $rslt
  }
}  
