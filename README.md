# bicep-deploy-example-db-auth
This is a webapp with a db and auth, to demonstrate a slightly more complicated deployment.

These are hosted on an Azure free tier, so give them a minute to load.
 - production: [https://app-bicep-deploy-example-db-auth-production-ffxmau6sofxjw.azurewebsites.net/](https://app-bicep-deploy-example-db-auth-production-ffxmau6sofxjw.azurewebsites.net/)
 - staging: [https://app-bicep-deploy-example-db-auth-staging-jatmwt6ikacyc.azurewebsites.net/](https://app-bicep-deploy-example-db-auth-staging-jatmwt6ikacyc.azurewebsites.net/)

## entra id auth for db
Create entra group, e.g. sql-administrators, and put yourself in it. Provide the group display name and id to the bicep params. I've done it via repo env vars. These are identifiers, not secrets.

## prepare db
Once deployed, connect to the db and run these queries to allow the app service to talk to the db. The square brackets are needed to avoid parsing issues.
 ```sql                                                                                                                                                                   
   CREATE USER [app-service-name]                                                                                                   
   FROM EXTERNAL PROVIDER;                                                                                                                                                
 ```                                                                                                                                                                      
                                                                                                                                                                          
 Then:                                                                                                                                                                    
                                                                                                                                                                          
 ```sql                                                                                                                                                                   
   ALTER ROLE db_datareader                                                                                                                                               
   ADD MEMBER [app-service-name];                                                                                                   
                                                                                                                                                                          
   ALTER ROLE db_datawriter                                                                                                                                               
   ADD MEMBER [app-service-name];                                                                                                   
 ```
