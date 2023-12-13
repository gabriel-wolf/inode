# arguments
if ($args.Length -gt 1) {
    $directoryPath = $args[0]
    $exportPath = $args[1]
}
else {
    $directoryPath = "C:\Users\gabee\iCloudDrive\"
    $exportPath = "C:\Users\gabee\isPhotos.csv"
}

function IsPhotoByExtension {
    param([string]$filePath)

    $photoExtensions = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tif", ".tiff", ".psd")

    $fileExtension = [System.IO.Path]::GetExtension($filePath).ToLower()

    if($photoExtensions -contains $fileExtension) {
        return 1
    }
    else {
        return 0
    }
}


$files = Get-ChildItem -Path $directoryPath -File -Recurse

$directoryPriorities = @{}

foreach ($file in $files) {

    $directory = $file.DirectoryName
    $isPhoto = IsPhotoByExtension $file

    # Add priority to directory hashtable
    if ($directoryPriorities.ContainsKey($directory)) {
        $directoryPriorities[$directory]["Photos"] += $isPhoto
        $directoryPriorities[$directory]["FileCount"]++
    }
    else {
        $directoryPriorities[$directory] = @{
            Photos = $isPhoto
            FileCount = 1
        }
    }   
}

$directoryDetails = @()

foreach ($directory in $directoryPriorities.Keys) {
    $averagePhoto = $directoryPriorities[$directory]["Photos"] / $directoryPriorities[$directory]["FileCount"]

    $isPhotosDirectory = if ($averagePhoto -ge 0.9) { "Yes" } else { "No" }
    
    $directoryDetails += [PSCustomObject]@{
        DirectoryPath = $directory
        'Confidence Score' = $averagePhoto
        'Photos Directory?' = $isPhotosDirectory
    }
}

# Create a CSV file with the directory details
$directoryDetails | Sort-Object -Property 'Confidence Score' -Descending | Export-Csv -Path $exportPath -NoTypeInformation
