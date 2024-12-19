# Define the primary directory where the websites are located
$primaryDirectory = "C:\inetpub\wwwroot"

# Generate a unique log file name with a timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFileName = "log_cleanup_report_$timestamp.txt"
$logFilePath = Join-Path -Path $primaryDirectory -ChildPath $logFileName

# Function to log messages to both console and log file
function Log-Message {
    param (
        [string]$message
    )
    $timestampedMessage = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - $message"
    Write-Output $timestampedMessage
    Add-Content -Path $logFilePath -Value "$timestampedMessage`n"
}

# Function to safely get directories, handling errors
function Get-SafeDirectories {
    param (
        [string]$path
    )
    try {
        Get-ChildItem -Path $path -Directory -ErrorAction Stop
    } catch {
        Log-Message "Failed to get directories in $($path): $($_.Exception.Message)"
        return @()
    }
}

# Check if script is in test mode
$testMode = $false
$totalFilesDeleted = 0
$totalSizeDeleted = 0

# Get directories to process
if ($testMode) {
    $directoriesToProcess = Get-SafeDirectories -Path $primaryDirectory | Select-Object -First 3
} else {
    $directoriesToProcess = Get-SafeDirectories -Path $primaryDirectory
}

# Log start of the process
Log-Message "Script started in $(if ($testMode) { 'test' } else { 'real' }) mode."

# Loop through each directory
foreach ($dir in $directoriesToProcess) {
    $directoryFilesDeleted = 0
    $directorySizeDeleted = 0
    try {
        $logsDirectory = Join-Path -Path $dir.FullName -ChildPath "Portals\_default\Logs"
        $filesToDelete = Get-ChildItem -Path $logsDirectory -Filter "*.log.resources" -File -ErrorAction Stop

        $filesToDeleteCount = $filesToDelete.Count
        Log-Message "Processing directory: $($dir.Name). Files to delete: $filesToDeleteCount"

        if ($filesToDeleteCount -eq 0) {
            Log-Message "No log files found in $($dir.Name). Skipping."
            continue
        }

        $fileIndex = 0
        foreach ($file in $filesToDelete) {
            if (-not $testMode) {
                try {
                    Remove-Item -Path $file.FullName -Force
                } catch {
                    Log-Message "Failed to delete file: $($file.FullName). Error: $($_.Exception.Message)"
                    continue
                }
            }

            $fileSize = $file.Length
            $directorySizeDeleted += $fileSize
            $totalSizeDeleted += $fileSize
            $directoryFilesDeleted++
            $totalFilesDeleted++
            $fileIndex++

            $progressPercent = [Math]::Round(($fileIndex / $filesToDeleteCount) * 100, 2)
            Write-Progress -Activity "Deleting log files in $($dir.Name)" -Status "$progressPercent% complete" -PercentComplete $progressPercent
            Log-Message "Deleted: $($file.Name), Size: $([Math]::Round($fileSize / 1MB, 2)) MB"
        }
        Log-Message "Deleted $directoryFilesDeleted files from $($dir.FullName). Total size: $([Math]::Round($directorySizeDeleted / 1MB, 2)) MB. Logs directory: $logsDirectory"
    } catch {
        Log-Message "Error processing $($dir.FullName): $($_.Exception.Message)"
    }
}

# Log the total number of files and size deleted
Log-Message "Total files deleted: $totalFilesDeleted"
Log-Message "Total size deleted: $([Math]::Round($totalSizeDeleted / 1MB, 2)) MB"
Log-Message "Script execution completed. Please check the log file for details: $logFilePath"

# Display completion message
Write-Host "Script completed. Total files deleted: $totalFilesDeleted. Total size deleted: $([Math]::Round($totalSizeDeleted / 1MB, 2)) MB. Log file: $logFilePath"
