---
title: "Authentication"
weight: 3
description: "Detailed explanation of OAuth2 authentication for the API."
---

This API uses **OAuth2 Authorization Code Flow** for secure access to API endpoints. OAuth2 is an industry-standard protocol for authorization, which provides temporary tokens to allow clients to access resources securely.

## OAuth2 Flow

1. **Authorization Request**  
   Direct the user to the following URL to log in and grant access to their account:
   ```plaintext
   GET http://example.com/oauth/auth
   ```

2. **Receive Authorization Code**  
   After login, the user will be redirected with an authorization code, which needs to be exchanged for an access token.

3. **Exchange Authorization Code for Access Token**  
   Use the following POST request to obtain an access token:
   ```plaintext
   POST http://example.com/oauth/token
   ```

4. **Using Access Tokens**  
   Include the access token in the `Authorization` header of each request as a Bearer token:
   ```plaintext
   Authorization: Bearer <your_access_token>
   ```

## Token Expiry and Refreshing Tokens

Access tokens typically expire after a short time. You can refresh tokens without re-authenticating the user by sending a request to the token endpoint with the refresh token:
```plaintext
POST http://example.com/oauth/token
{
    "client_id": "<client_id>",
    "client_secret": "<client_secret>",
    "grant_type": "refresh_token",
    "refresh_token": "<refresh_token>"
}
```

## Scopes

The following scopes are available:
- `read`: Allows read-only access.
- `write`: Allows modification of resources.
