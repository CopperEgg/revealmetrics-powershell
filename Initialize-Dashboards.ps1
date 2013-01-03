#
#	Initialize-Dashboards.ps1 contains sample code for creating a default set of dashboards.
# Copyright (c) 2012 CopperEgg Corporation. All rights reserved.
#
function Initialize-Dashboards {
  # create MSSQL dash
  $dash_name = "MSSQL Monitoring"
  $dashcfg = $null

  $widgets = @{
    "0" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:mssql_group_name, "0", "MSSQL_SQLEXPRESS_Buffer_Manager_Buffer_cache_hit_ratio");
          "match_param"=[string]$global:computer
          };
    "1" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:mssql_group_name, "1", "MSSQL_SQLEXPRESS_Buffer_Manager_Checkpoint_pages_per_sec");
          "match_param"=[string]$global:computer
          };
    "2" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:mssql_group_name, "2", "MSSQL_SQLEXPRESS_Buffer_Manager_Page_life_expectancy");
          "match_param"=[string]$global:computer
          };
    "3" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:mssql_group_name, "3", "MSSQL_SQLEXPRESS_General_Statistics_User_Connections");
          "match_param"=[string]$global:computer
          };
    "4" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:mssql_group_name, "4", "MSSQL_SQLEXPRESS_Access_Methods_Page_Splits_per_sec");
          "match_param"=[string]$global:computer
          };
    "5" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:mssql_group_name, "5", "MSSQL_SQLEXPRESS_General_Statistics_Processes_blocked");
          "match_param"=[string]$global:computer
          };
    "6" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:mssql_group_name, "6", "MSSQL_SQLEXPRESS_SQL_Statistics_Batch_Requests_per_sec");
          "match_param"=[string]$global:computer
          };
    "7" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:mssql_group_name, "7", "MSSQL_SQLEXPRESS_SQL_Statistics_SQL_Compilations_per_sec");
          "match_param"=[string]$global:computer
          };
    "8" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:mssql_group_name, "8", "MSSQL_SQLEXPRESS_SQL_Statistics_SQL_Re-Compilations_per_sec");
          "match_param"=[string]$global:computer
          }
  }
  $order = @( "0","1","2","3","4","5","6","7","8" )

  $dashcfg = New-Object PSObject -Property @{
    "name" = $dash_name;
    "data" = @{"widgets" = $widgets; "order" = $order}
  }
  $result = New-Dashboard $dash_name $dashcfg

  # create MS ASP.NET dash
  $dash_name = "ASP.NET Monitoring"
  $dashcfg = $null

  $widgets = @{
    "0" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:aspnet_group_name, "0", "ASPNET_Applications_Running");
          "match_param"=[string]$global:computer
          };
    "1" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:aspnet_group_name, "1", "ASPNET_Requests_Rejected");
          "match_param"=[string]$global:computer
          };
    "2" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:aspnet_group_name, "2", "ASPNET_Requests_Queued");
          "match_param"=[string]$global:computer
          };
    "3" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:aspnet_group_name, "3", "ASPNET_Worker_Processes_Running");
          "match_param"=[string]$global:computer
          };
    "4" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:aspnet_group_name, "4", "ASPNET_Worker_Process_Restarts");
          "match_param"=[string]$global:computer
          };
    "5" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:aspnet_group_name, "5", "ASPNET_Request_Wait_Time");
          "match_param"=[string]$global:computer
          };
    "6" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:aspnet_group_name, "6", "ASPNET_Requests_Current");
          "match_param"=[string]$global:computer
          };
    "7" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:aspnet_group_name, "7", "ASPNET_Error_Events_Raised");
          "match_param"=[string]$global:computer
          };
    "8" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:aspnet_group_name, "8", "ASPNET_Request_Error_Events_Raised");
          "match_param"=[string]$global:computer
          };
    "9" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:aspnet_group_name, "9", "ASPNET_Infrastructure_Error_Events_Raised");
          "match_param"=[string]$global:computer
          };
    "10" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:aspnet_group_name, "10", "ASPNET_Requests_In_Native_Queue");
          "match_param"=[string]$global:computer
          }

  }
  $order = @( "0","1","2","3","4","5","6","7","8", "9", "10" )

  $dashcfg = New-Object PSObject -Property @{
    "name" = $dash_name;
    "data" = @{"widgets" = $widgets; "order" = $order}
  }
  $result = New-Dashboard $dash_name $dashcfg

  # create .NET CLR dash
  $dash_name = "MS .NET CLR Monitoring"
  $dashcfg = $null

  $widgets = @{
    "0" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:netclr_group_name, "0", "NET_CLR_Exceptions_global_Number_of_Exceps_Thrown");
          "match_param"=[string]$global:computer
          };
    "1" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:netclr_group_name, "1", "NET_CLR_Exceptions_global_Number_of_Exceps_Thrown_per_sec");
          "match_param"=[string]$global:computer
          };
    "2" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:netclr_group_name, "2", "NET_CLR_Memory_global_Number_GC_Handles");
          "match_param"=[string]$global:computer
          };
    "3" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:netclr_group_name, "3", "NET_CLR_Memory_global_Allocated_Bytes_per_sec");
          "match_param"=[string]$global:computer
          };
    "4" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:netclr_group_name, "4", "NET_CLR_Memory_global_Number_Total_committed_Bytes");
          "match_param"=[string]$global:computer
          }
  }
  $order = @( "0","1","2","3","4" )

  $dashcfg = New-Object PSObject -Property @{
    "name" = $dash_name;
    "data" = @{"widgets" = $widgets; "order" = $order}
  }
  $result = New-Dashboard $dash_name $dashcfg

  # create Storage dash
  $dash_name = "MS Storage Monitoring"
  $dashcfg = $null

  $widgets = @{
    "0" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:storage_group_name, "0", "LogicalDisk_total_Percent_Free_Space");
          "match_param"=[string]$global:computer
          };
    "1" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:storage_group_name, "1", "LogicalDisk_total_Current_Disk_Queue_Length");
          "match_param"=[string]$global:computer
          };
    "2" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:storage_group_name, "2", "LogicalDisk_total_Percent_Disk_Time");
          "match_param"=[string]$global:computer
          };
    "3" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:storage_group_name, "3", "LogicalDisk_total_Avg_Disk_Queue_Length");
          "match_param"=[string]$global:computer
          };
    "4" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:storage_group_name, "4", "LogicalDisk_total_Percent_Disk_Read_Time");
          "match_param"=[string]$global:computer
          };
    "5" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:storage_group_name, "5", "LogicalDisk_total_Avg_Disk_Read_Queue_Length");
          "match_param"=[string]$global:computer
          };
    "6" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:storage_group_name, "6", "LogicalDisk_total_Percent_Disk_Write_Time");
          "match_param"=[string]$global:computer
          };
    "7" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:storage_group_name, "7", "LogicalDisk_total_Avg_Disk_Write_Queue_Length");
          "match_param"=[string]$global:computer
          };
    "8" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:storage_group_name, "8", "PhysicalDisk_total_Current_Disk_Queue_Length");
          "match_param"=[string]$global:computer
          };
    "9" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:storage_group_name, "9", "PhysicalDisk_total_Percent_Disk_Time");
          "match_param"=[string]$global:computer
          };
    "10" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:storage_group_name, "10", "PhysicalDisk_total_Avg_Disk_Queue_Length");
          "match_param"=[string]$global:computer
          };
    "11" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:storage_group_name, "11", "PhysicalDisk_total_Percent_Disk_Read_Time");
          "match_param"=[string]$global:computer
          };
    "12" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:storage_group_name, "12", "PhysicalDisk_total_Avg_Disk_Read_Queue_Length");
          "match_param"=[string]$global:computer
          };
    "13" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:storage_group_name, "13", "PhysicalDisk_total_Percent_Disk_Write_Time");
          "match_param"=[string]$global:computer
          };
    "14" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:storage_group_name, "14", "PhysicalDisk_total_Avg_Disk_Write_Queue_Length");
          "match_param"=[string]$global:computer
          }
  }
  $order = @( "0","1","2","3","4","5","6","7","8","9","10","11","12","13","14" )

  $dashcfg = New-Object PSObject -Property @{
    "name" = $dash_name;
    "data" = @{"widgets" = $widgets; "order" = $order}
  }
  $result = New-Dashboard $dash_name $dashcfg


  # create System Memory dash
  $dash_name = "MS System Memory Monitoring"
  $dashcfg = $null

  $widgets = @{
    "0" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:memory_group_name, "0", "Memory_Page_Faults_per_sec");
          "match_param"=[string]$global:computer
          };
    "1" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:memory_group_name, "1", "Memory_Available_Bytes");
          "match_param"=[string]$global:computer
          };
    "2" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:memory_group_name, "2", "Memory_Committed_Bytes");
          "match_param"=[string]$global:computer
          };
    "3" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:memory_group_name, "3", "Memory_Commit_Limit");
          "match_param"=[string]$global:computer
          };
    "4" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:memory_group_name, "4", "Memory_Write_Copies_per_sec");
          "match_param"=[string]$global:computer
          };
    "5" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:memory_group_name, "5", "Memory_Cache_Faults_per_sec");
          "match_param"=[string]$global:computer
          }
  }
  $order = @( "0","1","2","3","4","5" )

  $dashcfg = New-Object PSObject -Property @{
    "name" = $dash_name;
    "data" = @{"widgets" = $widgets; "order" = $order}
  }
  $result = New-Dashboard $dash_name $dashcfg

  # create System dash
  $dash_name = "MS System Monitoring"
  $dashcfg = $null

  $widgets = @{
    "0" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:system_group_name, "0", "Paging_File_total_Percent_Usage");
          "match_param"=[string]$global:computer
          };
    "1" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:system_group_name, "1", "Paging_File_total_Percent_Usage_Peak");
          "match_param"=[string]$global:computer
          };
    "2" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:system_group_name, "2", "System_File_Read_Operations_per_sec");
          "match_param"=[string]$global:computer
          };
    "3" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:system_group_name, "3", "System_File_Write_Operations_per_sec");
          "match_param"=[string]$global:computer
          };
    "4" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:system_group_name, "4", "System_File_Control_Operations_per_sec");
          "match_param"=[string]$global:computer
          };
    "5" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:system_group_name, "5", "System_Context_Switches_per_sec");
          "match_param"=[string]$global:computer
          };
    "6" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:system_group_name, "6", "System_System_Calls_per_sec");
          "match_param"=[string]$global:computer
          };
    "7" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:system_group_name, "7", "System_System_Up_Time");
          "match_param"=[string]$global:computer
          };
    "8" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:system_group_name, "8", "System_Processor_Queue_Length");
          "match_param"=[string]$global:computer
          };
    "9" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:system_group_name, "9", "System_Processes");
          "match_param"=[string]$global:computer
          };
    "10" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:system_group_name, "10", "System_Threads");
          "match_param"=[string]$global:computer
          };
    "11" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:system_group_name, "11", "System_Exception_Dispatches_per_sec");
          "match_param"=[string]$global:computer
          }
  }
  $order = @( "0","1","2","3","4","5","6","7","8","9","10","11" )

  $dashcfg = New-Object PSObject -Property @{
    "name" = $dash_name;
    "data" = @{"widgets" = $widgets; "order" = $order}
  }
  $result = New-Dashboard $dash_name $dashcfg

  # create Web Services dash
  $dash_name = "MS Web Services Monitoring"
  $dashcfg = $null

  $widgets = @{
    "0" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:web_group_name, "0", "Web_Service_total_Current_Connections");
          "match_param"=[string]$global:computer
          };
    "1" = @{
          "type"="metric";
          "style"="both";
          "match"="select";
          "metric" = @($global:web_group_name, "1", "Web_Service_total_Get_Requests_per_sec");
          "match_param"=[string]$global:computer
          };
    "2" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:web_group_name, "2", "Web_Service_total_Post_Requests_per_sec");
          "match_param"=[string]$global:computer
          };
    "3" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:web_group_name, "3", "Web_Service_total_Put_Requests_per_sec");
          "match_param"=[string]$global:computer
          };
    "4" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:web_group_name, "4", "Web_Service_total_Delete_Requests_per_sec");
          "match_param"=[string]$global:computer
          };
    "5" = @{
          "type"="metric";
          "style"="value";
          "match"="select";
          "metric" = @($global:web_group_name, "5", "Web_Service_total_Trace_Requests_per_sec");
          "match_param"=[string]$global:computer
          }
  }
  $order = @( "0","1","2","3","4","5" )

  $dashcfg = New-Object PSObject -Property @{
    "name" = $dash_name;
    "data" = @{"widgets" = $widgets; "order" = $order}
  }
  $result = New-Dashboard $dash_name $dashcfg
}
