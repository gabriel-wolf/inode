# Set the path to the directory you want to watch
$directoryPath = "C:\Users\gabee\watch\"
$logPath = "C:\Users\gabee\watchdog.txt"

# Create a FileSystemWatcher
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $directoryPath
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true


# Define the action to take when a file is changed
$action = {
    $eventTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $modifiedFile = $Event.SourceEventArgs.FullPath

    # Check if the event is a file change or creation
    if ($Event.SourceEventArgs.ChangeType -eq 'Changed') {
        # Log the modification
        Add-Content -Path $logPath -Value "$eventTimestamp - $modifiedFile was modified"
    }
    elseif ($Event.SourceEventArgs.ChangeType -eq 'Created') {
        # Log the creation
        Add-Content -Path $logPath -Value "$eventTimestamp - $modifiedFile was created"
    }
    
}

# Register the event
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
    # Clean up and unregister the event when the script is terminated
    Unregister-Event -SourceIdentifier FileChangedEvent
    Unregister-Event -SourceIdentifier FileCreatedEvent
    $watcher.Dispose()
}
