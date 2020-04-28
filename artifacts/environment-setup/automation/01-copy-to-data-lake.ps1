Remove-Module solliance-synapse-automation
Import-Module ".\artifacts\environment-setup\solliance-synapse-automation"

Install-Module -Name Az -AllowClobber -Scope CurrentUser
Install-Module -Name Az.CosmosDB -AllowClobber -Scope CurrentUser

Import-Module Az.CosmosDB

Connect-AzAccount

$subscriptionId = "cccbcfbd-0a1f-45ee-b948-2393697c32b0"
$resourceGroupName = "Synapse-L400-Workshop-175799"
$templatesPath = ".\artifacts\environment-setup\templates"
$workspaceName = "asaworkspace03"
$cosmosDbAccountName = "asacosmosdb03"
$cosmosDbDatabase = "CustomerProfile"
$cosmosDbContainer = "OnlineUserProfile01"
$synapseToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0VHVoTUptRDVNN0RMZHpEMnYyeDNRS1NSWSIsImtpZCI6IkN0VHVoTUptRDVNN0RMZHpEMnYyeDNRS1NSWSJ9.eyJhdWQiOiJodHRwczovL2Rldi5henVyZXN5bmFwc2UubmV0IiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvY2VmY2I4ZTctZWUzMC00OWI4LWIxOTAtMTMzZjFkYWFmZDg1LyIsImlhdCI6MTU4ODAzNTU4MSwibmJmIjoxNTg4MDM1NTgxLCJleHAiOjE1ODgwMzk0ODEsImFjciI6IjEiLCJhaW8iOiJBU1FBMi84UEFBQUFadit0dnFXRU1WUit4VjFFaGpYTjZmcWhPczhKR1B6ZFEyMjFXTmRnV2NJPSIsImFtciI6WyJwd2QiXSwiYXBwaWQiOiJlYzUyZDEzZC0yZTg1LTQxMGUtYTg5YS04Yzc5ZmI2YTMyYWMiLCJhcHBpZGFjciI6IjAiLCJmYW1pbHlfbmFtZSI6IjE3NTc5OSIsImdpdmVuX25hbWUiOiJPRExfVXNlciIsImlwYWRkciI6Ijc5LjExOC4xLjIyMyIsIm5hbWUiOiJPRExfVXNlciAxNzU3OTkiLCJvaWQiOiIzNzJiN2Q1MS0xNmE0LTQ0NjctOTZlOS1jMTY5ZGUwNTQxYTMiLCJwdWlkIjoiMTAwMzIwMDBCNzQ5Qzk4QSIsInNjcCI6IndvcmtzcGFjZWFydGlmYWN0cy5tYW5hZ2VtZW50Iiwic3ViIjoiQnQ5XzFIc2QxWk5fMk1BVnJZUkd1SnZpRHhDc2JyM3V3UG9jRjRWbFFfYyIsInRpZCI6ImNlZmNiOGU3LWVlMzAtNDliOC1iMTkwLTEzM2YxZGFhZmQ4NSIsInVuaXF1ZV9uYW1lIjoib2RsX3VzZXJfMTc1Nzk5QG1zYXp1cmVsYWJzLm9ubWljcm9zb2Z0LmNvbSIsInVwbiI6Im9kbF91c2VyXzE3NTc5OUBtc2F6dXJlbGFicy5vbm1pY3Jvc29mdC5jb20iLCJ1dGkiOiJENWhIdzNwa20wYTNCS2ZGWkdZeEFBIiwidmVyIjoiMS4wIn0.oUNmQztxDuZmgS7oyVVho0bFW1aePx0OB77FMzmsiTQRiMy577zv65dfKjvond0yYzQBX0IzzLURerYOSHr61Whbc_e9NNCvyjNXs2wEFRJkResQmq7VmYsG8BBbt9iA5sEDMIAgbDg6uLtoAkNOx6Ccas_Mc0LlAEJhH0pkLjmQFiCtpILLJbIWW6kXvD6N7lWb1TeGFaUk0UfaSLR6zTG9FUUMYr3E1YsXuIlZqMj3cTrDiA9WwaU5likdI0F0F8K_04JLdRblxMNX0HqS0DBc4YXHhNey1cZzZnt_xtICOegaz6h3TkAgtxryKyzPwEUJ9GqLO5vrn27ldThTRA"
$managementToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0VHVoTUptRDVNN0RMZHpEMnYyeDNRS1NSWSIsImtpZCI6IkN0VHVoTUptRDVNN0RMZHpEMnYyeDNRS1NSWSJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuYXp1cmUuY29tLyIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2NlZmNiOGU3LWVlMzAtNDliOC1iMTkwLTEzM2YxZGFhZmQ4NS8iLCJpYXQiOjE1ODgwMzg2MzMsIm5iZiI6MTU4ODAzODYzMywiZXhwIjoxNTg4MDQyNTMzLCJhY3IiOiIxIiwiYWlvIjoiQVNRQTIvOFBBQUFBMGNHekxKTk9JVE9MdkQ4Y0lPK2cxUEZPR1BTYXBzVmExUUd6alJnTFBBcz0iLCJhbXIiOlsicHdkIl0sImFwcGlkIjoiZWM1MmQxM2QtMmU4NS00MTBlLWE4OWEtOGM3OWZiNmEzMmFjIiwiYXBwaWRhY3IiOiIwIiwiZmFtaWx5X25hbWUiOiIxNzU3OTkiLCJnaXZlbl9uYW1lIjoiT0RMX1VzZXIiLCJpcGFkZHIiOiI3OS4xMTguMS4yMjMiLCJuYW1lIjoiT0RMX1VzZXIgMTc1Nzk5Iiwib2lkIjoiMzcyYjdkNTEtMTZhNC00NDY3LTk2ZTktYzE2OWRlMDU0MWEzIiwicHVpZCI6IjEwMDMyMDAwQjc0OUM5OEEiLCJzY3AiOiJ1c2VyX2ltcGVyc29uYXRpb24iLCJzdWIiOiJaeG5IdHJ2dTlFbVlTWF9HV3J3UnU4U1EwSVJpa2RwOVJSNWhXX2lReDRVIiwidGlkIjoiY2VmY2I4ZTctZWUzMC00OWI4LWIxOTAtMTMzZjFkYWFmZDg1IiwidW5pcXVlX25hbWUiOiJvZGxfdXNlcl8xNzU3OTlAbXNhenVyZWxhYnMub25taWNyb3NvZnQuY29tIiwidXBuIjoib2RsX3VzZXJfMTc1Nzk5QG1zYXp1cmVsYWJzLm9ubWljcm9zb2Z0LmNvbSIsInV0aSI6IlpLOHQ3bFdUSWtDaEZNVDdKZDRkQUEiLCJ2ZXIiOiIxLjAifQ.AU19gWVDtC_4NPwxzHD6ifMktt0rS12WP7f34VHvjFTcsG4al4aRoHR9TJxmR7aMTPx15x6Z_awA4u33cXGcFefAudYsTjWHp8Bg_S1bRnaeluQpMbg0d-guf6BqIiT2-k4T4vbeSBqKgSZsmuKvCrDDjP3FWBkauCKn3MPqKDW38ZFMgNXd3ta8hUjC4LumgpJpcGvOlEp65SL7g_jbmF2YZJVs9vcIMr-MWKklWzNKGm2T-w17PiDJPfGBiFTN_4z1kPgt8JFOogLm7oXcUUjE0bMWbeyJ4K5z4uMDVCmj8lPCNYWPKwFvidUtYh2mzVwPOSK-BvyLSo3wSTsUjQ"


Create-KeyVaultLinkedService -TemplatesPath $templatesPath -WorkspaceName $workspaceName -Name "asakeyvault03" -Token $synapseToken

Create-IntegrationRuntime -TemplatesPath $templatesPath -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -Name "AzureIntegrationRuntime01" -CoreCount 16 -TimeToLive 60 -Token $managementToken

$key = List-StorageAccountKeys -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -Name "asadatalake03" -Token $managementToken
$key




$container = Get-AzCosmosDBSqlContainer `
        -ResourceGroupName $resourceGroupName `
        -AccountName $cosmosDbAccountName -DatabaseName $cosmosDbDatabase `
        -Name $cosmosDbContainer