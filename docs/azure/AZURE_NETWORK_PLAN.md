# Azure Network Plan — NAPLANPrep Production
**Version:** 1.0 | **Region:** Australia East | **Date:** 2026-08-16

---

## 1. Resource Group

| Field | Value |
|---|---|
| Resource Group | npp-prod-rg-network |
| Region | australiaeast |
| Owner | Platform Team |
| Lifecycle | Permanent (do not delete without DR runbook) |

---

## 2. Resources to Create

| Resource | Type | Name | Region |
|---|---|---|---|
| Virtual Network | Microsoft.Network/virtualNetworks | npp-prod-vnet | australiaeast |
| Apps Subnet | Subnet | npp-prod-snet-apps | — |
| PE Subnet | Subnet | npp-prod-snet-pe | — |
| NSG (apps) | Microsoft.Network/networkSecurityGroups | npp-prod-nsg-apps | australiaeast |
| NSG (PE) | Microsoft.Network/networkSecurityGroups | npp-prod-nsg-pe | australiaeast |
| PE: PostgreSQL | Microsoft.Network/privateEndpoints | npp-prod-pe-postgres | australiaeast |
| PE: Redis | Microsoft.Network/privateEndpoints | npp-prod-pe-redis | australiaeast |
| PE: Key Vault | Microsoft.Network/privateEndpoints | npp-prod-pe-keyvault | australiaeast |
| PE: Storage | Microsoft.Network/privateEndpoints | npp-prod-pe-storage | australiaeast |
| PE: ACR | Microsoft.Network/privateEndpoints | npp-prod-pe-acr | australiaeast |
| DNS Zone: PG | Microsoft.Network/privateDnsZones | privatelink.postgres.database.azure.com | global |
| DNS Zone: Redis | Microsoft.Network/privateDnsZones | privatelink.redis.cache.windows.net | global |
| DNS Zone: KV | Microsoft.Network/privateDnsZones | privatelink.vaultcore.azure.net | global |
| DNS Zone: Blob | Microsoft.Network/privateDnsZones | privatelink.blob.core.windows.net | global |
| DNS Zone: ACR | Microsoft.Network/privateDnsZones | privatelink.azurecr.io | global |
| Network Watcher | Microsoft.Network/networkWatchers | npp-prod-nw | australiaeast |

---

## 3. IP Address Allocation Table

### VNet / Subnet Allocation
| Subnet | CIDR | Usable IPs | Used | Reserved |
|---|---|---|---|---|
| npp-prod-snet-apps | 10.0.1.0/24 | 251 | ~20 (CA env) | 231 (autoscaling) |
| npp-prod-snet-pe | 10.0.2.0/24 | 251 | 5 | 246 |
| npp-prod-snet-reserved | 10.0.3.0/24 | 251 | 0 | 251 |

### Private Endpoint Static IP Assignments
| Endpoint | IP | Service |
|---|---|---|
| npp-prod-pe-postgres | 10.0.2.4 | PostgreSQL Flexible Server |
| npp-prod-pe-redis | 10.0.2.5 | Azure Managed Redis |
| npp-prod-pe-keyvault | 10.0.2.6 | Key Vault |
| npp-prod-pe-storage | 10.0.2.7 | Storage Account (blob) |
| npp-prod-pe-acr | 10.0.2.8 | Container Registry |

---

## 4. Azure CLI — Network Provisioning (READ-ONLY / SAFE)

```bash
SUBSCRIPTION="<your-subscription-id>"
RG="npp-prod-rg-network"
REGION="australiaeast"

# Create resource group
az group create --name $RG --location $REGION

# Create VNet
az network vnet create \
  --resource-group $RG \
  --name npp-prod-vnet \
  --address-prefix 10.0.0.0/16 \
  --location $REGION

# Create apps subnet (delegated for Container Apps)
az network vnet subnet create \
  --resource-group $RG \
  --vnet-name npp-prod-vnet \
  --name npp-prod-snet-apps \
  --address-prefix 10.0.1.0/24 \
  --delegations Microsoft.App/environments

# Create PE subnet
az network vnet subnet create \
  --resource-group $RG \
  --vnet-name npp-prod-vnet \
  --name npp-prod-snet-pe \
  --address-prefix 10.0.2.0/24 \
  --disable-private-endpoint-network-policies true

# Create NSG for apps subnet
az network nsg create \
  --resource-group $RG \
  --name npp-prod-nsg-apps \
  --location $REGION

# Associate NSG with apps subnet
az network vnet subnet update \
  --resource-group $RG \
  --vnet-name npp-prod-vnet \
  --name npp-prod-snet-apps \
  --network-security-group npp-prod-nsg-apps

# Create private DNS zones
for ZONE in \
  "privatelink.postgres.database.azure.com" \
  "privatelink.redis.cache.windows.net" \
  "privatelink.vaultcore.azure.net" \
  "privatelink.blob.core.windows.net" \
  "privatelink.azurecr.io"; do
  az network private-dns zone create \
    --resource-group $RG \
    --name "$ZONE"
  az network private-dns link vnet create \
    --resource-group $RG \
    --zone-name "$ZONE" \
    --name "link-npp-prod-vnet" \
    --virtual-network npp-prod-vnet \
    --registration-enabled false
done
```

