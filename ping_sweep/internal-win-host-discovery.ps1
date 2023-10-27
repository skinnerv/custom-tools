#This is PS script to run on windows, in order to discovery host with open ports: $ports = 80, 443, 21, 22, 135, 445 You can modify the port list below. 
# to run: .\internal-win-host-discovery.ps1 -ipRange "127.0.0" -startNumber 10 -endNumber 15 -logFileName "C:\Tools\ping-log.txt"
param (
    [string]$ipRange,
    [int]$startNumber,
    [int]$endNumber,
    [string]$logFileName
)

# Function to scan a single host and port
Function Scan-Host {
    param (
        [string]$ip,
        [int]$port
    )

    $endpoint = New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Parse($ip), $port)
    $socket = New-Object System.Net.Sockets.TcpClient

    try {
        $socket.Connect($endpoint)
        if ($socket.Connected) {
            $resultText = "${ip}:${port} is open"
        }
    }
    catch {
        # Port is closed or host is unreachable
        $resultText = "${ip}:${port} is closed"
    }
    finally {
        $socket.Close()
    }

    $resultText
}

# Loop for scanning the IP range
$ports = 80, 443, 21, 22, 135, 445
$jobs = @()

Write-Host "Scanning in progress..."

for ($i = $startNumber; $i -le $endNumber; $i++) {
    $ip = "$ipRange.$i"
    foreach ($port in $ports) {
        $job = Start-Job -ScriptBlock {
            param ($ip, $port, $logFile)

            # Function to scan a single host and port
            Function Scan-Host {
                param (
                    [string]$ip,
                    [int]$port
                )

                $endpoint = New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Parse($ip), $port)
                $socket = New-Object System.Net.Sockets.TcpClient

                try {
                    $socket.Connect($endpoint)
                    if ($socket.Connected) {
                        $resultText = "${ip}:${port} is open"
                    }
                }
                catch {
                    # Port is closed or host is unreachable
                    $resultText = "${ip}:${port} is closed"
                }
                finally {
                    $socket.Close()
                }

                $resultText
            }

            $retryCount = 3  # Number of times to retry writing to the log file
            $retryDelay = 1  # Delay in seconds between retries

            while ($retryCount -gt 0) {
                try {
                    $result = Scan-Host -ip $ip -port $port
                    $result | Out-File -Append -FilePath $logFile
                    break  # Exit the retry loop if writing is successful
                } catch {
                    # Writing to the log file failed, retry after a delay
                    $retryCount--
                    Start-Sleep -Seconds $retryDelay
                }
            }
        } -ArgumentList $ip, $port, $logFileName

        $jobs += $job
    }
}

$jobs | Wait-Job | Receive-Job
$jobs | Remove-Job

Write-Host "Scanning completed."
