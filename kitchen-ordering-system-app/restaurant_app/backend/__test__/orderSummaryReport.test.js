const request = require('supertest');
const app = require('../server');

describe('GET /api/orders/reports/summary', () => {
  it('should return summary report with expected fields', async () => {
    const res = await request(app).get('/api/orders/reports/summary');

    console.log('Rapor özeti cevabı:', res.body);

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('totalOrders');
    expect(res.body).toHaveProperty('paidOrders');
    expect(res.body).toHaveProperty('pendingOrders');
    expect(res.body).toHaveProperty('totalRevenue');
    expect(res.body).toHaveProperty('popularItems');
    expect(Array.isArray(res.body.popularItems)).toBe(true);
  });
});
