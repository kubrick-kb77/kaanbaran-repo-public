# ----------------------------------------------
# EdgeDNS Zone & Record Export Script – PowerShell 7
# Exports zones to Excel XLSX
# One worksheet per zone
# Row-by-row writing (PowerShell 7 safe)
# ----------------------------------------------

$OutputFile = "$env:USERPROFILE\Documents\Akamai_EdgeDNS_Report1.xlsx"
$Section = "XXXXXXX"

Write-Host "Collecting EdgeDNS Zones via .edgerc section '$Section'..."

# Get all EdgeDNS zones
$zones = Get-EDNSZone -Section $Section
if (-not $zones) {
    Write-Host "No zones found or authentication failed."
    exit
}

# Helper: convert any value to Excel-safe string
function To-ExcelString($value) {
    if ($null -eq $value) { return "" }
    elseif ($value -is [System.Array]) { return ($value | ForEach-Object { To-ExcelString $_ }) -join "," }
    elseif ($value -is [PSCustomObject]) { return ($value | Out-String).Trim() }
    else { return [string]$value }
}

# Start Excel COM
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$workbook = $excel.Workbooks.Add()

foreach ($zone in $zones) {

    # Determine the zone name safely
    $zoneName = ""
    if ($zone.PSObject.Properties['zone']) { $zoneName = $zone.zone }
    elseif ($zone.PSObject.Properties['name']) { $zoneName = $zone.name }
    elseif ($zone.PSObject.Properties['ZoneName']) { $zoneName = $zone.ZoneName }
    $zoneName = [string]$zoneName

    if (-not $zoneName) { 
        Write-Host "Skipping zone with missing name..." 
        continue 
    }

    Write-Host "Processing zone: $zoneName"

    # Get record sets for the zone
    try {
        $recordResponse = Get-EDNSRecordSet -Zone $zoneName -Section $Section
    } catch {
        Write-Warning ("Failed to get record sets for " + $zoneName + ": " + $_)
        continue
    }

    # Extract recordsets safely
    if ($recordResponse.PSObject.Properties['recordsets']) { 
        $recordSets = $recordResponse.recordsets 
    }
    elseif ($recordResponse -is [System.Array]) { 
        $recordSets = $recordResponse 
    }
    else { 
        $recordSets = @($recordResponse) 
    }

    if ($recordSets.Count -eq 0) {
        Write-Host "No records for $zoneName, skipping sheet."
        continue
    }

    # Create worksheet (Excel sheet names max 31 chars)
    $worksheet = $workbook.Sheets.Add()
    $worksheet.Name = $zoneName.Substring(0,[Math]::Min(31,$zoneName.Length))

    # Write headers
    $headers = @("RecordName","RecordType","TTL","Target")
    for ($c=0; $c -lt $headers.Count; $c++) {
        $worksheet.Cells.Item(1, $c+1).Value2 = $headers[$c]
    }

    # Write each record row-by-row
    $rowIndex = 2
    foreach ($record in $recordSets) {

        $recordName = [string]($record.name ?? $record.RecordName ?? "")
        $recordType = [string]($record.type ?? $record.RecordType ?? "")
        $ttl        = [string]($record.ttl ?? $record.TTL ?? "")
        $rdataList  = $record.rdata ?? $record.Rdata ?? @("")

        foreach ($rdata in $rdataList) {
            $worksheet.Cells.Item($rowIndex,1).Value2 = To-ExcelString $recordName
            $worksheet.Cells.Item($rowIndex,2).Value2 = To-ExcelString $recordType
            $worksheet.Cells.Item($rowIndex,3).Value2 = To-ExcelString $ttl
            $worksheet.Cells.Item($rowIndex,4).Value2 = To-ExcelString $rdata
            $rowIndex++
        }
    }

    # Auto-fit columns
    $worksheet.Columns.AutoFit()
}

# Remove default empty sheets
while ($workbook.Sheets.Count -gt $zones.Count) { $workbook.Sheets.Item(1).Delete() }

# Save workbook
$workbook.SaveAs($OutputFile)
$workbook.Close()
$excel.Quit()

# Release COM objects
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($worksheet) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[GC]::Collect()
[GC]::WaitForPendingFinalizers()

Write-Host "✔ EdgeDNS report completed!"
Write-Host "Saved to: $OutputFile"
