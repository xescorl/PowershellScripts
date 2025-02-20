# Define the target directory
$targetDirectory = "##"

# Get all files in the target path
$files = Get-ChildItem -Path $targetDirectory -File -Recurse

foreach ($file in $files) {
    # Check if the path contains "Obsoleto"
    if ($file.FullName -match "Obsoleto") {
        Write-Output "Skipping file in Obsoleto path: $($file.FullName)"
        continue
    }

    # Check if the file name contains "1ªEd"
    if ($file.Name -match "V.2") {
        Write-Output "Found file: $($file.FullName)"
        # Create the new name by replacing "1ªEd" with "Ed1"
        $newName = $file.Name -replace "V.2", "Ed2"
        # Get the full path for the new name
        $newPath = Join-Path -Path $file.DirectoryName -ChildPath $newName
        Write-Output "Renaming to: $newPath"
        # Rename the file
        Rename-Item -Path $file.FullName -NewName $newName
    }
}