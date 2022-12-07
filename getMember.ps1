
# Read in the auth.secret file
$authSecret = Get-Content 'C:\ProgramData\ZeroTier\One\authtoken.secret'

# TODO: Print descriptions of networks
write-host "List of networks:"
Invoke-RestMethod -Method "GET" -Headers $h -Uri "http://127.0.0.1:9993/controller/network/"


#Get the ZeroTier network ID
$networkID = Read-Host -Prompt 'Please enter the ZeroTier network ID'

$h =  @{ 'X-ZT1-Auth' = $authSecret}

#Get a list of all members of the network
Invoke-RestMethod -Method "GET" -Headers $h -Uri "http://127.0.0.1:9993/controller/network/$networkID/member"  -OutFile 'file.txt'

# TODO: Parse the json because this is icky.

Select-String -Pattern "[a-f0-9]{9}" -Path '.\file.txt'
#$tmp1 = $tmp.Matches.Groups[0].Value

<#$m = @($tmp1)
foreach ($mem in $m)
{

    $mem = $mem |Out-String
    #Get the member's details
    $y = Invoke-RestMethod  -Method "GET" -Headers $h `
     -Uri "http://127.0.0.1:9993/controller/network/$networkID/member/054ef1ceba" -OutFile 'out.txt'
 
    # TODO: Parse the json because this is icky.
    $tmp = Select-String -Pattern "[a-f0-9]{9}" -Path '.\out.txt'
    $tmp1 = $tmp.Matches.Groups[0].Value
    write-host $tmp1
}
#>
$go = Read-Host -Prompt "Would you like to authorize a node? y or n"

if ($go -match 'y') {
   
    # Create a PowerShell object to hold the JSON request body
    $requestBody = @{

        "authorized" = $true
        "ipAssignments" = "[]"

    }

    $theMem = Read-Host -Prompt "Enter the node ID"

    # Set the request URI
    $requestUri = "http://127.0.0.1:9993/controller/network/$networkID/member/$theMem"

    $jsonBody = $requestBody | ConvertTo-Json

    $Params =@{

        Uri = $requestUri
        Method = "POST"
        Headers = $h
        Body = $jsonBody
        ContentType = "application/json"

    }
    # Create the request object
    Invoke-RestMethod @Params
        
    Invoke-RestMethod -Headers $h -URI "http://127.0.0.1:9993/controller/network/$networkID/member/$theMem"

} elseif ($go -match 'n') {

        $go = Read-Host -Prompt "Would you like to deauthorize a node? y or n"

        if ($go -match 'y') {
    
            # Create a PowerShell object to hold the JSON request body
            $requestBody = @{
        
                "authorized" = $false
                "ipAssignments" = "[]"
        
            }

            $theMem = Read-Host -Prompt "Enter the node ID"

            # Set the request URI
            $requestUri = "http://127.0.0.1:9993/controller/network/$networkID/member/$theMem"

            $jsonBody = $requestBody | ConvertTo-Json

            $Params =@{

                Uri = $requestUri
                Method = "POST"
                Headers = $h
                Body = $jsonBody
                ContentType = "application/json"

            }

            # Create the request object
            Invoke-RestMethod @Params

            Invoke-RestMethod -Headers $h -URI "http://127.0.0.1:9993/controller/network/$networkID/member/$theMem"

    } else {

        write-host "doing nothing."

    }

}




