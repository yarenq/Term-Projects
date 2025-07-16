const request = require('supertest');
const app = require('../server');

describe('GET /api/orders/kitchen', () => {
  it('should return 200 and list of kitchen orders', async () => {
    const res = await request(app).get('/api/orders/kitchen');

    console.log('Mutfak siparişleri:', res.body);

    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });
});

