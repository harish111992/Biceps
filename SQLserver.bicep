
//SQL server Creation
resource sqlServer 'Microsoft.Sql/servers@2014-04-01' ={
  name: 'dev-mi-sqlserver01'
  location: resourceGroup().location
//Properties: If you to configure inside the source.. ex see above webapp
// hit space it will show the vaules like administratorLogin...
  properties: {
     administratorLogin: 'devadmin'
      administratorLoginPassword: 'Password@123'
  }
}

//whitelist IP address
resource sqlServerFirewallRules 'Microsoft.Sql/servers/firewallRules@2021-02-01-preview' = {
  parent: sqlServer
  name: 'MyIPAddress'
  properties: {
    startIpAddress: '4.4.4.4'
    endIpAddress: '4.4.4.4'
  }
}

resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2014-04-01' = {
  parent: sqlServer
  name: 'dev-mi-sqldb01'
  location: resourceGroup().location
  properties: {
    collation: 'SQL_Latin_***'
    edition: 'Basic'
    maxSizeBytes: 'maxSizeBytes'
    requestedServiceObjectiveName: 'Basic'
  }
}
