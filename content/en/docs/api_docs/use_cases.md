---
title: "Use Cases"
weight: 6
description: "Examples of how to use the API for different workflows."
---

Here are some common use cases for the Classic European Cars API.

## Create a Collection

This example shows how to create a car collection and then add cars to it.

1. **Create a new collection**  
   Use the following POST request:
   ```json
   POST /collections
   {
      "name": "My Classic Cars",
      "description": "A collection of classic European cars.",
      "cars": []
   }
   ```

2. **Add a car to the collection**  
   Once the collection is created, add a car to the collection using the car ID:
   ```json
   PUT /collections/{collection_id}/cars
   {
      "car_id": "car123"
   }
   ```

3. **Retrieve the collection**  
   Retrieve details of the collection:
   ```plaintext
   GET /collections/{collection_id}
   ```

## Retrieve Specific Cars

You can filter cars by make, model, year, or country using query parameters:
```plaintext
GET /cars?make=BMW&year=1980
```