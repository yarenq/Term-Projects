// __tests__/menu.test.js

const request = require('supertest');
const app = require('../server'); // veya app.js ise ona göre

describe('GET /api/menu', () => {
  it('should return 200 and a list of menu items', async () => {
    const res = await request(app).get('/api/menu');
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });
});
