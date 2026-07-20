using './main.bicep'

param location = 'westcentralus'
param environmentName = 'production'
param appServicePlanSku = 'F1'
param sqlEntraAdminLogin string = readEnvironmentVariable('SQL_ENTRA_ADMIN_LOGIN')
param sqlEntraAdminObjectId string = readEnvironmentVariable('SQL_ENTRA_ADMIN_OBJECT_ID')
