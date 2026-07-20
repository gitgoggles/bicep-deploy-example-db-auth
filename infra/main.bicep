targetScope = 'subscription'

param workloadName string = 'bicep-deploy-example-db-auth'
param resourceGroupName string = 'rg-${workloadName}-${environmentName}'
param location string

@allowed([
  'production'
  'staging'
])
param environmentName string
param appServicePlanSku string
param sqlEntraAdminLogin string
param sqlEntraAdminObjectId string

var tags = {
  environment: environmentName
  workload: workloadName
  managedBy: 'bicep'
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

module database './database.bicep' = {
  name: 'database-${environmentName}'
  scope: resourceGroup
  params: {
    entraAdminLogin: sqlEntraAdminLogin
    entraAdminObjectId: sqlEntraAdminObjectId
    environmentName: environmentName
    location: location
    tags: tags
    workloadName: workloadName
  }
}

module application './application.bicep' = {
  name: 'application-${environmentName}'
  scope: resourceGroup
  params: {
    appServicePlanSku: appServicePlanSku
    environmentName: environmentName
    location: location
    sqlDatabaseName: database.outputs.databaseName
    sqlServerFqdn: database.outputs.serverFqdn
    tags: tags
    workloadName: workloadName
  }
}

output resourceGroupName string = resourceGroup.name
output appServicePlanName string = application.outputs.appServicePlanName
output webAppName string = application.outputs.webAppName
output webAppUrl string = application.outputs.webAppUrl
output webAppPrincipalId string = application.outputs.webAppPrincipalId
output sqlServerName string = database.outputs.serverName
output sqlServerPrincipalId string = database.outputs.serverPrincipalId
output sqlDatabaseName string = database.outputs.databaseName
