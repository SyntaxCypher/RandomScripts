Write-Host "Attention: DO NOT EXIT, File Integrity Check Running"
Write-Host "Seth Bates, 2023 ChecksumVerfication Script"
Write-Host "Version: 1.1"
Write-Host ""
Write-Host "CheckSum Verfication in progress:"
Write-Host ""
# Define the path to the checksum data file
$checksumDataFile = "C:\checksums.json"

# Function to load the checksum data from the JSON file
function LoadChecksumData {
    if (Test-Path $checksumDataFile) {
        $jsonContent = Get-Content $checksumDataFile | Out-String
        $hashtable = @{}
        $convertedData = $jsonContent | ConvertFrom-Json
        foreach ($entry in $convertedData.PSObject.Properties) {
            $hashtable[$entry.Name] = $entry.Value
        }
        return $hashtable
    }
    else {
        return @{}
    }
}

# Function to save the checksum data to the JSON file
function SaveChecksumData {
    $checksumData | ConvertTo-Json | Set-Content $checksumDataFile
}

# Load existing checksum data or create a new empty dictionary
$checksumData = LoadChecksumData
if ($null -eq $checksumData) {
    $checksumData = @{}
}

# Define the directories to check
$directories = @("C:\PATH-HERE", "C:\PATH-HERE")

# Define the files to exclude from checksum calculation
$excludeFiles = @(
    "C:\PATH-HERE",
    "C:\PATH-HERE"
)

# Initialize variables for progress tracking
$totalFiles = 0
$processedFiles = 0
$checksumChanged = $false

# Get the total number of files
foreach ($directory in $directories) {
    $totalFiles += (Get-ChildItem -Path $directory -File -Recurse).Count
}

# Loop through each directory
foreach ($directory in $directories) {
    # Get the list of files in the directory
    $files = Get-ChildItem -Path $directory -File -Recurse

    # Loop through each file
    foreach ($file in $files) {
        # Check if the file matches any exclude file pattern
        $excludeFile = $false
        foreach ($exclude in $excludeFiles) {
            if ($file.FullName -like $exclude) {
                $excludeFile = $true
                break
            }
        }

        if ($excludeFile) {
            # Skip excluded file
            Write-Host "Excluded file: $($file.FullName)"
            continue
        }

        # Get the current checksum of the file
        $currentChecksum = Get-FileHash -Path $file.FullName -Algorithm SHA256 | Select-Object -ExpandProperty Hash

        # Check if the file's checksum has changed
        if ($null -ne $checksumData[$file.FullName] -and $checksumData[$file.FullName] -ne $currentChecksum) {
            # Alert the user about the changed checksum
            Write-Host "Checksum of file $($file.FullName) has changed!"

            # Set the checksumChanged flag to true
            $checksumChanged = $true
        }
        else {
            # Checksum verified
            Write-Host "Checksum verified for file $($file.FullName)"
        }

        # Update the file's checksum in the checksum data dictionary
        $checksumData[$file.FullName] = $currentChecksum

        # Update progress variables
        $processedFiles++
        $progressPercentage = [math]::Round(($processedFiles / $totalFiles) * 100)
        Write-Host "Progress: $progressPercentage% ($processedFiles/$totalFiles)"
    }
}

# Save the updated checksum data to the JSON file
SaveChecksumData

# Prompt user to press any key or wait for timeout
$timeoutSeconds = 20
$startTime = Get-Date

while ((Get-Date) -lt ($startTime.AddSeconds($timeoutSeconds))) {
    if ($checksumChanged -eq $true) {
        break
    }

    if ([Console]::KeyAvailable) {
        $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
        break
    }

    Start-Sleep -Seconds 1
}

# Checksum changed, no timeout occurred
if ($checksumChanged -eq $true) {
    Write-Host "A checksum change has been detected. Press any key to exit..."
    $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
}
# Timeout occurred
else {
    Write-Host "Timeout reached. Exiting..."
}
