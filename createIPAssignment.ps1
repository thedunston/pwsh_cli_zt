# Temporary scripts to create an IP assignment on a Windows ZeroTier Node

# Read in the auth.secret file
$authSecret = Get-Content 'C:\ProgramData\ZeroTier\One\authtoken.secret'

# Gather information
$startPool = read-host -Prompt "Please enter the first IP for the DHCP pool"
$endPool = read-host -Prompt "Please enter the last IP for the DHCP pool"
$network = read-host -Prompt "Please enter the network ID"

# Network ID: Currently just /24
$o = $startPool.Split('.')
$netID = "{0}.{1}.{2}.0/24" -f $o[0], $o[1], $o[2]

# Create a PowerShell object to hold the JSON request body
$requestBody =  @{
  
        "ipAssignmentPools" = @( 
            @{ 
                "ipRangeStart" = "$startPool";
                "ipRangeEnd" = "$endPool"
            }
            
        );
        "v4AssignMode" = @{
                zt = $true
            };

        "routes" = @(

            @{ 

                "target" = "$netID";
                "via" = ""
        
            }
            
        );

    } | ConvertTo-Json


# Set the request URI
$requestUri = "http://127.0.0.1:9993/controller/network/$network"

# Convert the request body to JSON
$h =  @{ 'X-ZT1-Auth' = $authSecret}

$Params =@{
    Uri = $requestUri
    Method = "POST"
    Headers = $h
    Body = $requestBody
    ContentType = "application/json"

}

# Create the request object
Invoke-RestMethod @Params

# Output the network information
Invoke-RestMethod -Headers $h -URI "http://127.0.0.1:9993/controller/network/$network"