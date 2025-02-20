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

    # Convert the file name to uppercase until "Ed" followed by a number
    $nameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $extension = [System.IO.Path]::GetExtension($file.Name).ToLower()

    # Use regex to split the name at "Ed" followed by a number
    if ($nameWithoutExtension -match '^(.*?)(Ed\d+)$') {
        $newNameWithoutExtension = $matches[1].ToUpper() + $matches[2]
    } else {
        $newNameWithoutExtension = $nameWithoutExtension.ToUpper()
    }
    
    $newName = $newNameWithoutExtension + $extension

    # Get the full path for the new name
    $newPath = Join-Path -Path $file.DirectoryName -ChildPath $newName
    Write-Output "Renaming to: $newPath"
    # Rename the file
    Rename-Item -Path $file.FullName -NewName $newName
}