# Akamai DNS Zone & Record Automation (Terraform Template)

This Terraform module automates the creation and management of **Akamai DNS zones and DNS records** using CSV files. Each CSV file inside the `zones/` directory represents an Akamai DNS zone, and every row inside the CSV defines a DNS record for that zone.

The template fully supports all common DNS record types and includes special handling for multi-value **TXT** records.

---

## Features

### ✔️ Automatically Creates DNS Zones
Each CSV filename becomes a DNS zone. Example:
```
zones/example.com.csv → example.com
```

### ✔️ Bulk Imports DNS Records From CSV
Every CSV file must include the following columns:
```
name,type,ttl,target
```

### ✔️ TXT Multi‑Value Support
TXT targets can contain multiple values separated by a `|` character. Terraform splits and normalizes them automatically.

### ✔️ Safe, Repeatable, and Scalable
Changes to CSV files become updates in Akamai DNS via Terraform.

---

## Directory Structure
```
your-terraform-folder/
│
├─ main.tf              # Core Terraform logic
├─ variables.tf         # Input variable definitions
├─ terraform.tfvars     # User-provided values
├─ zones/               # CSV zone definitions
│    ├─ example.com.csv
│    ├─ example.org.csv
│    └─ ...
└─ README.md
```

---

## CSV Format
Each CSV file must follow this schema:

| Column | Description |
|--------|-------------|
| **name** | Record name (use `@` for the zone apex) |
| **type** | DNS record type (A, AAAA, CNAME, MX, TXT, etc.) |
| **ttl** | TTL value |
| **target** | Record target; TXT multi-value entries separated by `|` |

### Example `zones/example.com.csv`
```
name,type,ttl,target
@,A,300,93.184.216.34
www,CNAME,300,example.com
spf,TXT,300,"v=spf1 include:_spf.example.com | ~all"
```

---

## Required Variables
Define these variables in `variables.tf` and supply values in `terraform.tfvars`.

| Variable | Description |
|----------|-------------|
| **edgerc_path** | Path to your Akamai `.edgerc` file |
| **config_section** | `.edgerc` section to use |
| **contract_id** | Akamai contract ID (e.g., `ctr_1-ABCD`) |
| **group_id** | Akamai group ID for DNS management |

### Example `terraform.tfvars`
```
edgerc_path    = "~/.edgerc"
config_section = "default"
contract_id    = "ctr_1-ABCD"
group_id       = "grp_12345"
```

---

## How the Template Works

### 1. Reads All CSV Files Under `zones/`
Uses `fileset()` to load all `*.csv` files.

### 2. Parses CSV Into Terraform Objects
`csvdecode()` converts rows into structured maps.

### 3. Creates Akamai DNS Zones
Each CSV filename (minus `.csv`) becomes a DNS zone.

### 4. Creates DNS Records
Records are created for every row in the zone's CSV.

### 5. Processes TXT Targets
TXT records with `|` separators are automatically split into lists.

---

## Usage

### Step 1: Initialize Terraform
```
terraform init
```

### Step 2: Place CSV Files in the `zones/` Directory
Each file represents a zone.

### Step 3: Set Variables
Edit `terraform.tfvars` with your Akamai credentials and IDs.

### Step 4: View the Terraform Plan
```
terraform plan
```

### Step 5: Apply Changes
```
terraform apply
```
Terraform will create or update zones and DNS records accordingly.

---

## Best Practices
- Use version control to track changes to your CSV files.
- Do **not** commit Terraform state files; add them to `.gitignore`.
- Keep Akamai authentication credentials secure.

---

