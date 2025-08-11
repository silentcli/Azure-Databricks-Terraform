# DataOps Infrastructure with Terraform

This Terraform configuration creates a complete, production-ready DataOps infrastructure on Azure using modular design for maximum reusability and maintainability.

## 🏗️ Architecture

The infrastructure includes:
- **Resource Group**: Container for all resources with proper tagging
- **Storage Account**: Azure Data Lake Storage Gen2 with hierarchical namespace
- **Storage Containers**: Multi-tier containers (source, processed, archive)
- **Azure Databricks**: Premium workspace with cost-optimized networking
- **Automated File Upload**: CSV data ingestion with integrity checks
- **Managed Resource Group Cleanup**: Automatic cleanup of Databricks orphaned resources

## 📁 Project Structure

```
Infra/
├── main.tf                    # Main infrastructure orchestration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output definitions
├── demo.tfvars               # Demo environment configuration
├── prod.tfvars               # Production environment configuration
├── upload-files.sh           # Automated file upload script
├── cleanup-databricks-rg.sh  # Manual cleanup utility
├── modules/
│   ├── resource_group/       # Resource group module
│   ├── storage_account/      # Data Lake storage module
│   └── databricks/          # Databricks workspace module
└── ../demo_data/
    └── Sales.csv            # Sample dataset for ingestion
```

## 🧩 Modules

### 1. Resource Group Module (`modules/resource_group/`)
- Creates Azure Resource Group with proper naming conventions
- Supports consistent tagging across environments
- Location-agnostic for multi-region deployments

### 2. Storage Account Module (`modules/storage_account/`)
- **Data Lake Gen2**: Hierarchical namespace enabled
- **Multi-tier Storage**: Source, processed, archive containers
- **Configurable Replication**: LRS for demo, GRS for production
- **Security**: Private access by default
- **Cost-optimized**: Standard tier with lifecycle policies

### 3. Databricks Module (`modules/databricks/`)
- **Premium Workspace**: Advanced analytics capabilities
- **Network Optimization**: Public IP configurable for cost savings
- **Security Ready**: Prepared for private networking in production
- **SKU Flexibility**: Standard/Premium/Trial options

## 🚀 Features

### ✅ Automated Data Ingestion
- **CSV Upload**: Automated upload of Sales.csv to source container
- **Integrity Checks**: MD5 hash verification for data consistency
- **Idempotent**: Only uploads when file changes

### ✅ Cost Optimization
- **Public IP Option**: Avoid NAT gateway costs in demo environments
- **Configurable SKUs**: Match resources to environment needs
- **Storage Tiers**: Optimized replication for each environment

### ✅ Automated Cleanup
- **Managed RG Cleanup**: Automatic deletion of Databricks managed resource groups
- **Billing Protection**: Prevents orphaned resources and unexpected costs
- **Error Handling**: Robust cleanup with comprehensive logging

### ✅ Environment Management
- **Multi-Environment**: Separate configs for demo and production
- **Consistent Tagging**: Environment tracking across all resources
- **Scalable Design**: Easy to add new environments

## 🛠️ Usage

### Prerequisites
1. **Azure CLI**: Installed and authenticated
   ```bash
   az login
   az account set --subscription "your-subscription-id"
   ```
2. **Terraform**: Version >= 1.0
3. **Permissions**: Contributor role in target subscription

### 🚀 Quick Start

#### 1. Initialize Terraform
```bash
cd Infra/
terraform init
```

#### 2. Deploy Demo Environment
```bash
# Plan the deployment
terraform plan -var-file="demo.tfvars"

# Apply the configuration
terraform apply -var-file="demo.tfvars"
```

#### 3. Deploy Production Environment
```bash
# Plan the deployment
terraform plan -var-file="prod.tfvars"

# Apply the configuration
terraform apply -var-file="prod.tfvars"
```

#### 4. Clean Deployment
```bash
# Destroy all resources (including managed RGs)
terraform destroy -var-file="demo.tfvars"
```

### 🔧 Advanced Usage

#### Manual Cleanup of Orphaned Resources
If you have existing orphaned Databricks managed resource groups:
```bash
# Make cleanup script executable
chmod +x cleanup-databricks-rg.sh

# Run manual cleanup
./cleanup-databricks-rg.sh
```

#### Importing Existing Managed Resource Groups
```bash
# Find existing managed RGs
az group list --query "[?starts_with(name, 'databricks-rg-')].name" --output table

# Import specific RG (replace with actual name)
terraform import azurerm_resource_group.managed_rg \
  /subscriptions/SUBSCRIPTION_ID/resourceGroups/databricks-rg-WORKSPACE-HASH
```

## ⚙️ Configuration

### Environment Variables Files

#### Demo Environment (`example.tfvars`)
```hcl
# Optimized for cost and testing
environment                  = "Demo"
location                    = "East US 2"
storage_replication_type    = "LRS"          # Local redundancy
databricks_no_public_ip     = false          # Public clusters (cost savings)
databricks_sku             = "premium"       # Full feature set
storage_containers         = ["source", "processed", "archive"]
```

### Key Configuration Options

