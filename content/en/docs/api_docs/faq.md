---
title: "FAQ"
weight: 7
description: "Frequently asked questions about the Classic European Cars API."
---

This section answers some of the most frequently asked questions about the Classic European Cars API.

## How do I get an OAuth2 token?

To obtain an OAuth2 token, follow the steps in the [Authentication]({{< relref "auth.md" >}}) section. You’ll need your client ID, client secret, and authorization code to request a token.

## What do I do if I encounter a 401 Unauthorized error?

Ensure that you are sending the access token in the `Authorization` header with the correct format:
```plaintext
Authorization: Bearer <your_access_token>
```

## Can I update a car collection after it’s created?

Yes, you can update a car collection by sending a `PUT` request to the `/collections/{id}` endpoint.

## What data formats are supported?

All API requests and responses use JSON format.