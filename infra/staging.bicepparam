using './main.bicep'

param location = 'westcentralus'
param environmentName = 'staging'
param appServicePlanSku = 'B1'
param sqlEntraAdminLogin = readEnvironmentVariable('SQL_ENTRA_ADMIN_LOGIN')
param sqlEntraAdminObjectId = readEnvironmentVariable('SQL_ENTRA_ADMIN_OBJECT_ID')
