const request = require('supertest');
const app = require('../server');

describe('GET /api/orders/reports/daily', () => {
  it('should return daily report with expected fields', async () => {
    const res = await request(app).get('/api/orders/reports/daily');

    console.log('Günlük rapor cevabı:', res.body);

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('dailyOrders');
    expect(res.body).toHaveProperty('dailyRevenue');
    expect(res.body).toHaveProperty('paymentMethods');
    expect(Array.isArray(res.body.paymentMethods)).toBe(true);
  });
});

