Function Connect-TRMM {
    
    param(
        [string][Parameter(Mandatory=$true)]$APIKey,
        [string][Parameter(Mandatory=$true)]$URL
    )

    $Headers = @{
        "Content-Type" = "application/json"
        "X-API-KEY" = $APIKey
    }

    try {
        #Unfortunately, Tactical doesn't have a great "test" endpoint right now. /core/codesign/ will return a null token value if the credentials are correct, and return nothing if they aren't. This was the fastest request I could use to test.
        Invoke-RestMethod -Uri "$URL/core/codesign/" -Headers $Headers -Method GET -UseBasicParsing | Out-Null
    } Catch {
        Write-Warning "Could not connect to $URL. Please check your API key and URL."
        Write-Verbose $PSItem.Exception.Message
        return
    }

    Write-Output "Connected to $URL"
    $Script:TRMMHeaders = $Headers
    $Script:TRMMURL = $URL

}

Function Get-TRMMClients {
    param(
        [string]$ClientID
    )

    if(!$Script:TRMMHeaders){
        Write-Warning "Please connect to TRMM first!"
        Return
    }

    $Output = Invoke-RestMethod -Uri "$Script:TRMMURL/clients/$ClientID/" -Headers $Script:TRMMHeaders -Method GET -UseBasicParsing
    Write-Output $Output
}


Function Get-TRMMSites {
    param(
        [string]$SiteID
    )
    
    if(!$Script:TRMMHeaders){
        Write-Warning "Please connect to TRMM first!"
        Return
    }

    #Super simple. If $ClientID is specified, it only lists sites for that client ID. If not, the value is null, and it lists all sites.
    $Output = Invoke-RestMethod -Uri "$Script:TRMMURL/clients/sites/$SiteID/" -Headers $Script:TRMMHeaders -Method GET -UseBasicParsing
    Write-Output $Output
}

function Get-TRMMAgents {
    param (
        [String]$AgentID
    )
    
    if(!$Script:TRMMHeaders){
        Write-Warning "Please connect to TRMM first!"
        Return
    }
    #Quick warning, I do not know how to make this "Filter left", so it returns ALL agents. I could do some artificial filtering, but the request to the server will do the same thing anyways.. This may be a slow one, unless you specify an $AgentID
    
    $Output = Invoke-RestMethod -Uri "$Script:TRMMURL/agents/$AgentID/" -Headers $Script:TRMMHeaders -Method GET -UseBasicParsing
    Write-Output $Output
}

function Invoke-TRMMAgentCmd {
    param (
        [string][Parameter(Mandatory=$true)]$AgentID,
        [string][Parameter(Mandatory=$true)]$Command,
        [int]$Timeout="30",
        [switch]$UseCommandPrompt,
        [switch]$ReturnPSObject
    )
         
    if(!$Script:TRMMHeaders){
        Write-Warning "Please connect to TRMM first!"
        Return
    }
    
    #Default to powershell, but if command prompt is needed, the switch can set it to that. Obviously, if cmd is being used, we don't want a ps object returned..
    if($UseCommandPrompt){
        $Shell = "cmd"
        $ReturnPSObject = $False
    }else{
        $Shell = "powershell"
    }

    #This might be a little hacky.. Forgive me. By default, it returns plaintext. What this does, is it converts that plain text to json plaintext. Then PS can take that json string, and convert it to a ps object.
    if($ReturnPSObject){
        $Command = "$Command | ConvertTo-Json -Depth 10"
    }

    $RequestBody = @{
        cmd = "$Command"
        shell = "$Shell"
        timeout = $timeout
    } | ConvertTo-Json


    try{
        $Request = Invoke-RestMethod -Uri "$Script:TRMMURL/agents/$AgentID/cmd/" -Headers $Script:TRMMHeaders -Method POST -Body $RequestBody -UseBasicParsing
    }catch{
        Write-Warning "Command invocation failed. Please check your syntax, or agent ID"
        Write-Verbose $PSItem.Exception.Message
        return
    }

    if($ReturnPSObject){
        try{
            Write-Output $Request | ConvertFrom-Json #This is the aforementioned conversion from a json string, to a ps object.
        }catch{
            Write-Warning "Converting from json failed. Was your output a PSObject?" #If that conversion fails, it will return the raw json, or whatever the state of the text currently is. It usually works fine, but if your expected output isn't a ps object, you shouldn't use the returnpsobject param.
            Write-Verbose $PSItem.Exception.Message
            Write-Output $Request
            Return
        }
        
    }else{
        Write-Output $Request
    }
}

function New-TRMMClient {
    param (
        [string][Parameter(Mandatory=$true)]$Name,
        [string][Parameter(Mandatory=$true)]$PrimarySite
    )

    if(!$Script:TRMMHeaders){
        Write-Warning "Please connect to TRMM first!"
        Return
    }

    $RequestBody = @{
        client = @{
            name = "$Name"
        }
        site = @{
            name = "$PrimarySite"
        }
        custom_fields = @()
    } | ConvertTo-Json -Depth 5

    try{
        Invoke-RestMethod -URI "$Script:TRMMURL/clients/" -Headers $Script:TRMMHeaders -Method POST -Body $RequestBody -UseBasicParsing
    }catch{
        Write-Warning "Client Addition Failed.. Does it already exist?"
        Write-Verbose $PSItem.Exception.Message
        Return
    }

}

function New-TRMMSite {
    param (
        [string][Parameter(Mandatory=$true)]$Name,
        [string][Parameter(Mandatory=$true)]$ClientID
    )

    if(!$Script:TRMMHeaders){
        Write-Warning "Please connect to TRMM first!"
        Return
    }


    $RequestBody = @{
        site = @{
            client = "$ClientID"
            name = "$Name"
        }
        custom_fields = @()
    } | ConvertTo-Json -Depth 5


    try{
        Invoke-RestMethod -URI "$Script:TRMMURL/clients/sites/" -Headers $Script:TRMMHeaders -Method POST -Body $RequestBody -UseBasicParsing
    }catch{
        Write-Warning "Site Addition Failed.. Was your client ID correct?"
        Write-Verbose $PSItem.Exception.Message
        Return
    }

}
