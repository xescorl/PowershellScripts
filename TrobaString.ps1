# Define the target directory
$targetDirectory = "##"

# Define the string to search for
$searchString = "ED"

# Get all files in the target path
$files = Get-ChildItem -Path $targetDirectory -File -Recurse

foreach ($file in $files) {
    # Check if the path contains "Obsoleto"
    if ($file.FullName -match "Obsoleto") {
        #Write-Output "Skipping file in Obsoleto path: $($file.FullName)"
        continue
    }

    # Check if the file name contains the search string (case-sensitive)
    if ($file.Name -cmatch $searchString) {
        Write-Output "Found file: $($file.FullName)"
    }
}