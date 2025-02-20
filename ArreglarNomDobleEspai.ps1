# Define the target directory
$targetDirectory = '##'

# Get all files in the target path
$files = Get-ChildItem -Path $targetDirectory -File -Recurse

foreach ($file in $files) {
    # Check if the path contains "Obsoleto"
    if ($file.FullName -match "Obsoleto") {
        Write-Output "Skipping file in Obsoleto path: $($file.FullName)"
        continue
    }

    # Check if the file name contains "  "
    if ($file.Name -match "  ") {
        Write-Output "Found file: $($file.FullName)"
        # Create the new name by replacing "1ªEd" with "Ed1"
        $newName = $file.Name -replace "  ", " "
        # Get the full path for the new name
        $newPath = Join-Path -Path $file.DirectoryName -ChildPath $newName
        Write-Output "Renaming to: $newPath"
        # Rename the file
        Rename-Item -Path $file.FullName -NewName $newName
    }
}
