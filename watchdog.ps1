# Set the path to the directory you want to watch
$directoryPath = "C:\Users\gabee\watch\"
$logFilePath = "C:\Users\gabee\dog.json"

# Create a FileSystemWatcher
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $directoryPath
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

# Define the action to take when a file is changed or created
$action = {
    $eventTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $modifiedFile = $Event.SourceEventArgs.FullPath

    # Log the modification in a structured format (JSON)
    $logEntry = @{
        Timestamp = $eventTimestamp
        EventType = $Event.SourceEventArgs.ChangeType
        FilePath = $modifiedFile
    } | ConvertTo-Json

    Add-Content -Path $logFilePath -Value $logEntry
}

# Unregister existing events with the same source identifier
Unregister-Event -SourceIdentifier FileChangedEvent -ErrorAction SilentlyContinue
Unregister-Event -SourceIdentifier FileCreatedEvent -ErrorAction SilentlyContinue

# Register the events
Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $action -SourceIdentifier FileChangedEvent
Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action $action -SourceIdentifier FileCreatedEvent

# Keep the script running
try {
    while ($true) {
        # This loop keeps the script running to continue watching for file changes
        Start-Sleep -Seconds 1
    }
}
finally {
    # Clean up and unregister the events when the script is terminated
    Unregister-Event -SourceIdentifier FileChangedEvent
    Unregister-Event -SourceIdentifier FileCreatedEvent
    $watcher.Dispose()
}