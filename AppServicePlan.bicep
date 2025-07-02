//Windows App service plan
resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'dev-mi-asp01'
  location: resourceGroup().location
  sku: {
    name: 's1'
    capacity: 1
  }
}

//Linux App service plan-> kind and property is manadatory
resource appServicePlan2 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'dev-mi-asp02'
  kind: 'linux'
  properties: {
    reserved: true
  }
  location: resourceGroup().location
  sku: {
    name: 's1'
    capacity: 1
  }
}

//create the webapp based on the app service plan
//dependson: Biceps might run parallely, if the Appservice plan was not execute it may file webapp deploymnet. So need dependOn
resource webApplication 'Microsoft.Web/sites@2021-01-15' = {
  name: 'dev-mi-webapp01'
  location: resourceGroup().location
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', 'dev-mi-asp02')
  }
  dependsOn:[
    appServicePlan
  ]
}

//createa ApplicationInsights
resource appInsightsComponents 'Microsoft.Insights/components@2020-02-02' = {
  name: 'dev-mi-Appinsight01'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

//In webApp setting, to configure Appsettings -> Genetare (Key,vaule)
// parent: on which resource we are configuring.
resource Webappsetiing 'Microsoft.Web/sites/config@2024-11-01' = {
  name: 'web'
  parent: webApplication
  properties: {
    appSettings: [
      {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        //Dynamically pass the Instrumentation Key
        value: appInsightsComponents.properties.InstrumentationKey
      }
    ]
  }
}
