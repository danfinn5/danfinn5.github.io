---
title: "Error Handling"
weight: 5
description: "Common errors and how to resolve them."
---

## Error Handling

This section provides guidance on common errors you may encounter when using the API and how to resolve them.

## Common HTTP Status Codes

- **400 Bad Request**  
  The request was malformed or missing required parameters. Double-check your input data and parameters.

- **401 Unauthorized**  
  The authentication token is missing or invalid. Make sure your OAuth2 token is present in the Authorization header.

- **403 Forbidden**  
  You do not have the necessary permissions to access the resource. Verify your token scopes.

- **404 Not Found**  
  The requested resource does not exist. Ensure the endpoint and resource ID are correct.

- **500 Internal Server Error**  
  An error occurred on the server side. Retry the request after some time or contact support if the issue persists.

## Troubleshooting Tips

- **Invalid Tokens**  
  Make sure your access token is valid and hasn’t expired. If the token has expired, use the refresh token to get a new one.

- **Missing Parameters**  
  Review the API documentation to ensure that you are sending all required parameters in your request.

- **Rate Limiting**  
  If you hit rate limits, the API will return a 429 Too Many Requests error. Wait for a few seconds and retry the request.