const express = require('express');
const app = express();
const port = parseInt(process.env.PORT || 3000);

function getEnvObj() {
  const envObj = {};

  Object.keys(process.env).forEach((key) => {
    if (key.startsWith('KUBERNETES')) {
      envObj[key] = process.env[key];
    }
  });

  return envObj;
}

app.get('/', (req, res) => {
  res.json(getEnvObj());
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
