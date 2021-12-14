# Tactical RMM PS Module
This is a simple PS Module outlining what the tactical RMM API can do. Most of this is likely subject to change as the API evolves, but currently, you can use this module to list clients/sites/agents, create clients/sites, and invoke commands on agents, with returned output.


# Install
```
Install-Module -Name TacticalRMMPS 
```

# Commands


## Connect-TRMM

```
Connect-TRMM -APIKey (API key) -URL "https://api.domain.com"
```

It should return the following:

```
Connected to https://api.domain.com
```


## Get-TRMMClients
Pretty simple. Just lists all clients. You can filter with the "-Name" and "-CompanyID" flag, to only return detailed info about that one client

```
Get-TRMMClients -ClientID 2
```

Output would look like this:
```
id                       : 2
name                     : Testing Customer
server_policy            :
workstation_policy       :
alert_template           :
block_policy_inheritance : False
sites                    : {@{id=2; name=Testing Customer; server_policy=; workstation_policy=; alert_template=;
                           client_name=Testing Customer; client=2; custom_fields=System.Object[]; agent_count=0;
                           block_policy_inheritance=False; maintenance_mode=False; failing_checks=}, @{id=3; name=Test
                           site 2; server_policy=; workstation_policy=; alert_template=; client_name=Testing Customer;
                           client=2; custom_fields=System.Object[]; agent_count=0; block_policy_inheritance=False;
                           maintenance_mode=False; failing_checks=}}
custom_fields            : {}
agent_count              : 0
maintenance_mode         : False
failing_checks           : @{error=False; warning=False}
```

## Get-TRMMSites
Shows a list of sites. Can filter with the -SiteID flag, to only show the one site.

```
Get-TRMMSites -SiteID 2
```

This just filters the output a bit, to just the asset name, and the ID.

Output:
```
id                       : 3
name                     : Test site 2
server_policy            :
workstation_policy       :
alert_template           :
client_name              : Testing Customer
client                   : 2
custom_fields            : {}
agent_count              : 0
block_policy_inheritance : False
maintenance_mode         : False
failing_checks           : @{error=False; warning=False}
```

You can also get the layout of a specific ID, using the "-LayoutID" flag. This can be useful for designing automated asset creations for fields that aren't just "text" (like dropdowns)

```
(Get-HuduAssetLayouts -LayoutID 3).fields | select label, required, field_type, options, hint
```

## Get-TRMMAgents

Returns ALL agents globally. Unfortunately, there's no client/site filtering on the API endpoint side, so I didn't add filtering options, since it won't speed up the request at all. You can specify a singular AgentID and it will only show info about that agent.

```
Get-TRMMAgents -AgentID 
```

