# Set the path to the directory
$directoryPath = "C:\Users\gabee\iCloudDrive\Desktop"

# Get all shortcut files in the directory
$shortcutFiles = Get-ChildItem -Path $directoryPath -Filter *.lnk -Recurse

# Output the list of shortcut files
Write-Host "Shortcut Files:"
$shortcutFiles | ForEach-Object { Write-Host "  $($_.FullName)" }

# Initialize counters
$shortcutCount = 0
$otherFileCount = 0

# Get all files in the directory
$files = Get-ChildItem -Path $directoryPath 

# $files = Get-ChildItem -Path $directoryPath -Recurse | Where-Object {$_.PSIsContainer -and $_.PSIsLink}



# Iterate through each file
foreach ($file in $files) {
	# Write-Host $file.BaseName
    # Check if the file is a shortcut (.lnk file)
    if ($file.Extension -eq ".lnk") {
        $shortcutCount++
    } else {
        $otherFileCount++
    }
}

# Output results
Write-Host "Number of Shortcuts: $shortcutCount"
Write-Host "Number of Other Files: $otherFileCount"
