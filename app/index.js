const express = require('express');
const Redis = require('ioredis');
const crypto = require('crypto');
const app = express();
app.use(express.json());

const port = process.env.PORT || 3000;
const redisHost = process.env.REDIS_HOST;
const redis = redisHost ? new Redis(`redis://${redisHost}:6379`) : null;

app.get('/', (req, res) => {
  res.send('OK');
});

app.post('/data', async (req, res) => {
  const payload = req.body;

  const hash = crypto.createHash('sha256').update(JSON.stringify(payload)).digest('hex');

  if (redis) {
    await redis.set(`log:${Date.now()}`, JSON.stringify({ payload, hash }));
  }

  await new Promise(resolve => setTimeout(resolve, 30));

  res.send('Stored');
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
