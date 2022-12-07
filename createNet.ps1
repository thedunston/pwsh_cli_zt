# Read in the auth.secret file
$authSecret = Get-Content 'C:\ProgramData\ZeroTier\One\authtoken.secret'

$nodeID = Read-Host -Prompt "Please enter the node ID for this controller"
$desc = Read-Host -Prompt "Please enter a description for the network"
# Get the auth token
$h =  @{ 'X-ZT1-Auth' = $authSecret}

# Create a PowerShell object to hold the JSON request body
$requestBody = @{

        "name" = "$desc"

        # Private network by default
        "private" = $true
  
    }

    # Convert to json
$jsonBody = $requestBody | ConvertTo-Json
$i = "______"
# Set the request URI
$requestUri = "http://127.0.0.1:9993/controller/network/$nodeID$i"


$Params =@{
    Uri = $requestUri
    Method = "POST"
    Headers = $h
    Body = $jsonBody
    ContentType = "application/json"

}

# Create the request object
$request = Invoke-RestMethod @Params

# List networks
Invoke-RestMethod  -Headers $h  -Uri "http://127.0.0.1:9993/controller/network"