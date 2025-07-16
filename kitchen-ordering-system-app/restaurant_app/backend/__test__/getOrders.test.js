const request = require('supertest');
const app = require('../server');

describe('GET /api/orders', () => {
  it('should return 200 and a list of orders', async () => {
    const res = await request(app).get('/api/orders');

    console.log('Siparişler:', res.body);

    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });
});

