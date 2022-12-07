# pwsh_cli_zt

Status: Currently supported and will be updated soon. Today is 20221207.

[The bash_cli_zt scripts are here](https://github.com/thedunston/bash_cli_zt)

Here are the beginnings of Powershell scripts to manage a self-hosted ZeroTier controller on a Windows host.  These scripts were tested on Windows 10.  These are very icky and only performs the tasks:

1. Create a network, DHCP pool, and a short description.
2. List and authorize/deauthorize members.

These scripts will become more robust soon.

The output is raw JSON.  I wrote these to test if Windows could be a ZT self-hosted controller.

Hate time, not the programmer. :)

Run the createNet script first.
Then createIPAssignment
Finally, getMember
