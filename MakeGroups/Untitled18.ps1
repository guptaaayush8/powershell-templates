$uri = 'https://vssps.dev.azure.com/LyondellBasell/_apis/Graph/Groups?scopeDescriptor=scp.ZWM1YzM1ZjAtOWQxOC00ZWUzLTgxYjktOWVjZDYxNDI1Nzc2&api-version=6.0-preview.1'




$JsonBody = '{
  "displayName": "Test Group",
  "description": "Group at project level created via client library"
}'

$p = Invoke-RestMethod -Method Post -Uri $uri -Headers $Auth -Body $JsonBody -ContentType application/json

$uri = 'https://dev.azure.com/LyondellBasell/_apis/IdentityPicker/Identities/me/mru/common?operationScopes=ims&properties=DisplayName&properties=IsMru&properties=ScopeName&properties=SamAccountName&properties=Active&properties=SubjectDescriptor&properties=Department&properties=JobTitle&properties=Mail&properties=MailNickname&properties=PhysicalDeliveryOfficeName&properties=SignInAddress&properties=Surname&properties=Guest&properties=TelephoneNumber&properties=Manager&properties=Description&api-version=6.0-preview.1'

$p = Invoke-RestMethod -Method Get -Uri $uri -Headers $Auth 