#### Storage Account Naming
Storage account names must be globally unique (3-24 characters, lowercase/numbers only):
```hcl
storage_account_name = "stdataopsdemoeasus2025"  # Demo
storage_account_name = "stdataopsprodeastus2001" # Production
```

#### Cost vs Security Trade-offs
```hcl
# Cost-optimized (Demo)
databricks_no_public_ip = false     # Avoids NAT gateway costs
storage_replication_type = "LRS"    # Lower storage costs

# Security-optimized (Production)
databricks_no_public_ip = true      # Private networking
storage_replication_type = "GRS"    # Disaster recovery
```

#### Adding Storage Containers
```hcl
storage_containers = [
  "source",      # Raw data ingestion
  "processed",   # Transformed data
  "archive",     # Long-term storage
  "staging",     # Temporary processing
  "backup"       # Backup copies
]
```

## 💰 Cost Management

### Demo Environment Optimizations
- **Public IP Clusters**: Saves ~$100-200/month by avoiding NAT gateway
- **LRS Storage**: Reduces storage costs by 50% vs GRS
- **Standard Storage Tier**: Cost-effective for development workloads

### Production Environment Features
- **Private Clusters**: Enhanced security with dedicated networking
- **GRS Storage**: Geo-redundant for disaster recovery
- **Premium Features**: Advanced analytics and security capabilities

### Cost Monitoring
```bash
# Check current spending
az consumption usage list --top 10

# Set up billing alerts
az monitor action-group create --name "billing-alerts"
```

## 🔒 Security Features

### Data Protection
- **Private Storage Containers**: No public access by default
- **Encryption**: At-rest and in-transit encryption enabled
- **Access Keys**: Managed through Azure Key Vault integration

### Network Security
- **Private Endpoints**: Available for production deployments
- **VNet Integration**: Databricks workspace isolation
- **NSG Rules**: Configurable network security groups

### Identity & Access Management
- **RBAC Integration**: Role-based access control
- **Managed Identity**: Service principal authentication
- **Azure AD Integration**: Enterprise authentication ready

## 📊 Data Pipeline

### Automated Data Flow
1. **Ingestion**: CSV files uploaded to `source` container
2. **Processing**: Databricks notebooks process raw data
3. **Storage**: Transformed data stored in `processed` container
4. **Archive**: Historical data moved to `archive` container

### File Upload Automation
The infrastructure includes automated CSV upload:
```bash
# Upload triggered automatically during terraform apply
# File: ../demo_data/Sales.csv → source container
# Verification: MD5 hash checking for integrity
```

### Data Access URLs
After deployment, access your data at:
```
Blob Storage: https://{storage_account_name}.blob.core.windows.net/
Data Lake: https://{storage_account_name}.dfs.core.windows.net/
Databricks: https://adb-{workspace_id}.{region}.azuredatabricks.net/
```

## 📤 Outputs

After successful deployment, you'll receive:

#### Resource Information
#### Access Endpoints
#### Data Assets


## 🧹 Cleanup & Troubleshooting

### Automatic Cleanup Features
The infrastructure includes automatic cleanup mechanisms:

1. **Managed Resource Group Cleanup**: Automatically deletes Databricks managed resource groups during `terraform destroy`
2. **Error Handling**: Comprehensive error checking and logging
3. **Billing Protection**: Prevents orphaned resources that continue billing

### Common Issues & Solutions

#### Issue: Storage Account Name Already Exists
```bash
# Solution: Update storage account name in tfvars
storage_account_name = "storagename$(date +%Y%m%d)"
```

#### Issue: Databricks Managed RG Not Cleaned
```bash
# Solution: Run manual cleanup script
./cleanup-databricks-rg.sh

# Or import and destroy manually
terraform import azurerm_resource_group.managed_rg /subscriptions/.../resourceGroups/databricks-rg-...
terraform destroy -target="azurerm_resource_group.managed_rg"
```

#### Issue: File Upload Fails
```bash
# Check Azure CLI authentication
az account show

# Verify file exists
ls -la ../demo_data/Sales.csv

# Run upload script manually
./upload-files.sh
```

### Debugging Commands
```bash
# Validate configuration
terraform validate

# Check plan without applying
terraform plan -var-file="demo.tfvars"

# Show current state
terraform show

# List managed resource groups
az group list --query "[?starts_with(name, 'databricks-rg-')]"
```

## 🔄 Next Steps

### Planned Enhancements
- [ ] **App Registration Module**: Service principal automation
- [ ] **Key Vault Integration**: Secure credential storage
- [ ] **RBAC Module**: Role-based access control
- [ ] **Monitoring Module**: Azure Monitor and alerting
- [ ] **Backup Module**: Automated backup policies

### Getting Started with Data
1. **Access Databricks**: Use the workspace URL from outputs
2. **Connect to Storage**: Use storage endpoints for data access  
3. **Upload Data**: Files automatically appear in source container
4. **Start Processing**: Create notebooks in Databricks workspace

---

## 📞 Support

For issues or questions:
1. Check the troubleshooting section above
2. Validate your configuration with `terraform validate`
3. Review Azure CLI authentication with `az account show`
4. Check Terraform state with `terraform show`

**Happy DataOps-ing!** 🚀
