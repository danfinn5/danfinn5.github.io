const express = require('express');
const cors = require('cors');
const axios = require('axios');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());

app.get('/swagger.json', async (req, res) => {
  try {
    const response = await axios.get('https://app.swaggerhub.com/apis-docs/DANFINN5/EuroClassics/1.0.0');
    res.json(response.data);
  } catch (error) {
    res.status(500).send('Error fetching Swagger JSON');
  }
});

app.listen(PORT, () => {
  console.log(`Proxy server running on port ${PORT}`);
});
