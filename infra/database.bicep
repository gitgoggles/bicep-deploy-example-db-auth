targetScope = 'resourceGroup'

param location string
param workloadName string
param environmentName string
param entraAdminLogin string
param entraAdminObjectId string
param tags object = {}

var suffix = uniqueString(subscription().subscriptionId, workloadName, environmentName)
var sqlServerName = 'sql-${workloadName}-${environmentName}-${suffix}'
var sqlDatabaseName = 'sqldb-${workloadName}'

resource sqlServer 'Microsoft.Sql/servers@2023-08-01' = {
  name: sqlServerName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'Group'
      login: entraAdminLogin
      sid: entraAdminObjectId
      tenantId: tenant().tenantId
      azureADOnlyAuthentication: true
    }
  }
}

// Allows the web app to reach SQL over its Azure outbound addresses. This does
// not grant database access; authentication still uses its managed identity.
resource allowAzureServices 'Microsoft.Sql/servers/firewallRules@2023-08-01' = {
  parent: sqlServer
  name: 'AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-08-01' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  tags: tags
  sku: {
    name: 'GP_S_Gen5'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 2
  }
  properties: {
    autoPauseDelay: 60
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    freeLimitExhaustionBehavior: 'AutoPause'
    maxSizeBytes: 34359738368
    minCapacity: json('0.5')
    useFreeLimit: true
  }
}

output databaseName string = sqlDatabase.name
output serverFqdn string = sqlServer.properties.fullyQualifiedDomainName
output serverName string = sqlServer.name
output serverPrincipalId string = sqlServer.identity.principalId
