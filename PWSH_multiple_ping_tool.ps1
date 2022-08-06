try {
    #ask for the name of the log file 
    $file_name = Read-Host "please enter the name of the file you want to generate (you can add .txt .log or .data if you want)"

    # list the IP address you want to ping, you can edit this to change them, you  can add or remove them as long as there is one or more.
    # you need to put them between '' or "" and seperates them by a ,
    # exemple : 
    # [string[]]$ipToPing = '8.8.8.8' if you want only one 
    # [string[]]$ipToPing = '8.8.8.8', '192.0.0.212', '192.0.0.73' if you want multiple
    # [string[]]$ipToPing = '8.8.4.4', "192.0.0.48", "127.0.0.1" another exemple of multiple IP
    [string[]]$ipToPing = '8.8.8.8', '192.0.0.212', '192.0.0.73'


    # start recording what's inside the powershell prompt
    Start-Transcript -Path $file_name 

    # skip lines to make it easier to make the difference between ping logs and the system information that are given at the start of recording
    "`n`n`n`n`n`n`n`n`n`n`n`n`n`n------------------------------------------------------`n" | Write-Output

    # this block make sure you ping continuously the IP you specified and format the data so it can be easy to read in log file
    while ($true) {

            Get-Date -UFormat "%m/%d/%Y %R"| Write-Output
            "Address     ResponseTime `n-------     ------------" | Write-Output 
            # under this comment is the ping command, it is set to do it on each ip and filter to return only response time and ip
            $ipToPing| ForEach-Object -Process {Get-WmiObject -Class Win32_PingStatus -Filter ("Address='" + $_ + "'") -ComputerName .} | Select-Object -Property Address,ResponseTime 
            "`n------------------------------------------------------`n" | Write-Output
            # wait time so it doesn't spam the target IPs (time is in second so 'Start-Sleep 60' make it wait a minute)
            Start-Sleep 5
    }

}
# make sure that the script exit in a clean way without keeping busy the log file
finally {
    try {Stop-Transcript}
    catch{"script deja stop !"}
}
