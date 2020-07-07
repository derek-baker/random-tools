param(
    [string] $image = 'mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04',
    [string] $saPass = "<TODO>",
    [string] $externalPort = 1434,
    [string] $name = 'sql19'
)


# To download the container image
& docker pull $image


# To start/configure on first run
& docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$saPass" -p 1434:1433 --name $name -d $image


# If you want to connect to the container using SQLCMD:
# $ipv4 = (Test-Connection $Env:computername -count 1 | Select-Object Ipv4Address).Ipv4Address
# sqlcmd -S $ipv4,$externalPort -U SA -P "$saPass"
# NOTE: It looks like localhost works in the command above also


# To connect via SSMS 
#   use this format for 'Server name': <V4_IP>,<PORT>
#   use SQL auth and log in as SA


# To stop the container
# docker stop $name

# To stop the container
# docker start $name

# To remove container
# docker rm $name