Output:
```
winupdatepolicy          : {@{id=1; created_by=; created_time=Dec-14-2021 - 16:34; modified_by=;
                           modified_time=Dec-14-2021 - 16:34; critical=inherit; important=inherit; moderate=inherit;
                           low=inherit; other=inherit; run_time_hour=3; run_time_frequency=inherit;
                           run_time_days=System.Object[]; run_time_day=1; reboot_after_install=inherit;
                           reprocess_failed_inherit=True; reprocess_failed=False; reprocess_failed_times=5;
                           email_if_fail=False; agent=1; policy=}}
status                   : online
cpu_model                : {Intel(R) Xeon(R) Platinum 8259CL CPU @ 2.50GHz}
local_ips                : 172.31.15.1
make_model               : Amazon EC2 t3.micro
physical_disks           : {NVMe Amazon Elastic B SCSI Disk Device 50GB SCSI}
graphics                 : Microsoft Basic Display Adapter
checks                   : @{total=0; passing=0; failing=0; warning=0; info=0; has_failing_checks=False}
timezone                 : America/Los_Angeles
all_timezones            : {Africa/Abidjan, Africa/Accra, Africa/Addis_Ababa, Africa/Algiers...}
client                   : NoodleShip
site_name                : AWS
custom_fields            : {@{id=1; field=1; agent=1; value=352118bb-5e6f-422b-b95a-86de064179d0}}
patches_last_installed   :
last_seen                : 2021-12-14T19:53:24.954889Z
created_by               :
created_time             : Dec-14-2021 - 16:34
modified_by              :
modified_time            : Dec-14-2021 - 16:34
version                  : 1.7.1
salt_ver                 : 1.0.3
operating_system         : Windows Server 2019 Datacenter, 64 bit v1809 (build 17763.2300)
plat                     : windows
plat_release             :
hostname                 : DC01
salt_id                  : DC01-1
local_ip                 :
agent_id                 : xGquELTJRrzeXyxLJhssARtWnxsxHIFLRGkNWggk
services                 : {@{pid=0; name=AJRouter; status=stopped; binpath=C:\Windows\system32\svchost.exe -k
                           LocalServiceNetworkRestricted -p; username=NT AUTHORITY\LocalService; autodelay=False;
                           start_type=Manual; description=Routes AllJoyn messages for the local AllJoyn clients. If
                           this service is stopped the AllJoyn clients that do not have their own bundled routers will
                           be unable to run.; display_name=AllJoyn Router Service}, @{pid=0; name=ALG; status=stopped;
                           binpath=C:\Windows\System32\alg.exe; username=NT AUTHORITY\LocalService; autodelay=False;
                           start_type=Manual; description=Provides support for 3rd party protocol plug-ins for
                           Internet Connection Sharing; display_name=Application Layer Gateway Service}, @{pid=1968;
                           name=AmazonSSMAgent; status=running; binpath="C:\Program
                           Files\Amazon\SSM\amazon-ssm-agent.exe"; username=LocalSystem; autodelay=False;
                           start_type=Automatic; description=Amazon SSM Agent; display_name=Amazon SSM Agent},
                           @{pid=0; name=AppIDSvc; status=stopped; binpath=C:\Windows\system32\svchost.exe -k
                           LocalServiceNetworkRestricted -p; username=NT Authority\LocalService; autodelay=False;
                           start_type=Manual; description=Determines and verifies the identity of an application.
                           Disabling this service will prevent AppLocker from being enforced.;
                           display_name=Application Identity}...}
public_ip                : 3.140.145.168
total_ram                : 1
used_ram                 :
disks                    : {@{free=31.7 GB; used=18.3 GB; total=50.0 GB; device=C:; fstype=NTFS; percent=36}}
boot_time                : 1639176130.0
logged_in_username       : Administrator
last_logged_in_user      : Administrator
antivirus                : n/a
monitoring_type          : server
description              :
mesh_node_id             :
overdue_email_alert      : False
overdue_text_alert       : False
overdue_dashboard_alert  : False
offline_time             : 4
overdue_time             : 30
check_interval           : 120
needs_reboot             : False
choco_installed          : True
wmi_detail               : @{os=System.Object[]; cpu=System.Object[]; mem=System.Object[]; usb=System.Object[];
                           bios=System.Object[]; disk=System.Object[]; comp_sys=System.Object[];
                           graphics=System.Object[]; base_board=System.Object[]; comp_sys_prod=System.Object[];
                           network_config=System.Object[]; desktop_monitor=System.Object[];
                           network_adapter=System.Object[]}
time_zone                :
maintenance_mode         : False
block_policy_inheritance : False
pending_actions_count    : 0
has_patches_pending      : False
alert_template           :
site                     : 1
policy                   :
```

## Invoke-TRMMAgentCmd

This one will let you invoke a command, from the API, on the chosen agent. This runs the command ON the target machine, and returns the output as plaintext.

This defaults to powershell, but you can use the "-UseCommandPrompt" flag to switch the shell.

*If you expect your output to be a ps object, you can use the -ReturnPSObject flag. This does some json converting magic. This may not work with full scripts.*

The -Timeout flag changes the timeout from its default of 30 seconds. Good if you expect the commands/scripts to run long.


```
Invoke-TRMMAgentCmd -AgentID "xGquELTJRrzeXyxLJhssARtWnxsxHIFLRGkNWggk" -Command 'Get-TimeZone' -ReturnPSObject
```

Outputs:
```
Id                         : UTC
DisplayName                : (UTC) Coordinated Universal Time
StandardName               : Coordinated Universal Time
DaylightName               : Coordinated Universal Time
BaseUtcOffset              : @{Ticks=0; Days=0; Hours=0; Milliseconds=0; Minutes=0; Seconds=0; TotalDays=0;
                             TotalHours=0; TotalMilliseconds=0; TotalMinutes=0; TotalSeconds=0}
SupportsDaylightSavingTime : False
```

You can also run it with the "-JsonOnly" flag to only return the json.

## New-TRMMClient

Like it says on the tin, created a new client. There is a requirement to add a site when adding a client. Use the -PrimarySite flag to do so.

```
New-TRMMClient -Name "Test Customer 3" -PrimarySite "Test Site 1"
```

Output:
```
Test Customer 3 was added
```
Note: The output is from the API itself, not the PS commands. If you don't want output, pipe it to Out-Null.

## New-TRMMSite

This will create a new site for the specified client ID. In my above example, my "Test Customer 3" has an ID of 3.

```
New-TRMMSite -Name "Test Site 2" -ClientID 3
```

Output:
```
Site Test Site 2 was added
```
Note: The output is from the API itself, not the PS commands. If you don't want output, pipe it to Out-Null.