---

## 5. NSG Rule Table

### npp-prod-nsg-apps (Container Apps subnet)

| Priority | Dir | Protocol | Source | Destination | Port(s) | Action |
|---|---|---|---|---|---|---|
| 100 | In | TCP | AzureFrontDoor.Backend | 10.0.1.0/24 | 443 | Allow |
| 110 | In | TCP | AzureLoadBalancer | 10.0.1.0/24 | * | Allow |
| 200 | In | TCP | AzureMonitor | 10.0.1.0/24 | 443 | Allow |
| 4096 | In | Any | * | * | * | Deny |
| 100 | Out | TCP | 10.0.1.0/24 | 10.0.2.4/32 | 5432 | Allow |
| 110 | Out | TCP | 10.0.1.0/24 | 10.0.2.5/32 | 6380 | Allow |
| 120 | Out | TCP | 10.0.1.0/24 | 10.0.2.6/32 | 443 | Allow |
| 130 | Out | TCP | 10.0.1.0/24 | 10.0.2.7/32 | 443 | Allow |
| 140 | Out | TCP | 10.0.1.0/24 | Internet | 443 | Allow |
| 150 | Out | TCP | 10.0.1.0/24 | AzureMonitor | 443 | Allow |
| 160 | Out | TCP | 10.0.1.0/24 | 10.0.2.8/32 | 443 | Allow |
| 4096 | Out | Any | * | * | * | Deny |

### npp-prod-nsg-pe (Private Endpoints subnet)

| Priority | Dir | Protocol | Source | Destination | Port(s) | Action |
|---|---|---|---|---|---|---|
| 100 | In | TCP | 10.0.1.0/24 | 10.0.2.0/24 | 5432,6380,443 | Allow |
| 4096 | In | Any | * | * | * | Deny |
| 100 | Out | TCP | 10.0.2.0/24 | 10.0.1.0/24 | * | Allow |
| 4096 | Out | Any | * | * | * | Deny |

---

## 6. DNS Zone Configuration Checklist

- [ ] Create `privatelink.postgres.database.azure.com` in `npp-prod-rg-network`
- [ ] Link zone to `npp-prod-vnet` (registration disabled)
- [ ] Create `privatelink.redis.cache.windows.net` in `npp-prod-rg-network`
- [ ] Link zone to `npp-prod-vnet`
- [ ] Create `privatelink.vaultcore.azure.net` in `npp-prod-rg-network`
- [ ] Link zone to `npp-prod-vnet`
- [ ] Create `privatelink.blob.core.windows.net` in `npp-prod-rg-network`
- [ ] Link zone to `npp-prod-vnet`
- [ ] Create `privatelink.azurecr.io` in `npp-prod-rg-network`
- [ ] Link zone to `npp-prod-vnet`
- [ ] Verify DNS resolution from Container App: `nslookup npp-prod-pg.postgres.database.azure.com` → must return 10.0.2.4

---

## 7. Network Monitoring

### Network Watcher
```bash
az network watcher configure \
  --resource-group $RG \
  --locations australiaeast \
  --enabled true
```

### NSG Flow Logs
Enable flow logs on both NSGs to Log Analytics for security analysis:
```bash
# Enable flow logs (requires storage account in same region)
az network watcher flow-log create \
  --resource-group $RG \
  --name npp-nsgflow-apps \
  --nsg npp-prod-nsg-apps \
  --storage-account /subscriptions/<id>/resourceGroups/npp-prod-rg-monitoring/providers/Microsoft.Storage/storageAccounts/npplogsa \
  --enabled true \
  --retention 30 \
  --log-version 2 \
  --workspace /subscriptions/<id>/resourceGroups/npp-prod-rg-monitoring/providers/Microsoft.OperationalInsights/workspaces/npp-prod-law
```

### Connection Troubleshoot
```bash
# Test connectivity from Container App to PostgreSQL PE
az network watcher test-connectivity \
  --source-resource <container-app-resource-id> \
  --dest-address 10.0.2.4 \
  --dest-port 5432 \
  --resource-group npp-prod-rg-network
```

---

## 8. Change Control

All network changes must follow this procedure:

1. **Document** the change in the team's change log (Jira/Confluence)
2. **Test** the change in the UAT VNet (`npp-uat-vnet`) first
3. **Peer review** NSG rule changes — at minimum two reviewers
4. **Announce** a maintenance window for subnet or VNet changes (potential brief Container App connectivity interruption)
5. **Rollback plan** documented before applying
6. **Monitor** for 30 minutes post-change via Azure Monitor

**DANGER — Production NSG or subnet changes can interrupt live traffic. Always test in UAT first.**
