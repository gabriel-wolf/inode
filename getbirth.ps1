# Set the path to the directory
$directoryPath = "C:\Program Files"

# Get all files in the directory
$files = Get-ChildItem -Path $directoryPath -File -Recurse

# Create an array to store file names
$fileDetails = @()

# Iterate through each file and add its name to the array
# Iterate through each file and add its details to the array
foreach ($file in $files) {
    $fileDetails += [PSCustomObject]@{
        FileName   = $file.Name
        FilePath   = $file.FullName
        BirthTime  = $file.CreationTime
		AccessTime = $file.LastAccessTime
		WriteTime = $file.LastWriteTime
    }
}

# Create a CSV file with the file names
$fileDetails | Export-Csv -Path "C:\Users\gabee\programfilesbirths.csv" -NoTypeInformation