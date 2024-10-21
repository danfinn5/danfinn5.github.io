---
title: Getting Started
type: 
weight: 2
description: "Getting Started guide for the Euro Classics API"
---

## Getting Started with the Classic European Cars API

Welcome to the Classic European Cars API! This API allows you to retrieve and manage data about classic European cars and collections. Whether you want to build an app that showcases classic cars or manage your own collection, this guide will help you get started.

## Prerequisites

Before you begin, you need to have:
- A basic understanding of RESTful APIs and OAuth2.
- An API client such as [Postman](https://www.postman.com/) or [curl](https://curl.se/) installed.
- OAuth2 credentials (client ID and client secret) to access the API.

## Quick Start

Follow these steps to get started with the Classic European Cars API quickly:

### Step 1: Obtain OAuth2 Credentials

First, ensure you have your OAuth2 credentials (client ID and client secret).

### Step 2: Authenticate

Follow the authentication steps provided in this guide to authenticate your API client.

### Step 3: Make Your First Request

Once authenticated, use the `/cars` endpoint to retrieve a list of classic European cars.

## Authentication

This API uses **OAuth2 Authorization Code Flow** for secure access. You will need to obtain an authorization code to interact with the API. Follow these steps:

1. **Obtain Authorization URL**  
   Direct the user to the following URL to log in and grant access to their account:

   ```plaintext
   http://example.com/oauth/auth
   ```

2. **Receive Authorization Code**  
   After a successful login, the user will be redirected to your redirect URI with an authorization code.

3. **Exchange Authorization Code for Access Token**  
   Make a `POST` request to the token URL to exchange the authorization code for an access token:

   ```plaintext
   POST http://example.com/oauth/token
   ```

   Request Parameters:
   - `client_id`: Your client ID
   - `client_secret`: Your client secret
   - `code`: The authorization code you received
   - `grant_type`: "authorization_code"

Once you have the access token, include it in the `Authorization` header in each API request.

## Base URL

All API requests should be made to the following base URL:

```plaintext
https://virtserver.swaggerhub.com/DANFINN5/EuroClassics/1.0.0
```

## Endpoints Overview

### 1. Retrieve a List of Cars

**GET** `/cars`

This endpoint retrieves a list of classic European cars. You can filter the results by various parameters such as make, model, year, or country.

#### Example Request

```plaintext
GET /cars?make=BMW&year=1980
```

#### Response

```json
[
  {
    "id": "car123",
    "make": "BMW",
    "model": "E30",
    "year": 1980,
    "description": "A classic BMW E30.",
    "history": "Owned by a famous collector."
  }
]
```

### 2. Retrieve a Specific Car

**GET** `/cars/{id}`

Use this endpoint to fetch detailed information about a specific car by its unique ID.

#### Example Request

```plaintext
GET /cars/car123
```

#### Response

```json
{
  "id": "car123",
  "make": "BMW",
  "model": "E30",
  "year": 1980,
  "description": "A classic BMW E30.",
  "history": "Owned by a famous collector."
}
```

### 3. Manage Car Collections

You can create, update, delete, or retrieve car collections through the `/collections` endpoint.

#### Retrieve All Collections

**GET** `/collections`

This retrieves all car collections created by the user.

#### Create a New Collection

**POST** `/collections`

To create a new collection, send a request with the collection details in the body.

#### Example Request

```json
{
  "name": "My Favorite Classics",
  "cars": ["car123", "car124"],
  "description": "A collection of my favorite European cars."
}
```

#### Response

```json
{
  "id": "collection123",
  "name": "My Favorite Classics",
  "description": "A collection of my favorite European cars."
}
```

#### Update a Collection

**PUT** `/collections/{id}`

You can update an existing collection by its unique ID.

#### Delete a Collection

**DELETE** `/collections/{id}`

This deletes a collection by its unique ID.

## Error Handling

The API returns standard HTTP error codes to indicate the success or failure of an API request. Common status codes include:

- `200 OK`: The request was successful.
- `201 Created`: The resource was successfully created.
- `400 Bad Request`: The request could not be understood or was missing required parameters.
- `401 Unauthorized`: Authentication failed or the user doesn’t have permission to access the requested resource.
- `404 Not Found`: The requested resource could not be found.
- `500 Internal Server Error`: An error occurred on the server.

## Conclusion

This guide provides a basic overview to help you get started with the Classic European Cars API. Explore the endpoints, authenticate using OAuth2, and manage your car collections.

For detailed documentation of all available endpoints and parameters, refer to the [API Reference](https://virtserver.swaggerhub.com/DANFINN5/EuroClassics/1.0.0).
