# EdgeDNS Zone & Record Export Script (PowerShell 7)

This script exports **Akamai EdgeDNS zones and DNS record sets** into a single **Excel XLSX** file. Each EdgeDNS zone is written to its own worksheet, and records are written **row‑by‑row** to avoid PowerShell 7 COM write limitations.

---

## 🚀 Features
- Exports **all EdgeDNS zones** using your chosen `.edgerc` section
- Creates **one Excel worksheet per zone**
- Writes all DNS recordsets (A, AAAA, CNAME, TXT, etc.)
- Performs **safe row-by-row Excel writes** (PowerShell 7 compatible)
- Includes **Excel-safe string conversion** to avoid formatting issues

---

## 📄 Requirements
- Windows (Excel COM is required)
- **Microsoft Excel** installed
- **PowerShell 7+**
- Akamai EdgeDNS module (`Get-EDNSZone`, `Get-EDNSRecordSet`)
- A configured **~/.edgerc** file

---

## 🛠 Configuration
Update these values before running:

```powershell
$OutputFile = "$env:USERPROFILE\Documents\Akamai_EdgeDNS_Report1.xlsx"
$Section = "XXXXXXX"  # Replace with your .edgerc section
```

---

## ▶ Running the Script
Run the script in PowerShell 7:
```powershell
./Export-EdgeDNS-Zones.ps1
```

You will see console output such as:
```
Collecting EdgeDNS Zones via .edgerc section 'default'...
Processing zone: example.com
Processing zone: sub.example.com
✔ EdgeDNS report completed!
Saved to: C:\Users\You\Documents\Akamai_EdgeDNS_Report1.xlsx
```

---

## 📘 Output File Structure
The generated Excel file will contain:
- **One worksheet per zone**
- Sheet names automatically trimmed to Excel's 31-character limit
- Columns:
  - `RecordName`
  - `RecordType`
  - `TTL`
  - `Target` (multiple rdata entries produce multiple rows)

Example:
```
| RecordName | RecordType | TTL | Target          |
|------------|------------|-----|-----------------|
| www        | A          | 300 | 93.184.216.34   |
| @          | NS         | 86400 | ns1.akam.net   |
```

---

## ❗ Notes & Behavior
- Zones without recordsets are skipped.
- Records containing arrays or objects are safely converted to strings.
- COM objects are properly released to avoid Excel.exe lingering.
- Default blank sheets are automatically removed.

---

## 🧹 Cleanup & COM Handling
The script performs full Excel COM cleanup:
- Releases worksheet, workbook, and Excel COM objects
- Forces garbage collection

This prevents background Excel processes from staying open.

---

## ✔ Completion Message
At the end of execution, you will see:
```
✔ EdgeDNS report completed!
Saved to: <your output file path>
```

