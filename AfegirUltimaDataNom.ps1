# Define the target directory
$targetDirectory = "C:\Users\jros\Dropbox\2_ISO EXPOCOM"
#$targetDirectory = "C:\Users\jros\Desktop\proyectos\ISO\test\2_ISO EXPOCOM"
#$targetDirectory = "C:\Users\jros\Desktop\proyectos\ISO\test\proves"

# Get all files in the target path
$files = Get-ChildItem -Path $targetDirectory -File -Recurse

foreach ($file in $files) {
    # Check if the path contains "Obsoletos"
    if ($file.FullName -match "Obsoletos") {
        continue
    }

    # Skip .jpg and .png files
    if ($file.Extension -eq ".jpg" -or $file.Extension -eq ".png") {
        continue
    }
    
    # Read the content of the file
    $content = Get-Content -Path $file.FullName -Raw

    # Use regex to find all dates in the format dd/MM/yyyy or dd-MM-yyyy
    $dates = [regex]::Matches($content, '\b\d{2}[/-]\d{2}[/-]\d{4}\b') | ForEach-Object { $_.Value }

    if ($dates.Count -gt 0) {
        # Convert the dates to DateTime objects
        $dateTimes = @()
        foreach ($date in $dates) {
            try {
                $dateTimes += [datetime]::ParseExact($date, 'dd/MM/yyyy', $null)
            } catch {
                try {
                    $dateTimes += [datetime]::ParseExact($date, 'dd-MM-yyyy', $null)
                } catch {
                    Write-Output "Error parsing date '$date' in file: $($file.FullName)"
                }
            }
        }

        if ($dateTimes.Count -gt 0) {
            # Get the most recent date
            $mostRecentDate = $dateTimes | Sort-Object -Descending | Select-Object -First 1

            # Format the date as ddMMyyyy
            $formattedDate = $mostRecentDate.ToString("ddMMyyyy")

            # Check if the date is already in the file name
            if ($file.Name -match $formattedDate) {
                # Write-Output "Date already in file name: $($file.FullName)"
                continue
            }

            # Create the new file name with the date appended
            $newFileName = "$($file.BaseName) $formattedDate$($file.Extension)"

            # Check if the new file name is different from the current file name
            if ($file.Name -ne $newFileName) {
                Rename-Item -Path $file.FullName -NewName $newFileName
                Write-Host "Renamed file: $($file.FullName) to $newFileName" -ForegroundColor Magenta
            } else {
                Write-Output "File name unchanged: $($file.FullName)"
            }
        } else {
            Write-Output "No valid dates found in file: $($file.FullName)"
        }
    } else {
        # Write-Output "No dates found in file: $($file.FullName)"
    }
}