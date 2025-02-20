# Define the target directory
$targetDirectory = "##"

# Define a hashtable for accent replacements
$accentReplacements = @{
    'á' = 'a'; 'é' = 'e'; 'í' = 'i'; 'ó' = 'o'; 'ú' = 'u';
    'à' = 'a'; 'è' = 'e'; 'ì' = 'i'; 'ò' = 'o'; 'ù' = 'u';
    'ä' = 'a'; 'ë' = 'e'; 'ï' = 'i'; 'ö' = 'o'; 'ü' = 'u';
    'â' = 'a'; 'ê' = 'e'; 'î' = 'i'; 'ô' = 'o'; 'û' = 'u';
    'ã' = 'a'; 'õ' = 'o'; 'ñ' = 'n'; 'ç' = 'c';
}

# Get all files in the target path
$files = Get-ChildItem -Path $targetDirectory -File -Recurse

foreach ($file in $files) {
    # Check if the path contains "Obsoleto"
    if ($file.FullName -match "Obsoleto") {
        Write-Output "Skipping file in Obsoleto path: $($file.FullName)"
        continue
    }

    # Convert the file name by replacing accented characters
    $nameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $extension = [System.IO.Path]::GetExtension($file.Name).ToLower()

    foreach ($accent in $accentReplacements.Keys) {
        $nameWithoutExtension = $nameWithoutExtension -replace [regex]::Escape($accent), $accentReplacements[$accent]
    }

    $newName = $nameWithoutExtension + $extension

    # Get the full path for the new name
    $newPath = Join-Path -Path $file.DirectoryName -ChildPath $newName
    Write-Output "Renaming to: $newPath"
    # Rename the file
    Rename-Item -Path $file.FullName -NewName $newName
}