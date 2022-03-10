param amount int
param contactEmail string
param startDate string = utcNow('MM/01/yyyy')
param endDate string = dateTimeAdd(startDate, 'P2Y')

resource budget 'Microsoft.Consumption/budgets@2021-10-01' = {
  name: '${resourceGroup().name}-budget'
  properties: {
    amount: amount
    category: 'Cost'
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: startDate
      endDate: endDate
    }
    filter: {
      dimensions: {
        name: 'ResourceGroupName'
        operator: 'In'
        values: [
          resourceGroup().name
        ]
      }
    }
    notifications: {
      '${resourceGroup().name}-budget-not': {
        enabled: true
        operator: 'GreaterThan'
        threshold: 80
        contactEmails: [
          contactEmail
        ]
      }
    }
  }
}
