#
#	UserDefined.psm1 contains functions for retrieving metrics that may not be available using Get-Counter.
#
#	The three functions included here are provided as an example of creating your own metrics to monitor.
#	The second two functions retrieve the LastTaskResult and the LastRunTime of a task run by the TaskScheculer.
# Copyright (c) 2012 CopperEgg Corporation. All rights reserved.
#
#  When you create your own UserDefined metrics, you will need to specify the new metric in the
# win_counters.txt file, in the UserDefine metric group; AND you will need to create a corresponding function
# for each of the metrics, named the same as the metric, woith the letters '_function' appended. See below.
#
# To enable the sample UsedDefined metrics, you should uncomment the UserDefined metric group and associated metrics,
# and Replace "MyTask" with the name of the background task you want to monitor.
#
# Copyright (c) 2012 CopperEgg Corporation. All rights reserved.
#

$TaskToMonitor = "\MyTask"

function Get-LastRunDetail {
param(
  [string]$taskName
)
$computerName = $ENV:COMPUTERNAME
$taskService = new-object -comobject "Schedule.Service"
$taskService.Connect($computerName)
$taskFolder = $taskService.GetFolder("\")
$registeredTask = $taskFolder.GetTask($taskName)
return $registeredTask
}
Export-ModuleMember -function Get-LastRunDetail

function UserDefined_Hours_From_Last_Backup_function {
  $tmp = Get-LastRunDetail($TaskToMonitor)
  [DateTime]$tnow = [System.DateTime]::Now
  $dif = $tnow - $tmp.LastRunTime
  return $dif.TotalHours
}
Export-ModuleMember -function UserDefined_Hours_From_Last_Backup_function

function UserDefined_Last_Backup_Result_function {
  $tmp = Get-LastRunDetail($TaskToMonitor)
  return $tmp.LastTaskResult
}
Export-ModuleMember -function UserDefined_Last_Backup_Result_function