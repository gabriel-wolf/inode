# arguments
if ($args.Length -gt 1) {
    $directoryPath = $args[0]
    $exportPath = $args[1]
}
else {
    $directoryPath = "C:\Users\gabee\iCloudDrive\Documents\Classes\CSDS 325\"
    $exportPath = "C:\Users\gabee\toBackup.csv"
}

# Function to determine priority based on file extension (customize as needed)
function Get-CustomPriority($file) {

    $score = 0

    # if modified in the last 7 days plus 5
    if ($file.LastWriteTime -gt (Get-Date).AddDays(-7)) {
        $score += 5
    }

    # if modified in the last 6 months days plus 1
    if ($file.LastWriteTime -gt (Get-Date).AddMonths(-6)) {
        $score += 1
    }

    return $score
}


# Function to calculate directory level
function Get-DirectoryLevel($directory) {

    $slashCount = ($directory.Split("\") | Measure-Object).Count - 1

    return $slashCount
}

# Get all files in the directory
$files = Get-ChildItem -Path $directoryPath -File -Recurse

# Create a hashtable to store directory priorities and counts
$directoryPriorities = @{}

# Iterate through each file and calculate average directory priority
foreach ($file in $files) {
    Write-Output $file
    try {
        # Check if the directory is a system directory
        $isSystemDirectory = [System.IO.Directory]::GetFileSystemEntries($file.DirectoryName, $file.Directory.Name).Attributes -match "System"

        if (-not $isSystemDirectory) {
            $directory = $file.DirectoryName
            $priority = Get-CustomPriority $file
            $level = Get-DirectoryLevel $directory
            
            # Add priority to directory hashtable
            if ($directoryPriorities.ContainsKey($directory)) {
                $directoryPriorities[$directory]["TotalPriority"] += $priority
                $directoryPriorities[$directory]["FileCount"]++
            }
            else {
                $directoryPriorities[$directory] = @{
                    TotalPriority = $priority
                    FileCount = 1
                    Level = $level
                }
            }
        }   
    }
    catch {
        Write-Host "Error processing $($file.FullName): $_"
    }

    
}

# Create an array to store directory details
$directoryDetails = @()

# Calculate average directory priority and add to array
foreach ($directory in $directoryPriorities.Keys) {

    $fileCount = $directoryPriorities[$directory]["FileCount"]
    $level = $directoryPriorities[$directory]["Level"]

    $overallPriority = $directoryPriorities[$directory]["TotalPriority"]
    $averagePriority = $overallPriority / $fileCount

    $directoryDetails += [PSCustomObject]@{
        DirectoryPath = $directory
        Level = $level
        FileCount = $fileCount
        AveragePriority = $averagePriority
        OverallPriority = $overallPriority
    }
}

# Create a CSV file with the directory details
$directoryDetails | Sort-Object -Property OverallPriority -Descending | Export-Csv -Path $exportPath -NoTypeInformation
