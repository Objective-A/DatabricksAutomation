// ################################################################################################################################################################//
//                                                                       Define Parameters                                                                  
// ################################################################################################################################################################//
param storageConfig object
param location string
param containerNames array
param ShouldCreateContainers bool = true
param storageAccountName string
var varstorageAccountName = substring('${storageAccountName}-sa-${uniqueString(resourceGroup().id)}', 0, 24)
param azDatabricksWorkspaceID string
param workspaceName string
param resourceGroupName string
param azKeyVaultName string



// ################################################################################################################################################################//
//                                                                       Define Variables                                                                    
// ################################################################################################################################################################//
// var name = 'demo${environment}adlschd'


// ################################################################################################################################################################//
//                                                             Deploy Storage Account Per Environment                                                                         
// ################################################################################################################################################################//

resource azStorage 'Microsoft.Storage/storageAccounts@2021-08-01' =  {    
  name: storageAccountName
    location: location
    kind: storageConfig.kind
    sku: {
      name: storageConfig.sku_name
    }
    properties: {
      allowBlobPublicAccess: storageConfig.allowBlobPublicAccess
      isHnsEnabled: storageConfig.isHnsEnabled
      accessTier: storageConfig.accessTier
    }

    // Nested Resource Deployment - Containers within Storage Account
    resource blobServices 'blobServices' = {
      name: 'default'
      resource containersCreate 'containers' = [for ContainerName in containerNames: if (ShouldCreateContainers) {
        name: ContainerName
        properties: {
          publicAccess: 'Blob'
        }
      }]
    }
}


  
// ################################################################################################################################################################//
//                                                                       Outputs                                                                    
// ################################################################################################################################################################//
// output storagekey string = listKeys(resourceId('Microsoft.Storage/storageAccounts', name), '2021-08-01').keys[0].value
  output storageaccountname string = azStorage.name
  output azDatabricksWorkspaceID string = azDatabricksWorkspaceID
  output workspaceName string = workspaceName
  output resourceGroupName string = resourceGroupName
  output azKeyVaultName string = azKeyVaultName




  

